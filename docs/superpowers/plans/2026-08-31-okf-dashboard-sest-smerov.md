# OKF Dashboard Six Directions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Vytvoriť jeden offline, klikateľný a prezentačne použiteľný high-fidelity prototyp šiestich odlišných OKF dashboardových smerov nad rovnakým syntetickým datasetom.

**Architecture:** Runtime artefakt bude jediný self-contained HTML súbor s inline CSS, JavaScriptom, SVG a embedded WOFF2 fontmi. Immutable dataset, navigačný stav a šesť smerov budú oddelené cez stabilné `data-*` kontrakty; samostatný Python validátor bude testovať statické invarianty, interakcie, responzivitu, print a screenshot matrix bez toho, aby sa stal runtime závislosťou prototypu.

**Tech Stack:** HTML5, CSS custom properties a layers, vanilla JavaScript, inline SVG, Python 3.14, Playwright 1.61, Chromium 1228, IBM Plex Sans, IBM Plex Mono, Playfair Display

**Spec:** `docs/design/2026-08-31-okf-dashboard-sest-smerov.md`

## Global Constraints

- Runtime výstup je iba `docs/design/hifi/okf-dashboard-directions.html` a musí fungovať cez `file://` bez buildu a internetu.
- Testovací nástroj je `scripts/validate-okf-dashboard-prototype.py`; screenshoty a PDF sa ukladajú iba do explicitného adresára pod `/tmp`.
- Použiť iba syntetický dataset zo specu. ALFA STAV je referenčný prípad, Risk Control Tower používa presne definovaný portfóliový envelope.
- Každá obrazovka trvalo zobrazuje `Fiktívne dáta · pracovný návrh`, vrátane fullscreen a print režimu.
- Zachovať existujúci LegalWork shell a LAWOSS tokeny. Nový paralelný aplikačný shell sa nevytvára.
- Raw farby sa deklarujú iba raz v `:root`; komponenty a SVG používajú `var(--lw-*)` alebo odvodené tokeny.
- Dark je jediná navrhovaná téma. Rohy sú 2 až 6 px, hairlines majú prednosť pred tieňmi a zlatá je vyhradená pre aktívny stav, návrh a jednu primárnu akciu.
- IBM Plex Sans, IBM Plex Mono a Playfair Display budú vložené ako Latin Extended WOFF2 data URI s OFL notices.
- Potvrdené, kandidátne, neoverené, stale, chybové a read-only dáta sa rozlišujú textom, tvarom aj farbou.
- Kandidátna lehota 14. 9. 2026 sa nikde nesmie označiť ako potvrdená ani ako právne overený výpočet.
- Zobraziť `base_revision`, `base_hash` a blokovaný `proposal stale` stav. Žiadna interakcia nevykonáva ani nepredstiera zápis.
- Bez provenance sa nesmie zobraziť `Overené`. Každý smer má aspoň jednu funkčnú cestu `Ukázať zdroj`.
- Nepoužiť percento AI istoty, magické rizikové skóre, produktivitné metriky agenta, silent last-write-wins ani generický SaaS KPI grid ako hlavnú kompozíciu.
- Používateľské rozhranie je slovenské. Český smoke test musí zobraziť `Případ · lhůta · důkaz · řízení`.
- Klávesové skratky sa ignorujú v `input`, `textarea`, `select` a `contenteditable`; každá skratka má viditeľnú ovládaciu alternatívu.
- WCAG AA kontrast, viditeľný focus, textový fallback diagramov, focus restoration a `prefers-reduced-motion` sú povinné.
- Nepoužiť em dash v žiadnom novom alebo zmenenom texte.
- Nestagovať ani neupravovať súbory mimo zoznamu pri konkrétnej úlohe.
- Nepushovať. Každý commit zostáva na aktuálnej vetve na kontrolu používateľa.

## File Map

| Súbor | Zodpovednosť |
|---|---|
| `docs/design/hifi/okf-dashboard-directions.html` | jediný runtime prototyp, dataset, shell, šesť smerov, interakcie, embedded fonty a print CSS |
| `scripts/validate-okf-dashboard-prototype.py` | statická, browserová, responzívna, print a screenshot validácia |
| `docs/design/README.md` | stručný odkaz na nový exploration set a jeho stav |

## Stable Runtime Contract

Smerové ID a selektory sú záväzné pre všetky úlohy:

```text
registry       data-testid="direction-1"
timeline       data-testid="direction-2"
constellation  data-testid="direction-3"
ledger         data-testid="direction-4"
brain          data-testid="direction-5"
tower          data-testid="direction-6"
```

Spoločné selektory:

