# Zber z Telegramu — čo v chate zaznelo a v repe zatiaľ nie je

- **Spracoval:** Vojta Říha (VŘ) · 2026-09-03
- **Obdobie:** 1. 9. – 2. 9. 2026 · témy *General CHAT*, *Research*, *Feature IDEAS*
- **Nadväzuje na:** [spracovanie topicu Feature IDEAS zo 7. 8.](2026-08-07-feature-ideas-telegram.md)
- **Stav:** podklad na prerokovanie — **čísla nápadov sú návrh, prideľuje ich MČ**

> [!NOTE]
> **Prečo tento súbor vzniká.** MČ prenáša nápady z chatu do [`planning/napady.md`](../../planning/napady.md) priebežne a robí to dôsledne — k 3. 9. je tam 23 očíslovaných nápadov. Posledné dva dni sa ale v chate objavilo niekoľko vecí, ktoré tam ešte nedopadli, a jedna z nich má **nezhodu, ktorá nikde nie je zapísaná**.
>
> **Do `napady.md` som nesiahol zámerne.** Čísla 49–50 sú rezervované v [PR #55](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/55) a súbor aktívne edituje MČ — podľa `AGENTS.md` platí *„jeden súbor = jeden autor v jednom čase"*. Nižšie sú položky pripravené na prenos; číslovanie a zaradenie patrí jemu.

---

## A · Nezhoda, ktorá by nemala zapadnúť

### Onboarding jedným promptom × „96 % advokátov to nedá"

**Návrh MČ** *(1. 9.)*: appku spraviť otvorenú v tom zmysle, že používateľ zadá **len PROMPT do svojho AI harnessu**, ktorý mu appku sám skompiluje, nainštaluje a upraví podľa potrieb. Onboarding by potom znel: *„skopíruj tento PROMPT a zadaj ho do Claude Code alebo Codexu."*

**Námietka MF** *(2. 9.)*: *„96 % advokátov to nedá… teda aspoň podľa mňa."*

**Odpoveď MČ**: *„Tak tých 96 % advokátov nech používa chatgpt.com a nech si dávajú sumarizovať judikáty. Tie 4 % dostanú 1000× boost."*

**Prečo to patrí do evidencie a nie do chatu:** je to priamy protiklad k tomu, čo tím odklepol na [calle 28. 8.](../../meetings/2026-08-28-zapis-sync-call.md), bod 4 — *„light verzia + jednoduchý onboarding (klik-klik, pár obrazoviek, videá) sa spraví ako add-on pred verejným spustením"*, kde MF argumentoval tým istým číslom *(„90 % advokátov sa v plnom rozhraní stratí")* a **zhoda vtedy bola, že light verziu robíme**. Teraz stojí na stole odpoveď, že tá skupina nie je cieľovka.

Obe pozície môžu platiť naraz — prompt-onboarding pre technicky zdatných, klikací pre zvyšok — ale **to zatiaľ nikto nepovedal nahlas** a rozdiel je strategický, nie technický: určuje, pre koho produkt je.

