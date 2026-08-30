# OKF dashboard: šesť high-fidelity smerov

- **Stav:** schválený rozsah na vytvorenie prezentačných návrhov, nie tímové rozhodnutie o finálnom layoute
- **Zadal:** Marián Čuprík (MČ) · 2026-08-31
- **Rozsah:** šesť porovnateľných dashboardov nad rovnakým syntetickým OKF datasetom, s jedným detailným referenčným prípadom
- **Výstup:** `docs/design/hifi/okf-dashboard-directions.html`
- **Nadväzuje na:** [OKF 1.0](../../specs/0014-okf-1-kanonicky-kontrakt.md), [technické zadanie](../../planning/2026-08-31-okf-lawoss-technicky-navrh-zadanie.md), [LAWOSS design system](design-system.md)

> [!IMPORTANT]
> Tento dokument schvaľuje vytvorenie prezentačného exploration setu. Neurčuje finálny produktový dashboard, nemení záväzný LAWOSS design system a nepredstavuje odklepnutie OKF 1.0 tímom.

## 1. Cieľ

Vytvoriť šesť graficky aj UX odlišných high-fidelity návrhov, na ktorých sa dá rozhodnúť:

1. akú informáciu má OKF dashboard ukázať ako prvú,
2. ako má advokát rozlíšiť potvrdenú pravdu, návrh agenta, finding a chybu,
3. ako sa má používateľ dostať od UI hodnoty k pôvodnému zdroju,
4. ktorý smer je najlepší ako domovská obrazovka, detail prípadu, kontrolný pohľad a partnerský prehľad,
5. ktoré špecializované pohľady majú byť samostatnými lenses nad jedným OKF read modelom.

Všetky varianty použijú rovnaké syntetické dáta. Rozdiel bude v informačnej hierarchii, kompozícii, navigácii, vizualizácii a interakčnom modeli.

## 2. Odporúčaný formát výstupu

Jeden self-contained HTML súbor:

```text
docs/design/hifi/okf-dashboard-directions.html
```

Súbor bude obsahovať:

- úvodnú porovnávaciu galériu šiestich smerov,
- jeden plnohodnotný 1440 x 1024 dashboard pre každý smer,
- prepínanie smerov bez reloadu,
- prezentačný režim bez vysvetľujúceho chrome, ale s trvalým markerom `Fiktívne dáta · pracovný návrh`,
- klávesové skratky `1` až `6`, šípky, `F` a `Esc`, doplnené viditeľnými ovládacími prvkami,
- spoločný inspector zdroja a histórie,
- responzívne správanie pre menší desktop a tablet,
- print CSS pre prezentačný export,
- výlučne inline CSS, JavaScript, SVG a licenčne prípustné WOFF2 fonty bez CDN.

HTML bude označený ako pracovný návrh s fiktívnymi dátami. Marker zostane viditeľný aj vo fullscreen a print režime. Prototyp sa nebude tváriť ako funkčná appka ani ako schválená implementácia.

## 3. Spoločný syntetický OKF dataset

### 3.1 Identita

| Pole | Hodnota v prototype |
|---|---|
| Klient | ALFA STAV s.r.o. |
| Prípad | ALFA STAV s.r.o. proti BETA DEVELOPMENT a.s. |
| Agenda | spor zo zmluvy o dielo |
| Spisová značka | 18Cb/47/2026 |
| Súd | Okresný súd Žilina |
| Jurisdikcia | Slovensko |
| Zodpovedný advokát | JUDr. Martin Novák, fiktívna osoba |
| Fáza | po doručení rozsudku, príprava odvolania |

### 3.2 Potvrdené údaje

- Rozsudok bol doručený do elektronickej schránky 28. 8. 2026.
- Žaloba bola zamietnutá v celom rozsahu.
- Klient potvrdil prijatie rozhodnutia.
- Aktívny dokument je `02_podania/Odvolanie - koncept v1.docx`.
- Posledné potvrdené rozhodnutie spisu má ID `D-2026-011`.

### 3.3 Návrhy a otvorené body

