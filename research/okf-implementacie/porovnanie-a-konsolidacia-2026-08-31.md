# OKF: návrh VŘ, návrh MČ a konsolidovaný kontrakt

- **Dátum porovnania:** 2026-08-31
- **Účel:** spoločný podklad Mariána Čupríka a Vojtu Říhu na posúdenie OKF 1.0
- **Stav:** návrh MČ na spoločnú revíziu, nie je schválením VŘ ani tímu
- **Kanonický návrh:** [spec 0014](../../specs/0014-okf-1-kanonicky-kontrakt.md)
- **Interaktívna vizualizácia:** [OKF: VŘ, MČ, konsolidácia](../../assets/diagrams/okf-konsolidacia.html)
- **Zdroj VŘ:** [`vr-pamat/`](vr-pamat/) a [`zjednotenie.md`](zjednotenie.md)
- **Zdroj MČ:** [`mc-novy-spis/`](mc-novy-spis/), [`stanovisko-mc.md`](stanovisko-mc.md), [spec 0002](../../specs/0002-okf-operacny-system-praxe.md) a [spec 0009](../../specs/0009-reconcile-ucenie-z-uprav.md)

> [!IMPORTANT]
> Dokument rozlišuje pôvod, zásluhu a stav každého prvku. Slovo „konsolidovaný" znamená navrhovaný spoločný kontrakt, nie už dosiahnutý súhlas. Pôvodné implementácie sa nemenia a zostávajú referenčnými snímkami.

## 1. Jedna veta ku každému návrhu

| Návrh | Čo rieši | Prečo je dôležitý | Ako to robí |
|---|---|---|---|
| **VŘ** | dlhodobú, vybaviteľnú a kontrolovanú pamäť agenta | voľné poznámky sa časom zle hľadajú, miešajú typy a strácajú dôvod zmeny | typované záznamy, krátke summary, links, vrstvy L1/L2/L3, `Truth` + append-only `History`, cyklus LOAD/SAVE/LEARN/REVIEW/EVOLVE a brány v nástroji |
| **MČ** | celý životný cyklus reálneho klienta a spisu | advokát potrebuje poriadok v existujúcich priečinkoch, bezpečný zápis, stav a okamžitú orientáciu agenta | profil klient -> viac spisov, scaffold, retrofit, `AGENTS.md` + `CLAUDE.md`, `_STATUS.md`, protokol zápisu, validácia, freshness, overenie subjektov a reconciliation |
| **Konsolidovaný** | otvorený spis ako perzistentnú pamäť pre LAWOSS aj iný harness | ani samostatná pamäť bez spisu, ani spis bez typovanej pamäte nepokrývajú celý problém | klientsky workspace s viacerými prípadmi, otvorený anglický machine contract, lokalizované rozhranie, OKF Core, risk-based human gates, evidence -> finding -> potvrdená pravda + história |

## 2. Návrh Vojtu Říhu

### Čo

VŘ prináša pamäťový systém overený dlhším používaním. Jeho jednotkou je samostatný záznam s typom, stručným popisom pre retrieval a väzbami na ďalšie záznamy. Návrh rozlišuje:

- L1: pravidlá a poučenia použiteľné naprieč vecami,
- L2: kontext konkrétneho klienta alebo prípadu,
- L3: právne pramene a zdieľateľné know-how,
- aktuálnu pravdu od histórie jej zmien,
- načítanie relevantného kontextu od ukladania nového poznatku,
- pozorovanie agenta od schválenej zmeny systému.

### Prečo

VŘ návrh reaguje na prevádzkový problém netypovanej pamäte. Samotná konvencia v prompte nestačí. Po mesiacoch vzniká veľa položiek, ktoré sa ťažko filtrujú a revidujú. Krátky `summary` dá agentovi lacný retrieval hook. Typ, scope a links umožňujú vytvoriť index, ktorý nevyžaduje načítať celý obsah.

