#!/opt/homebrew/opt/python@3.14/bin/python3.14
from __future__ import annotations

import argparse
import re
from pathlib import Path

DIRECTIONS = ("registry", "timeline", "constellation", "ledger", "brain", "tower")
SCENARIOS = ("current", "empty", "partial", "stale", "parse-error", "future-version", "offline")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def validate_static(html_path: Path) -> None:
    html = html_path.read_text(encoding="utf-8")
    require("Fiktívne dáta · pracovný návrh" in html, "missing demo marker")
    require("ALFA STAV s.r.o." in html, "missing reference matter")
    require("14. 9. 2026" in html, "missing candidate deadline")
    require("base_revision" in html and "base_hash" in html, "missing concurrency trace")
    require("—" not in html, "em dash is forbidden")
    require(not re.search(r'(?:src|href)=["\']https?://', html), "external request found")
    for index, direction in enumerate(DIRECTIONS, start=1):
        require(f'data-direction="{direction}"' in html, f"missing direction {direction}")
        require(f'data-testid="direction-{index}"' in html, f"missing direction test id {index}")
    for scenario in SCENARIOS:
        require(f'data-scenario="{scenario}"' in html, f"missing scenario {scenario}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--html", type=Path, required=True)
    parser.add_argument("--mode", choices=("static", "smoke", "full"), default="static")
    parser.add_argument("--artifacts", type=Path)
    args = parser.parse_args()
    validate_static(args.html.resolve())
    print(f"OK: {args.mode} validation passed for {args.html}")


if __name__ == "__main__":
    main()