```text
[data-direction][data-active="true"]
[data-direction-target="registry|timeline|constellation|ledger|brain|tower"]
[data-scenario="current|empty|partial|stale|parse-error|future-version|offline"]
[data-action="show-source"]
[data-action="show-gate"]
[data-action="close-inspector"]
[data-action="close-gate"]
[data-testid="demo-marker"]
[data-testid="source-inspector"]
[data-testid="gate-dialog"]
[data-testid="scenario-select"]
[data-testid="presentation-toggle"]
[data-testid="shortcut-help"]
[data-testid="text-fallback"]
```

JavaScript rozhranie:

```js
const DATA = Object.freeze({ matter, portfolio, records, events, scenarios });
const DIRECTION_IDS = Object.freeze([
  "registry", "timeline", "constellation", "ledger", "brain", "tower"
]);
const appState = {
  direction: "registry",
  scenario: "current",
  presentation: false,
  selectedTimelineEvent: "event-delivery",
  spotlightNode: "T-2026-029",
  selectedLedgerItem: "F-2026-018",
  brainLayer: "L2",
  riskLens: "urgency",
  lastSourceTrigger: null
};

function setDirection(id, options = { updateHash: true }) {}
function setScenario(id) {}
function openSourceInspector(sourceId, trigger) {}
function closeSourceInspector() {}
function openGate(proposalId, trigger) {}
function closeGate() {}
function setTimelineEvent(id) {}
function renderTimelineDetail(id) {}
function spotlightNode(id) {}
function setLedgerItem(id) {}
function renderLedgerDetail(id) {}
function setBrainLayer(layer) {}
function renderBrainLayer(layer) {}
function setRiskLens(id) {}
function renderRiskMatrix(id) {}
function togglePresentation(force) {}
function stepDirection(delta) {}
function closeTopLayerOrPresentation() {}
function isTypingTarget(target) {}
function announce(message) {}
```

---

### Task 1: Test Contract and Semantic Scaffold

**Files:**
- Create: `scripts/validate-okf-dashboard-prototype.py`
- Create: `docs/design/hifi/okf-dashboard-directions.html`
- Reference: `docs/design/2026-08-31-okf-dashboard-sest-smerov.md`

**Interfaces:**
- Consumes: stable runtime contract and global constraints from this plan
- Produces: validator CLI `--mode static|smoke|full`, six semantic direction roots and common test selectors

- [ ] **Step 1: Create the static validator before the HTML exists**

Create `scripts/validate-okf-dashboard-prototype.py` with this initial contract:

```python
#!/opt/homebrew/opt/python@3.14/bin/python3.14
from __future__ import annotations

import argparse
import re
from pathlib import Path

DIRECTIONS = ("registry", "timeline", "constellation", "ledger", "brain", "tower")
SCENARIOS = ("current", "empty", "partial", "stale", "parse-error", "future-version", "offline")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def validate_static(html_path: Path) -> None:
    html = html_path.read_text(encoding="utf-8")
    require("Fiktívne dáta · pracovný návrh" in html, "missing demo marker")
    require("ALFA STAV s.r.o." in html, "missing reference matter")
    require("14. 9. 2026" in html, "missing candidate deadline")
    require("base_revision" in html and "base_hash" in html, "missing concurrency trace")
    require("\u2014" not in html, "em dash is forbidden")
    require(not re.search(r'(?:src|href)=["\']https?://', html), "external request found")
    for index, direction in enumerate(DIRECTIONS, start=1):
        require(f'data-direction="{direction}"' in html, f"missing direction {direction}")
        require(f'data-testid="direction-{index}"' in html, f"missing direction test id {index}")
    for scenario in SCENARIOS:
        require(f'data-scenario="{scenario}"' in html, f"missing scenario {scenario}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--html", type=Path, required=True)
    parser.add_argument("--mode", choices=("static", "smoke", "full"), default="static")
    parser.add_argument("--artifacts", type=Path)
    args = parser.parse_args()
    validate_static(args.html.resolve())
    print(f"OK: {args.mode} validation passed for {args.html}")


if __name__ == "__main__":
    main()
```

- [ ] **Step 2: Run the validator and verify the intentional failure**

Run:

```bash
python3 scripts/validate-okf-dashboard-prototype.py \
  --html docs/design/hifi/okf-dashboard-directions.html \
  --mode static
```

Expected: FAIL with `FileNotFoundError` because the runtime artefact does not exist yet.

- [ ] **Step 3: Create the minimal semantic HTML scaffold**

The new HTML must include the six exact roots and seven scenario controls before visual implementation:

```html
<!doctype html>
<html lang="sk">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>LAWOSS · OKF dashboard · 6 smerov</title>
  <style>:root { color-scheme: dark; } [hidden] { display: none !important; }</style>
</head>
<body>
  <div data-testid="demo-marker">Fiktívne dáta · pracovný návrh</div>
  <nav aria-label="Smery dashboardu">
    <button data-direction-target="registry">1 · Podací denník</button>
    <button data-direction-target="timeline">2 · Procesná mapa</button>
    <button data-direction-target="constellation">3 · Dôkazová konštelácia</button>
    <button data-direction-target="ledger">4 · Auditný ledger</button>
    <button data-direction-target="brain">5 · OKF Brain</button>
    <button data-direction-target="tower">6 · Risk Control Tower</button>
  </nav>
  <select data-testid="scenario-select" aria-label="Diagnostický scenár">
    <option data-scenario="current" value="current">Aktuálny</option>
    <option data-scenario="empty" value="empty">Prázdny stav</option>
    <option data-scenario="partial" value="partial">Čiastočné dáta</option>
    <option data-scenario="stale" value="stale">Neaktuálny návrh</option>
    <option data-scenario="parse-error" value="parse-error">Chyba záznamu</option>
    <option data-scenario="future-version" value="future-version">Budúca verzia</option>
    <option data-scenario="offline" value="offline">Offline</option>
  </select>
  <main>
    <section data-direction="registry" data-testid="direction-1" data-active="true">ALFA STAV s.r.o. · 14. 9. 2026 · base_revision · base_hash</section>
    <section data-direction="timeline" data-testid="direction-2" data-active="false" hidden>ALFA STAV s.r.o.</section>
    <section data-direction="constellation" data-testid="direction-3" data-active="false" hidden>ALFA STAV s.r.o.</section>
    <section data-direction="ledger" data-testid="direction-4" data-active="false" hidden>ALFA STAV s.r.o.</section>
    <section data-direction="brain" data-testid="direction-5" data-active="false" hidden>ALFA STAV s.r.o.</section>
    <section data-direction="tower" data-testid="direction-6" data-active="false" hidden>ALFA STAV s.r.o.</section>
  </main>
</body>
</html>
```

- [ ] **Step 4: Run static validation and HTML syntax checks**

```bash
python3 scripts/validate-okf-dashboard-prototype.py --html docs/design/hifi/okf-dashboard-directions.html --mode static
tidy -qe docs/design/hifi/okf-dashboard-directions.html
```

Expected: validator prints `OK`; `tidy` identifies no unclosed element or duplicate ID.

- [ ] **Step 5: Commit the contract and scaffold**

```bash
git add scripts/validate-okf-dashboard-prototype.py docs/design/hifi/okf-dashboard-directions.html
git commit -m "test: ukotviť kontrakt OKF dashboard prototypu"
```

### Task 2: Shared Dataset, LAWOSS Shell and Direction Gallery

**Files:**
- Modify: `docs/design/hifi/okf-dashboard-directions.html`
- Modify: `scripts/validate-okf-dashboard-prototype.py`

**Interfaces:**
- Consumes: direction and scenario roots from Task 1
- Produces: immutable `DATA`, `appState`, shared LegalWork shell, gallery, routing, status primitives and screen switching

- [ ] **Step 1: Add failing static assertions for shared runtime primitives**

```python
for fragment in (
    "const DATA = Object.freeze(", "const appState =", "function setDirection(",
    "function setScenario(", 'data-testid="direction-gallery"',
    'data-testid="presentation-toggle"', 'data-testid="shortcut-help"',
    "Případ · lhůta · důkaz · řízení",
):
    require(fragment in html, f"missing shared primitive: {fragment}")
```

Run static validation. Expected: FAIL on the first missing primitive.

- [ ] **Step 2: Implement the token layer and shared shell**

```css
@layer reset, tokens, shell, components, directions, scenarios, responsive, print;
@layer tokens {
  :root {
    --lw-canvas:#0A0E14; --lw-sidebar:#0A0E14; --lw-surface:#10171F;
    --lw-surface-hover:#141C26; --lw-sunken:#0C1219;
    --lw-text-primary:#E9E4DA; --lw-text-secondary:#A8B0BA;
    --lw-text-tertiary:#75808C; --lw-accent:#C9A24A;
    --lw-success:#8DBB8F; --lw-warning:#D89A4E;
    --lw-danger:#D9776B; --lw-info:#7FA3C7;
    --lw-border-subtle:rgba(233,228,218,.08);
    --lw-border:rgba(233,228,218,.14);
    --lw-border-strong:rgba(233,228,218,.26);
    --lw-radius-xs:2px; --lw-radius-md:3px; --lw-radius-lg:4px;
  }
}
```

