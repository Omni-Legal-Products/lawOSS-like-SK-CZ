# Spec 0009: Reconcile — učenie z úprav advokáta

- **Stav:** návrh · **V2 kandidát — vedome NIE V1** (scope V1 sa klepe 12. 8., toto doň nepatrí)
- **Navrhol:** Marián Čuprík (MČ) · 2026-08-11
- **Zdroj inšpirácie:** skill `reconcile`, Jeff Su / Cowork Academy → [analýza](../research/inspiracie/reconcile-jeff-su.md) *(platený kurz bez licencie — adaptujeme koncept vlastnými slovami, text nepreberáme)*
- **Súvisiace:** [**ADR 0007 agent-first**](../decisions/0007-agent-first-architektura.md) *(zatiaľ len v [PR #19](https://github.com/originalmagneto/lawOSS-like-SK-CZ/pull/19))* · [#21 tiered memory](navrhy.md) · [spec 0003 prompt layer](0003-prompt-layer.md) · [spec 0002 OKF](0002-okf-operacny-system-praxe.md) · [#5 hybrid routing](0003-prompt-layer.md#-hybrid-routing--rozdelenie-podľa-vrstvy)

> [!IMPORTANT]
> **Väzba na [ADR 0007 — agent-first architektúra](../decisions/0007-agent-first-architektura.md)** *(návrh, [PR #19](https://github.com/originalmagneto/lawOSS-like-SK-CZ/pull/19))*
> ADR 0007 robí z hranice spisu súčasne **kontrolný aj učiaci bod** — a tým z reconcile **druhú polovicu kontraktu medzi agentom a advokátom**, nie voliteľnú funkciu.
> **Zaradenie sa tým nemení: reconcile ostáva V2.** Mení sa len to, čo musí spĺňať architektúra V1, aby jej nechala miesto — drafty sa neprepisujú, verzie ostávajú, hranica je explicitná.
> Zároveň ADR 0007 povyšuje poistku z *Adaptácie 4* („advokát schvaľuje každú zmenu inštrukcií") zo slušnosti na **záväzný bezpečnostný prvok**: zápis do `AGENTS.md` alebo `MEMORY.md` je prechod hranice a vyžaduje podpis. Dôvod je prompt injection — otrávený dokument by sa cez úpravu draftu mohol natrvalo usadiť v inštrukciách.

## Problém

AI draft nikdy nie je finál. Advokát upraví podanie, zmluvu či email — a dnes sa tá práca **zahodí**: systém zajtra spraví tú istú chybu a advokát dookola opravuje to isté (oslovenie, štruktúru podania, citačný štýl, formálnosť). Úpravy advokáta sú pritom najkvalitnejší a najlacnejší tréningový signál, aký máme — vzniká sám, pri bežnej práci.

## Navrhované riešenie

Skill `reconcile` (SK/CZ): porovná AI draft s verziou, ktorú advokát **reálne použil**, a navrhne najmenšiu možnú zmenu inštrukcií, ktorá by rovnakej chybe nabudúce zabránila.

Mechaniku preberáme z originálu (fázy porovnanie → diagnóza → brána presnosti → návrh → schválenie; dispozície *delete → merge → move → rewrite → stage → add*; zásada „najprv orezať, až potom pridávať" — detail v [analýze](../research/inspiracie/reconcile-jeff-su.md)). **Naša pridaná hodnota je v tom, kam učenia ukladáme** — a presne tam vstupuje OKF.

### Adaptácia 1: rebrík umiestnenia nad OKF *(jadro adaptácie)*

Originál je zámerne standalone — umiestnenie učenia necháva na používateľa a výslovne odmieta vyžadovať štruktúru. My štruktúru **máme** (OKF), takže učenie stúpa po rebríku podľa všeobecnosti:

```mermaid
flowchart TB
    E["✏️ Úprava draftu advokátom"] --> R["🔍 reconcile"]
    R --> Q{"Aká všeobecná<br/>je preferencia?"}
    Q -->|"jednorazová<br/>(tento klient, táto vec)"| M["📄 MEMORY.md spisu<br/>(TP-XXX záznam)"]
    Q -->|"platí pre celý spis"| A["📄 AGENTS.md spisu"]
    Q -->|"štýl kancelárie"| P["📁 prompt layer kancelárie<br/>lawoss/prompts/sk · cz"]
    Q -->|"všeobecný vzor"| C["🌍 návrh do community skills<br/>(LAWOSS balík)"]
    M -.->|"anonymizačná brána<br/>pri každom povýšení"| A -.-> P -.-> C
    classDef g fill:#0b4f2a,stroke:#3ad98b,color:#fff
    class R g
```

| Úroveň | Kam sa zapisuje | Príklad učenia |
|---|---|---|
| **Vec/klient** | `MEMORY.md` spisu (záznam TP-XXX podľa PROTOKOLU ZÁPISU) | „klient Novák chce oslovenie *vážený pán inžinier*" |
| **Spis** | `AGENTS.md` spisu | „v tejto veci vždy citovať aj CSP, nie len OZ" |
| **Kancelária** | prompt layer (`lawoss/prompts/sk/` alebo `cz/`) | „podania štruktúrujeme I./II./III., petit vždy na konci samostatne" |
| **Komunita** | návrh do LAWOSS balíka (PR) | „slovenské súdy — dátumy vypisovať slovom v petite" |

### Adaptácia 2: anonymizačná brána pri povýšení

Učenie extrahované zo spisu **nesmie niesť klientske údaje**, keď stúpa na vyššiu úroveň. Pravidlo: na úrovni spisu môže učenie odkazovať na vec; od úrovne kancelárie vyššie musí byť formulované všeobecne (žiadne mená, spisové značky, sumy). Pri povýšení na komunitnú úroveň kontrola človekom povinná — je to verejný PR.

> [!NOTE]
> **Nadväzuje na návrh MF #27** — [lokálny anonymizačný privacy gate](0008-anonymizacia-a-privacy-gate.md) ([PR #17](https://github.com/originalmagneto/lawOSS-like-SK-CZ/pull/17)). Táto brána je jeho prirodzený spotrebiteľ: povýšenie učenia by malo prejsť tým istým lokálnym gate-om (candidate → verified → confirmed), nie vlastnou paralelnou implementáciou. Prepojiť pri prerokovaní oboch specov.

### Adaptácia 3: citlivosť dát a beh

Reconcile **číta drafty aj finály = obsah spisu viazaný mlčanlivosťou**. Beh sa preto riadi [#5 hybrid routingom](0003-prompt-layer.md#-hybrid-routing--rozdelenie-podľa-vrstvy): lokálny model, alebo cloud len podľa citlivostnej voľby advokáta. Toto nie je detail — je to podmienka nasadenia.

### Adaptácia 4: human gate na každej úrovni

Preberáme poistky originálu a pridávame jednu vlastnú:

- advokát **schvaľuje každú** zmenu inštrukcií (žiadne tiché prepisovanie),
- jedna úprava ešte nie je pravidlo — slabé signály sa odkladajú (*stage*), kým sa nezopakujú,
- ak finál vyzerá horšie než draft, zmena sa **neučí** (môže ísť o omyl),
- **nové:** učenie, ktoré protirečí dohodnutému pravidlu kancelárie, ide na **prerokovanie tímu** — nie na tichý prepis spoločného promptu jedným advokátom.

### Adaptácia 5: editor `.docx` ako miesto, kde sa diff zbiera

*(doplnené 2026-08-13 po skúšaní editora v LegalWorku)*

Doteraz spec nehovoril, **odkiaľ** diff draft → finál fyzicky príde. Skúšanie ukázalo, že to miesto už existuje: **vstavaný editor `.docx`** *(`@eigenpal/docx-editor-react`, viď [porovnanie editorov](../research/inspiracie/2026-08-13-editory-docx-superdoc-vs-eigenpal.md))*.

Reťazec je tým pádom celý v aplikácii, bez Wordu a bez add-inu:

```mermaid
flowchart LR
    A["🤖 agent pripraví draft"] --> B["📄 editor .docx<br/>režim <b>suggesting</b>"]
    B --> C["✍️ advokát upraví<br/><i>sledované zmeny s jeho menom</i>"]
    C --> D["🔍 reconcile<br/><i>číta diff</i>"]
    D --> E["📚 učenie po rebríku<br/>MEMORY → AGENTS → prompt layer"]
    classDef g fill:#0b4f2a,stroke:#3ad98b,color:#fff
    class D g
```

**Dve veci to podmieňujú a obe sú dnes nesplnené** *(overené v kóde 2026-08-13)*:

| # | Podmienka | Stav |
|---|---|---|
| [#31](../planning/napady.md) | **Meno autora úprav** — dnes sa každá zmena podpíše ako natvrdo zadané „Legal Cowork" a appka nemá nastavenie mena | ❌ **tvrdý predpoklad** |
| [#29](../planning/napady.md) | **Režim `suggesting`** — knižnica ho vie, LegalWork ho nikdy nezapne, takže sledované zmeny nevznikajú | ❌ blokuje zber |

> [!CAUTION]
> **#31 nie je kozmetika, je to podmienka správnosti učenia.** Ak sa všetky úpravy podpíšu rovnakým menom, reconcile **nerozlíši, čo napísal agent a čo opravil advokát**. Učil by sa z vlastných návrhov — čo je presne tá spätná väzba, ktorá model postupne pokazí. **Bez rozlíšenia autora sa reconcile nesmie spustiť.**

Poradie je teda dané: **#31 → #29 → tento spec.** Kým prvé dve nie sú hotové, reconcile nemá z čoho čítať.

### Čo máme v LAWOSS zadarmo navyše

| Výhoda | Detail |
|---|---|
| **Tracked changes z Word add-inu** | LegalWork robí drafty vo Worde s tracked changes — diff draft → finál dostávame **natívne**, netreba ho rekonštruovať |
| **Verzie markdownu v spise** | OKF spisy sú markdown — draft a finál sú dve verzie súboru, porovnanie je triviálne |
| **PROTOKOL ZÁPISU** | OKF už má disciplínu „kam čo patrí" — učenia dostanú vlastný typ záznamu (návrh: `R-XXX` v `MEMORY.md`) |

## Architektúra: skill NAD OKF — nie súčasť jadra, nie black box

Odpoveď na otázku „custom skill, alebo súčasť OKF?": **oboje, vo vrstvách.**

| Vrstva | Čo je | Kto ju môže meniť |
|---|---|---|
| **Proces** | `reconcile` = opencode Agent Skill v `lawoss/skills/` — **obyčajný markdown s inštrukciami** | ktokoľvek — princíp *„žiadny black box: prompty sú viditeľné a editovateľné"* platí aj tu |
| **Dáta** | učenia žijú v OKF súboroch (`MEMORY.md`, `AGENTS.md`, prompt layer) — čistý markdown u advokáta | advokát priamo, aj bez skillu |
| **Nastavenia** | režim + úrovne v konfigurácii kancelárie | advokát/kancelária |

Dôsledky: skill funguje aj **mimo LegalWorku** (Claude Code, čistý opencode) — prenositeľnosť vrstvy LAWOSS zostáva; a advokát môže učenia kedykoľvek ručne upraviť, zmazať alebo dopísať — reconcile je pomocník nad jeho súbormi, nie vlastník dát.

## Vzťah k self-learning / self-healing (#23, #24)

Reconcile je **konkrétna implementácia self-learning časti** nápadov #23/#24 — učenie z vlastných chýb s ľudskou kontrolou. **Self-healing (#23) je sesterská slučka** — udržiavanie integrácií (MCP, skills, CLI) v chode — a rieši sa samostatne. Spolu tvoria pilier „systém, ktorý sa zlepšuje sám"; reconcile je jeho prvý uchopiteľný kus, lebo signál (úpravy advokáta) vzniká sám pri bežnej práci.

## Režimy behu — automatizované, ale vždy editovateľné

Tri režimy (voľba v nastaveniach kancelárie), human gate platí vo všetkých:

| Režim | Správanie | Pre koho |
|---|---|---|
| `manual` | advokát spustí porovnanie sám („reconcile") | konzervatívny štart |
| `assisted` *(navrhovaný default)* | po uložení finálnej verzie do spisu skill **sám ponúkne** porovnanie; zápis až po schválení | bežná prax |
| `auto-stage` | učenia sa automaticky zapisujú ako **čakajúce návrhy** do fronty v spise (napr. sekcia *Na schválenie* v `MEMORY.md`); advokát ich hromadne schváli/zamietne raz za čas | pokročilí — maximum automatizácie bez straty kontroly |

Ďalšie nastavenia: maximálna úroveň, kam smú učenia stúpať (len spis / až kancelária) · citlivostný routing modelu (#5) · per-jurisdikcia vetvenie SK/CZ. **Žiadny režim nezapisuje do inštrukcií bez schválenia** — automatizuje sa zber a návrh, nie rozhodnutie.

## Zaradenie a zóna

- **V2 kandidát** — konkretizuje [#21 tiered memory](navrhy.md) (je to mechanizmus učenia, ktorý tomu nápadu chýbal) a kŕmi [spec 0003](0003-prompt-layer.md). Do V1 nepatrí a nenavrhuje sa to.
- **🟢 zelená zóna** ([plán forku](../planning/plan-fork-a-workflow.md)) — čistý skill + prompty, žiadny zásah do jadra LegalWorku. ⚠️ Nepliesť s AGPL pluginom `legalwork-legalmemory` — ten je v zakázanej zóne; toto staviame vlastné nad OKF markdownom.

## Otvorené otázky

- [ ] Ako `assisted` režim technicky zistí „finál bol uložený do spisu" (file watcher? hook v OKF skille? manuálny príkaz s pripomienkou?)
- [ ] Formát záznamu učení: `R-XXX` v `MEMORY.md` spisu + sekcia *Na schválenie* pre `auto-stage` frontu + rozšírenie PROTOKOLU ZÁPISU — odsúhlasiť v rámci OKF v0.2?
- [ ] Metrika zlepšovania: klesá počet materiálnych úprav na draft v čase? (jediný poctivý dôkaz, že sa systém učí)
- [ ] CZ variant: kde sa štýl podaní SK/CZ líši, učenia sa vetvia per jurisdikcia — potvrdiť s VŘ
