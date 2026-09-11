# Zápis: sync call 11. 9. 2026 — jazyková nezávislosť OKF, compliance do onboardingu, marketplace a alfa

- **Prítomní:** MČ · MF · IR *(IR do ~28. minúty, potom odišiel na konferenciu)*
- **Neprítomný:** VŘ — rodinné dôvody, avizované vopred. **Body, ktoré sú na ňom, ostali neuzavreté** (viď „Čo call neuzavrel“).
- **Podklady:** [zápis 7. 9.](2026-09-07-zapis-tyzdenne-stretnutie.md) · [dopady na OKF a appku](../planning/2026-09-07-dopady-callu-na-okf-a-appku.md) · [podklad z 10. 9. — logo B a jednotný shell](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/76)
- **Zdroj:** transkript callu + AI súhrn (lokálne u MČ, mimo gitu), zapísané 2026-09-11 s AI asistenciou. Stav repozitárov overený cez GitHub API 11. 9. 2026.

---

## Rozhodnutia

### OKF

1. **Systém je jazykovo nezávislý — rozdelene.** Strojová vrstva (názvy súborov, priečinkov a odkazov) je **po anglicky**, aby bola univerzálna; **obsah zápisov ostáva v jazyku advokáta**, teda agent zapisuje po slovensky alebo po česky. Dôvod: rovnaký systém má uniesť slovenčinu, češtinu a neskôr aj poľštinu bez toho, aby sa menil kontrakt priečinka. *(Toto je konkrétne naplnenie pravidla O6 o anglickom jadre z 1. 9.)*
2. **`_kancelaria` sa premenúva na `Office`.** MČ: „každý to pozná, moderný advokát bez problémov“ — a názov je jazykovo neutrálny. Technicky ide o hodnotu už existujúcej konštanty `OFFICE_DIR` plus migráciu.
3. **Ceremónia potvrdzovania zápisov ostáva zamietnutá.** Opakovane a výslovne: advokát neodklikáva jednotlivé zápisy. Keď vidí, že agent zapisuje zle, **otvorí súbor a prepíše ho ručne** — rovnako, ako keď opravuje výstup ľudského kolegu.
4. **Meno systému ostáva otvorené.** VŘ navrhoval prestať tomu hovoriť OKF; MČ: „nikoho to netrápi, môžeme sa dohodnúť neskôr, mne je to jedno.“ Nie je to blokátor.
5. **Vrstvy L1/L2/L3 a brány pamäte MČ výslovne prenechal VŘ** — „to je Vojtov príspevok, nech sa sám rozhodne“. *(Dopad viď v analýze nižšie.)*

### Aplikácia a modely