- Kandidátna lehota na odvolanie je 14. 9. 2026. Ide o modelový návrh, nie potvrdenú právnu lehotu.
- Agent navrhuje zápis do L2: platba 40 percent bola zmluvná splátka, nie záloha.
- Otázka `Q-2026-004`: Je protokol o odovzdaní podpísaný protistranou?
- Register vrátil odlišné sídlo protistrany. Verification je `partial` a rozdiel čaká na posúdenie.
- `_STATUS.md` je starší než dva nové dokumenty a potrebuje reconciliation.
- Jeden typovaný záznam má parse error, zvyšok store zostáva čitateľný.

### 3.4 Udalosti a zdroje

| Dátum | Udalosť | Stav | Zdroj |
|---|---|---|---|
| 12. 2. 2026 | podanie žaloby | potvrdené | `02_podania/Zaloba.pdf` |
| 18. 5. 2026 | vyjadrenie protistrany | potvrdené | `03_protistrana/Vyjadrenie.pdf` |
| 24. 8. 2026 | vydanie rozsudku | potvrdené | `04_rozhodnutia/Rozsudok.pdf` |
| 28. 8. 2026 | doručenie rozsudku | potvrdené | `evidence/edelivery/receipt.json` |
| 31. 8. 2026 | návrh lehoty | kandidát | `findings/deadlines/F-2026-018.md` |
| 31. 8. 2026 | návrh L2 faktu | čaká na human gate | `findings/reconciliation/F-2026-021.md` |

### 3.5 Portfóliový rámec

Prvých päť smerov otvorí detail referenčného prípadu ALFA STAV. Risk Control Tower začne na úrovni praxe a použije rovnaký dataset s týmito ďalšími fiktívnymi súhrnmi:

| Klient a prípad | Stav | Dôvod pozornosti | Zodpovedný |
|---|---|---|---|
| ALFA STAV s.r.o. proti BETA DEVELOPMENT a.s. | príprava odvolania | kandidátna lehota, partial verification, stale status | JUDr. Martin Novák |
| NOVA ENERGIA s.r.o., dodávka technológie | replika žalobcu | potvrdená lehota 3. 9. 2026 | JUDr. Eva Kováčová |
| LIPA DOMOV a.s., akvizičná previerka | due diligence | chýba vlastnícky dokument | Mgr. Peter Urban |
| HORIZONT SERVICES s.r.o., pracovný spor | pred pojednávaním | `_STATUS.md` neaktualizovaný 12 dní | JUDr. Martin Novák |
| MODRA LOGISTIKA a.s., poistná udalosť | dokazovanie | registry provider je offline | JUDr. Eva Kováčová |

ALFA STAV zostane v portfóliovej matici zvýraznený. Klik z úrovne praxe vedie cez `prax -> klient -> prípad` na ten istý detail a tú istú provenance, ktorú používajú ostatné smery.

### 3.6 Stabilné entity fixture

| Entita | Typ a stav | Obsah | Zdroj a locator |
|---|---|---|---|
| `T-2026-029` | `matter`, potvrdená truth | Rozsudok bol doručený 28. 8. 2026 a žaloba bola zamietnutá. | `memory/matters/T-2026-029.md:18` |
| `D-2026-011` | `decision`, aktívne | Pripraviť odvolanie a preveriť význam odovzdávacieho protokolu. | `memory/decisions/D-2026-011.md:21` |
| `TASK-2026-044` | úloha, otvorené | Skontrolovať, či je protokol podpísaný protistranou. | `_STATUS.md:48` |
| `Q-2026-004` | `question`, otvorené | Je protokol o odovzdaní podpísaný protistranou? | `memory/questions/Q-2026-004.md:16` |
| `F-2026-018` | `finding`, kandidátna lehota | Modelový návrh termínu odvolania 14. 9. 2026. | `findings/deadlines/F-2026-018.md:24` |
| `DL-2026-007` | lehota, potvrdené | Replika žalobcu v prípade NOVA ENERGIA, 3. 9. 2026. | `NOVA ENERGIA/memory/deadlines/DL-2026-007.md:19` |
| `F-2026-020` | `finding`, partial verification | Register vrátil rozdielne sídlo protistrany. | `findings/validation/F-2026-020.md:17` |
| `F-2026-021` | `finding`, čaká na gate | Platba 40 percent bola zmluvná splátka, nie záloha. | `findings/reconciliation/F-2026-021.md:22` |
| `OKF_STALE_001` | warning | `_STATUS.md` je starší než dva nové dokumenty. | `_STATUS.md:3` |
| `OKF_PARSE_002` | error | Záznam `Q-2026-009.md` má neuzavretú YAML hodnotu. | `memory/questions/Q-2026-009.md:7` |
| `AUD-2026-084` | audit | Advokát potvrdil truth `T-2026-029`. | `audit/2026-08.jsonl:41` |