Create `.prototype-bar`, `.lw-shell`, `.lw-sidebar`, `.lw-content`, `.direction-gallery`, `.direction-root`, `.status-word`, `.source-link`, `.diagram-frame` and `.screen-reader-only`. Gallery rows have miniature diagram previews, thesis, target user, strength, trade-off and product role. They are presentation navigation, not product KPI cards.

- [ ] **Step 3: Add the immutable fixture**

Define `DATA.matter`, `DATA.portfolio`, `DATA.records`, `DATA.events` and `DATA.scenarios` with every exact ID, label, date, source and locator from spec sections 3.5 to 3.7. The object must include `T-2026-029`, `D-2026-011`, `TASK-2026-044`, `Q-2026-004`, `F-2026-018`, `DL-2026-007`, `F-2026-020`, `F-2026-021`, `OKF_STALE_001`, `OKF_PARSE_002` and `AUD-2026-084`.

- [ ] **Step 4: Implement direction and scenario routing**

`setDirection()` leaves exactly one root with `data-active="true"`, hides and makes the rest inert, sets `aria-current="page"` on the matching control and updates the hash `#registry` through `#tower`. The gallery is a separate overlay screen; direction 1 remains the prepared active preview under it until a direction is selected. `setScenario()` changes only a presentation filter and never mutates `DATA`. Invalid hashes open the gallery without throwing.

- [ ] **Step 5: Run shared-runtime checks**

```bash
python3 scripts/validate-okf-dashboard-prototype.py --html docs/design/hifi/okf-dashboard-directions.html --mode static
rg -n 'style="[^";]*#[0-9A-Fa-f]{3,8}|fill="#[0-9A-Fa-f]{3,8}|stroke="#[0-9A-Fa-f]{3,8}' docs/design/hifi/okf-dashboard-directions.html
```

Expected: validator PASS; `rg` returns no component-level raw colors.

- [ ] **Step 6: Commit shared runtime**

```bash
git add docs/design/hifi/okf-dashboard-directions.html scripts/validate-okf-dashboard-prototype.py
git commit -m "feat: vytvoriť shell a dáta OKF dashboard galérie"
```

### Task 3: Podací Denník and Procesná Mapa

**Files:**
- Modify: `docs/design/hifi/okf-dashboard-directions.html`
- Modify: `scripts/validate-okf-dashboard-prototype.py`

**Interfaces:**
- Consumes: `DATA`, `.direction-root`, routing and source-trigger contract
- Produces: direction 1 register view, direction 2 process timeline, `setTimelineEvent(id)`

- [ ] **Step 1: Add failing direction-specific assertions**

Require `registry-decision-queue`, `deadline-strip`, `timeline-diagram`, `event-delivery`, `event-deadline-candidate` and `text-fallback`. Run static validation. Expected: FAIL.

- [ ] **Step 2: Build direction 1 as a legal register**

Use this semantic order:

```html
<header class="matter-cover">klient · spisová značka · fáza · validácia</header>
<section data-testid="registry-decision-queue"><!-- F-2026-018, F-2026-021, F-2026-020 --></section>
<figure data-testid="deadline-strip"><svg aria-labelledby="registry-strip-title registry-strip-desc"></svg><figcaption data-testid="text-fallback">Textový zoznam lehôt a stavov</figcaption></figure>
<section class="change-register">posledné zmeny · ďalší krok · audit</section>
```

The 14-day strip labels `14. 9. 2026` as `návrh, čaká na potvrdenie` and shows `Žiadna potvrdená budúca lehota` for ALFA STAV.

- [ ] **Step 3: Build direction 2 as a process map**

Create lanes `Podanie`, `Dokazovanie`, `Rozhodnutie` and render all six events from spec section 3.4. Full lines mean confirmed; dashed gold means candidate. The right detail exposes trigger, `§ 362 ods. 1 CSP · demonštračný údaj`, source version, calculation trace and named uncertainty.

```js
function setTimelineEvent(id) {
  appState.selectedTimelineEvent = id;
  document.querySelectorAll("[data-timeline-event]").forEach((item) => {
    item.setAttribute("aria-selected", String(item.dataset.timelineEvent === id));
  });
  renderTimelineDetail(id);
}
```

- [ ] **Step 4: Verify and capture primary screenshots**

```bash
python3 scripts/validate-okf-dashboard-prototype.py --html docs/design/hifi/okf-dashboard-directions.html --mode static
playwright screenshot --viewport-size="1440,1024" "file://$PWD/docs/design/hifi/okf-dashboard-directions.html#registry" /tmp/okf-registry.png
playwright screenshot --viewport-size="1440,1024" "file://$PWD/docs/design/hifi/okf-dashboard-directions.html#timeline" /tmp/okf-timeline.png
```

Expected: both screenshots exist and no numeric KPI card dominates either screen.

- [ ] **Step 5: Commit directions 1 and 2**

