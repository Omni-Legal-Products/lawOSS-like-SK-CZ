# Spec 0002: OKF — operačný systém advokátskej praxe

- **Stav:** návrh · **priorita: hlavná produktová priorita MČ**
- **Navrhol:** Marián Čuprík (MČ) · 2026-07-29
- **Zdroj:** existujúca implementácia — skill `novy-spis` (OKF v0.1) v legal plugine
- **Súvisiace:** [0001 transkripcia](0001-transkripcia.md) · [0004 MCP](0004-mcp-sk-konektory.md) · [call 2026-08-12](../meetings/2026-08-12-produktova-vizia-okf-pamat.md)

> [!IMPORTANT]
> **Toto je jadro odlíšenia.** Appka nie je „AI editor dokumentov" — je to **organizácia advokátskej praxe**, ktorá AI len využíva. Z poznámok: *„Aplikácia je lepidlo a register (zdroj pravdy), nie monolitický AI engine."* Roast to potvrdil z opačnej strany — advokát nekúpi kód, kúpi **poriadok a istotu**.

## Problém

Každá kancelária si vymýšľa vlastný chaos: názvy súborov, kde čo leží, čo je aktuálne. Keď príde AI, nemá sa čoho chytiť — a advokát nemá istotu, že model pracuje s aktuálnou verziou spisu. **AI bez štruktúry len rýchlejšie produkuje neporiadok.**

## Navrhované riešenie

Appka **presadzuje a učí** štruktúru — zakladá priečinky, generuje riadiace súbory, kontroluje konzistenciu.

```mermaid
flowchart TB
    U["👩‍⚖️ „Nový spis: Novák ⁄ rozvod"] --> APP["LAWOSS"]
    APP --> V["🔍 Overenie subjektov<br/>ORSR / RPO cez MCP<br/><i>žiadne údaje z hlavy</i>"]
    V --> F["📁 Založí OKF štruktúru"]
    F --> K["klient.md / spis.md<br/>(karta veci)"]
    F --> ST["_STATUS.md<br/>fáza · lehoty · úlohy"]
    F --> AG["AGENTS.md + CLAUDE.md<br/>kontext pre AI"]
    F --> ME["MEMORY.md<br/>taktické rozhodnutia"]
    F --> VAL["✅ okf-validate<br/>+ drift check"]
    classDef c fill:#0d1b2a,stroke:#c9a24a,color:#fff
    class F c
```

## Tri vrstvy pamäte

OKF rozlišuje tri vrstvy. Zápis do jednej vrstvy nesmie automaticky meniť inú vrstvu.

| Vrstva | Scope | Typický obsah | Schválenie |
|---|---|---|---|
| **L1 všeobecná pamäť** | používateľ alebo kancelária | stabilné preferencie, pracovné pravidlá, formátovanie | výslovné potvrdenie pri povýšení nového vzoru |
| **L2 projektová alebo spisová pamäť** | jedna vec alebo projekt | fakty, stav, chronológia, lehoty, taktické rozhodnutia, väzby na dokumenty | zápis podľa protokolu spisu, citlivé zmeny s potvrdením |
| **L3 právnická pamäť** | právna znalostná vrstva | zdroje, citácie, argumentačné vzory, jurisdikcia a časová platnosť | právna kontrola a zachovaná provenance |

L3 nesmie obsahovať klientsky identifikujúce údaje prenesené z L2. Opakovaný vzor nie je sám osebe dôkazom právnej správnosti.

## Reconciliation skill

Reconciliation pravidelne porovnáva aktuálny stav, nové dokumenty, komunikáciu a používateľské úpravy s riadiacimi súbormi a pamäťou.

```mermaid
flowchart LR
    S["Aktuálny stav"] --> D["Diff a provenance"]
    D --> P["Návrh zmeny + cieľová vrstva"]
    P --> V["Kontrola konfliktov, duplicít a platnosti"]
    V --> H{"Human approval"}
    H -->|"schváli alebo upraví"| W["Verzovaný zápis + audit"]
    H -->|"odmietne"| N["Bez zmeny pamäte"]
    W --> R["Možnosť rollbacku"]
```

Povinné vlastnosti:

- idempotentnosť a bezpečné opakované spustenie,
- strojovo čitateľný aj ľudsky zrozumiteľný diff,
- provenance každého návrhu,
- žiadny autonómny zápis do L1 alebo L3,
- metriky kvality a evidencia schválenia alebo odmietnutia,
- periodická konsolidácia bez straty histórie,
- rollback na predchádzajúci schválený stav.

## Onboarding subjektov a AML research

Pri novom spise OKF:

