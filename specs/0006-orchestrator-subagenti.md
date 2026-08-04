# Spec 0006: Orchestrátor a subagenti

- **Stav:** návrh · priečna architektúra
- **Navrhol:** Martin Friedrich (MF) · 2026-08-04 · [Issue #1](https://github.com/originalmagneto/lawOSS-like-SK-CZ/issues/1)
- **Súvisiace:** [0002 OKF](0002-okf-operacny-system-praxe.md) · [0003 prompt layer](0003-prompt-layer.md) · [0004 MCP konektory](0004-mcp-sk-konektory.md) · [0005 lehoty & timeline](0005-lehoty-timeline.md)
- **Zdrojové poznámky:** [orchestrátor + transkripcia](../research/idey/2026-07-29-orchestrator-transkripcia-byo-subscriptions.md) · [deep research](../research/deep-research/README.md)

> [!IMPORTANT]
> **Orchestrátor nie je ďalší chatbot a subagenti nie sú voľný roj autonómnych agentov.**
> LAWOSS potrebuje jeden kontrolovaný koordinátor workflowov a úzko vymedzených pracovníkov, ktorí vykonávajú jednotlivé kroky s minimálnym kontextom a oprávneniami.

## Problém

Existujúce návrhy pokrývajú OKF, OCR a transkripciu, lehoty, právny research, MCP konektory a voľbu modelu. Zatiaľ však nie je určené, **kto riadi poradie krokov, ako sa prenáša stav, ktoré operácie smie vykonať AI a kde musí rozhodnúť človek**.

Bez tejto vrstvy hrozí:

- viac agentov zapíše tú istú vec rôznym spôsobom;
- agent dostane širší kontext spisu, než potrebuje;
- výstup bez zdroja sa uloží ako fakt;
- zlyhanie jedného kroku sa tvári ako úspešné dokončenie;
- AI vykoná zápis alebo externú akciu bez vedomia advokáta.

## Navrhované riešenie

### 1. Orchestrátor

Orchestrátor je **stavový a pravidlami riadený koordinátor**, ktorý:

1. prijme požiadavku advokáta alebo udalosť z inboxu;
2. vyberie schválený workflow;
3. vytvorí run_id a načíta iba potrebný kontext;
4. pridelí krok vhodnému subagentovi alebo deterministickému nástroju;
5. kontroluje oprávnenia, routing a rozpočet;
6. prijme štruktúrovaný výsledok;
7. vyžiada ľudské potvrdenie tam, kde je potrebné;
8. zapíše výsledok cez kontrolované OKF operácie;
9. uloží auditný záznam a stav workflowu.

Orchestrátor **nesmie obchádzať pravidlá tým, že subagentovi poskytne širšie oprávnenia**.

### 2. Subagenti v alfe

| Subagent | Úloha | Predvolený režim | Oprávnenia |
|---|---|---|---|
| **Ingest / triage** | OCR, parsing, klasifikácia dokumentu, návrh spisu a metadát | lokálny | čítanie vstupu; iba návrh zápisu |
| **OKF worker** | vytvorenie alebo aktualizácia štruktúry spisu, statusu a úloh | lokálny | iba typované, nedeštruktívne a idempotentné OKF operácie |
| **Lehoty & timeline** | extrakcia udalostí a lehôt, výpočet kandidátneho dátumu, chronológia | lokálny + pravidlový výpočet | žiadny ostrý zápis bez potvrdenia advokátom |
| **Research worker** | rešerš cez schválené MCP zdroje a príprava podkladov | read-only MCP | čítanie iba povolených zdrojov; bez zápisu do registra |
| **Verifier** | kontrola citácií, zdrojov, verzií predpisov a provenance | lokálny/MCP read-only | označenie výsledku ako overený/neoverený; žiadne tiché opravy faktov |

**Neskôr** možno pridať drafting/redline, compliance a time-recording worker. Nemajú byť súčasťou prvej alfy len preto, že sú technicky možné.

### 3. Základné workflowy

#### Prijatie dokumentu

~~~mermaid
flowchart LR
    D["Dokument / e-mail / sken"] --> I["Ingest / triage"]
    I --> K["Návrh spisu a metadát"]
    K --> H{"Potvrdenie advokátom"}
    H -->|áno| O["OKF worker"]
    H -->|nie| X["Oprava alebo zahodenie návrhu"]
    O --> S["Auditný stav"]
~~~

#### Lehota a timeline

~~~mermaid
flowchart LR
    D["Rozhodnutie / podanie / e-mail"] --> L["Lehoty & timeline"]
    L --> C["Kandidátny dátum + zdroj + výpočet"]
    C --> H{"Povinné potvrdenie"}
    H -->|áno| K["OKF + kalendár"]
    H -->|nie| R["Oprava / nové posúdenie"]
~~~

#### Právny research

~~~mermaid
flowchart LR
    Q["Právna otázka"] --> R["Research worker"]
    R --> M["MCP zdroje"]
    M --> V["Verifier"]
    V --> H{"Ľudská kontrola"}
    H --> O["Research ledger / memo"]
~~~

### 4. Model routing

Routing sa riadi citlivosťou a typom úlohy, nie iba cenou:

| Vrstva | Preferovaný režim |
|---|---|
| Ingest, OKF a PII detekcia | lokálne |
| Extrakcia lehôt | lokálne + deterministické pravidlá; model iba navrhne kandidáta |
| Abstraktný právny research | schválený prémiový model alebo vlastný API kľúč |
| Posúdenie konkrétneho prípadu | lokálne, prípadne až po úspešnej sanitizácii |
| Overenie citácií | autoritatívny MCP zdroj + lokálne pravidlá |

Použitie spotrebiteľských subscriptions musí rešpektovať podmienky poskytovateľa. Orchestrátor nesmie obchádzať ToS ani simulovať používateľské rozhranie poskytovateľa. Predvolenou cestou má byť vlastný API kľúč, lokálny model alebo oficiálne podporovaný konektor.

### 5. Oprávnenia a bezpečnostné mantinely

- **Read-only default:** každý subagent začína bez práva zapisovať.
- **Matter scope:** agent dostane iba konkrétny spis a povolené podpriečinky.
- **Capability-based access:** oprávnenia sa udeľujú na konkrétne operácie (read_document, extract_deadline, write_status), nie na celý filesystem.
- **Human gate:** potvrdenie advokáta je povinné pri lehote, zápise z návrhu, finálnom výstupe a akejkoľvek externej akcii.
- **Bez autonómneho podania:** eID, slovensko.sk, odoslanie e-mailu alebo iný právny úkon sú mimo oprávnení alfy.
- **Minimálny kontext:** do každého kroku idú iba potrebné fragmenty, nie celý spis.
- **Žiadne klientske dáta v diagnostike:** logy obsahujú identifikátory a odkazy, nie plný obsah dokumentov.
- **Žiadne tiché zlyhanie:** neúplný workflow má stav partial alebo failed, nie completed.
- **Idempotencia a konflikty:** opakované spustenie nesmie duplikovať zápisy; súbežné zmeny musia byť zistené a predložené človeku.

### 6. Auditný kontrakt

Každý krok vytvorí auditnú udalosť minimálne s týmito údajmi:

- run_id a matter_id;
- workflow_id a verzia workflowu;
- agent_id a verzia subagenta;
- vstupné a výstupné referencie na súbory alebo zdroje;
- použitý model/provider a routingové rozhodnutie;
- nástrojové volania a výsledný stav;
- čas začatia a ukončenia;
- rozhodnutie človeka a jeho čas;
- dôvod zlyhania alebo odmietnutia.

Audit zaznamenáva **reprodukovateľné akcie, zdroje a výsledky**, nie skrytý interný reťazec uvažovania modelu.

### 7. Chybové stavy a návrat

- **Retry** je povolený iba pre bezpečné, idempotentné kroky.
- Po zlyhaní sa zachová čiastočný výstup a posledný bezpečný stav.
- Zápis do spisu sa vykoná až po úspešnej validácii schémy.
- Ak verifier označí citáciu ako neoverenú, výstup sa nesmie označiť ako overený.
- Pri prekročení času, rozpočtu alebo oprávnení orchestrátor workflow zastaví a vyžiada zásah človeka.
- Každý workflow musí byť možné zrušiť bez tichého pokračovania v pozadí.

### 8. Testovanie

Pred pilotom treba pripraviť anonymizované testovacie scenáre pre:

- prijatie rozhodnutia a návrh zaradenia do spisu;
- extrakciu lehoty s povinným potvrdením;
- súbeh dvoch agentov zapisujúcich do jedného spisu;
- neoveriteľnú alebo časovo nesprávnu citáciu;
- únik PII pri cloudovom routingu;
- opakované spustenie rovnakého workflowu;
- zlyhanie MCP zdroja alebo modelu;
- odmietnutie externej akcie bez ľudského potvrdenia.

Úspešnosť sa nemá merať iba kvalitou textu. Treba merať aj správnosť routingového rozhodnutia, úplnosť audit trailu, absenciu neoprávnených zápisov, deduplikáciu a čas ušetrený advokátovi.

## Otvorené otázky

- Má byť orchestrátor jednoduchý stavový automat, alebo neskôr všeobecný workflow engine?
- Kde sa bude uchovávať manifest workflowu a auditné udalosti v OKF štruktúre?
- Aké presné capability names a schémy budú mať OKF operácie?
- Ako sa rieši lockovanie spisu pri súbežnej práci viacerých používateľov?
- Ktoré subagenty patria do alfy a ktoré až do ďalšej vlny?
- Aké kalendárové a MCP konektory potrebujú workflowy 0005 a 0006?

> [!NOTE]
> Odporúčaný rozsah alfy je **jeden orchestrátor + ingest/triage, OKF, lehoty/timeline, research a verifier**. Drafting, redlining, compliance automatizácia a eID majú zostať samostatnými neskoršími krokmi.
