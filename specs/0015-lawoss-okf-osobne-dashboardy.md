# Spec 0015: LAWOSS osobné dashboardy nad OKF

- **Stav:** návrh MČ na spoločnú revíziu, nie je odklepnuté tímom
- **Navrhol:** Marián Čuprík (MČ) · 2026-09-01
- **Produktový cieľ:** natívna obrazovka LAWOSS `/prehlad`
- **Dátový základ:** [OKF 1.0](0014-okf-1-kanonicky-kontrakt.md)
- **Vizuálne prototypy:** [varianty 1 až 3](../docs/design/hifi/lawoss-okf-personal-dashboard-presets-1-3.html) · [varianty 4 až 6](../docs/design/hifi/lawoss-okf-personal-dashboard-presets-4-6.html)
- **Implementačný plán:** [postup po odklepnutí](../docs/superpowers/plans/2026-09-01-lawoss-okf-osobne-dashboardy.md)
- **Nadväzuje na:** [pôvodný exploration set](../docs/design/2026-08-31-okf-dashboard-sest-smerov.md), [LAWOSS design system](../docs/design/design-system.md)

> [!IMPORTANT]
> Toto je návrh MČ. Zaznamenáva dohodnuté zadanie a high-fidelity smery, ale nie je tímovým rozhodnutím a neoprávňuje implementáciu v produktovom repe. HTML súbory sú prezentačné artefakty. Produkčný dashboard musí byť zostavený z natívnych React komponentov v LAWOSS, bez WebView, iframe alebo paralelnej miniaplikácie.

## 1. Spresnenie zadania

Pôvodný exploration set porovnával najmä rôzne informačné pohľady. Aktuálne zadanie je užšie a produktovo presnejšie:

- všetkých šesť variantov predstavuje tú istú obrazovku `Prehľad`,
- všetky používajú ten istý syntetický prípad a ten istý OKF read model,
- mení sa vizuálna osobnosť, hustota, informačná hierarchia a UX štýl,
- používateľ si môže zvoliť vlastný osobný preset,
- dashboard sa prispôsobí kontextu praxe, klienta, workspace alebo prípadu,
- dashboard iba zobrazuje OKF dáta a nevytvára druhý zdroj právnej pravdy.

## 2. Produktový princíp

```text
kanonické OKF súbory, read-only
  -> validovaný typovaný LAWOSS read model
  -> spoločný register widgetov
  -> osobný UI preset
  -> natívna route /prehlad
```

LAWOSS môže mimo OKF rootu uložiť iba osobnú konfiguráciu rozhrania, cache a odvodený index. Osobná konfigurácia nikdy neobsahuje právne fakty, lehoty, rozhodnutia, findings ani auditné udalosti.

Zmazanie konfigurácie alebo cache musí iba obnoviť predvolený layout. Nesmie zmeniť obsah spisu.

## 3. Rozsah kontextu

Dashboard používa jeden komponentový model, ale môže dostať odlišný `scope`:

| Scope | Čo zobrazuje | Príklad |
|---|---|---|
| `practice` | osobný prehľad naprieč praxou | moje dnešné rozhodnutia, lehoty a kapacita |
| `client` | prípady a spoločné údaje jedného klienta | ALFA STAV s.r.o. |
| `workspace` | otvorený projektový alebo klientsky root | aktuálny OKF workspace |
| `matter` | detail jedného prípadu | 18Cb/47/2026 |

Breadcrumb vždy ukáže aktívny scope. Prepnutie scope nemení osobné preferencie ostatných používateľov ani kanonické OKF dáta.

## 4. Typovaný read model

Minimálny kontrakt projekcie:

```ts
type DashboardContext = {
  scope: "practice" | "client" | "workspace" | "matter";
  workspaceId?: string;
  clientId?: string;
  matterId?: string;
};

type OkfDashboardSnapshot = {
  revision: string;
  generatedAt: string;
  context: DashboardContext;
  identity: DashboardIdentity;
  decisions: DashboardDecision[];
  deadlines: DashboardDeadline[];
  tasks: DashboardTask[];
  questions: DashboardQuestion[];
  events: DashboardEvent[];
  findings: DashboardFinding[];
  sources: DashboardSourceState[];
  provenance: Record<string, DashboardProvenance>;
  diagnostics: DashboardDiagnostic[];
};
```

Každá právne významná hodnota musí niesť:

- stabilné ID,
- stav ako `confirmed`, `candidate`, `partial`, `stale` alebo `error`,
- locator pôvodného súboru alebo evidencie,
- revision alebo hash, z ktorého bola projekcia vytvorená,
- auditnú väzbu, ak bola hodnota potvrdená človekom.

