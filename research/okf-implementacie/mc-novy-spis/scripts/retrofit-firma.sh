#!/usr/bin/env bash
# retrofit-firma.sh — nedeštruktívne povýšenie EXISTUJÚCEHO firemného priečinka na Profil C.
# Pridá LEN to, čo chýba: kartu firmy (spis.md s ORSR poľami, _STATUS.md, AGENTS/CLAUDE/MEMORY)
# a tematické priečinky 1–6. Nikdy neprepíše, nezmaže ani nepresunie existujúci súbor/priečinok.
#
# Usage:
#   retrofit-firma.sh "<firma-dir>" [--klient "X"] --ico ICO \
#     [--obchodne-meno "X"] [--spzn "Sro 12345/V"] [--sud "Mestský súd Košice"] \
#     [--sidlo "…"] [--desc "…"]
#
# ORSR: hodnoty over cez MCP orsr_* PRED volaním. Ak karta spis.md už existuje, skript ju
# NEPREPÍŠE (vypíše upozornenie) — ORSR údaje vtedy doplň ručne.
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"
TPL="$HERE/../templates/spis"

dir=""; klient=""; ico=""; obchodne=""; spzn=""; sud=""; sidlo=""; desc=""
while [ $# -gt 0 ]; do case "$1" in
  --klient)        klient="$2";    shift 2;;
  --ico)           ico="$2";       shift 2;;
  --obchodne-meno) obchodne="$2";  shift 2;;
  --spzn)          spzn="$2";      shift 2;;
  --sud)           sud="$2";       shift 2;;
  --sidlo)         sidlo="$2";     shift 2;;
  --desc)          desc="$2";      shift 2;;
  -*) okf_die "unknown flag: $1";;
  *)  [ -z "$dir" ] && dir="$1" || okf_die "unexpected arg: $1"; shift;;
esac; done

[ -n "$dir" ] || okf_die 'usage: retrofit-firma.sh "<firma-dir>" [--klient X] --ico ICO [--obchodne-meno X --spzn X --sud X --sidlo X]'
[ -d "$dir" ] || okf_die "not an existing directory: $dir"
name="$(basename "$dir")"
[ -n "$obchodne" ] || obchodne="$name"
# klient z parent/klient.md ak nezadaný
if [ -z "$klient" ]; then
  pk="$(dirname "$dir")/klient.md"
  [ -f "$pk" ] && klient="$(okf_fm_get "$pk" title)"
fi
[ -n "$klient" ] || klient="$name"
today="$(okf_today)"

# 1) tematické priečinky (vytvor len chýbajúce — mkdir -p je idempotentné)
for d in "1 - Zmluva s klientom a splnomocnenia" "2 - Corporate" "3 - Pracovné právo" \
         "4 - Litigácie" "5 - IP právo" "6 - Iné"; do
  if [ -d "$dir/$d" ]; then echo "skip (exists dir): $d"; else mkdir -p "$dir/$d"; echo "added dir: $d"; fi
done

# 2) spis.md (len ak chýba)
if [ -e "$dir/spis.md" ]; then
  echo "skip (exists): spis.md  — ORSR údaje doplň ručne (no-touch)"
else
  cat > "$dir/spis.md" <<EOF
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
EOF
  echo "added: spis.md"
fi

# 3) _STATUS.md (len ak chýba)
if [ -e "$dir/_STATUS.md" ]; then echo "skip (exists): _STATUS.md"; else
  cat > "$dir/_STATUS.md" <<EOF
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
  echo "added: _STATUS.md"
fi

# 4) AGENTS.md / MEMORY.md (len ak chýbajú) + CLAUDE.md kópia
fill() {
  local t k; t="$(okf_sed_escape "$name")"; k="$(okf_sed_escape "$klient")"
  sed -e "s|{{TITLE}}|$t|g" -e "s|{{KLIENT}}|$k|g" \
      -e "s|{{DESCRIPTION}}||g" -e "s|{{RESOURCE}}||g" -e "s|{{KLIENT_ICO}}||g" \
      -e "s|{{PROTISTRANA}}||g" -e "s|{{PROTISTRANA_ICO}}||g" \
      -e "s|{{OBLAST}}|Obchodné právo|g" -e "s|{{SPZN}}||g" -e "s|{{SUD}}||g" \
      -e "s|{{DATE}}|$today|g" "$1"
}
[ -e "$dir/AGENTS.md" ] && echo "skip (exists): AGENTS.md" || { fill "$TPL/AGENTS.md" > "$dir/AGENTS.md"; echo "added: AGENTS.md"; }
[ -e "$dir/MEMORY.md" ] && echo "skip (exists): MEMORY.md" || { fill "$TPL/MEMORY.md" > "$dir/MEMORY.md"; echo "added: MEMORY.md"; }
if [ ! -e "$dir/CLAUDE.md" ] && [ -f "$dir/AGENTS.md" ]; then cp "$dir/AGENTS.md" "$dir/CLAUDE.md"; echo "added: CLAUDE.md (copy)"; else echo "skip (exists): CLAUDE.md"; fi

bash "$HERE/index-gen.sh" "$(dirname "$dir")" >/dev/null 2>&1 || true
echo "retrofit-firma done: $dir"

