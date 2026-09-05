# LAWOSS Marketplace Capability Catalog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the LAWOSS Marketplace mockup with a typed, local-first capability catalog and safe installation preview.

**Architecture:** Keep the catalog contract and pure operations in one focused module, then render it through the existing LAWOSS Marketplace route. The first slice bundles curated entries locally and exposes a future-compatible source/ref shape; it does not perform network fetches or installation. The UI uses an explicit selected-entry detail panel so the user can inspect risk and human gates before any future installer is added.

**Tech Stack:** React, TypeScript, Bun tests, existing LAWOSS CSS tokens and shell.

**Spec:** `docs/superpowers/specs/2026-09-05-lawoss-marketplace-capability-catalog-design.md`

## Global Constraints

- The model cannot install or update catalog entries.
- No item is auto-updated.
- The screen never labels a capability as connected merely because it appears in the catalog.
- Stable and lab packages remain separate.
- Do not modify OAuth, connector settings, or Telegram workflow behavior.
- Preserve unrelated work in the current branch/worktree.
- Every new pure behavior gets a failing Bun test before implementation.

---

### Task 1: Add the typed catalog model and pure operations

**Files:**
- Create: `apps/app/src/lawoss/domains/marketplace/catalog.ts`
- Test: `apps/app/tests/lawoss-marketplace.test.ts`

**Interfaces:**
- Produces `MarketplaceEntry`, `MarketplaceKind`, `MarketplaceChannel`, `MarketplaceRisk`.
- Produces `MARKETPLACE_CATALOG: readonly MarketplaceEntry[]`.
- Produces `filterMarketplaceEntries(entries, filters): MarketplaceEntry[]`.
- Produces `installationPreview(entry): { scope: string; source: string; capabilities: readonly string[]; humanGate: string; status: "preview-only" }`.

- [ ] **Step 1: Write failing tests for catalog invariants and filtering**

```ts
test("catalog entries have unique IDs and valid ISO verification dates", () => {
  const ids = MARKETPLACE_CATALOG.map((entry) => entry.id);
  expect(new Set(ids).size).toBe(ids.length);
  for (const entry of MARKETPLACE_CATALOG) {
    expect(entry.verification.checkedAt).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  }
});

test("filters combine channel and kind without changing catalog order", () => {
  const result = filterMarketplaceEntries(MARKETPLACE_CATALOG, { channel: "stable", kind: "mcp" });
  expect(result.every((entry) => entry.channel === "stable" && entry.kind === "mcp")).toBe(true);
  expect(result.map((entry) => entry.id)).toEqual(
    MARKETPLACE_CATALOG.filter((entry) => entry.channel === "stable" && entry.kind === "mcp").map((entry) => entry.id),
  );
});

test("installation preview is explicit and never reports installation", () => {
  const preview = installationPreview(MARKETPLACE_CATALOG[0]);
  expect(preview.status).toBe("preview-only");
  expect(preview.source).toContain(MARKETPLACE_CATALOG[0].source.repository);
  expect(preview.humanGate).toBe(MARKETPLACE_CATALOG[0].humanGate);
});
```

- [ ] **Step 2: Run the focused test to verify the expected missing-module failure**

Run: `pnpm --filter @legalwork/app test -- tests/lawoss-marketplace.test.ts`

Expected: FAIL because `catalog.ts` and its exported operations do not exist.

- [ ] **Step 3: Implement the minimal typed catalog**

Add curated entries for Slov-Lex, a legal-research skill, OKF CLI tooling,
DOCX redline, and an explicitly review-only community connector. Include
stable/lab/community channels, SK/CZ/EU jurisdiction values, exact-looking
repository refs as human-readable branch/tag refs, risk capabilities,
verification metadata, dependencies and human gates. Keep the filtering
function pure and return a new array. Keep `installationPreview` descriptive
and set `status` to `preview-only` for every entry.

- [ ] **Step 4: Run the focused test to verify it passes**

Run: `pnpm --filter @legalwork/app test -- tests/lawoss-marketplace.test.ts`

Expected: PASS with all catalog tests green.

- [ ] **Step 5: Commit the pure catalog slice**

```bash
git add apps/app/src/lawoss/domains/marketplace/catalog.ts apps/app/tests/lawoss-marketplace.test.ts
git commit -m "feat: pridať model LAWOSS marketplace katalógu"
```

### Task 2: Render filters and the safe detail/preview panel

**Files:**
- Modify: `apps/app/src/lawoss/domains/marketplace/marketplace-page.tsx`
- Modify: `apps/app/src/lawoss/shell/lawoss.css`
- Test: `apps/app/tests/lawoss-marketplace.test.ts`

