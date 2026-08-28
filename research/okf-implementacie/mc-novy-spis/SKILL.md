---
name: novy-spis
description: Use when creating a new client/legal matter (klient/spis) or a generic project folder following the OKF folder strategy. Triggers (SK) — "nový spis", "nový klient", "založ spis", "založ projekt", "nový projekt", "vytvor priečinok klienta", "zapíš do spisu", "aktualizuj spis", "skontroluj drift spisu"; (EN) — "new matter", "new client folder", "new project", "scaffold project".
---

# novy-spis — zakladanie OKF entít (klient/spis/projekt)

## Účel
Založiť novú entitu podľa stratégie `docs/specs/.../okf-folder-strategy` — **plne OKF v0.1
conformant** — a nič existujúce nemodifikovať.

## Krok 0 — Výber profilu (povinné)
Polož otázku: *Je to právne poradenstvo / zastupovanie / spis pre konkrétneho klienta?*
- **ÁNO → Profil A** (klient → spis). Pokračuj krokom A.
- **NIE → Profil B** (`projekt`, default). Pokračuj krokom B.
Daňové/účtovné veci nepatria sem — odkáž na skill `marian-uctovny-ledger`.

## Profil A — klient + spis
1. Zisti, či klient už má priečinok. **Ak áno, NEZAKLADAJ ho znova** (no-touch) — pridávaš len spis.
2. **ORSR/RPO audit** subjektu(ov) (klient aj protistrana): cez MCP `orsr_*` / `rpo_*` over
   IČO, sídlo, štatutára, stav. Žiadne údaje „z hlavy". Pre hlbšiu previerku ponúkni skill
   `client-research`.
3. Nový klient (ak treba):
   `scripts/new-klient.sh "<Obchodné meno z ORSR>" --ico <IČO> --root "<CHZ Work cesta>"`
4. Nový spis:
   `scripts/new-spis.sh "<oblasť 1-6>" "<YYYY-MM Protistrana - Vec - typ>" --klient-dir "<klient-dir>" --protistrana "<názov protistrany>" [--protistrana-ico <IČO protistrany>] [--ico <IČO klienta, ak nie je v klient.md>]`
5. Doplň do `spis.md` frontmatteru `spisova_znacka`, `sud`, `oblast_prava`, `lehoty` (z uznesení).
6. Over: `scripts/okf-validate.sh "<klient>"` → musí byť `OK`.
7. `scripts/sync_agents_claude.sh "<klient>"` (Drive = kópia).

## Profil B — projekt
1. `scripts/new-projekt.sh "<názov>" [--klient "<voliteľné>"] --root ~/PROJECTS`
2. Doplň `description`, `milestones`, `tags` do `projekt.md`.
3. Over: `scripts/okf-validate.sh "<projekt>"`.
   (CLAUDE.md je symlink — žiadny sync skript netreba.)

## Retrofit existujúceho foldra

Ak používateľ chce **konvertovať / upgradovať EXISTUJÚCI** priečinok klienta, spisu alebo projektu
na OKF štruktúru (nie vytvoriť nový), použij `scripts/retrofit.sh`:

```
scripts/retrofit.sh <typ> <dir> [--title "X"]
  # klient:  [--ico IČO]
  # spis:    [--klient X] [--klient-ico X] [--protistrana X] [--protistrana-ico X] [--oblast X]
  # projekt: [--klient X]
```

- `<typ>` ∈ `klient` | `spis` | `projekt`
- `<dir>` — cesta k **existujúcemu** priečinku (musí existovať)
- **Prísne nedeštruktívne**: vytvára LEN chýbajúce karty a riadiace súbory; nikdy neprepíše, nezmaže ani nepresunie žiadny existujúci súbor, dokument ani podpriečinok.
- **Idempotentné**: opakovateľné volanie nemá vedľajší efekt (existujúce súbory sa preskočia).
- Súbory pridávané podľa typu:
  - `klient` → `klient.md`, `AGENTS.md`, `MEMORY.md`, `CLAUDE.md` (kópia)
  - `spis` → `spis.md`, `_STATUS.md`, `AGENTS.md`, `MEMORY.md`, `CLAUDE.md` (kópia)
  - `projekt` → `projekt.md`, `AGENTS.md`, `MEMORY.md`, `CLAUDE.md` (symlink)

Po retrofit:
1. `scripts/okf-validate.sh "<dir>"` → musí byť `OK`.
2. (len Profil A — klient/spis) `scripts/sync_agents_claude.sh "<dir>"`.

**`--upgrade`**: pridaj tento príznak, ak chceš, aby retrofit **INJEKTOVAL frontmatter aj do EXISTUJÚCICH** riadiacich súborov v1.0, ktoré ho nemajú. Týka sa len fixných rozpoznaných názvov: karta (`klient.md` / `spis.md` / `projekt.md`), `AGENTS.md`, `CLAUDE.md`, `MEMORY.md`, `_STATUS.md`. Telo súboru zostáva **byte-for-byte zachované** (frontmatter sa prepíše iba pred ním). Operácia je idempotentná — súbory, ktoré frontmatter už majú, sa preskočia. Nikdy sa nedotýka dokumentov ani iných `.md` súborov mimo tejto množiny. Bez `--upgrade` retrofit VÝHRADNE vytvára chýbajúce súbory a žiadne existujúce nemení.

**Obmedzenie bez `--upgrade`**: ak existujúci riadiaci súbor (napr. `spis.md`) nemá frontmatter s poľom `type:`, retrofit ho nechá (no-touch) a `okf-validate.sh` ho označí ako chybu — použi `--upgrade` alebo doplň `type:` ručne.

