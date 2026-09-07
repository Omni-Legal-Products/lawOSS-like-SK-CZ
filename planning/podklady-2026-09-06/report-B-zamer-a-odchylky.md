# Report B: Zámer OKF a jeho odchýlky (12. 8. → 6. 9. 2026)

- **Pre:** Marián Čuprík (MČ)
- **Spracované:** 2026-09-06 z podkladov v `coord/` (vízia 12. 8., spec 0002, okf-implementacie, agenda a zápis 1. 9., spec 0013/0014/0015, review MF, texty PR #64 a #67) a doplnkovo z `okf-pamat/` (README, OKF-ZHODA, AGENTNI-ZAPISY), textov lawoss PR #24/#31/#35, VŘ dokumentu o kolízii s Google OKF (2. 9.) a plánu ďalších prác (PR #66).
- **Obmedzenie:** lokálny snapshot `okf-implementacie/vr-pamat/` obsahuje iba placeholder. Pôvodnú implementáciu VŘ (memory-manager.md, šablóny, príklady — podľa commitu 891c00f) opisujem nepriamo cez jej nástupcu `okf-pamat` a cez to, ako ju cituje spec 0014 a agenda. Kde neviem, píšem, že neviem.

---

## 1. Pôvodná vízia MČ (call 12. 8. 2026)

Zápis z 12. 8. nehovorí o „dashboarde" ani o „Obsidiane" — tie slová prídu až 28. 8. a 1. 9. Jadro vízie je **pamäť advokáta s človekom ako poslednou inštanciou** a OKF ako organizačný rámec, do ktorého tá pamäť padá.

**Rola človeka a agenta (R1):** „LAWOSS sa navrhuje ako AI-first prostredie. Primárnym vykonávateľom práce je agent, právnik zostáva supervízorom a rozhodovacou vrstvou." GUI „musí prioritne poskytovať prehľad, brány, schvaľovanie a audit."

**OKF ako priorita (R2):** „OKF je hlavná produktová priorita presadzovaná MČ. Správa spisov, pamäť a základné skilly tvoria jadro prvej verzie."

**Tri vrstvy pamäte (R3):** „Pamäť má tri vrstvy: všeobecnú, projektovú alebo spisovú a právnickú. Každá vrstva musí mať vlastný scope, provenance, pravidlá zápisu a schvaľovania."
- L1 všeobecná: preferencie, konvencie, „žiadne automatické povyšovanie jednorazovej úpravy na všeobecné pravidlo."
- L2 spisová: fakty, chronológia, lehoty, úlohy, taktické rozhodnutia, „pravidelná kontrola čerstvosti a úplnosti."
- L3 právnická: overené zdroje a argumentácia, „bez prenosu klientskych údajov", „zákaz odvodiť právnu správnosť iba z opakovaného používateľského správania."

**Human approval ako tvrdé pravidlo (R4):** Reconciliation „porovnáva stav a používateľské úpravy, navrhuje zmeny pamäte, ale nezapisuje ich autonómne bez human approval." A ďalej: „Agent nesmie sám vyhlásiť, že používateľská úprava je lepšia alebo všeobecne správna. Na povýšenie vzoru do L1 alebo L3 treba definovanú metriku, opakovanie a výslovné schválenie."

**Reconciliation lifecycle (8 krokov):** získať stav → porovnať → strojovo čitateľný diff s vysvetlením zdroja → klasifikovať podľa vrstvy → overiť duplicity/konflikt/platnosť/scope → „predložiť návrh právnikovi: schváliť, upraviť, odmietnuť alebo odložiť" → „zapísať iba schválenú zmenu a vytvoriť auditný záznam" → rollback a periodická konsolidácia.

**Onboarding spisu a subjektový research (R5, R6, R9):** pri novom spise conflict a identity check, MCP research v režimoch `light` / `medium` / `hard`, AML, sankcie, „verzovaný markdown report", „periodický rescan a reconciliation" — „idempotentné, merateľné a vratné."

**Architektonické princípy:** R8 „lokálne indexované korpusy, jednoduché vyhľadávanie … pred komplexným RAG"; R10 „Modulárne MCP, skills a CLI nástroje zostávajú oddelené od jadra aplikácie a pripájajú sa cez jednotné kontrakty"; R11 macOS hlavná platforma, „Spoločné jadro a dátové formáty majú zostať prenositeľné tam, kde je to rozumné."

**Priorita prvej verzie:** 1. správa spisov a trojvrstvová pamäť, 2. reconciliation s human approval, 3. skills a MCP pre onboarding a research, 4. fakturácia. Anonymizácia vypadla (R7).

Zhrnuté: advokát mal pracovať tak, že agent robí, systém navrhuje zmeny pamäte v podobe diffu, advokát ich schvaľuje, a všetko je auditovateľné a vratné. „Markdown ako pravda" je v tejto verzii implicitný (verzovaný markdown report, prenositeľné dátové formáty) — explicitne ho vysloví až spec 0002 a README z 28. 8.

## 2. Spec 0002 — čo pridal a konkretizoval

Spec 0002 (navrhnutý 29. 7., rozšírený po 12. 8.) urobil z vízie **produktovú tézu**: „Aplikácia je lepidlo a register (zdroj pravdy), nie monolitický AI engine." A: „AI bez štruktúry len rýchlejšie produkuje neporiadok."

Konkretizácie oproti 12. 8.:

1. **Tabuľka vrstiev so stĺpcom „Schválenie"** — L1 „výslovné potvrdenie pri povýšení nového vzoru", L2 „zápis podľa protokolu spisu, citlivé zmeny s potvrdením", L3 „právna kontrola a zachovaná provenance". Plus zákaz: „L3 nesmie obsahovať klientsky identifikujúce údaje prenesené z L2." Toto je pôvod neskoršej kontroly `L3_LEAK`.
2. **Povinné vlastnosti reconciliation** — idempotentnosť, diff, provenance, „žiadny autonómny zápis do L1 alebo L3", metriky, konsolidácia, rollback.
3. **Onboarding subjektov v 7 krokoch** vrátane „menovcov, nejednoznačné identifikátory, výpadok zdroja, rate limits a čiastočný výsledok. Neoverený alebo nedostupný register sa nesmie prezentovať ako čistý výsledok."
4. **Inventár OKF v0.1** (skill `novy-spis`): profily A/B/C, riadiace súbory, ORSR/RPO audit, retrofit, `okf-validate.sh` + `okf-freshness.sh`, PROTOKOL ZÁPISU.
5. **Zoznam „čo treba doplniť pre produkt":** GUI nad skriptami, konfigurovateľnosť per kancelária, retrofit stoviek spisov, audit trail (immutable log), prepojenie na transkripciu, tri vrstvy, reconciliation skill, subjektový onboarding.
6. **Strategické dôvody:** „Nezávislé od AI módy", „Zdroj pravdy pre agentov — `AGENTS.md`/`CLAUDE.md` v každom spise", „Predajné na workshopoch", „Nekopírovateľné narýchlo".
7. **Rozhodnutie 29. 7.:** „OKF ide von ako open-source — bez obmedzení."
8. **Otvorené otázky**, ktoré sú otvorené dodnes: multi-user, publikovať spec samostatne, kto schvaľuje povýšenie L2→L1/L3, periodicita reconciliation, obsah režimov light/medium/hard, zdieľanie vrstiev v kancelárii.

## 3. Dve implementácie pred zjednotením

README `okf-implementacie/` (28. 8.) stanovil cieľ: „z dvoch reálne používaných implementácií … spraviť jednu zjednotenú OKF špecifikáciu + skills, ktoré budú základom appky (**dashboard spisu renderovaný z markdownov**) aj prenositeľného systému mimo nej." Kritériá: „prenositeľnosť (funguje v opencode/Claude Code/Codex bez appky) · parsovateľnosť pre UI · idempotentné skripty · žiadny zápis bez human gate pri citlivých poliach (ADR 0007)."

### MČ — `mc-novy-spis` (OKF v0.1, skill v0.4.0)

- **Predmet:** priečinok klienta a spisu ako fyzická realita (Drive, Finder). Profil A klient → spis (`YYYY-MM Protistrana - Vec - typ`, oblasti 1–6), Profil B projekt, Profil C firma „ako jeden spis s tematickým členením", C-Z zahraničná firma.
- **Riadiace súbory:** `spis.md` (karta s frontmatterom vrátane `lehoty: []`), `_STATUS.md` označený v šablóne ako **„Status (SSOT)"** so 7 sekciami (Strany, Fakty, Lehoty, Chronológia, Úlohy, Dokumenty, Komunikácia), `MEMORY.md` s TP/LL/OQ číslovaním, `AGENTS.md` + `CLAUDE.md` kópia.
- **PROTOKOL ZÁPISU** ako disciplína v prompte: „čo nezapíšeš, pre budúceho agenta neexistuje"; tabuľka čo-kam; HARD GATE pred ukončením práce (bumpnúť `updated:`, zosúladiť Fázu/Ďalší krok).
- **Kontrola:** `okf-validate.sh` (štruktúra), `okf-freshness.sh` (porovná mtime `_STATUS.md` s najnovším obsahovým súborom → `STALE`), retrofit „prísne nedeštruktívne + idempotentné".
- **Overenie subjektov:** ORSR/RPO cez MCP, „žiadne údaje z hlavy".
- Technicky ~1 097 riadkov bash s testami (spec 0013).

### VŘ — `vr-pamat` → `okf-pamat`

Pôvodný snapshot v scratchpade chýba; podľa názvov súborov z commitu 891c00f (`memory-manager.md`, `sablony/zaznam.md`, príklady `case_…`, `feedback_…`, `reference_…`, `user_preferencie.md`) išlo o **typované záznamy pamäte** s rozlíšením prípad / spätná väzba / referencia / preferencie. Spec 0014 sumarizuje prínos VŘ ako „typované záznamy, retrieval summary, väzby, `Truth` + append-only `History`, vrstvy L1/L2/L3, cyklus LOAD/SAVE/LEARN/REVIEW/EVOLVE a brány v nástroji".

Nástupca `okf-pamat` (PR #24, 318–349 testov): „Žiadna databáza, žiadny index, žiadne embeddingy — markdown v spise." Záznam = jeden súbor s YAML frontmatterom (`type`, `layer`, `jurisdiction`, `status`, `deadlines`…), sekcie `## Truth` (prepisuje sa) a `## History` (append-only). Vrstva sa **odvodzuje z typu**: L1 `rule`/`lesson` (iba človek), L2 `matter`/`decision`/`subject`/`question`/`screening`/`claim`/`evidence`/`task` (agent sám), L3 `authority` (iba človek). Brány v kóde, nie v prompte: atomicita Truth/History, append-only, human gate, zákaz úniku L2→L3, optimistický súbeh. `_STATUS.md` „prepisujeme LEN medzi markermi". Štruktúru spisu „nezakladá ani nemení — to zostáva skillu `novy-spis`."

### Filozofický rozdiel

Agenda 1. 9. to pomenovala presne: „MČ systém rieši životný cyklus klienta, prípadov a reálneho priečinka. VŘ systém rieši granularitu, retrieval, históriu a kontrolovateľnosť pamäte." Inak povedané:

| | MČ | VŘ |
|---|---|---|
| Jednotka pravdy | priečinok + `_STATUS.md` ako SSOT (jeden dokument, sekcie) | záznam (jeden súbor = jeden fakt/rozhodnutie/subjekt) |
| Kde je disciplína | v prompte (PROTOKOL ZÁPISU) a v shell validátore | v knižnici (`planWrite() → applyRecordWrite()`, „Iná cesta na disk nie je") |
| Kto smie zapísať | agent podľa protokolu, hard gate je checklist | strojovo vynútené podľa vrstvy; L1/L3 iba človek |
| Čitateľ | človek v Finderi/Drive, agent cez AGENTS.md | agent cez index + summary; človek cez projekciu v `_STATUS.md` |
| Lokalizácia | SK názvy súborov a polí | pôvodne CZ/SK (`pamet/`, `## Pravda`), od 1. 9. anglické jadro |

Spec 0014 §1 to zhrnul: „Samotný MČ systém rieši priečinky a workflow, ale pamäť nie je dostatočne typovaná. Samotný VŘ systém rieši typovanú a vybaviteľnú pamäť, ale nie celý životný cyklus klienta, prípadov a reálnych priečinkov."

## 4. Call 1. 9. 2026: D1–D9 a O1–O7

Najprv pojmy, laicky:

- **`plan → validate → approve → apply`** — zápis do spisu nejde priamo na disk. Nástroj najprv vyrobí *plán* (čo presne sa zmení), *skontroluje* výsledok proti pravidlám, človek ho *schváli* a až potom sa *aplikuje* — buď celý, alebo nič. Je to softvérová podoba reconciliation lifecycle z 12. 8.
- **Risk-based human gates** — nie každý zápis potrebuje človeka; podľa rizika (lehota, identita klienta, stratégia, L1, L3, mazanie) sa vyžaduje potvrdenie, ostatné (pozorovania, indexy) ide automaticky.
- **`L3_LEAK`** — kontrola, či do zdieľanej právnickej vrstvy (judikáty, argumentačné vzory) nepretieklo IČO, rodné číslo alebo meno klienta zo spisu. Pochádza zo spec 0002 („L3 nesmie obsahovať klientsky identifikujúce údaje"). Nikoho sa nepýta na súhlas, pozerá sa na obsah.
- **SSOT lehôt** — single source of truth: lehota má byť zapísaná na jednom mieste, ostatné sú kópie z neho. Po zjednotení by bola na troch (frontmatter `spis.md`, pole záznamu, tabuľka v `_STATUS.md`).
- **`_STATUS.md` dvojitá pravda** — ak sa do `_STATUS.md` pripojí generovaná sekcia „Lehoty" popri ručnej sekcii „3. Lehoty", existujú dve tabuľky s rovnakým významom a rôznym obsahom.
- **Markery** — HTML komentáre `<!-- okf:render:deadlines:start -->` … `end`, medzi ktoré stroj smie písať; všetko mimo nich je ľudské a nedotknuté.
- **Freshness** — MČ detektor driftu: ak je `_STATUS.md` starší než najnovší dokument v spise, je STALE. Problém: keď stroj prepíše blok medzi markermi, mtime sa obnoví a drift v ručných sekciách sa zamaskuje (úloha 11 VŘ).

### Rozhodovací list D1–D9

| ID | Návrh MČ (agenda) | Výsledok callu (zápis) | Kto namietal / poznámka | Otvorené |
|---|---|---|---|---|
| D1 | Konsolidácia je kanonický smer podmienený technickým specom | ✅ „potvrdené prakticky — ideme stavať OKF Core" | — | mandát zmenený: „testovacie skilly a technický spec paralelne" |
| D2 | `AGENTS.md` bootstrap, `CLAUDE.md` byte-identický mirror | ✅ schválené | mirror „dokým sa Anthropic neznormálnie" | — |
| D3 | Klientsky workspace s viacerými prípadmi | ✅ schválené bez námietok | — | — |
| D4/O6 | Anglický machine contract, lokalizované ľudské výstupy | ✅ schválené | VŘ: bez nosného jazyka „veľký guláš"; obaja autori sa zhodli | mapovacia tabuľka a SK/CZ fixture (MF) |
| D5 | Typované records, `Truth + History`, L1/L2/L3, `lesson` | 🟡 čiastočne | typované záznamy bez námietok; **ústna definícia vrstiev na calle sa líši od písomnej** (L3 = detaily spisu vs L3 = pramene); `Truth + History` „na calle nezaznelo" | bod e) terminológia |
| D6 | Jeden `plan → validate → approve → apply` kontrakt | ❌ zamietnuté | **MČ:** „to by som nechal na človeku… validate, apply a všelijaké tie hlúposti by som tam neriešil"; VŘ bez námietky v zázname | rozsah vs `L3_LEAK` (bod c) |
| D7 | Chránené zmeny vynucuje Core a runtime approval | ❌ zamietnuté | to isté | bod c |
| D8 | PR #24 referenčný prototyp, nie kanonický základ | ⏳ nepreriešené („bod sa zamenil s dashboardmi") | VŘ 2. 9.: „falošný spor" — presun do `lawoss/okf-pamat/`, dva komplementárne balíky | zliať balíky? (7. 9.) |
| D9 | Dashboard odložiť; mandát na technický spec | 🟡 upravené — dashboardy „pokračujú ako vizualizačný add-on nad OKF súbormi" | — | default preset, widgety (spec 0015) |

Mimo listu pribudli rozhodnutia, ktoré agenda nemala: (4) lehoty a chronológia sú súčasť OKF a renderujú sa v `_STATUS.md`; (6) OKF sa invokuje skillom, systémový prompt editovateľný; (7) **opt-out / „tabula rasa"** — „prílišné constraintovanie obmedzuje inteligenciu novších modelov" (MČ); (8) `BRAIN.md` ako „Obsidian-štýl second brain" — budúci add-on; (9) marketplace; (10) MCP lokálne (stdio) a HW limity.

### O1–O7

| ID | Otázka | Návrh MČ | Výsledok | Otvorené |
|---|---|---|---|---|
| O1 | `_STATUS.md` bez dvojitej pravdy | „iba označené generované bloky v existujúcich sekciách, nikdy tichý append" | 🟡 render schválený v princípe | **podmienky MČ neprerokované** (markery do existujúcich sekcií, oprava maskovania driftu, SSOT lehôt, markdown odkazy) — bod g) |
| O2 | Migrácia legacy | jednorazový, nedeštruktívny, idempotentný plán, najprv pilot | ⏳ nepreberané | pilot = akčný bod „konsolidácia reálneho spisu" |
| O3 | Kde žije L1 brain | nechať otvorené | 🟡 AML u klienta bez námietok; `_kancelaria/` nepreberané | súvisí s `BRAIN.md` |
| O4 | Konkurencia | manifest hash, single writer | ⏳ nepreberané | VŘ medzitým implementoval optimistický súbeh (úloha 7) |
| O5 | Publikovať štandard | až po pilote | ⏳ nepreberané | VŘ 2. 9. navrhuje publikovať ako **profil Google OKF** |
| O6 | Anglická schéma | anglický kontrakt | ✅ schválené | — |
| O7 | Kalibrácia únikov | brána zostáva, sprísniť, bez per-record bypassu | ⏳ nepreberané; „technicky z väčšej časti vyriešené opravou N7" | viazané na bod c |

## 5. Spec 0014 a 0015 (PR #64) — kde sú v rozpore so zápisom

PR #64 (MČ, 25 commitov, +7 757 riadkov) vznikol **pred** callom; spec 0014 dostal po calle blok „Stav po calle" s vetou: „Sekcie tohto specu týkajúce sa write pipeline a approval brán sa prepracujú podľa výsledku otvoreného bodu c) zo zápisu; do vyriešenia ich čítaj ako neplatný návrh, nie kontrakt." Telo specu ale zostalo nezmenené, preto Martinov review (mf-review-checklist) uzatvára: „PR #64 neprijímať bez úpravy dokumentácie a bez doplnenia otvorených rozhodnutí. … po calle obsahuje neaktuálne tvrdenia o write pipeline a human gates."

Konkrétne rozpory:

**a) Spec 0014 §9 „Brány zápisu" vs rozhodnutie 5 (D6/D7 zamietnuté).** Spec: „Brány musia byť v OKF Core, nie iba v prompte." a sedem brán vrátane „Whole-store validation: zápis sa aplikuje až po validácii výsledného store", „Atomic apply", „Approval nesmie byť objekt, ktorý si volajúci sám vyrobí. V LAWOSS ho vydá runtime po potvrdení človekom." Zápis: „žiadny `plan → validate → approve → apply` systém ani risk-based human gates … Úpravy zápisov robí človek priamo v markdownoch, prípadne agent na pokyn." MF: „REJECTED AS WRITTEN — z PR/specu odstrániť tvrdenie, že tento ceremoniál je schválený."

**b) Spec 0014 §10 „Human Gate podľa rizika"** so zoznamom „Bez potvrdenia človeka nemožno meniť: právne významné lehoty, identitu klienta …, L1 a L3, kanonický záznam vymazaním" — to je presne risk-based gating, ktorý call zamietol. Zároveň je to najvernejší preklad vízie z 12. 8. (R4). Tu sa MČ na calle odchýlil od vlastného specu aj vlastnej vízie — viď §7.

**c) Spec 0014 §15 „Portable CLI"** (`detect`, `init`, `retrofit`, `validate`, `plan`, `apply`, `reconcile`, `sync`, `migrate`) a cieľ 8 „LAWOSS používa ten istý OKF Core ako portable CLI" vs zápis bod d): „CLI (`okf-cli`) — MČ nie je stotožnený s vytváraním ďalšieho nástroja; všetko má byť čisté markdowny, 100 % prenositeľné. V rozpore s konsolidovaným návrhom."