V referenčnom prípade nie je žiadna potvrdená budúca lehota. Tento empty state sa ukáže vedľa kandidátnej lehoty. Potvrdená lehota `DL-2026-007` patrí iba susednému prípadu NOVA ENERGIA a používa sa v portfóliovom prehľade.

### 3.7 Demonštračný výpočet kandidátnej lehoty

Prototyp ukáže kompletnú stopu, ale výslovne ju označí ako syntetický a právne neoverený príklad:

| Pole | Demonštračná hodnota |
|---|---|
| trigger | doručenie rozhodnutia 28. 8. 2026 |
| trigger source | `evidence/edelivery/receipt.json:12` |
| dokument | `04_rozhodnutia/Rozsudok.pdf`, strana 1 |
| právny základ | `§ 362 ods. 1 CSP`, demonštračný údaj |
| verzia zdroja | pracovný snapshot označený `2026-08-31` |
| calculation trace | deň doručenia sa nezapočíta, model počíta 15 dní do 12. 9. 2026 a posúva koniec na 14. 9. 2026 |
| pomenovaná neistota | treba potvrdiť trigger, aplikovaný právny režim a pravidlo posunu |
| write plan | `base_revision: 18`, `base_hash: 81aa39f2` |

Ak sa po vytvorení návrhu zmení receipt alebo kanonický záznam, gate prejde do stavu `proposal stale`. Akcie zápisu sa zablokujú a používateľ dostane možnosť `Prepočítať návrh`.

## 4. Spoločný informačný kontrakt

Dashboard je projekcia OKF read modelu. Nie je druhým zdrojom pravdy.

```text
OKF subory
  -> OKF Core
  -> serverovy read model
  -> dashboard lens
  -> inspector zdroja
```

Každý variant musí obsahovať alebo sprístupniť:

- klienta a identitu prípadu,
- aktuálnu fázu a ďalší krok,
- potvrdené a kandidátne lehoty,
- úlohy a otvorené otázky,
- findings a konflikty,
- dokumenty a evidence,
- decisions a aktuálnu truth,
- validáciu, freshness a parse stav,
- auditnú históriu,
- pôvod hodnoty až po súbor a riadok.

Nie každý prvok musí byť naraz viditeľný. Rozdiel medzi smermi je práve v tom, čo považujú za primárnu informáciu.

### 4.1 Úrovne a spoločná drill-down cesta

Každý smer viditeľne označí svoju úroveň:

| Úroveň | Obsah |
|---|---|
| `prípad` | detail jedného prípadu, jeho truth, udalosti, findings a zdroje |
| `klient` | spoločná identita a prípady jedného klienta |
| `prax` | súhrn viacerých klientov a prípadov bez predstierania právneho skóre |

Smery 1 až 5 začínajú na úrovni `prípad`. Smer 6 začína na úrovni `prax`, ale jeho primárny drill-down otvorí ALFA STAV na úrovni `prípad`. Breadcrumb a source inspector používajú rovnaké názvy a rovnaké entity vo všetkých smeroch.

### 4.2 Diagnostické scenáre

Spoločný prepínač `Scenár` umožní prezrieť stavy bez mutácie datasetu:

| Scenár | Viditeľný výsledok |
|---|---|
| current | referenčný stav s kandidátnou lehotou a otvorenými findings |
| empty | žiadna potvrdená budúca lehota, s vysvetlením ďalšieho kroku |
| partial | čiastočné overenie subjektu s pomenovaním chýbajúcich údajov |
| stale | stará projekcia a blokovaný stale write plan |
| parse-error | jeden poškodený záznam, zvyšok store zostáva dostupný |
| future-version | workspace sa otvorí read-only s vysvetlením verzie |
| offline | registre a vzdialené zdroje sú nedostupné, lokálne OKF dáta zostávajú čitateľné |

