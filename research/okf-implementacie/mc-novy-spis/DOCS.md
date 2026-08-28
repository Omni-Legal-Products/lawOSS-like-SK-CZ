# novy-spis — Referenčná dokumentácia

## 1. Výber profilu

| Situácia | Profil | Spúšťaný skript |
|---|---|---|
| Právne poradenstvo / zastupovanie / spis pre klienta | **A** | `new-klient.sh` + `new-spis.sh` |
| Interný projekt, výskum, infraštruktúra | **B** | `new-projekt.sh` |
| Daňové / účtovné veci | — | odkáž na `marian-uctovny-ledger` |

---

## 2. Frontmatter — polia dokumentov

### 2.1 `klient.md` (type: klient)

| Pole | Typ | Popis |
|---|---|---|
| `type` | string | vždy `klient` |
| `title` | string | Obchodné meno z ORSR |
| `description` | string | Krátky popis vzťahu / oblasti |
| `ico` | string (quoted) | IČO subjektu |
| `status` | enum | pozri §3 |
| `tags` | list | voľné štítky |
| `timestamp` | date `YYYY-MM-DD` | dátum vytvorenia |
| `updated` | date `YYYY-MM-DD` | dátum poslednej zmeny |

### 2.2 `spis.md` (type: spis)

| Pole | Typ | Popis |
|---|---|---|
| `type` | string | vždy `spis` |
| `title` | string | `YYYY-MM Protistrana - Vec - typ` |
| `description` | string | Krátky opis veci |
| `resource` | string | URL / cesta k hlavnému dokumentu (voliteľné) |
| `klient` | string | Obchodné meno klienta |
| `klient_ico` | string (quoted) | IČO klienta |
| `protistrana` | string | Obchodné meno protistrany |
| `protistrana_ico` | string (quoted) | IČO protistrany (voliteľné) |
| `oblast_prava` | list | oblasť(i) z číselníka 1–6 |
| `spisova_znacka` | string (quoted) | Spisová značka súdu / úradu |
| `sud` | string (quoted) | Súd alebo orgán |
| `status` | enum | pozri §3 |
| `lehoty` | list | zoznam lehôt vo formáte `{datum: YYYY-MM-DD, popis: …}` |
| `advokat` | string | zodpovedný advokát |
| `tags` | list | voľné štítky |
| `timestamp` | date `YYYY-MM-DD` | dátum vytvorenia |
| `updated` | date `YYYY-MM-DD` | dátum poslednej zmeny |

### 2.3 `projekt.md` (type: projekt)

| Pole | Typ | Popis |
|---|---|---|
| `type` | string | vždy `projekt` |
| `title` | string | Názov projektu |
| `description` | string | Krátky popis účelu |
| `klient` | string | Prepojený klient (voliteľné) |
| `status` | enum | pozri §3 |
| `milestones` | list | zoznam míľnikov `{datum: YYYY-MM-DD, popis: …}` |
| `tags` | list | voľné štítky |
| `timestamp` | date `YYYY-MM-DD` | dátum vytvorenia |
| `updated` | date `YYYY-MM-DD` | dátum poslednej zmeny |

---

## 3. Enum `status`

| Hodnota | Význam |
|---|---|
| `aktívny` | prebieha aktívna práca |
| `čaká-na-klienta` | čaká sa na podklady / rozhodnutie klienta |
| `neaktívny` | dočasne pozastavené |
| `ukončený` | vec uzavretá, ešte nie archivovaná |
| `archív` | archivované; vylúčené z `index.md` |

---

## 4. Skripty — použitie

### `new-klient.sh`
```
scripts/new-klient.sh <Názov> [--ico IČO] [--root DIR]
```
- `<Názov>` — obchodné meno verbatim (z ORSR)
- `--ico` — IČO subjektu (voliteľné, doplní sa do `klient.md`)
- `--root` — nadradený priečinok; default `$PWD`
- Odmietne vytvoriť, ak cieľ už existuje (no-touch).
- Generuje: `klient.md`, `AGENTS.md`, `MEMORY.md`, `CLAUDE.md` (byte kópia AGENTS.md) v novom priečinku klienta; regeneruje rodičovský `$root/index.md` cez `index-gen.sh`.

