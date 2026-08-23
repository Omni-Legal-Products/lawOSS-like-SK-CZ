# Dizajnový jazyk LAWOSS — tokeny, typografia, motion, vzory

- **Zostavil:** Marián Čuprík (MČ) s AI asistenciou · 2026-08-23
- **Stav:** 📝 návrh na odklep · **nie reskin LegalWorku, samostatný jazyk** realizovaný cez upstream token architektúru
- **Živý prototyp:** [`hifi/lawoss-hifi.html`](hifi/lawoss-hifi.html) *(self-contained; 4 obrazovky + tokeny; prepínač dark/light)*
- **Nadväzuje na:** [brand concept](../brand-concept.md) · mockupy 01–10 (21. 8.) · [audit](2026-08-23-audit-sucasnej-appky.md) · [ADR 0009 doktrína](../../decisions/0009-zakladna-produktova-doktrina.md) · [ADR 0007 agent-first](../../decisions/0007-agent-first-architektura.md)

---

## 0 · Téza v jednej vete

**Tmavý navy ako pracovný stôl advokáta, zlatá ako pečať rozhodnutia.** Všetko ostatné je tiché: hairline linky, veľkorysý priestor, presné identifikátory. Zlatá sa *zarába* — objaví sa iba tam, kde advokát rozhoduje alebo kde je zdroj overený. Keď je na obrazovke zlatých vecí veľa, dizajn zlyhal.

### Tri rozhodnutia, ktoré robia jazyk unikátnym (nie generickým „dark premium")

1. **Zlatá nie je dekorácia, je sémantika.** Plná zlatá výplň = *jedna* primárna akcia na obrazovke (Potvrdiť, Nový spis). Zlatý rám + glow (`card-gold`) = *čaká na rozhodnutie advokáta*. Zlatý odznak = *Overené* (zdroj s provenance). Nič iné zlaté nie je.
2. **Mono písmo pre právne identifikátory.** `§ 362 ods. 1 CSP`, `15C/123/2024`, `IČO 35 763 469`, `_STATUS.md` — všetko v Geist Mono. Čitateľ na prvý pohľad vie: *toto je presný odkaz, nie próza.* To je náš ekvivalent „štruktúra je informácia".
3. **Serif hovorí hlasom produktu, nie UI.** Playfair iba na H1 obrazovky, hero čísla a názov *Matter Brain*. Nikdy na labely, tlačidlá, tabuľky. Vďaka tomu serif zostane vzácny a obrazovky dostanú „právnickú" gravitas bez toho, aby sa z appky stal časopis.

Jedno vedomé riziko: **warning je oranžová, nie zlatá** (`#E08A3C`). Brand paleta má iba navy + zlatú; keby upozornenia boli zlaté, stratila by sa sémantika bodu 1.

---

## 1 · Farebný systém

### 1.1 Rampy

| Token | Hex | Použitie |
|---|---|---|
| `navy-950` | `#070E17` | sidebar (najhlbšia plocha) |
| `navy-900` | `#0A1420` | **canvas** (dark) |
| `navy-850` | `#0D1B2A` | brand navy (logo, light-mode sidebar, primárne tlačidlo light) |
| `navy-800` | `#112233` | elevated / popover |
| `navy-700` | `#16293D` | surface-hover |
| `navy-500` | `#2B4258` | border-strong @ light, avatar |
| `navy-300` | `#5B7188` | placeholder @ dark |
| `navy-100 / 50` | `#C9D3DE / #EEF2F6` | sidebar text, light sunken |
| `gold-700` | `#8C6A1F` | **akcent v light móde** (text/ikony na bielom, AA 5,0:1) |
| `gold-600` | `#A8832E` | hover @ light |
| `gold-500` | `#C9A24A` | **akcent v dark móde**, zlatá výplň v oboch módoch |
| `gold-400` | `#D8B45E` | hover @ dark |
| `gold-300 / 100` | `#E6C97F / #F3E7C6` | marker citácie, glow |

### 1.2 Sémantické tokeny (mapa na upstream `--lw-*`, **value-only**)

