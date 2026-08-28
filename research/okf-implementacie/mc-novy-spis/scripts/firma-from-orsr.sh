#!/usr/bin/env bash
# firma-from-orsr.sh — AUTOMAT: založí korporátneho klienta (Profil C) z ORSR JSON.
# Shell sám MCP nevolá — agent najprv spustí orsr_get_company_profile, uloží výstup do
# súboru a ten podá cez --orsr-json. Skript JSON rozparsuje a vyplní KOMPLETNÚ kartu
# (obch. meno, IČO, spis.zn.+súd, sídlo, konatelia, spoločníci, podiely, ZI, spôsob konania).
#
# LEN PRE SLOVENSKÉ FIRMY (zdroj ORSR). Zahraničné firmy → viď SKILL.md (Profil C-Z).
#
# Usage:
#   firma-from-orsr.sh "<Folder/Brand názov>" --klient-dir DIR --orsr-json FILE [--desc "…"] [--retrofit]
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"
TPL="$HERE/../templates/spis"

name=""; klient_dir=""; json=""; desc=""; retrofit=0
while [ $# -gt 0 ]; do case "$1" in
  --klient-dir) klient_dir="$2"; shift 2;;
  --orsr-json)  json="$2";       shift 2;;
  --desc)       desc="$2";       shift 2;;
  --retrofit)   retrofit=1;      shift;;
  -*) okf_die "unknown flag: $1";;
  *)  [ -z "$name" ] && name="$1" || okf_die "unexpected arg: $1"; shift;;
esac; done

[ -n "$name" ] && [ -n "$klient_dir" ] && [ -n "$json" ] \
  || okf_die 'usage: firma-from-orsr.sh "<názov>" --klient-dir DIR --orsr-json FILE [--desc X] [--retrofit]'
[ -d "$klient_dir" ] || okf_die "klient-dir not found: $klient_dir"
[ -f "$klient_dir/klient.md" ] || okf_die "missing klient.md in $klient_dir"
[ -f "$json" ] || okf_die "orsr-json not found: $json"
command -v python3 >/dev/null || okf_die "python3 required"

klient="$(okf_fm_get "$klient_dir/klient.md" title)"; [ -n "$klient" ] || klient="$name"
dest="$klient_dir/$name"
if [ -e "$dest" ] && [ "$retrofit" -eq 0 ]; then okf_die "target exists, refusing (no-touch): $dest  (použi --retrofit)"; fi
mkdir -p "$dest"
for d in "1 - Zmluva s klientom a splnomocnenia" "2 - Corporate" "3 - Pracovné právo" \
         "4 - Litigácie" "5 - IP právo" "6 - Iné"; do mkdir -p "$dest/$d"; done

today="$(okf_today)"

# parser: vyplní spis.md a _STATUS.md z ORSR JSON
NAME="$name" KLIENT="$klient" DESC="$desc" TODAY="$today" DEST="$dest" RETRO="$retrofit" \
python3 - "$json" <<'PY'
import json,os,sys
j=json.load(open(sys.argv[1],encoding='utf-8'))
name=os.environ['NAME']; klient=os.environ['KLIENT']; desc=os.environ['DESC']
today=os.environ['TODAY']; dest=os.environ['DEST']; retro=os.environ['RETRO']=='1'
s=j.get('subject',{}) or {}
obch=s.get('nameCurrent','') or name
ico=s.get('ico','') or ''
spzn=s.get('fileReference','') or ''
sud=s.get('courtName','') or ''
sidlo=s.get('addressCurrent','') or ''
forma=s.get('legalForm','') or ''
sync=(s.get('dataSyncDate','') or '')[:10]
def cur(lst):
    return [x for x in (lst or []) if x.get('current')]
sb=cur((j.get('statutoryBody',{}) or {}).get('current') or (j.get('statutoryBody',{}) or {}).get('all'))
# statutoryBody.current už je „current"
sb=(j.get('statutoryBody',{}) or {}).get('current') or []
typ=''
for t in (j.get('statutoryBody',{}) or {}).get('statutoryBodyTypeHistory',[]) or []:
    if t.get('current'): typ=t.get('value','')
acting=''
for a in (j.get('actingRules',{}) or {}).get('statutory',[]) or []:
    if a.get('current'): acting=(a.get('text','') or '').strip()
stk=(j.get('stakeholders',{}) or {}).get('current') or []
own=(j.get('ownership',{}) or {}).get('computedFromDeposits') or []
zi=''
try:
    tot=sum(float(o.get('value') or 0) for o in own)
    cur_=(own[0].get('currency') if own else 'EUR') or 'EUR'
    if tot: zi=f"{int(tot) if tot==int(tot) else tot} {cur_}"
except Exception: pass
acc=(j.get('accountingStatements') or [])
last_acc=acc[0].get('name','') if acc else ''
last_acc_date=(acc[0].get('deliveryDate','') or '')[:10] if acc else ''