### `new-spis.sh`
```
scripts/new-spis.sh <oblasť> "<YYYY-MM Protistrana - Vec - typ>" \
  --klient-dir DIR [--protistrana X] [--ico X] [--protistrana-ico X]
```
- `<oblasť>` — číselník 1–6 (napr. `Obchodné`, `Pracovné`, ...)
- druhý pozičný arg — celý názov spisu vo formáte `YYYY-MM Protistrana - Vec - typ`
- `--klient-dir` — cesta k existujúcemu priečinku klienta **(povinné)**
- `--protistrana` — obchodné meno protistrany
- `--ico` — IČO klienta (ak nie je v `klient.md`, doplní sa)
- `--protistrana-ico` — IČO protistrany
- Odmietne vytvoriť, ak cieľ už existuje (no-touch).
- Generuje: `spis.md`, `_STATUS.md`, `AGENTS.md`, `MEMORY.md`, `CLAUDE.md`; podadresáre 1–7.

### `new-projekt.sh`
```
scripts/new-projekt.sh <názov> [--klient X] [--root DIR]
```
- `<názov>` — ľubovoľný názov; interný slug sa generuje automaticky (`okf_slug`)
- `--klient` — prepojenie na klienta (voliteľné)
- `--root` — nadradený priečinok; default `$PWD`
- Odmietne vytvoriť, ak cieľ (slug) už existuje (no-touch).
- Generuje: `projekt.md`, `AGENTS.md`, `MEMORY.md`, `CLAUDE.md` (symlink → AGENTS.md); podadresáre `docs/`, `research/`, `assets/`, `drafty/`, `_tools/`.

### `retrofit.sh`
```
scripts/retrofit.sh <typ> <dir> [--title "X"]
                               [--ico IČO]
                               [--klient X] [--klient-ico X]
                               [--protistrana X] [--protistrana-ico X]
                               [--oblast X]
                               [--upgrade]
                               [--protocol]
```
- `<typ>` — povinné; musí byť `klient`, `spis`, alebo `projekt`
- `<dir>` — cesta k **existujúcemu** priečinku; skript odmietne pokračovať, ak priečinok neexistuje
- `--title` — nadpis karty (default: `basename <dir>`)
- Príznaky platné pre jednotlivé typy:
  - `klient`: `--ico` (IČO subjektu; ekvivalent `--klient-ico`)
  - `spis`: `--klient`, `--klient-ico`, `--protistrana`, `--protistrana-ico`, `--oblast`
  - `projekt`: `--klient`
- **Prísne nedeštruktívne**: vytvára LEN súbory, ktoré chýbajú. Nikdy neprepíše, nezmaže ani nepresunie žiadny existujúci súbor, dokument ani podpriečinok. Existujúce súbory sa preskočia s hlásením `skip (exists): <fname>`.
- **Idempotentné**: opakovateľné volanie nemá vedľajší efekt.
- Pridávané súbory podľa typu:
  - `klient` → `klient.md`, `AGENTS.md`, `MEMORY.md`, `CLAUDE.md` (byte-kópia AGENTS.md)
  - `spis` → `spis.md`, `_STATUS.md`, `AGENTS.md`, `MEMORY.md`, `CLAUDE.md` (byte-kópia AGENTS.md)
  - `projekt` → `projekt.md`, `AGENTS.md`, `MEMORY.md`, `CLAUDE.md` (symlink → AGENTS.md)

#### `--upgrade` — injekcia frontmatteru do existujúcich v1.0 súborov

Voliteľný príznak `--upgrade` aktivuje **druhý prechod** po štandardnom vytváraní chýbajúcich súborov: skript prechádza **rozpoznané riadiace súbory** a do každého, ktorý nemá frontmatter (prvý riadok nie je `---`), prepíše minimálny YAML blok:

```yaml
---
type: <typ-súboru>
title: <basename priečinka>
updated: <YYYY-MM-DD>
---
```

Telo súboru zostáva **byte-for-byte zachované** — frontmatter sa vloží pred pôvodný obsah pomocou temp-súboru + `mv` (atómická operácia); oprávnenia súboru (`chmod`) sa tiež zachovajú.

**Dotknú sa len tieto fixné mená** (rozpoznaná množina riadiacich súborov):

| typ | Súbory kontrolované `--upgrade` prechodom |
|---|---|
| `klient` | `klient.md`, `AGENTS.md`, `CLAUDE.md`, `MEMORY.md` |
| `spis` | `spis.md`, `_STATUS.md`, `AGENTS.md`, `CLAUDE.md`, `MEMORY.md` |
| `projekt` | `projekt.md`, `AGENTS.md`, `CLAUDE.md`, `MEMORY.md` |

