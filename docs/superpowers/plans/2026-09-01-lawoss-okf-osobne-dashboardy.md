# LAWOSS OKF Personal Dashboard Presets Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task by task.

**Goal:** Nahradiť fiktívny obsah existujúcej natívnej route `/prehlad` osobným dashboardom, ktorý bezpečne zobrazuje jeden typovaný read model nad kanonickými OKF súbormi v šiestich UI presetoch.

**Architecture:** Kanonické OKF súbory zostávajú jediným zdrojom pravdy. Framework-independent adapter vytvorí immutable `OkfDashboardSnapshot`. React vrstva používa spoločný register widgetov a osobný verzovaný layout store. Presety menia iba kompozíciu. Existujúci LAWOSS shell a route zostávajú zachované.

**Tech Stack:** TypeScript, React 19, Vite, Electron, Bun test runner, existujúce LAWOSS CSS tokeny.

**Spec:** [specs/0015-lawoss-okf-osobne-dashboardy.md](../../../specs/0015-lawoss-okf-osobne-dashboardy.md)

## Global Constraints

- Implementovať až po odklepnutí specu tímom.
- Pracovať v produktovom repe `Omni-Legal-Products/lawoss` cez branch a PR.
- Zachovať upstream zóny a `PATCHES.md` disciplínu produktového repa.
- Žiadny WebView, iframe ani paralelná webová aplikácia.
- Žiadna mutácia OKF cez dashboard composer.
- Každý krok robiť test-first a po každom kroku spustiť cielené testy.
- Použiť iba fiktívne fixture dáta v testoch a Storybook-like prezentačných plochách.

## Task 1: Zaviesť typy dashboard kontraktu

**Files:**

- Create: `lawoss/okf/dashboard-types.ts`
- Create: `lawoss/okf/dashboard-types.test.ts`

**Step 1: Write the failing test**

Vytvoriť compile/runtime test, ktorý overí povinné `revision`, `context`, provenance a stabilné stavy `confirmed`, `candidate`, `partial`, `stale`, `error`.

**Step 2: Run test to verify it fails**

Run: `bun test lawoss/okf/dashboard-types.test.ts`

Expected: FAIL, modul ešte neexistuje.

**Step 3: Write minimal implementation**

Definovať `DashboardContext`, `OkfDashboardSnapshot`, entity typy a diskriminované uniony stavov. Všetky polia majú byť `readonly`.

**Step 4: Run test to verify it passes**

Run: `bun test lawoss/okf/dashboard-types.test.ts`

Expected: PASS.

**Step 5: Commit**

```bash
git add lawoss/okf/dashboard-types.ts lawoss/okf/dashboard-types.test.ts
git commit -m "feat: pridať typovaný OKF dashboard kontrakt"
```

## Task 2: Vytvoriť read-only OKF dashboard adapter

**Files:**

- Create: `lawoss/okf/read-dashboard-snapshot.ts`
- Create: `lawoss/okf/read-dashboard-snapshot.test.ts`
- Create: `lawoss/okf/__fixtures__/alfa-stav/`

**Step 1: Write the failing tests**

Pokryť validný snapshot, partial verification, jeden parse error, stale projection, offline provider a budúcu nepodporovanú verziu.

**Step 2: Run tests to verify they fail**

Run: `bun test lawoss/okf/read-dashboard-snapshot.test.ts`

Expected: FAIL, reader ešte neexistuje.

**Step 3: Implement minimal reader**

Reader načíta kanonické OKF záznamy bez zápisu, zachová čitateľné dáta pri jednej chybe a ku každej právne významnej položke pripojí provenance.

**Step 4: Verify read-only behavior**

Test uloží hash fixture tree pred čítaním a po čítaní. Hash musí zostať rovnaký.

**Step 5: Run tests**

Run: `bun test lawoss/okf/read-dashboard-snapshot.test.ts`

Expected: PASS.

**Step 6: Commit**

```bash
git add lawoss/okf/read-dashboard-snapshot.ts lawoss/okf/read-dashboard-snapshot.test.ts lawoss/okf/__fixtures__/alfa-stav
git commit -m "feat: vytvoriť read-only OKF dashboard snapshot"
```

