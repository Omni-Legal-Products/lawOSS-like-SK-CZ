# Dopady callu 7. 9. 2026 na OKF a na nastavenia aplikácie

- **Pre koho:** MČ (a tím) — prechod callu proti rozhodovaciemu registru zo 6. 9. a proti stavu kódu
- **Zdroje:** [zápis 7. 9.](../meetings/2026-09-07-zapis-tyzdenne-stretnutie.md) · [rozhodovací podklad MČ 6. 9.](2026-09-06-rozhodovaci-podklad-mc.md) · [zápis 2. 9.](2026-09-02-zapis-sedenie-fork-okf-faza-a.md) · **kód overený 7. 9. 2026**: `lawoss` @ `dev` a vetvy `feat/okf-obsidian-vault`, `feat/marketplace-capability-catalog`; `lawoss-marketplace` @ `main` (`d9631fb`)
- **Ako čítať:** A = register rozhodnutí so stavom po calle. B = čo call zmenil v OKF kontrakte. C = nastavenia aplikácie. D = marketplace a výkon. E = riziká voči 16. 9. **F až I sú návrhy na rozhodnutie** — dve osi typizácie, kontext k otvoreným OKF bodom, inštalácia marketplace a čítací kanál pre dashboard.

---

## Časť A — Register rozhodnutí zo 6. 9. po calle

> [!NOTE]
> **Stav po calle 11. 9. 2026** *(VŘ neprítomný, [zápis](../meetings/2026-09-11-zapis-sync-call.md))*
> — **R1 vrstvy:** MČ ich výslovne delegoval na VŘ; písomná veta naďalej neexistuje, teraz bez termínu.
> — **R2 poverenie, R3 `L3_LEAK`:** nezaznelo, ostávajú na VŘ.
> — **R4 kontrakt spisu:** dve z ôsmich trení vyriešené rozhodnutím MČ — anglické strojové názvy *(padá spor `klient.md` × `client.md`)* a `_kancelaria` → `Office`. Šesť zostáva.
> — **R6 meno:** potvrdene otvorené a nie je to blokátor.
> — **Nové pravidlo:** strojová vrstva po anglicky, obsah zápisov v jazyku advokáta. Z toho priamo vyplýva premenovanie `EVENT_KINDS`.
> — **RAM (rozhodnutia 13–14 zo 7. 9.):** **prekonané** — rozpočet ~4 GB a jednotná metodika merania padli ako blokátor, ostáva len ukazovateľ spotreby.
> — **Termín bety 16. 9.:** **nepotvrdený**; nahradila ho vstupná podmienka alfy *(Anthropic · preklad · odstránené komerčné prvky · základné OKF)*.
> — **C a I (katalóg, workspace riadok, OKF tab):** nepohli sa.


