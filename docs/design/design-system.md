# LAWOSS Design systém — source of design truth

- **Stav:** 🟢 **záväzný živý dokument** (odklepnuté na calle 28. 8. — [zápis](../../meetings/2026-08-28-zapis-sync-call.md)). Každý feature PR sa naň odvoláva; zmeny sem idú cez PR skôr, než do kódu.
- **Vlastník:** MČ (dizajn lead) · zmeny hodnoteniu tímu podľa ADR 0011
- **Implementácia tokenov:** [`lawoss/theme/lawoss-tokens.css`](https://github.com/Omni-Legal-Products/lawoss/blob/dev/lawoss/theme/lawoss-tokens.css) vo forku — **jediné miesto, kde sa hodnoty menia**
- **Nadväzuje na:** [Dizajn systém je LegalWork](2026-08-27-dizajn-system-je-legalwork.md) *(princíp + mapa prekryvov)* · [dizajnový jazyk v2](2026-08-23-dizajnovy-jazyk-lawoss.md) *(svet, zákazy, vzory)* · [audit](2026-08-23-audit-sucasnej-appky.md)

## 0 · Prvý princíp

**Dizajn systém LAWOSS = dizajn systém LegalWorku s našimi hodnotami.** Ich štruktúra (tokeny `--lw-*`, komponenty `@legalwork/ui` + `@/components/ui`, shell, settings, systém skills/MCP/plugins) sa **preberá**; my meníme *hodnoty* tokenov a pridávame *features*. Pred každým návrhom: over, či to v appke už nie je → rozšír → inak postav z ich primitív → vlastné len bez ekvivalentu (a zapíš prečo). Detail: [mapa prekryvov](2026-08-27-dizajn-system-je-legalwork.md).

> [!WARNING]
> **Stav integrácie (28. 8., úprimne):** demo pohľady vo forku (Prehľad/Lehoty/Konektory/Marketplace) sú **pasívne obrazovky vo vlastnom layoute — NIE vzor integrácie**. Vzor integrácie = fork issue [#21](https://github.com/Omni-Legal-Products/lawoss/issues/21): pohľady v shelli appky, z jej primitív. Nekopírujte z dema layout; kopírujte tokeny a vzory z tohto dokumentu.

## 1 · Farby (dark = jediná navrhovaná téma)

| Rola | Token | Hodnota | Použitie |
|---|---|---|---|
| stôl / okno | `--lw-canvas`, `--lw-sidebar` | `#0A0E14` | pozadie appky |
| list / plocha | `--lw-surface` | `#10171F` | hlavné plochy, karty appky |
| hover plochy | `--lw-surface-hover` | `#141C26` | |
| vnorené | `--lw-sunken` | `#0C1219` | composer, kalkulácie, náhľady |
| atrament | `--lw-text-primary` | `#E9E4DA` | papierovo teplý, nie studená biela |
| sekundárny text | `--lw-text-secondary` | `#A8B0BA` | tintovaný z navy |
| terciárny text | `--lw-text-tertiary` | `#75808C` | meta (AA 4,8:1) |
| linky | `--lw-border-subtle/-/strong` | `rgba(233,228,218,.08/.14/.26)` | vždy 1 px |
| **zlatá = razidlo** | `--lw-accent` | `#C9A24A` (hover `#E3C46E`) | 1 primárna akcia na obrazovke · aktívny stav · pečať · „návrh agenta“ · nič iné |
| marker/selection | `--lw-gold-ink` | `rgba(201,162,74,.18)` | citácie, výber textu |
| success / warning / danger / info | `--lw-success/warning/danger` | `#8DBB8F / #D89A4E / #D9776B / #7FA3C7` | warning je oranžová, **nikdy zlatá** |

Svetlý režim: iba technický fallback (hodnoty v tokens vrstve), nenavrhuje sa.

## 2 · Tvar — hranaté (rozhodnutie 28. 8.)

Odlíšenie od upstreamu: **hranatejšie rohy** (fork issue [#22](https://github.com/Omni-Legal-Products/lawoss/issues/22), value-only):

| Token | Upstream | **LAWOSS** |
|---|---|---|
| `--lw-radius-xs` | 4px | **2px** |
| `--lw-radius-sm` | 6px | **2px** |
| `--lw-radius-md` | 8px | **3px** |
| `--lw-radius-lg` | 10px | **4px** |
| `--lw-radius-xl` | 12px | **4px** |
| `--lw-radius-2xl` | 16px | **6px** |
| `--lw-radius-3xl` | 20px | **6px** |
| `--lw-radius-full` | 9999px | 9999px *(avatary, status bodky — ostáva)* |
| shadcn `--radius` | 0.625rem | **0.25rem** |

Tiene: hairline > tieň; tieň len popover/menu a poctivá elevácia (offset + blur, nikdy zero-offset glow).

## 3 · Typografia

| Rola | Písmo | Poznámka |
|---|---|---|
| UI + text | **IBM Plex Sans** 400/500/600 | bundlovaný upstreamom; SK/CZ diakritika |
| právne identifikátory | **IBM Plex Mono** 400/500 | §, sp. zn., IČO, súbory, kalkulácie, tool-calls — len dáta, nie kostým |
| pečať | **Playfair Display** 500 | jediný serif, iba pečať |
| **wordmark LAWOSS** | **lettering, nie font** — viď nižšie | logo, splash, o aplikácii |

### 3b · Wordmark (z návrhov loga 11–14 — zhoda na calle 28. 8.)

Charakteristika litier (overené z návrhov 11–14, 2026-08-29): **tenký geometrický grotesk, jednotná hrúbka ťahu ~4 % kapitálok, veľmi široký preklad (~0,30–0,35 em), `A` bez priečnej čiary, dokonale kruhové `O`, `W` ako dve špicaté V, otvorené `S`**; podtitul `CZECHIA · SLOVAKIA` v rovnakom duchu, zlatý, menší, preklad ~0,25 em.

- Finál = **prekresliť do SVG kriviek** (lettering) — appka ani web nepotrebujú font ako závislosť.
- Najbližšie voľné fonty na pracovné použitie (prezentácie, dokumenty), *kým lettering nie je*: **Julius Sans One** alebo **Montserrat Thin/Light s rozšíreným trackingom** — priečku `A` má oboje, čiže len aproximácia; označovať ako pracovnú náhradu. *(neoverené voči licencii použitia v logu — lettering to rieši)*
- Delenie farieb `LAW` biele + `OSS` zlaté (brand-concept) sa vo wordmarku návrhov 11–14 nepoužíva — celý biely, zlatý je podtitul. **Na rozhodnutie pri finalizácii loga** (brand-concept vs. nové logo).

## 4 · Komponenty a vzory

**Reuse-first:** Button, Input, Select, Tabs, Menu, Modal, Toast, Table, Skeleton… = upstream (`@legalwork/ui`, `@/components/ui`) — bez vlastných náhrad. Systém **skills / MCP / plugins ostáva ich** (rozhodnutie 28. 8.) — my doň len pridávame obsah (marketplace zdroj, defaulty).

**LAWOSS vzory** (definície + ukážky v [dizajnovom jazyku v2 §3–§5](2026-08-23-dizajnovy-jazyk-lawoss.md) a [hifi prototype](hifi/lawoss-hifi.html)):

| Vzor | Kedy | Pravidlo |
|---|---|---|
| **Karta brány** (gate card) | každý návrh agenta s právnym účinkom | Zdroj + provenance ‖ návrh + istota (slovo, nie %) → Potvrdiť/Upraviť/Odmietnuť/Odložiť → veta „čo sa zapíše a kam“; nikdy modál cez prácu |
| **Pečať** | potvrdenie s právnym účinkom (lehota, podpis, onboarding) | jediný autorský motion moment (spring 550 ms); reduced-motion = bez animácie |
| **AI badge** | každý blok od agenta | nikdy sa neskrýva |
| **„Overené“ + provenance** | výsledok z overeného zdroja | bez provenance sa „Overené“ nevykreslí |
| **Trust label** | každý konektor | `lokálne` · `vlastný server` · `tretia strana — dáta odchádzajú` (viditeľné na karte) |
| **Register / kolónky / typografický stav** | zoznamy a hlavičky LAWOSS pohľadov | namiesto kariet s ikonkou, pills a eyebrows (zákazy v jazyku v2 §0) |
| **Diagram na pohľad** | každý LAWOSS pohľad | 1 diagram, ktorý nesie informáciu (pás lehôt, timeline, schéma, vrstvy pamäte) — žiadny wall of text |

## 5 · OKF dashboard — ako sa renderujú dáta zo spisu *(rozpracované, feature #1)*

Klik na klienta/spis → **dashboard renderovaný live z OKF markdownov**. Mapovanie súbor → UI:

| OKF zdroj | Čo z neho | Kde v UI |
|---|---|---|
| `spis.md` / `klient.md` frontmatter | sp. zn., súd, klient, protistrana, fáza, advokát | **obal** (kolónky hlavičky) |
| `_STATUS.md` › stav | aktuálna fáza + posledná zmena | stavový riadok + timeline „dnes“ |
| `_STATUS.md` › fakty | kľúčové fakty s odkazmi | Brain panel › Fakty (klik = otvorí súbor na riadku) |
| `_STATUS.md` › úlohy | checkboxy | zoznam úloh |
| `lehoty.md` (JSON front-matter, spec 0005) | potvrdené + kandidáti | pás lehôt / timeline; kandidát = karta brány |
| `MEMORY.md` (TP-xxx) | taktické rozhodnutia | Brain panel › Taktika |
| `AGENTS.md` / `CLAUDE.md` | kontext pre agentov | Nastavenia spisu (klikateľný config) |
| chronológia (`_STATUS.md` + dokumenty) | udalosti | timeline s fázami konania |

Pravidlá renderingu: **read-only parser** (`lawoss/okf/read.ts`), refresh cez file-watch; **zápis vždy len agent cez skill** (novy-spis / lehoty / reconcile) — UI nikdy nezapisuje markdown samo; neparsovateľná sekcia sa zobrazí ako surový markdown s upozornením (nikdy nie ticho vynechaná); config súbory klikateľné → otvoria sa v editore appky. Formát ostáva prenositeľný (Obsidian/Claude Code/opencode bez appky). **Presné schémy súborov = výstup zjednotenia implementácií MČ + VŘ** ([research/okf-implementacie](../../research/okf-implementacie/)) — po zjednotení sa sem doplní kontrakt.

## 6 · Checklist do každého feature PR

- [ ] hodnoty len z tokenov (žiadne hexy) · hranaté radiusy
- [ ] reuse-first: existujúci komponent/plocha? rozšírená, nie nahradená
- [ ] AI badge / Overené+provenance / trust label / karta brány tam, kde vzor platí
- [ ] SK aj CZ strings; AA kontrast; reduced-motion; Windows kontrola pri shellových zmenách
- [ ] `impeccable detect` bez nálezov; screenshot v PR
- [ ] odvolávka na tento dokument (verzia/commit) v popise PR

<sub>Živý dokument — posledná zmena 2026-08-29 (MČ s AI asistenciou). História v gite.</sub>
