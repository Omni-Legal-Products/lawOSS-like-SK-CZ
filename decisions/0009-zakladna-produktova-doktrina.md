# ADR 0009: Základná produktová doktrína LAWOSS

- **Dátum:** 2026-08-12
- **Stav:** Navrhnuté MČ, čaká na potvrdenie MF, IR a VŘ
- **Navrhol:** Marián Čuprík (MČ)
- **Súvisí s:** [dizajnový spec základnej produktovej doktríny](../docs/superpowers/specs/2026-08-12-lawoss-zakladna-produktova-doktrina-design.md)

## Kontext

LAWOSS má byť otvoreným pracovným prostredím pre českých a slovenských právnikov, nie ďalším uzavretým právnickým produktom. Produktovou hypotézou MČ je riziko uniformity: ak veľká časť trhu používa rovnaký výber modelov, skryté prompty a pracovné postupy uzavretých black box riešení, právna práca sa môže zjednocovať podľa rozhodnutí dodávateľa namiesto rozdielneho know-how jednotlivých kancelárií.

Toto nie je tvrdenie o konkrétnych konkurentoch. Pri verejnej komunikácii sa nesmú bez aktuálneho a doloženého overenia uvádzať fakty o ich cenotvorbe, modeloch ani promptoch. LAWOSS sa má odlišovať vlastnými vlastnosťami a princípmi: kontrolou používateľa, individualizáciou, otvorenosťou a agent-first architektúrou s právnikom ako supervízorom.

> **Your law. Your models. Your knowledge. Your agents.**

## Rozhodnutie

Navrhuje sa prijať základnú produktovú doktrínu LAWOSS postavenú na dvoch pilieroch. Doktrína je záväzným testom pre každé budúce významné produktové rozhodnutie, feature, ADR a partnerstvo po potvrdení MF, IR a VŘ.

### 1. Právnik vlastní svoju inteligenciu

Používateľ má mať kontrolu nad výberom modelov, pomerom kvality, ceny, rýchlosti a súkromia, vlastnými promptmi a skillmi, MCP servermi a dátovými zdrojmi, právnym know-how, pamäťou, automatizáciami, pracovnými postupmi, miestom spracovania a uloženia dát aj auditom práce agenta.

LAWOSS nesmie používateľa uzamknúť na jeden model, jedného dodávateľa ani jednu sadu skrytých promptov. Predvolená konfigurácia môže zjednodušiť začiatok, nesmie však odstrániť možnosť systém pochopiť, upraviť, vymeniť jeho časti alebo ich opustiť.

### 2. Aplikácia sa stavia pre agentov, človek ju riadi

LAWOSS je pracovné prostredie, v ktorom agenti vykonávajú rešerš, organizáciu, kontrolu a prípravu práce. OKF a pamäť udržiavajú kontext, skilly definujú odborné pracovné postupy a MCP servery poskytujú nástroje a overené zdroje. Právnik stanovuje cieľ, kontroluje riziko a schvaľuje výsledok.

Právnik nie je nahradený. Posúva sa do pozície manažéra a supervízora agentov. Rozhranie musí poskytovať riadenie, dohľad, audit a rozhodovanie; rozsah human approval musí zodpovedať riziku úlohy.

### Záväzný produktový test

Každý významný návrh, ADR, feature a partnerstvo musí odpovedať na všetkých šesť otázok:

1. Zvyšuje používateľovu kontrolu nad modelmi, dátami, nástrojmi a know-how?
2. Zachováva možnosť systém pochopiť, upraviť, vymeniť alebo opustiť?
3. Posilňuje schopnosť právnika bezpečne riadiť agentov?
4. Zachováva audit, provenance a primerané human approval?
5. Nevytvára nový povinný black box alebo vendor lock-in?
6. Umožňuje platformám a kanceláriám využiť vlastné výhody bez nútenej uniformity?

Ak návrh v ktoromkoľvek bode zlyhá, výnimka vyžaduje nový ADR s výslovným odôvodnením, mitigáciou a časovým obmedzením. Bez takého ADR sa výnimka neprijíma.

## Zvažované alternatívy

| Alternatíva | Prečo nie |
|---|---|
| Uzavretý jednotný stack | Znižuje kontrolu používateľa, vytvára vendor lock-in a núti rôzne kancelárie pracovať s rovnakými skrytými rozhodnutiami. |
| Nezáväzná vízia | Neposkytuje rozhodovací test ani mechanizmus na posúdenie výnimiek pri budúcich features a partnerstvách. |
| Otvorené modulárne jadro bez spoločnej doktríny | Zachováva technickú otvorenosť, ale bez záväzného smerovania nemusí chrániť individualitu, audit a právnika ako supervízora agentov. |

## Dôsledky

### Pozitívne

- Multi-model výber je základná schopnosť produktu, nie doplnok.
- Skilly, MCP servery a pracovné postupy musia byť prenositeľné a upraviteľné.
- Používateľ musí pri podstatnom výstupe vedieť identifikovať použitý model, nástroj, zdroj a pravidlo.
- Agent-first architektúra má jasné human approval brány podľa rizika.
- Kancelárie, jednotlivci a platformy môžu budovať vlastnú konfiguráciu a zachovať vlastné konkurenčné výhody.
- Komerčné partnerstvo nesmie odobrať komunite možnosť používať, kontrolovať a prispôsobovať otvorené jadro.

### Negatívne a hranice

- Modularita zvyšuje nároky na dokumentáciu, konfiguráciu, bezpečné predvolené nastavenia a podporu kompatibility.
- Nie každý model, integrácia alebo kombinácia workflowov môže byť podporená od prvého vydania.
- Otvorenosť neznamená automatické zverejňovanie klientskych dát ani interného know-how, autonómne právne rozhodovanie bez zodpovedného človeka, bezplatnú infraštruktúru alebo API kredity.
- Výnimka, ktorá obmedzí kontrolu, individualizáciu alebo audit, musí mať samostatný ADR, odôvodnenie, mitigáciu a časové obmedzenie.

## Ďalší postup

Po potvrdení tímom sa doktrína premietne do `docs/vision.md`, `docs/principles.md`, `README.md`, rozhodovacích otázok tímu a kontrolných zoznamov pre PR a feature návrhy.
