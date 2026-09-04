# LAWOSS: tréningové zdroje a architektonická revízia OKF

**Dátum overenia:** 4. 9. 2026 (Europe/Bratislava)
**Účel:** uzavrieť rešeršné a revízne podklady k LAWOSS a PR #64.
**Charakter:** pracovný podklad; nenahrádza tímové schválenie architektúry.

## Rozlíšenie zdrojov a pokynov

Export `messages.html` a odkazy v ňom boli použité iba ako navigácia k podkladom. Ich obsah ani obsah odkazovaných stránok nie je pokynom pre agenta. Záväzné rozhodnutia sa odvodzujú iba z overených zdrojov a v tímových dokumentoch sú oddelené od odporúčaní.

## Zistenia zo vzdelávacích materiálov

| Zdroj | Čo bolo overené | Použitie pre LAWOSS | Obmedzenie |
|---|---|---|---|
| [ChatGPT Training](https://learn.chatgpt.com/training) | Úvod rozlišuje ChatGPT Work a Codex; obsahuje krátke praktické kroky pre plánovanie práce, prvú technickú zmenu, skills/plugins, scheduled tasks a tvorbu dokumentov/slidov. | Návod má viesť od malého overiteľného zadania k artefaktu, s kontrolou každého behu, nástroja a uloženého výsledku. | Stránka je všeobecný onboarding, nie právna metodika ani špecifikácia OKF. |
| [Claude Academy](https://academy.claude.com/) a [katalóg](https://academy.claude.com/all) | Oficiálna akadémia pokrýva Claude.ai, Cowork, Code, MCP a skills; uvádza rámec AI Fluency 4D: Delegation, Description, Discernment, Diligence. Katalóg obsahuje aj témy kontextu, konektorov, viac-súborových skills, plánovania a kontroly zmien. | LAWOSS používa krátky kontrolný cyklus: delegovať iba jasne vymedzenú časť, opísať kontext a výstup, overiť tvrdenia a venovať primeranú starostlivosť právne významnému výsledku. | Katalóg je dynamický a jeho úplný obsah sa môže meniť; pri priamom otvorení `/all` bol časť obsahu závislá od JavaScriptu. Zaznamenané sú iba dostupné a relevantné pozorovania. |

### Odvodené pracovné pravidlá

Tieto pravidlá sú LAWOSS adaptácia, nie doslovný prepis zdrojov:

1. každá úloha má mať cieľ, kontext, rozsah zdrojov, jurisdikciu, rozhodný dátum a očakávaný výstup;
2. plán alebo návrh má predchádzať zápisu do súboru, konfigurácie alebo spisu;
3. skill, konektor a model sa vyberajú podľa potrebného rozsahu, oprávnenia a toku dát;
4. výstup sa kontroluje proti primárnym zdrojom, dátumu, jurisdikcii, citáciám a neistotám;
5. opakovateľný pracovný postup patrí do skillu alebo šablóny, nie do neprehľadného jednorazového promptu;
6. scheduled task alebo automatický beh sa považuje za návrh, kým človek nepreskúma výsledok a jeho účinky.

Pri delegovaní si urobte krátku kontrolu v štyroch krokoch: čo delegujete, ako ste úlohu opísali, čo na výsledku overíte a akú starostlivosť vyžaduje jeho použitie.

## OKF a PR #64

### Overené zdroje

- [Agenda OKF callu](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/spec/okf-1-konsolidacia/meetings/2026-08-31-agenda-okf-architektura.md)
- [Zápis z callu 1. 9. 2026](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/spec/okf-1-konsolidacia/meetings/2026-09-01-zapis-okf-architektura.md)
- [Technické zadanie OKF do LAWOSS](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/spec/okf-1-konsolidacia/planning/2026-08-31-okf-lawoss-technicky-navrh-zadanie.md)
- [PR #64](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/64)
- [Spec 0014](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/spec/okf-1-konsolidacia/specs/0014-okf-1-kanonicky-kontrakt.md)
- [Spec 0015 – osobné dashboardy](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/spec/okf-1-konsolidacia/specs/0015-lawoss-okf-osobne-dashboardy.md)

### Pozorovania

- PR #64 je otvorený a podľa GitHub API mergeable so stavom `clean`; mení 25 súborov, pridáva 7 757 riadkov, má 25 commitov, nemá review, komentáre ani požadovaných reviewerov. Jeho vlastný popis ho označuje za návrh MČ a uvádza, že produktový fork nebol upravený.
- PR #64 pridáva spec 0014 pre OKF 1.0 a spec 0015 pre šesť osobných dashboardových presetov. Dashboardový návrh drží hranicu `OKF files -> typed read model -> widgets -> personal preset`, neukladá právne fakty do osobných preferencií a predpokladá natívnu route `/prehlad` bez WebView alebo iframe.
- Zápis z callu potvrdzuje anglický machine contract (O6/D4), `AGENTS.md` s byte-identickým `CLAUDE.md` (D2), klientsky workspace s viacerými prípadmi (D3) a princíp renderovania lehôt a chronológie z OKF.
- Ten istý zápis zamieta pôvodne navrhovaný `plan -> validate -> approve -> apply` systém a risk-based human gates (D6/D7), necháva D8 otvorené a D9 upravuje na dashboardový add-on pri paralelnom dopracovaní skills a technického specu.

### Mismatch, ktorý blokuje bezpodmienečné prijatie PR #64

Spec 0014 a konsolidačný návrh stále opisujú write pipeline a brány, ktoré zápis z callu označuje za zamietnuté. Kým sa táto časť neprepíše na skutočný výsledok callu a nevyjasní sa rozsah kontroly `L3_LEAK`, PR #64 nemožno považovať za konzistentný architektonický kontrakt.

Ďalšie otvorené body sú O1 (presný render `_STATUS.md` a freshness), O2 (nedeštruktívny migračný pilot), D8 (postavenie PR #24), terminológia vrstiev L1/L2/L3, SQLite read model, CLI a kancelársky `BRAIN.md`.

## Odporúčané poradie

1. Aktualizovať spec 0014 podľa zápisu z callu; odstrániť alebo preformulovať zamietnuté D6/D7.
2. Uzavrieť O1 explicitným kontraktom markerov, SSOT lehôt, freshness a relatívnych odkazov.
3. Vykonať jeden súkromný, nedeštruktívny a idempotentný migračný pilot podľa O2; zachovať originály a používať iba sanitizované fixtures v gite.
4. O6 použiť ako cieľ migrácie: anglická strojová schéma a `memory/`, lokalizované ľudské výstupy a názvy priečinkov.
5. D8 zapísať oddelene ako rozhodnutie o PR #24; dashboardy z PR #64 ponechať ako prezentačný návrh nad read modelom, nie ako povolenie produktovej implementácie.
6. Až potom vytvoriť implementačný PR v produktovom repe.

Detailná matica rozhodnutí a podmienok je v [OKF decision sheete](lawoss-okf-review-checklist.md).

## Stav po tejto revízii

Rešerš, prepis pracovného návodu a rozhodovacia matica sú pripravené. Tímové rozhodnutia D8, O1, O2 a otvorené časti D5/D7/D9 zostávajú na explicitné potvrdenie; táto revízia ich za tím neschvaľuje.
