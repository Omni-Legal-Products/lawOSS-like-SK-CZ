# Fázovaný implementačný plán redesignu — fázy A → D

- **Zostavil:** Marián Čuprík (MČ) s AI asistenciou · 2026-08-23
- **Stav:** 📝 návrh na odklep *(implementácia vo forku až po odklepe tímom)*
- **Nadväzuje na:** [audit](2026-08-23-audit-sucasnej-appky.md) · [dizajnový jazyk](2026-08-23-dizajnovy-jazyk-lawoss.md) · [IA a komponenty](2026-08-23-ia-screen-plan-a-komponenty.md) · [spec 0011 (PR #55)](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/55) · [paper cuts 21. 8.](../../planning/2026-08-21-paper-cuts-a-rychle-vylepsenia.md) · [AGENTS.md forku](https://github.com/Omni-Legal-Products/lawoss/blob/dev/AGENTS.md)

Legenda: 🟢 nové súbory · 🟡 zásah do upstream súboru (riadok v `PATCHES.md` v tom istom PR) · 🔴 zakázané · **S/M/L** náročnosť (hodiny / dni / týždeň+).

---

## 0 · Zmierenie so spec 0011 — čo platí

Spec 0011 (21. 8.) a redesign prompt (23. 8.) sú obe od MČ a navonok si protirečia (minimálna UI vrstva vs. plná IA). Návrh zmierenia na odklep:

| Vrstva | Čo | Kde je definovaná |
|---|---|---|
| **Mechanika V1** | settings tab `lawoss`, `lawoss.config.md`, agent-driven „Nový spis" cez command palette, `lehoty.md` front-matter, connector registry, timeline ako HTML artifact vo fáze 1 | **spec 0011** — nemení sa |
| **Vizuál a IA** | token override (celá appka), vlastný sidebar + routy, domain obrazovky ako *pohľady* na dáta z 0011 | **tento plán** — stavia *nad* 0011, nie namiesto neho |

Dôsledok: Fázy A a B sú nezávislé od 0011 a môžu ísť hneď. Fáza C berie dáta presne z formátov 0011 (`lehoty.md`, `lawoss.config.md`, `_STATUS.md`) — žiadna databáza, žiadny nový stav (Q16/Q17). Timeline „fáza 2 panel tab" z 0011 sa stáva obrazovkou `/spis/:id/timeline` v Fáze C. Rozpočet merge dlhu 0011 (≤3 riadky) sa rozširuje na **≤ 8 riadkov `PATCHES.md`** po Fáze C — viď §5.

## 1 · Fáza A — token override + reskin celej appky

**Cieľ:** appka vyzerá ako LAWOSS (navy/zlatá/Playfair) bez zmeny jedinej obrazovky. Jeden PR, jeden deň.

| # | Úloha | Zóna | Náročnosť | PATCHES.md |
|---|---|---|---|---|
| A1 | Baseline in-app screenshoty všetkých obrazoviek, mac + Windows (`pnpm dev`) → `docs/design/baseline/` | 🟢 | S | — |
| A2 | `lawoss/theme/lawoss-tokens.css` — `:root` + `[data-theme="dark"]` value-only override **všetkých** `--lw-*` podľa [dizajnového jazyka §1.2](2026-08-23-dizajnovy-jazyk-lawoss.md) + nové `--lw-glow`, `--lw-marker`, `--lw-duration-seal` | 🟢 | M | — |
| A3 | `lawoss/theme/fonts.css` + dep `@fontsource-variable/playfair-display`; `--lw-font-serif` → Playfair | 🟢 | S | — |
| A4 | `apps/app/src/app/index.css`: **+1 riadok** `@import` za `tokens.css`; `--chart-1..5` value-only | 🟡 | S | 1 riadok |
| A5 | Default téma `dark` (`app/theme.ts` DEFAULT, value-only) *alebo* 🟢 `lawoss/theme/bootstrap.ts` nastaví pri prvom štarte | 🟡/🟢 | S | 0–1 |
| A6 | Word add-in `word-pane.css` value-only navy/gold | 🟡 | S | 1 riadok |
| A7 | Overiť live overlay / overlay transparentné pozadia na navy | — | S | — |
| A8 | Vizuálna kontrola: dark + light, mac + win; screenshoty „po" | — | S | — |
| A9 | **Upstream PR** „tokenize hardcoded colors" pre 12 súborov hex dlhu (bez onboarding, bez provider/marble) — pripraviť, podať, nečakať naň | upstream | M | 0 (ak prijatý) |

**Definícia hotovo A:** appka v dark navy s Playfair H1; žiadna obrazovka nerozbitá; `PATCHES.md` +2–3 riadky; screenshoty pred/po v PR.

## 2 · Fáza B — shell: navigácia a routy (nová IA, zatiaľ prázdne ciele)

| # | Úloha | Zóna | Náročnosť | PATCHES.md |
|---|---|---|---|---|
| B1 | `lawoss/shell/lawoss-sidebar.tsx` (skupiny Prax · Overovanie · Systém, gold rail, counts, pätička s menom) + `t('lawoss.nav.*')` | 🟢 | M | — |
| B2 | Switch na náš sidebar v `session-page.tsx` (1 riadok) — **alebo** upstream PR „sidebar slot v ShellConfig" | 🟡 | S | 1 |
| B3 | `lawoss/shell/routes.tsx` + `routes-paths.ts`; mount `<Route path="/*">` v `app-root.tsx` (1 riadok); redirect `/` → `/prehlad` (1 riadok) | 🟢 + 🟡 | M | 1–2 |
| B4 | `lawoss/shell/lawoss-layout.tsx` (PageHeader, grid, titlebar-drag) + EmptyState placeholdery pre každú routu | 🟢 | S | — |
| B5 | Settings tab `lawoss` (registrácia v `SETTINGS_TAB_VALUES` + list) + stránka `lawoss/settings/lawoss-settings-view.tsx` (spec 0011 A) | 🟢 + 🟡 | M | 1 |
| B6 | `sk.ts` + `cs.ts` kostra + registrácia v `i18n/index.ts` (union, LANGUAGES, TRANSLATIONS, plural) — rozhodnúť stratégiu voči `ci-i18n.yml` | 🟢 + 🟡 | L | 1 |
| B7 | Command palette akcie „Nový spis", „Usporiadaj spis" (spec 0011) | 🟡 | S | 1 |

**Definícia hotovo B:** nová navigácia funguje, každá routa má aspoň EmptyState so zlatou akciou; AI asistent a Nastavenia fungujú ako predtým; Windows overené (IR).

## 3 · Fáza C — domain obrazovky (🟢 `lawoss/domains/*`)

Poradie podľa Q07 (spisy/pamäť → lehoty → rešerš) a podľa toho, čo už má dáta:

| # | Obrazovka | Komponenty (🟢 `lawoss/ui`) | Dáta | Náročnosť |
|---|---|---|---|---|
| C1 | `lawoss/ui/*` základ: PageHeader, StatCard, SourceBadge, ConfidenceMeter, CitationBlock, ProposalTable, **DecisionGate**, SealMoment, Timeline, TaskList, MatterBrainPanel, ConnectorCard, WizardSteps, EmptyState (+ Storybook-like `lawoss/ui/preview.tsx` na vizuálnu kontrolu) | — | — | L |
| C2 | **Spisy** (`/spisy` zoznam + `/spis/:id` detail s Timeline·Úlohy·Dokumenty·Matter Brain; tab Asistent = existujúci session) | Timeline, TaskList, MatterBrainPanel | `spis.md`, `_STATUS.md`, `MEMORY.md`, `lehoty.md` (parser 🟢 `lawoss/okf/read.ts`, **read-only** — zápisy robí agent cez skill) | L |
| C3 | **Lehoty** (`/lehoty` zoznam + `/lehoty/:id` brána) | DecisionGate, DeadlineRow | `lehoty.md` stavy spec 0005; potvrdenie = agent skill zapíše + ICS + audit (UI volá skill, nezapisuje sám — ADR 0007 p. 2) | L |
| C4 | **Prehľad** (`/prehlad`) | StatCard×3, card-gold „Čaká na rozhodnutie", DeadlineList, SourceStatus | agregácia C2+C3 + hub health | M |
| C5 | **Konektory a nástroje** (`/konektory`) | ConnectorCard, LocalToolCard, segment, trust label | `connections/store` + 🟢 `lawoss/hub/{health,registry,tools}.ts` (Autogram/OCR/Whisper detekcia) | L |
| C6 | **Rešerš** (`/resers`: právny výskum + subjekty) | ResultRow+SourceBadge, RegisterCard, DecisionGate (menovec) | MCP judikatúra/Slov-Lex/registre cez existujúci client; režimy light/medium/hard (spec 0002) | L |
| C7 | **Onboarding LAWOSS** (nahrádza `/welcome`, 1 riadok 🟡) | WizardSteps, SealMoment | reuse create-workspace + provider selection logika | M |
| C8 | Podpisovanie (`/podpisovanie`) — detekcia Autogram + SignTypePicker + odovzdanie; Zaručená konverzia a Komunikácia = informačné placeholdery (nie V1/V2) | 🟢 | M | M |

**Definícia hotovo C:** advokát prejde *Nový spis → dokument → kandidát lehoty → brána → potvrdenie → ICS* bez chatu; každý AI blok má AI badge; každý overený výsledok má SourceBadge s provenance; Windows smoke test.

## 4 · Fáza D — motion polish a small delights

| # | Úloha | Náročnosť |
|---|---|---|
| D1 | Staggered entrance + hover lifts + skeletony na všetkých C obrazovkách; `prefers-reduced-motion` audit | M |
| D2 | SealMoment pri potvrdení lehoty, podpise, dokončení onboardingu | S |
| D3 | Timeline progress animácia + filter chips | S |
| D4 | Klávesové skratky brány (⏎ E Esc) + command palette položky pre každú obrazovku (ADR 0007 p. 2: všetko bez myši) | M |
| D5 | Empty/error/loading stavy podľa jazyka §5.6; copy review SK + CZ (VŘ) | M |
| D6 | Kontrast audit (axe) dark + light; Windows ClearType kontrola serifu (IR) | S |

## 5 · Rozpočet `PATCHES.md` po fáze C

| Upstream súbor | Zásah | Fáza |
|---|---|---|
| `apps/app/src/app/index.css` | +1 import, chart value-only | A |
| `apps/app/src/app/theme.ts` | default `dark` (ak nie bootstrap) | A |
| `apps/app/src/word-addin/word-pane.css` | value-only | A |
| `react-app/domains/session/chat/session-page.tsx` | sidebar switch | B |
| `react-app/shell/app-root.tsx` | mount LawossRoutes + redirect `/` | B |
| `app/types.ts` + settings-page | tab `lawoss` | B |
| `i18n/index.ts` | sk/cs registrácia | B |
| `shell/command-palette.tsx` | 2 akcie | B |

= **8 riadkov** (README.md a AGENTS.md už sú 2 → 10). Každý je 1–3 riadky kódu. Ak upstream prijme „sidebar slot" a „tokenize colors" PR, klesne na 6.

## 6 · Poradie a odhad

```
týždeň 1   A (1–2 dni)  →  B1–B4 (2–3 dni)        ← paralelne: B6 locale (VŘ CZ strana), A9 upstream PR
týždeň 2   B5–B7 + C1 (komponenty)                ← paralelne: IR Windows testy A/B
týždeň 3–4 C2 Spisy → C3 Lehoty → C4 Prehľad
týždeň 5   C5 Hub → C7 Onboarding
týždeň 6   C6 Rešerš → C8 → D
```

Každá položka = **1 issue vo forku** s odkazom na tento plán (po odklepe), vetva `design/*` (A, B, D) alebo `feat/*` (C), PR s 1 approval + zelené CI, screenshot dark+light v PR. Detail procesu: [playbook spolupráce](../playbook-spolupraca.md).

## 7 · Čo potrebuje rozhodnutie tímu (na call)

1. **Zmierenie 0011 ↔ redesign** (§0) — áno/nie.
2. **Dark ako default** — áno (návrh) / ponechať light.
3. **Locale stratégia** voči `ci-i18n.yml`: kompletný preklad 2 236 kľúčov (strojovo + korektúra) vs. dohoda s upstreamom.
4. **Hub = jedna obrazovka** pre mockupy 05 + 10 — áno (návrh).
5. **Q07:** lehoty v prvej trojici → C3 hneď po C2 (návrh) alebo až po rešerši.
6. **Rozpočet PATCHES.md ≤ 10** (§5) — áno/nie.
7. Hi-fi pre zvyšných 6 obrazoviek (04, 06, 07, 08, 09 + onboarding) — spraviť pred C, alebo až pri implementácii každej.

---

<sub>Návrh MČ s AI asistenciou 2026-08-23. Odhady sú orientačné (práca s AI agentmi, 4 ľudia na čiastočný úväzok). Zóny podľa AGENTS.md forku.</sub>
