#!/usr/bin/env bash
# new-firma.sh — korporátny klient (firma) ako spis s TEMATICKÝM členením.
# Firma = jeden spis: karta na úrovni firmy (vrátane ORSR údajov) + tematické
# priečinky 1–6. Konkrétne kauzy sa do nej pridávajú cez new-kauza.sh.
#
# Usage:
#   new-firma.sh "<Folder/Brand názov>" --klient-dir DIR --ico ICO \
#     [--obchodne-meno "X"] [--spzn "Sro 12345/V"] [--sud "Mestský súd Košice"] \
#     [--sidlo "Ulica 1, 040 01 Košice"] [--desc "krátky popis"]
#
# ORSR: hodnoty (--obchodne-meno/--ico/--spzn/--sud/--sidlo) MUSIA byť overené
# cez MCP orsr_* PRED volaním — skript ich len zapíše do karty (sám MCP nevolá).
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"
TPL="$HERE/../templates/spis"

name=""; klient_dir=""; ico=""; obchodne=""; spzn=""; sud=""; sidlo=""; desc=""
while [ $# -gt 0 ]; do case "$1" in
  --klient-dir)    klient_dir="$2"; shift 2;;
  --ico)           ico="$2";        shift 2;;
  --obchodne-meno) obchodne="$2";   shift 2;;
  --spzn)          spzn="$2";       shift 2;;
  --sud)           sud="$2";        shift 2;;
  --sidlo)         sidlo="$2";      shift 2;;
  --desc)          desc="$2";       shift 2;;
  -*) okf_die "unknown flag: $1";;
  *)  [ -z "$name" ] && name="$1" || okf_die "unexpected arg: $1"; shift;;
esac; done

[ -n "$name" ] && [ -n "$klient_dir" ] || okf_die 'usage: new-firma.sh "<názov>" --klient-dir DIR --ico ICO [--obchodne-meno X --spzn X --sud X --sidlo X --desc X]'
[ -d "$klient_dir" ] || okf_die "klient-dir not found: $klient_dir"
[ -f "$klient_dir/klient.md" ] || okf_die "missing klient.md in $klient_dir"

klient="$(okf_fm_get "$klient_dir/klient.md" title)"
[ -n "$klient" ] || okf_die "could not read klient title"
[ -n "$obchodne" ] || obchodne="$name"

dest="$klient_dir/$name"
[ -e "$dest" ] && okf_die "target exists, refusing (no-touch): $dest"
mkdir -p "$dest"

# tematické priečinky (klient/firemná úroveň)
mkdir -p \
  "$dest/1 - Zmluva s klientom a splnomocnenia" \
  "$dest/2 - Corporate" \
  "$dest/3 - Pracovné právo" \
  "$dest/4 - Litigácie" \
  "$dest/5 - IP právo" \
  "$dest/6 - Iné"

today="$(okf_today)"

# --- karta firmy: spis.md (s ORSR poľami) ---
cat > "$dest/spis.md" <<EOF
---
type: spis
title: $name
description: $desc
resource: 
klient: $klient
klient_ico: ""
protistrana: 
protistrana_ico: ""
firma: $obchodne
ico: "$ico"
oblast_prava: [Obchodné právo, Korporátne právo]
spisova_znacka: "$spzn"
sud: "$sud"
status: aktívny
lehoty: []
advokat: Marián Čuprík
tags: [korporátny-klient, s.r.o.]
timestamp: $today
updated: $today
---

# $name

Korporátny spis spoločnosti **$obchodne**.

## Firma — ORSR (overené cez MCP)
- **Obchodné meno:** $obchodne
- **IČO:** $ico
- **Spisová značka:** $spzn${sud:+, $sud}
- **Sídlo:** $sidlo
- **Konatelia:** _(doplň z ORSR)_
- **Spoločníci / podiely:** _(doplň z ORSR)_
- **Spôsob konania:** _(doplň z ORSR)_

## Navigácia
- SSOT: [\`_STATUS.md\`](./_STATUS.md)
- Pamäť: [\`MEMORY.md\`](./MEMORY.md)
- Klient: [\`../klient.md\`](../klient.md)

## Kauzy
*(zoznam generuje index.md; jednotlivé kauzy zakladaj cez new-kauza.sh do 1–6)*
EOF

# --- _STATUS.md (so subjektom) ---
cat > "$dest/_STATUS.md" <<EOF
---
type: status
title: $name — Status
updated: $today
---

# $name — Status (SSOT)

> **Fáza:** _(jedna veta — kde vec práve stojí)_
> **Ďalší krok:** _(čo sa má stať najbližšie + kto to má urobiť + dokedy)_

## 1. Subjekt (ORSR)
| Pole | Hodnota |
|---|---|
| Obchodné meno | $obchodne |
| IČO | $ico |
| Spis. zn. | $spzn${sud:+, $sud} |
| Sídlo | $sidlo |
| Konatelia |  |
| Spoločníci |  |
| ZI |  |

## 2. Fakty veci
*(každý fakt zistený pri práci — tvrdenia strán, zistenia z dokumentov, priznania, technický stav)*

| # | Fakt | Zdroj | Zistené | Dopad na vec |
|---|---|---|---|---|

## 3. Lehoty
| Dátum | Typ | Zdroj | Stav |
|---|---|---|---|

## 4. Chronológia
| Dátum | Udalosť | Zdroj |
|---|---|---|

## 5. Otvorené úlohy
| # | Úloha | Termín | Status | Kto |
|---|---|---|---|---|

## 6. Kľúčové dokumenty
| Typ | Lokácia |
|---|---|

## 7. Komunikácia
*(Gmail thread ID / spisová značka podania / tel. — aby budúci agent našiel kontext)*

| Kanál | Identifikátor | Téma | Posledná aktivita |
|---|---|---|---|
EOF

# --- AGENTS.md + MEMORY.md z template spisu, CLAUDE.md = kópia ---
fill() {
  local t k; t="$(okf_sed_escape "$name")"; k="$(okf_sed_escape "$klient")"
  sed -e "s|{{TITLE}}|$t|g" -e "s|{{KLIENT}}|$k|g" \
      -e "s|{{DESCRIPTION}}||g" -e "s|{{RESOURCE}}||g" \
      -e "s|{{KLIENT_ICO}}||g" -e "s|{{PROTISTRANA}}||g" \
      -e "s|{{PROTISTRANA_ICO}}||g" -e "s|{{OBLAST}}|Obchodné právo|g" \
      -e "s|{{SPZN}}||g" -e "s|{{SUD}}||g" -e "s|{{DATE}}|$today|g" "$1"
}
fill "$TPL/AGENTS.md" > "$dest/AGENTS.md"
fill "$TPL/MEMORY.md" > "$dest/MEMORY.md"
cp "$dest/AGENTS.md" "$dest/CLAUDE.md"

bash "$HERE/index-gen.sh" "$klient_dir" >/dev/null 2>&1 || true
echo "created firma: $dest"