**`--protocol`**: pridaj tento príznak, ak chceš do EXISTUJÚCICH `AGENTS.md`/`CLAUDE.md` doplniť **PROTOKOL ZÁPISU** (partial `templates/partials/protokol-zapisu.md`, marker `okf:protokol-zapisu:v1`). Operácia je **append-only** — partial sa pripojí na koniec súboru, telo zostáva nedotknuté; symlinky (napr. `CLAUDE.md` v Profile B) sa preskočia; ak marker už v súbore je, súbor sa preskočí (idempotentné). Dá sa kombinovať s `--upgrade` v tom istom volaní (`retrofit.sh spis <dir> --upgrade --protocol`).

## Práca v EXISTUJÚCOM spise (zápisová disciplína)

Každý priečinok scaffoldnutý alebo retrofitnutý týmto skillom (od v0.4.0) nesie v `AGENTS.md`/`CLAUDE.md`
**PROTOKOL ZÁPISU** — a agent pracujúci v takom priečinku ho **musí dodržiavať**, nie iba pri zakladaní:
- **fakt** veci → `_STATUS.md` § Fakty veci; **lehota** → `spis.md` frontmatter `lehoty:` + `_STATUS.md` § Lehoty;
  **taktické rozhodnutie** → `MEMORY.md` TP-XXX; **nový dokument** → správny podpriečinok + `_STATUS.md` § Kľúčové dokumenty;
  **komunikácia** (e-mail/hovor/správa) → `_STATUS.md` § Komunikácia; **úloha/záväzok** → `_STATUS.md` § Otvorené úlohy.
- Pred ukončením práce v spise vždy over Fázu/Ďalší krok navrchu `_STATUS.md` a `updated:` frontmatteru zmenených súborov (hard gate v samotnom protokole).
- **Kontrola driftu** (stará `_STATUS.md` oproti novšiemu obsahu v podstrome): `scripts/okf-freshness.sh "<dir>"` → `OK: žiadny drift` (exit 0) alebo `STALE: ...` riadky (exit 1).
- **Doplnenie protokolu do STARÉHO priečinka** (založeného pred v0.4.0): `scripts/retrofit.sh <typ> <dir> --protocol` — append-only, idempotentné, nemení telo súboru.

## Pravidlá (vždy)
- Píš LEN do novovytvorenej (alebo používateľom určenej) zložky. Nikdy nemeň súrodencov.
- Citácie predpisov/judikátov pod `# Citations`, overené cez MCP.
- Linky na zdieľané know-how rob bundle-relative (`/_02_Know_How/...`).
- Po dokončení vypíš používateľovi, čo vzniklo, a navrhni ďalší krok.

<!-- novy-spis:profil-c:v1 -->
## Profil C — korporátny klient (firma)

Použi, keď je „klientom" v skutočnosti **firma** (s.r.o./a.s.) s priebežnou korporátnou a
zmluvnou agendou. Firma = jeden spis s TEMATICKÝM členením (nie ploché kauzy).

**AUTOMAT (SK firma, odporúčané):**
1. MCP ORSR: `orsr_search_entities` (názov/IČO) → `orsr_get_company_profile`.
2. Ulož profil JSON do súboru (napr. `/tmp/orsr.json`).
3. `scripts/firma-from-orsr.sh "<Brand (Obch. meno)>" --klient-dir "<klient-dir>" --orsr-json /tmp/orsr.json [--desc "…"] [--retrofit]`
   → vyplní KOMPLETNÚ kartu (obch. meno, IČO, spis.zn.+súd, sídlo, konatelia, spoločníci +
     podiely, ZI, spôsob konania, posledná závierka) + tematické `1–6`.
4. Kauzy: `scripts/new-kauza.sh "<oblasť 1-6>" "<YYYY-MM Vec – typ>" --firma-dir "<firma-dir>"`
   (Corporate zmeny členíme po rokoch: oblasť `"2 - Corporate/Zmeny v spoločnosti"`).
5. Over `scripts/okf-validate.sh "<klient>"` → `OK`; potom `scripts/sync_agents_claude.sh`.

**Ručne (bez automatu):** `scripts/new-firma.sh "<názov>" --klient-dir DIR --ico ICO --obchodne-meno X --spzn "Sro …/V" --sud "Mestský súd …" --sidlo "…"`.
**Existujúca firma → Profil C:** `scripts/retrofit-firma.sh "<firma-dir>" --ico ICO …` (nedeštruktívne, idempotentné).

### Konvencia zaraďovania dokumentov v kauze (deakcentovane — Drive/macOS NFD)
- `.asice/.xml/.xdc/FUZKUV/eForm` → `6 - KEP-asice | Formuláre`
- „podpis…/signed" → `5 - Skeny | Podpísané dokumenty`
- skeny/obrázky `.jpg/.jpeg/.png/.tif` → `5 - Skeny | Podpísané dokumenty`
- výučný list/vysvedčenie/maturita/OP/podklady od klienta → `1 - Podklady od klienta`
- `.pages/.doc(x)` a pracovné/exportované `.pdf` → `2 - Drafty`
- súdne/správne podania → `7 - Súdne podania`

## Profil C-Z — ZAHRANIČNÁ firma (ORSR NEFUNGUJE)
ORSR pokrýva len SK subjekty. Pre zahraničnú firmu zisti dáta cez oficiálny register krajiny /
**web search** (príp. LinkedIn/OpenSanctions pre KYC), firmu založ cez `new-firma.sh` s ručnými
flagmi a do karty označ zdroj „verified via web" + krajinu. `--spzn/--sud` nechaj prázdne alebo
vlož ekvivalent. TODO (budúce): univerzálny zdroj — komerčná DB (OpenCorporates) alebo vlastný
MCP server pre zahraničné registre → potom `firma-from-<zdroj>.sh` obdobne ako ORSR automat.