Oddelenie `Truth` a `History` rieši ďalší problém. Advokát potrebuje vidieť dnešný platný stav, ale zároveň nesmie stratiť informáciu, čo bolo zmenené, kým a prečo.

### Ako

```text
Agent pracuje
    |
    v
LOAD relevantných summary a väzieb
    |
    v
SAVE nového záznamu alebo zmeny
    |
    v
Truth + povinný riadok History
    |
    v
LEARN -> REVIEW -> EVOLVE návrh
    |
    v
človek schváli zmenu pravidla alebo know-how
```

Brány majú byť implementované v nástroji. Nestačí agentovi povedať, aby ich rešpektoval. Zmena pravdy musí pridať históriu, L1 a L3 potrebujú human gate a zdieľateľná vrstva nesmie niesť klientsku väzbu.

### Silné stránky

- granularita jeden záznam = jeden súbor,
- typovanie a samostatný životný cyklus `lesson`,
- summary a links pre efektívne vybavovanie,
- koncept `Truth` + `History`,
- nástrojové brány namiesto promptovej prosby,
- explicitná evolúcia systému cez LEARN/REVIEW/EVOLVE.

### Čo samostatne nepokrýva

- klienta ako workspace s viacerými prípadmi,
- bezpečný scaffold a retrofit reálneho priečinka,
- kanonický vstup pre ľubovoľný harness,
- overovanie subjektu pri založení klienta,
- celý vzťah medzi stavom spisu, dokumentmi, findings a UI,
- nezávislosť od globálneho konfiguračného priestoru konkrétneho harnessu.

## 3. Návrh Mariána Čupríka

### Čo

MČ navrhuje OKF ako fundamentálny operačný systém právnej praxe. Klient alebo subjekt má jeden prenositeľný workspace. V ňom môže byť viac samostatných prípadov. Každý root, ktorý môže agent otvoriť priamo, má `AGENTS.md` a dočasne byte-identický `CLAUDE.md`.

Systém musí vedieť:

- založiť nový klientsky a prípadový priečinok,
- nedeštruktívne prepracovať existujúci priečinok,
- vytvoriť riadiace Markdown súbory a štruktúru,
- udržiavať stav, lehoty, chronológiu a ďalší krok,
- validovať štruktúru a upozorniť na zastaraný stav,
- overiť subjekt cez verejné registre,
- zosúladiť nové zdroje s existujúcou pravdou,
- fungovať mimo LAWOSS v Codex, Claude Code, OpenCode alebo inom harness-e.

### Prečo

Advokát nepracuje s izolovanými pamäťovými záznamami. Pracuje s klientom, viacerými spismi, dokumentmi, termínmi a rozhodnutiami. Agent musí po otvorení priečinka okamžite vedieť, čo je tento root, čo má čítať a kam smie zapisovať. Ak je protokol iba v databáze LAWOSS alebo v proprietárnom skille, priečinok mimo aplikácie stráca inteligenciu.

`AGENTS.md` je preto verejný bootstrap kontrakt. `BRAIN.md` môže byť praktický kontextový balík, ale je odvodený a regenerovateľný. Zdroj pravdy zostáva v otvorených súboroch pri klientovi a prípade.

### Ako

```text
Kancelária
  |
  +-- Klient ACME s.r.o. = jeden workspace
        |
        +-- spoločná identita a pamäť klienta
        +-- Prípad A
        +-- Prípad B
        +-- Prípad C

Každý otvoriteľný root:
AGENTS.md -> čítacie poradie -> write protocol -> human gates
CLAUDE.md -> byte-identický mirror
BRAIN.md -> odvodený kontext
```

Pri onboardingu systém najprv iba deteguje stav. Používateľ vidí dry-run. Zápis nastane až po potvrdení. Pri overovaní subjektu register nevykoná silent overwrite. Rozdiel vytvorí finding, ktorý človek prijme alebo odmietne.

### Silné stránky

