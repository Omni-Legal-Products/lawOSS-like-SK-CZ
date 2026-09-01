# Spec 0014: OKF 1.0 - kanonický otvorený kontrakt klienta a prípadov

- **Stav:** čiastočne schválené na [calle 1. 9. 2026](../meetings/2026-09-01-zapis-okf-architektura.md) — viď blok „Stav po calle" nižšie; zvyšok je návrh
- **Navrhol:** Marián Čuprík (MČ) · 2026-08-31
- **Konsoliduje:** implementáciu MČ `mc-novy-spis`, návrh a prevádzkové skúsenosti Vojtu Říhu (VŘ), [spec 0002](0002-okf-operacny-system-praxe.md) a pracovnú diskusiu MČ z 30. až 31. 8. 2026
- **Prínos VŘ:** typované záznamy, retrieval summary, väzby, `Truth` + append-only `History`, vrstvy L1/L2/L3, cyklus LOAD/SAVE/LEARN/REVIEW/EVOLVE a brány v nástroji
- **Prínos MČ:** klientská a spisová štruktúra, scaffold, retrofit, `AGENTS.md`, `_STATUS.md`, write protocol, validácia, freshness, overovanie subjektov, reconciliation a otvorená integrácia do LAWOSS
- **Jurisdikčný záber:** Česko + Slovensko, jadro pripravené na ďalšie jurisdikcie
- **Vizualizácia:** [OKF: VŘ × MČ × konsolidovaný návrh](../assets/diagrams/okf-konsolidacia.html)
- **Porovnávací podklad:** [porovnanie a konsolidácia 2026-08-31](../research/okf-implementacie/porovnanie-a-konsolidacia-2026-08-31.md)
- **Súvisiace PR:** [koordinačný PR #63](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/63) · [produktový PR #24](https://github.com/Omni-Legal-Products/lawoss/pull/24)

> [!IMPORTANT]
> Tento dokument je **návrh MČ pripravený na spoločnú revíziu s VŘ a tímom**. Zachytáva schválenia MČ z pracovnej diskusie, ale nepredstavuje súhlas VŘ ani tímové rozhodnutie. Pôvodné implementácie zostávajú zachované ako samostatné zdroje a ich autorstvo sa nemení.

## Stav po calle 1. 9. 2026

Podľa [zápisu z callu MČ + VŘ + MF](../meetings/2026-09-01-zapis-okf-architektura.md):

| Časť kontraktu | Stav |
|---|---|
| Anglický machine contract, lokalizácia na výstupe (O6/D4) | ✅ **schválené** |
| `AGENTS.md` kanonický bootstrap + `CLAUDE.md` mirror (D2) | ✅ **schválené** |
| Klientsky workspace s viacerými prípadmi (D3) | ✅ **schválené** |
| Lehoty a chronológia renderované z OKF v `_STATUS.md` | ✅ **schválené v princípe** (podmienky MČ k O1 sa dorozhodnú písomne) |
| Typované záznamy a vrstvy | 🟡 bez námietok; terminológiu L1/L2/L3 treba písomne zosúladiť s ústnou definíciou z callu |
| `plan → validate → approve → apply` pipeline a risk-based human gates (D6/D7) | ❌ **zamietnuté na calle** — úpravy robí človek v markdownoch alebo agent na pokyn; otvorený zostáva rozsah vs. kontrola `L3_LEAK` zo spec 0002 |
| `okf-cli` | ⏳ otvorené — MČ preferuje čisté markdowny bez ďalšieho nástroja |
| SQLite read model, postavenie PR #24 (D8), migrácia (O2), multi-user (O4), publikácia štandardu (O5) | ⏳ otvorené |

Sekcie tohto specu týkajúce sa write pipeline a approval brán sa prepracujú podľa výsledku otvoreného bodu c) zo zápisu; do vyriešenia ich čítaj ako **neplatný návrh**, nie kontrakt.

## 1. Problém

LAWOSS potrebuje fundamentálny systém práce s klientmi a prípadmi, ktorý:

