# LAWOSS: základná produktová doktrína

- **Dátum:** 2026-08-12
- **Autor návrhu:** Marián Čuprík (MČ)
- **Stav:** schválený MČ, čaká na tímové posúdenie MF, IR a VŘ
- **Účel:** určiť nadradený dôvod existencie LAWOSS a test pre budúce produktové rozhodnutia

## Jadro vízie

LAWOSS dáva právnikom úplnú kontrolu nad ich AI. Je to otvorené pracovné prostredie vytvorené pre AI agentov a riadené právnikom. Každá kancelária si môže zvoliť vlastné modely, skilly, MCP servery, zdroje, pamäť a pracovné postupy.

Projekt nemá vytvoriť ďalší uzavretý black box. Má zachovať individualitu právnej práce a umožniť, aby sa vlastné know-how, spôsob uvažovania a pracovné postupy kancelárie stali jej konkurenčnou výhodou.

> **Your law. Your models. Your knowledge. Your agents.**

## Dva piliere

### 1. Právnik vlastní svoju inteligenciu

Používateľ má mať pod kontrolou:

- výber modelu pre konkrétnu úlohu,
- pomer kvality, ceny, rýchlosti a súkromia,
- vlastné prompty a skilly,
- vlastné MCP servery a dátové zdroje,
- právne know-how kancelárie,
- pamäť, automatizácie a pracovné postupy,
- miesto spracovania a uloženia dát,
- audit toho, čo agent urobil, z akých zdrojov vychádzal a prečo.

LAWOSS nesmie používateľa uzamknúť na jeden model, jedného dodávateľa ani jednu sadu skrytých promptov. Predvolená konfigurácia môže zjednodušiť začiatok, ale nesmie odstrániť možnosť porozumieť systému, vymeniť jeho časti a prispôsobiť ho.

### 2. Aplikácia sa stavia pre agentov, človek ju riadi

LAWOSS nie je tradičná právnická aplikácia doplnená o chat. Je to pracovné prostredie, v ktorom:

- agenti vykonávajú rešerš, organizáciu, kontrolu a prípravu práce,
- OKF a pamäť udržiavajú kontext,
- skilly definujú odborné pracovné postupy,
- MCP servery poskytujú nástroje a overené zdroje,
- právnik stanovuje cieľ, kontroluje riziko a schvaľuje výsledok,
- rozhranie poskytuje riadenie, dohľad, audit a rozhodovanie.

Právnik nie je nahradený. Posúva sa z pozície manuálneho vykonávateľa do pozície manažéra a supervízora agentov. Rozsah ľudského schválenia musí zodpovedať riziku úlohy.

## Problém, ktorý projekt rieši

MČ pomenoval ako produktovú hypotézu riziko uniformity uzavretých právnych AI riešení. Ak veľká časť trhu používa rovnaký výber modelov, rovnaké skryté prompty a rovnaké pracovné postupy, právna práca sa môže zjednocovať podľa rozhodnutí dodávateľa.

LAWOSS ponúka opačný smer:

- otvorené a kontrolovateľné stavebné prvky,
- možnosť použiť rozdielne modely podľa náročnosti úlohy,
- prenositeľné know-how vo forme skillov a workflowov,
- vlastné integrácie a servery,
- schopnosť veľkej kancelárie, malej praxe aj jednotlivca vytvoriť si vlastnú konfiguráciu.

Tvrdenia o cenotvorbe, modeloch alebo promptoch konkrétnych konkurentov sa nesmú komunikovať ako fakty bez aktuálneho a doloženého overenia. Verejná komunikácia sa má sústrediť na vlastnosti a princípy LAWOSS, nie na neoverené hodnotenie iných produktov.

## Záväzný produktový test

Každý významný návrh, ADR, feature a partnerstvo má odpovedať na tieto otázky:

1. Zvyšuje používateľovu kontrolu nad modelmi, dátami, nástrojmi a know-how?
2. Zachováva možnosť systém pochopiť, upraviť, vymeniť alebo opustiť?
3. Posilňuje schopnosť právnika bezpečne riadiť agentov?
4. Zachováva audit, provenance a primerané human approval?
5. Nevytvára nový povinný black box alebo vendor lock-in?
6. Umožňuje platformám a kanceláriám využiť vlastné výhody bez nútenej uniformity?

Ak návrh v niektorom bode zlyhá, musí obsahovať výslovné odôvodnenie, mitigáciu a časové obmedzenie výnimky.

## Dôsledky pre produkt

- Multi-model výber je základná schopnosť, nie doplnok.
- Skilly, MCP a pracovné postupy musia byť prenositeľné a upraviteľné.
- Rozumné predvolené nastavenia sú vítané, ale nesmú sa stať nepriehľadným obmedzením.
- Agent-first architektúra musí mať jasné human approval brány podľa rizika.
- OKF a tri vrstvy pamäte sú kontextovým jadrom agentov.
- Používateľ musí vedieť identifikovať model, nástroj, zdroj a pravidlo použité pri podstatnom výstupe.
- Integrácie špecifické pre macOS alebo Windows sa môžu rozvíjať samostatne.
- Komerčné partnerstvo nesmie odobrať komunite možnosť používať, kontrolovať a prispôsobovať otvorené jadro.

## Hranice

Otvorenosť neznamená:

- automatické zverejňovanie klientskych dát alebo interného know-how,
- autonómne právne rozhodovanie bez zodpovedného človeka,
- podporu každého modelu a každej integrácie od prvého vydania,
- absenciu bezpečných predvolených nastavení,
- povinnosť poskytovať bezplatnú infraštruktúru alebo API kredity.

## Tímové rozhodnutie

Tím má výslovne rozhodnúť:

> Prijímame kontrolu používateľa, individualizáciu, otvorenosť a agent-first architektúru s právnikom ako supervízorom za záväznú produktovú doktrínu LAWOSS a za test všetkých budúcich významných rozhodnutí?

Možnosti:

- **A:** áno, ako záväznú doktrínu; výnimka vyžaduje ADR s odôvodnením a mitigáciou,
- **B:** áno, iba ako nezáväznú víziu,
- **C:** nie; uviesť, ktorý princíp alebo dôsledok tím odmieta.

**Odporúčanie MČ:** A.

## Navrhované následné zapracovanie

Po tímovom potvrdení sa doktrína premietne do:

1. `docs/vision.md` ako hlavný dôvod existencie produktu,
2. `docs/principles.md` ako záväzné produktové pravidlá,
3. nového ADR, ktoré zaznamená rozhodnutie a výnimkový proces,
4. `README.md` ako stručná verejná formulácia,
5. rozhodovacích otázok tímu ako nová otázka s vlastným ID,
6. PR a feature šablón ako kontrolný checklist.

## Kritériá úspechu

- nový člen tímu vie po prečítaní dokumentácie vysvetliť, prečo LAWOSS existuje,
- každá významná feature uvádza dopad na kontrolu, otvorenosť a agent-first workflow,
- používateľ môže overiť, čo systém použil na podstatný výstup,
- výmena modelu alebo nástroja nevyžaduje opustenie celého pracovného prostredia,
- externá komunikácia používa konzistentnú pozitívnu formuláciu bez neoverených tvrdení o konkurencii.