```bash
git add docs/design/hifi/okf-dashboard-directions.html scripts/validate-okf-dashboard-prototype.py
git commit -m "feat: navrhnúť podací denník a procesnú mapu"
```

### Task 4: Dôkazová Konštelácia and Auditný Ledger

**Files:**
- Modify: `docs/design/hifi/okf-dashboard-directions.html`
- Modify: `scripts/validate-okf-dashboard-prototype.py`

**Interfaces:**
- Consumes: shared source triggers and fixture record IDs
- Produces: accessible evidence graph, ledger split inspector, `spotlightNode(id)`, `setLedgerItem(id)`

- [ ] **Step 1: Add failing graph and ledger assertions**

Require `evidence-graph`, graph nodes `T-2026-029` and `F-2026-020`, `graph-list-fallback`, `audit-ledger`, ledger items `OKF_PARSE_002` and `OKF_STALE_001`. Run static validation. Expected: FAIL.

- [ ] **Step 2: Build the evidence constellation**

Use an inline SVG with node types `document`, `evidence`, `truth`, `decision`, `finding`, `subject`. Each node has an adjacent keyboard-operable control. `spotlightNode("T-2026-029")` dims unrelated edges, highlights the provenance path and updates the inspector preview. Add a visible collapsible table with columns `Od`, `Vzťah`, `Do`, `Stav` containing the same graph edges.

- [ ] **Step 3: Build the audit ledger**

Rows include `F-2026-018`, `F-2026-020`, `F-2026-021`, `OKF_STALE_001`, `OKF_PARSE_002` and `AUD-2026-084`. Selection updates a split inspector with diff, provenance, append-only History and recommended next action.

```js
function setLedgerItem(id) {
  appState.selectedLedgerItem = id;
  document.querySelectorAll("[data-ledger-item]").forEach((row) => {
    row.setAttribute("aria-selected", String(row.dataset.ledgerItem === id));
  });
  renderLedgerDetail(id);
}
```

- [ ] **Step 4: Verify safety and commit**

```bash
python3 scripts/validate-okf-dashboard-prototype.py --html docs/design/hifi/okf-dashboard-directions.html --mode static
rg -n "AI.*[0-9]+%|risk score|win rate|silent" docs/design/hifi/okf-dashboard-directions.html
git add docs/design/hifi/okf-dashboard-directions.html scripts/validate-okf-dashboard-prototype.py
git commit -m "feat: pridať dôkazovú konšteláciu a auditný ledger"
```

Expected: validator PASS; `rg` returns no prohibited metric or behavior copy.

### Task 5: OKF Brain and Risk Control Tower

**Files:**
- Modify: `docs/design/hifi/okf-dashboard-directions.html`
- Modify: `scripts/validate-okf-dashboard-prototype.py`

**Interfaces:**
- Consumes: `DATA.records`, `DATA.portfolio`, shared gate and source contracts
- Produces: L1/L2/L3 memory view, controlled promotion preview, portfolio risk lenses, `setBrainLayer(layer)`, `setRiskLens(id)`

- [ ] **Step 1: Add failing memory and portfolio assertions**

Require `brain-layers`, `data-brain-layer="L1|L2|L3"`, the copy `L2-to-L3 leak kontrola`, `risk-matrix` and risk lenses `urgency`, `evidence`, `data-health`, `workload`. Run static validation. Expected: FAIL.

- [ ] **Step 2: Build OKF Brain**

Use three adjacent memory bands with a stable matter brief. L2 is active initially and shows current truth, decision, question, task and two pending findings. L1 promotion preview requires human gate; L3 adds legal review and L2-to-L3 leak control. No drag-and-drop affordance may exist.

```js
function setBrainLayer(layer) {
  if (!["L1", "L2", "L3"].includes(layer)) return;
  appState.brainLayer = layer;
  document.querySelectorAll("[data-brain-layer]").forEach((button) => {
    button.setAttribute("aria-pressed", String(button.dataset.brainLayer === layer));
  });
  renderBrainLayer(layer);
}
```

- [ ] **Step 3: Build Risk Control Tower**

Render the five exact portfolio rows from `DATA.portfolio` against transparent columns `Lehota`, `Chýbajúci zdroj`, `Stale`, `Human gate`, `Provider`. Each cell shows a reason word or source count, never a combined score. ALFA STAV is selected and drills down to `#registry` while preserving a breadcrumb back to `prax`.

```js
function setRiskLens(id) {
  if (!["urgency", "evidence", "data-health", "workload"].includes(id)) return;
  appState.riskLens = id;
  document.querySelectorAll("[data-risk-lens]").forEach((button) => {
    button.setAttribute("aria-pressed", String(button.dataset.riskLens === id));
  });
  renderRiskMatrix(id);
}
```

