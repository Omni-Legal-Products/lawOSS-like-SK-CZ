# Počítanie lehôt v slovenskom práve

- **Prispel:** Igor Ribár (IR) · 2026-08-14 · destilát interného deterministického nástroja kancelárie RIBÁR & PARTNERS
- **Pre:** [spec 0005 Lehoty & timeline](../../specs/0005-lehoty-timeline.md) (právne jadro SK, úloha MF+IR)
- **Stav:** draft na revíziu; tvrdenia bez overenia nesú tag [OVERIŤ] a pred použitím ich musí overiť advokát

Podklad pre LAWOSS spec 0005 (Lehoty & timeline). Stav: DRAFT na revíziu advokátmi (MF, IR). Sekcie českého práva doplní CZ tím.

Podklad je destilátom interného deterministického nástroja na výpočet procesných lehôt (ďalej len „zdroj"). Preberá výlučne všeobecné právne pravidlá a ich pramene; každé ustanovenie citované bez tagu [OVERIŤ] je v zdroji overené proti úradnému zneniu predpisu. Ustanovenia označené [OVERIŤ] zdroj výslovne neobsahuje alebo ich neoveril; pred publikáciou ich musí overiť advokát.

## Metodické zásady zdroja (odporúčané prevziať do spec 0005)

1. **Výpočet lehoty je čistá kalendárna aritmetika, nie úsudok modelu.** Koniec lehoty vzniká výhradne behom deterministického algoritmu s testami; AI vrstva výsledok len tlmočí.
2. **Fail-closed katalóg.** Dĺžka a právny základ lehoty sa berú z katalógu, v ktorom je každý záznam overený proti úradnému zneniu predpisu. Neoverený typ lehoty algoritmus odmietne vypočítať; dĺžka sa nikdy nedosadzuje z pamäte modelu.
3. **Pravidlá počítania sa viažu na predpis, pod ktorý lehota patrí.** Trestná lehota sa nikdy nepočíta podľa pravidiel civilného predpisu a naopak; audit trail (zdroj overenia) sa vedie per predpis.
4. **Neistota sa propaguje, nezamlčiava.** Každý krok opretý o neoverený vstup (napríklad tabuľku sviatkov) nesie tag [OVERIŤ] až do finálneho výstupu.
5. **Human gate.** Vypočítaný koncový dátum je vždy pracovný návrh; pred spoľahnutím ho potvrdzuje advokát. Zmeškaná lehota je najdrahšia chyba advokácie.

## 1. Kategórie lehôt

### 1.1 Slovenské právo

**Procesné vs. hmotnoprávne lehoty.** Zdroj pokrýva procesné lehoty podania (odvolanie, sťažnosť, dovolanie, žaloba na obnovu konania, ústavná sťažnosť, správna žaloba, kasačná sťažnosť). Hmotnoprávne premlčacie a prekluzívne doby zdroj vedome nepokrýva; identifikuje ich ako samostatnú etapu, ktorej obsah vyžaduje odbornú kontrolu pred automatizáciou. Prakticky na rozlíšení záleží minimálne v troch bodoch:

1. **Posun konca lehoty.** Pri procesných lehotách sa koniec pripadajúci na sobotu alebo deň pracovného pokoja posúva na najbližší nasledujúci pracovný deň (§ 121 ods. 4 CSP, § 63 ods. 5 TP, § 69 ods. 5 SSP). Pri hmotnoprávnej preklúzii po márnom uplynutí doby právo zaniká; zdroj ako príklad uvádza dvojmesačnú prekluzívnu lehotu podľa § 77 Zákonníka práce (č. 311/2001 Z. z. [OVERIŤ]), ktorej koniec označuje za tvrdú preklúziu. Či sa aj na hmotnoprávnu lehotu uplatní posun z dňa pracovného pokoja, zdroj nerieši [OVERIŤ].
2. **Spôsob zachovania lehoty.** Rozlíšenie „procesná lehota je zachovaná odovzdaním podania na poštovú prepravu, hmotnoprávna lehota vyžaduje, aby podanie v lehote došlo súdu" zdroj neupravuje; presné ustanovenia per predpis doplní advokát [OVERIŤ].
3. **Odpustenie zmeškania.** Zmeškanie procesnej lehoty možno za podmienok § 122 CSP odpustiť (návrh do 15 dní od odpadnutia prekážky, spolu so zmeškaným úkonom); pri lehote na žalobu na obnovu konania je odpustenie zmeškania vylúčené (§ 407 CSP).

**Zákonné vs. sudcovské lehoty.** Zákonné lehoty majú dĺžku a začiatok určené predpisom a v katalógu sú overené citáciou. Sudcovské lehoty (napríklad výzvová lehota určená súdom) sa počítajú rovnakou aritmetikou príslušného procesného predpisu, ale ich dĺžku a právny základ zadáva používateľ; systém taký základ označí ako neoverený a výstup nesie príslušné upozornenie. Odporúčanie pre spec 0005: sudcovská lehota nikdy nesmie ticho prevziať dôveryhodnosť katalógového záznamu.

### 1.2 České právo

Doplní CZ tím.

## 2. Pravidlá počítania

### 2.1 Slovenské právo

Zdroj obsahuje pravidlá počítania pre štyri predpisy. Znenie pravidiel je v zdroji overené proti úradnému textu (s výnimkami označenými [OVERIŤ]).

#### Civilný sporový poriadok (zákon č. 160/2015 Z. z.)

| Č. | Pravidlo | Ustanovenie |
|---|---|---|
| P-01 | Do plynutia lehoty určenej podľa dní sa nezapočítava deň, keď nastala skutočnosť určujúca začiatok lehoty (dies a quo). | § 121 ods. 2 CSP |
| P-02 | Lehoty určené podľa týždňov, mesiacov alebo rokov sa končia uplynutím dňa, ktorý sa svojím označením zhoduje s dňom, keď nastala skutočnosť určujúca začiatok lehoty; ak taký deň v mesiaci niet, posledným dňom mesiaca. | § 121 ods. 3 CSP |
| P-03 | Ak koniec lehoty pripadne na sobotu alebo deň pracovného pokoja, posledným dňom lehoty je najbližší nasledujúci pracovný deň. Sobota je v znení menovaná výslovne. | § 121 ods. 4 CSP |

#### Trestný poriadok (zákon č. 301/2005 Z. z.)

| Č. | Pravidlo | Ustanovenie |
|---|---|---|
| P-04 | Do lehoty určenej podľa dní sa nezapočítava deň, v ktorom sa stala udalosť určujúca začiatok lehoty. | § 63 ods. 3 TP |
| P-05 | Lehota určená podľa týždňov, mesiacov alebo rokov sa skončí uplynutím dňa, ktorý pomenovaním alebo číselným označením zodpovedá dňu udalosti; ak taký deň v poslednom mesiaci chýba, uplynutím posledného dňa mesiaca. | § 63 ods. 4 TP |
| P-06 | Koniec lehoty na deň pracovného pokoja alebo pracovného voľna sa posúva na najbližší budúci pracovný deň; to neplatí pre lehotu väzby. Znenie sobotu nemenuje výslovne (na rozdiel od CSP a SSP), zahŕňa ju však ako deň pracovného voľna. | § 63 ods. 5 TP |
| P-07 | Lehota na sťažnosť proti uzneseniu je tri PRACOVNÉ dni od oznámenia uznesenia; dni pracovného pokoja a voľna sa do plynutia vôbec nezapočítavajú (nejde len o posun konca). | § 187 ods. 1 TP |

#### Správny súdny poriadok (zákon č. 162/2015 Z. z.)

| Č. | Pravidlo | Ustanovenie |
|---|---|---|
| P-08 | Do lehoty určenej podľa dní sa nezapočítava deň, v ktorom sa stala udalosť určujúca začiatok lehoty. | § 69 ods. 3 SSP |
| P-09 | Lehota určená podľa týždňov, mesiacov alebo rokov sa skončí uplynutím dňa zodpovedajúceho pomenovaním alebo číselným označením dňu udalosti; ak taký deň v poslednom mesiaci chýba, uplynutím posledného dňa mesiaca. | § 69 ods. 4 SSP |
| P-10 | Koniec lehoty na sobotu alebo deň pracovného pokoja sa posúva na najbližší nasledujúci pracovný deň; to neplatí na lehotu určenú podľa hodín. | § 69 ods. 5 SSP |

#### Zákon o Ústavnom súde SR (zákon č. 314/2018 Z. z.)

| Č. | Pravidlo | Ustanovenie |
|---|---|---|
| P-11 | Zákon č. 314/2018 Z. z. vlastné pravidlá počítania lehôt NEOBSAHUJE (overené prehľadaním úplného znenia). Pri lehote ústavnej sťažnosti zdroj aplikuje mesačnú aritmetiku zhodného označenia a posun konca z dňa pracovného pokoja, oporu pre subsidiárne použitie procesného predpisu však treba overiť [OVERIŤ]. | zákon č. 314/2018 Z. z. |

#### Dni pracovného pokoja a sviatky

| Č. | Pravidlo | Prameň |
|---|---|---|
| P-12 | Dňami pracovného pokoja sú sobota a nedeľa, 13 fixných sviatkov (1.1., 6.1., 1.5., 8.5., 5.7., 29.8., 1.9., 15.9., 1.11., 17.11., 24.12., 25.12., 26.12.) a pohyblivé dni Veľký piatok a Veľkonočný pondelok, odvodené od dátumu Veľkonočnej nedele (algoritmicky vypočítateľný, napr. Meeusov algoritmus). Tento zoznam zdroj NEMÁ overený proti úradnému zneniu zákona č. 241/1993 Z. z. o štátnych sviatkoch, dňoch pracovného pokoja a pamätných dňoch; každý posun cez nedeľu alebo sviatok preto nesie [OVERIŤ]. Sobota je overená nezávisle priamo zo znenia § 121 ods. 4 CSP. | zákon č. 241/1993 Z. z. [OVERIŤ] |

**Hmotnoprávne počítanie času podľa Občianskeho zákonníka (§ 122 OZ [OVERIŤ]) zdroj neobsahuje**; pravidlá počítania hmotnoprávnych dôb doplní advokát.

#### Katalóg overených lehôt (dĺžka, začiatok, prameň)

| Č. | Lehota | Dĺžka | Začiatok plynutia | Ustanovenie |
|---|---|---|---|---|
| K-01 | Odvolanie (CSP) | 15 dní | doručenie rozhodnutia | § 362 ods. 1 CSP |
| K-02 | Odvolanie pri chýbajúcom alebo nesprávnom poučení (CSP) | 3 mesiace | doručenie rozhodnutia | § 362 ods. 3 CSP |
| K-03 | Dovolanie (CSP) | 2 mesiace | doručenie rozhodnutia odvolacieho súdu oprávnenému subjektu | § 427 ods. 1 CSP |
| K-04 | Sťažnosť proti uzneseniu (CSP) | 15 dní | doručenie uznesenia | § 242 CSP |
| K-05 | Žaloba na obnovu konania, subjektívna lehota (CSP) | 3 mesiace | odkedy sa žalobca mohol dozvedieť o dôvode obnovy alebo ho mohol uplatniť | § 403 ods. 1 CSP |
| K-06 | Žaloba na obnovu konania, objektívna lehota (CSP) | 3 roky | právoplatnosť napadnutého rozhodnutia | § 403 ods. 2 CSP |
| K-07 | Návrh na odpustenie zmeškania lehoty (CSP); pripojiť aj zmeškaný úkon | 15 dní | odpadnutie prekážky | § 122 CSP |
| K-08 | Odvolanie (TP) | 15 dní | oznámenie rozsudku (vyhlásenie v prítomnosti oprávnenej osoby, inak doručenie) | § 309 ods. 1 TP |
| K-09 | Sťažnosť proti uzneseniu (TP) | 3 pracovné dni | oznámenie uznesenia | § 187 ods. 1 TP |
| K-10 | Dovolanie (TP) | 3 roky | doručenie rozhodnutia obvinenému (v jeho prospech), resp. prokurátorovi (v neprospech) | § 370 ods. 1 TP |
| K-11 | Ústavná sťažnosť (čl. 127 Ústavy SR) | 2 mesiace | právoplatnosť rozhodnutia, oznámenie opatrenia alebo upovedomenie o inom zásahu | § 124 zákona č. 314/2018 Z. z. |
| K-12 | Správna žaloba (SSP) | 2 mesiace | oznámenie rozhodnutia alebo opatrenia orgánu verejnej správy | § 181 ods. 1 SSP |
| K-13 | Kasačná sťažnosť (SSP) | 1 mesiac | doručenie rozhodnutia správneho súdu oprávnenému subjektu | § 443 ods. 1 SSP |
| K-14 | Kasačná sťažnosť vo veciach zaistenia (SSP) | 7 dní | doručenie rozhodnutia správneho súdu | § 443 ods. 2 SSP |

### 2.2 České právo

Doplní CZ tím.

## 3. Doručovanie a fikcia doručenia

### 3.1 Slovenské právo

**Rozsah pokrytia zdroja je tu obmedzený.** Zdroj pracuje s doručením, oznámením alebo inou rozhodnou udalosťou ako so zadaným vstupom (dátumom); samotné posúdenie, KEDY bolo doručené, nepokrýva. Konkrétne:

- **Fikcia doručenia** (náhradné doručenie, márne uplynutie úložnej lehoty) je v zdroji výslovne vyčlenená ako samostatná neimplementovaná etapa s povinnou odbornou kontrolou obsahu; pravidlá a ustanovenia doplní advokát.
- **Elektronické schránky** (zákon č. 305/2013 Z. z. o e-Governmente, úložná lehota) zdroj vôbec neupravuje [OVERIŤ]; doplní advokát.
- **Poštové doručovanie a osobitné doručovacie režimy CSP/TP/SSP** zdroj neupravuje; doplní advokát.

Čo zdroj k rozhodnej udalosti obsahuje a je použiteľné pre spec:

1. **Doručenie vs. oznámenie.** V trestnom konaní plynie odvolacia lehota od OZNÁMENIA rozsudku, ktorým je vyhlásenie v prítomnosti oprávnenej osoby, inak doručenie (§ 309 ods. 1 TP). Nezamieňať s civilným režimom, kde plynie od doručenia (§ 362 ods. 1 CSP).
2. **Viacerí príjemcovia.** Ak sa rozsudok oznamuje obžalovanému aj obhajcovi a zákonnému zástupcovi, lehota plynie od oznámenia vykonaného najneskoršie (§ 309 ods. 2 TP). Obdobné pravidlo najneskoršieho doručenia platí pri dovolaní v trestnom konaní, ak sa rozhodnutie doručuje obvinenému aj obhajcovi alebo zákonnému zástupcovi. Prokurátorovi plynie lehota samostatne (§ 309 ods. 4 TP).
3. **Ústavná sťažnosť.** Ak rozhodnutie nadobúda právoplatnosť vyhlásením a zároveň sa doručuje písomné vyhotovenie, lehota plynie od doručenia písomného vyhotovenia; pri opatrení alebo inom zásahu plynie odo dňa, keď sa sťažovateľ mohol o ňom dozvedieť; po mimoriadnom opravnom prostriedku plynie od doručenia rozhodnutia o ňom (§ 124 zákona č. 314/2018 Z. z.).
4. **Správna žaloba.** Prokurátor a zainteresovaná verejnosť majú vlastný, odlišný začiatok plynutia (§ 181 ods. 2 a 3 SSP).

### 3.2 České právo

Doplní CZ tím.

## 4. Osobitné pasce

### 4.1 Slovenské právo

| Č. | Pasca | Opora |
|---|---|---|
| T-01 | Rozhodná udalosť sa líši per typ lehoty: doručenie, oznámenie, právoplatnosť, dozvedenie sa o dôvode, odpadnutie prekážky. Nesprávne zvolená udalosť dáva formálne správny výpočet z nesprávneho dátumu. | katalóg K-01 až K-14 |
| T-02 | Obnova konania má dvojicu lehôt: subjektívnu (3 mesiace od možnosti dozvedieť sa o dôvode, § 403 ods. 1 CSP) a objektívnu (3 roky od právoplatnosti, § 403 ods. 2 CSP); platí skoršia z hraníc. Odpustenie zmeškania je vylúčené (§ 407 CSP). | § 403, § 407 CSP |
| T-03 | Chýbajúce poučenie alebo nesprávne poučenie o neprípustnosti odvolania predlžuje odvolaciu lehotu z 15 dní na 3 mesiace (§ 362 ods. 3 CSP). | § 362 ods. 1 a 3 CSP |
| T-04 | Sťažnosť podľa § 187 ods. 1 TP plynie v PRACOVNÝCH dňoch, nie kalendárnych; „tri dni" počítané kalendárne dávajú nesprávny výsledok. Výnimky: uznesenia podľa § 83 ods. 2 TP; v skrátenom vyšetrovaní sa sťažnosť podáva do skončenia vyšetrovania (§ 204 ods. 1 TP). | § 187 ods. 1, § 83 ods. 2, § 204 ods. 1 TP |
| T-05 | Väzobné lehoty: § 63 ods. 5 TP posun konca na najbližší pracovný deň pre lehotu väzby VÝSLOVNE VYLUČUJE. Nejde o medzeru katalógu, ale o odlišné pravidlo počítania; automatizovaný výpočet ich musí odmietnuť, nie „dopočítať". | § 63 ods. 5 TP |
| T-06 | Dvojinštančné a viacsubjektové situácie: pri oznámení viacerým oprávneným osobám plynie lehota od najneskoršieho oznámenia (§ 309 ods. 2 TP; obdobne dovolanie TP); prokurátor má samostatné plynutie (§ 309 ods. 4 TP). | § 309 ods. 2 a 4 TP |
| T-07 | Ústavná sťažnosť po mimoriadnom opravnom prostriedku: lehota plynie od doručenia rozhodnutia o ňom, nie od pôvodného rozhodnutia; pri právoplatnosti vyhlásením plynie od doručenia písomného vyhotovenia (§ 124 zákona č. 314/2018 Z. z.). Pravidlá počítania pre konanie pred ÚS SR treba opierať o subsidiaritu procesného predpisu [OVERIŤ]. | § 124 zákona č. 314/2018 Z. z. |
| T-08 | Kombinácia hmotnoprávnej a procesnej roviny: žaloba o neplatnosť skončenia pracovného pomeru podľa § 77 Zákonníka práce podlieha dvojmesačnej hmotnoprávnej PREKLUZÍVNEJ lehote plynúcej odo dňa, keď sa mal pracovný pomer skončiť; počítanie od skončenia pracovného pomeru potvrdil veľký senát NS SR sp. zn. 1VCdo/2/2019 z 26.01.2021 [OVERIŤ verbatim pred citáciou v podaní]. Slovo „najneskôr" v § 77 určuje len koniec lehoty; podanie pred začiatkom jej plynutia môže vyvolať námietku predčasnosti. Po márnom uplynutí právo zaniká. | § 77 Zákonníka práce |
| T-09 | Reťazenie sviatku a víkendu: posun konca sa vykonáva iteratívne, kým prvý deň nie je pracovný (napríklad naivný koniec piatok 01.05. posunie sviatok, sobota a nedeľa až na pondelok 04.05.). | § 121 ods. 4 CSP, § 63 ods. 5 TP, § 69 ods. 5 SSP |
| T-10 | Mesačná lehota z konca mesiaca: ak deň zhodného označenia v poslednom mesiaci neexistuje (31., 30., 29. vo februári), lehota končí posledným dňom mesiaca; vo februári teda 28., v priestupnom roku 29. | § 121 ods. 3 CSP, § 63 ods. 4 TP, § 69 ods. 4 SSP |
| T-11 | Posun z dňa pracovného pokoja sa uplatní LEN na koniec lehoty; dni pokoja vnútri plynutia sa započítavajú. Výnimkou sú lehoty určené v pracovných dňoch (§ 187 ods. 1 TP), kde sa dni pokoja nezapočítavajú vôbec. | P-03, P-06, P-07, P-10 |
| T-12 | SSP: kasačná sťažnosť má vo veciach zaistenia skrátenú lehotu 7 dní (§ 443 ods. 2 SSP) namiesto mesiaca; pri opravnom uznesení plynie lehota znovu len v rozsahu vykonanej opravy. Posun konca neplatí na lehoty určené podľa hodín (§ 69 ods. 5 SSP). | § 443, § 69 ods. 5 SSP |
| T-13 | Sudcovské lehoty (výzvové a podobné) nemajú katalógovú oporu; dĺžku zadáva používateľ a systém musí právny základ označiť ako neoverený, inak výpočet nesie falošnú autoritu. | metodická zásada 2 |
| T-14 | Zoznam sviatkov je časovo premenlivý údaj: posun cez nedeľu alebo sviatok je spoľahlivý len proti overenému zneniu zákona č. 241/1993 Z. z. k rozhodnému dátumu [OVERIŤ]; implementácia má neoverenú tabuľku sviatkov flagovať, nie ticho použiť. | zákon č. 241/1993 Z. z. [OVERIŤ] |

### 4.2 České právo

Doplní CZ tím.

## 5. Testovacie prípady

Všetky očakávané dátumy boli vypočítané deterministickým algoritmom zdroja (nie odhadom) a hraničné prípady sú kryté jeho testovacou sadou. Poznámky k tabuľke:

- Spôsob doručenia zdroj nerozlišuje (fikcie doručenia nepokrýva); vstupom je vždy už ustálený dátum rozhodnej udalosti. Testovacie prípady fikcie doručenia preto v podklade chýbajú a doplní ich advokát.
- Prípady, ktorých výsledok závisí od posunu cez nedeľu alebo sviatok, nesú [OVERIŤ] k zoznamu dní pracovného pokoja (zákon č. 241/1993 Z. z., pozri P-12); posun cez sobotu je overený priamo zo znenia § 121 ods. 4 CSP.
- Dátumy vo formáte DD.MM.RRRR.

| Č. | Typ lehoty (predpis) | Dĺžka | Rozhodná udalosť a dátum | Očakávaný posledný deň | Odôvodnenie |
|---|---|---|---|---|---|
| 1 | odvolanie (CSP), zákonná | 15 dní | doručenie rozsudku 02.03.2026 (pondelok) | 17.03.2026 (utorok) | Deň doručenia sa nezapočítava (§ 121 ods. 2 CSP), 15. deň je pracovný, bez posunu (§ 362 ods. 1 CSP). |
| 2 | výzvová lehota určená súdom, sudcovská | 5 dní | doručenie výzvy 02.03.2026 | 09.03.2026 (pondelok) | Naivný koniec sobota 07.03. sa posúva na najbližší pracovný deň (§ 121 ods. 4 CSP); posun prechádza nedeľou [OVERIŤ]; právny základ dĺžky zadal používateľ, systém ho neoveruje. |
| 3 | modelová mesačná lehota (CSP) | 1 mesiac | udalosť 31.01.2026 | 02.03.2026 (pondelok) | Deň zhodného označenia vo februári niet, lehota končí 28.02. (§ 121 ods. 3 CSP), sobota sa posúva na pondelok (§ 121 ods. 4 CSP) [OVERIŤ nedeľa]. |
| 4 | modelová denná lehota (CSP) | 1 deň | udalosť 30.04.2026 | 04.05.2026 (pondelok) | Naivný koniec 01.05. je sviatok, nasleduje víkend; posun sa reťazí až na prvý pracovný deň (§ 121 ods. 4 CSP) [OVERIŤ sviatok]. |
| 5 | modelová ročná lehota (CSP) | 1 rok | udalosť 29.02.2024 (priestupný deň) | 28.02.2025 (piatok) | Deň zhodného označenia v nepriestupnom roku niet, lehota končí posledným dňom februára (§ 121 ods. 3 CSP), bez posunu. |
| 6 | dovolanie (CSP) | 2 mesiace | doručenie rozhodnutia odvolacieho súdu 12.05.2026 | 13.07.2026 (pondelok) | Deň zhodného označenia 12.07. je nedeľa, posun na najbližší pracovný deň (§ 427 ods. 1, § 121 ods. 3 a 4 CSP) [OVERIŤ nedeľa]. |
| 7 | dovolanie (CSP) | 2 mesiace | doručenie 31.12.2026 | 01.03.2027 (pondelok) | Deň 31.02. neexistuje, lehota končí 28.02.2027 (§ 121 ods. 3 CSP); nedeľa sa posúva na pondelok (§ 121 ods. 4 CSP) [OVERIŤ nedeľa]. |
| 8 | odvolanie pri chýbajúcom poučení (CSP) | 3 mesiace | doručenie 30.11.2026 | 01.03.2027 (pondelok) | Deň 30.02. neexistuje, koniec 28.02.2027 (§ 362 ods. 3, § 121 ods. 3 CSP); nedeľa sa posúva na pondelok (§ 121 ods. 4 CSP) [OVERIŤ nedeľa]. |
| 9 | žaloba na obnovu konania, subjektívna (CSP) | 3 mesiace | dozvedenie sa o dôvode obnovy 01.09.2026 | 01.12.2026 (utorok) | Lehota končí dňom zhodného označenia (§ 403 ods. 1, § 121 ods. 3 CSP), pracovný deň, bez posunu. |
| 10 | odvolanie (TP) | 15 dní | oznámenie rozsudku 02.03.2026 | 17.03.2026 (utorok) | Deň oznámenia sa nezapočítava (§ 63 ods. 3 TP), koniec je pracovný deň (§ 309 ods. 1 TP); trestná lehota sa počíta podľa § 63 TP, nie podľa CSP. |
| 11 | sťažnosť proti uzneseniu (TP) | 3 pracovné dni | oznámenie uznesenia 05.03.2026 (štvrtok) | 10.03.2026 (utorok) | Lehota plynie len v pracovných dňoch, sobota a nedeľa sa nezapočítavajú (§ 187 ods. 1 TP). |
| 12 | sťažnosť proti uzneseniu (TP) | 3 pracovné dni | oznámenie uznesenia 06.03.2026 (piatok) | 11.03.2026 (streda) | Tri pracovné dni od piatka sú pondelok, utorok a streda (§ 187 ods. 1 TP); koniec nikdy nepadne na deň pokoja. |
| 13 | dovolanie (TP) | 3 roky | doručenie rozhodnutia 02.03.2026 | 02.03.2029 (piatok) | Lehota končí dňom zhodného označenia o tri roky (§ 370 ods. 1, § 63 ods. 4 TP), pracovný deň, bez posunu. |
| 14 | ústavná sťažnosť (zákon č. 314/2018 Z. z.) | 2 mesiace | právoplatnosť rozhodnutia 02.03.2026 | 04.05.2026 (pondelok) | Deň zhodného označenia 02.05. je sobota, posun na pondelok; zákon č. 314/2018 Z. z. vlastné pravidlá počítania nemá, subsidiárne použitie procesného predpisu [OVERIŤ] (§ 124 zákona č. 314/2018 Z. z.). |
| 15 | správna žaloba (SSP) | 2 mesiace | oznámenie rozhodnutia orgánu verejnej správy 02.03.2026 | 04.05.2026 (pondelok) | Deň zhodného označenia 02.05. je sobota, posun na najbližší pracovný deň (§ 181 ods. 1, § 69 ods. 4 a 5 SSP) [OVERIŤ nedeľa]. |
| 16 | kasačná sťažnosť (SSP) | 1 mesiac | doručenie rozhodnutia správneho súdu 02.03.2026 | 02.04.2026 (štvrtok) | Lehota končí dňom zhodného označenia (§ 443 ods. 1, § 69 ods. 4 SSP), pracovný deň, bez posunu. |
| 17 | kasačná sťažnosť (SSP) | 1 mesiac | doručenie 31.03.2026 | 30.04.2026 (štvrtok) | Deň 31.04. neexistuje, lehota končí posledným dňom apríla (§ 443 ods. 1, § 69 ods. 4 SSP), bez posunu. |
| 18 | kasačná sťažnosť (SSP) | 1 mesiac | doručenie 31.01.2028 | 29.02.2028 (utorok) | Deň 31.02. neexistuje, v priestupnom roku lehota končí 29.02. (§ 443 ods. 1, § 69 ods. 4 SSP), bez posunu. |
| 19 | kasačná sťažnosť vo veciach zaistenia (SSP) | 7 dní | doručenie rozhodnutia 02.03.2026 | 09.03.2026 (pondelok) | Deň doručenia sa nezapočítava (§ 69 ods. 3 SSP), 7. deň je pondelok, bez posunu (§ 443 ods. 2 SSP). |

České testovacie prípady: doplní CZ tím.

## 6. Témy nepokryté zdrojom (doplní advokát pri revízii)

1. **Hmotnoprávne počítanie času** podľa Občianskeho zákonníka (§ 122 OZ [OVERIŤ]) a premlčacie a prekluzívne doby OZ a Obchodného zákonníka.
2. **Fikcie doručenia**: elektronické schránky podľa zákona č. 305/2013 Z. z. a úložná lehota [OVERIŤ], poštové doručovanie, náhradné doručenie a osobitné doručovacie režimy CSP, TP a SSP.
3. **Zachovanie lehoty** podaním na poštovú prepravu alebo elektronickým podaním vs. hmotnoprávna požiadavka dôjdenia, s presnými ustanoveniami per predpis [OVERIŤ].
4. **Zoznam dní pracovného pokoja**: overenie fixných aj pohyblivých sviatkov proti úradnému zneniu zákona č. 241/1993 Z. z. vrátane časových verzií (zoznam sa novelami mení).
5. **Opora subsidiárneho použitia procesného predpisu** na počítanie lehoty ústavnej sťažnosti (zákon č. 314/2018 Z. z. vlastné pravidlá nemá).
6. **Väzobné lehoty** (§ 63 ods. 5 TP vylučuje posun konca) a **lehoty určené podľa hodín** (§ 69 ods. 5 SSP): odlišné režimy počítania, ktoré katalóg zámerne nepokrýva.
7. **Ďalšie procesné poriadky a typy lehôt** mimo katalógu: Civilný mimosporový poriadok, správne konanie pred orgánom verejnej správy (Správny poriadok), exekučné a upomínacie konanie, poplatkové lehoty, lehoty v konaní pred ESĽP a SDEÚ.
8. **Judikatúrne ukotvenie** pravidiel počítania (zdroj obsahuje jedinú judikatúrnu kotvu, 1VCdo/2/2019 k § 77 Zákonníka práce, aj tú s výhradou [OVERIŤ verbatim]).