Scenár je iba prezentačný filter. Nemení kanonický stav, audit ani fixture.

## 5. Spoločné bezpečnostné pravidlá

### 5.1 Stav nie je iba farba

Každý stav má farbu, tvar alebo štýl čiary a textové pomenovanie:

| Stav | Vizuálny princíp | Povinná mikrocopy |
|---|---|---|
| potvrdené | plná čiara alebo plný bod, zelená iba ako sekundárny signál | `potvrdené` |
| návrh agenta | zlatá značka alebo prerušovaná čiara | `návrh, čaká na potvrdenie` |
| neoverené | obrys a warning farba | `neoverené` alebo `čiastočne overené` |
| chyba | červený alebo kontrastný technický marker | stabilný kód chyby a odporúčaný krok |
| stale | časový marker a warning | dátum poslednej aktualizácie |
| read-only | zreteľná informačná lišta | dôvod a dovolené ďalšie kroky |

### 5.2 Human gate

Právne významná zmena nikdy nemá jediné tlačidlo bez kontextu. Gate zobrazí:

1. zdroj a locator,
2. navrhovanú zmenu,
3. dôvod a požadovaný typ schválenia,
4. presný diff,
5. vetu, čo sa zapíše a kam,
6. `base_revision` alebo hash, ku ktorému bol návrh vytvorený,
7. stav concurrency kontroly,
8. akcie Potvrdiť, Upraviť, Odmietnuť a Odložiť.

Pri stave `proposal stale` sa Potvrdiť a Upraviť zablokujú. Gate vysvetlí, ktorý podklad sa zmenil, a ponúkne `Prepočítať návrh`. Žiadne tlačidlo v prezentačnom prototype nevykoná zápis.

### 5.3 Provenance

Akcia `Ukázať zdroj` otvorí inspector s reťazcom:

```text
UI hodnota
  -> read model pole
  -> kanonicky OKF zaznam
  -> povodny subor a riadok
  -> evidencia alebo dokument
  -> historia zmien
```

Bez provenance sa nepoužije označenie `Overené`.

### 5.4 Zakázané skratky

- Žiadne percento AI istoty.
- Žiadne magické rizikové skóre bez vysvetlenia.
- Žiadna automaticky potvrdená lehota.
- Žiadne produktivitné metriky agenta.
- Žiadny silent last-write-wins.
- Žiadne tiché vynechanie neparsovateľného záznamu.
- Žiadne generické SaaS KPI karty ako hlavná kompozícia.

## 6. Spoločný vizuálny rámec

Všetky smery zostanú v existujúcom LegalWork shelli a LAWOSS tokenoch:

| Token | Rola | Hodnota |
|---|---|---|
| `--lw-canvas`, `--lw-sidebar` | canvas a sidebar | `#0A0E14` |
| `--lw-surface` | surface | `#10171F` |
| `--lw-sunken` | sunken | `#0C1219` |
| `--lw-text-primary` | text primary | `#E9E4DA` |
| `--lw-text-secondary` | text secondary | `#A8B0BA` |
| `--lw-text-tertiary` | text tertiary | `#75808C` |
| `--lw-accent` | accent | `#C9A24A` |
| `--lw-success` | success | `#8DBB8F` |
| `--lw-warning` | warning | `#D89A4E` |
| `--lw-danger` | danger | `#D9776B` |
| `--lw-info` | info | `#7FA3C7` |

Raw farby sa v HTML objavia iba v jednom deklaratívnom `:root` token bloku. Komponenty a inline SVG používajú tokeny alebo premenné odvodené z tohto bloku.

Typografia:

- IBM Plex Sans pre UI a text,
- IBM Plex Mono pre spisové značky, ID, dátumy, súbory a locatory,
- Playfair Display iba pre pečať.

IBM Plex Sans, IBM Plex Mono a Playfair Display sa vložia ako subsetované WOFF2 data URI z licenčne prípustných OFL zdrojov. HTML tak zostane offline a typograficky konzistentný. V kóde zostanú systémové fallbacky pre prípad, že prehliadač embedded font odmietne.