- [ ] **Step 4: Verify scope and drill-down**

Run static validation. Confirm direction 5 displays `prípad`, direction 6 displays `prax`, and activating ALFA STAV changes the hash to `#registry` without page reload.

- [ ] **Step 5: Commit directions 5 and 6**

```bash
git add docs/design/hifi/okf-dashboard-directions.html scripts/validate-okf-dashboard-prototype.py
git commit -m "feat: doplniť OKF Brain a partnerský risk prehľad"
```

### Task 6: Source Inspector, Human Gate, Scenarios and Keyboard Control

**Files:**
- Modify: `docs/design/hifi/okf-dashboard-directions.html`
- Modify: `scripts/validate-okf-dashboard-prototype.py`

**Interfaces:**
- Consumes: all source triggers, proposal IDs and diagnostic controls from Tasks 2 to 5
- Produces: reusable source inspector, inert demonstration gate, scenario renderer, keyboard navigation, focus restoration, Playwright smoke mode

- [ ] **Step 1: Extend the validator with a failing browser smoke test**

Import Playwright only for mode `smoke` or `full`:

```python
from playwright.sync_api import sync_playwright


def validate_browser_smoke(html_path: Path) -> None:
    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(headless=True)
        page = browser.new_page(viewport={"width": 1440, "height": 1024})
        errors: list[str] = []
        page.on("console", lambda message: errors.append(message.text) if message.type == "error" else None)
        page.on("pageerror", lambda error: errors.append(str(error)))
        page.goto(html_path.as_uri())
        require(page.locator('[data-direction][data-active="true"]').count() == 1, "not exactly one active direction")
        require(page.get_by_test_id("demo-marker").is_visible(), "demo marker not visible")
        require(page.evaluate("document.documentElement.scrollWidth <= document.documentElement.clientWidth"), "global horizontal overflow")
        require(not errors, f"browser errors: {errors}")
        browser.close()
```

Call this function from `main()` for `smoke` and `full`. Run `--mode smoke`. Expected: FAIL on incomplete controls or interactions.

- [ ] **Step 2: Implement the source inspector**

Create one `<aside role="dialog" aria-modal="true" data-testid="source-inspector">` with sections `UI hodnota`, `Read model`, `Kanonický záznam`, `Súbor a riadok`, `Evidence`, `History`. `openSourceInspector(sourceId, trigger)` stores the trigger, fills the exact fixture and focuses the close button. `closeSourceInspector()` hides the panel and restores focus.

- [ ] **Step 3: Implement the demonstration gate and stale state**

The gate displays source, locator, proposed diff, named uncertainty, destination, `base_revision: 18`, `base_hash: 81aa39f2` and the sentence describing the write target. Under scenario `stale`, Potvrdiť and Upraviť are disabled, the changed input is named and `Prepočítať návrh` appears. Every action announces `Demonštračný stav · nič sa nezapísalo`.

- [ ] **Step 4: Implement all seven scenario projections**

Use `document.body.dataset.scenario = id` plus a dedicated banner. Scenario changes only visibility and copy; frozen fixture data remains unchanged. `future-version` makes the active dashboard read-only. `offline` keeps local records visible and marks the provider unavailable.

- [ ] **Step 5: Implement safe keyboard behavior**

```js
function isTypingTarget(target) {
  return target instanceof HTMLElement && (
    ["INPUT", "TEXTAREA", "SELECT"].includes(target.tagName) || target.isContentEditable
  );
}

document.addEventListener("keydown", (event) => {
  if (isTypingTarget(event.target)) return;
  if (/^[1-6]$/.test(event.key)) setDirection(DIRECTION_IDS[Number(event.key) - 1]);
  if (event.key === "ArrowRight") stepDirection(1);
  if (event.key === "ArrowLeft") stepDirection(-1);
  if (event.key.toLowerCase() === "f") togglePresentation();
  if (event.key === "Escape") closeTopLayerOrPresentation();
});
```

Add visible shortcut help and equivalent buttons.

- [ ] **Step 6: Expand browser smoke assertions**

Test `2`, ArrowRight, ArrowLeft, `F`, Escape; focus the scenario select and verify pressing `1` does not switch. Open a source trigger, assert the inspector includes a file and line, close it, and verify focus returns to the trigger. Exercise all seven scenarios and assert one active direction throughout.

- [ ] **Step 7: Run smoke mode and commit**

```bash
python3 scripts/validate-okf-dashboard-prototype.py \
  --html docs/design/hifi/okf-dashboard-directions.html \
  --mode smoke
git add docs/design/hifi/okf-dashboard-directions.html scripts/validate-okf-dashboard-prototype.py
git commit -m "feat: pridať zdroje, brány a bezpečné ovládanie"
```

