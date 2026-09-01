# Zápis: call 1. 9. 2026 — OKF architektúra, anglické jadro, dashboardy a MCP

- **Prítomní:** MČ · VŘ · MF *(IR neprítomný — tento zápis + Telegram post sú pre neho; jeho požiadavka na lehoty je pokrytá, viď rozhodnutie 4)*
- **Podklady:** [agenda](2026-08-31-agenda-okf-architektura.md) · [prezentácia](../assets/diagrams/okf-konsolidacia.html) · [spec 0014](../specs/0014-okf-1-kanonicky-kontrakt.md) · [zjednotenie.md](../research/okf-implementacie/zjednotenie.md) (PR #63) · [stanovisko MČ](../research/okf-implementacie/stanovisko-mc.md) · plán ďalších prác (PR #66)
- **Zdroj:** transkript callu + AI sumarizácia (lokálne u MČ), zapísané 2026-09-01. *(Pozn.: AI sumarizácia chybne uvádza ďalší call o 10:30 a rozpisuje MCP ako „Metacognitive Prompts" — smerodajný je transkript.)*

> [!NOTE]
> Call sa neriadil striktne rozhodovacím listom D1–D9 z agendy — prebehol voľnejšie. Výsledky sú do listu premietnuté nižšie; body, ktoré na calle reálne nezazneli, sú poctivo označené ako otvorené, nie dohlasované dodatočne.

## Rozhodnutia

1. **Anglické jadro schválené (O6 / D4).** Machine contract — kľúče, hodnoty enumov, názvy systémových súborov (`status`, `memory`, `index`…) — bude výhradne anglický ako „tretí nosný technický jazyk" popri SK/CZ obsahu. Lokalizácia sa deje až na úrovni klientskeho rozhrania; úpravy systému sa robia raz, nie per jazyk. *(VŘ: bez jedného nosného jazyka by bol spis „veľký guláš"; MČ: systém jednotný pre každého, preklady na úrovni klienta.)*
2. **`AGENTS.md` ako kanonický bootstrap a index, `CLAUDE.md` byte-identický mirror (D2).** V koreňovom priečinku klienta = rozcestník/prehľad spisov; v koreni spisu = spisový prehľad. Mirror zostáva, „dokým sa Anthropic neznormálnie". Základ prenositeľnosti.
3. **Klientsky workspace s viacerými prípadmi (D3).** Spoločná identita klienta, izolovaný stav každého prípadu. Schválené bez námietok.
4. **Lehoty a chronológia sú súčasť OKF, nie samostatný systém.** Všetky takéto informácie sa ťahajú z markdown súborov; lehoty a chronologické zápisy sa renderujú v `_STATUS.md`. Tým je pokrytá aj Igorova skoršia požiadavka na sledovanie lehôt. Kto si OKF vypne alebo doň „bastlí", tieto funkcionality stráca — interface to musí dať najavo.
5. **D6/D7 zamietnuté — žiadny `plan → validate → approve → apply` systém ani risk-based human gates.** Rozhodol MČ na calle („to by som nechal na človeku… validate, apply a všelijaké tie hlúposti by som tam neriešil"); VŘ bez námietky v zázname. Úpravy zápisov robí človek priamo v markdownoch, prípadne agent na pokyn. *Dôsledok: mení podstatnú časť konsolidovaného návrhu (spec 0014) aj plánu v PR #66 — viď otvorený bod c) o rozsahu.*
6. **OKF sa invokuje skillom** (operatívne rozhodnutie, návrh VŘ) — tvarovateľné používateľom. Systémový prompt bude editovateľný s rozumným defaultom; pri zapnutom OKF sa súbory nového prípadu generujú automaticky.
7. **Opt-out / „tabula rasa" režim schválený.** Používateľ musí vedieť pracovať aj mimo OKF constraintu — switch „nečítaj `AGENTS.md`" / „prečítaj len časť", čistý model bez kontextu spisu, prípadne napojenie vlastného Obsidianu. Dôvod (MČ): prílišné constraintovanie obmedzuje inteligenciu novších modelov.
8. **`BRAIN.md` — centrálna kancelárska znalostná báza ako budúci add-on feature.** Obsidian-štýl second brain nad všetkými klientmi a spismi: zaujímavé zistenia s reťazenými markdown odkazmi na zdroj (`BRAIN.md` → `AGENTS.md` prípadu → záznam), 100 % prenositeľné, v Obsidiane sa prepojenia načítajú automaticky. Škálovanie pri veľkom objeme zostáva otvorené.
9. **LAWOSS marketplace.** Skills, MCP servery a pluginy sa budú distribuovať cez vlastný marketplace (spravovaný GitHub repozitár s automatickými updatmi, po vzore LegalWork/opencode) pre Claude Code, Codex a ďalšie harness-y. Default sada per jurisdikcia sa vyberie pri onboardingu (basic/advanced otázka pri zakladaní spisu); čo najmenej proprietárnych vecí. Kandidáti do základu: SlovLex, judikatúra, CLI na Apple/Google/Outlook nástroje.
10. **MCP lokálne + hardvérové limity treba riešiť od začiatku.** MCP servery pôjdu ako lokálne (stdio); MČ svoje prerobí z webových na lokálne. VŘ upozornil, že lokálne právne databázy môžu byť pamäťovo extrémne náročné (jeho odhad z vlastnej praxe: až 50–60 GB; neoverené) a bežný počítač ich neutiahne — protipríklad MČ: jeho judikatúrne MCP beží na serveri s ~2 GB RAM, fork LAWOSS bez konektorov zaberá ~631 MB (meranie MČ). Záver: otestovať reálne zaťaženie forku s napojenými MCP na strojoch tímu, používateľom jasne komunikovať HW špecifikácie a ponúkať odľahčené odporúčané varianty (napr. SlovLex ťahajúci live dáta bez ukladania).

## Otvorené body (dorozhodnúť písomne alebo na calle 7. 9.)

- **a) D8 — postavenie PR #24** sa na calle nepreriešilo (bod sa zamenil s dashboardmi v PR #64 a téma sa už nevrátila). Dorozhodnúť v diskusii k PR #66 alebo na najbližšom calle.
- **b) SQLite ako regenerovateľný read model** — MČ váha (komplikácia navyše vs. lightweight a agentom zrozumiteľné). Nerozhodnuté.
- **c) Rozsah zamietnutia D6/D7 vs. kontrola `L3_LEAK`.** Zamietnutie mierilo na approval ceremóniu, no kontrola úniku klientskych identifikátorov do zdieľanej vrstvy pochádza z MČ [spec 0002](../specs/0002-okf-operacny-system-praxe.md) a chráni mlčanlivosť (§ 23 ZoA). Treba explicitne povedať, či padá aj ona, alebo zostáva ako jediná validácia.
- **d) CLI (`okf-cli`)** — MČ nie je stotožnený s vytváraním ďalšieho nástroja; všetko má byť čisté markdowny, 100 % prenositeľné. V rozpore s konsolidovaným návrhom — dorozhodnúť.
- **e) Terminológia vrstiev L1/L2/L3.** Ústna definícia z callu (L1 = ako pracovať / operačné workflows, L2 = klient a prípady, L3 = detaily spisu, ev. L4) sa líši od písomnej sémantiky v spec 0002/0014 (L3 = pramene/authority). Zosúladiť písomne pred implementáciou — závisí od toho aj význam `L3_LEAK`.
- **f) Škálovanie centrálneho `BRAIN.md`** pri veľkom objeme zistení.
- **g) Podmienky MČ k O1** (markery do existujúcich sekcií, oprava maskovania driftu, SSOT lehôt, markdown odkazy) sa na calle neprerokovali — render lehôt a chronológie je schválený v princípe (rozhodnutie 4), detaily dorozhodnúť písomne.