## Task 3: Zaviesť osobné preferencie bez faktov spisu

**Files:**

- Create: `apps/app/src/lawoss/domains/prehlad/dashboard-preferences.ts`
- Create: `apps/app/tests/lawoss-dashboard-preferences.test.ts`

**Step 1: Write the failing tests**

Overiť default, uloženie presetov podľa scope, migráciu neznámej verzie, reset a odmietnutie neznámeho widgetu. Test musí potvrdiť, že serializovaný store neobsahuje snapshot ani právne entity.

**Step 2: Run tests to verify they fail**

Run: `cd apps/app && bun test tests/lawoss-dashboard-preferences.test.ts`

Expected: FAIL.

**Step 3: Implement the versioned adapter**

Použiť úzky storage interface s browser implementáciou nad `localStorage` a kľúčom `lawoss.dashboard.preferences.v1`. Uložiť iba `presetId`, widget IDs, poradie, šírky a scope defaults.

**Step 4: Run tests**

Run: `cd apps/app && bun test tests/lawoss-dashboard-preferences.test.ts`

Expected: PASS.

**Step 5: Commit**

```bash
git add apps/app/src/lawoss/domains/prehlad/dashboard-preferences.ts apps/app/tests/lawoss-dashboard-preferences.test.ts
git commit -m "feat: uložiť osobné preferencie dashboardu"
```

## Task 4: Vytvoriť spoločný widget registry

**Files:**

- Create: `apps/app/src/lawoss/domains/prehlad/dashboard-widget-registry.tsx`
- Create: `apps/app/src/lawoss/domains/prehlad/widgets/`
- Create: `apps/app/tests/lawoss-dashboard-widget-registry.test.tsx`

**Step 1: Write the failing tests**

Overiť stabilné widget IDs, povolené scope, required snapshot slices a fallback pri chýbajúcom alebo neznámom widgete.

**Step 2: Run tests to verify they fail**

Run: `cd apps/app && bun test tests/lawoss-dashboard-widget-registry.test.tsx`

Expected: FAIL.

**Step 3: Implement minimal widgets**

Implementovať `next-decision`, `matter-process`, `deadlines`, `calendar`, `record-register`, `source-health`, `activity` a `workload`. Každý dostane iba readonly slice snapshotu.

**Step 4: Add provenance interaction**

Každá právne významná hodnota musí otvoriť spoločný inspector komponent, nie vlastný ad hoc modal.

**Step 5: Run tests**

Run: `cd apps/app && bun test tests/lawoss-dashboard-widget-registry.test.tsx`

Expected: PASS.

**Step 6: Commit**

```bash
git add apps/app/src/lawoss/domains/prehlad/dashboard-widget-registry.tsx apps/app/src/lawoss/domains/prehlad/widgets apps/app/tests/lawoss-dashboard-widget-registry.test.tsx
git commit -m "feat: pridať register dashboard widgetov"
```

## Task 5: Implementovať Process & Evidence diagram

**Files:**

- Create: `apps/app/src/lawoss/domains/prehlad/widgets/process-evidence-map.tsx`
- Create: `apps/app/tests/lawoss-process-evidence-map.test.tsx`

**Step 1: Write the failing accessibility and interaction tests**

Overiť štyri swimlanes, najviac osem hlavných uzlov, jedného vlastníka na uzol, klávesový výber, prístupný názov a otvorenie provenance inspectora.

**Step 2: Run tests to verify they fail**

Run: `cd apps/app && bun test tests/lawoss-process-evidence-map.test.tsx`

Expected: FAIL.

**Step 3: Implement the React SVG component**

Použiť existujúce LAWOSS tokeny, dostupné focus stavy a dáta z `matter-process` slice. SVG nesmie obsahovať natvrdo vložený obsah konkrétneho prípadu.

**Step 4: Verify diagram geometry**

Renderovať SVG fixture a spustiť diagram-design geometry checker. Očakávaný výsledok je 0 nálezov.

**Step 5: Run tests**

Run: `cd apps/app && bun test tests/lawoss-process-evidence-map.test.tsx`

Expected: PASS.

**Step 6: Commit**