### Task 7: Embedded Fonts, Responsive Layout, Reduced Motion and Print

**Files:**
- Modify: `docs/design/hifi/okf-dashboard-directions.html`
- Modify: `scripts/validate-okf-dashboard-prototype.py`

**Interfaces:**
- Consumes: complete runtime and browser smoke validator
- Produces: offline font payload, responsive behavior, reduced-motion behavior, A4 print output and 24-image screenshot matrix

- [ ] **Step 1: Add failing final-mode assertions**

Require three `@font-face` declarations, `OFL-1.1`, `@media (max-width:1100px)`, `@media (max-width:700px)`, `@media (prefers-reduced-motion:reduce)` and `@media print`. Run `--mode static`. Expected: FAIL.

- [ ] **Step 2: Embed the licensed Latin Extended fonts**

Use these exact local sources:

```text
/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/LAWOSS/node_modules/.pnpm/@fontsource-variable+ibm-plex-sans@5.2.8/node_modules/@fontsource-variable/ibm-plex-sans/files/ibm-plex-sans-latin-ext-wght-normal.woff2
/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/LAWOSS/node_modules/.pnpm/@fontsource+ibm-plex-mono@5.3.0/node_modules/@fontsource/ibm-plex-mono/files/ibm-plex-mono-latin-ext-400-normal.woff2
/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/LAWOSS/node_modules/.pnpm/@fontsource-variable+playfair-display@5.3.0/node_modules/@fontsource-variable/playfair-display/files/playfair-display-latin-ext-wght-normal.woff2
```

Insert base64 payloads mechanically into predeclared markers `__FONT_IBM_PLEX_SANS__`, `__FONT_IBM_PLEX_MONO__`, `__FONT_PLAYFAIR__`. Add the package copyright notices and complete OFL 1.1 license in a collapsed `details` element. Do not print base64 payloads to the terminal transcript.

Use this bounded mechanical rewrite after the markers exist:

```bash
node <<'NODE'
const fs = require('node:fs');
const htmlPath = 'docs/design/hifi/okf-dashboard-directions.html';
const assets = {
  '__FONT_IBM_PLEX_SANS__': '/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/LAWOSS/node_modules/.pnpm/@fontsource-variable+ibm-plex-sans@5.2.8/node_modules/@fontsource-variable/ibm-plex-sans/files/ibm-plex-sans-latin-ext-wght-normal.woff2',
  '__FONT_IBM_PLEX_MONO__': '/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/LAWOSS/node_modules/.pnpm/@fontsource+ibm-plex-mono@5.3.0/node_modules/@fontsource/ibm-plex-mono/files/ibm-plex-mono-latin-ext-400-normal.woff2',
  '__FONT_PLAYFAIR__': '/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/LAWOSS/node_modules/.pnpm/@fontsource-variable+playfair-display@5.3.0/node_modules/@fontsource-variable/playfair-display/files/playfair-display-latin-ext-wght-normal.woff2'
};
const licenses = [
  '/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/LAWOSS/node_modules/.pnpm/@fontsource-variable+ibm-plex-sans@5.2.8/node_modules/@fontsource-variable/ibm-plex-sans/LICENSE',
  '/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/LAWOSS/node_modules/.pnpm/@fontsource+ibm-plex-mono@5.3.0/node_modules/@fontsource/ibm-plex-mono/LICENSE',
  '/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/LAWOSS/node_modules/.pnpm/@fontsource-variable+playfair-display@5.3.0/node_modules/@fontsource-variable/playfair-display/LICENSE'
];
const escapeHtml = (value) => value.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
let html = fs.readFileSync(htmlPath, 'utf8');
for (const [marker, fontPath] of Object.entries(assets)) {
  if (!html.includes(marker)) throw new Error(`Missing marker ${marker}`);
  html = html.replace(marker, fs.readFileSync(fontPath).toString('base64'));
}
const licenseText = licenses.map((licensePath) => fs.readFileSync(licensePath, 'utf8')).join('\n\n');
if (!html.includes('__OFL_LICENSES__')) throw new Error('Missing marker __OFL_LICENSES__');
html = html.replace('__OFL_LICENSES__', escapeHtml(licenseText));
fs.writeFileSync(htmlPath, html, 'utf8');
NODE
```

- [ ] **Step 3: Implement responsive layouts**

At `max-width:1100px`, collapse the sidebar to a top rail and make the source inspector a fixed overlay. At `max-width:700px`, stack every direction, expose text fallbacks by default, and confine graph or timeline horizontal scrolling to `.diagram-scroll`. The document root must never overflow horizontally.

- [ ] **Step 4: Implement reduced motion and print**