| `--lw-*` | Dark (primárny) | Light (sekundárny) |
|---|---|---|
| `canvas` | `#0A1420` | `#F6F7F9` |
| `surface` / `surface-hover` | `#0F1D2E` / `#142538` | `#FFFFFF` / `#F1F3F6` |
| `sunken` | `#081019` | `#EDF0F4` |
| `sidebar` | `#070E17` | **`#0D1B2A`** *(sidebar ostáva navy aj v light — kotva značky)* |
| `text-primary / secondary / tertiary` | `#F2F4F7 / #A9B4C2 / #7D8A99` | `#0D1B2A / #42586E / #66758A` |
| `accent / accent-hover / accent-fg` | `#C9A24A / #D8B45E / #0A1420` | `#8C6A1F / #A8832E / #FFFFFF` |
| `accent-soft` | `rgba(201,162,74,.12)` | `rgba(201,162,74,.14)` |
| `accent-border` | `rgba(201,162,74,.55)` | `rgba(140,106,31,.45)` |
| `primary / primary-fg` | `#F2F4F7 / #0A1420` *(upstream sémantika: inverzná výplň — ponechať)* | `#0D1B2A / #FFFFFF` |
| `border-subtle / border / border-strong` | `rgba(255,255,255,.06/.10/.18)` | `rgba(13,27,42,.07/.12/.22)` |
| `success / warning / danger` | `#5CC08A / #E08A3C / #E06C6C` | `#1F7A4C / #B4560F / #B3261E` |
| `focus-ring` | `0 0 0 2px canvas, 0 0 0 4px #C9A24A` | rovnako |
| `shadow-md` | `0 12px 32px -12px rgba(0,0,0,.6)` | `0 6px 20px -8px rgba(13,27,42,.18)` |
| **nové** `--lw-glow` | `0 0 0 1px rgba(201,162,74,.45), 0 0 32px -6px rgba(201,162,74,.45)` | slabšia |
| **nové** `--lw-marker` | `rgba(201,162,74,.26)` | `.22` |
| `--chart-1..5` (index.css) | `#C9A24A #5B7188 #5CC08A #E08A3C #A9B4C2` | `#8C6A1F #2B4258 #1F7A4C #B4560F #66758A` |

**Kontrast (overené výpočtom 2026-08-23):** gold-500 na canvas 7,7:1 · gold-700 na bielom 5,0:1 · navy na zlatej výplni 7,7:1 · secondary 8,1 / 7,4 · tertiary 4,8 / 4,7 · warning 6,4 / 4,9 · success 7,6 / 5,3 · danger 5,3 / — . **`#C9A24A` na bielom = 2,4:1 ✗ — nikdy ako text v light móde.**

### 1.3 Hierarchia plôch

`sidebar (950)` → `canvas (900)` → `surface (card)` → `sunken (vnorené bloky: kalkulácia, code, input)`. Rozdiely sú 3–6 % jasu — hĺbku robia **hairline bordery**, nie tiene. Tieň iba: popover/menu (`shadow-md`), hover lift karty (`translateY(-1px/-2px)` + `shadow-md`).

---

## 2 · Typografia

| Rola | Písmo | Veľkosť / riadok | Váha | Kde |
|---|---|---|---|---|
| **display** | Playfair Display | 30 / 1.15, letter-spacing −.01em | 400 | H1 obrazovky |
| **hero číslo** | Playfair Display, `tnum` | 40 / 1 | 400 | StatCard, navrhovaná lehota (22) |
| **h2** | Playfair Display | 24 / 1.2 | 400 | sekcie v dlhých dokumentoch |
| **h3** | Inter | 15 / 1.4 | 600 | nadpis karty |
| **body** | Inter | 14 / 1.5 | 400 | základ; `cv11 ss01 tnum` |
| **body-lg** | Inter | 15.5 / 1.6 | 400 | citácie, dlhé texty v DecisionGate |
| **caption** | Inter | 12–12.5 / 1.4 | 400 | meta, dátumy |
| **eyebrow** | Inter | 11, `.12em`, uppercase | 600 | labely sekcií (Zdroj, Stav, Kľúčové fakty) |
| **mono** | Geist Mono | 12 (0.92em) | 400–500 | §, spisové značky, IČO, súbory, kalkulácia |
| **kbd** | Geist Mono | 10.5 | 500 | klávesové skratky |

Pravidlá: serif **≥ 18 px** (Windows ClearType); nikdy serif bold; číselné stĺpce vždy `tabular-nums`; max šírka textu 64 ch v čítacích blokoch; **sentence case** všade (žiadne Title Case v tlačidlách).

