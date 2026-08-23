# IA, navigácia, screen plán a komponentový inventár

- **Zostavil:** Marián Čuprík (MČ) s AI asistenciou · 2026-08-23
- **Stav:** 📝 návrh na odklep
- **Nadväzuje na:** [audit](2026-08-23-audit-sucasnej-appky.md) · [dizajnový jazyk](2026-08-23-dizajnovy-jazyk-lawoss.md) · [spec 0011 (PR #55)](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/55) · [spec 0002 OKF](../../specs/0002-okf-operacny-system-praxe.md) · [spec 0005 lehoty](../../specs/0005-lehoty-timeline.md) · [spec 0004 MCP](../../specs/0004-mcp-sk-konektory.md) · [spec 0007 podpisovanie](../../specs/0007-podpisovanie-a-zarucena-konverzia.md)

---

## 1 · Princíp IA: spis je jednotka, agent je v spise

Dnes: *session* (konverzácia) je jednotka, priečinky sú kontext. Nová IA: **spis** (OKF priečinok) je jednotka; session, dokumenty, lehoty, timeline a Matter Brain sú jeho *pohľady*. Agentné plochy (chat, terminál, voice, artifacts) **neodstraňujeme** — stávajú sa tabom *Asistent* vnútri spisu a samostatnou položkou *AI asistent* pre prácu mimo spisu.

Toto zároveň plní ADR 0007 pravidlo 2: každá obrazovka je *pohľad na stav na disku* (`_STATUS.md`, `spis.md`, `lehoty.md`), nie vlastný stav v UI. Agent ju vie „vykonať" bez GUI.

## 2 · Ľavá navigácia

| Skupina | Položka | Routa | Zdroj dát | Fáza |
|---|---|---|---|---|
| **Prax** | Prehľad | `/prehlad` (nová domovská) | agregácia `_STATUS.md` všetkých spisov v OKF koreni | C |
| | Spisy `24` | `/spisy`, `/spis/:id/*` | OKF priečinky (workspace = OKF koreň) | C |
| | Lehoty `7` | `/lehoty`, `/lehoty/:id` (brána) | `lehoty.md` JSON front-matter (spec 0011 A) | C |
| | Dokumenty | `/dokumenty` | workspace files panel (reuse) + OKF triedenie | C |
| | Komunikácia | `/komunikacia` | mockup 09 — **V2**, placeholder „pripravujeme" | D+ |
| **Overovanie** | Rešerš | `/resers` (právny výskum · subjekty) | MCP judikatúra/Slov-Lex, registre | C |
| | Podpisovanie | `/podpisovanie` | Autogram detekcia (spec 0007) | D |
| **Systém** | Konektory a nástroje | `/konektory` | `connections/store` + `lawoss/hub` | C |
| | AI asistent | `/session/*` (existujúce) | bez zmeny | B |
| | Nastavenia | `/settings/*` + tab `lawoss` | spec 0011 | B |

Pätička: avatar + meno advokáta (z nastavenia, nápad #31) + jurisdikcia. Sidebar má **gold rail** pri aktívnej položke, počty iba pri Spisy/Lehoty (ostatné counts = šum).

**Technicky:** `lawoss/shell/lawoss-sidebar.tsx` (🟢) nahrádza upstream `AppSidebar` jedným switchom v `session-page.tsx` (🟡 1 riadok, alebo `ShellConfig` flag ak upstream prijme PR). Routy sa registrujú v `app-root.tsx` jedným `<Route path="/*" element={<LawossRoutes/>}>` (🟡 1 riadok) — vnútri `lawoss/shell/routes.tsx` (🟢) sú všetky naše.

## 3 · Screen-by-screen mapa (10 mockupov)

Legenda: **reuse** = existujúci komponent/flow bez zmeny · **reskin** = existujúce, iba tokeny/labely · **nové** = nový súbor v 🟢 zóne. Hi-fi = v prototype [`hifi/lawoss-hifi.html`](hifi/lawoss-hifi.html).

| # | Obrazovka | Reuse | Reskin | Nové | Hi-fi | Dáta / špecifikácia |
|---|---|---|---|---|---|---|
| 01 | **Prehľad praxe** | Card, Badge, Button | — | PageHeader, StatCard×3, „Čaká na rozhodnutie" (card-gold), DeadlineList, SourceStatus | ✅ | agregácia `_STATUS.md` + `lehoty.md`; konektory health |
| 02 | **Spis + Matter Brain** | workspace-files-panel (dokumenty), session (tab Asistent) | — | PageHeader s mono spisovou značkou, Timeline (skrátená), TaskList, MatterBrainPanel | ✅ | `spis.md` frontmatter, `_STATUS.md`, `MEMORY.md` (L2) |
| 03 | **Kontrola lehoty** | Button, Badge, Kbd | — | **DecisionGate** (CitationBlock + ProposalTable + ConfidenceMeter + 4 akcie + audit veta), SealMoment | ✅ | spec 0005 dátový model: `source_ref/locator/version`, `calculation_trace`, `uncertainty`, stav `needs_review→confirmed` |
| 04 | **Podpisovanie eIDAS** | artifact preview (DOCX/PDF) | — | SignTypePicker (6 kariet: PDF/XML · QES/QTS · SK eID/CZ podpis), AutogramStatus, SealMoment (pero) | wireframe | spec 0007: iba detekcia + odovzdanie Autogramu; PIN nikdy v LAWOSS |
| 05 | **Právny výskum** | SearchInput, Tabs, Card | — | ResultRow (typ · názov · mono ref · **SourceBadge**), ConnectorsSidePanel, „Všetky výsledky sú overené" pätička | wireframe | MCP judikatúra (24 tools), Slov-Lex; každý výsledok má provenance alebo sa nezobrazí ako Overené |
| 06 | **Rešerš subjektov** | SearchInput, Tabs (Klient·Protistrana·Partner·Riziká·KÚV) | — | RegisterCard×6 (stav `bez záznamu / nedoplatok / nenačítané`), FindingsSummary, KuvCard | wireframe | spec 0002 light/medium/hard; **menovec = vždy človek potvrdí** (IR podmienka) → DecisionGate variant |
| 07 | **Timeline spisu** | — | — | Timeline (plná, filter chips: Lehoty·Podania·Pojednávania·Dokumenty·E-maily·Ďalšie kroky), MatterBrain (zúžený), AuditTrail link | wireframe (skrátený v 02) | `lehoty.md` + `_STATUS.md` chronológia; vizuálne odlíšiť *confirmed / candidate / rejected* (spec 0005) |
| 08 | **Zaručená konverzia** | — | — | WizardSteps×4 (Naskenovaný dokument → Osvedčovacia doložka → Overenie → Elektronický výstup), SealMoment | wireframe | spec 0010: **nie V1, nie V2** — obrazovka ako externý proces (odkaz na samostatnú appku MČ); v UI zatiaľ „pripravujeme" + vysvetlenie prečo |
| 09 | **Automatizácia e-mailov** | — | — | FlowDiagram 8 krokov (ilustratívna), IncomingMailCard (sumár·úlohy·lehota·návrh odpovede) → DecisionGate „Odoslať po schválení" | wireframe | V2; ADR 0007 pravidlo 5: **odosielací nástroj agent nemá** — brána odovzdá draft do mail klienta |
| 10 | **Lokálne nástroje** | recorder settings (Whisper modely) | — | ConnectorCard / LocalToolCard grid, segment filter, LocalNote „všetko beží lokálne" | ✅ (zlúčené s 05 do hubu) | `lawoss/hub`: detekcia Autogram/OCR/Whisper/skripty, health, logy |

**Rozhodnutie v návrhu:** mockupy 05 (panel konektorov) a 10 (lokálne nástroje) sú v IA **jedna obrazovka** *Konektory a nástroje* so segmentom (Všetko · Právne zdroje · Registre · Lokálne nástroje · AI modely). Dva hubové ekrány by advokát nerozlíšil.

## 4 · Routing v kóde

```
apps/app/src/react-app/shell/app-root.tsx        🟡 +1 riadok: <Route path="/*" element={<LawossRoutes />} />  (pred fallback "*")
lawoss/shell/routes.tsx                          🟢 všetky /prehlad /spisy /spis/:id/* /lehoty /resers /konektory /podpisovanie
lawoss/shell/lawoss-sidebar.tsx                  🟢 navigácia (t() kľúče lawoss.nav.*)
lawoss/shell/lawoss-layout.tsx                   🟢 sidebar + main (reuse titlebar-drag utilities, platform variants)
lawoss/shell/routes-paths.ts                     🟢 buildery: prehladRoute(), spisRoute(id, tab?), lehotaRoute(id) — rovnaký vzor ako workspace-routes.ts
```

Workspace mapping: **OKF koreň = workspace**. `spis/:id` = relatívna cesta priečinka spisu v OKF koreni (URL-safe slug + hash). Session v spise: `spisRoute(id,'asistent')` renderuje existujúci `SessionRoute` s `workspaceId` = OKF koreň a session filtrom na priečinok spisu (route state, nie global).

## 5 · Komponentový inventár s API náčrtmi (🟢 `lawoss/ui/`)

Všetko strict TS, bez `any`; `cva` varianty; `@/components/ui` primitíva pod kapotou; každý string cez `t('lawoss.*')` v `sk.ts` **aj** `cs.ts`.

```ts
// PageHeader — serif H1 + lead + crumbs + actions
type PageHeaderProps = { title: ReactNode; lead?: ReactNode; crumbs?: Crumb[]; actions?: ReactNode; back?: () => void };

// StatCard — hero číslo
type StatCardProps = { label: string; icon: LucideIcon; value: number | string; delta?: ReactNode; tone?: 'default' | 'urgent'; href?: string };

// SourceBadge — „Overené“; bez provenance sa NEVYKRESLÍ ako overené
type Provenance = { source: string; retrievedAt: string; version?: string; locator?: string; url?: string };
type SourceBadgeProps = { provenance?: Provenance; fallback?: 'ai' | 'none' };

// ConfidenceMeter — slovo + meter, nikdy percento
type Confidence = 'low' | 'medium' | 'high';
type ConfidenceMeterProps = { level: Confidence; reasons?: string[] };

// CitationBlock — § citácia s markerom
type CitationBlockProps = { lawTitle: string; citation: string /* mono */; versionNote?: string; quote: string; highlight?: [number, number]; provenance?: Provenance; onOpenDocument?: () => void };

// DecisionGate — jadro doktríny
type GateAction = 'confirm' | 'edit' | 'reject' | 'defer';
type DecisionGateProps<T> = {
  source: ReactNode;                 // typicky <CitationBlock/>
  proposal: ReactNode;               // typicky <ProposalTable/>
  confidence: Confidence;
  uncertainty?: string[];            // „dátum doručenia z OCR — skontrolujte“
  consequence: string;               // auditná veta: čo sa zapíše a kam
  onDecide: (a: GateAction, payload?: Partial<T>) => Promise<void>;
  shortcuts?: boolean;               // ⏎ / E / Esc
};

// ProposalTable — kľúč/hodnota s hero riadkom a calc trace
type ProposalRow = { key: string; value: ReactNode; mono?: boolean; hero?: boolean; note?: string };
type ProposalTableProps = { rows: ProposalRow[]; calculationTrace?: string };

// SealMoment — potvrdenie s právnym účinkom
type SealMomentProps = { title: string; subtitle?: string; icon?: 'check' | 'pen' | 'doc'; autoCloseMs?: number };

// Timeline
type TimelineEvent = { id: string; at: string; title: string; kind: 'podanie'|'dokument'|'lehota'|'pojednavanie'|'email'|'krok'; state: 'done'|'now'|'future'; status?: 'confirmed'|'candidate'|'rejected'; meta?: string };
type TimelineProps = { events: TimelineEvent[]; progress?: number; compact?: boolean; filters?: TimelineEvent['kind'][] };

// MatterBrainPanel — L2 pamäť veci
type MatterBrainProps = { status: { label: string; tone: 'ok'|'warn' }; facts: { text: string; ref: string }[]; nextSteps: string[]; updatedAt: string; provenanceOk: boolean; onProposeWrite: () => void };

// TaskList
type Task = { id: string; title: string; done: boolean; due?: string; dueTone?: 'soon'|'late' };

// DeadlineRow / DeadlineList — riadok lehoty s tónom podľa blízkosti
type DeadlineRowProps = { title: string; matter: string; dueAt: string; status: 'confirmed'|'candidate'; };

// ConnectorCard / LocalToolCard — hub
type Trust = 'local' | 'own-server' | 'third-party';
type ConnectorCardProps = { name: string; kind: 'mcp' | 'tool' | 'model'; description: string; status: 'connected'|'ready'|'missing'|'error'; trust: Trust; readOnly?: boolean; verified?: boolean; meta?: { label: string; value: string }[]; actions: ReactNode };

// WizardSteps — 4-krokový (konverzia, onboarding)
type WizardStep = { id: string; title: string; hint?: string; state: 'done'|'current'|'todo' };

// EmptyState
type EmptyStateProps = { title: string; hint?: string; action?: { label: string; onClick: () => void } };
```

Rozšírenia existujúcich (value-only / variant add, 🟡 ak v `packages/ui`, inak wrapper v 🟢): `Card tone="gold"`, `Badge tone="verified" | "ai"`, `Button variant="gold"` (= upstream `accent` po remape, netreba nový variant).

## 6 · Nastavenia — tab „LAWOSS“ (spec 0011 A)

Jedna stránka, sekcie: **Advokát** (meno, titul, jurisdikcia SK/CZ) · **Spisy a OKF** (koreňový priečinok, nomenklatúra, default moduly) · **Agent** (default autonómia pre nové spisy, default výstupný formát) · **Vzhľad** (téma dark/light/system, jazyk sk/cs/en) · **Konektory** → odkaz na hub. Tab registrácia = 🟡 1 riadok v `SETTINGS_TAB_VALUES` + settings-page list.

## 7 · Onboarding LAWOSS (nahrádza `/welcome`)

4 kroky vo WizardSteps: *Kto ste* (meno, jurisdikcia) → *Kde máte spisy* (OKF koreň, retrofit ponuka) → *AI model* (lokálny/cloud/auto + politika dát) → *Konektory* (Slov-Lex, Judikatúra, registre — jedným klikom). Posledná obrazovka = Seal moment „Prax pripravená". Reuse: `create-workspace` flow pre výber priečinka; provider selection logiku reuse, iba nový vizuál.

---

<sub>Návrh MČ s AI asistenciou 2026-08-23. Routy a napojovacie body overené v kóde forku 2026-08-23 (`app-root.tsx`, `session-page.tsx`, `types.ts`); pri upstream synce znova overiť.</sub>