- úplná doménová hierarchia klient -> viac prípadov,
- reálna štruktúra priečinkov a prevádzkový protokol,
- scaffold, idempotentný retrofit a validácia,
- prenositeľnosť cez `AGENTS.md`,
- jasný stav prípadu pre človeka,
- registry verification a evidence,
- reconciliation a human gates pri právne významných zmenách.

### Čo samostatne nepokrýva

- dostatočne striktnú schému jednotlivých pamäťových záznamov,
- efektívne vybavovanie veľkého množstva poznatkov cez summary a links,
- samostatný životný cyklus lessons,
- úplnú append-only históriu každej zmeny pravdy,
- nástrojové vynútenie všetkých brán.

## 4. Prečo konsolidácia nie je kompromis 50:50

Návrhy riešia dve rôzne osi toho istého systému:

```text
                 Obsah jedného poznatku
                 typ · summary · links
                 Truth · History · gates
                           ^
                           |  VŘ
                           |
Životný cyklus <-----------+-----------> Pamäťový záznam
klient · prípady            |
scaffold · retrofit         |  MČ
AGENTS · status · register  v
                 Reálny priečinok praxe
```

Konsolidácia preberá z MČ obal, doménový životný cyklus a interoperabilitu. Z VŘ preberá vnútorný tvar pamäte, retrieval a bezpečnostné brány. Nový prvok nie je tretia paralelná implementácia. Je ním spoločný otvorený kontrakt a jedna core implementácia, ktorú používajú všetky adaptéry.

## 5. Rozhodovacia matica

| Oblasť | VŘ | MČ | Konsolidovaný návrh | Dôvod |
|---|---|---|---|---|
| Základná jednotka | záznam pamäte | klient, spis, projekt | klientsky workspace s viacerými prípadmi a typovanými záznamami | zachováva právnu realitu aj granularitu |
| Vstup agenta | harness config a memory index | `AGENTS.md` + `CLAUDE.md` | `AGENTS.md` kanonický, `CLAUDE.md` mirror | funguje v ľubovoľnom harness-e |
| `BRAIN.md` | front-door kontext | nie je kanonický | odvodený budgeted context | rýchlosť bez nového SSOT |
| Pamäť | typované súbory | voľné TP/LL/OQ sekcie | jeden typovaný record = jeden súbor | parsovanie, audit, retrieval |
| Aktuálny stav | v záznamoch | `_STATUS.md` | records sú SSOT, `_STATUS.md` je ľudská projekcia + ručné sekcie | jedna pravda, použiteľný prehľad |
| História | dôraz na append-only | chronológia a audit | `Truth` + append-only `History` v každom zázname | vysvetliteľnosť zmeny |
| Typy | project/user/feedback/reference | TP/LL/OQ | `matter`, `decision`, `subject`, `question`, `rule`, `lesson`, `authority` | explicitný životný cyklus |
| Vrstvy | L1/L2/L3 | L1/L2/L3 v spec 0002 | L1 kancelária, L2 klient/prípad, L3 právne know-how | hranice prístupu a zdieľania |
| Lokalizácia | lokalizovaná perzistencia | zmiešané názvoslovie | anglický machine contract, lokalizované UI a ľudské priečinky | jedna schéma pre SK, CZ aj ďalšie krajiny |
| Založenie | nie je jadrom | skripty nového spisu | OKF Core `init` + LAWOSS onboarding | jedna cesta zápisu |
| Retrofit | nie je jadrom | nedeštruktívny a idempotentný | detect -> dry-run -> confirm -> apply -> validate | bezpečná adopcia |
| Subjekt | pamäťový record | ORSR/RPO audit | Basic verification s providerom a evidence | identita bez silent overwrite |
| Reconciliation | review/evolve | reconciliation v specoch | source -> finding -> gate -> truth + history | automatizácia bez právneho autopilota |
| LAWOSS | zatiaľ knižnica/prototyp | integrácia ako cieľ | adaptér nad rovnakým OKF Core | appka nevytvorí druhý SSOT |