- dá agentovi okamžitú orientáciu po otvorení ľubovoľného priečinka,
- funguje v LAWOSS aj v inom harness-e,
- ukladá stav, pamäť a audit v otvorených súboroch,
- nestráca históriu pri zmene pravdy,
- nerozmnožuje lehoty a fakty do viacerých zdrojov pravdy,
- dokáže bezpečne založiť nový priečinok aj prepracovať existujúci,
- overí právnickú osobu alebo iný subjekt cez dostupné registre,
- oddelí automatické pozorovanie od právne významného rozhodnutia,
- zostane verziovateľný, migrovateľný a zlepšovateľný.

Samotný MČ systém rieši priečinky a workflow, ale pamäť nie je dostatočne typovaná. Samotný VŘ systém rieši typovanú a vybaviteľnú pamäť, ale nie celý životný cyklus klienta, prípadov a reálnych priečinkov. OKF 1.0 preto nie je výber jednej implementácie. Je to otvorený kontrakt, ktorý zachováva silné časti oboch.

## 2. Ciele

1. **Prenositeľnosť:** klientsky priečinok je plnohodnotný aj bez LAWOSS.
2. **Agentická orientácia:** `AGENTS.md` je vždy prvý a kanonický vstup.
3. **Jedna pravda:** kanonické záznamy sa nezdvojujú v UI ani v projekciách.
4. **Auditovateľnosť:** zmena pravdy má dôvod, zdroj, autora a históriu.
5. **Bezpečná automatizácia:** systém automatizuje zber a návrh, nie právne rozhodnutie.
6. **Evolúcia:** schéma a workflow sa môžu zlepšovať cez návrhy, verzie a migrácie.
7. **Viac jurisdikcií:** jazyk zobrazenia nie je súčasťou perzistenčnej schémy.
8. **Aplikačná integrácia:** LAWOSS používa ten istý OKF Core ako portable CLI a externé agenty.

## 3. Non-goals OKF 1.0

Do prvého kontraktu nepatrí:

- cloudová synchronizácia spisov,
- plné riešenie súbežnej editácie viacerými ľuďmi,
- Extended due diligence ako hotová implementácia,
- automatické povyšovanie lessons do kancelárskej pamäte,
- automatická zmena právne významnej pravdy,
- vlastný billing alebo kompletný practice management,
- LAWOSS databáza ako zdroj pravdy.

## 4. Základné princípy

### P1. `AGENTS.md` je kanonický vstup

Každý samostatne otvoriteľný OKF root musí obsahovať `AGENTS.md`. Agent z neho zistí:

- typ rootu a jeho účel,
- poradie čítania,
- umiestnenie kanonických a odvodených súborov,
- pravidlá zápisu,
- human gates,
- validačné a reconciliation kroky,
- väzbu na nadradený klientsky alebo kancelársky kontext.

`BRAIN.md` nie je vstupný protokol. Je to regenerovateľný kontextový balík.

### P2. `CLAUDE.md` je dočasný byte-identický mirror

Kým Anthropic harness-y nepoužívajú `AGENTS.md`, každý OKF root obsahuje `CLAUDE.md` s presne rovnakým obsahom. Odlišný obsah je validačná chyba. Symlink je prípustný iba tam, kde je spoľahlivo prenositeľný. Na Drive, Windows a pri exporte musí fungovať byte-kópia.

### P3. Priečinok je produkt, LAWOSS je adaptér

Kanonická identita, stav, história, findings a dôkazy žijú v klientskom priečinku. LAWOSS môže mimo neho držať iba:

- cestu k workspace,
- UI preferencie,
- cache a odvodený index,
- dočasný stav dialógov,
- serverom vydané approval tokeny.

Zmazanie cache LAWOSS nesmie zmazať ani zmeniť pravdu o klientovi alebo prípade.

### P4. Strojový kontrakt je anglický, ľudské rozhranie lokalizované

Kanonicky anglické sú:

- názvy riadiacich súborov,
- YAML kľúče a enumy,
- názvy systémových priečinkov,
- markery generovaných blokov,
- typy záznamov a chybové kódy.

Lokalizované zostávajú:

- pracovné priečinky vo Finderi a Drive,
- názvy klientov a prípadov,
- texty záznamov,
- `_STATUS.md`, reporty, CLI hlášky a UI.

Jurisdikcia je hodnota poľa, nie názov priečinka. Skutočne odlišný právny pojem dostane samostatné kanonické pole. Nejde iba o preklad.