Súbor, ktorý v priečinku neexistuje, sa ticho preskočí (`[ -f "$f" ] || return 0`). Súbory, ktoré frontmatter **už majú** (prvý riadok = `---`), sa tiež preskočia — operácia je idempotentná.

`--upgrade` **nikdy** nesiahne na dokumenty ani na žiadne iné `.md` súbory mimo uvedenej množiny.

Bez `--upgrade` retrofit nemodifikuje žiadny existujúci súbor — výhradne pridáva chýbajúce.

#### `--protocol` — injekcia PROTOKOLU ZÁPISU do existujúcich AGENTS.md/CLAUDE.md

Voliteľný príznak `--protocol` po štandardnom vytváraní chýbajúcich súborov **append-uje** partial
`templates/partials/protokol-zapisu.md` (marker `<!-- okf:protokol-zapisu:v1 -->`) na koniec
`AGENTS.md` a `CLAUDE.md` v cieľovom priečinku:

- **Append-only**: partial sa pripojí (`printf '\n'; cat "$PARTIAL"; >> "$f"`), pôvodný obsah súboru sa nikdy neprepíše ani nemaže.
- **Marker-idempotentné**: ak súbor už obsahuje `okf:protokol-zapisu:v1`, preskočí sa s hlásením `skip (protokol prítomný): <fname>`.
- **Symlink-safe**: ak je cieľ symlink (typicky `CLAUDE.md` v Profile B), preskočí sa bez zápisu — vyhne sa duplicite pri zdieľanom súbore.
- Súbor, ktorý neexistuje, sa ticho preskočí.
- Skladá sa s `--upgrade` v jednom volaní: `scripts/retrofit.sh spis <dir> --upgrade --protocol` najprv doplní frontmatter, potom pripojí protokol.
- Ak partial chýba na disku (`templates/partials/protokol-zapisu.md`), skript zlyhá hneď na začiatku (`okf_die`), pred akoukoľvek zmenou.

- Po dokončení best-effort regeneruje `index.md` v rodičovskom adresári (cez `index-gen.sh`).
- Odporúčaný post-krok: `scripts/okf-validate.sh <dir>` a (pre klient/spis) `scripts/sync_agents_claude.sh <dir>`.

### `okf-validate.sh`
```
scripts/okf-validate.sh <DIR>
```
- Prechádza všetky `*.md` pod `DIR` (okrem `templates/`).
- Každý non-`index.md`, non-`log.md` súbor musí mať frontmatter s neprázdnym `type:`.
- Koreňový `index.md` smie mať len `okf_version:` vo frontmatteri.
- Výstup: `OK: <DIR> conformant (OKF v0.1)` alebo riadky `ERROR:` + exit 1.

### `sync_agents_claude.sh`
```
scripts/sync_agents_claude.sh [DIR] [--symlink]
```
- Default: `DIR = .`, mode = `copy` (Drive-safe kópia).
- `--symlink` — namiesto kópie vytvorí symlink (Profil B, lokálne prostredie).
- Synchronizuje `AGENTS.md` ↔ `CLAUDE.md` v každom podadresári: novší súbor prepíše starší.

### `index-gen.sh`
```
scripts/index-gen.sh <DIR>
```
- Generuje `DIR/index.md` so zoznamom aktívnych entít (vylúči `archív` a `ukončený`).
- Volaný automaticky z `new-klient.sh` a `new-spis.sh`.

### `okf-freshness.sh`
```
scripts/okf-freshness.sh <dir>
```
Drift detektor: pre KAŽDÝ `_STATUS.md` nájdený pod `<dir>` (vrátane `<dir>` samotného) porovná jeho
mtime s najnovším mtime "content" súboru vo VLASTNOM podstrome daného `_STATUS.md` (bez podstromov
vnorených `_STATUS.md` — tie sa skenujú nezávisle, ako vlastná hranica).
- **Content súbor** = ktorýkoľvek bežný súbor okrem kontrolných súborov na KORENI adresára s daným
  `_STATUS.md` (`_STATUS.md`, `AGENTS.md`, `CLAUDE.md`, `MEMORY.md`, `spis.md`, `klient.md`,
  `projekt.md`, `index.md`, `log.md`) a okrem `.DS_Store` kdekoľvek v podstrome.