Tvar:

- rohy 2 až 6 px,
- hairline separátory namiesto plošných tieňov,
- jedna zlatá primárna akcia na obrazovke,
- žiadny glow, glass alebo dekoratívne gradienty,
- jeden hlavný informačný diagram na každý smer.

## 7. Smer 1: Podací denník

- **Úroveň:** `prípad`
- **Drill-down:** rozhodovací riadok -> gate -> zdroj a história

### Téza

Dashboard je ranný pracovný register. Najprv ukazuje, o čom musí rozhodnúť advokát, potom najbližšie lehoty a napokon zmeny v spise.

### Primárne použitie

- každodenný štart práce,
- samostatný advokát a malý tím,
- rýchly triage bez štúdia celého spisu.

### Kompozícia

```text
+--------------------------------------------------------------+
| obal pripadu: klient | sp. zn. | faza | validacia             |
+--------------------------------------------------------------+
| register Potrebuje vase rozhodnutie                           |
| 01 kandidatna lehota | 02 L2 zapis | 03 rozdiel v registri   |
+--------------------------------------------------------------+
| 14-dnovy pas lehôt                                          |
+--------------------------------------------------------------+
| posledne zmeny v spise | agent activity | dalsi krok          |
+--------------------------------------------------------------+
```

### Signature interaction

Rozbalenie registrového riadku ukáže priamo v zozname reťazec `zdroj -> navrh -> miesto zapisu`. Používateľ môže otvoriť plnú gate bez straty kontextu.

### Silná stránka

Najmenšia krivka učenia a najlepší kandidát na domovský matter overview.

### Riziko

Menej vhodný na strategické pochopenie vzťahov v rozsiahlej veci.

## 8. Smer 2: Procesná mapa

- **Úroveň:** `prípad`
- **Drill-down:** udalosť -> calculation trace -> dokument a audit

### Téza

Najdôležitejšia informácia je, kde sa vec nachádza v čase, čo ju tam dostalo a čo príde ďalej.

### Primárne použitie

- súdny spor,
- príprava na pojednávanie,
- kontrola chronológie a lehôt,
- handoff medzi členmi tímu.

### Kompozícia

```text
+----------------+--------------------------------+-------------+
| fazy konania   | procesna os a udalosti         | detail      |
|                |                                | udalosti    |
| podanie        | o----o====o----:----o           | zdroj       |
| dokazovanie    |      [DOKAZY]                  | vypocet     |
| rozhodnutie    |                  [DNES]         | historia    |
+----------------+--------------------------------+-------------+
| mini navigator celeho obdobia                                 |
+--------------------------------------------------------------+
```

### Signature interaction

Scrubbing po osi času. Klik na udalosť zobrazí trigger, dokument, locator, právny základ, calculation trace a auditnú históriu.

### Silná stránka

Najlepšie vysvetľuje rozdiel medzi potvrdenou udalosťou a kandidátnou lehotou.

### Riziko

Slabší pre transakčnú agendu a všeobecné poradenstvo bez procesnej osi.

## 9. Smer 3: Dôkazová konštelácia

- **Úroveň:** `prípad`
- **Drill-down:** fact alebo finding -> provenance path -> dokument alebo evidence

### Téza

OKF je mapa toho, ako dôkaz podporuje finding a ako sa finding po potvrdení stáva pravdou spisu.

### Primárne použitie

- komplexný spor,
- due diligence,
- rozporné zdroje,
- viac subjektov a prepojených tvrdení.

### Kompozícia

```text
+-------------+-----------------------------------+--------------+
| filtre      | graf faktov, zdrojov a subjektov  | inspector    |
|             |                                   | vybraneho    |
| facts       | [PDF]---[FACT]---[DECISION]        | uzla         |
| evidence    |          |                        |              |
| subjects    |       [FINDING]---[REGISTER]       | provenance   |
+-------------+-----------------------------------+--------------+
| queue rozporov a chybajucich dokazov                           |
+--------------------------------------------------------------+
```

### Signature interaction

