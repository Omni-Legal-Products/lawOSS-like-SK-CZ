#!/usr/bin/env python3
"""Generuje specs/prehlad.html z evidencie v specs/navrhy.md.

Prehľad bol dovtedy ručný a zastarával — 2026-08-14 mu chýbali nápady #28
až #33 aj zjednotené stavy. Odkedy majú stavy pevnú sadu, dá sa generovať.

Zdroj pravdy je vždy navrhy.md. Tento súbor sa needituje ručne.

Spúšťa GitHub Action pri pushi; lokálne:
    python3 .github/scripts/update_prehlad.py
"""
import html
import re
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ZDROJ = ROOT / "specs" / "navrhy.md"
CIEL = ROOT / "specs" / "prehlad.html"

# poradie určuje poradie stĺpcov v prehľade
STAVY = [
    ("💭", "nápad", "#7d8ca8", "zapísané, nerozpracované"),
    ("📝", "spec", "#c9a24a", "rozpísané do špecifikácie"),
    ("✅", "odklepnuté", "#1f9d55", "tím schválil, môže sa stavať"),
    ("🔨", "implementuje sa", "#2b7fd4", "beží PR vo forku"),
    ("✔️", "hotové", "#0b6b3a", "je to v produkte"),
    ("⏸️", "odložené", "#c98a1a", "vedome nie teraz"),
    ("❌", "zamietnuté", "#c0392b", "nejde sa do toho"),
]

RIADOK = re.compile(r"^\|\s*(\d+)\s*\|(.+)$")


def odkazy_na_text(s: str) -> str:
    """[text](url) -> text; **bold** a *kurzíva* -> čistý text."""
    s = re.sub(r"\[([^\]]+)\]\([^)]*\)", r"\1", s)
    s = re.sub(r"\*\*([^*]+)\*\*", r"\1", s)
    s = re.sub(r"(?<!\*)\*([^*]+)\*(?!\*)", r"\1", s)
    s = re.sub(r"`([^`]+)`", r"\1", s)
    return " ".join(s.split())


def nacitaj():
    polozky = []
    for line in ZDROJ.read_text(encoding="utf-8").splitlines():
        m = RIADOK.match(line)
        if not m:
            continue
        stlpce = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(stlpce) < 6:
            continue
        cislo, navrh, kto, datum, stav = stlpce[0], stlpce[1], stlpce[2], stlpce[3], stlpce[4]
        kluc = next((n for _, n, _, _ in STAVY if n in stav), None)
        if kluc is None:
            continue
        nazov = odkazy_na_text(navrh)
        popis = ""
        if " — " in nazov:
            nazov, popis = nazov.split(" — ", 1)
        polozky.append({
            "cislo": int(cislo),
            "nazov": nazov,
            "popis": popis,
            "kto": odkazy_na_text(kto),
            "datum": odkazy_na_text(datum),
            "stav": kluc,
            "poznamka": odkazy_na_text(stav.split("·", 1)[1]) if "·" in stav else "",
        })
    return polozky


def karta(p) -> str:
    emoji = next(e for e, n, _, _ in STAVY if n == p["stav"])
    pozn = f'<div class="pozn">{html.escape(p["poznamka"])}</div>' if p["poznamka"] else ""
    popis = f'<div class="popis">{html.escape(p["popis"])}</div>' if p["popis"] else ""
    return f"""<div class="karta" data-stav="{p['stav']}">
  <div class="hlava"><span class="cislo">#{p['cislo']}</span><span class="kto">{html.escape(p['kto'])} · {html.escape(p['datum'])}</span></div>
  <div class="nazov">{emoji} {html.escape(p['nazov'])}</div>
  {popis}{pozn}
</div>"""