### P5. Odvodený súbor nie je zdroj pravdy

Regenerovateľné sú:

- `BRAIN.md`,
- `INDEX.md`,
- označené bloky v `_STATUS.md`,
- LAWOSS read model a cache.

Kanonické sú:

- `okf.yaml`,
- `client.md`,
- `matter.md`,
- typované záznamy v `memory/`,
- záznamy v `findings/`,
- uložené evidence artefakty,
- append-only história.

## 5. Doménová hierarchia

```text
Kancelársky kontext
└── Klient alebo subjekt = jeden LAWOSS workspace
    ├── spoločná identita a klientska pamäť
    ├── Prípad A
    ├── Prípad B
    └── ďalšie prípady
```

Klientsky workspace je prenositeľná jednotka. Jeden klient môže mať viac prípadov. Každý prípad má vlastný `AGENTS.md`, stav, pamäť a findings, ale odkazuje na nadradený klientsky kontext.

Fyzické umiestnenie kancelárskeho brainu zostáva otvorené. OKF 1.0 musí fungovať aj bez jedného spoločného fyzického rootu kancelárie.

## 6. Navrhovaná štruktúra klienta

```text
ACME s.r.o./
├── AGENTS.md
├── CLAUDE.md
├── okf.yaml
├── client.md
├── BRAIN.md
├── INDEX.md
│
├── memory/
│   ├── decisions/
│   ├── subjects/
│   ├── questions/
│   └── lessons-proposed/
│
├── findings/
│   ├── reconciliation/
│   └── validation/
│
├── evidence/
│   └── registry/
│
└── Prípady/
    └── 2026-08 Dodávateľ XY - zmluva o dielo/
        ├── AGENTS.md
        ├── CLAUDE.md
        ├── matter.md
        ├── _STATUS.md
        ├── BRAIN.md
        ├── INDEX.md
        ├── memory/
        ├── findings/
        └── 1 - Podklady od klienta/
```

Názov a cesta priečinka `Prípady/` sú konfigurovateľné v `okf.yaml`. Používateľ nemusí premenovať existujúcu ľudskú štruktúru.

## 7. Zodpovednosť súborov

| Súbor alebo adresár | Zodpovednosť | Kanonický |
|---|---|---|
| `AGENTS.md` | bootstrap, čítacie poradie, write protocol, human gates | áno |
| `CLAUDE.md` | mirror `AGENTS.md` pre kompatibilitu | odvodený mirror |
| `okf.yaml` | verzia, locale, capabilities, cesty a office policy | áno |
| `client.md` | človekom potvrdená identita klienta | áno |
| `matter.md` | identita prípadu, väzby a stabilné metadáta | áno |
| `memory/` | typované pravdy, rozhodnutia, subjekty a otázky | áno |
| `findings/` | rozpory, warnings, návrhy a validačné chyby | áno do vyriešenia |
| `evidence/` | registry snapshoty a iné uložené dôkazy | áno |
| `_STATUS.md` | ľudská projekcia fázy, ďalšieho kroku, lehôt a chronológie | zmiešaný |
| `BRAIN.md` | krátky budgeted context pre agenta | nie |
| `INDEX.md` | navigácia a retrieval index | nie |

V `_STATUS.md` sa generované bloky vkladajú iba medzi stabilné markery v existujúcich očíslovaných sekciách. Render nesmie ticho pripojiť druhú sekciu s rovnakým významom. Ľudské sekcie mimo markerov zostávajú nedotknuté.

## 8. Pamäťové vrstvy a typy

| Vrstva | Scope | Typy v OKF 1.0 | Zápis |
|---|---|---|---|
| L1 | kancelária | `rule`, `lesson` | iba po schválení človekom |
| L2 | klient alebo prípad | `matter`, `decision`, `subject`, `question` | observations automaticky, pravda podľa rizika |
| L3 | právna znalostná vrstva | `authority` | právna kontrola a human gate |

`lesson` zostáva samostatný typ. Poučenie z chyby má iný životný cyklus než fakt spisu a musí sa dať samostatne revidovať, odmietnuť alebo vymazať.

### Minimálny záznam

