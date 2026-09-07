# Zápis: týždenný call 7. 9. 2026 — OKF ako maják, generalizácia agend, marketplace, RAM a termín 16. 9.

- **Prítomní:** MČ · VŘ · MF *(odpojil sa v ~24. minúte na iný hovor, na záver sa krátko vrátil)* — **IR neprítomný** *(volal mu MČ: nemá čas, ale chce byť pri tom → MČ mu bude posielať kalendárové pozvánky)*
- **Podklady:** [rozhodovací podklad MČ zo 6. 9.](../planning/2026-09-06-rozhodovaci-podklad-mc.md) · [zápis zo sedenia 2. 9.](../planning/2026-09-02-zapis-sedenie-fork-okf-faza-a.md) · reťaz PR vo forku #24 → #31 → #35
- **Zdroj:** transkript callu + AI súhrn (lokálne u MČ, mimo gitu), zapísané 2026-09-07 s AI asistenciou
- **Nadväzuje:** [zápis 28. 8.](2026-08-28-zapis-sync-call.md) · dopady tohto callu na kód a nastavenia sú rozpísané v [planning/2026-09-07-dopady-callu-na-okf-a-appku.md](../planning/2026-09-07-dopady-callu-na-okf-a-appku.md)

---

## Rozhodnutia

### OKF

1. **Google „Open Knowledge Format“ je maják, nie dogma.** Držíme sa ich technickej dokumentácie a **sledujeme ich revízie** — v0.2 priniesla veci, ktoré nám chýbali, a dáva zmysel ich preberať. Systém sa ale prispôsobuje reálnej advokátskej praxi, nie naopak. *(VŘ navrhol prestať to volať „OKF“, lebo to doslova OKF nie je; MČ: „môžeme to nazvať úplne inak, mne je to jedno“ — **meno teda neuzavreté**, viď otvorené R6.)*
2. **Nové typy záznamov a vrstvy z revízií VŘ sa prijímajú.** MČ: „dáva to zmysel, ja s tým nemám problém.“
3. **Ceremónia schvaľovania je definitívne zamietnutá — aj v kóde.** VŘ potvrdil, že zvyšková kontrola od človeka (klikanie „zapíš“ po každej zmene) je **pozostatok z pôvodných PR-iek a de facto mŕtvy kód**, ktorý odstráni. MČ: „schvaľovanie po každej jednej zmene je hlúposť.“
4. **Kontrola aktualizácie statusov a reconciliácia indexových súborov sú povinná súčasť.** Toto bol dlhodobý problém MČ so starým OKF (staré záznamy sa nikdy neaktualizovali, indexy driftovali) a v0.2 to rieši — „tieto veci tam proste musíme mať“.
5. **Testovanie na otvorených dátach je prijatý základ.** VŘ testoval na českom insolvenčnom registri (ISIR) — živé, verejne dostupné údaje, žiadne obmedzenie, kde sa smú objaviť.
6. **Systém sa zovšeobecní mimo procesných agend.** Dnešné typy (`evidence`, `claims`…) sú vyslovene procesné. Doplní sa **typizačná vrstva veci** (trestné · civil · správne · rodina · korporát) a typy pre **tvorbu (zmluvy), právne podania, rešerše a vlastnú agendu advokáta** (medzinárodné právo, exekúcie, valné zhromaždenia, interné poznámky). **Podmienka MČ: abstrahovať a generalizovať, nerobiť „veľa lievikov“** — príliš členitý systém sa nedá udržiavať.
7. **Duplicita súborov v podpriečinkoch nie je vada.** VŘ ju označil v PR-kách; MČ vysvetlil, že je zámerná — agent vchádza do adresára cez index a rovnomenné súbory sa týkajú len obsahu toho priečinka.
8. **Adresárová štruktúra a nomenklatúra advokáta sa nastavuje — súbory OKF ostávajú jednotné.** Systémové súbory OKF (`spis.md`, `_STATUS.md`, `memory/`…) majú pevné názvy a formát; to je kontrakt, ktorý drží prenositeľnosť. Nastavuje sa **vlastná pracovná štruktúra advokáta**: podpriečinky spisu (zmluvy, podania, korešpondencia, dôkazy…), tak ako si ich kto reálne vedie, a konvencia pomenovania dokumentov (Word, PDF). Advokát si ju zadá **pri onboardingu a neskôr v Settings**, uloží sa na úrovni kancelárie a **OKF systém ju použije pri zakladaní každého nového spisu** aj pri retrofite existujúceho — agent potom vie, kam ktorý dokument patrí a ako ho pomenovať. MČ: „na ostatných riešeniach práve vadí, že si to nemôžeš individualizovať podľa seba."

### Marketplace a rozšírenia