## Rozhodovací list D1–D9 — výsledky

| ID | Rozhodnutie (podľa agendy) | Výsledok callu |
|---|---|---|
| D1 | Konsolidácia je kanonický smer podmienený technickým specom | ✅ potvrdené prakticky — ideme stavať OKF Core; mandát viď nižšie |
| D2 | `AGENTS.md` bootstrap + `CLAUDE.md` mirror | ✅ schválené |
| D3 | Klientsky workspace s viacerými prípadmi | ✅ schválené |
| D4 | Anglický machine contract, lokalizované ľudské výstupy | ✅ schválené (= O6) |
| D5 | Typované records, `Truth + History`, vrstvy, `lesson` | 🟡 čiastočne — typované záznamy a vrstvy bez námietok, terminológia vrstiev sa musí písomne zosúladiť (otvorený bod e); `Truth + History` na calle nezaznelo |
| D6 | Jeden `plan → validate → approve → apply` kontrakt | ❌ zamietnuté (rozhodnutie 5) |
| D7 | Chránené zmeny vynucuje Core a runtime approval | ❌ zamietnuté (rozhodnutie 5); rozsah vs. `L3_LEAK` otvorený (bod c) |
| D8 | PR #24 ako referenčný prototyp | ⏳ nepreriešené (otvorený bod a) |
| D9 | Dashboard odložiť; mandát MČ na technický spec | 🟡 upravené — dashboardy pokračujú ako vizualizačný add-on nad OKF súbormi (varianty v PR #64, osobné dashboardy); **mandát: testovacie skilly a technický spec paralelne** |

## Stav otázok O1–O7 (číslovanie podľa agendy)

| ID | Otázka | Výsledok |
|---|---|---|
| O1 | `_STATUS.md` bez dvojitej pravdy | 🟡 render lehôt a chronológie schválený v princípe; podmienky MČ dorozhodnúť (bod g) |
| O2 | Migrácia legacy | ⏳ nepreberané priamo; pilot = akčný bod „konsolidácia reálneho spisu" |
| O3 | Kde žije kancelársky brain | 🟡 AML u klienta (návrh VŘ z 31. 8. bez námietok); `_kancelaria/` nepreberané; súvisí s `BRAIN.md` (rozhodnutie 8) |
| O4 | Multi-user | ⏳ nepreberané |
| O5 | Publikovať štandard | ⏳ nepreberané |
| O6 | Anglická perzistenčná schéma | ✅ **schválené** (rozhodnutie 1) |
| O7 | Kalibrácia kontroly únikov | ⏳ nepreberané na calle; technicky z väčšej časti vyriešené opravou N7, formálne potvrdenie viaže na otvorený bod c |

## Akčné body (do pondelka 7. 9.)

- [ ] **MČ** — rozposlať zhrnutie porady; s VŘ dopracovať **testovacie varianty OKF skillu (1/2/3)** a otestovať na reálnych podkladoch: založenie nového spisu + konsolidácia existujúceho spisu (PDF, DOCX…); finalizovať dashboardy v PR #64; prerobiť svoje MCP na lokálne (stdio); zapísať výsledky brány D1 komentárom do PR #66; premietnuť rozhodnutia do spec 0014; vygenerovať a poslať prístupy k mail/kalendár službám lawoss.app
- [ ] **VŘ** — s MČ dopracovať a otestovať varianty OKF skillu na reálnych prípadoch; skompilovať/updatnúť fork LAWOSS, napojiť lokálne MCP (SlovLex, judikatúra) a zmerať zaťaženie RAM; zvážiť Claude Team s DPA na prácu s live prípadmi (odporúčanie MČ; VŘ presunie na IČO)
- [ ] **MF** — navrhnúť **grafický koncept onboardingu na OKF** (scény, diagramy, videá alebo ukážky interface); vyskúšať OKF na testovacom foldri; tiež otestovať fork + lokálne MCP a zaťaženie RAM
- [ ] **IR** *(async)* — pozrieť zápis; pridať sa k testovaniu OKF (avizoval vlastné systémy); pripomienky k logu a Windows/WSL stratégii stále vítané; sledovanie lehôt je pokryté rozhodnutím 4
- [ ] **všetci** — písať priebežne skúsenosti do Telegramu

**Ďalší call: pondelok 7. 9. 2026, 10:00–11:00** *(dohodnuté v závere callu; VŘ budúci týždeň inak nemôže, MF preferoval dopoludnie)*.

<sub>Zapísal MČ s AI asistenciou z transkriptu 2026-09-01.</sub>