```markdown
---
okf_version: 1
id: D-2026-001
type: decision
layer: L2
scope: matter
title: Procesná stratégia po doručení uznesenia
summary: Po potvrdení lehoty pripraviť vyjadrenie a dôkazný návrh.
jurisdiction: sk
status: active
created_at: 2026-08-31T09:00:00+02:00
updated_at: 2026-08-31T09:00:00+02:00
revision: 1
sources:
  - ../1 - Podklady od klienta/Uznesenie.pdf
links:
  - Q-2026-003
---

## Truth

...

## History

| At | Actor | Change | Reason | Sources |
|---|---|---|---|---|
| 2026-08-31T09:00:00+02:00 | MČ | created | confirmed strategy | Uznesenie.pdf |
```

`summary` je krátky retrieval hook. Agent najprv prečíta index a summary, plný záznam až pri relevancii.

## 9. Brány zápisu

Brány musia byť v OKF Core, nie iba v prompte.

1. **Truth trace:** zmena `Truth` bez nového riadku `History` je odmietnutá.
2. **Append-only history:** stará história musí zostať doslovnou predponou novej.
3. **Human gate:** L1, L3, mazanie a chránené L2 polia vyžadujú reálne povolenie.
4. **L2 to L3 leak:** zdieľateľná právna vrstva nesmie niesť klientsku väzbu alebo tvrdé identifikátory.
5. **Whole-store validation:** zápis sa aplikuje až po validácii výsledného store.
6. **Optimistic concurrency:** write plan je viazaný na revision alebo hash aktuálneho stavu.
7. **Atomic apply:** buď sa uloží celý validný výsledok, alebo nič.

Approval nesmie byť objekt, ktorý si volajúci sám vyrobí. V LAWOSS ho vydá runtime po potvrdení človekom. Portable CLI použije interaktívne potvrdenie diffu. Externý agent bez CLI môže pripraviť návrh v `findings/`, nie predstierať schválenie.

## 10. Automatizácia a kanonická pravda

OKF rozlišuje:

```text
Source alebo Observation
          ↓
Finding a Proposed Change
          ↓
Human Gate podľa rizika
          ↓
Canonical Truth + History
```

Automaticky možno:

- evidovať nový alebo zmenený súbor,
- uložiť registry response ako evidence,
- vytvoriť observation alebo finding,
- kontrolovať schému, freshness a väzby,
- regenerovať projekcie,
- pripraviť diff.

Bez potvrdenia človeka nemožno meniť:

- právne významné lehoty,
- identitu klienta pri rozpore zdrojov,
- právnu kvalifikáciu,
- stratégiu alebo rozhodnutie advokáta,
- L1 a L3,
- kanonický záznam vymazaním alebo náhradou.

## 11. Založenie a retrofit

### Nový klient

1. Používateľ vyberie reálny priečinok alebo vytvorí nový.
2. Systém zistí typ subjektu a jurisdikciu.
3. Ponúkne Basic alebo Extended verification. OKF 1.0 implementuje Basic.
4. Zobrazí dry-run novej štruktúry.
5. Po potvrdení vytvorí klientsky root a prvý prípad.
6. Vygeneruje `AGENTS.md`, mirror, kartu, config a prázdne stores.
7. Validuje celý klientsky workspace.

### Existujúci priečinok

1. Detekcia: current OKF, MČ legacy, VŘ memory, partial, plain alebo future version.
2. Read-only analýza bez zápisu.
3. Dry-run s presným diffom.
4. Výslovné potvrdenie.
5. Vytvorenie iba chýbajúcich súborov a markerov.
6. Originálne súbory zostávajú nedotknuté.
7. Validácia, report a možnosť odstrániť iba novovytvorené artefakty.

Retrofit a migrácia musia byť idempotentné.

## 12. Overovanie subjektov

Overovanie je portable capability konfigurovaná v `okf.yaml`, nie proprietárna voľba iba v LAWOSS.

### Režimy

- `ask`: opýtať sa pri založení alebo retrofite,
- `always`: spustiť automaticky,
- `never`: preskočiť,
- periodicita rescanov,
- preferované providers podľa jurisdikcie,
- správanie pri nedostupnom zdroji.

### Úrovne

**Basic:** existencia, oficiálny názov, identifikátor, sídlo, právna forma, stav a štatutári.

