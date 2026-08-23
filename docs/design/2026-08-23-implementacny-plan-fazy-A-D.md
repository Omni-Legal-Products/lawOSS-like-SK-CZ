# Fázovaný implementačný plán — fázy A → D (v2)

- **Zostavil:** Marián Čuprík (MČ) s AI asistenciou · 2026-08-23 · **v2** podľa rozsahu „LegalWork + LAWOSS vrstva, 4 tentpoles“
- **Stav:** 📝 návrh na odklep *(implementácia vo forku až po odklepe tímom)*
- **Nadväzuje na:** [audit](2026-08-23-audit-sucasnej-appky.md) · [dizajnový jazyk v2](2026-08-23-dizajnovy-jazyk-lawoss.md) · [IA v2](2026-08-23-ia-screen-plan-a-komponenty.md) · [spec 0011 (PR #55)](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/55) · [paper cuts 21. 8.](../../planning/2026-08-21-paper-cuts-a-rychle-vylepsenia.md) · [AGENTS.md forku](https://github.com/Omni-Legal-Products/lawoss/blob/dev/AGENTS.md)

Legenda: 🟢 nové súbory · 🟡 zásah do upstream súboru (riadok v `PATCHES.md` v tom istom PR) · **S/M/L** hodiny / dni / týždeň+.

---

## 0 · Vzťah k spec 0011

Spec 0011 je **mechanika** (settings tab `lawoss`, `lawoss.config.md`, agent-driven „Nový spis“ cez command palette, `lehoty.md` front-matter, connector registry). Tento plán je **skin + pohľady** nad tou mechanikou. Kde 0011 hovorí „timeline ako HTML artifact vo fáze 1“, tento plán ju robí natívnym SVG pohľadom v spise (fáza C) — artifact variant ostáva ako fallback pre čistý opencode/CLI (prenositeľnosť OKF). Rozpočet `PATCHES.md`: **≤ 9 nových riadkov** (§5).

## 1 · Fáza A — skin celej appky (1 PR, 1–2 dni)

| # | Úloha | Zóna | Nár. | PATCHES |
|---|---|---|---|---|
| A1 | Baseline screenshoty všetkých upstream obrazoviek, mac + Windows → `docs/design/baseline/` | 🟢 | S | — |
| A2 | `lawoss/theme/lawoss-tokens.css` — value-only override `--lw-*` podľa [jazyka §1](2026-08-23-dizajnovy-jazyk-lawoss.md): desk/sheet/well, ink, gold, rule, stavové farby, `--chart-*`, nové `--lw-gold-ink`, `--lw-duration-seal` | 🟢 | M | — |
| A3 | `lawoss/theme/fonts.css`: `--lw-font-sans` → IBM Plex Sans (už bundlovaný), `--lw-font-mono` → IBM Plex Mono (🟢 dep `@fontsource/ibm-plex-mono`), `--lw-font-serif` → Playfair (🟢 dep, iba pečať/wordmark) | 🟢 | S | — |
| A4 | `apps/app/src/app/index.css`: +1 `@import` za `tokens.css` | 🟡 | S | 1 |
| A5 | Default téma `dark`: `lawoss/theme/bootstrap.ts` nastaví pri prvom štarte (🟢) — ak nepôjde, 1 riadok v `app/theme.ts` (🟡) | 🟢/🟡 | S | 0–1 |
| A6 | `word-addin/word-pane.css` value-only | 🟡 | S | 1 |
| A7 | `::selection`, scrollbar, focus ring, `color-scheme` v override vrstve; kontrola overlay/titlebar | 🟢 | S | — |
| A8 | Screenshoty „po“, dark, mac + win; `impeccable detect` nad override CSS | — | S | — |
| A9 | Upstream PR „tokenize hardcoded colors“ (12 súborov hex dlhu bez onboarding/provider/marble) — podať, nečakať | upstream | M | 0 |

**Hotovo A:** celá appka v svete „stôl + list“, Plex písmo, bez rozbitej obrazovky, `PATCHES.md` +2–3.

## 2 · Fáza B — záložky, routy, tab LAWOSS, locale (3–4 dni)

| # | Úloha | Zóna | Nár. | PATCHES |
|---|---|---|---|---|
| B1 | `lawoss/ui/tabs.tsx` (registrové záložky) + `lawoss/shell/tabs.tsx` (položky, počty z OKF/lehoty/konektorov) | 🟢 | M | — |
| B2 | Horný blok `app-sidebar.tsx` → `<LawossTabs/>` (1 riadok) — alebo upstream PR „sidebar slot v ShellConfig“ | 🟡 | S | 1 |
| B3 | `lawoss/shell/routes.tsx` + mount v `app-root.tsx` (+ redirect `/` → `/prehlad`) | 🟢 + 🟡 | M | 1 |
| B4 | `lawoss/shell/layout.tsx`: list (sheet) s obalom, H1, composer s kontextom; prázdne stavy pre každú routu (1 veta + 1 zlatá akcia) | 🟢 | S | — |
| B5 | Settings tab `lawoss` (spec 0011 A) | 🟢 + 🟡 | M | 1 |
| B6 | `sk.ts` + `cs.ts` + registrácia v `i18n/index.ts`; stratégia voči `ci-i18n.yml` (rozhodnutie §7) | 🟢 + 🟡 | L | 1 |
| B7 | Command palette: „Nový spis“, „Usporiadaj spis“, „Skontrolovať lehoty“ (spec 0011) | 🟡 | S | 1 |

**Hotovo B:** záložky fungujú, Asistent/Nastavenia nezmenené, každá nová routa má prázdny stav; Windows overené (IR).

## 3 · Fáza C — štyri tentpoles ako pohľady (🟢 `lawoss/domains/*`)

Poradie: Brain → lehoty → reconcile → konektory/marketplace (Q07 + to, čo už má dáta a skills).

| # | Pohľad | Stavebné prvky (`lawoss/ui`) | Dáta / skill | Nár. |
|---|---|---|---|---|
| C1 | `lawoss/okf/read.ts` — parser `spis.md` (frontmatter), `_STATUS.md`, `MEMORY.md` (TP-xxx), `lehoty.md` (JSON front-matter); **read-only**; + `lawoss/ui/preview.tsx` na vizuálnu kontrolu prvkov | — | OKF v0.1 formáty zo skillu `novy-spis` | M |
| C2 | **Spis + OKF Brain** (`/spis/:id`): obal, timeline SVG s fázami, register dokumentov (otvoriť v upstream editore), úlohy, Brain panel s vrstvami, agent line + composer (session filtrovaná na priečinok) | obal, register, timeline, brain, composer-context | C1; session = upstream `SessionRoute` s route state | L |
| C3 | **Lehoty + brána** (`/lehoty`, `/lehoty/:id`): register lehôt, pás 14 dní, brána s náhľadom dokumentu a locatorom, pečať; potvrdenie volá skill `lehoty` (zápis + ICS + audit) | register, deadline-strip, gate, docview, seal | spec 0005 stavy; skill `lehoty-sk` (IR #33), `lehoty-cz` (VŘ) | L |
| C4 | **Prehľad** (`/prehlad`): obal praxe, „Čaká na advokáta“ (kandidáti lehôt + návrhy zápisov + drafty), pás lehôt, agent line, composer, prijímacia pečiatka | obal, register, deadline-strip, stamp | agregácia C1 cez všetky spisy koreňa | M |
| C5 | **Reconcile** (`/spis/:id/reconcile/:docId`): hook na uloženie v upstream DOCX editore → skill `reconcile` vytvorí diff + návrhy → pohľad diff + „čo si agent chce zapamätať“ + výber vrstvy + brána | diff, learn, gate | spec 0009; verzie dokumentu v OKF; zápis do `MEMORY.md`/`_STATUS.md` len po podpise | L |
| C6 | **Konektory** (`/konektory`): schéma SVG, register pripojených (trust label, read-only, tools, latencia), lokálne nástroje (Autogram/OCR/Whisper/OKF skripty — detekcia), BYO server | schema, register | `connections/store` + `lawoss/hub/{health,tools}.ts` | L |
| C7 | **Marketplace** (`/marketplace`): register z `lawoss-registry` (MCP · skills · pluginy), pin, remote/local inštalácia cez deterministický skill/CLI, allowlist, rollback | register | spec 0011 B; `lawoss-registry` repo | M |
| C8 | DOCX editor: `suggesting` prepínač (#29), meno advokáta (#31), `onSave` → C5 | 🟡 | S | 2 |

**Hotovo C:** advokát prejde *Nový spis (chat) → dokument → kandidát lehoty → brána → pečať → ICS* a *uloží úpravu dokumentu → reconcile → zápis do pamäte po podpise* bez opustenia appky; každý AI blok označený; Windows smoke test.

## 4 · Fáza D — diagramy dotiahnuť, motion, copy (1 týždeň)

| # | Úloha | Nár. |
|---|---|---|
| D1 | Timeline a pás lehôt: interaktivita (hover = detail, klik = brána/dokument), filtre druhov udalostí, responzívne zalomenie | M |
| D2 | Pečať v troch kontextoch (lehota, podpis cez Autogram, dokončený onboarding); `prefers-reduced-motion` audit | S |
| D3 | Klávesnica: brána ⏎/E/Esc, command palette pre každý pohľad (ADR 0007 p. 2) | M |
| D4 | Prázdne/chybové stavy podľa jazyka; SK copy MČ, CZ copy VŘ | M |
| D5 | Kontrast audit (axe), Windows ClearType (IR), `impeccable detect` nad `lawoss/**` = 0 nálezov | S |

## 5 · Rozpočet `PATCHES.md` po fáze C

| Upstream súbor | Zásah | Fáza |
|---|---|---|
| `app/index.css` | +1 import | A |
| `app/theme.ts` | default dark (iba ak bootstrap nestačí) | A |
| `word-addin/word-pane.css` | value-only | A |
| `session/sidebar/app-sidebar.tsx` | horný blok → LawossTabs | B |
| `shell/app-root.tsx` | mount + redirect | B |
| `app/types.ts` + settings list | tab `lawoss` | B |
| `i18n/index.ts` | sk/cs | B |
| `shell/command-palette.tsx` | 3 akcie | B |
| `artifacts/artifact-docx-editor.tsx` | mode + author + onSave | C |

= **9 riadkov** (+2 existujúce = 11; ak upstream prijme „sidebar slot“ a „tokenize colors“, 9). Každý 1–3 riadky kódu.

## 6 · Poradie a odhad

```
týždeň 1   A → B1–B4                         ‖ B6 locale (MČ SK, VŘ CZ) · A9 upstream PR · IR Windows A
týždeň 2   B5–B7 · C1 parser · lawoss/ui prvky
týždeň 3   C2 Spis + Brain · C4 Prehľad
týždeň 4   C3 Lehoty + brána (IR lehoty-sk)
týždeň 5   C5 Reconcile + C8 editor
týždeň 6   C6 Konektory · C7 Marketplace
týždeň 7   D
```

Každá položka = 1 issue vo forku s odkazom sem (po odklepe); vetvy `design/*` (A, B, D) a `feat/*` (C); PR s 1 approval + CI + screenshot; proces v [playbooku](../playbook-spolupraca.md).

## 7 · Na rozhodnutie tímu

1. **Rozsah v2** (LegalWork + vrstva, 5 pohľadov, nič navyše) — áno/nie.
2. **IBM Plex Sans namiesto Inter** — zmena `brand-concept.md` — áno (MČ súhlasí 23. 8.) / potvrdenie tímu.
3. **Tmavá ako jediná navrhovaná téma** (light iba technicky funkčný) — áno/nie.
4. **Locale stratégia** voči `ci-i18n.yml` (2 236 kľúčov).
5. **Q07:** lehoty hneď po Brain (C3 po C2) — áno/nie.
6. **Reconcile hook v upstream editore** = 2 riadky 🟡 (C8) alebo upstream PR „onSave hook“ — preferencia?
7. **`PATCHES.md` ≤ 11 riadkov** — akceptovať.

---

<sub>v2 · MČ s AI asistenciou · 2026-08-23. Odhady orientačné (4 advokáti s AI agentmi, čiastočný úväzok).</sub>
