# Dizajnový jazyk LAWOSS — „podací denník na tmavom stole“

- **Zostavil:** Marián Čuprík (MČ) s AI asistenciou · 2026-08-23 · **v2** (v1 z toho istého dňa zamietnutá MČ ako „cloud style / AI slop“: karty, pills, eyebrows, ikonky v rohoch, glow)
- **Stav:** 📝 návrh na odklep
- **Živý prototyp:** [`hifi/lawoss-hifi.html`](hifi/lawoss-hifi.html) — Prehľad · Spis + OKF Brain · Kontrola lehoty · Konektory + Marketplace · Reconcile
- **Rozsah:** LegalWork ostáva základom (chat + dashboard + nastavenia navrchu, opencode vzadu, dokument s priamou editáciou). Tento jazyk je **vrstva nad ním**, jasne oddelená od upstreamu, pre 4 tentpoles: OKF Brain · lehoty a dokumenty · MCP · marketplace.
- **Metóda:** smer vybraný z troch svetov (A podací denník · B Zbierka zákonov · C precízny nástroj) podľa postupu *impeccable / new-work*; prototyp prešiel detektorom anti-vzorov (`impeccable detect`, 2026-08-23).

---

## 0 · Svet v jednej vete

**Appka sa správa ako podací denník a spisový obal položené na tmavom stole pod lampou.** Riadky s linajkami namiesto kariet, číslo listu namiesto ikonky, kolónky namiesto eyebrows, registrové záložky namiesto ikonovej navigácie, pečať namiesto zeleného checku. Advokát to pozná naspamäť — preto to nevyzerá ako ďalší SaaS dashboard.

### Čo tento svet zakazuje (vynútiteľné v review)

| ❌ Nikdy | ✅ Namiesto toho |
|---|---|
| karty s ikonkou v rohu, rovnaké v gride; vnorené karty | **register**: riadky oddelené linajkou, číslo listu, pevný stĺpec dátumu |
| pills / odznaky so zaoblením | **typografický stav**: `· potvrdené` `› návrh agenta` `· čaká na doklady` (farba + znak) |
| eyebrow / kicker nad nadpisom | **kolónka**: label v small-caps *vedľa* hodnoty ako na spisovom obale; nadpis sekcie + linka pod ním |
| hero-metric (veľké číslo + label + delta) | čísla v kolónke, 16 px, s poznámkou — nie plagát |
| lucide ikony v navigácii | **registrové záložky** s textom a počtom (mono) |
| glow, zero-offset tiene, glass | jediné svetlo = lampa (radial gradient na stole); list má skutočný tieň s offsetom |
| pulzujúce bodky, progress ringy, sparklines | diagram, ktorý nesie informáciu (pás lehôt, timeline, schéma konektorov, vrstvy pamäte) |
| serif H1 všade | serif iba **pečať a wordmark** |
| wall of text / tabuľka na celú obrazovku | každý pohľad má **jeden diagram** + registre; text má mieru 46–70 ch |

---

## 1 · Farby

Jedna téma: tmavá. Svetlý režim sa **nenavrhuje** (rozhodnutie MČ 2026-08-23); upstream light ostáva funkčný cez tokeny, ale nie je cieľ.

| Token (náš) | Hex | Mapuje sa na `--lw-*` | Použitie |
|---|---|---|---|
| `desk` | `#0A0E14` | `canvas`, `sidebar` | stôl, pozadie okna |
| `sheet` | `#10171F` | `surface` | list registra (hlavná plocha) |
| `sheet-2` | `#141C26` | `surface-hover`, `overlay` | hover riadku, Brain gradient |
| `well` | `#0C1219` | `sunken` | composer, náhľad dokumentu, kalkulácia |
| `rule / rule-2 / rule-3` | `rgba(233,228,218,.08/.14/.26)` | `border-subtle/border/border-strong` | linajky — **vždy 1 px**; `rule-3` iba hlavné deliace čiary |
| `ink` | `#E9E4DA` | `text-primary` | atrament — papierovo teplý, nie studená biela |
| `ink-2` | `#A8B0BA` | `text-secondary` | tintovaný z navy hue (nie sivý) |
| `ink-3` | `#75808C` | `text-tertiary` | labely, meta (4,8:1 na sheet) |
| `gold` | `#C9A24A` | `accent` | **razidlo**: aktívna záložka (2 px hrot), jedna primárna akcia, pečať, „dnes“, návrh agenta |
| `gold-2` | `#E3C46E` | `accent-hover` | hover, hero hodnota v bráne |
| `gold-ink` | `rgba(201,162,74,.18)` | `accent-soft`, `selection` | marker v citácii, výber textu |
| `red / amber / green / blue` | `#D9776B / #D89A4E / #8DBB8F / #7FA3C7` | `danger / warning / success / info` | dnes-zajtra · blízko · potvrdené-pripojené · vlastný server |