**Extended:** vlastníctvo, koneční užívatelia výhod, insolvencia, sankcie, DPH a ďalšie rizikové zdroje. Kontrakt s úrovňou počíta, implementácia je po OKF 1.0.

### Výsledok

Výsledok obsahuje:

- provider a zdroj,
- čas kontroly,
- query a identifikátor,
- jurisdikciu,
- normalizované údaje,
- partial alebo unavailable stav,
- nájdené rozdiely,
- odkaz alebo uložený evidence snapshot.

Register nikdy priamo neprepíše `client.md`. Rozdiel vytvorí finding. Potvrdená zmena upraví identitu a appendne históriu.

## 13. Reconciliation

### Spúšťače

1. **Pri otvorení:** rýchla kontrola bootstrapu, verzie, freshness a poškodených záznamov.
2. **Po udalosti:** import dokumentu, registry check, e-mail alebo agentová práca.
3. **Hĺbkový audit:** manuálny alebo plánovaný prechod klienta a všetkých prípadov.

### Výsledok

Reconciliation vytvorí otvorený Markdown finding s:

- tvrdením v OKF,
- protidôkazom alebo novým zdrojom,
- dotknutými záznamami a projekciami,
- závažnosťou,
- navrhovaným diffom,
- požadovaným human gate,
- stavom `open`, `accepted`, `rejected` alebo `needs_evidence`.

Konflikt sa nikdy nerieši silent last-write-wins.

## 14. Evolúcia

VŘ cyklus sa zachováva s týmito hranicami:

- **LOAD:** rozpočtovaný kontext z `AGENTS.md`, `BRAIN.md`, indexu a relevantných summary.
- **SAVE:** observations a návrhy na konci práce.
- **LEARN:** lesson proposal po oprave človekom.
- **REVIEW:** konsolidácia opakovaných lessons a patterns.
- **EVOLVE:** návrh zmeny protokolu alebo schémy.

EVOLVE nesmie automaticky prepísať `AGENTS.md`, `CLAUDE.md` ani `okf.yaml`. Návrh musí uviesť problém, dôkazy, všeobecnosť, dopad na súkromie, migračný dopad a test. Schválená zmena vytvorí novú verziu formátu alebo office policy.

## 15. Portable OKF Core a adaptéry

```text
Otvorený OKF priečinok
        ↓
OKF Core
schema · parser · validate · plan · migrate · reconcile · render
        ↓
Portable CLI | Agentový adaptér | LAWOSS adaptér
```

### OKF Core

Jedna implementácia kontraktu bez UI. Používa robustný YAML parser. Zachováva neznáme polia a vracia parse errors ako findings po jednotlivých súboroch.

### Portable CLI

Poskytne `detect`, `init`, `retrofit`, `validate`, `plan`, `apply`, `reconcile`, `sync` a `migrate`. Každý mutujúci príkaz má dry-run alebo interaktívny diff.

### Agentový adaptér

Ponúkne typované operácie. Nie je jediným miestom protokolu. Externý agent sa musí vedieť zorientovať cez `AGENTS.md` bez LAWOSS-specific skillu.

### LAWOSS adaptér

Používa rovnaký OKF Core pre onboarding, file watcher, read model, registry providers, approval dialóg a UI. UI priamo neimplementuje druhú cestu zápisu.

## 16. LAWOSS workflow

Pri pripojení priečinka LAWOSS:

1. rozpozná stav bez zápisu,
2. current OKF otvorí okamžite,
3. legacy alebo plain folder dostane onboarding ponuku,
4. ukáže dry-run,
5. opýta sa na verification,
6. po potvrdení vykoná scaffold alebo retrofit,
7. zaregistruje klienta a prípady,
8. spustí validáciu a obnoví projekcie,
9. založí session v klientskom alebo prípadovom root-e,
10. agent začne čítaním `AGENTS.md`.

File watcher po zmene obnoví iba odvodený read model a vytvorí potrebné findings. Právne významnú pravdu neprepisuje.

## 17. Migrácia existujúcich systémov

### MČ

- `TP-XXX` → `decision`,
- `LL-XXX` → návrh `lesson` v L1,
- `OQ-XXX` → `question`,
- lehoty a chronológia → typované L2 records,
- starý `MEMORY.md` zostáva nedotknutý,
- markery sa injektujú iba do rozpoznaných sekcií `_STATUS.md`,
- premenovanie `spis.md` na `matter.md` a kľúčov na anglickú schému je súčasť jednej migrácie.