All intentional motion elements receive `data-animated`. Under reduced motion, their animation and transition duration becomes `0.01ms`. Print shows only the active direction, its title, thesis and permanent demo marker; shell controls, dialogs and shortcut help are hidden. Use `@page { size: A4 landscape; margin: 10mm; }`.

- [ ] **Step 5: Implement full Playwright matrix**

In `validate_full()`, iterate six directions over viewports `(1440,1024)`, `(1280,800)`, `(1024,768)`, `(390,844)`. Save 24 screenshots into `--artifacts/screenshots`. For each direction set print media and save `direction-N.pdf`; verify marker visibility before PDF creation. Use `page.emulate_media(reduced_motion="reduce")` and assert every `[data-animated]` computed transition and animation duration is zero or `0.01ms`.

- [ ] **Step 6: Run full automated validation**

```bash
OKF_ARTIFACT_ROOT="$(mktemp -d /tmp/okf-dashboard-validation.XXXXXX)"
python3 scripts/validate-okf-dashboard-prototype.py \
  --html docs/design/hifi/okf-dashboard-directions.html \
  --mode full \
  --artifacts "$OKF_ARTIFACT_ROOT"
find "$OKF_ARTIFACT_ROOT/screenshots" -type f -name '*.png' | wc -l
find "$OKF_ARTIFACT_ROOT" -type f -name '*.pdf' | wc -l
```

Expected: 24 PNG files, 6 PDF files, zero console errors, zero external requests and zero global horizontal overflows.

- [ ] **Step 7: Inspect primary screenshots visually**

Open the six 1440 x 1024 screenshots with the local image viewer. Check alignment, text clipping, legibility, distinctiveness, single gold emphasis, diagram hierarchy and visible status semantics. Record each defect as a concrete selector and correct it before proceeding.

- [ ] **Step 8: Commit the production-quality prototype**

```bash
git add docs/design/hifi/okf-dashboard-directions.html scripts/validate-okf-dashboard-prototype.py
git commit -m "fix: dokončiť responzívny a offline OKF prototyp"
```

### Task 8: Presentation Index and Final Acceptance

**Files:**
- Modify: `docs/design/README.md`
- Verify: `docs/design/hifi/okf-dashboard-directions.html`
- Verify: `scripts/validate-okf-dashboard-prototype.py`
- Reference: `docs/design/2026-08-31-okf-dashboard-sest-smerov.md`

**Interfaces:**
- Consumes: complete and validated prototype
- Produces: discoverable design index entry and final evidence-backed handoff

- [ ] **Step 1: Add the prototype to the design index**

```markdown
## OKF dashboard · šesť smerov

- [Klikateľná high-fidelity galéria](hifi/okf-dashboard-directions.html)
- [Schválený rozsah a hodnotiace kritériá](2026-08-31-okf-dashboard-sest-smerov.md)

Pracovný exploration set nad fiktívnymi dátami. Nejde o finálne tímové rozhodnutie ani o produktovú implementáciu.
```

- [ ] **Step 2: Run final acceptance**

```bash
FINAL_OKF_ARTIFACT_ROOT="$(mktemp -d /tmp/okf-dashboard-final.XXXXXX)"
python3 scripts/validate-okf-dashboard-prototype.py \
  --html docs/design/hifi/okf-dashboard-directions.html \
  --mode full \
  --artifacts "$FINAL_OKF_ARTIFACT_ROOT"
tidy -qe docs/design/hifi/okf-dashboard-directions.html
rg -n '\x{2014}|T[B]D|T[O]DO|F[I]XME' \
  docs/design/hifi/okf-dashboard-directions.html \
  scripts/validate-okf-dashboard-prototype.py \
  docs/design/README.md
rg -n "(src|href)=[\"']https?://" docs/design/hifi/okf-dashboard-directions.html
git diff --check
```

Expected: validator PASS; `tidy` has no structural error; `rg` returns no prohibited fragment; git diff has no whitespace error.

- [ ] **Step 3: Verify commit scope**

```bash
git status --short
git diff --stat HEAD~1..HEAD
```

Expected: only the planned prototype, validator and design index are involved. Existing unrelated user changes remain untouched.

- [ ] **Step 4: Commit the presentation index**

```bash
git add docs/design/README.md
git commit -m "docs: sprístupniť šesť smerov OKF dashboardu"
```

- [ ] **Step 5: Open the final gallery for the user**

Open this absolute local path in a browser panel:

```text
/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/mikeOSS-SLOVAKIA/docs/design/hifi/okf-dashboard-directions.html
```

Handoff reports the final file, six direction names, automated validation result, screenshot and PDF counts, commits created and any deliberately unimplemented non-goal. Do not claim product integration or a team-approved final dashboard.
