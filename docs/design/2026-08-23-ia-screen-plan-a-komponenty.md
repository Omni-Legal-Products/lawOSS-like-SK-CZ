# IA, pohľady a stavebné prvky — LegalWork + LAWOSS vrstva

- **Zostavil:** Marián Čuprík (MČ) s AI asistenciou · 2026-08-23 · **v2** (v1 navrhovala 10 nových obrazoviek a novú IA — zamietnuté MČ: *„nejdeme prekopávať základy, sme advokáti; chat + dashboard + nastavenia, opencode vzadu, 4 tentpoles“*)
- **Stav:** 📝 návrh na odklep
- **Nadväzuje na:** [audit](2026-08-23-audit-sucasnej-appky.md) · [dizajnový jazyk v2](2026-08-23-dizajnovy-jazyk-lawoss.md) · [spec 0011 (PR #55)](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/55) · [spec 0002 OKF](../../specs/0002-okf-operacny-system-praxe.md) · [spec 0005 lehoty](../../specs/0005-lehoty-timeline.md) · [spec 0009 reconcile](../../specs/0009-reconcile-ucenie-z-uprav.md) · [ADR 0007](../../decisions/0007-agent-first-architektura.md)

---

## 1 · Princíp: LegalWork ostáva, LAWOSS je vrstva

| Vrstva | Čo | Kto to vlastní |
|---|---|---|
| **Povrch** (LegalWork) | sidebar s priečinkami a sessions · chat so composerom · side panel (súbory, artifacts, **DOCX editor s priamou editáciou a sledovanými zmenami**, browser) · terminál · voice · settings | upstream; my iba **skin** (tokeny, písmo, záložky) |
| **Motor** (opencode) | agent, subagenti, tool calling, skills, prompty, MCP | upstream pin + naše skills/prompty/MCP konfigy v `lawoss/**` (🟢) |
| **LAWOSS vrstva** | 4 tentpoles ako *pohľady nad dátami na disku* (OKF markdown) + admin konektorov/marketplace | my, nové súbory |

Každý náš pohľad je **derivát stavu na disku** (`_STATUS.md`, `spis.md`, `MEMORY.md`, `lehoty.md`, opencode config) — ADR 0007 pravidlo 1 a 2: agent to vie bez GUI, GUI to len ukazuje a dáva advokátovi podpísať.

## 2 · Navigácia = upstream sidebar so záložkami

| Záložka | Čo je pod ňou | Pôvod |
|---|---|---|
| Prehľad | domovská: obal praxe, register „Čaká na advokáta“, pás lehôt, posledná správa agenta, composer | **nové** (`/prehlad`) |
| Spisy `24` | upstream zoznam priečinkov (workspaces) = OKF spisy; detail spisu = náš pohľad | upstream priečinky + nový detail (`/spis/:id`) |
| Lehoty `7` | register lehôt zo všetkých spisov + brána | **nové** (`/lehoty`, `/lehoty/:id`) |
| Dokumenty `128` | upstream workspace files panel ako stránka + OKF triedenie | upstream panel, reskin |
| Asistent `3` | upstream sessions (chat) — nezmenené | upstream (`/session/*`) |
| Konektory `8` | náš admin nad `connections/store` + lokálne nástroje | **nové** (`/konektory`) |
| Marketplace | registry: MCP · skills · pluginy, pin, inštalácia | **nové** (`/marketplace`) |
| Nastavenia | upstream settings + tab `lawoss` (spec 0011 A) | upstream + 1 tab |

Záložky nahrádzajú horný blok upstream sidebaru (New Task / Learning / Workflows / Integrations / Recorder) — tie položky sa presúvajú: Learning → Reconcile (v spise), Workflows → Nastavenia, Integrations → Konektory, Recorder → Konektory › Whisper. Priečinky (60 % sidebaru) ostávajú ako sú, len v našom skine.

## 3 · Päť pohľadov × štyri tentpoles

| Pohľad | Tentpole | Diagram (aby to nebol wall of text) | Dáta | Hi-fi |
|---|---|---|---|---|
| **Prehľad** | všetky | pás lehôt 14 dní | agregácia `_STATUS.md` + `lehoty.md` + health konektorov | ✅ |
| **Spis + OKF Brain** | 1 · OKF Brain | timeline spisu s fázami konania; vrstvy pamäte L1/L2/L3 | `spis.md`, `_STATUS.md`, `MEMORY.md`, `lehoty.md`; dokumenty = OKF priečinok; composer = session v spise | ✅ |
| **Kontrola lehoty** (brána) | 2 · lehoty + dokumenty | náhľad dokumentu s locatorom vedľa citácie predpisu; pečať | spec 0005 model (`source_locator`, `calculation_trace`, `uncertainty`, stavy) | ✅ |
| **Reconcile** | 1 · OKF Brain (self-healing) | diff v1 agent / v2 advokát; panel „čo si agent chce zapamätať“ s výberom vrstvy | spec 0009: diff z verzií dokumentu v OKF, návrhy do `MEMORY.md` (L1) / `_STATUS.md` (L2), žiadny autonómny zápis | ✅ |
| **Konektory + Marketplace** | 3 · MCP, 4 · marketplace | schéma LAWOSS → opencode → konektory s trust labelom | `connections/store` (MCP remote/local), lokálne nástroje (Autogram, OCR, Whisper, OKF skripty), `lawoss-registry` manifesty (spec 0011 B) | ✅ |

Dokument s priamou editáciou = upstream artifact DOCX editor (`artifact-docx-editor.tsx`) v side paneli, reskin + `suggesting` režim (nápad #29) + meno advokáta (#31). Reconcile sa spúšťa **pri uložení** v tomto editore.

Čo sa **nestavia** (zo zamietnutej v1): samostatné obrazovky Rešerš, Podpisovanie, Zaručená konverzia, Automatizácia e-mailov, Lokálne nástroje. Rešerš a subjekty = skills v chate (výsledky ako registre v artifact preview); podpisovanie = Autogram v Konektoroch + akcia v dokumente; konverzia mimo V1/V2 (spec 0010); e-maily V2.

## 4 · Routing a napojovacie body v kóde

```
shell/app-root.tsx              🟡 +1: <Route path="/*" element={<LawossRoutes/>}/> pred fallback; redirect "/" → /prehlad
session/sidebar/app-sidebar.tsx 🟡 +1: horný blok → <LawossTabs/> (alebo upstream PR „sidebar slot“)
app/types.ts + settings-page    🟡 +1: tab "lawoss"
i18n/index.ts                   🟡: registrácia sk/cs
artifacts/artifact-docx-editor  🟡 +2: mode prop (suggesting), author z nastavení (#29, #31), onSave → reconcile hook
lawoss/shell/routes.tsx, tabs.tsx, layout.tsx                 🟢
lawoss/domains/prehlad, spis, lehoty, reconcile, konektory, marketplace   🟢
lawoss/okf/read.ts  (parser _STATUS.md / spis.md / lehoty.md, read-only)  🟢
lawoss/hub/{health,tools,registry}.ts                         🟢
lawoss/ui/{tabs,obal,register,gate,seal,timeline,deadline-strip,brain,diff,schema,composer-context}.tsx  🟢
lawoss/theme/{lawoss-tokens.css,fonts.css}                    🟢
```

Zápisy do OKF robí **vždy agent cez skill** (`novy-spis`, `lehoty`, `reconcile`), GUI volá skill a zobrazuje výsledok — nikdy nezapisuje markdown samo. To drží logiku prenosnú (ADR 0004 p. 5) a jednu cestu pre audit.

## 5 · API náčrty stavebných prvkov (`lawoss/ui`, strict TS)

```ts
type Tab = { id: string; label: string; count?: number; to: string; group: 'prax' | 'agent' | 'system' };

type ObalField = { label: string; value: ReactNode; note?: string; mono?: boolean; tone?: 'warn' };

type RegisterColumn = 'no' | 'date' | 'title' | 'ref' | 'status' | 'action';
type RegisterRow = { id: string; no?: string; date?: { text: string; tone?: 'urg' | 'soon' }; title: string; sub?: string; ref?: string; status?: { text: string; tone?: 'ok' | 'warn' | 'ai' | 'off' }; action?: { label: string; to: string } };
type RegisterProps = { title: string; meta?: ReactNode; columns: RegisterColumn[]; rows: RegisterRow[]; widths?: string };

type Provenance = { source: string; retrievedAt: string; version?: string; locator?: string };
type GateProps<T> = { source: ReactNode /* citácia + docview */; proposal: ReactNode /* kolónky + trace */; confidence: 'low'|'medium'|'high'; uncertainty?: string[]; consequence: string; onDecide: (a: 'confirm'|'edit'|'reject'|'defer', p?: Partial<T>) => Promise<void> };
type SealProps = { ring: string /* „POTVRDIL ADVOKÁT · 7. 6. 2024 · AUDIT 0x…“ */; anchor: HTMLElement | null };

type TimelineEvent = { at: string; title: string; sub?: string; kind: 'done' | 'candidate' | 'ordered' | 'planned' };
type Phase = { label: string; from: string; to: string; active?: boolean };
type TimelineProps = { events: TimelineEvent[]; phases: Phase[]; today: string };
type DeadlineStripProps = { days: 14; items: { at: string; title: string; sub: string; tone: 'urg'|'soon'|'ok'|'candidate' }[] };

type BrainProps = { status: string; facts: { text: string; ref: string }[]; tactics?: { text: string; ref: string }[]; next: string[]; layers: { l2Pending: number }; onReview: () => void };

type DiffProps = { v1: string; v2: string; meta: { doc: string; v1At: string; v2At: string } };
type Learning = { rule: string; layer: 'L1' | 'L2'; evidence: string; suggestedLayer: 'L1' | 'L2' };

type Trust = 'local' | 'own' | 'third';
type ConnectorRow = { name: string; sub: string; trust: Trust; kind: 'remote' | 'local' | 'tool'; tools?: number; latencyMs?: number; readOnly: boolean; status: 'connected' | 'ready' | 'missing' | 'off' };
type RegistryItem = { id: string; name: string; sub: string; type: 'mcp' | 'skill' | 'plugin'; source: string; pin: string; install: ('remote' | 'local')[]; requires?: string[]; verified: boolean };
```

## 6 · Nastavenia › tab LAWOSS

Advokát (meno, titul, jurisdikcia) · OKF (koreň, nomenklatúra, default moduly) · Agent (default autonómia, výstupný formát) · Vzhľad (téma — default tmavá, jazyk sk/cs/en) · odkazy Konektory / Marketplace. Podľa spec 0011 A, bez zmeny.

---

<sub>v2 · MČ s AI asistenciou · 2026-08-23. Napojovacie body overené v kóde forku `dev` @ c5e177a.</sub>