```bash
git add apps/app/src/lawoss/domains/prehlad/widgets/process-evidence-map.tsx apps/app/tests/lawoss-process-evidence-map.test.tsx
git commit -m "feat: pridať procesnú mapu spisu"
```

## Task 6: Implementovať šesť preset definícií

**Files:**

- Create: `apps/app/src/lawoss/domains/prehlad/dashboard-presets.ts`
- Create: `apps/app/tests/lawoss-dashboard-presets.test.ts`

**Step 1: Write the failing tests**

Pre každý preset overiť rovnaký vstupný snapshot, unikátne poradie a šírky, povinný `next-decision` alebo bezpečný ekvivalent a deterministický fallback.

**Step 2: Run tests to verify they fail**

Run: `cd apps/app && bun test tests/lawoss-dashboard-presets.test.ts`

Expected: FAIL.

**Step 3: Implement preset data**

Presety nesmú byť šesť samostatných stránok. Sú to immutable definície kompozície nad jedným widget registrom.

**Step 4: Run tests**

Run: `cd apps/app && bun test tests/lawoss-dashboard-presets.test.ts`

Expected: PASS.

**Step 5: Commit**

```bash
git add apps/app/src/lawoss/domains/prehlad/dashboard-presets.ts apps/app/tests/lawoss-dashboard-presets.test.ts
git commit -m "feat: pridať šesť osobných dashboard presetov"
```

## Task 7: Integrovať dashboard do existujúcej route `/prehlad`

**Files:**

- Modify: `apps/app/src/lawoss/domains/prehlad/prehlad-page.tsx`
- Create: `apps/app/src/lawoss/domains/prehlad/dashboard-page.tsx`
- Create: `apps/app/src/lawoss/domains/prehlad/dashboard-grid.tsx`
- Create: `apps/app/src/lawoss/domains/prehlad/provenance-inspector.tsx`
- Create: `apps/app/tests/lawoss-prehlad-dashboard.test.tsx`

**Step 1: Write the failing integration tests**

Overiť načítanie snapshotu, scope breadcrumb, výber presetu, inspector, diagnostické stavy a reset bez mutácie OKF fixture.

**Step 2: Run tests to verify they fail**

Run: `cd apps/app && bun test tests/lawoss-prehlad-dashboard.test.tsx`

Expected: FAIL.

**Step 3: Replace the current fictional mockup**

`PrehladPage` zostane route entry a použije `DashboardPage`. Nepridávať druhú route ani webový kontajner.

**Step 4: Run integration tests**

Run: `cd apps/app && bun test tests/lawoss-prehlad-dashboard.test.tsx`

Expected: PASS.

**Step 5: Commit**

```bash
git add apps/app/src/lawoss/domains/prehlad apps/app/tests/lawoss-prehlad-dashboard.test.tsx
git commit -m "feat: integrovať OKF dashboard do prehľadu"
```

## Task 8: Vizuálna a produktová verifikácia

**Files:**

- Modify only if required by verified defects from this task.

**Step 1: Run focused tests**

Run: `cd apps/app && bun test tests/lawoss-dashboard-*.test.* tests/lawoss-process-evidence-map.test.tsx tests/lawoss-prehlad-dashboard.test.tsx`

Expected: PASS.

**Step 2: Run product gates**

Run: `cd apps/app && pnpm typecheck && pnpm test && pnpm build`

Expected: PASS.

**Step 3: Visual verification**

Otvoriť Electron alebo web development build a overiť 1440 px, 1024 px a 768 px pre všetkých šesť presetov. Overiť keyboard-only flow, focus, reduced motion, offline, parse error a future-version read-only stav.

**Step 4: Security and data-boundary verification**

Porovnať OKF fixture hash pred a po všetkých UI operáciách. Skontrolovať local storage a potvrdiť, že obsahuje iba povolenú osobnú konfiguráciu.

**Step 5: Update product documentation**

Aktualizovať produktový `PATCHES.md` iba ak sa zmení upstream-owned súbor. Do produktového PR pridať odkaz na spec 0015 a výsledky všetkých gateov.

**Step 6: Final commit**

```bash
git add <iba overené súbory tejto zmeny>
git commit -m "docs: zdokumentovať OKF dashboard integráciu"
```
