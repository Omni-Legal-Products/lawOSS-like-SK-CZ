# Rozhodovací podklad MČ — 6. 9. 2026 (pred callom 7. 9., 10:00)

- **Pre koho:** MČ (pracovný podklad na vlastné rozhodnutia; po rozhodnutí sa z neho stane agenda a zápis)
- **Zdroje:** vízia 12. 8. · spec 0002 · `zjednotenie.md` (VŘ) · `stanovisko-mc.md` a `review-pr24.md` (MČ, 29. 8.) · agenda a zápis 1. 9. · komentáre v coord #66 (výsledky D1, námietka VŘ 2. 9.) · podklad VŘ na 7. 9. (coord #70) · plán C1–C3 (coord #68) · Google OKF (coord #69) · review MF (coord #73) · kód `lawoss/okf-pamat` (stav po PR #35) a `lawoss/okf` (Fáza A) · tri analytické reporty (A: kód VŘ, B: zámer a odchýlky, C: 10 bodov) — report B je v `podklady-2026-09-06/`
- **Ako čítať:** Časť A je zoznam všetkých rozhodnutí naprieč projektom. Časť B je OKF do hĺbky. Časť C sú ostatné oblasti stručne (marketplace, onboarding, dizajn, MCP release). Pri každom rozhodnutí je *odporúčanie* — je to návrh, nie hlasovanie.

---

## Časť A — Plán rozhodnutí (všetko, v poradí)