## 6. Konsolidovaný kontrakt

### Čo

OKF 1.0 je otvorený, Markdown-first kontrakt klienta a jeho prípadov. Samotný priečinok obsahuje dostatok údajov a inštrukcií, aby ho vedel bezpečne používať človek, LAWOSS aj externý agent.

### Prečo

Hodnota LAWOSS nie je v uzamknutí klientskych dát do aplikácie. Je v tom, že aplikácia automaticky udržiava poriadok, ukazuje konflikty a dáva bezpečný workflow nad otvorenými súbormi. Portable core zároveň bráni tomu, aby sa protokol rozdelil na jednu verziu v UI, druhú v CLI a tretiu v agentovom skille.

### Ako

```text
Otvorený klientsky priečinok
          |
          v
       OKF Core
schema · parse · detect · plan · apply · validate
migrate · reconcile · render
     /          |           \
    v           v            v
CLI          agent        LAWOSS
portable     adapter      desktop UI
```

Kanonické záznamy žijú v priečinku. LAWOSS mimo neho drží cestu, UI nastavenia, cache, read model a krátkodobé approval tokeny. Zmazanie aplikačnej cache nesmie zmazať pravdu spisu.

## 7. Simulácia na jednom klientovi

### Situácia

Kancelária preberá klienta **ACME s.r.o.**. Klient má spor z dodávateľskej zmluvy a neskôr pribudne pracovnoprávna vec.

### Krok 1: pripojenie existujúceho priečinka

LAWOSS vykoná read-only detekciu. Priečinok nemá OKF. Systém ponúkne retrofit a ukáže presný dry-run. Nič nepremenuje ani nepresunie bez potvrdenia.

**Výsledok:** vznikne klientsky root s `AGENTS.md`, `CLAUDE.md`, `okf.yaml`, `client.md`, stores a prvý prípad. Pôvodné dokumenty zostanú tam, kde boli.

### Krok 2: Basic verification

Používateľ zvolí overenie. Provider nájde oficiálny názov, IČO, sídlo, právnu formu, stav a štatutárov. Snapshot odpovede sa uloží do `evidence/registry/`.

Ak sa sídlo líši od údaja zadaného používateľom, register neprepíše `client.md`. Vznikne finding s oboma hodnotami, zdrojom, časom a navrhovaným diffom.

### Krok 3: prvý prípad

Prípad **Dodávateľ XY, zmluva o dielo** dostane vlastný root. Agent číta `AGENTS.md`, potom `matter.md`, `_STATUS.md`, index a iba relevantné summary. Nemusí načítať celý klientsky archív.

### Krok 4: príde uznesenie

File watcher vidí nový dokument. Automaticky môže vytvoriť source observation a navrhnúť lehotu. Nemôže ju povýšiť na potvrdenú právnu lehotu bez človeka.

Advokát potvrdí dátum doručenia a výpočet. Vznikne typovaný record. `_STATUS.md` zobrazí lehotu v generovanom bloku, ale record zostáva jediným zdrojom pravdy.

### Krok 5: zmena stratégie

Klient schváli, že sa nebude namietať miestna príslušnosť. Agent pripraví zmenu `decision`. Zápis prejde iba ak súčasne zmení `Truth` a pridá nový riadok `History` s dôvodom a zdrojom.

### Krok 6: externý agent

Advokát otvorí rovnaký prípad v inom harness-e. Agent nepotrebuje LAWOSS plugin na prvotnú orientáciu. Začne cez `AGENTS.md`, načíta rovnaké kanonické records a dodrží rovnaký write protocol. Ak nemá bezpečný approval mechanizmus, zmenu uloží iba ako proposed finding.

### Krok 7: druhý prípad klienta

Vznikne pracovnoprávna vec. Zdieľa potvrdenú identitu klienta, ale má vlastný stav, dokumenty, rozhodnutia a findings. L2 dáta sa nemiešajú medzi prípadmi. Schválené L1 poučenie môže kancelária použiť naprieč oboma.

