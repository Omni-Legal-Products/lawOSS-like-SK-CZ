# ADR 0010: Ochrana know-how a značky — čo licenciou ubrániť vieme a čo nie

- **Dátum:** 2026-08-14
- **Stav:** **návrh** — na prerokovanie tímom MČ · MF · IR · VŘ
- **Navrhol:** MČ · 2026-08-14 *(návrh [#33](../planning/napady.md))*
- **Súvisí s:** [ADR 0002](0002-preco-forkujeme-mikeoss.md) *(monetizácia = vzdelávanie)* · [ADR 0003](0003-legal-work-ako-zaklad.md) a [ADR 0004](0004-ako-rozsirit-legalwork.md) *(MIT)* · [ADR 0009](0009-zakladna-produktova-doktrina.md) *(otvorenosť ako pilier)* · [stratégia](../docs/strategia.md)

## Kontext

Do LAWOSS ide **celé know-how tímu** — prompty, skills, OKF štruktúra, MCP konektory, právne postupy. Rozdáva sa zadarmo a monetizácia stojí výhradne na školeniach *(ADR 0002)*.

MČ položil otázku, ktorú sme dosiaľ nemali nikde zodpovedanú:

> **Čo bráni tomu, aby niekto vzal celú appku a staval na nej vlastné platené riešenia — platené školenia, platené add-ony, platený hosting?**

Otázka je oprávnená a **odpoveď je nepríjemná.**

## Rozhodnutie

### 1. Priznávame, že licenciou to ubrániť nevieme — a je to vedomé

**LAWOSS je MIT.** MIT výslovne dovoľuje komerčné použitie, uzavretie odvodeného diela aj sublicencovanie. Ktokoľvek smie LAWOSS vziať, zavrieť, prebrandovať a predávať k nemu školenia, doplnky aj hosting. **Je to vlastnosť licencie, nie diera v nej.**

Nie je to ani prehliadnutie: MIT vyplýva z voľby základu *(ADR 0003)*, kde sme **AGPL-3.0 vedome zamietli** pri mikeOSS. Otočiť to teraz by znamenalo zrušiť ADR 0003 aj 0004.

> [!IMPORTANT]
> **Ani AGPL by problém nevyriešila.** Obmedzila by uzavretý hosting, ale **nezabránila by tomu hlavnému, čoho sa obávame** — nikto nepotrebuje licenciu na to, aby predával školenia k open-source softvéru. To je bežná a legitímna prax celého odvetvia. Vymeniť licenciu by teda znamenalo zaplatiť rozporom s ADR 0003 za ochranu, ktorú nedostaneme.

### 2. Čo brániť vieme — tri páky, žiadna z nich licencia

| Páka | Čo chráni | Čo stojí |
|---|---|---|
| **Ochranná známka** na meno a logo | Kód smie prevziať ktokoľvek. **Volať to LAWOSS nesmie.** Zamedzí zámene a tomu, aby cudzí platený produkt ťažil z našej povesti. | poplatok za prihlášku, rozhodnutie kde *(SK/CZ/EUIPO)* |
| **Autorita a komunita** | *„Štyria advokáti zo SAK a ČAK to postavili a učia to"* sa **nedá forknúť**. Kto prevezme kód, začína bez dôvery a bez prístupu ku komore. | nič navyše — vyplýva z toho, kto sme |
| **Tempo a väzba na upstream** | Fork zastarne. Kto sa odpojí, udržiava si vlastný merge s LegalWorkom aj s našou vrstvou. | to, čo robíme aj tak |

**Ochranná známka je jediná právne vymáhateľná** a je najlacnejšia zo všetkých úvah o zmene licencie.

### 3. Rozlišujeme dve otázky, ktoré sa zlievajú

| | |
|---|---|
| **Čo robíme my** | Zodpovedané. [ADR 0002](0002-preco-forkujeme-mikeoss.md) a odpoveď IR na Q22: *„Platené moduly odmietam: v momente, keď predávame softvér, sme dodávateľ softvéru so všetkým, čo k tomu patrí."* |
| **Čo smú robiť iní** | **Toto ADR.** Smú takmer všetko okrem používania našej značky. |

Zlievanie týchto dvoch otázok je zdroj celého nedorozumenia.

### 4. Prijímame, že prevzatie je prijateľné riziko

Ak niekto vezme LAWOSS a postaví na ňom platený produkt:

- **advokátom to neuškodí** — originál zostáva zadarmo a otvorený,
- **je to dôkaz hodnoty**, nie zlyhanie,
- **my zostávame tí, čo tomu rozumejú najviac**, lebo to sami používame v praxi.

Toto je cena za otvorenosť, ktorú si [ADR 0009](0009-zakladna-produktova-doktrina.md) zvolila ako pilier. **Nemôžeme mať zároveň otvorenosť aj výhradnosť.**

## Dôsledky

1. **Registrovať ochrannú známku LAWOSS** — slovnú, prípadne aj kombinovanú s logom. Rozhodnúť rozsah *(SK, CZ, alebo EUIPO pre celú EÚ)*. **Toto je jediný krok, ktorý treba spraviť aktívne a čím skôr**, kým meno nie je notoricky spojené s projektom a kým ho niekto nezaregistruje prvý.
2. **Doplniť `NOTICE` a `README`** o jasné vyhlásenie: kód je MIT, **značka LAWOSS chránená**. Odvodené dielo sa musí volať inak.
3. **Nemeniť licenciu.** MIT zostáva. Kto navrhne zmenu, musí najprv zrušiť ADR 0003 a 0004.
4. **Neriešiť to zákazmi v dokumentácii** — nevymáhateľné a pôsobí to zle pri projekte, ktorý stojí na otvorenosti.

## Zvažované alternatívy

| Alternatíva | Prečo nie |
|---|---|
| **Prejsť na AGPL-3.0** | Obmedzí uzavretý hosting, ale **nezabráni plateným školeniam ani add-onom**. Ruší ADR 0003 a 0004 a vracia licenciu, ktorú sme pri mikeOSS zamietli. Vysoká cena, nízka ochrana. |
| **Dual licensing** *(open + platená komerčná)* | Znamená, že **predávame softvér** — presne to, čo ADR 0002 vylučuje. IR to na Q22 odmietol výslovne. |
| **Zadržať časť know-how** *(prompty a skills mimo repa)* | V rozpore s [ADR 0009](0009-zakladna-produktova-doktrina.md), pilier 1: *„žiadne skryté prompty"*. Zabilo by to dôveryhodnosť aj zmysel projektu. |
| **Nerobiť nič** | Značka zostane nechránená a **ktokoľvek ju môže zaregistrovať prv než my** — vrátane toho, kto by chcel stavať platený produkt. To je jediné reálne nebezpečenstvo v celej téme. |

## Otvorené otázky

- [ ] 🔴 **Rešerš staršej známky `LAWOSS`** — **pokus 2026-08-14 zlyhal**: EUIPO provider nie je nakonfigurovaný pre náš účet na patent.dev *(free tier, `provider_not_configured`)*. Bez tejto rešerše sa **nesmie podávať prihláška** — ak kolidujúca staršia známka existuje, prihláška padne a poplatok prepadne. Konfigurácia: `https://patent.dev/patent-connector/`, alebo priamo cez [eSearch EUIPO](https://www.tmdn.org/tmview/) *(zadarmo, ručne)*.
- [ ] **Kde registrovať známku** — SK, CZ, alebo rovno EUIPO? *(EUIPO je drahšie, ale pokrýva obe jurisdikcie naraz a projekt je dvojjurisdikčný)*
- [ ] **Kto je majiteľ známky** — jeden z tímu, alebo spoločný subjekt? Súvisí s tým, či projekt niekedy dostane právnu formu.
- [ ] Registrovať aj **logo**, alebo zatiaľ len slovné označenie?
- [ ] Ako sa známka správa k **organizácii Omni Legal Products**, ktorá je iné meno než produkt?

---

<sub>Pripravil MČ s AI asistenciou, 2026-08-14. Licenčné tvrdenia o MIT a AGPL vychádzajú zo znenia licencií; **rešerš staršej známky sa 2026-08-14 nepodarilo vykonať** (EUIPO provider nie je nakonfigurovaný) a postup registrácie nebol overený u úradu. Pred podaním prihlášky sa oboje musí preveriť.</sub>