Dashboard nesmie nazvať hodnotu potvrdenou, ak read model neposkytne provenance.

## 5. Osobná konfigurácia

```ts
type DashboardPresetId =
  | "visual-command-center"
  | "minimal-focus"
  | "information-dense"
  | "process-evidence"
  | "calendar-first"
  | "modular-personal-cockpit";

type DashboardPreferences = {
  version: 1;
  presetId: DashboardPresetId;
  enabledWidgetIds: string[];
  layout: Array<{
    widgetId: string;
    order: number;
    width: 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12;
  }>;
  scopeDefaults: Partial<Record<DashboardContext["scope"], DashboardPresetId>>;
};
```

Konfigurácia je v prvej verzii:

- osobná a lokálna pre zariadenie,
- oddelená od OKF rootu,
- verzovaná a bezpečne resetovateľná,
- obmedzená na povolené widgety a dvanásťstĺpcovú mriežku,
- bez tímového zdieľania a bez faktov zo spisu.

## 6. Spoločný register widgetov

Všetky presety používajú rovnaké widgety a ten istý snapshot. Preset iba mení kompozíciu a prioritu.

| Widget | Primárna informácia | Povinná bezpečnostná vlastnosť |
|---|---|---|
| `next-decision` | najbližšie rozhodnutie advokáta | otvorí human gate, sám nezapisuje |
| `matter-process` | fáza, vlastníci a handoffy | každý uzol má vlastníka a provenance |
| `deadlines` | potvrdené a kandidátne lehoty | stav nie je rozlíšený iba farbou |
| `calendar` | lehoty, pojednávania a pracovné bloky | kandidát sa netvári ako potvrdená udalosť |
| `record-register` | truth, findings, tasks a questions | umožní drill-down na zdroj |
| `source-health` | dostupnosť, freshness a parse stav | chyba jedného zdroja neskryje ostatné dáta |
| `activity` | posledná auditná aktivita | uvádza autora a typ operácie |
| `workload` | osobná pracovná kapacita | nie je právnym rizikovým skóre |

## 7. Šesť porovnateľných UI smerov

### 7.1 Visual Command Center

Dominantný procesný pás, veľká kandidátna lehota a jasný najbližší human gate. Vhodné pre vizuálne orientovaného používateľa, ktorý chce rýchlo pochopiť stav spisu.

### 7.2 Minimal Focus

Jedna najdôležitejšia právna veta a jedna primárna akcia. Ďalšie informácie sa odkrývajú progresívne. Vhodné pre pokojný režim bez vizuálneho hluku.

### 7.3 Information Dense

Register, stav, zdroj, detail a audit vedľa seba. Vhodné pre power usera, intenzívnu operatívu a kontrolu viacerých záznamov.

### 7.4 Process & Evidence

Swimlane mapa spisu s lanes `Klient`, `Advokát`, `OKF` a `Súd`. Zobrazuje vlastníctvo, handoffy, automatické kroky a human gate. Detail vybraného uzla sa otvára v bočnom inspectore.

Tento variant používateľ počas prezentácie aktívne otvoril. Evidujeme ho ako prejavený záujem, nie ako finálnu voľbu.

### 7.5 Calendar First

Vrstvený týždenný kalendár spája potvrdené lehoty, kandidátne lehoty, pojednávania a rezervovaný čas na právnu prácu. Vhodné pre používateľa, ktorého pracovný deň riadi čas.

### 7.6 Modular Personal Cockpit

Bezpečný osobný composer v stabilnej dvanásťstĺpcovej mriežke. Používateľ mení poradie, šírku a viditeľnosť widgetov. Presúva iba pohľady, nie OKF dáta.

## 8. Procesná mapa

Procesná mapa nie je dekorácia. Musí spĺňať tieto pravidlá:

1. Najviac štyri swimlanes a osem hlavných krokov v jednom pohľade.
2. Každý krok má jedného vlastníka.
3. Automatický krok, ľudské rozhodnutie a externá udalosť majú odlišný tvar alebo štýl čiary.
4. Zlatá zvýrazňuje aktuálny human gate, nie každý aktívny prvok.
5. Klik na uzol otvorí inspector so zdrojom, locatorom, neistotou, revision a auditom.
6. Diagram má textový názov, opis a klávesovo dosiahnuteľný ekvivalent.
7. Pri menšej šírke sa inspector presunie pod mapu alebo do draweru. Nesmie zakryť hlavný tok.

Geometria prezentačného SVG bola 2026-09-01 overená nástrojom `verify-geometry.py` z diagram-design pluginu s výsledkom 0 nálezov.

## 9. Stavy a zlyhania

