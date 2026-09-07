# Podklad VŘ na call 7. 9. 2026 (10:00) — OKF pamäť

- **Pripravil:** Vojta Říha (VŘ) · 3. 9. 2026
- **Pre:** MČ, MF, IR
- **Nadväzuje na:** [výsledky brány D1 z 1. 9.](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/66#issuecomment-5493899679)

---

## V piatich riadkoch

1. **Jadro je hotové a merge-ready** — reťaz troch PR, 414 testov, CI zelené. Blokuje ho už len review.
2. **D8 (kolízia s Fázou A) sa vyriešil bez rozhodnutia** — boli to dva rôzne nástroje na tej istej ceste; presun do `lawoss/okf-pamat/` stačil.
3. **Google vydal „Open Knowledge Format", skratka OKF.** Naše `memory/` je odteraz jeho konformný bundle. Otázka mena je na vás.
4. **Test na 10 skutočných konaniach z ISIR** našiel 9 vád, ktoré 390 testov s vymyslenými dátami nevidelo. Všetky opravené.
5. **Sťahujem námietku k úlohe 12** (markdown odkazy) — MČ mal pravdu. **Trvám na námietke k bodu c** (`L3_LEAK`) — ISIR dal nové argumenty.

---

## Stav PR

Poradie merge je dané základňami: **#24 → #31 → #35**. Každý ďalší mieri do predchádzajúceho, aby recenzent videl len prírastok.

| PR | Čo | Stav |
|---|---|---|
| [lawoss#24](https://github.com/Omni-Legal-Products/lawoss/pull/24) | pamäťové jadro: 9 typov, 5 brán, AML, dôkazná vrstva | `mergeable`, 5/5 CI, **čaká na approve** |
| [lawoss#31](https://github.com/Omni-Legal-Products/lawoss/pull/31) → #24 | trvalé poverenie — agentné zápisy bez potvrdzovania | `mergeable` |
| [lawoss#35](https://github.com/Omni-Legal-Products/lawoss/pull/35) → #31 | Obsidian vault · zhoda s OKF v0.2 · opravy z ISIR | `mergeable`, +2241/−260 |
| [coord#66](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/66) | plán 16 úloh — **prepísaný podľa D1** + rozbor D6/D7 | otvorený |
| [coord#68](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/68) | plán nasadenia do aplikácie (fáza C1–C3) | otvorený |
| [coord#69](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/69) | naše OKF × Google OKF — kolízia mena | otvorený |

> Poznámka k CI: #31 a #35 mieria do feature vetvy, takže na nich testovacie joby nebežia. Lokálne 414/414; po zlúčení #24 sa preretargetujú na `dev` a CI ich prebehne.

---

## Čo sa zmenilo v rozhodnutiach od 1. 9.

### D8 — vyriešené, ostáva len kozmetika

Fáza A (`84256f6`) založila `lawoss/okf/`, tento PR sa dostal do konfliktu. Pri pohľade dovnútra: **`@lawoss/okf` (binárka `okf`) zakladá priečinok spisu, `@lawoss/okf-pamat` (binárka `okf-memory`) vedie pamäť vnútri neho.** Kolidovali tri cesty, jediné spoločné slovo `validate`, každý validuje niečo iné. Presun bez jedinej zmeny kódu.

**Na call:** len či balíčky dlhodobo zliať do jedného. Nič neblokuje.

### Úloha 12 — námietka stiahnutá

Tvrdil som, že vault potrebuje `[[wiki-odkazy]]`. **Bol to omyl:** `[[S-001]]` v Obsidiane nikdy nesadol, lebo súbor nesie v názve aj slug. Markdown odkaz mieri na skutočný súbor, funguje v Obsidiane aj mimo neho a je to tvar, ktorý žiada OKF. Podmienka MČ je **splnená**, nie obídená.

### O1 podmienky — stav po kusoch

| Podmienka MČ | Stav |
|---|---|
| markery do existujúcich sekcií | ✅ hotové; `init` zakladá kostru so všetkými piatimi blokmi, existujúci súbor sa nemení |
| markdown odkazy namiesto `[[…]]` | ✅ hotové |
| oprava maskovania driftu cez `sync` (úloha 11) | ⛔ čaká na výber z troch variantov |
| SSOT lehôt (úloha 13) | ⛔ rozhodnutie, **musí padnúť pred migráciou** |

---

## Google „Open Knowledge Format" — čo to pre nás znamená

Jún 2026, Google Cloud, vendor-neutrálna spec pre agentmi čitateľné znalosti: adresár markdownu s YAML frontmatterom, `type` ako jediné povinné pole, `index.md`, `log.md`. Doména `okf.md`, blog Google Cloud, komerční sprievodcovia. **Kto si vygoogli „OKF", nájde ich.**

Formáty sa nezávisle zbehli k tomu istému — preto som zladenie **urobil** (v #35):

- `memory/` je bundle, `index.md` a `log.md` sú rezervované, koreňový index nesie `okf_version: "0.2"`
- `summary` → `description`, `tags` je pole schémy, neznáme kľúče sa zachovajú
- **`sources[]` so stabilným `id` a atribúcia jednotlivého tvrdenia `[^id]`** — presne to, čo advokát robí v každom podaní; z toho `CITATION_UNRESOLVED` ako chyba (veta vyzerá podložene a nie je)
- `verified[]` ako zoznam overení
- dve vedomé odchýlky (rozbitý odkaz a neznámy `type` sú u nás chyba, nie tolerovaná neznalosť) — zdôvodnené v `OKF-ZHODA.md`

**Na call:** A premenovať / B ignorovať / **C profil ich formátu**. Odporúčam C: skratka zostáva, kolízia sa mení na kompatibilitu, a mení to úlohu 15 — namiesto vlastného JSON Schema publikujeme profil existujúceho štandardu.

---

## Test na 10 konaniach z ISIR — prečo to stojí za zmienku

66 záznamov cestou agenta cez CLI, dáta zostali v scratchpade. Sedem súdov, obe odvolacie inštancie, výber zámerne na záťaž. **Deväť vád, ktoré vymyslené dáta neukázali:**

| Vada | Dôsledok, kým bola | Stav |
|---|---|---|
| **IČO s vedúcou nulou sa ukladalo bez nej** (`04920040` → `4920040`) — 4 z 12 IČO vo vzorku | nesprávny údaj vyzerá ako overený; jehla úniku zo zlého čísla nikdy nesadla → **prameň s IČO subjektu prešiel bránou** | ✅ |
| firma so spojkou „a" nebola jehlou (`Kolář a Klaudy v.o.s.`) | únik do L3 | ✅ |
| hodnoty mimo výpočet sa nekontrolovali; `person_type: natural` **potichu vypol AML kontrolu** | tichá strata zákonnej kontroly | ✅ `UNKNOWN_VALUE` — hneď našlo SK zvyšky v našich vlastných fixturách |
| rodné číslo vo voľnom texte nebolo jehlou (výrok opísaný do otázky) | únik do L3 | ✅ |
| uplynutá lehota bez nálezu, úloha po termíne s nálezom | asymetria v neprospech tej horšej | ✅ `DEADLINE_PASSED` |
| matica dôkazov a úlohy sa na novej veci nikdy neukázali | MARKER_ONLY bez kostry | ✅ `init` |
| L1/L3 zostávali v spise; kancelária prázdna | zdieľateľné poznanie stratené | ✅ smerovanie, jehly zo spisu pôvodu |
| klientský `memory/` bez indexu, subjekty v projekcii neviditeľné | AML evidencia v spise neviditeľná | ✅ |
| kolízia `A-001` naprieč vecami v spoločnej kancelárii | 9 z 11 prameňov sa nezapísalo s nezrozumiteľnou hláškou | ✅ `created` je nemenné → iný záznam, CLI navrhne voľné id |

Vedome nerobím: **opakovanú lehotu** (štvrťročné správy správcu). Zapíše sa ako výčet dátumov; počítanie lehôt patrí lehotníku.

Pri opravách vyšli ešte dve vady CLI: `findOfficeDir` z kancelárie odmietal vrátiť seba (zápis L1 priamo do `_kancelaria/` nikdy nemal poverenie) a audit riadok vracal `updated` dozadu s neošetreným pádom. Obe opravené.

---

## Na rozhodnutie 7. 9.

| # | Otázka | Odporúčanie VŘ |
|---|---|---|
| 1 | **Approve reťaze #24 → #31 → #35** | zlúčiť v tomto poradí; kód na žiadne rozhodnutie nižšie nečaká |
| 2 | **Meno OKF: A / B / C** | **C — profil Open Knowledge Format**; mení úlohu 15 na lacnejšiu |
| 3 | **Bod c — `L3_LEAK`** | **ponechať.** Nie je to human gate, chráni mlčanlivosť (ČR § 21 zák. č. 85/1996 Sb., overené; SK ustanovenie doplní MČ), beží iba nad L3. ISIR: chytila IČO aj RČ z výroku — a ukázala, ako ľahko sa oslepí. Ak ju rušíme, `zjednotenie.md` prestane tvrdiť štyri brány. |
| 4 | **Úloha 11 — drift cez `sync`** | vybrať z troch variantov (obnoviť mtime / `human_updated:` / freshness voči `spis.md`); odporúčam **obnoviť mtime** — najmenší zásah |
| 5 | **Úloha 13 — SSOT lehôt** | rozhodnúť **pred** migráciou; návrh: `deadlines` v zázname je jediný zdroj, frontmatter `spis.md` sa renderuje |
| 6 | **O7 prahy** | vecne hotové; `_kancelaria/okf.config` už existuje (#31) — zostáva len prahy doň zapojiť. Áno/nie. |
| 7 | **Prehľad a Lehoty** (coord#68) | v registry vedené na MČ; **prevzatie potvrdiť.** `read.ts` navrhujem v `okf-pamat`, lebo číta pamäť, nie štruktúru |
| 8 | **`log.md` × blok Chronológia** | dnes existuje oboje; `log.md` je generovaný, druhý zdroj pravdy nevzniká. Nechať oboje, alebo jedno? |
| 9 | **`EVENT_KINDS` sú slovenské** (`dorucenie`, `pojednavanie`) — odporuje O6 | premenovať pri migrácii (úloha 10), nie teraz |
| 10 | **Pilot migrácie** (úloha 10, podmienka MČ O2) | jeden reálny spis — čí a kedy? |

## Čo VŘ neurobí bez odklepu

Úlohy 11, 13, 14 (rozhodnutia vyššie) · migrácia 10 (klientské dáta) · zliatie balíčkov · premenovanie `EVENT_KINDS` · zápis z UI (fáza C je zámerne read-only).

## Kde čo nájsť

- `lawoss/okf-pamat/README.md` — päť brán, nálezy validácie, CLI
- `lawoss/okf-pamat/OKF-ZHODA.md` — mapovanie polí na Google OKF, dve odchýlky s dôvodmi
- `lawoss/okf-pamat/OBSIDIAN-VAULT.md` — napojenie na vault, čo sa deje pri prechode oboma smermi
- `lawoss/okf-pamat/AGENTNI-ZAPISY.md` — trvalé poverenie: čo vypína a čo nie
- `docs/superpowers/plans/2026-09-01-okf-pamat-dalsie-prace.md` — plán s D1 a rozborom D6/D7
