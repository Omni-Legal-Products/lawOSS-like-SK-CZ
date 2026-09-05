# LAWOSS Marketplace Capability Catalog Design

**Status:** approved for implementation by the user on 2026-09-05.

## Goal

Turn the existing LAWOSS Marketplace mockup into a data-driven, local-first
capability catalog that makes provenance, dependencies, jurisdiction, risk and
human approval requirements visible before any installation can happen.

This is the first vertical slice of the broader LAWOSS marketplace proposal.
It deliberately stops at catalog discovery and an installation preview; it does
not install code, connect OAuth providers, send email, write to external
systems, or scan documents.

## User experience

The Marketplace screen presents curated entries grouped as MCP, skill, CLI and
workflow bundle. Users can filter by kind and channel (`stable`, `lab`,
`community`, `private`), select an entry, and inspect a detail panel containing:

- what the capability does;
- jurisdiction and source repository/ref;
- required dependencies;
- local/network/external-action capabilities;
- verification status and last verification date;
- the required human gate;
- a deterministic installation preview listing the intended scope and pinned
  source without claiming that installation has happened.

The UI must work offline from a bundled catalog. The remote registry is a later
slice; the data contract introduced here is intentionally compatible with a
GitHub-hosted `marketplace.json`.

## Data contract

`MarketplaceEntry` is the stable app-facing shape:

```ts
type MarketplaceKind = "mcp" | "skill" | "cli" | "workflow";
type MarketplaceChannel = "stable" | "lab" | "community" | "private";
type MarketplaceRisk = "read-only" | "local-write" | "network" | "external-action";

type MarketplaceEntry = {
  id: string;
  name: string;
  description: string;
  kind: MarketplaceKind;
  channel: MarketplaceChannel;
  jurisdictions: string[];
  source: { repository: string; ref: string };
  dependencies: string[];
  capabilities: MarketplaceRisk[];
  verification: { status: "verified" | "review" | "unverified"; checkedAt: string };
  humanGate: string;
  install: { scope: "workspace" | "global"; action: "preview-only" };
};
```

The bundled catalog must contain no credentials, client data, opaque network
URLs, or claims that an unverified community item is safe. IDs are unique and
dates use ISO `YYYY-MM-DD` strings.

## Safety boundaries

- The model cannot install or update catalog entries.
- No item is auto-updated.
- The screen never labels a capability as connected merely because it appears
  in the catalog.
- `external-action` entries remain visibly high-risk and state their human
  gate; no such action is executable in this slice.
- Stable and lab packages remain separate; experimental content is never
  silently promoted to stable.
- Existing LAWOSS connector and plugin settings remain unchanged.

## Files and interfaces

- `apps/app/src/lawoss/domains/marketplace/catalog.ts` owns the types, bundled
  entries, filtering and installation-preview helpers.
- `apps/app/src/lawoss/domains/marketplace/marketplace-page.tsx` renders the
  catalog and selected-entry preview using the existing LAWOSS shell.
- `apps/app/src/lawoss/shell/lawoss.css` adds only the responsive styles needed
  for the catalog controls and detail panel.
- `apps/app/tests/lawoss-marketplace.test.ts` covers the pure catalog behavior.
- `docs/marketplace.md` documents the current contract and the boundary to the
  future GitHub registry.

## Acceptance criteria

1. The catalog is typed, deterministic and contains unique IDs.
2. Filters return stable results without mutating the source catalog.
3. An entry's detail/preview exposes source, dependencies, capabilities,
   verification and human gate.
4. The page no longer renders a hard-coded row list or an install button that
   implies installation has occurred.
5. The page is usable at narrow widths and preserves LAWOSS's existing visual
   language.
6. Existing app tests remain green; the new catalog tests pass.
7. The implementation branch can be opened as a PR, which triggers the
   existing LAWOSS GitHub-to-Telegram PR notification workflow.

## Explicit non-goals

- GitHub API or raw-registry fetching;
- plugin installation, uninstall or rollback execution;
- OAuth/Auth Broker work for Google Workspace, Exchange or ZaKo;
- Autogram/VisionKit document detection;
- marketplace ratings, telemetry or autonomous external actions;
- changes to `.github/workflows/telegram-notify.yml`.