**Interfaces:**
- Consumes the catalog types, `MARKETPLACE_CATALOG`, `filterMarketplaceEntries` and `installationPreview` from Task 1.
- Produces a Marketplace route with filter controls, selected-entry detail, and preview-only wording.

- [ ] **Step 1: Extend the failing tests with source-level page contract checks**

```ts
test("marketplace source renders catalog data and preview language", async () => {
  const source = await Bun.file(new URL("../src/lawoss/domains/marketplace/marketplace-page.tsx", import.meta.url)).text();
  expect(source).toContain("MARKETPLACE_CATALOG");
  expect(source).toContain("installationPreview");
  expect(source).toContain("preview-only");
  expect(source).not.toContain("const REGISTRY: RegistryRow[]");
});
```

- [ ] **Step 2: Run the test to verify the page still has the old mockup contract**

Run: `pnpm --filter @legalwork/app test -- tests/lawoss-marketplace.test.ts`

Expected: FAIL because the current page uses `REGISTRY` and has no catalog/detail preview.

- [ ] **Step 3: Replace the hard-coded row rendering**

Use local React state for `kind`, `channel` and selected entry ID. Render a
compact filter row, the filtered catalog rows, and a selected-entry detail
section below the list. Show source/ref, jurisdiction, dependencies, risk
capabilities, verification status/date, human gate and the installation scope.
Use a button labelled `Zobraziť plán` or `Skryť plán`; the plan must say
`Iba náhľad — nič sa neinštaluje`. Remove the old `Inštalovať` button and the
fictional `lawoss-registry · pin` claim from the current mockup.

- [ ] **Step 4: Add responsive styles using existing LAWOSS tokens**

Add styles for filters, selected state, detail columns and preview rows. Keep
the existing register visual language, avoid nested card grids, and make the
detail section stack below the list under 900px. Ensure buttons have visible
focus styles and disabled/empty states are readable.

- [ ] **Step 5: Run focused tests and typecheck the app**

Run: `pnpm --filter @legalwork/app test -- tests/lawoss-marketplace.test.ts`

Expected: PASS.

Run: `pnpm --filter @legalwork/app typecheck`

Expected: PASS with no TypeScript errors.

- [ ] **Step 6: Commit the Marketplace UI slice**

```bash
git add apps/app/src/lawoss/domains/marketplace/marketplace-page.tsx apps/app/src/lawoss/shell/lawoss.css apps/app/tests/lawoss-marketplace.test.ts
git commit -m "feat: zobraziť bezpečný LAWOSS marketplace preview"
```

### Task 3: Document the GitHub registry boundary

**Files:**
- Create: `docs/marketplace.md`

**Interfaces:**
- Documents the app-facing catalog fields and future GitHub-hosted registry contract.

- [ ] **Step 1: Write the documentation**

Document the distinction between skill, MCP, CLI and workflow bundle; the
stable/lab/community/private channels; the required provenance, dependency,
risk and human-gate metadata; the current bundled/offline behavior; and the
future flow `GitHub manifest → validation → pinned catalog → install preview →
explicit installer`. State that OAuth, external writes, code execution and
auto-update require separate approved designs.

- [ ] **Step 2: Run a documentation contract check**

Run: `rg -n "stable|lab|community|private|human|OAuth|auto-update|preview" docs/marketplace.md`

Expected: every required boundary is present.

- [ ] **Step 3: Commit the documentation**

```bash
git add docs/marketplace.md
git commit -m "docs: popísať hranice LAWOSS marketplace"
```

### Task 4: Full verification and GitHub delivery

**Files:**
- No source changes expected.

- [ ] **Step 1: Run the focused and full app tests**

Run: `pnpm --filter @legalwork/app test -- tests/lawoss-marketplace.test.ts`

Expected: PASS.

Run: `pnpm --filter @legalwork/app test`

Expected: all existing and new app tests pass.

- [ ] **Step 2: Run app typecheck and build**

Run: `pnpm --filter @legalwork/app typecheck`

Expected: PASS.

Run: `pnpm --filter @legalwork/app build`

Expected: PASS.

- [ ] **Step 3: Inspect the final diff**

Run: `git status --short && git diff --check && git diff --stat HEAD~3..HEAD`

Expected: only the marketplace catalog, UI/CSS, tests and documentation are
present; no credentials, client data, generated dependency directories or
Telegram secrets are included.

- [ ] **Step 4: Commit any final corrections and push the feature branch**

Push only `feat/marketplace-capability-catalog` to `origin`. Do not push to
`dev`. Opening the PR will use the existing `.github/workflows/telegram-notify.yml`
and notify the `LAWOSS APP GH` Telegram topic without adding routine push
notifications.
