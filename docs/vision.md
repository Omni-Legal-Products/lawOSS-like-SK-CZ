# Vízia

**LAWOSS dáva právnikom úplnú kontrolu nad ich AI.**

LAWOSS je otvorené pracovné prostredie pre českých a slovenských advokátov. Staviame ho na [LegalWork](https://github.com/eigenweltlabs/legalwork), zvolenom MIT základe s open-code harnessom v pozadí. Rozhodnutie o základe zachytáva [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md).

Nie je to ďalší uzavretý AI editor dokumentov, ale operačný systém advokátskej praxe: organizácia spisov a poriadok v praxi ([OKF](../specs/0002-okf-operacny-system-praxe.md)), doplnené o modely, skilly, MCP servery a overené zdroje podľa voľby kancelárie.

## Dva piliere

### Právnik vlastní svoju inteligenciu

Právnik má mať kontrolu nad tým, ako AI pracuje a s čím pracuje. To zahŕňa výber modelu podľa kvality, ceny, rýchlosti a súkromia, vlastné prompty a skilly, MCP servery a dátové zdroje, právne know-how, pamäť, automatizácie, workflowy, miesto spracovania a uloženia dát aj audit práce agenta.

Predvolené nastavenia majú pomôcť začať, nie vytvoriť povinný black box. Používateľ musí vedieť systém pochopiť, upraviť, vymeniť jeho časti alebo ho opustiť bez núteného vendor lock-in.

### Aplikácia sa stavia pre agentov, človek ju riadi

Agenti vykonávajú rešerš, organizáciu, kontrolu a prípravu práce. OKF a pamäť udržiavajú kontext, skilly definujú odborné postupy a MCP servery poskytujú nástroje a overené zdroje.

Právnik stanovuje cieľ, určuje prijateľné riziko a schvaľuje výsledok. Nie je nahradený, ale je manažérom a supervízorom agentov. Rozhranie preto musí podporovať riadenie, dohľad, audit a rozhodovanie, pričom rozsah human approval zodpovedá riziku úlohy.

## Čím sa odlišujeme

| Oblasť | Záväzok LAWOSS |
|---|---|
| 📁 Organizácia praxe | Štruktúra spisov má hodnotu aj bez AI. |
| 🔓 Otvorené a upraviteľné jadro | Prompty, skilly, modely a nástroje nesmú byť povinným black boxom. |
| 🔒 Dátová kontrola | Kancelária rozhoduje o modeli, dátach, pamäti a mieste spracovania podľa vlastného rizika. |
| 🤖 Agent-first práca | Agenti vykonávajú úlohy, právnik ich vedie, kontroluje a schvaľuje. |
| 🇸🇰🇨🇿 Overené zdroje | MCP integrácie môžu prepájať pracovné postupy so zdrojmi pre slovenskú a českú prax. |

## Hranice

- **Komerčný SaaS produkt**: softvér ani službu nepredávame. Monetizácia je výhradne cez workshopy a školenia.
- **Náhrada právneho úsudku advokáta**: zodpovednosť za výstup nesie vždy právnik.
- **Povinný uzavretý ekosystém**: otvorené jadro nesmie používateľa uzamknúť na jediný model, dodávateľa alebo skrytú sadu postupov.

## Ako sa doktrína uplatňuje

Základná produktová doktrína je navrhnutá v [ADR 0009](../decisions/0009-zakladna-produktova-doktrina.md) a čaká na potvrdenie tímom. Po potvrdení bude rozhodovacím testom pre významné features, partnerstvá a výnimky. Tvrdenia o konkurencii verejne uvádzame iba po aktuálnom a doloženom overení; LAWOSS vysvetľujeme vlastnými vlastnosťami a princípmi.
