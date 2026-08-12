# Rozhodovacie otázky tímu po calle 2026-08-12

- **Stav:** otvorené na vyjadrenie MČ, MF, IR a VŘ
- **Účel:** uzavrieť produktový, vývojový a prevádzkový rámec LAWOSS
- **Spôsob vyjadrenia:** komentár v PR podľa ID otázky, napríklad `Q01: možnosť A, pretože...`

> [!IMPORTANT]
> Tento dokument nie je prijaté rozhodnutie. Odporúčané voľby sú východiskom na diskusiu. Po zhode sa výsledky prepíšu do ADR, roadmapy alebo príslušného specu.

## Ako hlasovať

Každý člen tímu by mal pri každej otázke uviesť:

1. preferovanú možnosť,
2. jednu krátku vetu s dôvodom,
3. prípadnú podmienku alebo riziko,
4. či vie byť vlastníkom ďalšieho kroku.

Ak niekto nemá názor, uvedie `bez preferencie`. Ticho sa nepovažuje za súhlas.

## A. Riadenie produktu a zodpovednosť

### Q01: Kto je konečný product owner?

- **A:** MČ ako product owner, pri zásadných rozhodnutiach konzultuje tím.
- **B:** spoločné rozhodovanie všetkých štyroch jednomyseľne.
- **C:** iný model.
- **Odporúčanie:** A. Produkt potrebuje jedného rozhodovateľa pri patovej situácii, pričom autorstvo a námietky zostanú zaznamenané.

### Q02: Kto vlastní upstream sync s LegalWorkom?

- **A:** jeden menovaný maintainer + AI agent, druhý člen vykoná review.
- **B:** rotačná zodpovednosť.
- **C:** externý technický maintainer.
- **Odporúčanie:** A, s povinným checklistom a `PATCHES.md`.

### Q03: Kto môže schváliť release?

Navrhované minimum:

- product owner,
- technická verifikácia,
- domain owner funkcií v release,
- osobitný legal alebo security sign-off pri regulovaných workflowoch.

## B. Vetvy, review a release

### Q04: Zostane `dev` integračnou aj default vetvou?

- **A:** áno, kopírujeme upstream LegalWork a stabilitu označujeme tagmi.
- **B:** zavedieme stabilný `main`, `dev` ostane integračný.
- **Odporúčanie:** A počas prvého MVP. Menej odchýlok od upstreamu znamená menej konfliktov.

### Q05: Aké review minimum používame?

- malé docs zmeny: autor môže merge po automatických kontrolách,
- funkčný kód: najmenej jeden ľudský review,
- security, privacy, QES alebo konverzia: domain review + security alebo legal sign-off,
- upstream sync: samostatný PR a regresné testy.

Má byť toto pravidlo záväzné aj tam, kde ho GitHub Free technicky nevynucuje?

### Q06: Čo vydávame v prvej fáze?

- **A:** iba zdrojový kód a návod.
- **B:** nepodpísané testovacie buildy.
- **C:** podpísané a notarizované macOS a Windows buildy.
- **Odporúčanie:** A pre interný vývoj, potom C pre verejný pilot. B iba s výrazným varovaním.

## C. Prvá produktová iterácia

### Q07: Ktoré tri vertikály sú prvé?

OKF a trojvrstvová pamäť sú podľa callu hlavná priorita MČ. Tím má zoradiť ďalšie dve:

- reconciliation s human approval,
- onboarding subjektov + AML research,
- základné spisové skills,
- billing,
- transkripcia,
- OCR ingest,
- lehoty a kalendár.

**Odporúčaná prvá trojica:**

1. OKF + L2 spisová pamäť ako prvý vertikálny rez,
2. reconciliation návrh + schválenie + audit,
3. onboarding subjektov v režime `light` cez existujúce MCP.

L1 a L3 sa majú špecifikovať súbežne, ale prvá implementácia má byť úzka a merateľná.

### Q08: Čo znamená MVP billing?

- **A:** iba časové záznamy a export.
- **B:** čas, sadzby, náklady a podklady pre faktúru.
- **C:** vystavenie účtovného dokladu a napojenie na účtovníctvo.
- **Odporúčanie:** B. Samotné účtovné doklady a integrácie oddeliť do ďalšej fázy.

### Q09: Je anonymizácia formálne vyradená z V1?

- **Navrhované rozhodnutie:** áno, `nice to have`, budúci voliteľný modul.
- **Otázka:** aké podmienky musia nastať, aby sa téma znovu otvorila?

## D. Pamäť a reconciliation

### Q10: Čo presne patrí do L1, L2 a L3?

Tím musí potvrdiť minimálne:

- vlastníka každej vrstvy,
- povolené typy údajov,
- retention a mazanie,
- kto môže čítať a zapisovať,
- pravidlá prenosu medzi vrstvami,
- provenance a verzovanie.

### Q11: Kto schvaľuje povýšenie poznatku?

- L2 do L1,
- L2 do L3,
- lokálny vzor používateľa do kancelárskeho pravidla,
- právny vzor do spoločnej právnickej pamäte.

**Odporúčanie:** žiadne autonómne povýšenie. Agent iba navrhuje a vysvetľuje diff.

### Q12: Aká je periodicita reconciliation?

- pri každej významnej zmene,
- denne,
- týždenne,
- pri uzavretí fázy alebo spisu,
- kombinácia event triggerov a periodickej konsolidácie.

**Odporúčanie:** okamžitý návrh pri významnej udalosti + týždenná konsolidácia + finálna kontrola pri uzavretí veci.

### Q13: Aké metriky rozhodnú, že reconciliation funguje?

Navrhované minimum:

- počet navrhnutých, schválených, upravených a odmietnutých zmien,
- false promotion rate,
- duplicity a konflikty,
- čas potrebný na ľudskú kontrolu,
- úspešnosť rollbacku,
- úplnosť provenance.

## E. Subjekty, AML a registre

### Q14: Čo obsahujú režimy `light`, `medium` a `hard`?

Treba určiť:

- povinné registre pre SK, CZ a neskôr PL,
- sankčné a diskvalifikačné zdroje,
- riešenie menovcov,
- timeout a čiastočný výsledok,
- cenu alebo limit dotazov,
- frekvenciu re-scanov,
- formát a retention reportu.

### Q15: Je AML onboarding vlajková feature alebo súčasť OKF?

- **A:** samostatná marketingová feature.
- **B:** workflow vo vnútri OKF intake.
- **Odporúčanie:** B architektonicky, A môže byť marketingové pomenovanie používateľského scenára.

## F. Dáta, modely a platformy

### Q16: Musia klientské dáta zostať lokálne?

Treba rozhodnúť zvlášť pre:

- originálne dokumenty,
- L2 spisovú pamäť,
- L1 preferencie,
- L3 právnickú pamäť,
- telemetriu a crash reporty,
- zálohy.

### Q17: Je lokálny index predvolený a RAG iba voliteľný?

- **Navrhované rozhodnutie:** áno pre prvú verziu.
- **Doriešiť:** veľkosť korpusu, aktualizácie, licencie, citačný graph, distribúcia a diskové limity.

### Q18: Ktoré platformy podporujeme?

- macOS,
- Windows,
- Linux,
- ktoré CLI integrácie môžu zostať macOS-only: Apple Notes a Reminders,
- čo musí mať platformovo neutrálny fallback.

### Q19: Patrí Poľsko do prvej architektúry?

- **A:** od začiatku neutralizovať dátové modely pre SK/CZ/PL, implementovať iba SK/CZ.
- **B:** riešiť PL až po stabilnom SK/CZ MVP.
- **Odporúčanie:** A na úrovni schém a kontraktov, B na úrovni prvých integrácií.

## G. Regulované a citlivé workflowy

### Q20: Kto vykonáva sign-off?

Osobitne určiť vlastníka pre:

- privacy a pamäťové hranice,
- AML metodiku,
- QES a autorizáciu,
- zaručenú konverziu,
- licencie dát a tretích strán,
- release security.

### Q21: Aký human-in-the-loop model je záväzný?

Ktoré akcie agent:

- môže urobiť autonómne,
- môže pripraviť, ale nie vykonať,
- nesmie urobiť vôbec,
- musí zapísať do nemenného audit logu?

## H. Open source, financovanie a komunita

### Q22: Je celý softvér a všetky základné moduly bezplatné?

Call otvoril otázku hranice medzi free a plateným. Treba zosúladiť s existujúcim rozhodnutím, že monetizácia je cez školenia a workshopy, nie SaaS.

Možnosti:

- všetok kód a základné moduly open source, platené iba školenia a implementačná pomoc,
- open core a platené moduly,
- platené hostovanie alebo distribúcia.

### Q23: Čo publikujeme späť komunite?

- SK a CZ lokalizácie,
- všeobecné opravy LegalWorku,
- modulové rozhranie,
- OKF špecifikácia,
- skills,
- MCP servery,
- datasety a indexy s vyjasnenou licenciou.

## Návrh výstupu z diskusie

Po uzavretí PR vzniknú samostatné ADR pre:

1. governance a product ownership,
2. branching, review a release model,
3. scope prvej iterácie,
4. pamäťové hranice a reconciliation approval,
5. lokálnosť dát a platformová podpora,
6. monetizáciu a open-source hranicu.
