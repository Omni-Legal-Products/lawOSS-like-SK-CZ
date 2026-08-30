---
type: note
title: Stanovisko MČ k otvoreným bodom zjednotenia OKF pamäte (O1–O7)
updated: 2026-08-29
---

# Stanovisko MČ k O1–O7 - podklad na call 1. 9.

- **K čomu:** [`zjednotenie.md`](zjednotenie.md) (PR #63) a implementácia v [PR #24](https://github.com/Omni-Legal-Products/lawoss/pull/24).
- **Celkovo:** zjednotený kontrakt **prijímam**. Typovanie, `popis` ako nosič vybavovania, `Pravda` × `História` a brány v nástroji sú správne a doložené prevádzkou. Body 1 a 6 (štruktúra a zakladanie) zostávajú `mc-novy-spis` bez zmeny - to sedí.
- **K piatim bodom Vojtu (O1–O5) pridávam dva vlastné:** O6 (jednotné anglické názvoslovie v jadre) a O7 (kalibrácia kontroly klientskych identifikátorov).
- **Podmienky sú len pri O1** a vyplývajú z dvoch vecí, ktoré som overil spustením kódu z PR #24 proti mojej reálnej šablóne `_STATUS.md`, nie z čítania.

---

## O1 - renderované sekcie `_STATUS.md`: **áno v princípe, s dvomi podmienkami**

Princíp beriem: jedna pravda, projekcia namiesto ručného prepisovania. Ale návrh tvrdí viac, než dnešná implementácia robí.

### Podmienka 1 - render musí **vyplniť existujúce sekcie**, nie pripájať nové

Dnešný `renderStatus` hľadá markery; keď ich nenájde, pripojí **novú sekciu na koniec súboru**. Na mojej šablóne to znamená presne tú dvojitú pravdu, ktorú má O1 odstrániť:

```
## 3. Lehoty          ← ručná, zostáva prázdna
## 4. Chronológia     ← ručná, zostáva prázdna
...
## Lhůty              ← pripojená strojom
## Chronologie        ← pripojená strojom
## Záznamy paměti     ← pripojená strojom
```

(overené: `okf-memory init --sk --apply` + zápis záznamu + `sync --apply` nad `templates/spis/_STATUS.md`)

**Čo žiadam do kontraktu:**
1. Šablóna `_STATUS.md` nesie markery **vnútri** `## 3. Lehoty` a `## 4. Chronológia`. Číslovanie a názvy sekcií zostávajú moje.
2. `retrofit.sh` markery injektuje do existujúcich spisov - append-only, idempotentne, ako `--protocol` (patrí to k O2).
3. `renderStatus`, keď nájde nadpis Lehoty/Chronológia **bez** markerov, nesmie ticho pripojiť duplikát - nech skončí chybou alebo varovaním „spustite retrofit".

### Podmienka 2 - `okf-freshness.sh` **nezaniká**, len sa mu zúži rozsah - a treba ho opraviť

Tvrdenie „drift zaniká a `okf-freshness.sh` tam stráca úlohu" platí pre 2 zo 7 sekcií. Ručné zostávajú **§2 Fakty veci, §5 Otvorené úlohy, §6 Kľúčové dokumenty, §7 Komunikácia** - a to sú práve tie, kde drift bolí najviac (nový dokument v spise, nezapísaný v §6).

Horšie: **`okf-memory sync` drift maskuje.** `okf-freshness.sh` porovnáva mtime `_STATUS.md` s najnovším obsahovým súborom. Keď agent pridá dokument (T1) a potom spustí `sync --apply` (T2 > T1), `_STATUS.md` sa dotkne stroj, freshness zhasne na zelenú - hoci §6 nikto nedoplnil. Detektor driftu prestane detegovať práve v okamihu, keď zapneme projekciu.

**Riešenia (stačí jedno, moje poradie):**
- `sync` po zápise **obnoví pôvodný mtime** `_STATUS.md`, keď sa zmenil iba obsah medzi markermi; alebo
- `_STATUS.md` nesie `human_updated:` vo frontmatteri (bumpuje ho iba človek/protokol zápisu) a `okf-freshness.sh` porovnáva voči nemu; alebo
- freshness ignoruje `_STATUS.md` úplne a porovnáva voči `spis.md`.

### Tri veci navyše, ktoré patria k O1

**(a) Lehoty sú po zjednotení na troch miestach.** `spis.md` frontmatter `lehoty:` + `lehoty:` v zázname + renderovaná tabuľka. To je o jedno miesto viac než dnes. **Návrh: SSOT = záznam pamäte**, tabuľka je projekcia a `lehoty:` v `spis.md` sa buď tiež renderuje, alebo sa z protokolu zápisu vypúšťa. Rozhodnúť treba teraz, nie po migrácii.

**(b) „Záznamy pamäte" v `_STATUS.md` sú nadbytočné.** Ten istý zoznam je v `pamat/INDEX.md` a cesta k nemu vedie cez `BRAIN.md`. `_STATUS.md` je moje rozhranie na vec, nie výpis databázy. **Navrhujem renderovať iba Lehoty a Chronológiu**; `records` nech zostane v INDEX-e. (Ak sa blok ponechá, nech je voliteľný - render iba tam, kde marker je.)

**(c) `[[R-001]]` sa mi v spise neklikne.** Spisy žijú v Drive/Finderi a otvárajú sa v bežnom markdown prehliadači, nie v Obsidiane. Wiki-odkaz tam je mŕtvy text. **Žiadam relatívne markdown odkazy** - `[R-001](pamat/R-001-slug.md)` v `_STATUS.md` aj v `INDEX.md`. Vo vnútri záznamov `[[…]]` nech pokojne zostane (validátor si ich vie preložiť).

### Ak sa O1 zamietne

Alternatíva zo `zjednotenia.md` (pamäť vedľa, `_STATUS.md` celý ručný) je horšia, ale nie katastrofa - dnes tak fungujem. **Neodporúčam ju**, lebo cena je trvalá dvojitá pravda pri lehotách a chronológii, teda pri tom jedinom, kde omyl znamená zmeškanú lehotu.

---

## O2 - migrácia existujúcich spisov: **áno, jednorazovo a nedeštruktívne**

- Pôvodný `MEMORY.md` zostáva na disku nedotknutý, konverzia je čítanie → zápis do `pamat/`. Rovnaká disciplína ako `retrofit.sh`: idempotentné, žiadne mazanie, žiadne presuny.
- **Mapovanie preberá význam existujúcich prefixov:** `TP-XXX → decision`, `LL-XXX → lesson`, `OQ-XXX → question`. Tým sa zachová aj čitateľnosť identifikátorov - navrhujem, aby **id nieslo prefix odvodený z typu** (`D-`, `L-`, `Q-`, `S-`, `A-`), nie jednotný `R-`. Ploché `R-001` po roku nič nehovorí a v `INDEX.md` sa netriedi podľa významu.
- `LL-XXX → lesson` je L1, takže migrácia zapisuje do vrstvy s human gate. **Migračný skript preto beží ako človek**, s jedným súhrnným diffom na odklep - nie záznam po zázname.
- **Do O2 patrí aj injektáž markerov** do `_STATUS.md` existujúcich spisov (podmienka 1 v O1).
- Poradie: najprv jeden reálny spis ako pilot, potom dávka. Migrácia bez piloty nejde.

## O3 - L1 kancelárie: **súhlas s `_kancelaria/pamat/`**

- Koreň kancelárie je správna odpoveď; L1 nemá čo robiť v spise a ešte menej v konfigu agenta.
- **Názov priečinka nech ide z tej istej mapovacej tabuľky** ako pamäť v spise - SK `pamat/`, CZ `pamet/`. Nie natvrdo. *(Ak prejde O6, je to jednoducho `_kancelaria/memory/` a problém zaniká.)*
- Nadväzujúca vec, ktorú treba dopovedať: `okf-validate.sh` dnes o `_kancelaria/` nevie a `okf-freshness.sh` by ju nemal považovať za spis. Prahy: `_kancelaria/` nemá `_STATUS.md` ani `spis.md`.
- L3 (pramene) podľa mňa patrí tiež nad spis - do `_kancelaria/pramene/` alebo do zdieľaného know-how (`/_02_Know_How/`), inak sa ten istý judikát skopíruje do desiatich spisov a `L3_LEAK` sa kontroluje desaťkrát. **Prosím doplniť ako O3b.**

## O4 - multi-user: **necháme otvorené, nie je to blokátor**

- Append-only história konflikt naozaj zmierňuje; `## Pravda` je last-write-wins a pri dnešnej veľkosti tímu (jeden advokát na spis) to nebolí.
- **Podmienka na zatvorenie neskôr:** akonáhle na jednom spise pracujú dvaja, potrebujeme buď zámok na súbor záznamu, alebo `zmena:` ako optimistickú verziu (zápis odmietne, ak sa `zmena:` na disku posunula). To druhé je lacné a dalo by sa pridať už teraz do `planWrite` - **navrhujem to ako malý dodatok, nie ako otvorený bod.**

## O5 - publikovať schému ako štandard: **áno, ale až po O2**

- Súhlasím, že je to lacné, a súhlasím so smerom (Q10 prenositeľnosť).
- **Nie však pred migráciou.** O2 je prvý reálny test schémy na dátach, ktoré nevznikli podľa nej. Publikovať schému a potom ju kvôli migrácii meniť je horšie než nepublikovať.
- Poradie: O2 pilot → korekcie schémy → verzia `okf: 1` zmrazená → publikácia (samostatné repo alebo `specs/` + JSON Schema).

---

## O6 - jednotné anglické názvoslovie v jadre, lokalizácia až na výstupe **(nový bod, MČ)**

**Návrh:** stroj pracuje výhradne po anglicky. Používateľ vidí svoj jazyk. Preklad je vrstva zobrazenia, nie formát na disku.

### Prečo to otváram

Dnešný stav nie je „česko-slovenský", je **rozhodený**. Doložím to na vlastných šablónach - `spis.md` má:

```yaml
type: spis                 # anglický kľúč, slovenská hodnota
title: …                   # anglický kľúč
klient: …                  # slovenský kľúč
oblast_prava: […]          # slovenský kľúč
status: aktívny            # anglický kľúč, slovenská hodnota
lehoty: []                 # slovenský kľúč
```

Vedľa toho `AGENTS.md`, `MEMORY.md`, `_STATUS.md`, `CLAUDE.md` - čisto anglické názvy súborov. **Nekonzistencia je moja, nie Vojtova** - chcem to povedať rovno. PR #24 ju však ide utvrdiť: lokalizuje aj to, čo dnes anglické je (`typ:`, `nazev:`, `popis:`, hodnoty `rozhodnuti`/`rozhodnutie`, priečinok `pamet`/`pamat`, nadpisy `Pravda`/`Historie`).

### Čo konkrétne navrhujem

| Vrstva | Jazyk | Príklad |
|---|---|---|
| kľúče frontmatteru | **EN** | `type:`, `title:`, `summary:`, `deadlines:`, `parties:` |
| hodnoty enumov | **EN** | `type: decision`, `status: active`, `layer: L2` |
| priečinok pamäte | **EN** | `memory/` - jeden, nie `pamet/` × `pamat/` |
| názvy riadiacich súborov | **EN** | `matter.md`, `client.md`, `project.md` (dnes `spis/klient/projekt`) |
| markery a sekcie záznamu | **EN** | `okf:render:deadlines`, `## Truth`, `## History` |
| jurisdikcia | hodnota poľa | `jurisdiction: sk` - **nie názov priečinka** |
| renderované tabuľky v `_STATUS.md` | **jazyk používateľa** | `## 3. Lehoty`, `\| Dátum \| Vec \|` |
| UI appky, CLI hlášky, telá dokumentov | **jazyk používateľa** | existujúcich 278 i18n kľúčov sk/cs |
| **názvy priečinkov oblastí a spisov** | **jazyk používateľa, bez zmeny** | `1 - Podklady od klienta`, `2026-08 X - Vec - typ` |

Posledný riadok je hranica, na ktorej trvám: **priečinky sú ľudské rozhranie vo Finderi a v Drive.** Anglické názvy priečinkov by systém zhoršili a Poľsku ani Maďarsku nepomôžu - tie si aj tak postavia vlastný strom oblastí. Angličtina patrí tam, kde číta stroj.

### Čo to získa

- **N1 z review PR #24 zaniká z definície.** Nie je `pamet` × `pamat`, je `memory/`. Jurisdikcia sa nedetekuje z názvu priečinka, lebo je to hodnota poľa.
- **Nová krajina = nový locale súbor, nie nový stĺpec schémy + migrácia dát.** Dnes by Poľsko znamenalo tretiu kolónku vo `FIELDS` a `TYPE_KEYS`, tretiu sadu nadpisov, tretí názov priečinka a testovú maticu 3×.
- **Spis prenesený medzi jurisdikciami sa neprepisuje.** Česká pobočka otvorí slovenský spis a číta ho.
- **Testová matica CZ/SK sa scvrkne** z perzistencie na zobrazenie.
- Nezhoda medzi `type: spis` (SK hodnota) a `type: matter` (kanonický typ v PR #24) prestane existovať - dnes sú to dve mená pre tú istú vec.

### Čo to stojí

- **Moje existujúce spisy sa premenujú a prekľúčujú** (`type: spis` → `matter`, `lehoty:` → `deadlines:`, `spis.md` → `matter.md`). `retrofit.sh` to zvládne, ale **patrí to do tej istej migrácie ako O2** - nie dvakrát.
- **Napätie, ktoré treba odklepnúť, nie zamlčať:** Vojtova architektúra stojí na tom, že *súbor je rozhranie* - advokát ho otvorí a číta. Anglické kľúče to zhoršujú. Moja protiváha: ľudské rozhranie je `_STATUS.md` a appka, a tie zostávajú lokalizované; **záznam pamäte je formát, nie dokument.** Ak sa tím prikloní k Vojtovi, potom je ale treba prestať tvrdiť, že cieľom je viacjazyčný produkt - lebo pri lokalizovanej perzistencii je každá ďalšia krajina zmena schémy.
- **Kde má Vojta pravdu a treba to zachovať:** keď sa právny pojem medzi jurisdikciami naozaj líši (jeho príklad `lhuty` × `lehoty` ako dve polia jednej schémy, nie preklad jedného), riešením nie je jeden kľúč s dvomi prekladmi, ale **dva kanonické anglické kľúče** s odlišným významom. Preklad rieši jazyk, nie rozdiel v práve.

**Rozhodnutie na call:** ideme na kanonickú angličtinu v jadre? Ak áno, O2 migrácia sa robí rovno na ňu a PR #24 sa upraví pred merge (mapovacia tabuľka zostáva - len prestane byť perzistenčnou schémou a stane sa i18n tabuľkou).

---

## O7 - IČO a identifikátory: kontrola je správna, ale je hrubá a má byť konfigurovateľná **(nový bod, MČ)**

### Najprv oprava faktu - systémový zákaz IČO tam nie je

Kontrola `L3_LEAK` vo `validate.ts` beží **výhradne nad záznamami vrstvy L3** (`authority` - judikáty, ustanovenia, argumentačné vzory):

```ts
for (const r of records) { if (r.layer !== "L3") continue; … }
```

**L2 (spis) má `ico` aj `datum_narodenia` priamo v schéme** a záznamy typu `subject` ich majú niesť - presne tak, ako to robím dnes v `_STATUS.md` § Strany. IČO klienta v spise je v poriadku a nič ho neblokuje. A samotné pravidlo nie je Vojtov nápad - je to veta z môjho [spec 0002](../../specs/0002-okf-operacny-system-praxe.md) („L3 nesmie obsahovať klientsky identifikujúce údaje"), ktorú on len previedol z prompt-u do nástroja.

### Prečo to pravidlo aj tak dáva zmysel

Chránené nie je IČO - to je verejný údaj. Chránená je **väzba**: „táto kancelária zastupuje tohto klienta proti tomuto subjektu v tejto veci". L3 je jediná vrstva, ktorá je určená na zdieľanie naprieč spismi, v rámci kancelárie a potenciálne na publikovanie ako know-how. Klientsky identifikátor, ktorý sa tam usadí, sa o rok vynorí v cudzom spise.

To je **mlčanlivosť podľa §23 ZoA, nie GDPR** - a DPA, DPIA ani zmluva s poskytovateľom modelu ju nevypína. Sú to dve nezávislé osi:

| Otázka | Rieši |
|---|---|
| Smie model vidieť klientske dáta? | DPA / DPIA / GDPR / súhlas klienta - **áno, ak je to ošetrené** |
| Smie sa klientsky údaj **uložiť do zdieľanej vrstvy know-how**? | mlčanlivosť + hygiena vrstiev - **toto rieši `L3_LEAK`** |

Táto brána nehovorí, čo smie ísť do modelu. Hovorí, kde to smie zostať ležať.

### Kde máš pravdu - kontrola je príliš hrubá

Dnes je triggerom aj **obchodné meno subjektu** od 4 znakov, ako substring, case-insensitive. Publikovaný judikát pritom firmy legitímne menuje. „Doprava s.r.o." v prameni zhodí validáciu ako `error`.

**Návrh kalibrácie:**

| Údaj v L3 zázname | Závažnosť |
|---|---|
| rodné číslo, dátum narodenia | `error` - nekonfigurovateľné |
| IČO subjektu **tohto** spisu | `error`, konfigurovateľné na `warning` |
| obchodné meno subjektu tohto spisu | `warning` (dnes `error`) |
| zhoda musí byť na **celé slovo**, nie substring | - |

### Konfigurovateľnosť: áno, ale na úrovni kancelárie

- Prahy patria do `_kancelaria/okf.config` (viď O3), **nie k jednotlivému zápisu**. Per-zápis prepínač je presne to, čo agent zapne, aby prešiel.
- Vypnutie nech je vedomé a s dôvodom zapísaným v konfigu - nie tichý default.
- Advokát je pán svojho spisu; nástroj má varovať, nie moralizovať. Ale hranicu „rodné číslo do zdieľateľnej vrstvy" nechávam tvrdú.

---

## Zhrnutie na hlasovanie

| Bod | Stanovisko MČ |
|---|---|
| **O1** | ÁNO, ak: markery do existujúcich sekcií (nie append) · freshness zostáva a opraví sa maskovanie cez `sync` · lehoty SSOT = záznam · blok `records` von z `_STATUS.md` · markdown odkazy namiesto `[[…]]` |
| **O2** | ÁNO - jednorazovo, nedeštruktívne, `TP→decision / LL→lesson / OQ→question`, id s prefixom typu, pilot na jednom spise |
| **O3** | ÁNO - `_kancelaria/pamat/`, názov z mapovacej tabuľky; **+ O3b: kam patrí L3** |
| **O4** | Otvorené; navrhujem hneď pridať optimistickú kontrolu cez `zmena:` |
| **O5** | ÁNO, ale až po O2 |
| **O6** *(nový)* | Kanonická **angličtina v jadre** (kľúče, enumy, `memory/`, `matter.md`), lokalizácia až na výstupe. Priečinky spisov zostávajú po slovensky. Migrácia spolu s O2. |
| **O7** *(nový)* | `L3_LEAK` **nie je** systémový zákaz IČO - beží iba nad L3 a pochádza zo spec 0002. Ponechať, ale skalibrovať (meno → `warning`, celé slovo) a prahy dať do konfigu kancelárie. |

Verifikácia PR #24 a nálezy z kódu: [`review-pr24.md`](review-pr24.md).