**d) Spec 0014 §8 „Minimálny záznam"** s `## Truth` / `## History` a tabuľkou histórie vs D5: „`Truth + History` na calle nezaznelo." MF: „CHANGED / DEFERRED — neoznačiť celý bod za schválený."

**e) Spec 0014 P1** vyžaduje, aby `AGENTS.md` obsahoval „human gates" a „validačné a reconciliation kroky" — pri zamietnutí D6/D7 nie je jasné, čo tam má stáť.

**f) Spec 0015 (dashboardy) vs D9 a D6/D7.** Agenda navrhovala „Dashboard sa odkladá"; PR #64 pridal šesť high-fidelity presetov a implementačný plán ešte pred callom. Call to obrátil na „add-on", takže samotná existencia specu 0015 už rozpor nie je. Rozpor je v obsahu: widget `next-decision` „otvorí human gate, sám nezapisuje"; akceptačné kritérium „Human gate zobrazí zdroj, neistotu, diff a revision pred akoukoľvek mutáciou"; diagnostický stav „stale read model alebo stale write plan". MF: „Ak produktový dashboard neskôr zobrazuje human gate, nesmie tým spätne tvrdiť, že tím schválil zamietnutý `plan -> validate -> approve -> apply` protokol."

**g) Spec 0014 §7** pri `_STATUS.md` uvádza „zmiešaný" kanonický status a projekciu „iba medzi stabilné markery v existujúcich očíslovaných sekciách" — to je v súlade s O1, ale podmienky O1 neboli na calle prerokované (bod g), takže spec predbieha rozhodnutie.

