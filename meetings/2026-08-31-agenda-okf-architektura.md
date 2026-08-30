# Agenda: call 31. 8. 2026 o 10:30 - zjednotenie OKF architektúry

- **Určené pre:** Marián Čuprík (MČ) + Vojta Říha (VŘ)
- **Pripravil:** MČ s AI asistenciou
- **Čas:** 31. 8. 2026 o 10:30 CEST
- **Odporúčaná dĺžka:** 45 minút
- **Stav podkladu:** návrh MČ na spoločnú revíziu, nič v tomto dokumente ešte nie je rozhodnutím VŘ ani tímu
- **Hlavný prezentačný podklad:** [OKF 1.0: VŘ, MČ a konsolidovaný návrh](../assets/diagrams/okf-konsolidacia.html#overview)

> [!IMPORTANT]
> Cieľom callu nie je vybrať dashboard, endpointy ani detailnú implementáciu. Cieľom je získať spoločný mandát pre kanonický OKF kontrakt a architektonický smer, z ktorého sa následne dopracuje technický spec LAWOSS.

## Výsledok, ktorý potrebujeme na konci

1. potvrdenie, čo z návrhu VŘ a čo z návrhu MČ zostáva súčasťou spoločného OKF 1.0,
2. dohoda, či portable OKF Core bude spoločným základom CLI, externých agentov a LAWOSS,
3. dohoda o postavení produktového PR #24: prototyp na zachovanie konceptov a testov, alebo priamy základ,
4. presný zoznam otvorených bodov, ktoré blokujú technický spec,
5. vlastník a ďalší krok ku každému neuzavretému bodu,
6. mandát MČ dopracovať detailný technický spec bez začatia produktovej implementácie.

## Čo dnes vedome nerozhodujeme

- layout a poradie dashboardov,
- konkrétne HTTP endpointy a event DTO,
- konkrétny storage engine regenerovateľného read modelu,
- finálny zoznam SK a CZ registry providers,
- plný multi-user a remote team mode,
- finálne fyzické miesto kancelárskeho L1 brainu, ak neblokuje kontrakt,
- implementačné issues a delenie programátorskej práce.

Dashboard zostáva neskorším konzumentom hotového OKF Core a serverového read modelu.

## Overený stav pred callom

Overené read-only cez `git` a GitHub CLI 31. 8. 2026 o 00:43 CEST.

| Podklad | Overený stav | Ako ho prezentovať |
|---|---|---|
| [koordinačný PR #63](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/63) | otvorený, mergeable, bez review | návrh a referenčný snapshot VŘ, nie tímové rozhodnutie |
| [koordinačný PR #64](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/64) | otvorený, mergeable, bez review, cieľom je vetva PR #63 | konsolidačný návrh MČ nad podkladom VŘ, nie súhlas VŘ |
| [produktový PR #24](https://github.com/Omni-Legal-Products/lawoss/pull/24) | otvorený, mergeable, review required, päť zobrazených CI kontrol zelených | funkčný prototyp pamäťovej časti, nie schválená cieľová architektúra |
| [spec 0014](../specs/0014-okf-1-kanonicky-kontrakt.md) | návrh na spoločnú revíziu | pracovný kanonický kontrakt, ktorý má call potvrdiť alebo presne upraviť |
| [technické zadanie LAWOSS](../planning/2026-08-31-okf-lawoss-technicky-navrh-zadanie.md) | architektonické discovery | rozsah ďalšieho technického specu, nie hotová implementácia |

## Prezentačný scenár so zdieľaním obrazovky

### 0 až 4 min: rámec a pravidlá

Otvoriť [01 Porovnanie](../assets/diagrams/okf-konsolidacia.html#overview).

Úvodná veta:

> Dnes nerušíme ani MČ, ani VŘ systém. Rozhodujeme, ktoré princípy z oboch tvoria kanonický spoločný kontrakt a akú architektonickú hranicu má potom dopracovať technický spec LAWOSS. Dashboard dnes zámerne neriešime.

Potvrdiť spôsob zaznamenania každej odpovede:

- **ÁNO**,
- **ÁNO S PRESNOU ÚPRAVOU**,
- **NIE + navrhovaná alternatíva**,
- **POTREBUJEME DÔKAZ + konkrétny fixture alebo test**.

### 4 až 10 min: presnosť atribúcie VŘ a MČ

1. Otvoriť [02 Návrh VŘ](../assets/diagrams/okf-konsolidacia.html#vr).
2. Požiadať VŘ, aby opravil každé nepresné alebo chýbajúce tvrdenie.
3. Otvoriť [03 Návrh MČ](../assets/diagrams/okf-konsolidacia.html#mc).
4. Oddeliť rozdielne problémové vrstvy.

Kľúčová veta:

> Nie je to kompromis päťdesiat na päťdesiat. MČ systém rieši životný cyklus klienta, prípadov a reálneho priečinka. VŘ systém rieši granularitu, retrieval, históriu a kontrolovateľnosť pamäte. Spoločný OKF potrebuje oboje.

### 10 až 18 min: spoločný kontrakt

Otvoriť [04 Konsolidácia](../assets/diagrams/okf-konsolidacia.html#joint).

Potvrdiť en bloc s právom vytiahnuť konkrétny konflikt:

1. otvorené file-based jadro pri klientovi a prípadoch,
2. `AGENTS.md` ako bootstrap a `CLAUDE.md` ako byte-identický mirror,
3. klientsky workspace s viacerými prípadmi,
4. anglický machine contract a lokalizované ľudské výstupy,
5. typované records, `Truth`, append-only `History` a vrstvy L1/L2/L3,
6. tok `evidence alebo observation -> finding alebo proposal -> human-confirmed truth`,
7. LAWOSS cache a read model ako odvodené dáta, nie kanonická pravda.

### 18 až 28 min: skutočné rozhodovacie napätia

Otvoriť [technické porovnanie](../research/okf-implementacie/porovnanie-a-konsolidacia-2026-08-31.md) a [stanovisko MČ](../research/okf-implementacie/stanovisko-mc.md) iba pri bode, kde treba presný detail.

| Bod | Otázka na call | Navrhovaný výsledok MČ |
|---|---|---|
| O1 | Ako plniť `_STATUS.md` bez dvojitej pravdy? | iba označené generované bloky v existujúcich sekciách, nikdy tichý append duplicitnej sekcie |
| O2 | Ako migrovať MČ a VŘ legacy? | jednorazový, nedeštruktívny a idempotentný plán, originály zachovať, najprv fixture a súkromný pilot |
| O3 | Kde fyzicky žije kancelársky L1 brain? | nechať otvorené, kým neblokuje klientský a prípadový kontrakt |
| O4 | Akú konkurenciu rieši v1? | manifest hash, revision a single writer per workspace; plný multi-user režim neskôr |
| O5 | Kedy publikovať OKF ako samostatný štandard? | až po migračnom pilote a stabilizovaní verzie 1 |
| O6 | Lokalizovaná alebo anglická perzistenčná schéma? | anglický machine contract, lokalizované priečinky a ľudské výstupy |
| O7 | Ako riešiť únik L2 do L3? | brána zostáva, matching sa sprísni a konfiguruje na úrovni kancelárie, bez per-record bypassu |

Na dnešný mandát sú kritické najmä O1, O2 a O6. O3, detail O4, O5 a detail O7 môžu zostať explicitne otvorené.

### 28 až 36 min: architektúra LAWOSS

Otvoriť [06 Architektúra LAWOSS](../assets/diagrams/okf-konsolidacia.html#architecture-lawoss).

Porovnať tri smery:

1. **PR #24 priamo napojiť do appky:** rýchle, ale zachová matter-only a legacy obmedzenia,
2. **OKF iba v LAWOSS serveri:** jednoduchšie pre appku, ale poruší interoperabilitu mimo LAWOSS,
3. **spoločný `@lawoss/okf-core` + portable CLI + tenký LAWOSS server adaptér:** odporúčaný smer.

Kľúčová veta:

> `AGENTS.md` orientuje agenta, ale neautorizuje zápis. Jedna knižnica musí vynucovať parse, validate, plan, approval pre chránené zmeny a recoverable apply pre CLI aj LAWOSS.

Potvrdiť pracovnú hranicu:

```text
LAWOSS workspace = klientsky OKF root
matter = stabilne identifikovaný prípad v klientskom root-e
OKF files = kanonická pravda
OKF Core = pravidlá a plánovanie zmien
LAWOSS server = watcher, read model, approvals, audit a providers
UI a dashboard = neskorší konzument
```

### 36 až 41 min: jedna end-to-end simulácia

Otvoriť [05 Simulácia ACME](../assets/diagrams/okf-konsolidacia.html#simulation) a prejsť iba:

1. **Pripojenie priečinka:** detect, dry-run a potvrdenie,
2. **Nové uznesenie:** observation a human-confirmed lehota,
3. **Iný agent:** orientácia cez `AGENTS.md`, bez predstierania approval,
4. **Reconciliation:** evidence, finding, rozhodnutie človeka, `Truth + History`.

Účel simulácie nie je ukázať UI. Má overiť, že rovnaký kontrakt funguje pri založení, externej zmene, právne významnom zápise aj inom harness-e.

### 41 až 45 min: hlasovanie, otvorené body a mandát

Otvoriť [07 Rozhodnutia](../assets/diagrams/okf-konsolidacia.html#decisions) a zaznamenať každú odpoveď nižšie.

## Rozhodovací list na živé doplnenie

| ID | Rozhodnutie | Výsledok callu | Presná úprava alebo dôkaz | Vlastník |
|---|---|---|---|---|
| D1 | Konsolidácia je kanonický smer podmienený detailným technickým specom. |  |  |  |
| D2 | `AGENTS.md` je kanonický bootstrap a `CLAUDE.md` byte-identický mirror. |  |  |  |
| D3 | Jeden klientsky workspace obsahuje viac stabilne identifikovaných prípadov. |  |  |  |
| D4 | Perzistenčný machine contract je anglický, ľudské výstupy lokalizované. |  |  |  |
| D5 | Typované records, `Truth + History`, L1/L2/L3 a samostatný `lesson` zostávajú. |  |  |  |
| D6 | CLI, agent a LAWOSS používajú ten istý `plan -> validate -> approve -> apply` kontrakt. |  |  |  |
| D7 | Chránené zmeny vynucuje Core a runtime approval, nie prompt ani self-declared objekt. |  |  |  |
| D8 | PR #24 je referenčný prototyp na zachovanie konceptov a testov, nie priamy kanonický základ. |  |  |  |
| D9 | Dashboard sa odkladá a MČ dostáva mandát dopracovať technický spec platformy. |  |  |  |

## Ako hovoriť o PR #24

Použiť formuláciu:

> PR #24 je funkčný prototyp s úspešným CI a dôkaz, že viaceré pamäťové invarianty vieme implementovať. Nie je však app integráciou ani hotovým OKF 1.0. Dnes rozhodujeme, či jeho koncepty a testy prenesieme do spoločného Core, nie či prácu VŘ zahodíme.

Na calle nerozoberať ako problémy CI workflow ani samostatný lockfile. V [technickom review](../research/okf-implementacie/review-pr24.md) sú výslovne uzavreté ako nenálezy. Sústreďme sa na cieľový kontrakt, parser, klientsky model, approval, atomicitu a integráciu.

## Čo zapísať bezprostredne po calle

1. nový zápis `meetings/2026-08-31-zapis-okf-architektura.md` s účastníkmi, zdrojom a presnými výsledkami D1 až D9,
2. aktualizáciu stavu a presných zmien v [spec 0014](../specs/0014-okf-1-kanonicky-kontrakt.md), bez prepisovania autorstva VŘ,
3. pri schválenom architektonickom smere ADR alebo explicitné označenie, že ide stále iba o návrh,
4. rozhodnutie o poradí koordinačných PR #64 a #63,
5. technický spec až na základe mandátu z callu,
6. žiadny produktový kód ani implementačné issue bez schváleného specu.

## Definícia úspešného callu

Call je úspešný aj bez úplnej zhody, ak pri každom spornom bode vznikne:

- presne pomenovaný konflikt,
- alternatívny návrh,
- fixture, test alebo iný dôkaz potrebný na rozhodnutie,
- vlastník,
- termín alebo ďalší rozhodovací krok.

Call nie je úspešný, ak sa skončí všeobecným „ešte to premyslíme“ bez zaznamenania konkrétnych rozdielov.