| # | Rozhodnutie | Stav | Poznámka |
|---|---|---|---|
| **R1** | Význam vrstiev L1/L2/L3 | 🟡 **ústne uzavreté, písomne nie** | Na calle sa o vrstvách vecne nehovorilo; MČ ich v závere označil za vyriešené. Vetu treba zapísať, kód VŘ na nej stojí. |
| **R2** | Rozsah zamietnutia ceremónie + trvalé poverenie (#31) | 🟢 **prvá polovica** / 🔴 druhá | Ceremónia padla definitívne a VŘ odstráni aj zvyškový kód. **Podmienky poverenia sa neriešili** → kontext a návrh v **G1**. |
| **R3** | `L3_LEAK` a prahy | 🔴 nezaznelo | Kontext a návrh v **G2**. |
| **R4** | Jeden kontrakt spisu (Fáza A × `okf-pamat`) | 🟡 princíp áno, práca nerozdelená | Rozdelenie práce v **G4**. **Najväčšie riziko termínu.** |
| **R5** | SSOT lehôt a drift | 🟡 čiastočne | Uzavreté: lehota je vlastný typ, ktorý appka prečíta a zobrazí. Neuzavreté: či `lehoty:` odchádzajú zo `spis.md`. |
| **R6** | Meno OKF, `log.md`, `EVENT_KINDS` | 🟡 meno otvorené / 🔴 `EVENT_KINDS` | Vecne sme pri variante „profil". `EVENT_KINDS` je podmienka pred merge #35 → **G3**. |
| **R7** | Approve reťaze #24 → #31 → #35 | 🟢 uzavreté | Podmienky treba doplniť do PR ako follow-up. |
| **R8** | Prehľad a Lehoty (C1–C3), `read.ts` | 🟡 nepriamo | Dashboard potvrdený ako smer; čítací kanál je rozpísaný v **I**. |
| **R9** | Pilot migrácie spisu MČ | 🔴 zamenené | „Pilot" na calle = beta appky 16. 9., nie migrácia spisu. |
| **R10** | Reconciliation a subjektový research — vlastník | 🟡 polovica | Reconciliácia indexov a stale statusov je záväzná. Research nemá vlastníka. |
| **R11** | Prepis spec 0014, PR #64 a #67 | 🔴 nezaznelo | Call dal nový obsah pre §9/§10 — prepis má oporu v zápise. |
| **M1** | Martinova PR #36 k marketplace | 🟡 | VŘ ju pozrie. **Katalóg v nej je demo dáta** — viď H3. |
| **M2** | Push katalógu do `lawoss-marketplace` | 🟢 **hotové 7. 9.** | `main` = `d9631fb`, 15 pluginov, 14 so skillom. |
| **M3** | Verejné × private | 🔴 **blokátor inštalácie** | Technický dôvod je overený v **H2** — nie je to len organizačná otázka. |
| **O1** | Onboarding MF | 🟡 rozšírený, nie naplánovaný | Pribudol mu profil pracovnej štruktúry (B1). |
| **O2** | Light verzia | ⚪ neriešené | |
| **D1** | PR #23 hranaté rohy | ⚪ neriešené | Otvorené od 28. 8. |
| **D2** | Logo | ⚪ neriešené | Pribudla požiadavka na grafickejšie rozhranie pre marketing. |
| **I1** | OKF tab v Settings, „Add folder" | 🟡 rozšírené o tri veci | Viď časť C. |
| **I2/I3** | PATCHES.md, upstream sync | ⚪ neriešené | Od 1. 9. nesledované. |

---

## Časť B — Čo call zmenil v OKF kontrakte

### B1. Pracovná štruktúra advokáta je profil — systémové súbory OKF ostávajú jednotné

*(Spresnené MČ po calle.)* Súbory, ktoré tvoria OKF kontrakt — `spis.md`, `klient.md`, `_STATUS.md`, `AGENTS.md`, `memory/`, `_kancelaria/` — majú **pevné názvy a formát**. Na nich stojí prenositeľnosť (tvrdá podmienka z 2. 9.: ručne vyrobený priečinok musí prejsť `validate` bez CLI) a nemenia sa.

Nastavuje sa **to, čo si advokát reálne vedie sám**:

| Čo | Príklad | Kde sa to prejaví |
|---|---|---|
| podpriečinky spisu | `01 Zmluvy/`, `02 Podania/`, `03 Korešpondencia/`, `04 Dôkazy/`, `05 Fakturácia/` | zakladajú sa pri novom spise, rozpoznajú sa pri retrofite |
| konvencia pomenovania dokumentov | `RRRR-MM-DD_Podanie_Novák.docx` | podľa nej agent pomenuje vygenerovaný Word/PDF |
| kde v strome ležia klienti | `AK/R/Novák Ján/` | agent nájde klienta bez toho, aby sa mu tam sypali karty |
| rola priečinka | „podania patria sem, korešpondencia sem" | agent vie, kam uložiť, čo vytvorí |

**Dobrá správa: polovica mechanizmu už existuje.** V `okf-pamat` je `_kancelaria/okf.config` s poľom `client_path` (vzor typu `AK/*`, hviezdička = jeden segment), presne s odôvodnením „vaulty vzniknuté pred OKF majú vlastnú logiku a rozsypať do nich 52 kariet je zásah do cudzieho poriadku". Profil pracovnej štruktúry je **rozšírenie toho istého súboru**, nie nový systém.

**Vo Fáze A je extension point tiež pripravený.** `okf` má `TemplateSet = Record<EntityType, Record<cesta, obsah>>` a dnes generuje len štyri systémové súbory na spis. Profil = **ďalšie položky v tej istej mape** (prázdne podpriečinky + `.gitkeep`/`README`), načítané z konfigu namiesto natvrdo zo šablón.

**Návrh zápisu v `_kancelaria/okf.config`:**

```yaml
client_path: "AK/*"
matter_folders:
  - "01 Zmluvy"
  - "02 Podania"
  - "03 Korešpondencia"
  - "04 Dôkazy"
folder_roles:
  drafts: "01 Zmluvy"
  filings: "02 Podania"
  correspondence: "03 Korešpondencia"
  evidence: "04 Dôkazy"
document_naming: "{date}_{kind}_{client}"
```

`folder_roles` je to podstatné: bez neho je zoznam priečinkov len kozmetika a agent nevie, kam písať. Roly nech sú **voliteľné** — kto ich nevyplní, má priečinky bez správania.

**Kto to stavia:** profil zapisuje onboarding (MF) a Settings, číta ho `okf apply` pri zakladaní a retrofite (MČ) aj `okf-memory` pri hľadaní klienta (VŘ, `client_path` už má). Do bety stačí **profil s defaultmi = dnešný stav** a jeden reálny príklad — tvoja vlastná štruktúra.

### B2. Pod slovom „typ" sa na calle zliali dve rôzne veci

Druh veci (trest/civil/správne/rodina/korporát — MČ) a typ záznamu v pamäti (`drafting` a spol. — VŘ) sú **dve nezávislé osi**. Ak sa nerozlíšia, každý postaví niečo iné pod tým istým slovom. Návrh je v **časti F**.

### B3. Zrušená ceremónia — čo po nej ostáva ako pravidlo

Po odstránení mŕtveho kódu ostáva jediná brána do L1/L3 trvalé poverenie z PR #31. Veta zo spec 0002 („žiadny autonómny zápis do L1 alebo L3") sa preto musí prepísať do tvaru:

> Do L1 a L3 zapisuje človek, alebo agent na základe **výslovného písomného poverenia** advokáta. Ceremónia potvrdzovania jednotlivých zápisov sa nekoná.

Bez tejto vety nemá prepis spec 0014 o čo sa oprieť a `L3_LEAK` sa môže omylom zrušiť spolu s ceremóniou, hoci je to obsahová kontrola mlčanlivosti, nie schvaľovanie.

### B4. Lehota ako typ, ktorý appka prečíta

Rozhodnutie z callu plus dashboard dáva reťaz `záznam s deadlines → čítací kanál → timeline`. Čítací kanál je rozpísaný v **časti I** — a nie je to `--json`, ako sa pôvodne zdalo.

---

## Časť C — Nastavenia aplikácie

K nedokončenému bodu I1 (OKF tab v natívnych Settings + napojenie „Nový spis" na upstream „Add folder") pribudli z callu tri veci:

1. **Profil pracovnej štruktúry** *(rozhodnutie 8)* — nastaví sa pri onboardingu, uloží do `_kancelaria/okf.config`, použije sa pri každom novom spise aj retrofite. Spojivo medzi onboardingom (MF) a OKF (MČ + VŘ) — dnes ho nikto nevlastní.
2. **Sekcia integrácií** *(rozhodnutie 18)* — kalendár a e-mail (Google Workspace, Office/Exchange) plus CLI skilly (Reminders CLI, chystané Apple Notes CLI). Oddelená od marketplace, lebo sú to univerzálne veci naviazané na účet, nie na jurisdikciu.
3. **Pamäťová cena rozšírení** *(rozhodnutie 15)* — pri zapínaní skillu/MCP zobraziť, koľko RAM pribudne, plus odporúčaný default. **Žiadne blokovanie spustenia.**

---

## Časť D — Marketplace a výkon

**Stav k 7. 9. (overené):** `Omni-Legal-Products/lawoss-marketplace`, `main` = `d9631fb`, **private**, 15 pluginov, každý s `.claude-plugin/plugin.json`, 14 z nich so sprievodným skillom. Rozhodnutie 11 z callu (skill ku každému MCP) je teda z veľkej časti splnené ešte pred callom.

- **Inštalácia** — technicky rozobratá v časti **H**.
- **Výber defaultov závisí od merania RAM.** Poradie: metodika (MF) → meranie → výber defaultnej sady (MČ) → onboarding. 15 položiek × neznáma spotreba je presne scenár, pred ktorým MČ na calle varoval.
- **Záložný plán (CLI namiesto MCP)** je reálny — harness dáva Bash. Katalóg to unesie: 14 z 15 položiek už má skill, ktorý je pri CLI variante ešte prirodzenejším nosičom.

---

## Časť E — Riziká voči 16. 9.

| # | Riziko | Prečo | Čo s tým |
|---|---|---|---|
| 1 | **Dva nástroje, jeden priečinok** (R4) | spis založený cez `/novy-spis` dnes s `okf-memory` nefunguje — 8 konkrétnych trení | rozdeliť prácu **tento týždeň** (G4) |
| 2 | **`EVENT_KINDS` slovensky** (R6) | každý spis založený medzitým nesie slovenské hodnoty v append-only histórii | premenovať **pred merge #35** (G3) |
| 3 | **Private marketplace** (M3) | resolver vo forku nepošle žiadne prihlásenie → 404 aj pre členov organizácie | rozhodnúť viditeľnosť (H4) |
| 4 | **Katalóg v PR #36 sú demo dáta** | ukazuje neexistujúce repozitáre, nie našich 15 pluginov | prepojiť na reálny katalóg (H3) |
| 5 | **Čítací kanál nie je zapojený** | `okf-pamat` nie je v pnpm workspace → appka ho nevidí | jeden riadok + riadok do PATCHES.md (I2) |
| 6 | **Onboarding neimplementovaný** (O1) | návrh len na vetve bez PR, pribudol mu profil štruktúry | zúžiť rozsah na betu |
| 7 | **Nedokončené z 2. 9.** (I1–I3) | OKF tab, „Add folder", PATCHES.md, upstream sync | |

**Odporúčané poradie práce MČ:** (1) merge reťaze s podmienkami → (2) rozdelenie práce k jednému kontraktu + veta o vrstvách → (3) viditeľnosť marketplace → (4) workspace riadok a čítací kanál → (5) OKF tab a „Add folder" → (6) profil štruktúry s defaultmi → (7) defaultná sada po meraní MF.

---

## Časť F — Návrh: dve osi typizácie

> Reaguje na požiadavku z callu: zovšeobecniť systém mimo procesných agend, ale **nerobiť veľa lievikov**.

### F1. Os 1 — druh veci (`kind`), v hlavičke záznamu `matter`

Pozor na názov: `type` je už obsadené typom záznamu (`type: matter`), takže druhé pole sa **nesmie** volať `matter.type`, ako to má spec 0013. Navrhujem **`kind`** a k tomu voliteľné `procedure`:

| `kind` | Čo pokrýva | `procedure` |
|---|---|---|
| `litigation` | zastupovanie v konaní | `criminal · civil · administrative · family · insolvency · enforcement` |
| `advisory` | poradenstvo, stanoviská | — |
| `transaction` | korporát, prevody, valné zhromaždenia | — |
| `drafting` | tvorba zmlúv a dokumentov | — |
| `research` | rešerše (aj medzinárodné právo) | — |
| `registry` | zápisy do registrov (ORSR, RPVS, ZRSR) | — |
| `internal` | vlastná agenda kancelárie | — |

Sedem druhov + jedno spresnenie pri konaniach namiesto tridsiatich typov. Rodinné a trestné právo nie sú samostatné druhy — sú to `litigation` s iným `procedure`, lebo procesne sa vedú rovnako a líšia sa obsahom, nie štruktúrou.

**Čo `kind` riadi:**
- ktoré sekcie a checklisty sa vygenerujú do `_STATUS.md`,
- ktoré validácie sa zapnú (lehoty a chronológia majú zmysel pri `litigation`, AML pri každom, dôkazná matica len pri `litigation`),
- ktoré skilly a šablóny sa ponúknu,
- ktoré podpriečinky z profilu (B1) sa založia.

**Čo `kind` nesmie robiť:** zakladať nové typy záznamov, nové adresárové systémy ani nové vrstvy pamäte. Toto je celá poistka proti lievikom.

### F2. Os 2 — typ záznamu (`type`), uzavretý zoznam v pamäti

Dnes 11 typov. Z callu vyplýva doplniť **dva**, nie sedem:

| Nový typ | Vrstva | Čo nesie |
|---|---|---|
| `draft` | L2 | dokument, ktorý tvoríme (zmluva, podanie, stanovisko): stav, verzia, kto pripomienkoval, kde leží súbor |
| `note` | L2 | vlastná agenda a interné poznámky, ktoré nie sú pravidlo ani poučenie |

**Čo sa zámerne nepridáva:**
- *rešerš* — má už dva nosiče: `question` (zadanie a záver) a `authority` (pramene). Tretí by len rozbil, kde sa čo hľadá.
- *podanie* — je to **udalosť**, nie záznam: `EVENT_KINDS` už má `podanie/filing` a lehota visí na `decision`/`matter`.
- *valné zhromaždenie, exekúcia, medzinárodné právo* — to sú `kind` a `procedure`, nie typy záznamov.

### F3. Čo treba odklepnúť

1. `kind` + `procedure` v hlavičke `matter`, nie `matter.type` *(kolízia s `type`)*.
2. Dva nové typy záznamov: `draft`, `note`.
3. Zápis do spec 0013 (profily vecí) a do schémy `okf-pamat`.

---

## Časť G — Kontext k otvoreným OKF rozhodnutiam

### G1. Trvalé poverenie — za akých podmienok ho prijať

**Čo to je.** Advokát raz napíše do `_kancelaria/okf.config`, že agent smie do L1 (pravidlá a poučenia kancelárie) a L3 (právne pramene) zapisovať sám, dokedy to platí a prečo. Odvtedy agent zapisuje bez pýtania a v histórii záznamu ostane, kto poverenie dal. Neúplné poverenie (bez mena, dátumu konca, dôvodu alebo rozsahu) neplatí — bezpečný default blokuje. Mazanie poverenie nekryje nikdy.

**Tri veci, ktoré v ňom dnes nesedia** *(overené v `src/config.ts` na vetve #35)*:

1. **Dátum sa porovnáva ako text** — `auth.expiresAt < today`. Pri tvare `2026-12-31` to funguje. Ak advokát napíše `31.12.2026`, porovnanie vyjde, že poverenie **nikdy nevyprší** — tichý omyl v jeho neprospech.
2. **Poverenie platí aj pre knižničné volanie z aplikácie**, ktoré o ňom nemusí vedieť. Appka si nevyžiada „chcem konať pod poverením" — dostane to automaticky.
3. **Súbor s poverením si môže napísať sám agent.** Vo forku nie je nič, čo by mu to zakázalo. Hranicou je stopa v histórii, nie zámok.

**Cena chyby.** Poverenie je jediná brána, ktorá po zrušení ceremónie ostala. Ak sa dá obísť alebo tíško nikdy nevyprší, brána tam formálne je, ale nedrží.

**Možnosti:**

| | Čo to znamená | Cena |
|---|---|---|
| **A** | Prijať #31 tak, ako je | 0 práce; brána je formálna |
| **B** | Prijať s tromi podmienkami: validovať `expires_at` na `RRRR-MM-DD`, opt-in pre knižnicu (appka poverenie výslovne podá), zákaz zápisu do `okf.config` agentom | ~pol dňa u VŘ, follow-up po merge |
| **C** | Nezlúčiť #31, L1/L3 len cez interaktívne `--approve-as` | rozpletá #35, ktorý na ňom stojí |

**Odporúčanie: B.** Je to tvoja vízia v praktickej podobe — človek rozhoduje raz a písomne, nie pri každom zápise, a nástroj nesmie byť oklamateľný vlastným agentom. Bod 1 (validácia dátumu) je päť riadkov a odstraňuje najzákernejšiu chybu.

### G2. `L3_LEAK` — nechať, zmäkčiť, alebo zrušiť

**Čo to je.** Keď ide zápis do L3 (právny prameň, ktorý sa použije naprieč spismi), nástroj skontroluje, či v texte nie sú klientske identifikátory zo spisu: IČO, rodné číslo, dátum narodenia, číslo dokladu, adresa, meno subjektu. IČO a rodné číslo = chyba, celé meno = chyba, samotné priezvisko = varovanie. **Beží len nad L3** — IČO klienta v spise (L2) nikto neblokuje.

**Príklad.** Agent zapisuje prameň *„Súd v konaní proti Alfa s.r.o., IČO 04920040, dovodil, že…"* → odmietnuté. Po preformulovaní na *„Súd dovodil, že…"* prejde. *„Žalobca Novák namietal premlčanie"* → len varovanie.

**Prečo to nie je zamietnutá ceremónia.** Ceremónia sa pýtala človeka na súhlas. Toto sa nepýta nikoho — pozerá sa na obsah. Pravidlo pochádza z tvojho spec 0002, VŘ ho len previedol do nástroja. Na teste na 10 konaniach z ISIR chytilo IČO s vedúcou nulou aj rodné číslo opísané do otázky.

**Cena chyby v oboch smeroch.** Falošný poplach = preformulovať vetu. Rodné číslo v zdieľanej vrstve = nedá sa vziať späť; § 23 zákona o advokácii (SK), § 21 zák. 85/1996 Sb. (CZ).

**Jedno slepé miesto.** Ak sa niektorý subjekt v spise nedá prečítať (napr. Obsidian pridá do hlavičky viacriadkový `aliases:`), vypadne zo zoznamu identifikátorov a brána pre toho klienta **ticho oslepne** — nezastaví nič a nikto sa to nedozvie.

**Možnosti:** (A) nechať ako tvrdú validáciu · (B) znížiť na varovanie · (C) zrušiť.

**Odporúčanie: A, s dvomi podmienkami.** Kontrola musí **zablokovať zápis**, keď je niektorý subjekt nečitateľný (dnes prejde), a prahy do `okf.config` len pre meno a priezvisko s povinným dôvodom — identifikátory nekonfigurovateľné. A doplniť do dokumentácie § 23 ZoA, VŘ naň čaká.

### G3. `EVENT_KINDS` — prečo to treba rozhodnúť pred merge, nie po ňom

**Čo to je.** Zoznam druhov udalostí v chronológii spisu. Dnes: `dorucenie, podanie, pojednavanie, rozhodnutie, vyzva, hovor, email` — slovenské hodnoty v strojovom kontrakte, proti pravidlu z 1. 9. o anglickom jadre (O6).

**Prečo teraz.** História záznamov je **append-only**. Každý spis založený medzi merge a premenovaním ponesie slovenské hodnoty naveky a migrácia by musela porušiť pravidlo, ktoré celý systém drží. Päť minút práce dnes = špeciálny prípad v migrátore navždy.

**Návrh:** `delivery, filing, hearing, decision, notice, call, email`. Zobrazované názvy ostávajú slovenské a české — mení sa len strojová hodnota.

**Odporúčanie:** podmienka pred merge #35.

### G4. Jeden kontrakt spisu — rozdelenie práce

Osem trení medzi Fázou A a `okf-pamat`. Dnes by spis založený cez `/novy-spis` s `okf-memory` nefungoval (`sync` skončí `KONFLIKT`, exit 1).

**Fáza A (MČ):**
1. šablóna `_STATUS.md` dostane markery vnútri `## 3. Lehoty` a `## 4. Chronológia`,
2. `spis.md` dostane `jurisdiction: sk|cz`,
3. šablóna `AGENTS.md` prepísaná: pamäť je `memory/` cez `okf-memory`, `MEMORY.md` je archív *(inak Codex píše do `MEMORY.md` a Claude do `memory/` — dve pamäte)*,
4. vytvárať `client.md` namiesto `klient.md`,
5. `okf validate` prestane kontrolovať `memory/index.md` *(bundle je v0.2 s koreňom `memory/`)*.

**`okf-pamat` (VŘ):**
6. `init` odmietne spis bez `jurisdiction:` namiesto tichého defaultu `cz`,
7. retrofit markerov do existujúceho `_STATUS.md` (append-only, idempotentne),
8. `_kancelaria` → anglický názov podľa O6, alebo výslovná výnimka.

**Spoločné:** jeden runtime. Fáza A beží na bun, `okf-pamat` na node 24. Server appky beží na **bun** — návrh: zjednotiť na bun a node testy v `okf-pamat` nechať tak, ako sú.

---

## Časť H — Ako sa katalóg dostane do forku

### H1. Mechanizmus vo forku už existuje

`apps/server/src/claude-plugin-bundle.ts` (upstream LegalWork) vie z GitHub repozitára vytiahnuť Claude Code plugin — `.claude-plugin/plugin.json`, `skills/`, `commands/`, `agents/`, `.mcp.json` — a nainštalovať ho existujúcou cestou `installCloudPlugin`: menné priestory, registrácia MCP, register inštalácií, odinštalovanie, schválenia a reload udalosti sú hotové.

**Náš katalóg je s tým kompatibilný.** Všetkých 15 pluginov má `.claude-plugin/plugin.json` so `skills: "./skills/"`. Inštalačná adresa je adresa podpriečinka:

```text
https://github.com/Omni-Legal-Products/lawoss-marketplace/tree/main/plugins/orsr
```

Tri veci, ktoré treba vedieť:

- **Bez podpriečinka to nepôjde.** Repozitár má 15 manifestov v rovnakej hĺbke → resolver vráti `plugin_ambiguous` a vypýta si adresár. Buď inštalujeme po jednom, alebo doplníme čítanie `marketplace.json` (dnes ho appka nepozná).
- **Nainštaluje sa iba `SKILL.md`.** Ak by skill mal ďalšie súbory, resolver ich preskočí s varovaním. Naše skilly sú jednosúborové → v poriadku.
- **MCP sa nenainštaluje**, lebo `.mcp.json` v pluginoch zámerne nie je — nasadenie servera je vec prevádzkovateľa a je popísané v `docs/SETUP.md`. Ak by sme chceli jedno-klikové MCP, doplní sa `.mcp.json` len tým serverom, ktoré sú nasadené a chránené OAuth.

### H2. Blokátor je jeden a je technický

Resolver posiela na GitHub **iba** hlavičky `Accept` a `User-Agent` — **žiadne prihlásenie**. Nikde v `claude-plugin-bundle.ts` ani `cloud-plugins.ts` nie je token ani `Authorization`.

**Dôsledok:** kým je `lawoss-marketplace` private, inštalácia vráti 404 **aj členom organizácie**, aj keď majú do repozitára prístup v prehliadači. Nie je to nastavenie prístupových práv — appka sa jednoducho nemá čím preukázať.

### H3. Katalóg v PR #36 zatiaľ neukazuje na naše pluginy

`apps/app/src/lawoss/domains/marketplace/catalog.ts` v Martinovej PR obsahuje **šesť ukážkových položiek** s neexistujúcimi zdrojmi (`Omni-Legal-Products/lawoss-registry`, `community/unverified-isds`) a inštalácia je `preview-only`. Model typov, kanálov a jurisdikcií je dobrý a stojí za zachovanie — **dáta treba vymeniť za našich 15 položiek** s adresami do `lawoss-marketplace` a tlačidlo previesť z náhľadu na skutočnú inštaláciu cez existujúci resolver.

### H4. Možnosti — toto je na rozhodnutie

| | Riešenie | Kód | Funguje pre | Poznámka |
|---|---|---|---|---|
| **A** | **Zverejniť `lawoss-marketplace`** | 0 riadkov | členov aj advokátov, hneď | Obsahuje len usage skilly, README, `SETUP.md` a licencie — **žiadny kód serverov, žiadne tajomstvá** *(prešiel som `SETUP.md`: je to návod, nie konfigurácia; endpointy ani kľúče tam nie sú)*. Zdrojových 15 MCP repozitárov ostáva private. |
| **B** | **Doplniť token do resolvera** | ~40 riadkov vo forku + bezpečné uloženie | len členov s vlastným PAT | Katalóg ostane private, ale pre advokátov to aj tak treba prehodiť na A. 🟡 zásah do upstream súboru. |
| **C** | **A teraz + B neskôr** | A hneď, B po bete | oboje | Kanál `stable` verejne, kanál `private` pre firemné skilly cez token — presne Martinov model kanálov z PR #36. |

**Odporúčanie: C**, teda **zverejniť katalóg teraz**. Je to jediná cesta, ktorou onboarding 16. 9. reálne niečo nainštaluje, a zverejňujeme tým návody, nie know-how serverov.

> [!IMPORTANT]
> Zmena viditeľnosti repozitára je krok navonok — **čaká na tvoje výslovné odklepnutie.** Zvyšok (H1, H3) viem spraviť bez toho.

---

## Časť I — Čítací kanál pre dashboard a lehoty

### I1. `--json` nie je to, čo chýba

`@lawoss/okf-pamat` už dnes exportuje **plné knižničné API**: `readStore`, `readScope`, `validateStore`, `renderStatus`, `parseRecord`, `maskRecord` a celú schému. Server aplikácie beží na **bun**, takže import TypeScriptových zdrojov je bez prekladu v poriadku — je to tá istá cesta, akou funguje Fáza A.

Dashboard teda nepotrebuje serializáciu cez CLI. Potrebuje **import**.

### I2. Chýba jeden riadok

`pnpm-workspace.yaml` má v `packages:` iba `apps/*` a `packages/*`. Priečinok `lawoss/` v ňom **nie je**, takže `@lawoss/okf-pamat` nie je workspace balík a appka ho nevidí. Oprava je pridať `- "lawoss/*"` — plus **riadok do `PATCHES.md`**, lebo je to upstream súbor (🟡 zóna).

### I3. Poradie

```text
merge #24 → #31 → #35
   → riadok "lawoss/*" do pnpm-workspace.yaml + PATCHES.md
   → read model v appke (C1–C3, VŘ) nad readScope/validateStore
   → Lehoty (timeline) a Prehľad (agregácia naprieč spismi)
   → dashboard generovaný z markdownov
```

### I4. `--json` aj tak dopĺňame, ale nie kvôli appke

Pre prenositeľnosť (iné harnessy, shell, skripty mimo TypeScriptu) má zmysel doplniť `--json` na `read` a `validate` — dnes obidva tlačia ľudský text. Je to malá práca a **nie je blokátorom bety**.

---

## Otvorené otázky na dorozhodnutie

1. **Viditeľnosť `lawoss-marketplace`** — zverejniť teraz (H4)? *Čaká na MČ.*
2. `kind` + `procedure` a dva nové typy záznamov (F3).
3. Podmienky trvalého poverenia (G1) a osud `L3_LEAK` (G2).
4. `EVENT_KINDS` anglicky pred merge #35 (G3).
5. Meno systému — ostáva „OKF" ako profil, alebo sa premenúva (R6).
6. Kto vlastní subjektový research a periodický rescan (R10).
7. Termín migračného pilotu spisu MČ (R9).