Martinov gate pred prijatím PR #64 má 10 položiek; prvá je „spec 0014 odráža zápis z 1. 9. vrátane zamietnutia D6/D7". Tabuľka „Rozhodnutie tímu" je prázdna.

## 6. Spec 0013 (Fáza A) — CLI `okf`, profily, dve generácie

Spec 0013 (MČ, 2. 9., „spracoval Claude Code na pokyn MČ") a lawoss PR #30 vznikli **deň po calle**, na ktorom MČ vyjadril nesúhlas s CLI (bod d). Spec to rieši definíciou, čo CLI *je*: „Malý program, ktorý sa spúšťa v priečinku klienta a vie presne päť vecí" — `detect`, `plan`, `apply` („iba chýbajúce artefakty"), `validate`, `render`. „Súbory dnu, súbory von. Žiadny server, žiadna databáza, žiadna sieť." A kľúčové: „**Ľudská brána je zámerne mimo neho.** CLI vyrobí plán; kto ho zavolal (agent alebo appka), ten ho ukáže advokátovi; `apply` beží až po potvrdení."

Vzťah k pamäti: **žiadny**. Fáza A zakladá štruktúru (prepis bash skriptov `novy-spis` do TypeScriptu bez závislostí, kvôli Windows a prehliadaču), pamäť ostáva `okf-pamat` (VŘ). Ako VŘ napísal v komentári k PR #24: „`@lawoss/okf` (MČ, Fáza A) **zakladá** priečinok spisu, `@lawoss/okf-pamat` **vedie pamäť** vnútri neho. … Prekryv príkazov je jediné slovo `validate`, a každý validuje niečo iné."

**Profily vecí:** spec otvára „dieru, o ktorej konsolidácia mlčí" — v spec 0014 „nie je slovo korporát, IP, RPVS ani insolvencia". Návrh: `matter.type` (litigation · corporate · employment · ip · registration · insolvency · advisory) a `matter.mode` (bounded/ongoing) v `okf.yaml`; „Z ‚lehoty' sa stane všeobecný **termín** s druhom". Je to zovšeobecnenie Profilu C z `novy-spis`.

**Dve generácie OKF** (spec 0013, bod 2): „*OKF v0.1* je formát (Google Open Knowledge Format: Markdown + YAML frontmatter s povinným `type:`, rezervovaný `index.md`) — na ňom stojí skill aj jeho `scripts/`. *OKF 1.0* z konsolidácie 1. 9. je kancelársky kontrakt nad tým (`okf.yaml`, `client.md`, `memory/` records, `evidence/registry/`). Kontrakt 1.0 tím ešte neschválil, preto CLI vo Fáze A stojí na v0.1."

Pozor na jednu vec: spec 0013 stotožňuje MČ „OKF v0.1" s Google formátom, zatiaľ čo VŘ dokument z 2. 9. hovorí, že Google vydal svoj OKF v júni 2026 a „Až doteraz to bola zhoda náhod." Stratégia MČ je datovaná 2026-06-15 (odkaz v SKILL.md). Jedna z týchto dvoch viet je nepresná — buď v0.1 na Google formáte nestojí (a spec 0013 to má opraviť), alebo to nie je náhoda. Neviem, ktorá; treba to vyjasniť pred rozhodnutím o názve.

## 7. Mapa odchýlok

| Pôvodný zámer (12. 8. / spec 0002) | Dnešný stav (6. 9.) | Kto/čo to zmenil | Hodnotenie |
|---|---|---|---|
| **Human approval pri každom zápise do L1/L3**: „nezapisuje ich autonómne bez human approval"; povýšenie „treba definovanú metriku, opakovanie a výslovné schválenie" | Call: D6/D7 zamietnuté („nechal na človeku"). VŘ PR #31: **trvalé poverenie** — advokát raz zapíše do `_kancelaria/okf.config` scope `[L1, L3]` a `expires_at`, zápisy prechádzajú bez potvrdenia, história nesie meno a platnosť poverenia | MČ na calle (zamietnutie ceremónie); VŘ PR #31 (2. 9.) ako naplnenie „agent na pokyn" | **Kompromis so stratou.** Audit trail ostal; požiadavka „metrika + opakovanie" pred povýšením do L1/L3 dnes nikde nie je. Vízia nezakazovala len klikanie, zakazovala aj *automatické* povyšovanie |
| **Reconciliation** ako druhá priorita v1 (diff → návrh → schválenie → audit → rollback) | Spec 0014 §13 (findings `open/accepted/rejected/needs_evidence`) — po calle „neplatný návrh". V kóde: `okf-pamat validate` vracia nálezy, ale reconciliation skill neexistuje; Fáza A ho nemá | zamietnutie D6/D7 mu vzalo mechanizmus; na calle slovo nepadlo | **Strata (zatiaľ).** Najväčšia medzera medzi víziou a dneškom |
| **Dashboard renderovaný z markdownov** (README 28. 8.) | Agenda: odložiť. Call: add-on. Spec 0015: šesť presetov `/prehlad`. VŘ plán C1–C3 (2. 9.): `read.ts` a naplnenie Prehľad/Lehoty reálnymi dátami, read-only | MČ (agenda), tím (call), VŘ (C1–C3) | **Kompromis, smerom k zlepšeniu** — read-only projekcia bez druhej pravdy je v súlade so zámerom |
| **Markdown ako jediná pravda, žiadna DB** | `okf-pamat`: „žiadna databáza, žiadny index"; spec 0014 P3 „LAWOSS je adaptér"; SQLite read model otvorený (bod b) | zachované oboma | **Zachované** |
| **`_STATUS.md` ako SSOT** (šablóna MČ) | Spec 0014: `_STATUS.md` „zmiešaný", projekcia medzi markermi; SSOT lehôt má byť záznam (úloha 13) | konsolidácia MČ + VŘ render | **Zmena významu** — z pravdy na projekciu. Rozumná, ale podmienky O1 nedorozhodnuté a freshness detektor sa tým oslepí (úloha 11) |
| **Tri vrstvy L1/L2/L3** s L3 = právne zdroje | Kód (`okf-pamat`) a spec 0014: L3 = `authority`. Call: ústne L1 = workflows, L2 = klient/prípady, L3 = detaily spisu, „ev. L4" | zaznelo na calle (bod e) | **Riziko** — od toho závisí, čo `L3_LEAK` chráni |
| **`L3_LEAK`** (spec 0002: L3 bez klientskych údajov) | Implementované vo VŘ jadre (hard/strong/weak); po zamietnutí D7 nejasné, či padá (bod c). VŘ námietka: „Nie je to human gate … Chráni mlčanlivosť" | MČ otvoril; VŘ namieta ponechať | **Otvorené — rozhodnutie MČ** |
| **Lokalizované SK/CZ súbory** (`spis.md`, `_STATUS.md`, `pamat/`) | Anglický machine contract (O6): `matter.md`, `memory/`, `## Truth`; ľudské priečinky ostávajú SK/CZ | obaja autori, schválené na calle | **Zlepšenie** — zhoda oboch |
| **Režimy research `light`/`medium`/`hard`** + periodický rescan | Spec 0014: `Basic`/`Extended` + `ask`/`always`/`never`; `okf-pamat screening` má enum `light/medium/hard`, ale „Jadro preverenie nevykonáva"; Fáza A: „Overenie v ORSR nie je jeho práca" | dva slovníky, nikto nevykonáva | **Strata** — vízia R5/R6/R9 dnes nemá implementáciu ani vlastníka |
| **AI-first so štruktúrou** (R1) | Call rozhodnutie 7: **opt-out / tabula rasa** — „prílišné constraintovanie obmedzuje inteligenciu novších modelov" | MČ | **Nový prvok** — v súlade s „kontrola používateľa", ale zápis dodáva: „Kto si OKF vypne … tieto funkcionality stráca — interface to musí dať najavo" |
| **CLI ako oddelený modul** (R10) | Call bod d: MČ proti ďalšiemu nástroju. 2. 9.: MČ sám postavil `okf` CLI (Fáza A). Dnes **dva CLI** (`okf`, `okf-memory`) a **dva konfigy** (`okf.yaml` v spec 0013/0014 vs `_kancelaria/okf.config` u VŘ) | MČ (obrat za 24 h), VŘ | **Nekonzistentné** — vecne v poriadku (komplementárne), ale bod d treba uzavrieť a konfig zjednotiť |
| **Názov OKF** | Kolízia s Google „Open Knowledge Format" (jún 2026) a Open Knowledge Foundation. VŘ navrhuje C: „OKF-legal — profil Open Knowledge Format". `okf-pamat` už deklaruje `memory/` ako bundle Google OKF v0.2 (`okf_version: "0.2"`, `index.md`, `sources[]` s `[^id]`) | VŘ (2.–3. 9.) — implementované pred rozhodnutím 7. 9. | **Kompromis s rizikom** — silný argument (vizualizér zadarmo, interoperabilita), ale vykonaný pred mandátom; „OKF" v spec 0002 znamená niečo iné |
| **`[[wiki-odkazy]]` / Obsidian** | MČ O1c: markdown odkazy (Drive/Finder). VŘ OKF-ZHODA: markdown cesty od 2. 9.; PR #35: pre vault sú `[[…]]` nutné → návrh dialekt v configu | VŘ | **Kompromis** — konfigurovateľný dialekt |
| **`AGENTS.md` ako vstup** | D2 schválené. Navyše `BRAIN.md`: spec 0014 „nie je vstupný protokol", `okf-pamat` README „vstupný bod pre agentov", call: centrálna znalostná báza | VŘ vs MČ definícia | **Drobný rozpor v definícii** |
| **Konfigurovateľnosť per kancelária** (spec 0002) | `okf.yaml` (návrh) / `okf.config` (kód) — pozri vyššie | — | **Rozdvojené** |
| **Retrofit stoviek spisov** (spec 0002) | O2 nepreberané; migrácia TP→decision, LL→lesson, OQ→question naplánovaná (úloha 10), čaká na pilot | — | **Odložené** |
| **Audit trail (immutable log)** | `## History` append-only per záznam; kancelársky `log.md` otvorený (VŘ 2. 9. otázka 4) | VŘ | **Čiastočne** — per záznam áno, naprieč spismi nie |
| **PR #24 ako prototyp** (D8) | technicky vyriešené presunom; „referenčný prototyp" vs „základ" nerozhodnuté | VŘ 2. 9. | **Otvorené** |

## 8. Čo z pôvodnej vízie dnes nikto nerobí

1. **Reconciliation skill** — druhá priorita v1 (12. 8.), s diffom, návrhom, schválením, rollbackom a periodicitou. Po zamietnutí D6/D7 nemá mechanizmus ani vlastníka. VŘ `validate` a `findings` sú najbližší stavebný kameň, ale nie sú reconciliation.
2. **Pravidlá povyšovania L2 → L1/L3** — „definovaná metrika, opakovanie a výslovné schválenie" (12. 8.), otvorená otázka spec 0002 „Ktoré typy poznatkov sa smú povýšiť … a kto to schvaľuje?". Trvalé poverenie (PR #31) otázku obchádza, nerieši.
3. **Subjektový research v režimoch light/medium/hard, conflict check, periodický rescan** (R5, R6, R9). MČ skill robí ORSR audit pri založení; VŘ jadro nesie výsledok screeningu a stráži `AML_EXPIRED`; nikto nevykonáva rescan ani „menovcov, výpadok zdroja, čiastočný výsledok".
4. **Prepojenie transkripcie a výstupov AI do spisu** (spec 0002 „automaticky na správne miesto").
5. **Hromadný retrofit / migrácia** existujúcej praxe — čaká na pilot (O2).
6. **Multi-user** — otvorené od spec 0002; optimistický súbeh vo VŘ jadre je technický základ, politika neexistuje.
7. **Kancelársky audit log naprieč spismi** — iba per-záznam história.
8. **Písomná definícia vrstiev** po calle (bod e) — nikto ju nenapísal; kód medzitým beží na písomnej sémantike.
9. **Slovenská právna vetva** vo VŘ jadre — VŘ opakovane žiada: „Prosím MČ o kontrolu slovenskej vetvy" (AML § 7 zák. 297/2008), slovenské ukotvenie druhov dôkazov (CSP) „zámerne chýba", § 23 ZoA „slovenskú úpravu som neoveroval, doplní MČ".
10. **Windows** (R11, IR) — zápis 1. 9.: IR neprítomný, „Windows/WSL stratégia stále vítané".
11. **Publikácia OKF ako štandardu** (O5) — čaká, a zmenila by sa na profil Google formátu, ak prejde možnosť C.

## 9. Otvorené rozhodnutia, ktoré sú na MČ

Zoradené podľa toho, ako priamo sa dotýkajú pôvodného zámeru.

1. **Bod c — ostáva `L3_LEAK`?** Väzba: spec 0002 (autor MČ) a vízia L3 „bez prenosu klientskych údajov". VŘ námietka (2. 9.) je vecná: kontrola obsahu, nie ceremónia; asymetrická cena chyby; § 21 CZ ZoA / § 23 SK ZoA. Ak MČ trvá na zrušení, VŘ žiada, nech „`zjednotenie.md` prestane tvrdiť štyri brány" a riziko sa zapíše viditeľne.
2. **Rozsah zamietnutia D6/D7 vs vízia R4.** Zamietnutie ceremónie je rozhodnutie MČ; treba ale povedať, či platí aj „žiadny autonómny zápis do L1 alebo L3" zo spec 0002 — a či trvalé poverenie (PR #31, zápis L1/L3 bez potvrdzovania, s expiráciou) je jeho prijateľná podoba. Dnes je PR #31 `mergeable` a nikto z tímu sa k nemu z pohľadu vízie nevyjadril.
3. **Bod e — terminológia vrstiev.** Bez písomného zosúladenia je `L3_LEAK`, `_kancelaria/memory/` aj spec 0014 §8 postavené na sémantike, ktorá na calle ústne zaznela inak.
4. **Bod d — CLI.** MČ sám postavil Fázu A; treba formálne uzavrieť, že CLI so zámerne externou ľudskou bránou nie je v rozpore s „čisté markdowny". Nadväzne: zliať `okf` + `okf-pamat` (D8, 7. 9.) a zjednotiť `okf.yaml` vs `okf.config`.
5. **Bod g — podmienky O1** (markery do existujúcich sekcií, oprava maskovania driftu, SSOT lehôt, dialekt odkazov). Väzba: `_STATUS.md` bol v MČ systéme SSOT; rozhodnutie mení, čo je pravda a čo projekcia. VŘ úlohy 11–13 čakajú; „Rozhodnúť pred migráciou, nie po nej."
6. **Prepis spec 0014 §9, §10, §15 a P1** podľa zápisu (akčný bod MČ „premietnuť rozhodnutia do spec 0014"; Martinov gate č. 1). Dokým to nie je, PR #64 nemá byť prijatý.
7. **Kolízia mena OKF (A/B/C)** a s ňou súvisiace: `sources[]` s atribúciou tvrdení, `okf_version`, `log.md` vs Chronológia, O5 ako profil. Plus vyjasniť tvrdenie spec 0013, že v0.1 „stojí na Google formáte".
8. **Reconciliation a research — kto to vlastní.** Ak ostávajú prioritou v1 podľa 12. 8., treba im vlastníka a mechanizmus; ak nie, treba to povedať a vo vízii to zapísať ako zmenu.
9. **Spec 0015:** default preset, globálny vs per-scope, prvá dávka widgetov; a či Prehľad/Lehoty (v registry vedené na MČ) preberá VŘ plán C1–C3 (jeho otvorená otázka 1: „prevzatie treba potvrdiť").
10. **Slovenská právna kontrola** vo VŘ jadre (AML § 7, § 23 ZoA, dôkazné prostriedky CSP) — VŘ na to výslovne čaká.
11. **Profily vecí** (spec 0013): je `matter.type` povinný, kto vlastní profily, kde vznikne repo `okf`.
12. **Bod b — SQLite read model** — MČ „váha"; súvisí s R8 (lokálne indexy pred RAG) a s princípom „LAWOSS je adaptér".

---

**Jednou vetou:** Štruktúra, prenositeľnosť a markdown-ako-pravda z pôvodnej vízie prežili a zosilneli (anglické jadro, typované záznamy, `AGENTS.md`, dashboard iba ako projekcia); čo sa vytratilo, je *procesná* časť vízie — reconciliation, schvaľovanie zmien pamäte a subjektový research s rescanom — a vytratila sa najmä rozhodnutím MČ z 1. 9. zamietnuť D6/D7, ktoré bolo širšie, než čo z toho tím stihol dorozhodnúť.