- Nevyžaduje žiadne flagy okrem cesty; `<dir>` musí existovať.
- **Exit 0** + `OK: žiadny drift`, ak žiadny `_STATUS.md` nie je stale.
- **Exit 1** + jeden riadok `STALE: <dir> — _STATUS.md je starší než: <relatívna cesta>` pre každý
  stale spis (vypisuje sa najnovší nájdený content súbor v danom podstrome).
- Read-only — nič nemodifikuje; vhodné volať kedykoľvek pred/po práci v existujúcom spise.

### `preflight.sh`
```
scripts/preflight.sh
```
- Overí prítomnosť systémových závislostí: `bash`, `awk`, `sed`, `grep`, `date`.
- Exit 0 = OK; exit 1 = chýba nástroj.

### `lib.sh`
Zdieľaná knižnica helperov — nie je priamo spustiteľná.
Funkcie: `okf_die`, `okf_today`, `okf_fm_get`, `okf_slug`, `okf_sed_escape`.

---

## 5. OKF v0.1 — pravidlá konformity

1. Každý konceptový dokument (`*.md` okrem `index.md`, `log.md`) **musí** mať YAML frontmatter s neprázdnym poľom `type:`.
2. Non-root `index.md` nesmie mať frontmatter. Koreňový `index.md` smie mať frontmatter IBA s kľúčom `okf_version:` (alebo žiadny frontmatter).
3. Skripty **odmietajú** prepísať existujúci cieľový priečinok (no-touch).
4. `CLAUDE.md` je vždy synchronizovaná kópia `AGENTS.md` (Profil A) alebo symlink (Profil B).
5. Linky na zdieľané know-how musia byť bundle-relative (`/_02_Know_How/...`), nie absolútne.

## 5a. Zápisový protokol

Partial `templates/partials/protokol-zapisu.md` (marker `<!-- okf:protokol-zapisu:v1 -->`) je
povinná zápisová disciplína pre agenta pracujúceho v existujúcom priečinku: smerovacia tabuľka
(fakt → `_STATUS.md` § Fakty veci, udalosť → § Chronológia, lehota → `spis.md` frontmatter +
§ Lehoty, taktika → `MEMORY.md` TP-XXX, poučenie → LL-XXX, otvorená otázka → OQ-XXX, dokument →
podpriečinok + § Kľúčové dokumenty, komunikácia → § Komunikácia, úloha → § Otvorené úlohy) a
session-end hard gate (Fáza/Ďalší krok, `updated:` frontmatteru, AGENTS↔CLAUDE sync).

Partial sa vkladá do `AGENTS.md`/`CLAUDE.md`:
- **pri zakladaní** — `new-klient.sh`, `new-spis.sh`, `new-projekt.sh` (šablóny
  `templates/klient/AGENTS.md`, `templates/spis/AGENTS.md`, `templates/projekt/AGENTS.md` už
  obsahujú tento partial vložený priamo do tela);
- **pri retrofite existujúceho priečinka** — `scripts/retrofit.sh <typ> <dir> --protocol`
  (append-only, marker-idempotentné, symlink-skip; pozri § 4 `--protocol`).

Sprievodná zmena `_STATUS.md` šablóny (`templates/spis/_STATUS.md`): **Fáza** a **Ďalší krok**
navrchu (nad sekciou Strany), nová **§ 2 Fakty veci** a nová **§ 7 Komunikácia** — kompletné poradie
sekcií: 1 Strany, 2 Fakty veci, 3 Lehoty, 4 Chronológia, 5 Otvorené úlohy, 6 Kľúčové dokumenty,
7 Komunikácia.
6. Citácie predpisov a judikátov patria pod sekciu `# Citations`, overené cez MCP.

---

## 6. Integrácie MCP (Profil A)

| Krok | MCP nástroje |
|---|---|
| ORSR audit klienta | `orsr_get_company_data_by_query`, `orsr_get_company_profile` |
| ORSR audit protistrany | `orsr_get_company_data`, `orsr_search_entities` |
| RPO overenie | `rpo_get_entity`, `rpo_search` |
| Hlbšia previerka | skill `client-research` |
| Judikáty / predpisy | `mcp__marian-cuprik-legal_MCP-judikaty__*`, EUR-Lex MCP |