6. **Chyba pri pripájaní AI modelu je opravená.** Appka hlásila „nie je zvolený žiadny model“ aj po výbere. Opravu doviedol MF, zlúčená ako [lawoss #40](https://github.com/Omni-Legal-Products/lawoss/pull/40) *(`fix(app): select default model after provider connection`, merged 11. 9. 07:42)*. MČ si appku na calle skompiloval a **pripojenie OpenAI overil naživo — funguje**.
7. **Pripojenie Anthropic stále nefunguje** — MČ si ho berie na seba. IR upozornil, že v prvom kroku Anthropic pokrýva drvivú väčšinu trhu, takže to nie je detail.
8. **Rozdelenie testovania providerov:** MČ — Anthropic, OpenAI, lokálne modely (Ollama) a ďalšie; MF — OpenAI; IR — Anthropic (používa API aj subscription).

### Compliance a onboarding

9. **Stanoviská ČAK a SAK k používaniu AI idú priamo do onboardingu.** Pripraví MF; IR je zdroj na slovenskej strane. Zistenia z callu: ČAK pokryla use-case cez **OpenAI Business/Teams**, vyžaduje **DPA s doložkou o netrénovaní**, a **akceptuje existujúce enterprise riešenia** bez podmienky, že dáta musia ostať v EÚ *(požiadavka na EÚ je podľa IR skôr GDPR poistka)*. SAK má vlastné usmernenie; IR ho plánuje budúci rok aktualizovať smerom k agentom.
10. **Advokát musí byť pri onboardingu upozornený**, že na prácu s klientskymi dátami potrebuje business/enterprise plán a podpísanú DPA — vrátane odkazov, v čitateľnej grafickej podobe, nie ako odstavec drobným písmom.
11. **Automatická detekcia typu predplatného.** Pri onboardingu oskenovať, aké subscriptions používateľ má *(vzor: open-source nástroj na kontrolu usage, ktorý rozlíši Business od spotrebiteľského plánu)*, a podľa toho povedať jasnú vetu: so spotrebiteľským plánom nepracuj s klientskymi dátami, použi ho na rešerše.
12. **Ekonomika ostáva na subscriptions.** Platiť API za token je pre advokáta neúnosné, ak chce dobré modely. Skúsenosť s lacnými komerčnými produktmi na trhu je opačná — limity, dokupovanie kreditov a slabšie modely na rešerše. Neskôr sa k tomu pridajú lokálne modely.

### Marketplace a integrácie

13. **Náš marketplace bude default vo vnútri ich existujúcej sekcie Integrations** (connectors · skills · plugins). Bude združovať **pluginy, workflowy, skilly a MCP**. Ako to presne napojiť na ich rozhranie, zatiaľ nie je doriešené.
14. **CLI nástroje si berie MČ** — prepojenie na SharePoint, Exchange a Google Workspace.
15. **MF spraví marketplace zo svojich MCP** a nasype ich do organizačného, otagované tak, aby sa dali odlíšiť. **Pluginy** (kombinácia MCP + skillov + skriptov) **preberá pod seba.** Zadanie k tomu: pozerať sa na to očami advokáta, ktorý si appku nastavuje — čo tam má nájsť.
16. **Proprietárne prvky LegalWorku sa odstránia alebo skryjú:** memory drive, účtový systém, recorder a komerčné položky Premium/Maximum. Namiesto recordera sa integruje vlastný transkripčný softvér MČ, lokálne.

### Výkon a hardvér

17. **RAM prestáva byť blokátor.** MČ: nerobíme technickú podporu a neriešime to ako komerčný produkt — kto má slabý stroj, nech si kúpi lepší. Nikto z tímu nemá stroj s 8 GB, na ktorý VŘ upozorňoval *(MF 24 GB, MČ 32 GB a laptop 16 GB, IR 32 GB, VŘ 32 GB)*. **Zobrazovanie pamäťovej ceny rozšírení pri zapínaní ostáva ako funkcia**, nie ako brána.

### Windows

18. **IR skompiluje a spustí appku na Windows** a nahlási, či tam nie je niečo zásadne rozbité, čo treba priebežne upravovať na Windows vetve.

### Alfa testovanie

19. **Úzka skupina alfa testerov**, nie masa — cieľ je kvalitná spätná väzba. Kandidáti sa zbierajú mimo repozitára; každý z tímu má dodať jedno-dve mená. Prioritne niekto na **Windows**, ako doplnok k IR.
20. **Samostatný komunikačný kanál pre testerov**, nie prístup do všetkých topicov. Distribúcia: buď build od nás, alebo zrkadlové repo, ktoré sa klonuje pri každom update a tester si skompiluje lokálne.
21. **Vstupná podmienka alfy (MČ) — štyri veci:** funkčné pripojenie Anthropic · prvý preklad rozhrania · odstránené komerčné prvky LegalWorku · základná verzia OKF integrovaná.

---

## Čo sa zmenilo oproti 7. 9.

Tri body idú proti tomu, čo sa dohodlo minulý týždeň. Zapisujeme ich ako zmenu, nie ako upresnenie.

| Vec | Dohoda 7. 9. | Stav po 11. 9. |
|---|---|---|
| **RAM** | rozpočet ~4 GB, jednotná metodika merania (MF), meranie predchádza výberu defaultov *(rozhodnutia 13 a 14)* | rozpočet aj meranie **padli ako blokátor**; ostáva len ukazovateľ spotreby. Návrh pritom pochádzal od VŘ, ktorý dnes nebol prítomný. |
| **Termín bety 16. 9.** | pevný termín skompilovanej funkčnej bety | **nepotvrdený** — MČ: „chceli sme vydať betu, ale neviem, či to bude relevantné“. Nový termín nepadol; nahradila ho **vstupná podmienka alfy** (rozhodnutie 21). |
| **Vrstvy L1/L2/L3** | mali sa uzavrieť písomne jednou vetou | **delegované na VŘ**, ktorý je na neurčito mimo |

> [!WARNING]
> **Kalendár aj zápis zo 7. 9. stále uvádzajú 16. 9. ako termín bety.** Kým nepadne nový termín alebo sa výslovne nepovie, že sa posúva, tím si bude niesť dva rôzne obrazy o tom, čo má byť v stredu hotové.

---

## Čo call neuzavrel

**Všetko, čo je na VŘ.** Vrstvy L1/L2/L3, podmienky trvalého poverenia, osud kontroly úniku do L3 a šesť z ôsmich trení jedného kontraktu spisu. Dnešné rozhodnutia 1 a 2 riešia dve z nich — anglické strojové názvy uzatvárajú spor `klient.md` × `client.md`, a `Office` uzatvára názov priečinka kancelárie. **Zvyšných šesť sa dnes nedotklo nikto.**

**Veci, ktoré sú na MČ a od 7. 9. sa nepohli** *(overené v `dev` 11. 9.)*:

- katalóg v appke stále odkazuje na **tri neexistujúce repozitáre** a inštalácia je `preview-only`
- `pnpm-workspace.yaml` stále **nemá `lawoss/*`**, takže appka nevidí `@lawoss/okf-pamat` a dashboard nemá odkiaľ čítať
- `EVENT_KINDS` sú stále po slovensky — čo je teraz navyše v priamom rozpore s dnešným rozhodnutím 1

**Koordinačný [PR #76](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/76)** (logo B a jednotný shell) je stále otvorený a reviewera nedostal, hoci produktová časť ([lawoss #39](https://github.com/Omni-Legal-Products/lawoss/pull/39)) je už zlúčená.

**Notarizácia, platformová matica a overenie updatera** nemajú vlastníka.

---

## Nález mimo callu: stabilné vydanie sa volá „LegalWork“

Pri kontrole stavu po calle *(GitHub API, 11. 9.)*:

| Čo | Zistenie |
|---|---|
| Release na našom forku | **„LegalWork v0.1.14“**, `prerelease = false`, publikované 11. 9. 08:13 |
| Assety | 18 súborov, všetky pomenované `legalwork-*` — macOS arm64 aj x64, Linux arm64 aj x64, Windows x64 — plus updater manifesty `latest*.yml` |
| Build | beh nad tagom `v0.1.14` **zlyhal v oboch macOS joboch**; Linux a Windows prešli. Neskorší beh nad `dev` prešiel. *(Zodpovedá tomu, čo MF hlásil na calle.)* |
| LAWOSS preview z 10. 9. | ostáva ako **pre-release** |

Dôsledok: **prvé stabilné vydanie na forku nesie meno upstreamu a upstream názvy binárok**, zatiaľ čo LAWOSS build je iba pre-release. Rebranding `productName` je pritom v roadmape stále otvorená položka Fázy 1. Stabilný updater mieri na `lawoss.app/update`, ktorý podľa roadmapy ešte nie je zriadený, s GitHubom ako záložným zdrojom.

**Na rozhodnutie:** či sa `v0.1.14` preklopí na pre-release alebo premenuje, a či sa rebranding `productName` spraví pred tým, než sa `lawoss.app/update` zapne.

---

## Bezpečnostné prvky pre zaručenú konverziu — vstup od MF

MČ informoval, že do macOS appky Autogram integroval podpisovanie cez mobil (QR kód, NFC) a že detektor bezpečnostných prvkov sa učí z vykonaných konverzií. Chce to priniesť aj do LAWOSS; naviaže na [spec 0007](../specs/0007-podpisovanie-a-zarucena-konverzia.md) a [spec 0010](../specs/0010-zarucena-konverzia.md).

Dnes detekuje **štyri** prvky. MF doplnil, že vyhláška ich pozná podstatne viac:

- [x] pečiatka · [x] podpis · [x] pečať · [x] parafa *(hotové)*
- [ ] šnúrka / trikolóra
- [ ] spinka
- [ ] nit
- [ ] lepka
- [ ] úradne osvedčený podpis *(odlíšiť od vlastnoručného)*
- [ ] okrúhla úradná pečiatka so štátnym znakom *(odlíšiť od bežnej pečiatky)*

**Logika, ktorú MF zdôraznil:** prvok, ktorý prechádza celým dokumentom, sa nesmie vyhodnocovať po stranách. Keď detektor nájde spinku alebo šnúrku na prvej strane, musí vedieť, že vedie až po poslednú — striedavo vľavo a vpravo. MČ si overí presné znenie vyhlášky a zoznam doplní.

---

## Poznámka k AI súhrnu

Automatický súhrn z tohto callu tvrdí, že padol *„návrh na premenovanie systému z OKF (Older Kancelária) na Office“*. **To je chyba prepisu.** Premenúva sa **priečinok kancelárie** `_kancelaria` → `Office` (rozhodnutie 2). Meno systému OKF je samostatná, stále otvorená otázka (rozhodnutie 4). Kto číta súhrn bez zápisu, odnesie si zlý záver.

---

## Akčné body

**MČ**
- [ ] sprevádzkovať pripojenie **Anthropic**
- [ ] CLI nástroje: SharePoint, Exchange, Google Workspace
- [ ] rozhodnúť osud release `v0.1.14` (pre-release × premenovanie) a rebranding `productName`
- [ ] katalóg v appke: vymeniť demo dáta za reálnych 15 položiek
- [ ] `lawoss/*` do `pnpm-workspace.yaml` + riadok do `PATCHES.md`
- [ ] `EVENT_KINDS` do angličtiny — vyplýva z rozhodnutia 1
- [ ] odstrániť/skryť komerčné prvky LegalWorku, integrovať vlastný transkripčný softvér
- [ ] prvý preklad rozhrania
- [ ] doplniť detekciu bezpečnostných prvkov podľa zoznamu vyššie, po overení vyhlášky
- [ ] s VŘ dokončiť OKF a personalizáciu/lokálnu pamäť

**MF**
- [ ] stanoviská ČAK a SAK do onboardingu vrátane grafickej podoby a autodetekcie predplatného
- [ ] marketplace zo svojich MCP → nasypať do organizačného, otagovať
- [ ] prevziať pluginy a doriešiť napojenie na sekciu Integrations
- [ ] testovať na vlastných skúšobných spisoch a zapisovať chyby
- [ ] zoznam alfa testerov a samostatný kanál

**IR**
- [ ] skompilovať a spustiť appku na Windows, nahlásiť zásadné problémy
- [ ] SAK: usmernenie k AI ako podklad pre onboarding

**VŘ** *(po návrate)*
- [ ] vrstvy L1/L2/L3 — jedna veta písomne
- [ ] podmienky trvalého poverenia a osud kontroly úniku do L3
- [ ] zvyšných šesť trení jedného kontraktu spisu

**Tím**
- [ ] potvrdiť alebo posunúť termín bety — dnes je nepotvrdený
- [ ] reviewer pre koordinačný PR #76
- [ ] vlastník notarizácie, platformovej matice a overenia updatera

<sub>Zapísal MČ s AI asistenciou z transkriptu 2026-09-11.</sub>
