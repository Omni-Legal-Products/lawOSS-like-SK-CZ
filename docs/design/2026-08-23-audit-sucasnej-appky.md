# Audit súčasnej appky (fork LAWOSS @ `dev` c5e177a) — baseline pre redesign

- **Zostavil:** Marián Čuprík (MČ) s AI asistenciou · 2026-08-23
- **Stav:** 📄 pracovný podklad · **nie rozhodnutie** — patrí do PR `design/redesign-plan`
- **Metóda:** čítanie kódu forku `Omni-Legal-Products/lawoss` (`dev` @ `c5e177a`, sync s upstreamom `v0.1.13` + #88), grep, `git log`; web build (`pnpm --filter @legalwork/app dev:web`) spustený 2026-08-23 pre baseline uvítacej obrazovky. Každý nález má značku **overené** / **neoverené**.
- **Nadväzuje na:** podklad „redesign prompt 2026-08-23“ *(lokálne u MČ, nie v repe)* · [spec 0011 UI vrstva a konektory (PR #55)](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/55) · [ADR 0004](../../decisions/0004-ako-rozsirit-legalwork.md) *(tri zóny)* · [brand concept](../brand-concept.md)

> [!IMPORTANT]
> Čast B podkladu z 23. 8. bola v troch bodoch **nepresná** — opravené nižšie (§1.3, §2.1, §3.2). Audit ju nahrádza ako technický štartovací bod.

---

## 1 · Kde sme — zhrnutie v 10 riadkoch

| Zistenie | Stav | Dôsledok pre redesign |
|---|---|---|
| Appka je **agent/chat-centrická**: reálne existujú iba 2 route komponenty (`session-route.tsx` 86 KB, `settings-route.tsx` 109 KB) + `welcome` | overené `shell/app-root.tsx` | nová IA (Prehľad · Spisy · Lehoty…) = **nové routy + nové súbory**, nie prepis session |
| Ľavá navigácia **nie je v `shell/`** ale v `domains/session/sidebar/app-sidebar.tsx` (1 683 riadkov) | overené | nová navigácia = vlastný `lawoss/shell/sidebar` + jedno prepnutie v session-page (🟡) |
| Labely navigácie („New Task", „Learning", „Workflows", „Integrations", „Folders") sú **hardcoded EN**, nie `t()` | overené | lokalizácia navigácie si vyžiada 🟡 zásah alebo náš sidebar |
| **Predvolená téma je light** a Appearance tab je skrytý (komentár v kóde); dark sa zapína len cez uložený `legalwork.react.settings.theme-mode` | overené `app/theme.ts` | Fáza A musí **zapnúť dark ako default** (1 riadok, 🟡) — inak náš navy jazyk nikto neuvidí |
| `packages/ui/styles/theme.css` sa **v appke neimportuje** — `index.css` (663 r.) si robí vlastné shadcn mapovanie z `--lw-*` | overené grep | override vrstva musí ísť **za `tokens.css` v `index.css`**, `theme.css` ignorovať |
| Appka **nepoužíva `@legalwork/ui`** pre shell (sidebar, settings, modaly idú cez `@/components/ui/*` shadcn + Base UI) | overené | nové komponenty staviame na `@/components/ui` vzoroch, `@legalwork/ui` len kde už je |
| Hex dlh: **16 z 250 TSX** obsahuje surové hexy (`#05080f` 15×, `#0a58c2` 9×, `#818cf8` 6×…) | overené grep (podklad B6) | cascade override ich **nechytí** — sú to inline/Tailwind arbitrary values → 🟡 alebo upstream PR |
| `sk.ts` / `cs.ts` **neexistujú**; pridanie = 🟡 zásah do `i18n/index.ts` (union, LANGUAGES, TRANSLATIONS, plural) + `ci-i18n.yml` stráži **kompletnosť** | overené | locale kostra = samostatná úloha s rozhodnutím „kompletne vs. postupne" (paper-cuts P3) |
| `lawoss/**` (zelená zóna) **neexistuje** | overené `ls` | redesign ju zakladá — štruktúra v implementačnom pláne |
| MCP UI žije v `settings/pages/mcp-view.tsx`; `domains/connections` je **stavová vrstva** (store 1 190 r., auth modal 966 r.) | overené | hub z mockupov 05/10 = nová obrazovka nad existujúcim `connections/store.ts`, nie prepis |

---

## 2 · Inventár obrazoviek a flowov

### 2.1 Routy (`shell/app-root.tsx`, react-router JSX, overené)

| Cesta | Komponent | Poznámka |
|---|---|---|
| `/welcome` | `WelcomeRoute` | onboarding 4 kroky (`domains/onboarding/*`) |
| `/session`, `/session/:id`, `/workspace/:ws/session[/:id]` | `SessionRoute` | hlavný chat; obsahuje sidebar, side panel (files/artifacts/browser taby), terminal dock, voice panel |
| `/learnings`, `/workspace/:ws/learnings` | `SessionRoute` | learnings sú mód session, nie samostatná routa |
| `/settings/*`, `/workspace/:ws/settings/*` | `SettingsRoute` | 23 tabov (`SETTINGS_TAB_VALUES` v `app/types.ts:180-206`) vrátane `extensions/mcp` |
| `/`, `*` | redirect → `/session` | |

Path buildery (`shell/workspace-routes.ts`): `workspaceSessionRoute`, `workspaceSettingsRoute`, `globalSettingsRoute`, `legacySessionRoute` — ARCHITECTURE.md **zakazuje** ručné skladanie URL. Workspace/session identita je **route state, nie global state**.

### 2.2 Domény (`react-app/domains/`, overené `ls`)

`benchmark` · `connections` · `onboarding` · `recorder` · `session` · `settings` · `workspace`. *(ARCHITECTURE.md uvádza aj `cloud/` — **neexistuje**, cloud žije v settings `eigenwelt-account-view` + `cloud-*` taby; doc je zastaraná.)*

### 2.3 Baseline screenshot

Web build: **uvítacia obrazovka** — svetlé pozadie, modrý akcent `#0a58c2`, Inter, nadpis „Welcome to LegalWork", pravý panel s modrým noise gradientom (`PaperGrainGradient` z `@paper-design/shaders-react`). Za výber priečinka sa web build bez Electron/legalwork-server nedostane (natívny dialóg) → **in-app screenshoty všetkých obrazoviek = úloha Fázy A** (`pnpm dev` v Electrone, macOS + Windows).

---

## 3 · Token architektúra

### 3.1 Poradie importov v `apps/app/src/app/index.css` (overené)

```
@import "tailwindcss"; @config tailwind.config.ts
@import "../styles/colors.css"              ← 3 039 r. Radix škál (surové --blue-9 …)
@import "@legalwork/ui/styles/tokens.css"   ← --lw-* (:root + .dark,[data-theme="dark"])
@import "tw-animate-css"; @import "shadcn/tailwind.css"
@import @fontsource-variable inter / geist / geist-mono / ibm-plex-sans
:root { --background … --sidebar … --chart-1..5 }   ← shadcn semantika odvodená z --lw-*
legacy --dls-* · glass aliasy · @custom-variant dark · platform variants · titlebar utils
```

**Miesto pre našu override vrstvu:** hneď **za** `@import "@legalwork/ui/styles/tokens.css"` — jeden riadok `@import "../../../lawoss/theme/lawoss-tokens.css";` (🟡, 1 riadok v `PATCHES.md`). Všetko, čo `index.css` odvodzuje z `--lw-*`, sa preplní automaticky.

### 3.2 Prepínanie témy (overené `app/theme.ts`)

- Selektor: `.dark, [data-theme="dark"]`; runtime nastavuje **atribút** `document.documentElement.dataset.theme` + `style.colorScheme`.
- Módy `light | dark | system`; kľúč `legalwork.react.settings.theme-mode`; **default `light`**.
- Electron sync `invokeDesktop("__setNativeTheme")`.
- Komentár v kóde: Appearance tab je **skrytý** → používateľ dnes tému nezmení.

### 3.3 Tokeny, ktoré meníme (value-only)

| Skupina | Dnes (dark) | Cieľ | Poznámka |
|---|---|---|---|
| `--lw-canvas / surface / sunken / sidebar` | `#131316 / #1b1b1f / #202024 / #161619` (neutrálna čierna) | stôl / list / well: `#0A0E14 / #10171F / #0C1219 / #0A0E14` | svet „podací denník na tmavom stole“ (jazyk v2) |
| `--lw-accent*` | modrá `#3b9bff` (dark) / `#0a58c2` (light) | zlatá `#C9A24A` (dark); light sa nenavrhuje, iba technicky funguje (`#8C6A1F`, AA) | zlatá = razidlo, nie dekorácia |
| `--lw-primary` | `#f4f4f5` (dark, invertované!) / `#011627` | ponechať sémantiku (primary = inverzná výplň), **nezamieňať s navy** | upstream používa primary ako „čierne tlačidlo" |
| `--lw-font-sans / mono / serif` | Inter / Geist Mono / IBM Plex Sans (!) | **IBM Plex Sans** (už bundlovaný) / **IBM Plex Mono** (🟢 dep) / Playfair iba pečať (🟢 dep) | Inter zamietnutý MČ („AI slop“); serif token je dnes sans |
| `--lw-focus-ring` | modrá | zlatá | |
| `--lw-success/warning/danger` | Radix | ladené k navy; **warning oranžová `#E08A3C`, nie zlatá** | inak kolízia s akcentom |
| `--chart-1..5` (index.css) | `sky/blue/indigo/violet/purple-9` | navy/gold/mint/oranž/sivá | 🟡 value-only v `index.css` |
| `--lw-shadow-*` | sivé tiene | takmer žiadne, hairline + glow `rgba(201,162,74,.35)` | „hairline, nie tieň" |

Nemenia sa: radius (4–20 px, `--radius: .625rem`), motion (`ease-standard/out/spring`, 120/160/220 ms), spacing.

### 3.4 Hex dlh — kam sa nedostane cascade

16 súborov (zoznam v podklade B6, overené grep). Triedenie podľa dopadu na náš vizuál:

| Súbor | Čo je hardcoded | Vidí to advokát? | Odporúčanie |
|---|---|---|---|
| `onboarding/welcome-page.tsx`, `provider-selection-step`, `template-workflows-step`, `transcription-setup-step` | `#05080f`, `#0a1633`, modrý gradient | **áno, prvé čo vidí** | vlastný `lawoss/onboarding` (🟢) + prepnutie routy `/welcome` (🟡 1 riadok) |
| `session/chat/session-page.tsx`, `surface/session-surface.tsx` | `#0a58c2` a pod. | áno | upstream PR „tokenize hardcoded colors" (univerzálne) |
| `terminal-dock.tsx`, `voice-panel.tsx` | xterm/voice farby | občas | upstream PR / ponechať |
| `design-system/marble-avatar.tsx`, `provider-icon.tsx` | brand farby providerov, avatar palety | áno, drobné | **ponechať** (logá providerov majú byť ich farby) |
| `settings/pages/messaging-view.tsx`, `recorder/premium-upsell-modal.tsx`, `learnings-route.tsx`, `architecture-mismatch-gate.tsx`, `feature-announcement-modal.tsx`, `components/chat/message-list.tsx` | rôzne | zriedka | upstream PR v druhej vlne |

> [!NOTE]
> **Napätie s AGENTS.md:** čistenie 16 súborov = 16 riadkov v `PATCHES.md`, pričom pravidlo hovorí „pod ~10 riadkov". Preto: čo sa dá, riešiť **override vrstvou** (cascade) a **vlastnými súbormi** (onboarding), zvyšok ponúknuť **upstreamu** ako PR *„tokenize hardcoded colors"* — dizajnový systém upstreamu je stabilný (tokens.css: 1 commit od vzniku), šanca na prijatie je vysoká a náš diff ostane ~0.

---

## 4 · UX hodnotenie súčasného modelu

| Dimenzia | Dnes | Pre advokáta znamená | Posun |
|---|---|---|---|
| **Vstupný bod** | chat so session, sidebar = zoznam priečinkov a sessions | „kam mám kliknúť, aby som videl, čo horí?" — nikam | **Prehľad praxe** ako domovská routa; chat zostáva o 1 klik (AI asistent) alebo *v spise* |
| **Jednotka práce** | session (konverzácia) | advokát myslí v **spisoch**, nie v konverzáciách | spis = jednotka; session je **súčasť spisu** (`/spis/:id/asistent`) |
| **AI výstup** | správa v chate, tool call karty | kde je zdroj, kde je istota, čo sa stane keď kliknem? | **DecisionGate** vzor: Zdroj · Návrh · istota · 4 akcie · auditná veta |
| **Lehoty** | neexistujú | kritický use case (Q07: „zmeškaná lehota advokáta položí") | routa `/lehoty` + kandidát → brána (spec 0005) |
| **MCP** | settings tab `extensions/mcp`, JSONC config, OAuth modal 966 r. | „čo je pripojené a je to dôveryhodné?" sa nedozvie | **Konektory a nástroje hub** (mockup 05/10) s trust labelom *lokálne / vlastný / tretia strana* (spec 0011 B) |
| **Onboarding** | 4 kroky o modeloch, workflow šablónach, transkripcii | rieši providerov, nie prax | LAWOSS onboarding: meno advokáta → jurisdikcia → OKF koreň → konektory |
| **Jazyk** | EN + 10 locales, sidebar hardcoded EN | advokát bez angličtiny sa stratí | `sk.ts` + `cs.ts` (🟢) + vlastný sidebar |
| **Platforma** | `mac/windows/linux` varianty, `titlebar-drag` | Windows first-class (issue #41) | každá nová obrazovka testovaná na Windows (IR) |

**Čo sa nesmie zničiť:** session/chat (composer, side panel taby, artifacts vrátane DOCX editora, terminál, voice, learnings), recorder, benchmark, settings, Word add-in (`word-addin/` vlastný CSS!), live overlay, web build.

---

## 5 · MCP / connections — čo máme a čo chýba voči hubu

**Máme (overené `domains/connections/store.ts`):** `mcpServers`, `mcpStatuses` (connected/…), `quickConnect`, `connectMcp`, `authorizeMcp` (OAuth/token), `setMcpEnabled`, `removeMcp`, `readMcpConfigFile` (JSONC cez `jsonc-parser`), `pollMcpServersAfterReload`; `use-mcp-connected-count.ts` (poll 60 s); `legalwork-server-store.ts` (capabilities, audit log entries); modaly `add-mcp`, `mcp-connector-setup` (vendor katalóg s `{placeholder}`), `claude-plugin-import`.

**Chýba pre hub z mockupov 05/10 a spec 0011 B:**

| Potreba | Dnes | Čo doplniť (🟢 nové súbory) |
|---|---|---|
| stav per server s **odozvou, počtom tools, posledným syncom** | len connected/disconnected | `lawoss/hub/health.ts` — canary call + meranie |
| **trust label** (beží lokálne · vlastný server · tretia strana · dáta odchádzajú) | nič | odvodiť z `local/remote` + registry manifest |
| **read-only flag** a allowlist tools | nič | z manifestu (`requires`, tools) |
| **lokálne nástroje** (Autogram, Whisper, OCR, CLI skripty) ako rovnocenné karty | recorder settings oddelene | `lawoss/hub/tools/*` adaptéry: detekcia prítomnosti, cesta, verzia |
| logy/výstupy per konektor | nič v UI | panel s posledným výstupom / chybou |
| katalóg (registry) local+remote variant | `mcp-connector-setup-modal` (vendor) | napojiť na `lawoss-registry` manifesty |

---

## 6 · Komponentový deficit (vs. 36 primitív `@legalwork/ui` + shadcn `@/components/ui`)

*(v2 — rozsah „LegalWork + vrstva“; v1 zoznam StatCard/Badge/Card-gold zamietnutý ako cloud style)*

| Stačí reuse (reskin tokenmi) | **Nové stavebné prvky (🟢 `lawoss/ui`)** |
|---|---|
| Button, Input, SearchInput, Switch, Tabs, Menu, Select, Tooltip, Modal, ConfirmModal, Toast, Skeleton, Checkbox, Table, Kbd; upstream composer, DOCX/PDF artifact editor, workspace files panel, settings shell, MCP auth modaly | **Tabs** (registrové záložky) · **Obal** (kolónky) · **Register** (riadky s číslom listu) · **DeadlineStrip** (SVG 14 dní) · **Timeline** (SVG s fázami) · **Brain** (+ vrstvy L1/L2/L3) · **Gate** (+ DocView s locatorom) · **Seal** · **Diff + Learn** (reconcile) · **Schema** (konektory) · **ComposerContext** · **EmptyState** |

API náčrty: [IA v2 §5](2026-08-23-ia-screen-plan-a-komponenty.md).

---

## 7 · Riziká

| # | Riziko | Závažnosť | Mitigácia |
|---|---|---|---|
| R1 | **Dve vízie UI od MČ naraz**: spec 0011 (minimálna UI vrstva: settings tab + artifact timeline, ≤3 riadky PATCHES) vs. redesign prompt (plná IA + 10 obrazoviek) | vysoká — tím nevie, čo platí | tento balík navrhuje **zmierenie** (implementačný plán §0): 0011 = mechanika V1, redesign = vizuál + IA nad ňou vo fázach; odklepnúť na calle |
| R2 | Dark ako default je 🟡 zásah do `theme.ts`; upstream môže Appearance tab odkryť | nízka | value-only, 1 riadok; alebo `lawoss/theme/bootstrap.ts` nastaví default pri prvom spustení (🟢) |
| R3 | Playfair na Windows: ClearType rendering tenkých serifov | stredná | váha 400–500, min. 18 px pre serif; IR overí na Windows |
| R4 | Upstream mení `app-sidebar.tsx` často (44 commitov v domains za 3 mesiace) | stredná | **vlastný sidebar** ako nový súbor, jediný switch v session-page |
| R5 | `ci-i18n.yml` vyžaduje kompletné preklady — `sk.ts` s 2 236 kľúčmi | stredná | rozhodnúť: kompletný strojový preklad + ľudská korektúra kľúčových obrazoviek, alebo dohoda s upstreamom o fallbacku |
| R6 | Word add-in a overlay majú vlastný CSS — nebudú ladiť s navy | nízka | samostatná mini-úloha vo Fáze A (value-only v `word-pane.css`) |
| R7 | In-app baseline screenshoty chýbajú | nízka | prvá úloha Fázy A (mac + win) |

---

## 8 · Nesúlady nájdené mimo rozsahu (na vedomie, neriešené tu)

- `ARCHITECTURE.md` forku uvádza doménu `cloud/`, ktorá neexistuje.
- 3 prunable worktrees v metadátach forku (`/private/tmp/lawoss-*`) → `git worktree prune`.
- Koordinačné repo: `decisions/0002` odkazuje na neexistujúci `0001-fork-strategy.md`; `specs/README.md` má 0006 ako „rezervované" hoci súbor existuje, a 0011 bez súboru (žije v PR #55); `CONTRIBUTING.md` a issue template stále „MikeOSS Slovakia"; chýba `LICENSE`.

---

<sub>Overené čítaním kódu a grepom 2026-08-23 (fork `dev` @ c5e177a). Fiktívne dáta v screenshotoch a prototypoch — žiadne reálne klientske údaje.</sub>
