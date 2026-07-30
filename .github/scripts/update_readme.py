#!/usr/bin/env python3
"""Regeneruje AUTO sekcie v README.md.

Sekcie sú ohraničené markermi <!-- AUTO:X --> ... <!-- /AUTO:X -->.
Spúšťa GitHub Action pri každom pushi; dá sa spustiť aj lokálne:
    python3 .github/scripts/update_readme.py
"""
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
README = ROOT / "README.md"

IGNORE = {".git", ".github", "node_modules", "__pycache__"}


def git(*args: str) -> str:
    return subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True).stdout.strip()


def repo_name() -> str:
    """Názov repa z git remote — prežije premenovanie repozitára."""
    url = git("remote", "get-url", "origin")
    if url:
        return url.rstrip("/").removesuffix(".git").rsplit("/", 1)[-1]
    return ROOT.name


def build_tree() -> str:
    lines = ["```text", f"{repo_name()}/"]

    def walk(d: Path, prefix: str = "") -> None:
        entries = sorted(
            [p for p in d.iterdir() if p.name not in IGNORE and not p.name.startswith(".")],
            key=lambda p: (p.is_file(), p.name.lower()),
        )
        for i, p in enumerate(entries):
            connector = "└── " if i == len(entries) - 1 else "├── "
            lines.append(f"{prefix}{connector}{p.name}{'/' if p.is_dir() else ''}")
            if p.is_dir():
                walk(p, prefix + ("    " if i == len(entries) - 1 else "│   "))

    walk(ROOT)
    lines.append("```")
    return "\n".join(lines)


def build_progress() -> str:
    """Spočíta checkboxy vo všetkých .md v planning/ a vykreslí progress bary."""
    rows = []
    for f in sorted((ROOT / "planning").glob("*.md")):
        text = f.read_text(encoding="utf-8")
        done = len(re.findall(r"^\s*[-*] \[[xX]\]", text, re.M))
        total = done + len(re.findall(r"^\s*[-*] \[ \]", text, re.M))
        if total == 0:
            continue
        pct = round(100 * done / total)
        filled = round(pct / 5)
        bar = "█" * filled + "░" * (20 - filled)
        rows.append(f"| [`{f.name}`](planning/{f.name}) | `{bar}` | {done}/{total} ({pct} %) |")
    if not rows:
        return "*Žiadne úlohy (checkboxy) v `planning/` zatiaľ nie sú.*"
    header = "🤖 | Súbor | Progress | Hotovo |\n|---|---|---|\n".replace("🤖 ", "")
    return "| Súbor | Progress | Hotovo |\n|---|---|---|\n" + "\n".join(rows)


def build_activity() -> str:
    log = git("log", "-8", "--pretty=format:| `%h` | %ad | %an | %s |", "--date=format:%Y-%m-%d")
    if not log:
        return "*Zatiaľ žiadne commity.*"
    total = git("rev-list", "--count", "HEAD")
    files = git("ls-files").count("\n") + 1
    return (
        f"**{total} commitov** · **{files} súborov**\n\n"
        "| Commit | Dátum | Autor | Správa |\n|---|---|---|---|\n" + log
    )


def replace(text: str, key: str, content: str) -> str:
    pattern = re.compile(rf"(<!-- AUTO:{key} -->).*?(<!-- /AUTO:{key} -->)", re.S)
    return pattern.sub(lambda m: f"{m.group(1)}\n{content}\n{m.group(2)}", text)


def main() -> None:
    text = README.read_text(encoding="utf-8")
    text = replace(text, "TREE", build_tree())
    text = replace(text, "PROGRESS", build_progress())
    text = replace(text, "ACTIVITY", build_activity())
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    text = re.sub(
        r"(<!-- AUTO:UPDATED -->).*?(<!-- /AUTO:UPDATED -->)",
        rf"\g<1>{now}\g<2>",
        text,
        flags=re.S,
    )
    README.write_text(text, encoding="utf-8")
    print("README.md aktualizované.")


if __name__ == "__main__":
    main()