Každý preset musí vedieť zobraziť rovnaké diagnostické stavy:

- žiadna potvrdená budúca lehota,
- čiastočné overenie subjektu,
- stale read model alebo stale write plan,
- parse error jedného OKF záznamu,
- workspace s novšou nepodporovanou verziou,
- offline registre pri dostupných lokálnych dátach,
- prázdny scope bez prípadu alebo klienta.

Chyba jedného záznamu nesmie zmeniť zvyšok čitateľného store na prázdnu obrazovku. Budúca verzia OKF sa otvorí read-only s jasným vysvetlením.

## 10. Natívna integrácia do LAWOSS

Overené lokálnou kontrolou produktového repa 2026-09-01:

- LAWOSS je Electron aplikácia s React 19 a Vite,
- existujúca route `/prehlad` je deklarovaná v `apps/app/src/lawoss/shell/routes.tsx`,
- obrazovka žije v `apps/app/src/lawoss/domains/prehlad/prehlad-page.tsx`,
- shell poskytuje `apps/app/src/lawoss/shell/layout.tsx`.

Implementácia po odklepnutí rozšíri túto existujúcu plochu. Nevytvorí samostatnú webovú aplikáciu, WebView ani iframe. High-fidelity HTML slúži iba na porovnanie dizajnov a prezentáciu v GitHub Pages.

## 11. Rešerš vizuálnych vzorov

Verejné referencie boli vyhľadané a otvorené cez web 2026-09-01. Použili sa iba ako kalibrácia kompozície, nie na kopírovanie konkrétneho rozhrania:

- [Untitled UI, Week view calendar](https://dribbble.com/shots/25708683-Week-view-calendar-Untitled-UI): vrstvenie pracovného týždňa,
- [Multi-layered calendar in Black, Dark & Light mode](https://dribbble.com/shots/22477011-Multi-layered-calendar-in-Black-Dark-Light-mode): hustota a tmavý kalendár,
- [Case management for a legal management system](https://dribbble.com/shots/22487455-Case-management-for-a-legal-management-system): právna hlavička prípadu a hierarchia detailu,
- [Xesence AI Powered Legal Dashboard](https://www.behance.net/gallery/232068815/Xesence-AI-Powered-Legal-Dashboard-UI-UX): kombinácia legal workflow a dashboard navigácie.

Pôvodnosť LAWOSS smerov tvorí spojenie local-first OKF, provenance, human gate, osobného presetu a LAWOSS vizuálneho jazyka.

## 12. Non-goals

- tímovo zdieľaný layout,
- zapisovanie právnych faktov z composeru,
- nahradenie OKF súborov databázou dashboardu,
- automatické potvrdzovanie lehôt,
- univerzálne AI confidence alebo risk score,
- samostatný webový produkt mimo LAWOSS,
- produktová implementácia pred tímovým odklepnutím.

## 13. Akceptačné kritériá

- [ ] Jeden fixture snapshot vykreslí všetkých šesť presetov bez zmeny dát.
- [ ] Preset sa dá nastaviť osobitne pre `practice`, `client`, `workspace` a `matter`.
- [ ] Osobné preferencie neobsahujú žiadny právny fakt zo spisu.
- [ ] Každá právne významná hodnota otvorí provenance až po súbor a locator.
- [ ] Kandidátna a potvrdená lehota sa líšia textom aj vizuálnym štýlom.
- [ ] Human gate zobrazí zdroj, neistotu, diff a revision pred akoukoľvek mutáciou.
- [ ] Offline a parse-error stav zachová čitateľné lokálne dáta.
- [ ] Reset layoutu nemení OKF root.
- [ ] Implementácia používa existujúcu route `/prehlad` a natívne React komponenty.
- [ ] Žiadny WebView, iframe ani paralelná miniaplikácia.
- [ ] Klávesové ovládanie, focus stav a čítačka obrazovky sprístupnia hlavné funkcie.

## 14. Otvorené rozhodnutia pre tím

1. Ktorý preset bude predvolený pre nového používateľa?
2. Má si používateľ zvoliť jeden globálny preset alebo odlišný preset podľa scope?
3. Ktoré widgety patria do prvej implementačnej dávky?
4. Má sa `Calendar First` v prvej verzii napojiť iba na OKF lehoty alebo aj na externý kalendár?
5. Je `Process & Evidence` hlavný kandidát na detail prípadu alebo iba voliteľný lens?

Odporúčanie MČ na diskusiu: začať s `Visual Command Center` ako defaultom, `Process & Evidence` ako procesným lensom a `Minimal Focus` ako alternatívou. Ostatné presety môžu nad tým istým registrom widgetov pribudnúť bez zmeny dátového kontraktu.