### Krok 8: reconciliation konflikt

Nový registry check ukáže zmenu štatutára. Systém vytvorí finding. Človek overí zdroj, prijme zmenu a `client.md` aj subjektový record dostanú novú revision a históriu. Pôvodný stav zostáva auditovateľný.

## 8. Automatické a potvrdené operácie

| Operácia | Automaticky | Vyžaduje človeka | Prečo |
|---|---:|---:|---|
| detekcia nového súboru | áno | nie | observation nemení právnu pravdu |
| uloženie registry evidence | áno | nie | ide o zachovanie zdroja |
| finding pri rozpore | áno | nie | návrh nie je rozhodnutie |
| regenerácia `BRAIN.md` a indexu | áno | nie | odvodené projekcie |
| zmena identity klienta | nie | áno | konflikt môže mať právny význam |
| potvrdenie lehoty | nie | áno | riziko zmeškania lehoty |
| právna kvalifikácia a stratégia | nie | áno | zodpovednosť advokáta |
| L1 lesson alebo rule | nie | áno | ovplyvní ďalšie veci |
| L3 authority alebo zdieľateľné know-how | nie | áno | právna kontrola a mlčanlivosť |
| vymazanie kanonického recordu | nie | áno | audit a strata pravdy |

## 9. Čo sa má zmeniť na dnešnom prototype PR #24

[Review PR #24](review-pr24.md) dokumentuje konkrétne implementačné medzery. Pred tým, než sa prototyp stane základom aplikácie, konsolidovaný kontrakt vyžaduje najmä:

1. prejsť na jeden anglický machine contract a `memory/`,
2. oddeliť jurisdikciu od názvu priečinka,
3. vkladať markery do existujúcich status sekcií bez duplikácie,
4. validovať celý výsledný store ešte pred zápisom,
5. nahradiť self-declared approval reálnym runtime alebo CLI potvrdením,
6. zbierať parse chyby po súboroch,
7. použiť robustný YAML parser a zachovať neznáme polia,
8. pridať optimistic concurrency a atomic apply,
9. doplniť klientsku hierarchiu, onboarding, verification a reconciliation,
10. testovať syntetické MČ aj VŘ fixtures bez straty dát.

PR #24 je preto užitočný implementačný prototyp pamäťového jadra, nie hotový kanonický štandard.

## 10. Otvorené rozhodnutia na spoločnú revíziu

| ID | Rozhodnutie | Navrhovaný smer | Čo sa stane, ak sa odloží |
|---|---|---|---|
| O1 | fyzické miesto kancelárskeho brainu | nezablokovať klientsky OKF, definovať neskôr | L1 ostane dočasne bez spoločného rootu |
| O2 | minimálna multi-user politika | optimistic concurrency už v 1.0, zámky neskôr | bez revision checku hrozí prepis cudzej zmeny |
| O3 | Basic providers pre SK a CZ | overiť spoľahlivé zdroje a fallback | blokuje implementáciu providerov, nie formát |
| O4 | auto-approve nízkorizikového L2 | v 1.0 nič chránené auto-approve | viac klikov, nižšie riziko |
| O5 | koniec legacy režimu | po úspešnom pilote určiť prechodné obdobie | parser bude dlhšie niesť dva formáty |

## 11. Odporúčaný spôsob hodnotenia

VŘ a tím by mali oddelene označiť pri každom bode:

- **súhlasím**, kontrakt je pripravený,
- **súhlasím s podmienkou**, uviesť presný diff,
- **nesúhlasím**, uviesť alternatívu a dôvod,
- **potrebujem dôkaz**, uviesť požadovaný fixture alebo test.

Najprv treba odklepnúť kontrakt a hranice zodpovednosti. Až potom má zmysel rozhodnúť, či sa PR #24 upraví, rozdelí alebo nahradí implementáciou OKF Core.