9. **Marketplace po vzore GitHub Marketplace.** Centrálne miesto na **skilly, MCP a pluginy**, upgradeovateľné a udržiavateľné nami; my určujeme, čo je v **defaulte**. Otagované podľa jurisdikcie (ČR/SR, judikatúra, komentáre). MČ už spravil klon svojich privátnych MCP do organizácie s návodmi na remote aj lokálnu inštaláciu a chce z nich pluginy.
10. **Pri onboardingu si advokát zvolí jurisdikciu a defaulty sa nainštalujú na klik.** Remote inštalácia ostáva pre pokročilejších kolegov.
11. **Ku každému MCP ide sprievodný skill** *(VŘ)* — advokát nemá vedieť, aké volania má MCP; skill mu povie, ako sa má MCP pýtať. „Keď tam bude rovno skill, bude to preňho veľká úľava.“
12. **Marketplace vedie MF, MČ a VŘ mu pomôžu.** VŘ si pozrie Martinovu PR-ku; MČ dodá default konfiguráciu (default skilly, MCP, pluginy).

### Výkon a hardvér

13. **Rozpočet pamäte: cieľ do ~4 GB pre appku vrátane rozšírení** *(VŘ)*. Dôvod: advokát má súčasne otvorený Word, PDF a Chrome. 15 MCP, ktoré zožerú 6–8 GB na stroji s 8–16 GB, je koniec.
14. **Meria sa jednotne a priamo v appke, nie samostatne** — MF pripraví jednotnú metodiku testov, aby neplatilo „ja to testujem inak než Vojta“. MČ má overené **remote MCP v appke (bez problémov)**, lokálne **STDIO netestované** → testuje MF. VŘ testuje na dvoch strojoch (16 GB a 24 GB, SSD) a následne aj na Windows.
15. **Tvrdá minimálna konfigurácia sa zamieta.** MF navrhol interný test, ktorý by program pri slabom stroji nespustil; MČ to odmietol — **appka musí byť spustiteľná na každom počítači a v základnej konfigurácii fungovať**. Namiesto blokovania: **odporúčané defaulty + zobrazovanie pamäťovej ceny pri zapínaní jednotlivých rozšírení** (analógia s videohrami, ktoré ukazujú spotrebu VRAM pri zapínaní features). Odhad zo systémových prostriedkov na macOS/Linux realizovateľný, na Windows neisté.
16. **Záložný plán: MCP → samostatné CLI nástroje.** Keďže appka stojí na open-code harnesse, má k dispozícii Bash CLI — ak sa MCP ukážu ako pamäťovo neúnosné, dá sa od nich úplne upustiť.

### Produkt, termín a marketing

17. **Termín: 16. 9. 2026 — skompilovaná funkčná beta.** Uzavretý pilot s integrovaným OKF systémom, marketplace a onboardingom. MČ: „musíme to dovtedy zmaknúť.“
18. **Špeciálna sekcia integrácií v nastaveniach** popri marketplace skillov a MCP: **kalendár a e-mail** (Google Workspace a Office/Exchange ako defaulty), plus CLI skilly typu Reminders CLI a chystané Apple Notes CLI. Účel: skenovanie mailov, stretnutia a **zápis lehôt** — priamo na advokátsku prax.
19. **Dashboard generovaný live z markdownov** pokračuje ako smer — lehoty ako timeline, dôležité údaje z indexov a statusových markdownov. MČ má hotový základný návrh.
20. **Benchmark modelov na právne úlohy** — vlastný „LAWOSS benchmark“ po vzore Harvey. VŘ: „bez toho to nemá iný význam než marketing — a overenie, že to funguje aj na iných počítačoch než našich.“ Slúži teda dvojako: marketing + funkčné overenie.
21. **Rozhranie: viac grafiky, menej textu** — aspoň pre marketingové ukážky a onboarding. *(Otvorené: VŘ preferuje čisto textové rozhranie, MČ žiada aspoň materiál na obrázky.)*
22. **Očakávaný veľký záujem.** IR hlási veľký feedback z komory → paralelne s technikou treba rozvíjať marketingový naratív, nielen technický základ.

---

## Čo call neuzavrel

MČ na záver zhrnul ako uzavreté aj body, ktoré na calle **nezazneli vecne** — sú buď dorozhodnuté písomne v PR-kách, alebo len predpokladané. Aby sa nestratili:

| # | Vec | Stav po calle | Čo treba |
|---|---|---|---|
| R1 | Význam vrstiev **L1/L2/L3** | MČ ich označil za „vyriešené“, ale na calle sa o nich nehovorilo | zapísať **jednou vetou písomne** do `zjednotenie.md` a do tohto zápisu *(MČ)* |
| R2 | **Trvalé poverenie** (PR #31) — podmienky | padla ceremónia, podmienky sa neriešili | rozhodnúť: opt-in aj pre knižničné volanie, ochrana `okf.config` pred vlastným agentom, validácia `expires_at` |
| R3 | **`L3_LEAK`** a prahy | nezaznelo | potvrdiť, že ide o kontrolu mlčanlivosti, nie o zamietnutú „human gate“ |
| R4 | **Jeden kontrakt spisu** (Fáza A × `okf-pamat`) | MČ označil za uzavreté („jeden kontrakt, jeden bundle“), rozdelenie práce sa neriešilo | rozdeliť 8 konkrétnych trení — **najväčšie riziko pre 16. 9.** |
| R5 | **SSOT lehôt** a drift | čiastočne — „lehoty ako špeciálny typ, ktorý appka prečíta a zobrazí“ | dorozhodnúť, či `lehoty:` odchádzajú zo `spis.md` |
| R6 | **Meno OKF**, `log.md`, `EVENT_KINDS` | meno otvorené; `EVENT_KINDS` anglicky nezaznelo | `EVENT_KINDS` je podmienka pred merge #35 — inak ide slovenčina do append-only histórie |
| R9 | **Pilot migrácie** spisu MČ | zamenené s pilotom appky (16. 9.) | samostatný termín |
| R10 | **Reconciliation a subjektový research** — vlastník | nezaznelo | priradiť vlastníka alebo zapísať zmenu vízie |
| R11 | Prepis **spec 0014**, osud PR #64 a #67 | nezaznelo | MČ po calle |

---

## Nové požiadavky, ktoré na calle pribudli

| Čo | Kto navrhol | Dopad |
|---|---|---|
| Profil pracovnej štruktúry advokáta (podpriečinky spisu + pomenovanie dokumentov), prenesený z onboardingu do OKF | MČ | **stredný** — nová vrstva nad šablónami, systémové súbory ostávajú nedotknuté |
| Typizačná vrstva veci (trest/civil/správne/rodina/korporát) + typy pre tvorbu zmlúv, podania, rešerše a vlastnú agendu | MČ, VŘ | stredný — nadväzuje na „profily vecí“ zo spec 0013 |
| Sprievodný skill ku každému MCP | VŘ | malý — v katalógu už z veľkej časti je |
| Rozpočet RAM ~4 GB + zobrazenie pamäťovej ceny rozšírení | VŘ, MČ | stredný — nová UI vec v marketplace |
| Sekcia integrácií kalendár/e-mail/CLI v nastaveniach | MČ | stredný |
| Benchmark modelov na právne úlohy | VŘ, MČ | nový pracovný prúd |

---

## Akčné body (do 16. 9.)

- [ ] **VŘ** — odstrániť zvyškový kód schvaľovania z OKF implementácie (mŕtvy kód z pôvodných PR-iek)
- [ ] **VŘ** — doplniť typy pre tvorbu (zmluvy), právne podania a vlastnú agendu advokáta; udržať to generalizované
- [ ] **VŘ** — pozrieť Martinovu PR-ku k marketplace a pomôcť s ňou
- [ ] **VŘ** — testovanie na druhom stroji a na Windows; príprava podkladov k benchmarku
- [ ] **MF** — integrovať marketplace do appky a naplniť defaultné skilly/MCP/pluginy pre CZ a SK
- [ ] **MF** — jednotná metodika merania RAM + otestovať lokálne (STDIO) MCP
- [ ] **MF** — onboarding: nastavenie základných vecí vrátane adresárovej štruktúry a nomenklatúry
- [ ] **MČ** — default konfigurácia marketplace (default skilly, MCP, pluginy) a pomoc MF
- [ ] **MČ** — integrovať špeciálne CLI skilly (Google Workspace, Reminders CLI, chystané Apple Notes CLI) do nastavení
- [ ] **MČ** — kalendárové pozvánky na stretnutia (aby sa vedel pripojiť IR)
- [ ] **MČ** — marketingový naratív + benchmark ako marketingový aj funkčný materiál
- [ ] **MČ** — dopísať body, ktoré call neuzavrel (tabuľka vyššie), najmä vetu k L1/L2/L3 a rozdelenie práce k jednému kontraktu spisu
- [ ] **všetci** — už začať appku reálne používať a integrovať do nej rozpracované veci, nie testovať oddelene

**Ďalší míľnik: streda 16. 9. 2026 — skompilovaná funkčná beta.** Medzitým podľa potreby status check *(dohodne sa v Telegrame)*; IR sa pripojí, ak stihne.

<sub>Zapísal MČ s AI asistenciou z transkriptu 2026-09-07.</sub>