Závislosť: `@fontsource-variable/playfair-display` (🟢 dep v `apps/app`), import v `lawoss/theme/fonts.css`. Inter Variable a Geist Mono už sú.

---

## 3 · Tvar, priestor, hustota

- **Radius:** `sm 6` (badge, kbd, chk) · `md 8` (button, input, ikona) · `lg 10` (veľké tlačidlá) · `xl 12` (card) · `2xl 16` (seal, modal) · `full`. Upstream hodnoty, bez zmeny.
- **Spacing scale:** 4 / 8 / 12 / 16 / 20 / 24 / 36 / 48. Karta `p-20`, grid gap `16`, stránka `28 36`.
- **Grid:** sidebar 232 px fixný + obsah `max-width 1400`. Dashboard `1.1fr 1fr .9fr`; spis `1fr 1.1fr .95fr` (timeline · úlohy/dokumenty · Matter Brain). Pod 1100 px 2 stĺpce, pod 800 px 1 stĺpec + skrytý sidebar (drawer).
- **Hustota:** riadky zoznamov 40–44 px (advokát klikne myšou, nie prstom), tabuľky 36 px. Čítacie bloky (citácie, dokument) majú väčšie písmo a riadkovanie než UI okolo — **čitateľnosť dlhého textu má prednosť pred hustotou**.
- **Hairline vždy `1px`**, nikdy 2 px okrem focus ringu a aktívneho gold railu v sidebari (2 px).

---

## 4 · Motion & small delights

Všetko na existujúcich tokenoch `--lw-ease-standard (.2,0,0,1)`, `--lw-ease-out (.16,1,.3,1)`, `--lw-ease-spring (.34,1.56,.64,1)`, `120/160/220 ms` + **nový `--lw-duration-seal: 600ms`**. Všetko pod `@media (prefers-reduced-motion: reduce)` → bez animácií (transitions aj keyframes).

| Moment | Animácia | Tokeny | Prečo |
|---|---|---|---|
| Vstup obrazovky | staggered rise kariet: `opacity 0→1, translateY 6px→0`, delay 40 ms/karta, max 6 | `slow`, `ease-out` | obrazovka „sa usadí", nie vybuchne |
| Hover karty konektora / riadku | `translateY(-2px)` + border → `accent-border` | `base`, `ease-out` | ticho potvrdí klikateľnosť |
| Checkbox úlohy | spring scale 0.4→1 zlatého checku | `base`, `ease-spring` | jediný „hravý" spring okrem brány |
| **DecisionGate → Potvrdiť** | tlačidlo 1 px lift; potom **Seal moment**: disk `scale .86→1` spring 600 ms, check sa *kreslí* (`stroke-dashoffset 40→0`, 500 ms, delay 250 ms), auto-zavrie po 1,8 s | `seal`, `ease-spring`, `ease-out` | fyzická metafora pečate — advokát *niečo potvrdil*, nie klikol |
| Podpis / konverzia hotová | rovnaký Seal moment, iná ikona (pero / dokument) | | konzistentný jazyk „hotovo s právnym účinkom" |
| Timeline progress | gradient čiary `--progress` animovaný z 0 na aktuálnu hodnotu pri otvorení (400 ms) | `ease-standard` | „kde sme vo veci" |
| Skeleton → content | skeleton fade-out 120 ms, content rise | `fast` | bez preskoku layoutu |
| Status dot pripojené | jemný glow `box-shadow 0 0 6px`, **bez pulzovania** | — | pulzovanie = úzkosť |
| Toast | upstream `lw-toast-in` | — | reuse |
| `more →` link | `gap 6→9px` na hover | `fast` | šípka „ide" |

**Čo zámerne nerobíme:** parallax, glassmorphism, gradientové tlačidlá (jediný gradient: Matter Brain surface→sunken), pulzujúce bodky, animované pozadia (upstream `PaperGrainGradient` nahradíme statickým navy s jemným vignette).

---

## 5 · Komponentové vzory pre doktrínu „AI pod kontrolou advokáta“

Toto je jadro — dizajnové pravidlá, ktoré robia ADR 0007/0009 **viditeľnými**.

### 5.1 DecisionGate (rozhodovacia brána)

Každý návrh agenta s právnym účinkom sa zobrazuje **iba** cez tento vzor:

```
┌ Zdroj ───────────────────────┐ ┌ Návrh agenta ──── istota ▮▮▮▯ ┐
│ Názov predpisu (serif)       │ │ kľúč  →  hodnota (mono/tnum)   │
│ mono citácia + verzia znenia │ │ navrhovaná hodnota (serif gold)│
│ „citát s <mark>markerom</mark>“│ │ ▢ kalkulácia (mono, sunken)    │
│ [Overené · Slov-Lex] [locator]│ │ ⚠ neistota: čo skontrolovať    │
└──────────────────────────────┘ └────────────────────────────────┘
┌ [■ Potvrdiť]  [Upraviť]  [Odmietnuť]  [Odložiť] ─ ⏎ E Esc · „Po potvrdení: …“ ┐
```

Pravidlá: (1) Zdroj je **vždy vľavo/prvý** — advokát číta zdroj pred návrhom. (2) Iba **Potvrdiť** má zlatú výplň; Odmietnuť je sekundárne s červeným textom, nie červené tlačidlo (aby odmietnutie nebolo „nebezpečné", je legitímne). (3) **Auditná veta** pod akciami hovorí presne, čo sa zapíše a kam (`spis.md`, ICS, audit). (4) Istota je **vizuálny meter + slovo** (nízka/stredná/vysoká), nie percento — percento by sugerovalo presnosť, ktorú model nemá. (5) Bez zdroja s provenance sa brána **nezobrazí** — agent musí dodať `source_ref + locator` (spec 0005).

### 5.2 SourceBadge „Overené“

Zlatý outline odznak s checkom + názov zdroja (`Overené · Slov-Lex`). Zobrazuje sa **iba** ak výsledok prišiel z overeného konektora s časom získania. Bez neho = výsledok je „návrh" (`badge-ai` s bodkou). Hover → tooltip s provenance (zdroj, verzia, čas, locator).

### 5.3 AI badge

Sivý outline + zlatá bodka s glow. Označuje **každý** blok, ktorý napísal agent. Nikdy sa neskrýva.

### 5.4 Matter Brain panel

Gradient surface→sunken, zlatý rám + glow (je to „čo agent vie o veci"). Sekcie: Stav · Kľúčové fakty (s mono odkazom na riadiaci súbor) · Ďalšie kroky (návrh agenta) · pätička *aktualizované · provenance ✓* + akcia **Navrhnúť zápis** (nie „Uložiť" — zápis do pamäte ide cez bránu, ADR 0007 pravidlo 4).

### 5.5 Trust label konektora

Tri stavy, vždy viditeľné na karte: `beží lokálne` (neutrálny) · `vlastný server` (neutrálny) · **`dáta odchádzajú z počítača`** (warning) pre servery tretích strán. Plus `read-only` a `Overený zdroj`. Spec 0011 B požaduje, aby to nebolo skryté — preto je to na karte, nie v detaile.

### 5.6 Stavové vzory

- **Empty state:** serif jednoriadková veta + jedna zlatá akcia („Zatiaľ žiadne lehoty. Agent ich nájde v doručených dokumentoch. → Skontrolovať dokumenty").
- **Chyba konektora:** oranžový badge + veta čo sa stalo + čo spraviť; **nikdy** „prázdny výsledok" prezentovaný ako čistý (spec 0004/0011 canary).
- **Loading:** skeleton v tvare cieľového layoutu, bez spinnera na celú obrazovku.

---

## 6 · Svetlý režim

Sekundárny, ale plnohodnotný. Tri pravidlá: sidebar ostáva navy (kotva značky), akcent je gold-700 (AA), zlatá výplň tlačidla zostáva gold-500 s navy textom. Testovať každú obrazovku v oboch módoch (prototyp má prepínač).

---

## 7 · Čo z toho je „taste“ a čo je pravidlo

Pravidlá (vynútiteľné v review): sekcie 1–3, 5.1–5.5, kontrast AA, reduced-motion. Taste (dizajnér rozhoduje per obrazovka): konkrétne rozloženie gridu, kde použiť serif H2, ktorá akcia je „tá jedna zlatá". Ak si pri obrazovke nie si istý, **uber zlatú**.

---

<sub>Návrh MČ s AI asistenciou 2026-08-23. Hodnoty kontrastu vypočítané (WCAG 2.x relative luminance) 2026-08-23. Prototyp používa Google Fonts link s plnými fallbackmi — v appke idú fonty cez @fontsource (offline).</sub>