def main() -> None:
    polozky = nacitaj()
    ts = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    pocty = {n: sum(1 for p in polozky if p["stav"] == n) for _, n, _, _ in STAVY}

    filtre = "\n    ".join(
        f'<button class="f" data-f="{n}" style="--c:{c}">{e} {n} <b>{pocty[n]}</b></button>'
        for e, n, c, _ in STAVY if pocty[n]
    )
    stlpce = "\n".join(
        f'<section class="skupina" data-stav="{n}"><h2 style="--c:{c}">{e} {n} '
        f'<span class="pocet">{pocty[n]}</span></h2><p class="vysvetl">{v}</p>'
        + "\n".join(karta(p) for p in sorted(polozky, key=lambda x: x["cislo"]) if p["stav"] == n)
        + "</section>"
        for e, n, c, v in STAVY if pocty[n]
    )

    CIEL.write_text(f"""<!doctype html>
<html lang="sk">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LAWOSS — prehľad návrhov a funkcií</title>
<style>
  :root{{--navy:#0d1b2a;--gold:#c9a24a;--ink:#1a2233;--muted:#5b6577;--line:#e4e7ec;--bg:#f6f7f9;--card:#fff}}
  @media(prefers-color-scheme:dark){{:root{{--ink:#e8ecf3;--muted:#9aa6b8;--line:#25324a;--bg:#0b131f;--card:#111c2e}}}}
  *{{box-sizing:border-box}}
  body{{margin:0;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
    background:var(--bg);color:var(--ink);line-height:1.55}}
  .hero{{background:linear-gradient(160deg,var(--navy),#13243a);color:#fff;padding:34px 20px 26px;border-bottom:3px solid var(--gold)}}
  .wrap{{max-width:1180px;margin:0 auto}}
  .hero h1{{margin:.1em 0;font-size:clamp(22px,4vw,34px);font-weight:800}}
  .hero p{{margin:.3em 0 0;color:#c8d2e0;font-size:14px}}
  .gen{{margin-top:12px;font-size:12.5px;color:#8fa0b8}}
  .filtre{{display:flex;flex-wrap:wrap;gap:8px;padding:18px 20px 4px}}
  .f{{background:var(--card);border:1px solid var(--line);border-left:4px solid var(--c);color:var(--ink);
    padding:7px 13px;border-radius:9px;font-size:13px;cursor:pointer;font-family:inherit}}
  .f:hover{{border-color:var(--c)}}
  .f.off{{opacity:.35}}
  main{{padding:10px 20px 60px}}
  .skupina{{margin:26px 0}}
  .skupina h2{{font-size:17px;margin:0 0 2px;border-left:4px solid var(--c);padding-left:10px;font-weight:800}}
  .pocet{{background:var(--c);color:#fff;border-radius:100px;padding:1px 9px;font-size:12.5px;margin-left:6px}}
  .vysvetl{{margin:0 0 12px 14px;color:var(--muted);font-size:13px}}
  .karta{{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:13px 15px;margin:0 0 9px 14px}}
  .hlava{{display:flex;justify-content:space-between;gap:10px;font-size:12px;color:var(--muted)}}
  .cislo{{font-weight:800;color:var(--gold)}}
  .nazov{{font-weight:700;margin:3px 0 2px;font-size:14.5px}}
  .popis,.pozn{{color:var(--muted);font-size:13px}}
  .pozn{{margin-top:4px;font-style:italic}}
  footer{{border-top:1px solid var(--line);padding:20px;color:var(--muted);font-size:12.5px;text-align:center}}
</style>
</head>
<body>
<div class="hero"><div class="wrap">
  <h1>📋 Prehľad návrhov a funkcií</h1>
  <p>Všetko, čo je v evidencii — od surového nápadu po hotovú funkciu.</p>
  <div class="gen">Generované z <code>specs/navrhy.md</code> · {ts} · <b>{len(polozky)} položiek</b></div>
</div></div>

<div class="wrap">
  <div class="filtre">
    {filtre}
  </div>
  <main>
{stlpce}
  </main>
  <footer>
    Tento súbor sa <b>negeneruje ručne</b>. Zdroj pravdy je <code>specs/navrhy.md</code>;
    zmeny píš tam a prehľad sa prekreslí sám.
  </footer>
</div>

<script>
document.querySelectorAll('.f').forEach(function(b){{
  b.addEventListener('click', function(){{
    b.classList.toggle('off');
    var s = b.dataset.f;
    document.querySelectorAll('.skupina[data-stav="'+s+'"]').forEach(function(g){{
      g.style.display = b.classList.contains('off') ? 'none' : '';
    }});
  }});
}});
</script>
</body>
</html>
""", encoding="utf-8")
    print(f"specs/prehlad.html aktualizované — {len(polozky)} položiek: " +
          ", ".join(f"{n} {pocty[n]}" for _, n, _, _ in STAVY if pocty[n]))


if __name__ == "__main__":
    main()