def names(lst): return '; '.join(x.get('name','') for x in lst if x.get('name'))
konatelia=names(sb) or '_(z ORSR nezistené)_'
# spoločníci + podiely
own_by={o.get('stakeholder',''):o for o in own}
spol_lines=[]
for x in stk:
    nm=x.get('name','')
    o=own_by.get(nm)
    if o and o.get('percent') is not None:
        spol_lines.append(f"{nm} {o.get('percent')}% (vklad {int(o.get('value')) if float(o.get('value',0))==int(o.get('value',0)) else o.get('value')} {o.get('currency','EUR')})")
    else:
        spol_lines.append(nm)
spolocnici='; '.join(spol_lines) or '_(z ORSR nezistené)_'

fm=f'''---
type: spis
title: {name}
description: {desc}
resource: 
klient: {klient}
klient_ico: ""
protistrana: 
protistrana_ico: ""
firma: {obch}
ico: "{ico}"
oblast_prava: [Obchodné právo, Korporátne právo]
spisova_znacka: "{spzn}"
sud: "{sud}"
status: aktívny
lehoty: []
advokat: Marián Čuprík
tags: [korporátny-klient, s.r.o.]
timestamp: {today}
updated: {today}
---

# {name}

Korporátny spis spoločnosti **{obch}**.

## Firma — ORSR (overené cez MCP{(", sync "+sync) if sync else ""})
- **Obchodné meno:** {obch}
- **IČO:** {ico}
- **Spisová značka:** {spzn}{(", "+sud) if sud else ""}
- **Sídlo:** {sidlo}
- **Štatutárny orgán ({typ or "konateľ"}):** {konatelia}
- **Spoločníci / podiely:** {spolocnici}
- **Základné imanie:** {zi or "_(doplň)_"}
- **Spôsob konania:** {acting or "_(z ORSR nezistené)_"}
- **Posledná účtovná závierka:** {(last_acc + (" ("+last_acc_date+")" if last_acc_date else "")) if last_acc else "_(nezistené)_"}

## Navigácia
- SSOT: [`_STATUS.md`](./_STATUS.md)
- Pamäť: [`MEMORY.md`](./MEMORY.md)
- Klient: [`../klient.md`](../klient.md)

## Kauzy
*(kauzy zakladaj cez new-kauza.sh do tematických 1–6)*
'''

st=f'''---
type: status
title: {name} — Status
updated: {today}
---

# {name} — Status (SSOT)

> **Fáza:** _(jedna veta — kde vec práve stojí)_
> **Ďalší krok:** _(čo sa má stať najbližšie + kto to má urobiť + dokedy)_

## 1. Subjekt (ORSR{(", sync "+sync) if sync else ""})
| Pole | Hodnota |
|---|---|
| Obchodné meno | {obch} |
| IČO | {ico} |
| Spis. zn. | {spzn}{(", "+sud) if sud else ""} |
| Sídlo | {sidlo} |
| Štatutár ({typ or "konateľ"}) | {konatelia} |
| Spoločníci | {spolocnici} |
| ZI | {zi} |
| Spôsob konania | {acting} |

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
'''

sp=os.path.join(dest,'spis.md'); su=os.path.join(dest,'_STATUS.md')
if os.path.exists(sp) and retro:
    print("skip (exists): spis.md")
else:
    open(sp,'w',encoding='utf-8').write(fm); print("written: spis.md")
if os.path.exists(su) and retro:
    print("skip (exists): _STATUS.md")
else:
    open(su,'w',encoding='utf-8').write(st); print("written: _STATUS.md")
PY

# AGENTS/MEMORY/CLAUDE (len ak chýbajú)
fill(){ local t k; t="$(okf_sed_escape "$name")"; k="$(okf_sed_escape "$klient")";
  sed -e "s|{{TITLE}}|$t|g" -e "s|{{KLIENT}}|$k|g" -e "s|{{DESCRIPTION}}||g" \
      -e "s|{{RESOURCE}}||g" -e "s|{{KLIENT_ICO}}||g" -e "s|{{PROTISTRANA}}||g" \
      -e "s|{{PROTISTRANA_ICO}}||g" -e "s|{{OBLAST}}|Obchodné právo|g" \
      -e "s|{{SPZN}}||g" -e "s|{{SUD}}||g" -e "s|{{DATE}}|$today|g" "$1"; }
[ -e "$dest/AGENTS.md" ] || fill "$TPL/AGENTS.md" > "$dest/AGENTS.md"
[ -e "$dest/MEMORY.md" ] || fill "$TPL/MEMORY.md" > "$dest/MEMORY.md"
[ -e "$dest/CLAUDE.md" ] || cp "$dest/AGENTS.md" "$dest/CLAUDE.md"
bash "$HERE/index-gen.sh" "$klient_dir" >/dev/null 2>&1 || true
echo "firma-from-orsr done: $dest"