1. identifikuje a normalizuje všetky zadané subjekty,
2. vykoná conflict a identity check,
3. podľa zvoleného režimu `light`, `medium` alebo `hard` zavolá povolené MCP,
4. preverí relevantné registre, AML, sankčné a diskvalifikačné kritériá,
5. vytvorí verzovaný markdown report s použitými zdrojmi a časom kontroly,
6. zapíše schválené výsledky do spisovej pamäte,
7. naplánuje alebo umožní periodický rescan a reconciliation.

Systém musí riešiť menovcov, nejednoznačné identifikátory, výpadok zdroja, rate limits a čiastočný výsledok. Neoverený alebo nedostupný register sa nesmie prezentovať ako čistý výsledok.

### Čo už existuje (skill `novy-spis`, OKF v0.1)

| Prvok | Popis |
|---|---|
| **Profil A** | klient → spis (`YYYY-MM Protistrana - Vec - typ`, oblasť 1–6) |
| **Profil B** | projekt (generický) |
| **Profil C** | korporátny klient — firma ako spis s tematickým členením |
| **Riadiace súbory** | `klient.md`/`spis.md`/`projekt.md` (karta), `_STATUS.md`, `AGENTS.md`, `CLAUDE.md`, `MEMORY.md` |
| **ORSR/RPO audit** | pri zakladaní sa subjekty overia cez MCP — nie „z hlavy" |
| **Retrofit** | konverzia existujúceho priečinka; **prísne nedeštruktívne + idempotentné** |
| **Validácia** | `okf-validate.sh` → OK/chyba · `okf-freshness.sh` → drift `_STATUS.md` vs obsah |
| **PROTOKOL ZÁPISU** | disciplína zápisu: fakt → `_STATUS.md`; lehota → `spis.md` frontmatter + `_STATUS.md`; taktické rozhodnutie → `MEMORY.md` (TP-XXX); dokument → podpriečinok + `_STATUS.md`; komunikácia a úlohy → `_STATUS.md` |

### Čo treba doplniť pre produkt

- [ ] **GUI** nad skriptami — advokát neklikne `.sh` (dnes je to CLI/skill)
- [ ] **Konfigurovateľnosť per kancelária** — vlastné názvoslovie, oblasti práva, šablóny
- [ ] **Onboarding existujúcej praxe** — retrofit stoviek starých spisov naraz
- [ ] **Audit trail** — kto/kedy/čo zapísal (immutable log), nadväzuje na compliance
- [ ] Prepojenie na [transkripciu](0001-transkripcia.md) a výstupy AI → automaticky na správne miesto
- [ ] **Tri pamäťové vrstvy** - oddelené schémy, scope, provenance a schvaľovanie
- [ ] **Reconciliation skill** - diff, návrh, human approval, audit, metriky a rollback
- [ ] **Subjektový onboarding** - režimy `light` / `medium` / `hard`, AML a periodický rescan

## Prečo je to strategicky silné

1. **Nezávislé od AI módy** — štruktúra spisu má hodnotu aj bez modelu; AI je násobič, nie základ.
2. **Zdroj pravdy pre agentov** — `AGENTS.md`/`CLAUDE.md` v každom spise znamená, že *ktorýkoľvek* agentický systém vie okamžite kontext veci. To je presne to, čo sme robili aj v tomto repe.
3. **Predajné na workshopoch** — „naučíme vás poriadok v praxi" je vzdelávací produkt, ktorý stojí na vlastných nohách (a je to náš monetizačný model podľa [ADR 0002](../decisions/0002-preco-forkujeme-mikeoss.md)).
4. **Nekopírovateľné narýchlo** — Harvey ani Legora vám neusporiada prax podľa slovenských zvyklostí.

## Rozhodnuté

> [!NOTE]
> **OKF ide von ako open-source — bez obmedzení.** `novy-spis` je Mariánova implementácia OKF systému; dáva ju k dispozícii celú, vrátane ďalšieho vývoja a vylepšovania. *(rozhodnuté 2026-07-29)*

Dôsledok: OKF môže byť zároveň **implementácia aj dokumentovaný štandard** — a stáva sa tým prirodzeným základom v1.

## Otvorené otázky

- [ ] Multi-user: ako to funguje, keď v spise pracujú traja ľudia naraz?
- [ ] Publikovať OKF špecifikáciu samostatne (aby ju vedel implementovať aj niekto iný)?
- [ ] Ktoré typy poznatkov sa smú povýšiť z L2 do L1 alebo L3 a kto to schvaľuje?
- [ ] Aká je periodicita reconciliation a rescanov subjektov?
- [ ] Čo presne obsahujú režimy subjektovej kontroly `light`, `medium` a `hard`?
- [ ] Ktoré pamäťové vrstvy sa smú zdieľať medzi používateľmi kancelárie?