| # | Rozhodnutie | Kto naň čaká | Kedy | Detail |
|---|---|---|---|---|
| **OKF** | | | | |
| R1 | Čo znamenajú vrstvy L1/L2/L3 (jedna veta, písomne) | VŘ, kód | call 7. 9. | B4/R1 |
| R2 | Rozsah zamietnutia D6/D7: padla ceremónia, alebo aj zásada „L1/L3 zapisuje iba človek"? Je trvalé poverenie (PR #31) prijateľné a za akých podmienok? | VŘ (#31) | call 7. 9. | B4/R2 |
| R3 | `L3_LEAK`: tvrdá validácia / varovanie / policy / zrušiť; prahy do `okf.config` áno/nie | VŘ (úloha 14) | call 7. 9. | B4/R3 |
| R4 | Jeden kontrakt spisu: ako sa zosúladí Fáza A (`okf`) s `okf-pamat` (šablóna `_STATUS.md`, `spis.md`, `AGENTS.md`, `klient.md`, `_kancelaria/`, runtime, verzia bundle) | obaja | call 7. 9. + týždeň | B4/R4 |
| R5 | SSOT lehôt (úloha 13) a oprava driftu (úloha 11) | VŘ | call 7. 9. | B4/R5 |
| R6 | Meno OKF (A/B/C), `log.md`, `EVENT_KINDS` | VŘ, MF (onboarding) | call 7. 9. | B4/R6 |
| R7 | Approve reťaze lawoss #24 → #31 → #35 (s podmienkami) | VŘ | po calle | B4/R7 |
| R8 | Prehľad a Lehoty: preberá VŘ (C1–C3)? Kde je `read.ts`? | VŘ (#68) | call 7. 9. | B4/R8 |
| R9 | Pilot migrácie: čí spis, kedy, kto spúšťa | VŘ | call 7. 9. | B4/R9 |
| R10 | Reconciliation a subjektový research: vlastník, alebo zmena vízie | tím | call 7. 9. | B4/R10 |
| R11 | Prepis spec 0014 (§9, §10, §15, P1) a osud PR #64 a #67 | MF (gate), VŘ | tento týždeň | B4/R11 |
| **Marketplace** | | | | |
| M1 | Review a merge Martinovho PR #36 (katalóg v appke); ide pod Experimenty, alebo ostáva LAWOSS pohľad? | MF | tento týždeň | C1 |
| M2 | Push katalógu do `Omni-Legal-Products/lawoss-marketplace` (repo je prázdne) | nikto, blokuje distribúciu | hneď | C1 |
| M3 | Povýšiť release vetvy 15 MCP repozitárov na default branch? Verejné, alebo private? | — | po M2 | C1 |
| **Onboarding** | | | | |
| O1 | Martinov návrh one-click onboardingu: otvoriť ako PR do coord, určiť termín implementácie vo forku | MF | call 7. 9. | C2 |
| O2 | Light verzia: kedy a kto | MF | neskôr | C2 |
| **Dizajn** | | | | |
| D1 | PR #23 hranaté rohy: rebase a merge | — | tento týždeň | C3 |
| D2 | Logo: ďalšie kolo kombinácií (3·4·11·13 + font 11–14) | tím | — | C3 |
| **Integrácia do appky** | | | | |
| I1 | OKF tab v natívnych Settings; napojenie „Nový spis" na upstream „Add folder" | — (MČ) | tento týždeň | C4 |
| I2 | PATCHES.md: 3 súbory bez záznamu; AGENTS.md forku vs. prax syncu | — (MČ) | tento týždeň | C4 |
| I3 | Upstream sync (od 1. 9. nesledované) | — (MČ) | tento týždeň | C4 |

---

## Časť B — OKF do hĺbky

### B1. Príbeh: ako sme sa sem dostali (12. 8. → 6. 9.)

1. **12. 8. — vízia MČ.** Tri vrstvy pamäte (L1 všeobecná / L2 spis / L3 právnická), **reconciliation s human approval** („nezapisuje autonómne bez human approval"; povýšenie do L1/L3 „treba definovanú metriku, opakovanie a výslovné schválenie"), subjektový research `light/medium/hard` s periodickým rescanom. Priorita v1: 1. spisy + pamäť, 2. reconciliation, 3. skills/MCP na onboarding.
2. **Spec 0002 (MČ).** „L3 nesmie obsahovať klientsky identifikujúce údaje prenesené z L2" → pôvod `L3_LEAK`. „Žiadny autonómny zápis do L1 alebo L3."
3. **28. 8. — OKF = feature #1.** MČ nahrá `novy-spis` (štruktúra spisu, bash, `_STATUS.md` ako SSOT, `MEMORY.md` s TP/LL/OQ), VŘ nahrá pamäťový systém (typované záznamy). Úloha: zjednotiť.
4. **29. 8. — `zjednotenie.md` (VŘ) + PR #24.** Kontrakt: štruktúra od MČ, pamäť ako `memory/<ID>-slug.md` s `## Truth`/`## History`, vrstva plynie z typu, **štyri brány v nástroji, nie v prompte** (atomicita, append-only, human gate do L1/L3, zákaz úniku L2→L3). MČ review: „merge po oprave N1 a N2". MČ stanovisko: **kontrakt prijímam**, podmienky len k O1 (`_STATUS.md`), nové O6 (anglické jadro) a O7 (kalibrácia úniku).
5. **1. 9. — call.** Schválené: anglické jadro, `AGENTS.md` bootstrap, klient s viacerými vecami, lehoty a chronológia z markdownov do `_STATUS.md`, opt-out režim, `BRAIN.md` ako budúci second brain, marketplace, lokálne MCP. **Zamietnuté D6/D7** — MČ: „to by som nechal na človeku… validate, apply a všelijaké tie hlúposti by som tam neriešil." Otvorené: a) D8 (PR #24), c) či padá aj `L3_LEAK`, d) MČ „nie je stotožnený s ďalším CLI", e) vrstvy zazneli ústne inak (L3 = detaily spisu) než sú písomne (L3 = pramene), g) podmienky O1.
6. **2. 9. — obaja stavajú.** MČ: Fáza A (`okf` CLI: detect/plan/apply/validate/render, skill `/novy-spis`, stránka pod Experimentmi; PR #30 merged). VŘ: prijíma zamietnutie D6/D7 a **PR #31 trvalé poverenie** (advokát raz zapíše do `_kancelaria/okf.config`, čo smie agent do L1/L3 sám); presúva jadro do `lawoss/okf-pamat/` a vyhlasuje D8 za „falošný spor"; **namieta ponechať `L3_LEAK`**.
7. **3. 9. — PR #35 + podklad VŘ.** Obsidian vault, zhoda s Google „Open Knowledge Format" v0.2 (implementovaná pred rozhodnutím o mene), test na 10 konaniach z ISIR (9 vád, opravené). 414 testov. Podklad s 10 bodmi na 7. 9.
8. **4. 9. — review MF (coord #73, merged).** PR #64 (spec 0014/0015 od MČ) „neprijímať bez úpravy": spec stále opisuje write pipeline a human gates, ktoré call zamietol.
9. **Dnes.** Reťaz #24 → #31 → #35 čaká na approve MČ. Vo forku od 2. 9. nič nové od MČ (OKF do Settings, Add folder nedokončené). Coord PR #64, #66, #67, #68, #69, #70 otvorené.

**Jednou vetou:** štruktúra, prenositeľnosť a „markdown ako pravda" prežili a zosilneli; procesná časť vízie (reconciliation, schvaľovanie zápisov do pamäte, research s rescanom) sa vytratila — najmä zamietnutím D6/D7, ktoré bolo širšie, než čo tím dorozhodoval, a VŘ ho naplnil trvalým poverením.

### B2. Čo Vojta reálne postavil (`lawoss/okf-pamat`, stav po PR #35)

**Laicky.** Program `okf-memory`, ktorý v priečinku spisu vedie podpriečinok `memory/` s malými markdown kartičkami (jedna kartička = jeden fakt, rozhodnutie, subjekt, dôkaz, úloha, prameň). Každá kartička má hlavičku (anglické kľúče: `type`, `layer`, `jurisdiction`, `status`, `created`, `updated`, `deadlines`…) a dve sekcie: `## Truth` (aktuálna pravda, prepisuje sa) a `## History` (čo sa kedy stalo, iba pridáva). Pri každom zápise program skontroluje sedem vecí a ak niečo nesedí, nezapíše nič. Z kartičiek potom vyrobí tabuľky lehôt a chronológie do `_STATUS.md` (iba medzi HTML markermi), index a denník.

**Presne.**
- **11 typov** (nie 9): L2 `matter, decision, subject, question, screening, claim, evidence, task` · L1 `rule, lesson` · L3 `authority`. Vrstva sa neurčuje ručne, plynie z typu.
- **Tri úrovne na disku:** `_kancelaria/memory/` (L1, L3, `okf.config`) · klient (`subject`, `screening`) · spis (`memory/`, `BRAIN.md`, `_STATUS.md`). Kanceláriu a klienta nástroj hľadá smerom hore (5 a 4 úrovne). **Nič z toho nezakladá** okrem `memory/`, `BRAIN.md` a kostry `_STATUS.md`.
- **Brány pri zápise:** atomicita Truth/History · append-only história · human gate (L1, L3, mazanie) · zákaz úniku do L3 · optimistický súbeh · plus dve nepočítané: `updated` musí byť posunutý (dôsledok: **záznam sa nedá zmeniť dvakrát v ten istý deň**) a kolízia ID v kancelárii.
- **`L3_LEAK`:** jehly z každého `subject` (IČO, rodné číslo, dátum narodenia, číslo dokladu, adresa, meno bez právnej formy) + rodné čísla vo voľnom texte L2; kopa sena = text každého L3 záznamu. `hard`/`strong` = chyba, `weak` (samotné priezvisko) = varovanie. **Slepé miesto:** subjekt s chybou v hlavičke (napr. Obsidian pridá viacriadkový `aliases:`) vypadne z jehiel a brána pre toho klienta ticho oslepne.
- **~25 druhov nálezov** vo `validate` (AML chýba/expirovalo/neúplné podľa § 5 CZ a § 7 SK, `CITATION_UNRESOLVED`, `UNKNOWN_VALUE`, `DEADLINE_PASSED`, `BROKEN_LINK`, `TASK_CYCLE`, `AUTHORITY_STALE`…).
- **Trvalé poverenie (PR #31):** `_kancelaria/okf.config` = holý textový súbor (`standing_authorization`, `expires_at`, `scope: [L1, L3]`, `reason`). Ak existuje a platí, `write` do L1/L3 prejde bez potvrdenia, do History sa zapíše meno a platnosť. Nevypína mazanie, `L3_LEAK`, atomicitu, súbeh. **Ale:** súbor si môže napísať aj agent (vo forku nie je hook, ktorý by to zakázal); poverenie je aktívne aj pre knižničné volanie bez opt-in; `expires_at` sa porovnáva ako reťazec.
- **Google OKF v0.2 (PR #35):** `memory/` je konformný bundle (`index.md` s `okf_version: "0.2"`, `log.md`, `sources[]` s `[^id]`, `verified[]`, `summary`→`description`, neznáme kľúče prežijú). Dve vedomé odchýlky (rozbitý odkaz a neznámy `type` sú chyba).
- **Rozsah:** 3 523 riadkov src, 5 095 riadkov testov, 412 testov, strict TS, node 24, nulové závislosti, bez `--json` výstupu (Fáza A ho má).
- **Slovenské/české v strojovom kontrakte (proti O6):** `EVENT_KINDS = dorucenie, podanie, pojednavanie, rozhodnutie, vyzva, hovor, email`; `_kancelaria`; `klient.md` ako alias; CLI hlášky slovensky; default jurisdikcia `cz`; právne § iba CZ pri dôkazoch.

### B3. Kde sa to reálne trie s tvojou Fázou A (skutočný obsah D8)

VŘ má pravdu, že *príkazy* sa neprekrývajú (jediné spoločné slovo je `validate`). Na úrovni *súborov v jednom priečinku* je trenie konkrétne a dnes by spis založený cez `/novy-spis` s `okf-memory` nefungoval:

| # | Trenie | Dôsledok dnes |
|---|---|---|
| 1 | Šablóna `_STATUS.md` z Fázy A má `## 3. Lehoty`, `## 4. Chronológia` **bez markerov**; retrofit markerov neexistuje ani v jednom balíku | `okf-memory sync` skončí `KONFLIKT`, exit 1 |
| 2 | `spis.md` z Fázy A nemá `jurisdiction:`; má `lehoty: []` | `okf-memory init` bez `--sk` založí slovenský spis ako **cz** (české nadpisy); lehoty na dvoch miestach |
| 3 | Fáza A `validate` (OKF v0.1, koreň = priečinok entity) označí `BRAIN.md`, kostru `_STATUS.md` a `memory/index.md` za chyby; `okf-pamat` je v0.2 s koreňom `memory/` | dva pojmy „bundle", dve verzie |
| 4 | `AGENTS.md` z Fázy A prikazuje písať rozhodnutia do `MEMORY.md` (TP-XXX), lehoty do `spis.md` + `_STATUS.md`; `SKILL.md`/`BRAIN.md` VŘ prikazuje všetko do `memory/`, `MEMORY.md` „čítaj ako archív" | Codex/OpenCode (čítajú `AGENTS.md`) píšu do `MEMORY.md`, Claude Code so skillom do `memory/` → **dve pamäte** |
| 5 | Fáza A vytvára `klient.md`; VŘ kanonický je `client.md`, `klient.md` len alias | kto migruje? |
| 6 | `_kancelaria/` nezakladá nikto; Fáza A ju nepozná; slovenský názov v strojovom kontrakte | L1/L3 skončia v spise bez varovania, ak kancelária neexistuje |
| 7 | Runtime: Fáza A **bun**, okf-pamat **node 24**; dva `package.json` | kto to spustí u advokáta? |
| 8 | Fáza A `render` generuje `klient/index.md`; `okf-memory sync` generuje `klient/memory/index.md` | dva indexy |

### B4. Rozhodnutia s kontextom

#### R1. Vrstvy L1/L2/L3 — jedna veta, písomne

**Otázka.** Na calle 1. 9. si vrstvy opísal ústne ako L1 = ako pracovať (workflows), L2 = klient a prípady, L3 = detaily spisu (ev. L4). Písomne (spec 0002, 0014, kód VŘ) je L1 = pravidlá a poučenia kancelárie, L2 = klient + spis, **L3 = právne pramene zdieľané naprieč spismi**. Od toho závisí, čo chráni `L3_LEAK`.

**Príklad.** Judikát „súhlas vlastníka nie je titulom k stavbe" je L3 (písomne): patrí kancelárii, použije sa v desiatich spisoch, nesmie v ňom byť IČO klienta. Podľa ústnej definície by L3 boli „detaily spisu" a kontrola úniku by nedávala zmysel.

**Odporúčanie.** Potvrdiť písomnú sémantiku (kód na nej stojí, tvoj spec 0002 tiež). Zapísať jednou vetou do zápisu a do `zjednotenie.md`: *L1 = kancelária (pravidlá, poučenia), L2 = klient a jeho veci, L3 = právne pramene a argumentačné vzory bez klientskych údajov.*

#### R2. Rozsah zamietnutia D6/D7 a trvalé poverenie (PR #31)

**Čo si zamietol.** `plan → validate → approve → apply` ako ceremóniu v UI a risk-based human gates („to by som nechal na človeku"). Tvoj spec 0002 ale zároveň hovorí „žiadny autonómny zápis do L1 alebo L3" a vízia 12. 8. „na povýšenie vzoru do L1/L3 treba metriku, opakovanie a výslovné schválenie".

**Ako to VŘ pochopil.** Zrušil `--approve-as` (interaktívne potvrdenie diffu) a nahradil ho **trvalým poverením**: advokát raz zapíše do `_kancelaria/okf.config` „agent smie do L1 a L3 do 31. 12.", odvtedy agent zapisuje poučenia a pramene sám; v histórii ostane stopa. VŘ: „to je doslova agent na pokyn".

**Príklad.** Agent pri práci na spise Novák zistí „súd X vyžaduje plnú moc s overeným podpisom". S poverením zapíše `L-007` do `_kancelaria/memory/` sám. Bez poverenia CLI povie „vyžaduje schválenie človekom" a čaká na `--approve-as "JUDr. …"`.

**Čo VŘ možno nevidí.** (a) Poverenie je textový súbor, ktorý si agent môže napísať sám; hranica je stopa v histórii, nie zámok. (b) Je aktívne aj pre knižničné volanie z appky bez toho, aby volajúci vedel. (c) Vízia nezakazovala len klikanie, zakazovala *automatické povyšovanie* bez metriky — to dnes nikde nie je.

**Možnosti.**
1. Prijať #31 ako je (VŘ). Rýchle; agent je naozaj samostatný.
2. Prijať #31 **s podmienkami**: poverenie je opt-in aj pre knižnicu (appka ho musí explicitne podať), fork zakáže agentovi zápis do `okf.config` (permission/hook), `expires_at` validovaný, scope len L1/L3. Zapísať do zápisu: „ceremónia padla, zásada ‚L1/L3 iba človek alebo výslovné písomné poverenie' platí."
3. #31 nezlúčiť; L1/L3 iba cez `--approve-as` (interaktívne). Najbližšie k spec 0002, ale #35 (Obsidian, ISIR opravy) je postavený na #31 → museli by sa rozpliesť.

**Odporúčanie.** Možnosť 2. Je to tvoja vízia v praktickej podobe: človek rozhoduje, ale raz a písomne, nie pri každom zápise; a nástroj nesmie byť oklamateľný vlastným agentom.

#### R3. `L3_LEAK` a prahy (O7)

**Otázka.** Keď ide zápis do L3 (prameň), nástroj skontroluje, či v texte nie je IČO, rodné číslo, dátum narodenia, adresa alebo meno subjektu z L2. Je to „human gate", ktorý si zamietol, alebo obsahová kontrola mlčanlivosti?

**Fakty.** Pravidlo je z tvojho spec 0002. Nikoho sa nepýta na súhlas, pozerá sa na obsah. Beží iba nad L3; v L2 nič neblokuje (IČO klienta v spise je v poriadku). Kalibrácia podľa tvojho O7 už je (IČO/dátum = chyba, celé meno = chyba, samotné priezvisko = varovanie, zhoda na celé slovo). ISIR test: chytila IČO s vedúcou nulou aj rodné číslo opísané do otázky.

**Príklad.** Agent zapisuje prameň „Súd v konaní proti Alfa s.r.o., IČO 04920040, dovodil, že…" → odmietnuté. Preformuluje na „Súd dovodil, že…" → prejde. „Žalobca Novák namietal premlčanie" → len varovanie.

**Cena chyby.** Falošný poplach = preformulovať vetu. Rodné číslo v zdieľanej vrstve = nedá sa vziať späť; § 23 ZoA (SK) / § 21 zák. 85/1996 Sb. (CZ).

**Odporúčanie.** Ponechať ako tvrdú validáciu (je to tvoje pravidlo, VŘ ho len previedol do nástroja). Dve podmienky: (1) `assertNoLeak` musí **blokovať**, keď niektorý subjekt v scope nie je čitateľný (dnes slepé miesto); (2) prahy do `okf.config` áno, ale iba pre meno/priezvisko, s povinným `reason`; identifikátory nekonfigurovateľné. Doplniť SK § 23 ZoA do dokumentácie (VŘ na to čaká).

#### R4. Jeden kontrakt spisu (Fáza A × okf-pamat)

**Otázka.** Dva balíky môžu ostať (zakladanie vs. pamäť), ale **kontrakt priečinka musí byť jeden**. Kto upraví čo?

**Odporúčanie (rozdelenie práce):**
- **Fáza A (MČ):** šablóna `_STATUS.md` dostane markery vnútri `## 3. Lehoty` a `## 4. Chronológia` (+ voliteľné `evidence_matrix`); `spis.md` dostane `jurisdiction: sk|cz`; `lehoty:` zo `spis.md` von (viď R5); šablóna `AGENTS.md` prepísaná: pamäť = `memory/` cez `okf-memory`, `MEMORY.md` = archív; vytvárať `client.md` (a `klient.md` prestať); `okf validate` prestane kontrolovať frontmatter `memory/index.md` (bundle je v0.2 s koreňom `memory/`).
- **okf-pamat (VŘ):** `init` odmietne spis bez `jurisdiction:` namiesto defaultu `cz`; retrofit markerov (`okf-memory init` do existujúceho `_STATUS.md` append-only, idempotentne); `_kancelaria` → anglický názov (`office/`?) podľa O6, alebo výslovná výnimka; `--json` výstup pre appku.
- **Runtime:** jeden. Návrh: node (bez bun), Fáza A sa prepíše na node testy — malé.
- **D8 formálne:** „dva balíky, jeden kontrakt; zliatie zvážiť po pilote".

#### R5. SSOT lehôt a drift (úlohy 13 a 11)

**Otázka.** Lehota je dnes na troch miestach (`spis.md` frontmatter, `deadlines` v zázname, tabuľka v `_STATUS.md`). Ktoré je pravda? A ako zabrániť, aby `sync` (ktorý prepíše tabuľku a tým obnoví čas súboru) zamaskoval, že ručné sekcie `_STATUS.md` nikto neaktualizoval?

**Príklad.** Rozsudok doručený 2. 9., odvolanie do 17. 9. Advokát 5. 9. zistí, že doručenie bolo 3. 9. a opraví `spis.md` na 18. 9. Záznam a tabuľka ďalej hlásia 17. 9.

**Odporúčanie.**
- **SSOT = záznam** (`deadlines` v `decision`/`matter`), tabuľka v `_STATUS.md` je projekcia, **`lehoty:` zo `spis.md` vypustiť** (nie renderovať do karty — nástroj sa karty nemá dotýkať, a odpadá kolízia s driftom). Do rozhrania: kto zapíše lehotu inam, stráca ju v Lehotách (rozhodnutie 4 z 1. 9.).
- **Drift:** nie manipulácia s mtime (Drive/iCloud/Obsidian ho prepíšu). `okf-freshness.sh` nech porovnáva voči **`updated:` vo frontmatteri `_STATUS.md`**, ktorý už dnes bumpuje iba človek/protokol (HARD GATE v `novy-spis`), a `sync` sa ho nedotýka. Je to tvoj variant 2, ale bez nového poľa.
- Počítanie lehôt (SK/CZ pravidlá IR a VŘ, 42 pravidiel) ostáva mimo jadra: schéma nesie dátum, výpočet robí skill „lehotník".

#### R6. Meno OKF, `log.md`, `EVENT_KINDS`

**Fakty.** Google vydal v júni 2026 „Open Knowledge Format" (OKF): priečinok markdownu s YAML, `type` jediné povinné pole, `index.md`, `log.md`. VŘ už v #35 spravil `memory/` konformným bundle. Spec 0013 tvrdí, že tvoje v0.1 „stojí na Google formáte", VŘ píše o zhode náhod — jedno z toho treba opraviť.

**Možnosti.** A premenovať naše (drahé, stratíme pojem) · B ignorovať (Google vyhrá každé hľadanie) · **C profil**: „OKF pre advokátsku prax, profil Open Knowledge Format" — skratka ostáva, kolízia = kompatibilita, ich vizualizér zadarmo, publikácia štandardu (O5) zlacnie.

**Odporúčanie.** C, s dvomi poznámkami: (1) produktovo môžeme názov OKF používať ďalej, navonok ako „profil"; (2) niekto (VŘ) sleduje ich spec. `log.md` **nechať** (je generovaný, nič nestojí, potrebný pre konformitu). `EVENT_KINDS` **premenovať teraz** ako podmienku approve #35 (`delivery, filing, hearing, decision, notice, call, email`) — každý spis založený medzitým by inak niesol slovenské hodnoty v append-only histórii, ktorú potom migrácia musí porušiť.

#### R7. Approve reťaze #24 → #31 → #35

**Odporúčanie.** Schváliť po calle, keď padnú R1–R3 a R6, s týmito podmienkami zapísanými do PR (follow-up, nie blokátor merge, okrem bodu 1):
1. `EVENT_KINDS` anglicky (pred merge #35).
2. Poverenie: opt-in pre knižnicu; ochrana `okf.config` vo forku; validácia `expires_at`.
3. `assertNoLeak` blokuje pri nečitateľnom subjekte.
4. `init` bez jurisdikcie zlyhá.
5. Oprava textu PR #35 a `OBSIDIAN-VAULT.md` (wiki-odkazy retrahované; `related: [[Subjekty/…]]` by bol `BROKEN_LINK`).
6. `--json` pre appku.
Zároveň do zápisu: bod d) CLI uzavretý („CLI je vykonávateľ, ľudská brána mimo neho; priečinok musí byť čitateľný bez CLI"), D5 `Truth + History` potvrdené.

#### R8. Prehľad a Lehoty (C1–C3), `read.ts`

**Odporúčanie.** Áno, VŘ preberá C1–C3 ako **experiment** (pod Experimentmi, read-only). `read.ts` v `okf-pamat` (číta pamäť). Tvoje presety zo spec 0015 ostávajú dizajnový návrh nad tým istým read modelom; produktová implementácia až po pilote. Agregácia naprieč spismi hneď (Prehľad bez nej nemá zmysel).

#### R9. Pilot migrácie

**Odporúčanie.** Tvoj reálny spis, na **sanitizovanej kópii mimo gitu**, spúšťaš ty lokálne (žiadny DPA problém, ty poznáš tvar `MEMORY.md`). Termín: po merge reťaze a po R5/R6 → cieľ do 14. 9. VŘ dodá migrátor (`TP→D-`, `LL→L-` ako človek s jedným diffom, `OQ→Q-`, markery do `_STATUS.md`). Výstup: sanitizované fixtures do repa.

#### R10. Reconciliation a research — vlastník, alebo zmena vízie

**Fakt.** Druhá a tretia priorita v1 z 12. 8. dnes nemajú mechanizmus ani vlastníka. Dva slovníky režimov (`Basic/Extended` v spec 0014 vs `light/medium/hard` v kóde), nikto research nevykonáva.

**Odporúčanie.** Povedať to nahlas a zapísať zmenu: **v1 reconciliation = `validate` nálezy + človek upravuje markdown** (nie diff/approve pipeline). Subjektový research = skill nad tvojimi MCP (ORSR, RPVS, FS, diskvalifikácie, judikatúra) v jednom slovníku `light/medium/hard`, výsledok do `screening` záznamu; vlastník MČ, po pilote. Periodický rescan = úloha pre neskôr.

#### R11. Spec 0014, PR #64 a #67

**Odporúčanie.** Prepísať §9 (brány → len tie v nástroji: 5 brán + validate), §10 (human gate → „L1/L3 iba človek alebo písomné poverenie"), §15 (CLI → dva nástroje, jeden kontrakt), P1; `Truth + History` potvrdiť. Viem to pripraviť zajtra po calle ako commit do PR #64. #67 (spec 0013) doplniť: opraviť vetu o Google, profily vecí ostávajú otvorené.

### B5. Odporúčané poradie na calle (60 min)

R1 (5) → R3 (10) → R2 (10) → R5 (10) → R6 (5) → R7 (5) → R4 (10, rozdelenie práce) → R8, R9 (5) → R10, R11 písomne, ak nezostane čas.

---

## Časť C — Ostatné oblasti (stručne, detail pri prechádzaní)

### C1. Marketplace

- **PR #36 (MF):** typovaný lokálny katalóg (MCP/skill/CLI/workflow, kanály stable/lab/community/private, jurisdikcie, risk, human gate, `preview-only` inštalácia), 31 súborov, CI zelené, mergeable. Prepisuje tvoju marketplace stránku z fázy B1. Spec + plán sú na Martinovej vetve `codex/okf-konsolidacia` (nezlúčené). Rozhodnúť: (a) merge ako LAWOSS pohľad, alebo presunúť pod Experimenty (pravidlo z 2. 9.: „všetko rozpracované pod Experimenty"); (b) či katalóg v appke má čítať `releases.json` z `lawoss-marketplace` (dnes bundlované natvrdo).
- **Org repo `lawoss-marketplace` je prázdne.** Katalóg (15 položiek) je lokálne v commite d9631fb na vetve `codex/lawoss-release-2026-09-05`. 15 MCP repozitárov je vypushnutých na rovnomennej vetve (15/15 overených). Blokátor (workflow scope) je preč. Rozhodnúť: push katalógu; promócia release vetiev na `main` (história-free vetvy, vyžaduje migračné rozhodnutie); private vs public.

### C2. Onboarding (MF)

- Návrh Fázy 1 one-click onboardingu (28. 8.) je len na vetve `agent/one-click-onboarding`, bez PR, stav „implementácia nezačala". Martin medzitým urobil review PR #64 a marketplace. Rozhodnúť: otvoriť PR z návrhu do coord; termín implementácie vo forku (uvítacia obrazovka s rámčekom „dokončí MF" už existuje); akčný bod z 1. 9. „grafický koncept onboardingu na OKF" nesplnený.

### C3. Dizajn

- PR #23 hranaté rohy (tvoj akčný bod z 28. 8.) otvorený, mergeable neznáme → rebase a merge. Logo: ďalšie kolo kombinácií nikde nezačaté. Design-system.md je živý dokument; hifi `lawoss-hifi.html`.

### C4. Integrácia do appky (MČ)

- Z 2. 9. nedokončené: OKF tab v natívnych Settings, napojenie „Nový spis" na „Add folder". PATCHES.md: bez záznamu `apps/app/src/i18n/index.ts`, `app-root.tsx`, `scripts/i18n-audit.mjs`; `app-sidebar.tsx` má zapísaný len import. AGENTS.md forku hovorí o sync z release tagov, prax je `upstream/dev` → zosúladiť. Upstream sync od 1. 9. neoverený.