`Spotlight fact` stlmí ostatné uzly a ukáže celú trasu od aktuálnej truth cez históriu po pôvodný dokument alebo registry snapshot.

### Silná stránka

Najsilnejší prezentačný wow efekt a najlepšie sensemaking pre komplikovanú vec.

### Riziko

Graf sa môže pri veľkom spise preplniť. Musí preto mať list fallback a klávesovú navigáciu.

## 10. Smer 4: Auditný ledger

- **Úroveň:** `prípad`, s prepínateľným klientskym auditným súhrnom
- **Drill-down:** ledger riadok -> diff -> kanonický záznam, locator a history

### Téza

Dashboard dokazuje integritu systému. Každá hodnota vysvetlí pôvod, schválenie a zmenu v čase.

### Primárne použitie

- partner review,
- kontrola pred podaním,
- audit migrácie alebo retrofitu,
- diagnostika poškodeného workspace.

### Kompozícia

```text
+--------------------------------------------------------------+
| health ribbon: schema | mirror | freshness | provider | audit |
+-----------------------------------------+--------------------+
| ledger findings a zmien                 | split inspector    |
| ID | severity | subor | stav | dalsi    | diff               |
|                                         | provenance         |
|                                         | append-only history|
+-----------------------------------------+--------------------+
```

### Signature interaction

`Vysvetlit hodnotu` ukáže source-to-UI trace od vizuálneho poľa až po kanonický záznam, súbor a riadok.

### Silná stránka

Najvyššia dôvera, kontrolovateľnosť a auditovateľnosť.

### Riziko

Je technickejší a menej priateľský ako každodenný domovský pohľad.

## 11. Smer 5: OKF Brain

- **Úroveň:** `prípad`, s viditeľným kontextom vrstiev kancelárie a právnej znalosti
- **Drill-down:** memory record -> Truth a History -> zdroje a návrh promotion

### Téza

Hlavná hodnota je vedieť, čo systém o veci vie, čo nevie, čo sa naučil a do ktorej vrstvy poznatok patrí.

### Primárne použitie

- návrat k staršej veci,
- odovzdanie spisu kolegovi,
- práca s agentom,
- reconciliation a kontrola lessons.

### Kompozícia

```text
+----------------+--------------------------+------------------+
| matter brief   | current truth            | vrstvy pamate    |
| faza           | fakty                    | L1 kancelaria    |
| dalsi krok     | decisions                | L2 pripad        |
| otvorene       | otazky                   | L3 pravo         |
+----------------+--------------------------+------------------+
| pending promotions | lessons proposed | reconcile queue     |
+--------------------------------------------------------------+
```

### Signature interaction

Guided promotion ukáže anonymizovaný návrh, cieľovú vrstvu, diff a presnú vetu, čo sa po schválení zapíše. Promotion do L1 vždy vyžaduje human gate. Promotion do L3 navyše vyžaduje právnu kontrolu a úspešnú L2-to-L3 leak kontrolu. Priame drag-and-drop presúvanie záznamov medzi vrstvami nie je dovolené.

### Silná stránka

Najlepšie komunikuje jedinečnosť OKF a transparentnú agentickú pamäť.

### Riziko

Menej vhodný na rýchly portfóliový prehľad a kontrolu najbližších lehôt.

## 12. Smer 6: Risk Control Tower

- **Úroveň:** `prax`
- **Drill-down:** risk cell -> klient -> referenčný prípad -> zdroj a audit

### Téza

Riadiaci partner nepotrebuje vidieť všetko. Potrebuje vedieť, kde sa koncentruje operačné riziko a prečo.

### Primárne použitie

- väčšia advokátska kancelária,
- vedúci tímu,
- týždenný operations review,
- kontrola zaťaženia a dátového zdravia.

### Kompozícia

```text
+-------------+----------------------------------+---------------+
| saved lens  | matica pripad x dovod pozornosti | prioritna     |
| Urgencia    | lehota | zdroj | stale | gate    | decision queue|
| Dokazy      |                                  |               |
| Data health | mini procesne drahy               |               |
+-------------+----------------------------------+---------------+
| workload a data-health pruhy s vysvetlenim pravidiel          |
+--------------------------------------------------------------+
```