### VŘ

- typy sa normalizujú na OKF enumy,
- netypované záznamy sa nemenia potichu, dostanú finding,
- summary a links sa zachovajú,
- globálna harness-specific pamäť sa presunie alebo odkáže do otvorenej office vrstvy až po rozhodnutí o jej fyzickom umiestnení.

Najprv sa vykoná pilot na jednom reálnom spise mimo verejného repozitára. Do gitu patria iba syntetické alebo sanitizované fixtures.

## 18. Chybové správanie

- Jeden poškodený záznam nezhodí celý store.
- Future schema version sa otvorí read-only.
- Nedostupný registry provider je `unavailable`, nie čistý výsledok.
- Partial verification sa nesmie prezentovať ako úplná.
- Stale write plan sa odmietne.
- Neznáme polia sa zachovajú.
- Nezhoda mirroru je validačná chyba.
- Chýbajúci marker pri existujúcej status sekcii vyžaduje retrofit, nie append duplicity.
- Zlyhanie regenerovateľnej projekcie nemení kanonické records.
- Každá chyba má stabilný kód, súbor, závažnosť a odporúčaný krok.

## 19. Testy a acceptance criteria

OKF 1.0 je pripravený na integráciu do LAWOSS, keď:

- nový klient a viac prípadov možno založiť portable CLI,
- MČ legacy sa dá nedeštruktívne migrovať,
- VŘ typované aj netypované fixtures sa spracujú bez straty dát,
- Codex, Claude Code a OpenCode sa zorientujú iba cez `AGENTS.md`,
- `CLAUDE.md` mirror je testovaný na byte-identitu,
- Basic verification vytvorí auditovateľný subject/evidence record,
- reconciliation nájde modelový konflikt bez silent rewrite,
- scaffold, sync a migrácia sú idempotentné,
- parser zvládne čiarky v obchodných menách, Unicode, quotes a multiline text,
- jeden parse error nezastaví validáciu zvyšku,
- concurrency test odmietne stale revision,
- atomicity test nedovolí polovičný zápis,
- zmazanie LAWOSS cache nestratí kanonické údaje,
- SK, CZ a zahraničný subject fixture prejdú rovnakým core kontraktom.

## 20. Poradie implementácie

1. Spoločná revízia tejto špecifikácie a vizualizácie.
2. Syntetické fixtures MČ, VŘ a konsolidovaného formátu.
3. Portable OKF Core a CLI vo forku.
4. Migračný pilot a korekcia schémy.
5. Zmrazenie `okf_version: 1`.
6. Basic registry providers.
7. LAWOSS onboarding, watcher, read model a approvals.
8. UI klienta, prípadov, findings a reconciliation.
9. Extended verification a ďalšie capabilities.

## 21. Otvorené rozhodnutia

| ID | Otázka | Blokuje OKF 1.0 |
|---|---|---|
| O1 | Kde fyzicky žije kancelársky brain pri oddelených klientskych workspaceoch? | nie |
| O2 | Aká je minimálna multi-user politika nad optimistic concurrency? | čiastočne |
| O3 | Presný zoznam Basic providers pre SK a CZ a fallback pre zahraničie | áno pre provider implementáciu |
| O4 | Ktoré nízkorizikové L2 polia môže office policy v budúcnosti auto-approve? | nie |
| O5 | Ako dlho zostávajú staré legacy súbory aktívne po migrácii? | áno pre migráciu |

## 22. Rozhodovací návrh pre tím

Tím má oddelene hlasovať o:

1. otvorenom formáte a `AGENTS.md` bootstrap-e,
2. klientskej hierarchii s viacerými prípadmi,
3. anglickom machine contract-e,
4. typoch a vrstvách pamäte,
5. hranici automatic observation vs human-confirmed truth,
6. Basic verification v OKF 1.0,
7. poradí portable core pred LAWOSS UI,
8. ďalšom osude produktového PR #24.

Kým tieto body nie sú odklepnuté, tento dokument zostáva návrhom a PR #24 zostáva implementačným prototypom, nie kanonickým štandardom.