Chart paleta (`--chart-1..5`): `gold · ink-2 · green · amber · blue`.

**Pravidlo zlatej:** na jednej obrazovke max. jedna zlatá výplň (tlačidlo) + razidlá (záložka, pečať, „dnes“, `›` pri návrhu agenta). Keď je zlatých vecí viac, uber.

---

## 2 · Písmo

| Rola | Písmo | Prečo |
|---|---|---|
| UI a text | **IBM Plex Sans** 400/500/600 | už bundlovaný upstreamom (`@fontsource-variable/ibm-plex-sans`, overené 2026-08-23) → nulová závislosť; výborné SK/CZ diakritiky; „úradný“ charakter sadí k registru; **nie je Inter** (MČ: „Inter = AI slop“) |
| identifikátory | **IBM Plex Mono** 400/500 | § a ods., spisové značky, IČO, názvy súborov (`_STATUS.md`), čísla listov, kalkulácia lehoty, tool-calls agenta. Nie ako kostým — iba pre dáta a merania |
| pečať, wordmark | **Playfair Display** 500 | jediný serif; nikdy na nadpisy v UI |

Škála: H1 26/1.15 w500 · H2 sekcie 15 w600 · body 14/1.45 · meta 12–12.5 · kolónkové labely `font-variant-caps: all-small-caps` 13 px `.07em` · citácia 17/1.55 max 46 ch · hero hodnota (lehota) 22 w500 gold-2. Číslice vždy `tnum`.

Nová závislosť: `@fontsource/ibm-plex-mono` (🟢). `lawoss/theme/lawoss-tokens.css` nastaví `--lw-font-sans`, `--lw-font-mono`, `--lw-font-serif`.

Brand concept: riadok „Inter — UI“ sa mení na „IBM Plex Sans — UI“ (PR do `docs/brand-concept.md` po odklepe).

---

## 3 · Stavebné prvky (namiesto komponentovej knižnice kariet)