Súvisí aj s Q06 *(„kompiláciu si spraví používateľ sám")* a s vetvou [`agent/one-click-onboarding`](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/tree/agent/one-click-onboarding), ktorú MF otvoril 1. 9.

➡️ **Návrh: zaradiť ako bod na najbližší call**, nie ako nápad do koša.

---

## B · Položky pripravené na prenos do `napady.md`

Číslovanie je návrh — po #48 a #51 je voľné od #52 *(49–50 drží PR #55)*.

- **52. Onboarding jedným promptom** — MČ, 2026-09-01, z chatu. Používateľ nedostane inštalátor, ale **prompt pre svojho AI agenta**, ktorý mu appku skompiluje a nastaví. Sedí na Q06 *(kompiláciu si robí používateľ)* a na agent-first doktrínu. ⚠️ **Otvorená nezhoda s MF a s bodom 4 zápisu z 28. 8.** — viď sekcia A. Rozpracované vo vetve `agent/one-click-onboarding`.

- **53. `ponytail` — redukcia codebase pri upstream syncu** — MČ, 2026-09-01, z chatu. [`DietrichGebert/ponytail`](https://github.com/DietrichGebert/ponytail) *(JavaScript, MIT, overené 2026-09-03)* — nástroj, ktorý vedie agenta k mazaniu zbytočného kódu. MČ: *„zrezal mi codebase o skoro 70 % a všetko funguje."* **Prečo je to pre nás relevantné:** menšia plocha nášho kódu = menší diff proti upstreamu = lacnejší sync a menej konfliktov, čo je presne cieľ [#48](../../planning/napady.md) *(opencode sync pipeline)* a pravidla „naše zmeny len ako pluginy a overlay". ⚠️ Použiť **len na náš kód v zelenej zóne**, nikdy na upstream súbory — mazanie v cudzom kóde by sync naopak rozbilo.

- **54. Slovenské generované komentáre — dorovnanie asymetrie SK × CZ** — MČ + VŘ, 2026-09-02, z chatu. MČ: *„Tie SK generované komentáre by som chcel tiež rozbehnúť."* VŘ má slovenské pramene **už vyscrapované** a vie generovanie spustiť. **Podmienka, ktorú si stanovil sám VŘ:** je to dielo, ktoré **potrebuje slovenské autorstvo** — spustí sa až po výslovnom pokyne MČ, aby autorstvo a zodpovednosť za obsah sedeli na jurisdikciu.
  - Rieši ❗ **otvorenú asymetriu z [#47](../../planning/napady.md)**: česká strana má komentárovú vrstvu ku celému právu, slovenská nie.
  - Platí **rovnaká výhrada ako pri CZ korpuse** *(Q23)*: sekundárny, nerecenzovaný materiál generovaný s AI — *„publikovať áno, citovať v podaní nie"*; varovanie musí niesť produkt, nie len repozitár.
  - VŘ navrhol, že sa to *„môže odpublikovať a odmarketovať spolu s LAWOSS"* — teda **naviazať na spoločné oznámenie**, nie vydávať samostatne.

- **55. Minimálne systémové nároky ako produktové rozhodnutie** — MČ, 2026-09-01, z chatu. Po napojení remote Slov-Lex MCP do LAWOSS narástla spotreba o ~100 MB RAM; MČ: *„žobráci s 8 GB RAM to budú mať ťažké."* **Prečo to nie je len poznámka:** cieľovka podľa callu 28. 8. zahŕňa aj starších kolegov na starších strojoch *(„mysleli sme aj na vás")*. Ak plná verzia s viacerými MCP nepobeží na 8 GB, je to **argument pre light verziu aj technicky**, nie len kvôli rozhraniu. Treba zmerať a stanoviť deklarované minimum.

- **56. Vzdelávacie centrum namiesto technickej dokumentácie** — IR, 2026-09-02, z chatu. IR: *„Mohli by sme mať inštrukcie ako klasické CRM"* s odkazom na [vzdelávacie centrum Caflou](https://www.caflou.cz/vzdelavaci-centrum) — teda návody a kurzy pre používateľa, nie developerská dokumentácia. Sedí presne na **prierezový postoj MČ č. 5** z podkladu ku konsolidácii *(„dokumentácia pre advokáta, nie pre developera")* a zároveň na monetizačný model *(školenia — [ADR 0002](../../decisions/0002-preco-forkujeme-mikeoss.md))*: vzdelávacie centrum je výkladná skriňa toho, čo sa predáva.
  - Na otázku IR *„Budeme mať aj web?"* odpovedal MČ: **`lawoss.app`** *(teaser beží — [docs/lawoss-web-teaser.md](../../docs/lawoss-web-teaser.md))*.

---

## C · Vecný posun, ktorý nie je nápad, ale patrí do evidencie

| Čo | Kto | Stav |
|---|---|---|
| **Poľské pramene sa sťahujú** — beží na samostatnom stroji | VŘ, 2026-09-02 | plní úlohu z roadmapy *(mapovanie PL zdrojov)* |
| **Kontakty do Poľska** — MČ obnovuje vzťahy so známymi z konferencie Legal Market Day | MČ, 2026-09-02 | sedí na Q19 *(internacionalizácia cez lokálnych maintainerov)* |
| **Certifikačný materiál Anthropic** ako zdroj pre tím | VŘ, 2026-09-01, topic *Research* | [Claude Certified Architect Foundations](https://anthropic-partners.skilljar.com/claude-certified-architect-foundations-certification) — ucelený podklad k architektúre agentov |

---

## D · Čo som overil, že už zachytené je

Aby bolo zrejmé, že tento súbor needuplikuje evidenciu MČ — nasledujúce v `napady.md` alebo v zápisoch **už sú** a nepridávam ich znova: paper cuts #28–#32, samoúdržba nástrojovej plochy #45, distribúcia korpusov cez HF/torrent #46, komentárový korpus VŘ #47, opencode sync pipeline #48, TUI #51, a celý priebeh prác vo forku *(sync, Experimenty, OKF Fáza A, updater)* zapísaný v sedení 2. 9.

<sub>Zostavil VŘ s AI asistenciou, 2026-09-03, z tém *General CHAT*, *Research* a *Feature IDEAS*. Odkazy na `ponytail` a na vetvu `agent/one-click-onboarding` overené cez GitHub API 2026-09-03. Citácie z chatu sú doslovné; kde je uvedený zámer *(„chcel by som rozbehnúť")*, nejde o prijaté rozhodnutie.</sub>