### Signature interaction

Lens switch prepína rovnaké prípady medzi pohľadmi Urgencia, Dôkazy, Dátové zdravie a Zaťaženie. Klik na bunku filtruje konkrétnu decision queue a ukáže dôvody zaradenia.

### Silná stránka

Najlepší prehľad pre partnera a väčšiu prax.

### Riziko

Rizikový signál nesmie predstierať právny záver. Každá bunka musí ukázať transparentné pravidlo a zdroj.

## 13. Poradie prezentácie

Odporúčané poradie vytvára príbeh od každodennej práce po riadenie kancelárie:

1. Podací denník: praktický default.
2. Procesná mapa: čas a lehoty.
3. Dôkazová konštelácia: vzťahy a provenance.
4. Auditný ledger: kontrola a dôvera.
5. OKF Brain: pamäť a učenie.
6. Risk Control Tower: riadenie praxe.

Na úvodnej galérii bude pri každom smere uvedené:

- jedna veta s tézou,
- hlavný používateľ,
- najsilnejšia vlastnosť,
- hlavný trade-off,
- odporúčaná produktová rola.

## 14. Interakcie prototypu

Prototyp bude mať reálne, ale lokálne interakcie bez servera:

- otvorenie a zatvorenie source inspectora,
- filtrovanie viditeľnosti potvrdených, kandidátnych a chybových stavov bez zmeny údajov,
- prepínanie diagnostického scenára bez zmeny údajov,
- výber udalosti na timeline,
- spotlight konkrétneho faktu v grafe,
- výber ledger riadku a diffu,
- prepnutie L1, L2 a L3 vrstvy,
- prepnutie risk lens,
- otvorenie ukážky gate pred akýmkoľvek rozhodnutím,
- klávesovú navigáciu medzi variantmi,
- prezentačný režim.

Interakcie nemenia dáta ani nesimulujú úspešný zápis. Akcie Potvrdiť, Upraviť, Odmietnuť a Odložiť v ukážke gate zobrazia iba správu `Demonštračný stav · nič sa nezapísalo`.

Globálne skratky sa ignorujú, keď je focus v `input`, `textarea`, `select` alebo `contenteditable`. Galéria má viditeľnú nápovedu a každý shortcut má rovnocenné tlačidlo, aby ovládanie nezáviselo od pamäte ani od klávesnice.

## 15. Responzivita

### 1440 x 1024 a väčšie

Plná kompozícia so sidebarom a inspectorom.

### 1024 až 1439 px

- zmenšený sidebar,
- inspector ako prekryvný panel,
- zachovanie hlavného diagramu,
- žiadny horizontálny overflow celej stránky.

### 768 až 1023 px

- sidebar sa zmení na kompaktnú hornú lištu,
- sekundárne registre sa skladajú pod hlavný diagram,
- graf a timeline ostanú horizontálne posúvateľné iba vo vlastnom kontajneri.

### Menej než 768 px

Prezentačný prototyp poskytne čitateľný stack a list fallback. Mobil nie je primárny cieľ finálneho dashboardu, ale základné informácie a navigácia nesmú byť nedostupné.

## 16. Prístupnosť

- kontrast minimálne WCAG AA,
- viditeľný focus ring,
- všetky interakcie dostupné klávesnicou,
- graf má rovnocenný textový alebo tabuľkový fallback,
- stav nie je komunikovaný iba farbou,
- `prefers-reduced-motion` vypne prechody a prezentačné animácie,
- SVG má titul a opis,
- inspector zachytí focus a po zatvorení ho vráti pôvodnému prvku,
- texty a ovládanie zostanú čitateľné pri 200 percent zoom.

Používateľské rozhranie prototypu je slovenské. Plná česká lokalizácia je mimo tohto exploration setu, ale galéria obsahuje typografický smoke test znakov `Případ · lhůta · důkaz · řízení`, aby embedded font preukázal podporu SK aj CZ glyfov.

## 17. Hodnotiace kritériá

Každý smer sa bude hodnotiť na stupnici 1 až 5:

| Kritérium | Otázka |
|---|---|
| rýchlosť orientácie | Vie advokát do 10 sekúnd povedať, čomu treba venovať pozornosť? |
| právna bezpečnosť | Je jasné, čo je potvrdené, navrhnuté a chybové? |
| provenance | Vie používateľ vysvetliť pôvod dôležitej hodnoty? |
| OKF jedinečnosť | Ukazuje smer hodnotu otvoreného file-first kontraktu? |
| bežná použiteľnosť | Dá sa pohľad používať denne bez kognitívneho preťaženia? |
| prezentačná sila | Vysvetlí smer produkt za menej než minútu? |
| škála | Funguje pre jeden prípad aj budúce vyššie prehľady? |
| implementačné riziko | Dá sa postaviť v LegalWork shelli bez paralelného UI sveta? |

## 18. Overenie

Pred odovzdaním sa vykoná:

1. HTML syntax a kontrola konzoly bez JavaScript chýb.
2. Screenshot každého smeru pri 1440 x 1024.
3. Kontrola pri 1280 x 800, 1024 x 768 a 390 x 844.
4. Klávesová kontrola všetkých interakcií.
5. Kontrola `prefers-reduced-motion`.
6. Kontrola, že každý variant používa rovnaký syntetický dataset.
7. Kontrola, že žiadny variant nepoužíva percento AI istoty alebo nepotvrdenú lehotu ako pravdu.
8. Kontrola, že každý smer má aspoň jednu funkčnú cestu `Ukázať zdroj`.
9. Vizuálna kontrola screenshotov a odstránenie pretekania, kolízií a nečitateľných textov.
10. Kontrola, že v súbore nie sú externé requesty, reálne klientske dáta ani tajomstvá.
11. Kontrola všetkých diagnostických scenárov vrátane empty, partial, stale, parse-error, future-version a offline.
12. Kontrola fullscreen a print preview alebo PDF exportu každého smeru pri zachovaní markera fiktívnych dát.
13. Vizuálna kontrola slovenskej a českej diakritiky v embedded fontoch.

## 19. Acceptance criteria

- Existuje šesť zreteľne odlišných high-fidelity dashboardov.
- Všetky používajú rovnaký dataset a rovnaký referenčný prípad. Portfóliový smer pridáva iba spoločný summary envelope definovaný v tomto dokumente.
- Všetky zostávajú rozpoznateľné ako LAWOSS v LegalWork shelli.
- Každý smer má vlastný informačný diagram a signature interaction.
- Potvrdené, kandidátne, neoverené, stale a chybové dáta sa nedajú zameniť.
- Empty, partial, stale, parse-error, future-version a offline scenár sú prepínateľné bez mutácie údajov.
- Source inspector ukáže súbor, riadok, typ záznamu a históriu.
- Galéria je použiteľná na prezentáciu bez vysvetľovania implementácie.
- Prototyp funguje bez buildu a bez internetu.
- Žiadna interakcia nepredstiera skutočný zápis do OKF.
- Výstup je vizuálne overený na desktope a čitateľný na tablete a mobile.
- Fullscreen aj print export zachovajú marker `Fiktívne dáta · pracovný návrh`.

## 20. Non-goals

- produktová implementácia v repozitári `lawoss`,
- finálne rozhodnutie o poradí dashboardov,
- definovanie API alebo read model schema,
- reálne parsovanie OKF súborov,
- zápis do Markdown,
- login, autorizácia alebo multi-user synchronizácia,
- light verzia celej aplikácie,
- kompletná česká lokalizácia prototypu,
- náhrada LegalWork shellu,
- zmena záväzného LAWOSS design systemu.

## 21. Odporúčanie

Ako produktový default sa má najprv hodnotiť **Podací denník**. Ostatné smery sa majú posudzovať ako špecializované lenses:

- Procesná mapa pre čas a lehoty,
- Dôkazová konštelácia pre vzťahy a provenance,
- Auditný ledger pre kontrolu,
- OKF Brain pre agentickú pamäť,
- Risk Control Tower pre riadenie praxe.

Toto rozdelenie zachováva jeden OKF read model a jeden shell. Rozdielne obrazovky nie sú šesť samostatných produktov, ale šesť spôsobov čítania tej istej otvorenej pravdy.