| Prvok | Čo to je | Kde |
|---|---|---|
| **Záložky** (`.tab`) | ľavá navigácia ako registrové záložky zakladača; aktívna je vytiahnutá (−6 px), zrastá s listom, 2 px zlatý hrot; počet v mono | shell — skin upstream sidebaru: priečinky = Spisy, sessions = Asistent, + naše položky |
| **Obal** (`.obal`) | riadok kolónok spisového obalu: small-caps label / hodnota / poznámka, oddelené linkami | hlavička Prehľadu, spisu, reconcile |
| **Register** (`.reg`, `.r`) | sekcia s nadpisom + linkou + meta vpravo; riadky grid: číslo listu · dátum · vec (+ podriadok) · referencia (mono) · stav (typografický) · akcia | všade, kde bol zoznam/karty |
| **Pás lehôt** | SVG: 14 dní, víkendy tlmené, „dnes“ zlatá čiara so svetlom, lehoty ako vlajky v dvoch výškach; potvrdené plné · návrh prerušovaný | Prehľad |
| **Timeline spisu** | SVG: os s pásmi fáz konania pod ňou, udalosti (plné = stalo sa, prerušované zlaté = návrh, obrys = nariadené, prázdne = plánované), „dnes“ | Spis |
| **OKF Brain** | panel s 2 px zlatým hrotom: Stav · Fakty (s mono odkazom na `_STATUS.md`) · Taktika (`MEMORY.md` TP-xxx) · Ďalšie kroky · **diagram vrstiev L1/L2/L3** s tým, čo čaká na zápis | Spis |
| **Brána** (`.gate`) | Zdroj (predpis, mono citácia, citát s markerom, **náhľad dokumentu s locatorom**) ‖ Návrh (kolónky, hero hodnota, kalkulácia v mono, neistota) → 4 akcie → veta „po potvrdení sa zapíše…“ | lehoty, menovci, odoslanie e-mailu, zápis do pamäte |
| **Pečať** (`.seal`) | SVG okrúhla pečať, Playfair po obvode, dopadne vedľa potvrdenej hodnoty (spring 550 ms, rotácia −8°) | potvrdenie v bráne, podpis, dokončenie onboardingu |
| **Prijímacia pečiatka** | ghost v rohu: `LAWOSS · došlo 23. 08. 2026 · 09:14 · 3 na rozhodnutie` (mono, 55 %) | Prehľad — jediný „delight“ na domovskej obrazovke |
| **Diff + poznatok** | dvojstĺpcový diff (v1 agent / v2 advokát, del/ins tintované) → panel „Čo si agent chce zapamätať“: pravidlo s markerom, výber vrstvy L1/L2, dôkaz | Reconcile |
| **Schéma konektorov** | SVG: LAWOSS → opencode (skills, prompty, *žiadny nástroj na odoslanie*) → konektory so stavom a trust labelom | Konektory |
| **Composer** | LegalWork chat vstup, prilepený dole, s kontextom (`prax` / `ABC v. DEF`) v mono zlatom | Prehľad, Spis — chat nezmizol, je v spise |
| **Agent line** | posledná správa agenta ako jeden odsek so zlatou bodkou + riadok tool-callov v mono | nad composerom |

Stavové slová: `· potvrdené` green · `› návrh agenta` gold · `· čaká na …` amber · `· nenájdený` amber · `· vypnuté` ink-3. Trust label konektora: `lokálne` green · `vlastný server` blue · `tretia strana · dáta odchádzajú` amber.

---

## 4 · Motion

Jeden autorský moment: **pečať**. Ostatné je ticho: záložka sa vysunie 220 ms `ease-standard`; riadok hover 120 ms; `dnes` na páse má statické svetlo (žiadne pulzovanie). Upstream tokeny `--lw-ease-*`, `--lw-duration-*` + nový `--lw-duration-seal: 550ms`. Všetko pod `prefers-reduced-motion` → pečať sa objaví bez animácie. Žiadne staggered entrances na každej sekcii.

---

## 5 · Prehliadačové plochy, ktoré tiež nesú dizajn

`::selection` zlatý atrament · scrollbar tenký v `rule-2` · focus ring 1,5 px zlatý s 3 px odsadením · `color-scheme: dark` (natívne ovládacie prvky) · caret v `ink`. V Electrone: titlebar plocha v `desk`, `titlebar-drag` ostáva.

---

## 6 · Kontrola kvality pred merge

`ink-3` na `sheet` 4,8:1 · `ink-2` 8,1:1 · `gold` na `desk` 7,7:1 · `desk` text na `gold` 7,7:1 (overené výpočtom 2026-08-23). Detektor: `node …/impeccable/scripts/detect.mjs <súbor>` — cieľ 0 nálezov okrem známych (Google Fonts link v prototype; v appke idú fonty cez @fontsource). Windows: IR skontroluje Plex Sans rendering a záložky na 125 % škálovaní.

---

<sub>v2 · MČ s AI asistenciou · 2026-08-23. Referencie, ktoré MČ poslal (impeccable.style, tasteskill.dev, refero styles, 21st.dev, aceternity) prešli 2026-08-23; z nich vzaté: zákaz eyebrow/karty/pills/hero-metric (impeccable craft-floor), pomenovanie sveta miestom (refero), a vedomé **nepoužitie** marketingových efektov (aurora, beams, 3D karty — 21st/aceternity) v nástroji na prácu.</sub>
