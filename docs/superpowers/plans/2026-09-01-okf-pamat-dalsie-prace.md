# OKF pamäť — plán ďalších prác

> **Pre agentných pracovníkov:** POVINNÝ SUB-SKILL: použi `superpowers:subagent-driven-development` (odporúčané) alebo `superpowers:executing-plans` a implementuj tento plán úlohu po úlohe. Kroky sú `- [ ]` na odškrtávanie. **Úlohy sa berú v poradí**; kde je uvedená brána rozhodnutia, nepokračuj bez nej.

**Cieľ:** doviesť pamäťové jadro OKF ([PR #24](https://github.com/Omni-Legal-Products/lawoss/pull/24)) z prototypu do stavu, ktorý znesie merge a reálne spisy.

**Architektúra:** markdown v spise, typované záznamy `Pravda` × `História`, brány zápisu v nástroji. Bez runtime závislostí, mimo pnpm workspace, Node 24+ s natívnym TypeScriptom.

**Tech stack:** TypeScript (strict, `erasableSyntaxOnly`), `node --test`, pnpm 11.4.0 s `--ignore-workspace`.

**Spec:** [`research/okf-implementacie/zjednotenie.md`](../../../research/okf-implementacie/zjednotenie.md) (VŘ) · [`specs/0014-okf-1-kanonicky-kontrakt.md`](../../../specs/0014-okf-1-kanonicky-kontrakt.md) (MČ, PR #64) · [`research/okf-implementacie/stanovisko-mc.md`](../../../research/okf-implementacie/stanovisko-mc.md) · [`research/okf-implementacie/review-pr24.md`](../../../research/okf-implementacie/review-pr24.md)

---

## Global Constraints

Platia pre **každú** úlohu, netreba ich opakovať:

- **Pracovný adresár:** `lawoss/okf/` vo forku `Omni-Legal-Products/lawoss`, vetva `feat/okf-pamat`, worktree `~/Projects/lawoss/_worktrees/feat-okf-pamat`.
- **Testy:** `pnpm test` = `node --test 'tests/**/*.test.ts'`. Pred commitom musí byť **0 fail** a `pnpm typecheck` exit 0.
- **Inštalácia:** `pnpm install --ignore-workspace --frozen-lockfile`. Nikdy `npm` ani `yarn`.
- **TDD bez výnimky:** test najprv, spusti ho, over že padá zo správneho dôvodu, až potom implementácia.
- **Zóny:** píš iba do `lawoss/okf/**` a `.github/workflows/ci-okf-pamat.yml`. Zmena akéhokoľvek upstream súboru = riadok do `PATCHES.md` v tom istom PR. Nové LAWOSS súbory záznam nepotrebujú.
- **Commit správy po slovensky**, formát `typ: čo` (`feat:`, `fix:`, `docs:`, `test:`, `chore:`).
- **Žiadne klientske dáta** v testoch ani v commitoch — fixture sú vymyslené.
- **Cudziu implementáciu nemeníš.** `research/okf-implementacie/mc-novy-spis/` je referenčný snapshot MČ; pripomienky patria do `zjednotenie.md`, nie do jeho súborov.
- **Históriu neprepisuj** (žiadne vynútené pretlačenie vetvy) a nikdy nepíš priamo do `dev` ani do `main`.

---

## Odkiaľ úlohy pochádzajú

| Zdroj | Čo z neho je |
|---|---|
| [`review-pr24.md`](../../../research/okf-implementacie/review-pr24.md) (MČ, 29. 8.) | nálezy N1–N8, verdikt „merge po oprave N1 a N2" |
| [`stanovisko-mc.md`](../../../research/okf-implementacie/stanovisko-mc.md) (MČ, 29. 8.) | podmienky k O1, nové body O6 a O7 |
| [`zjednotenie.md`](../../../research/okf-implementacie/zjednotenie.md) (VŘ, 29.–31. 8.) | otvorené body O1–O5 |
| [PR #64](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/64) | spec 0014 kanonický kontrakt, agenda callu |
| skill `/legal` a jeho 14 agentov (VŘ, prevádzka) | schémy záznamov pre dôkaznú vrstvu, úlohy a provenance L3 — **fáza 3b** |

**Stav nálezov k 1. 9. 2026** — over pred začatím, časť je už hotová:

| Nález | Stav |
|---|---|
| N5 jeden pokazený záznam zhodí store | ✅ **hotové** (commit `a4b540e`) — v úlohe 6 zostáva len premenovať kód na `PARSE_ERROR` |
| N7 `L3_LEAK` falošné nálezy | ✅ **hotové** (commit `55159fb`) — celé slovo, meno → `warning`, identifikátory → `error`. Kryje väčšinu O7. |
| N6 čiarka v zozname | ✅ **hotové 1. 9.** (commit `1a42187`) — úloha 1 dokončená |
| N2 duplicitné sekcie | ✅ **hotové 1. 9.** (commit `2e071a8`) — úloha 2 dokončená |
| N3 štvrtá brána mimo zápisu | ❌ otvorené — **úloha 3** |
| N4 `Approval` self-declared | ❌ otvorené — **úloha 4** |
| N1 `init` nezaloží adresár | ⊘ **zaniká** rozhodnutím O6 — jeden `memory/`, jurisdikcia je hodnota poľa. Rieši sa zrušením `detect()` v úlohe 8. |
| N8 drobnosti | ❌ otvorené — **úloha 6** |

---

## D1 — Brána rozhodnutia (call 1. 9. 2026, 10:30)

**Toto nie je úloha na implementáciu. Je to brána.**

Po čiastočnom rozhodnutí z 1. 9. (O6, viď nižšie) už brána **neblokuje paušálne**. Čo je odblokované a čo nie:

| Úlohy | Stav brány |
|---|---|
| 4 (`Approval`), 6 (drobnosti), 7 (súbeh) | ✅ **odblokované** — na O1 ani O6 nezávisia |
| 8 (angličtina), 10 (migrácia), 17–21 (fáza 3b) | ✅ **odblokované** rozhodnutím O6 |
| 5 (`init`) | ⊘ **zrušená** rozhodnutím O6 |
| 11, 12, 13 (drift, odkazy, SSOT lehôt) | ⛔ **stále blokované** — závisia od O1, ktoré rozhodnuté nie je |
| 14 (konfigurovateľné prahy) | ⛔ **stále blokované** — závisí od O7 |

Na hlasovanie idú body O1–O7 podľa [`stanovisko-mc.md`](../../../research/okf-implementacie/stanovisko-mc.md). Pre kód sú rozhodujúce dva:

- **O6 — kanonická angličtina v jadre.** Ak prejde: `pamet/`/`pamat/` → jeden `memory/`, kľúče a enumy po anglicky, `## Pravda` → `## Truth`, mapovacia tabuľka prestane byť perzistenčnou schémou a stane sa i18n vrstvou. **Zaniká tým celá trieda chýb N1.**
- **O1 podmienky** — markery do existujúcich sekcií, `records` blok von zo `_STATUS.md`, markdown odkazy namiesto `[[…]]`, oprava maskovania driftu cez `sync`.

**Po calle zapíš rozhodnutie sem** (aby ho ďalší agent nemusel dohľadávať):

```
D1 rozhodnuté dňa: ____________
O1: ÁNO / NIE / s podmienkami: ____________
O6 kanonická angličtina: ✅ ÁNO — stanovisko VŘ 1. 9. 2026, zhoda s návrhom MČ
O7 konfigurovateľné prahy: ÁNO / NIE
Ostatné (O2–O5): ____________
```

### ✅ O6 — rozhodnuté: jadro stojí na anglických kľúčoch

**Stanovisko VŘ z 1. 9. 2026:** systém stojí primárne na anglických kľúčoch, nie na českých ani slovenských. Tým sa prijíma návrh MČ zo [`stanovisko-mc.md`](../../../research/okf-implementacie/stanovisko-mc.md).

> [!NOTE]
> Zhodli sa na tom obaja autori pôvodných implementácií. **Formálne potvrdenie tímom patrí do zápisu z callu** — tento riadok je stanovisko VŘ, nie zápis hlasovania. Ak sa na calle rozhodlo inak, prepíš ho a označ dátum.

**Čo z toho plynie pre poradie prác:**

| Úloha | Dopad |
|---|---|
| **5** (`init` nezaloží adresár, N1) | ❌ **zaniká** — priečinok je jeden `memory/`, jurisdikcia je hodnota poľa. Neopravuj `detect()`, zruš ho. |
| **8** (kanonická angličtina) | ✅ **aktívna a povinná**, robí sa **spolu s úlohou 10**, nie dvakrát |
| **10** (migrácia) | migruje sa **rovno na anglickú schému**, nie na lokalizovanú a potom znova |
| **17–21** (nové typy z `/legal`) | zakladajú sa **rovno anglicky** — `claim`, `evidence`, `task`, nie `tvrzeni`/`dukaz`/`ukol` |

Mapovacia tabuľka vo `schema.ts` zostáva — prestáva byť perzistenčnou schémou a stáva sa i18n vrstvou pre výstup. Renderované tabuľky v `_STATUS.md` a hlášky CLI zostávajú v jazyku používateľa.

---

## Kanonické prefixy identifikátorov (normatívne)

Vyplýva z O6 a **rieši kolíziu**, ktorá by inak vznikla pri migrácii: MČ navrhoval `D-` pre *decision*, `fact-analyzer` v `/legal` používa `D-` pre *dôkaz*. Pod anglickými kľúčmi je odpoveď jednoznačná — **dôkaz je `evidence`, teda `E-`**.

| Typ (kanonický) | Prefix | Poznámka |
|---|---|---|
| `matter` | `M-` | |
| `subject` | `S-` | |
| `screening` | `SC-` | `S-` je obsadené subjektom |
| `decision` | `D-` | podľa návrhu MČ |
| `question` | `Q-` | |
| `task` | `T-` | nový typ, úloha 19 |
| `claim` | `C-` | nový typ, úloha 17 |
| `evidence` | `E-` | nový typ, úloha 17 |
| `rule` | `R-` | |
| `lesson` | `L-` | |
| `authority` | `A-` | |

**Prefix nie je dekorácia.** Ploché `R-001` po roku nič nehovorí a v `INDEX.md` sa netriedi podľa významu — to je dôvod, prečo ho MČ do O2 pýtal.

### Prečo sa nezavádza typ `event` — a čo namiesto neho

Rozbor proti **aktuálnemu buildu** (stav po úlohe 2, 177 testov), nie proti zámeru.

**Udalosť dnes nesú tri mechanizmy, ktoré už fungujú:**

| Mechanizmus | Čo robí |
|---|---|
| `TimelineEntry { date, text }` v `## História` každého záznamu | primárny nosič; **append-only je vynútené** (`assertAppendOnly`), zmena Pravdy bez stopy je nemožná (`assertTruthTraced`) |
| render blok `timeline` | zlúči históriu **všetkých** záznamov, zoradí podľa dátumu a vykreslí `\| Dátum \| Udalosť \| Záznam \|` do §4; každý riadok nesie odkaz na zdrojový záznam, takže provenance sa nestráca |
| `deadlines` na zázname | dátumové dôsledky udalosti (lehota z doručenia) |

**Čo tieto tri mechanizmy nedokážu.** `TimelineEntry` je voľný text, takže neunesie právnu kvalifikáciu, väzby na dôkazy, účastníkov ani status sporné/nesporné. A hlavne **nemá identitu** — je to riadok vnútri cudzieho záznamu, nedá sa naň odkázať `[[…]]`.

**Kedy to prekáža:** práve vtedy, keď sa udalosť stane spornou. „Výpoveď bola doručená 12. 6." je v spore bežná otázka — a v tej chvíli potrebuje dôkazy a status preukázania.

> [!IMPORTANT]
> **Sporná udalosť je tvrdenie.** „Bolo doručené 12. 6." je presne to, čo modeluje `claim`: niekto to tvrdí, niekto nesie bremeno, dôkazy to podporujú alebo vyvracajú, a má to `proof_status`. Samostatný typ `event` by pre sporné udalosti duplikoval `claim` a pre nesporné duplikoval `TimelineEntry`. **Preto nevzniká** — nie kvôli kolízii prefixu, tá je len dôsledok.

**Výsledné pravidlo — kam udalosť patrí:**

| Udalosť | Kam |
|---|---|
| nesporná (doručenie, ktoré nikto nespochybňuje) | `TimelineEntry` v `## História` |
| **sporná** (potrebuje dôkaz a status preukázania) | `claim` (`C-`) + väzby na `evidence` (`E-`) — úloha 17 |
| lehota, ktorá z nej plynie | `deadlines` na zázname |

**Jedna medzera zostáva**, a nepokrýva ju ani jedno z toho: `TimelineEntry.text` je netypovaný. Chronológia preto nevie odlíšiť doručenie od pojednávania a nedá sa filtrovať ani použiť na výpočet lehôt. Rieši to **úloha 22** — malá aditívna zmena, nie nový typ.

---

## Fáza 1 — opravy nezávislé od D1

Tieto tri úlohy sa dajú robiť **hneď a bez ohľadu na výsledok callu**. Rob ich v poradí.

---

### ✅ Úloha 1: Čiarka v zoznamovom poli ticho rozbíja dáta (N6) 🔴 — HOTOVÉ

> **Dokončené 1. 9. 2026, commit [`1a42187`](https://github.com/Omni-Legal-Products/lawoss/commit/1a42187).** 166/166 testov, typecheck čistý.
>
> **Čo plán nepredvídal:** testy odhalili druhú vadu tej istej triedy, ktorú nález N6 nepomenoval — `emit()` neescapoval úvodzovku **vnútri položky zoznamu**, takže hodnota `Firma "Alfa", s.r.o.` sa pri čítaní predčasne uzavrela. Oprava parsera bez opravy zápisu by problém nevyriešila. Opravené v tom istom commite.
>
> **Druhá vec, na ktorú si dať pozor pri podobných úlohách:** prvá verzia `splitList` rozbila existujúce testy `record-aml.test.ts`, lebo medzeru medzi čiarkou a úvodzovkou (`["a", "b"]`) brala ako súčasť hodnoty. Pri zmene parsera vždy spusti **celú** sadu, nie len nový súbor.

Najzávažnejší nález. `emit()` zapíše `["Doprava, s.r.o."]`, `parseScalar()` to rozdelí na **každej** čiarke a vznikne `["\"Doprava", "s.r.o.\""]` — bez chyby a bez varovania. Trafí to každé slovenské aj české obchodné meno, teda najbežnejší legitímny vstup do poľa `strany:`.

Overené 1. 9. 2026: dva subjekty sa pri prvom read-modify-write cykle zmenia na štyri zmrzačené reťazce.

**Files:**
- Modify: `lawoss/okf/src/record.ts` (funkcia `parseScalar`, pridať `splitList`)
- Test: `lawoss/okf/tests/record-lists.test.ts` (nový)

**Interfaces:**
- Consumes: nič nové
- Produces: `parseRecord` / `serializeRecord` round-trip zachová čiarku vo vnútri položky zoznamu. Signatúry sa nemenia.

- [x] **Krok 1: Napíš padajúci test**

Vytvor `lawoss/okf/tests/record-lists.test.ts`:

```typescript
import { test } from "node:test";
import assert from "node:assert/strict";
import { parseRecord, serializeRecord } from "../src/record.ts";
import { newRecord } from "../src/index.ts";

function tamASpat(hodnoty: string[]): string[] {
  const r = newRecord({
    id: "S-001", type: "subject", jurisdiction: "cz",
    title: "X", summary: "y", created: "2026-09-01", updated: "2026-09-01",
    truth: "t", timeline: [{ date: "2026-09-01", text: "z" }],
    parties: hodnoty,
  });
  return parseRecord(serializeRecord(r)).parties ?? [];
}

test("ciarka v obchodnom mene prezije round-trip", () => {
  assert.deepEqual(
    tamASpat(["Doprava, s.r.o.", "Novák, a.s."]),
    ["Doprava, s.r.o.", "Novák, a.s."],
  );
});

test("hodnota bez uvodzoviek sa stale deli na ciarke", () => {
  const r = parseRecord(`---
okf: 1
id: R-001
typ: rozhodnuti
nazev: X
popis: y
vrstva: L2
jurisdikce: cz
stav: platny
vznik: 2026-09-01
zmena: 2026-09-01
zdroje: [a, b, c]
---

## Pravda
t

## Historie
- 2026-09-01 — z
`);
  assert.deepEqual(r.sources, ["a", "b", "c"]);
});

test("prazdny zoznam zostava prazdny", () => {
  assert.deepEqual(tamASpat([]), []);
});

test("jedna polozka s ciarkou sa nerozpadne", () => {
  assert.deepEqual(tamASpat(["Novák, a.s."]), ["Novák, a.s."]);
});

test("uvodzovka vo vnutri hodnoty prezije", () => {
  assert.deepEqual(tamASpat(['Firma "Alfa", s.r.o.']), ['Firma "Alfa", s.r.o.']);
});

test("apostrof sa neberie ako uvodzovka uprostred slova", () => {
  assert.deepEqual(tamASpat(["O'Brien, s.r.o."]), ["O'Brien, s.r.o."]);
});

test("ciarka prezije aj v poli zdroje a oblast_prava", () => {
  const r = newRecord({
    id: "R-002", type: "decision", jurisdiction: "cz",
    title: "X", summary: "y", created: "2026-09-01", updated: "2026-09-01",
    truth: "t", timeline: [{ date: "2026-09-01", text: "z" }],
    area: ["Obchodní právo, korporace"], sources: ["NS 29 Cdo 1/2020, bod 12"],
  });
  const zpet = parseRecord(serializeRecord(r));
  assert.deepEqual(zpet.area, ["Obchodní právo, korporace"]);
  assert.deepEqual(zpet.sources, ["NS 29 Cdo 1/2020, bod 12"]);
});
```

- [x] **Krok 2: Spusti test a over, že padá**

```bash
cd ~/Projects/lawoss/_worktrees/feat-okf-pamat/lawoss/okf
node --test tests/record-lists.test.ts
```

Očakávané: padnú testy s čiarkou. Prvý ukáže `["\"Doprava", "s.r.o.\"", …]` namiesto dvoch položiek. Testy bez čiarky prejdú — to je správne, nesmieš rozbiť existujúce správanie.

- [x] **Krok 3: Implementuj rozdeľovanie, ktoré rešpektuje úvodzovky**

V `lawoss/okf/src/record.ts` pridaj nad `parseScalar`:

```typescript
/**
 * Rozdelí obsah `[…]` na položky. Čiarka vnútri úvodzoviek nie je oddeľovač —
 * bez toho sa „Doprava, s.r.o." rozpadne na dva zmrzačené reťazce a tichá
 * strata dát sa prejaví až o mesiace, pri prvom read-modify-write cykle.
 */
function splitList(inner: string): string[] {
  const out: string[] = [];
  let cur = "";
  let quote: string | undefined;
  let quoted = false;

  for (let i = 0; i < inner.length; i++) {
    const ch = inner.charAt(i);
    if (quote !== undefined) {
      if (ch === "\\" && inner.charAt(i + 1) === quote) {
        cur += quote;
        i++;
        continue;
      }
      if (ch === quote) {
        quote = undefined;
        continue;
      }
      cur += ch;
      continue;
    }
    if (ch === '"' || ch === "'") {
      quote = ch;
      quoted = true;
      continue;
    }
    if (ch === ",") {
      out.push(quoted ? cur : cur.trim());
      cur = "";
      quoted = false;
      continue;
    }
    cur += ch;
  }
  out.push(quoted ? cur : cur.trim());
  return out;
}
```

A v `parseScalar` nahraď vetvu pre zoznam:

```typescript
  if (v.startsWith("[") && v.endsWith("]")) {
    const inner = v.slice(1, -1).trim();
    if (inner === "") return [];
    return splitList(inner);
  }
```

`unquote` sa na položky už nevolá — `splitList` ich vracia rozbalené.

- [x] **Krok 4: Spusti testy**

```bash
node --test tests/record-lists.test.ts && node --test 'tests/**/*.test.ts' && ./node_modules/.bin/tsc -p tsconfig.json --noEmit
```

Očakávané: všetko zelené, 0 fail, typecheck exit 0.

- [x] **Krok 5: Commit**

```bash
git add lawoss/okf/src/record.ts lawoss/okf/tests/record-lists.test.ts
git commit -m "fix: čiarka v zoznamovom poli už nerozbíja záznam (N6)"
```

Do tela commitu napíš, že `emit()` zapisoval zoznamy v hranatých zátvorkách, `parseScalar` ich delil na každej čiarke a `unquote` polovice neopravil; slovenské aj české obchodné meno má čiarku v kanonickom tvare, takže dva subjekty sa pri prvom read-modify-write cykle zmenili na štyri zmrzačené reťazce — bez chyby a bez varovania.

---

### ✅ Úloha 2: Render pripája duplicitné sekcie namiesto vyplnenia existujúcich (N2) 🔴 — HOTOVÉ

> **Dokončené 1. 9. 2026, commit [`2e071a8`](https://github.com/Omni-Legal-Products/lawoss/commit/2e071a8).** 177/177 testov, typecheck čistý.
>
> Overené na šablóne `mc-novy-spis`: pred opravou mala po `sync --apply` **päť** nadpisov, po oprave zostávajú **dva** a `sync` skončí `KONFLIKT` s exit 1 bez dotyku súboru. S markermi vnútri sekcií render prejde a je idempotentný.
>
> **Nad rámec zadania:** zhoda sa hľadá na **celý** nadpis vrátane číslovania (`## 3. Lehoty`), takže vlastná sekcia advokáta typu „Lehoty a termíny klienta" poplach nespustí. Bez toho by kontrakt otravoval na legitímnom obsahu.

Bez markerov `appendBlock` pripojí novú sekciu na koniec. Na šablóne `mc-novy-spis` tak vznikne `## 3. Lehoty` (ručná, prázdna) **aj** `## Lehoty` (renderovaná) — presne tá dvojitá pravda, ktorú má O1 odstrániť.

Overené 1. 9. 2026 na šablóne so sekciami `## 3. Lehoty` a `## 4. Chronológia`: po `sync --apply` má súbor päť nadpisov namiesto dvoch.

MČ žiada (podmienka 1 k O1): keď render nájde nadpis Lehoty/Chronológia **bez** markerov, nesmie ticho pripojiť duplikát — nech skončí chybou s odkazom na retrofit.

**Files:**
- Modify: `lawoss/okf/src/render.ts`
- Modify: `lawoss/okf/src/cli.ts` (zachytiť novú výnimku a vypísať ju čitateľne)
- Modify: `lawoss/okf/tests/render.test.ts` (existujúci test kodifikuje staré správanie)
- Test: `lawoss/okf/tests/render-conflict.test.ts` (nový)

**Interfaces:**
- Produces: `export class RenderConflictError extends Error` z `render.ts`, re-exportovaná z `index.ts`. `renderStatus(existing, records, j)` ju vyhodí, keď existuje nadpis bloku bez markerov.

- [x] **Krok 1: Napíš padajúci test**

Vytvor `lawoss/okf/tests/render-conflict.test.ts`:

```typescript
import { test } from "node:test";
import assert from "node:assert/strict";
import { renderStatus, RenderConflictError } from "../src/render.ts";
import { newRecord } from "../src/index.ts";

const ZAZNAM = newRecord({
  id: "R-001", type: "decision", jurisdiction: "sk",
  title: "Rozhodnutie", summary: "s", created: "2026-09-01", updated: "2026-09-01",
  truth: "t", timeline: [{ date: "2026-09-01", text: "z" }],
  deadlines: ["2026-09-12"],
});

const SABLONA_MC = `# Vec — Status (SSOT)

## 3. Lehoty
| Dátum | Typ |
|---|---|

## 4. Chronológia
| Dátum | Udalosť |
|---|---|
`;

const S_MARKERMI = `# Vec — Status (SSOT)

## 3. Lehoty
<!-- okf:render:deadlines:start -->
<!-- okf:render:deadlines:end -->

## 4. Chronológia
<!-- okf:render:timeline:start -->
<!-- okf:render:timeline:end -->
`;

test("nadpis bez markerov skonci chybou, nie tichym duplikatom", () => {
  assert.throws(() => renderStatus(SABLONA_MC, [ZAZNAM], "sk"), RenderConflictError);
});

test("chyba pomenuje sekciu aj odporucany krok", () => {
  try {
    renderStatus(SABLONA_MC, [ZAZNAM], "sk");
    assert.fail("malo vyhodiť výnimku");
  } catch (e) {
    assert.ok(e instanceof RenderConflictError);
    assert.match((e as Error).message, /Lehoty/);
    assert.match((e as Error).message, /retrofit/i);
  }
});

test("s markermi vnutri existujucej sekcie render prejde a neduplikuje", () => {
  const out = renderStatus(S_MARKERMI, [ZAZNAM], "sk");
  assert.match(out, /2026-09-12/);
  assert.equal((out.match(/^## /gm) ?? []).length, 2, "nesmie pribudnúť nadpis");
  assert.equal(renderStatus(out, [ZAZNAM], "sk"), out, "render musí byť idempotentný");
});

test("blok records sa uz do _STATUS.md sam nepridava", () => {
  const out = renderStatus(S_MARKERMI, [ZAZNAM], "sk");
  assert.doesNotMatch(out, /okf:render:records/,
    "zoznam záznamov patrí do INDEX.md, nie do _STATUS.md (O1, stanovisko MČ)");
});

test("blok records sa vyplni, ak si ho advokat markerom vyziada", () => {
  const s = `# Status

## Záznamy
<!-- okf:render:records:start -->
<!-- okf:render:records:end -->
`;
  assert.match(renderStatus(s, [ZAZNAM], "sk"), /R-001/);
});

test("uplne prazdny subor dostane sekcie doplnene", () => {
  const out = renderStatus("# Status\n", [ZAZNAM], "sk");
  assert.match(out, /okf:render:deadlines:start/);
  assert.match(out, /2026-09-12/);
});
```

- [x] **Krok 2: Spusti test a over, že padá**

```bash
node --test tests/render-conflict.test.ts
```

Očakávané: import `RenderConflictError` zlyhá, takže padne celý súbor. Po pridaní triedy padnú prvé dva testy na tom, že sa výnimka nevyhadzuje.

- [x] **Krok 3: Implementuj**

V `lawoss/okf/src/render.ts` pridaj nad `renderStatus`:

```typescript
export class RenderConflictError extends Error {}

/** Nadpisy, pod ktorými blok žije v už existujúcich spisoch — vrátane číslovania MČ. */
const BLOCK_HEADING_ALIASES: Record<BlockName, readonly string[]> = {
  deadlines: ["Lhůty", "Lehoty"],
  timeline: ["Chronologie", "Chronológia"],
  records: ["Záznamy paměti", "Záznamy pamäte", "Záznamy"],
};

/** Blok, ktorý sa sám nepridáva — renderuje sa iba tam, kde si ho niekto vyžiadal markerom. */
const MARKER_ONLY: readonly BlockName[] = ["records"];

function bareHeading(text: string, b: BlockName): string | undefined {
  for (const alias of BLOCK_HEADING_ALIASES[b]) {
    const re = new RegExp(`^##\\s*(?:\\d+\\.\\s*)?${alias}\\s*$`, "mi");
    if (re.test(text)) return alias;
  }
  return undefined;
}
```

A nahraď telo `renderStatus`:

```typescript
export function renderStatus(
  existing: string,
  records: readonly OkfRecord[],
  j: Jurisdiction,
): string {
  let out = existing;
  for (const b of BLOCKS) {
    const body = RENDERERS[b](records, j);
    const replaced = replaceBlock(out, b, body);
    if (replaced !== undefined) {
      out = replaced;
      continue;
    }
    const bare = bareHeading(out, b);
    if (bare !== undefined) {
      throw new RenderConflictError(
        `Sekcia „${bare}" existuje, ale nemá markery — render by pripojil duplikát ` +
          `a v spise by vznikli dve pravdy. Doplň markery cez retrofit ` +
          `a spusti sync znova.`,
      );
    }
    if (MARKER_ONLY.includes(b)) continue;
    out = appendBlock(out, b, body, j);
  }
  return out;
}
```

- [x] **Krok 4: Zachyť výnimku v CLI a uprav starý test**

V `lawoss/okf/src/cli.ts` doplň import `RenderConflictError` z `./render.ts` a obaľ telo vetvy `case "sync"` do `try { … } catch (e) { if (e instanceof RenderConflictError) return { code: 1, out: \`KONFLIKT: ${e.message}\` }; throw e; }`.

V `lawoss/okf/tests/render.test.ts` uprav test „chybajuci blok sa doplni aj s markermi" — má očakávať doplnenie iba blokov `deadlines` a `timeline`. Pridaj k nemu komentár, že `records` je odteraz marker-only podľa podmienky MČ k O1.

- [x] **Krok 5: Spusti testy**

```bash
node --test 'tests/**/*.test.ts' && ./node_modules/.bin/tsc -p tsconfig.json --noEmit
```

Očakávané: 0 fail, typecheck exit 0.

- [x] **Krok 6: Commit**

```bash
git add lawoss/okf/src/render.ts lawoss/okf/src/cli.ts lawoss/okf/tests/
git commit -m "fix: render nesmie pripájať duplicitné sekcie do _STATUS.md (N2)"
```

---

### Úloha 3: Štvrtá brána nie je v ceste zápisu (N3) 🟡

`zjednotenie.md` tvrdí štyri brány „v nástroji, nie v prompte". Tri naozaj sú. Kontrola úniku L2→L3 žije iba v `okf-memory validate` — `applyRecordWrite` ju nevolá, takže prameň s IČO klienta na disk prejde a chytí ho až samostatný beh validácie.

Buď sa brána doplní, alebo `zjednotenie.md` prestane tvrdiť, že sú štyri. **Doplň ju** — tvrdenie je správne, chýba mu implementácia.

**Files:**
- Modify: `lawoss/okf/src/store.ts` (`applyRecordWrite`)
- Modify: `lawoss/okf/src/index.ts` (export novej výnimky)
- Test: `lawoss/okf/tests/write-gate-leak.test.ts` (nový)

**Interfaces:**
- Produces: `export class LeakBlockedError extends Error` zo `store.ts`. `applyRecordWrite` ju vyhodí, keď by zápis vytvoril L3 záznam s `error` nálezom kódu `L3_LEAK`.

- [ ] **Krok 1: Napíš padajúci test**

Vytvor `lawoss/okf/tests/write-gate-leak.test.ts`:

```typescript
import { test } from "node:test";
import assert from "node:assert/strict";
import { mkdtempSync, mkdirSync, writeFileSync, readdirSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { applyRecordWrite, memoryDirName, LeakBlockedError } from "../src/store.ts";
import { serializeRecord } from "../src/record.ts";
import { newRecord, planWrite } from "../src/index.ts";

const SCHVALENIE = { by: "JUDr. Vojtěch Říha", at: "2026-09-01T10:00:00Z" };

function spisSoSubjektom(ico = "29139643", meno = "Gh Real Estate s.r.o."): string {
  const dir = mkdtempSync(join(tmpdir(), "okf-leak-"));
  mkdirSync(join(dir, memoryDirName("cz")));
  writeFileSync(
    join(dir, "pamet", "S-001-klient.md"),
    serializeRecord(newRecord({
      id: "S-001", type: "subject", jurisdiction: "cz",
      title: meno, summary: "protistrana",
      created: "2026-09-01", updated: "2026-09-01", truth: "t",
      timeline: [{ date: "2026-09-01", text: "overené" }],
      registry_id: ico,
    })),
  );
  return dir;
}

function pramen(id: string, truth: string) {
  return newRecord({
    id, type: "authority", jurisdiction: "cz",
    title: "Právna veta", summary: "prameň",
    created: "2026-09-01", updated: "2026-09-01", truth,
    timeline: [{ date: "2026-09-01", text: "založené" }],
  });
}

test("zapis pramena s ICO klienta sa odmietne uz pri zapise", () => {
  const dir = spisSoSubjektom();
  const p = pramen("J-001", "Vec sa týkala spoločnosti s IČO 29139643.");
  assert.throws(
    () => applyRecordWrite(dir, planWrite(undefined, p, "právna veta"), SCHVALENIE),
    LeakBlockedError,
  );
  assert.equal(readdirSync(join(dir, "pamet")).length, 1, "na disku nesmie nič pribudnúť");
});

test("cisty pramen prejde", () => {
  const dir = spisSoSubjektom();
  const p = pramen("J-002", "Miestna príslušnosť sa posudzuje k okamihu začatia konania.");
  applyRecordWrite(dir, planWrite(undefined, p, "právna veta"), SCHVALENIE);
  assert.equal(readdirSync(join(dir, "pamet")).length, 2);
});

test("varovanie zapis neblokuje", () => {
  const dir = spisSoSubjektom("", "Novák");
  const p = pramen("J-003", "Žalobca Novák namietal premlčanie.");
  assert.doesNotThrow(() =>
    applyRecordWrite(dir, planWrite(undefined, p, "veta"), SCHVALENIE));
});

test("zapis do L2 sa kontrolou uniku nezdrzuje", () => {
  const dir = spisSoSubjektom();
  const r = newRecord({
    id: "R-001", type: "decision", jurisdiction: "cz",
    title: "Rozhodnutie", summary: "IČO overené v OR",
    created: "2026-09-01", updated: "2026-09-01", truth: "IČO 29139643 sedí.",
    timeline: [{ date: "2026-09-01", text: "z" }],
  });
  assert.doesNotThrow(() =>
    applyRecordWrite(dir, planWrite(undefined, r, "fakt"), undefined));
});
```

- [ ] **Krok 2: Spusti test a over, že padá**

```bash
node --test tests/write-gate-leak.test.ts
```

Očakávané: import `LeakBlockedError` zlyhá.

- [ ] **Krok 3: Implementuj**

V `lawoss/okf/src/store.ts` doplň `import { validateStore } from "./validate.ts";`, triedu a kontrolu v `applyRecordWrite` hneď po `authorize`:

```typescript
export class LeakBlockedError extends Error {}
```

```typescript
export function applyRecordWrite(dir: string, diff: WriteDiff, approval: Approval | undefined): void {
  authorize(diff, approval);
  const store = readStore(dir);

  // Štvrtá brána. Beží iba pre L3 — v spise sú identifikátory legitímne
  // a validate.ts ich tam aj tak preskakuje.
  const after = diff.after;
  if (after && after.layer === "L3") {
    const ostatne = store.records.filter((r) => r.id !== after.id);
    const chyby = validateStore([...ostatne, after]).filter(
      (f) => f.recordId === after.id && f.severity === "error" && f.code === "L3_LEAK",
    );
    if (chyby.length > 0) {
      throw new LeakBlockedError(
        `Zápis záznamu ${after.id} odmietnutý — ${chyby.map((f) => f.message).join(" ")}`,
      );
    }
  }
  // … zvyšok funkcie zostáva bez zmeny
}
```

- [ ] **Krok 4: Exportuj a spusti testy**

V `lawoss/okf/src/index.ts` pridaj `LeakBlockedError` do exportu zo `store.ts`.

```bash
node --test 'tests/**/*.test.ts' && ./node_modules/.bin/tsc -p tsconfig.json --noEmit
```

- [ ] **Krok 5: Commit**

```bash
git add lawoss/okf/src/store.ts lawoss/okf/src/index.ts lawoss/okf/tests/write-gate-leak.test.ts
git commit -m "feat: kontrola úniku L2→L3 je v ceste zápisu, nie iba vo validate (N3)"
```

---

## Fáza 2 — po rozhodnutí D1

**Nezačínaj, kým nie je vyplnená brána D1.** Poradie v rámci fázy je záväzné.

> [!IMPORTANT]
> **Úlohy 4–16 sú zámerne v hrubšom rozlíšení než 1–3.** Nesú súbory, rozhranie a akceptačné kritériá, ale nie hotový kód krok po kroku — a to preto, že ich obsah závisí od výsledku D1. Rozpísať detailné kroky pre schému, ktorá sa o hodinu môže preklopiť do angličtiny, je práca do koša.
>
> **Prvý krok každej z týchto úloh je preto rozpísať ju do krokov podľa vzoru úloh 1–3** (padajúci test s kódom → beh → implementácia s kódom → beh → commit) a až potom začať. Akceptačné kritériá sú záväzné zadanie, nie inšpirácia.

### Úloha 4: `Approval` je self-declared — CLI ako jediná zápisová hranica (N4)

`authorize()` prejde pri akomkoľvek neprázdnom `{ by, at }`. Knižničný volajúci si súhlas vyrobí sám, takže human gate je konvencia API, nie hranica. Dnes to nehorí, lebo CLI zápis záznamov vôbec nemá — a to je práve dôvod, prečo sa to má doplniť teraz, kým je plocha malá.

**Files:** `lawoss/okf/src/cli.ts` (nový príkaz `write`), `lawoss/okf/SKILL.md`, test `lawoss/okf/tests/cli-write.test.ts`

**Akceptačné kritériá:**
- `okf-memory write <spis> --file <cesta.md> --reason "…"` vypíše diff a **nič nezapíše**.
- `… --apply` zapíše záznam L2.
- `… --apply` na L1/L3 alebo mazanie bez `--approve-as "<meno>"` skončí kódom 1 a hláškou, čo chýba.
- `… --apply --approve-as "JUDr. …"` prejde a meno sa objaví v audit riadku histórie.
- `SKILL.md` obsahuje vetu, odkiaľ `Approval` smie pochádzať: od človeka cez CLI, nikdy si ho agent nekonštruuje sám.

**Poznámka:** neinteraktívne potvrdenie je zámerné — interaktívny prompt sa v agentovom behu odklikne cez `yes |`. Hranicou je to, že meno musí do príkazu zadať človek.

### ❌ Úloha 5: `init` nezaloží adresár pamäte a jurisdikcia sa háda (N1) — ZRUŠENÁ

> **Zrušená 1. 9. 2026 rozhodnutím O6.** Priečinok je jeden `memory/` a jurisdikcia je hodnota poľa, nie názov adresára — celá trieda chýb N1 zaniká z definície. **Neopravuj `detect()`, zruš ho** v rámci úlohy 8.
>
> Zadanie nižšie zostáva zapísané len ako doklad, čo sa zrušilo a prečo. **Nevykonávaj ho.** Ak by sa O6 na calle prekvapivo otočilo, toto je hotové zadanie na obnovenie.

~~Pôvodné zadanie:~~

**Files:** `lawoss/okf/src/cli.ts`, `lawoss/okf/src/store.ts`, test `lawoss/okf/tests/init-jurisdiction.test.ts`

**Akceptačné kritériá:**
- `okf-memory init <spis> --sk --apply` vytvorí `pamat/` **a** `BRAIN.md`, v tomto poradí.
- `readStore` berie jurisdikciu zo `spis.md`; keď ju nevie určiť a adresár neexistuje, **zlyhá** namiesto tichého `?? "cz"`.
- `applyRecordWrite` odmietne zápis SK záznamu do `pamet/` a naopak — mix jurisdikcií v jednom spise je chyba, nie stav.
- Test: SK spis end-to-end od `init --sk` po `sync --apply`; v `_STATUS.md` sa nesmie objaviť `## Lhůty` ani hlavička `| Datum |`.

### Úloha 6: Drobnosti z N5 a N8

**Files:** `lawoss/okf/src/store.ts`, `src/render.ts`, `src/write.ts`, `src/cli.ts`, `tests/parse-errors.test.ts`

**Akceptačné kritériá:**
- Kód nálezu `PARSE` premenovaný na **`PARSE_ERROR`** (zosúladenie s review N5).
- `writeIndex()` a `renderRecords()` — preč ternár, ktorého obe vetvy sú identické.
- `planWrite` pri `update` odmietne zápis, ak sa `truth` alebo história zmenili a `updated` zostalo. Dnes to chytí až `STALE_UPDATED` vo `validate`; logickejšie je to pri zápise.
- `okf-memory init` berie default jurisdikcie zo `spis.md`, nie z prepínača.

### Úloha 7: Optimistická kontrola súbehu cez `zmena:` (O4, dodatok MČ)

**Files:** `lawoss/okf/src/store.ts`, test `lawoss/okf/tests/concurrency.test.ts`

**Akceptačné kritériá:** `applyRecordWrite` prečíta záznam z disku tesne pred zápisom; ak sa jeho `updated` líši od `diff.before.updated`, odmietne zápis `ConcurrentWriteError`. Test: dva `planWrite` z toho istého východiskového stavu, druhý `applyRecordWrite` musí padnúť.

### Úloha 8: Kanonická angličtina v jadre (O6)

⚠️ **Iba ak D1/O6 prešlo.** Veľká zmena; robí sa **spolu s migráciou** (úloha 10), nie dvakrát.

**Rozsah:** kľúče frontmatteru a hodnoty enumov po anglicky (`type: decision`, `status: active`), jeden priečinok `memory/`, riadiace súbory `matter.md` / `client.md`, sekcie `## Truth` / `## History`. **Priečinky oblastí a spisov zostávajú v jazyku používateľa** — hranica, na ktorej MČ trvá. Mapovacia tabuľka vo `schema.ts` zostáva, len prestane byť perzistenčnou schémou a stane sa i18n vrstvou.

**Akceptačné kritériá:** `FIELDS` má jednu sadu kanonických kľúčov; `cz`/`sk` stĺpce sa používajú iba pri renderovaní pre človeka. Renderované tabuľky v `_STATUS.md` zostávajú lokalizované. Testová matica CZ/SK sa presúva z perzistencie na zobrazenie. Existujúce testy sa **prepíšu, nie zmažú**.

---

## Fáza 3 — migrácia, konfigurácia, publikácia

### Úloha 9: `_kancelaria/` — koreň L1 a domov L3 (O3 + O3b)

L1 záznamy (`rule`, `lesson`) žijú v `_kancelaria/`; `readScope` ich číta ako tretiu úroveň. `okf-validate.sh` a `okf-freshness.sh` `_kancelaria/` nepovažujú za spis (nemá `_STATUS.md` ani `spis.md`). **O3b:** rozhodnúť a implementovať, kam patrí L3 — návrh MČ je `_kancelaria/pramene/`, aby sa ten istý judikát nekopíroval do desiatich spisov a `L3_LEAK` sa nekontroloval desaťkrát.

### Úloha 10: Migrácia existujúcich spisov (O2)

`TP-XXX → decision`, `LL-XXX → lesson`, `OQ-XXX → question`. Pôvodný `MEMORY.md` zostáva **nedotknutý** — konverzia je čítanie → zápis. Idempotentné, žiadne mazanie ani presuny. Id nesie prefix **podľa normatívnej tabuľky vyššie** — nie ploché `R-` a nie ad-hoc písmená. Migruje sa **rovno na anglickú schému** (O6), nie na lokalizovanú a potom znova.

⚠️ **Skontroluj kolíziu pred spustením dávky.** Ak spis prešiel cez `/legal` a `fact-analyzer`, môže už obsahovať `D-XXX` v zmysle *dôkaz*. Pod novou schémou je `D-` *decision* a dôkaz je `E-`. Migračný skript musí staré `D-XXX` rozpoznať podľa obsahu záznamu (dôkaz má typ dôkazu podľa § 125–131 o. s. ř.) a premapovať na `E-`, nie ich ticho nechať. `LL → lesson` je L1, takže migračný skript beží **ako človek** s jedným súhrnným diffom na odklep. Súčasťou je injektáž markerov do `_STATUS.md`. **Najprv pilot na jednom reálnom spise, až potom dávka.**

### Úloha 11: Oprava maskovania driftu cez `sync` (O1, podmienka 2 MČ)

`okf-freshness.sh` porovnáva mtime `_STATUS.md` s najnovším obsahovým súborom. Keď agent pridá dokument a potom spustí `sync --apply`, súboru sa dotkne stroj a freshness zhasne na zelenú, hoci §6 nikto nedoplnil. **Detektor driftu prestane detegovať práve v okamihu, keď zapneme projekciu.**

Stačí jedno riešenie, v poradí preferencie MČ: `sync` obnoví pôvodný mtime, keď sa zmenil iba obsah medzi markermi; alebo `human_updated:` vo frontmatteri; alebo freshness porovnáva voči `spis.md`. Test musí ukázať, že po `sync --apply` freshness stále hlási drift v §6.

### Úloha 12: Markdown odkazy namiesto `[[…]]` v `_STATUS.md` a `INDEX.md` (O1c)

Spisy žijú v Drive a Finderi a otvárajú sa v bežnom markdown prehliadači, nie v Obsidiane — `[[R-001]]` je tam mŕtvy text. `_STATUS.md` a `INDEX.md` nesú `[R-001](pamat/R-001-slug.md)`. Vo vnútri záznamov `[[…]]` zostáva a validátor mu naďalej rozumie.

### Úloha 13: Lehoty majú jedno SSOT (O1a)

Po zjednotení sú lehoty na troch miestach: `spis.md` frontmatter, pole `lehoty:` v zázname, renderovaná tabuľka. SSOT je záznam pamäte, tabuľka je projekcia; `lehoty:` v `spis.md` sa buď tiež renderuje, alebo vypadne z protokolu zápisu. **Rozhodnúť pred migráciou, nie po nej** — inak sa migruje do stavu, ktorý sa vzápätí mení.

### Úloha 14: Konfigurovateľné prahy kontroly únikov (O7)

Väčšina O7 je **hotová** (celé slovo, meno → `warning`, identifikátory → `error`). Zostáva konfigurácia: prahy do `_kancelaria/okf.config`, **nie k jednotlivému zápisu** — per-zápis prepínač je presne to, čo agent zapne, aby prešiel. Vypnutie musí byť vedomé a s dôvodom v konfigu. Hranica „rodné číslo do zdieľateľnej vrstvy" zostáva tvrdá a nekonfigurovateľná.

### Úloha 15: Publikovať schému ako štandard (O5)

**Až po úlohe 10.** Migrácia je prvý reálny test schémy na dátach, ktoré podľa nej nevznikli. Poradie: pilot → korekcie schémy → verzia `okf: 1` zmrazená → publikácia (JSON Schema v `specs/`).

### Úloha 16: Parser pre UI a dashboard spisu

Podľa poradia MČ posledná zo základnej sady. `lawoss/okf/read.ts` ako vstup pre appku, dashboard renderovaný z markdownov (design-system §5). **Nezačínaj pred dokončením úlohy 10** — dashboard nad nemigrovanými dátami nemá čo zobraziť.

> [!NOTE]
> Úlohy **17–21 (fáza 3b)** sú z pohľadu MČ poradia dodatok. Dajú sa robiť **pred aj po** úlohe 16 — sú to nové typy záznamov, dashboard ich buď zobrazí, alebo nie. Ak sa robia po nej, počítaj s tým, že parser aj dashboard budú potrebovať doplnenie o `claim`, `evidence` a `task`. **Lacnejšie je urobiť ich skôr** a dashboard postaviť rovno nad úplnou sadou typov.

---

## Fáza 3b — prenos z `/legal` (VŘ), aby bol systém plne prenositeľný

Zdroj: skill `/legal` a jeho 14 agentov v praxi VŘ. **Kritérium výberu bolo jediné —
zanechá to typovaný artefakt v priečinku spisu, alebo to žije iba v prompte agenta?**
Prenositeľnosť podľa Q10 je vlastnosť súborov na disku; cudzí harness (opencode, Codex,
Cursor) tvoje agenty nemá, ale priečinok spisu otvorí.

Podľa tohto kritéria sa neberie menu, dispatch cez Task tool, redline OOXML ani persony
agentov. Berú sa **schémy záznamov**, ktoré sú dnes zahrabané vnútri agentov.

Všetky nové typy sa zakladajú **rovno anglicky** (O6) a s prefixmi z normatívnej tabuľky.

---

### Úloha 17: Typy `claim` a `evidence` — dôkazná vrstva

OKF dnes nesie stav veci, rozhodnutia a subjekty, ale **nemá čím zachytiť, kto čo tvrdí
a čím to dokazuje**. `fact-analyzer` to má vyriešené typovanými záznamami s krížovými
odkazmi — presne tvar OKF, len pre vrstvu, ktorá chýba.

**Files:** `lawoss/okf/src/schema.ts`, `src/record.ts` (rozhranie), test `lawoss/okf/tests/claims-evidence.test.ts`

**Interfaces — Produces:** dva nové `RecordType` vo vrstve **L2**: `claim` (prefix `C-`) a `evidence` (prefix `E-`).

**Polia `claim`** (predloha: `T-XXX` v `fact-analyzer.md`):

| kanonické | čo to je |
|---|---|
| `claimed_by` | odkaz na `S-` — kto tvrdí |
| `claimed_at` | kedy bolo tvrdené |
| `claimed_in` | kde — v žalobe, replike, výpovedi |
| `legal_question` | k akej právnej otázke smeruje |
| `burden_of_proof` | kto musí preukázať |
| `supporting_evidence` | zoznam `E-` |
| `contradicting_evidence` | zoznam `E-` |
| `proof_status` | `proven` / `unproven` / `disputed` |
| `credibility` | `high` / `medium` / `low` |

**Polia `evidence`** (predloha: `D-XXX`):

| kanonické | čo to je |
|---|---|
| `evidence_kind` | druh dôkazu — hodnota je **jurisdikčná**, viď upozornenie nižšie |
| `origin_date` | dátum vzniku |
| `author` | kto listinu vytvoril |
| `formal_requirements` | podpis, pečiatka |
| `proves` | zoznam `C-` |
| `evidence_strength` | `direct` / `indirect` |
| `reliability` | `high` / `medium` / `low` |
| `objection` | kto namieta a čo |
| `procedural_status` | `proposed` / `taken` |

> [!WARNING]
> **`evidence_kind` sa neprekladá.** `fact-analyzer` viaže druhy dôkazu na § 125–131
> o. s. ř. (listina, výsluch svedka, znalecký posudok, výsluch účastníka, ohliadka).
> Slovenský ekvivalent je Civilný sporový poriadok, nie o. s. ř., a členenie sa nemusí
> kryť. **Kľúč je anglický, hodnoty a ich právne ukotvenie sú jurisdikčné** — rovnaká
> disciplína ako pri AML sadách. SK vetvu neodhaduj; nechaj `[OVERIŤ — MČ]` a ohlás to
> ako `AML_RULESET_UNVERIFIED` robí pri AML.

**Akceptačné kritériá:**
- `LAYER_OF.claim === "L2"`, `LAYER_OF.evidence === "L2"`.
- Round-trip oboch typov cez `parseRecord`/`serializeRecord` bez straty (test pre každé nové pole).
- `validateStore` hlási rozbitý odkaz, keď `supporting_evidence` ukazuje na neexistujúce `E-`, a naopak `proves` na neexistujúce `C-`.
- **Obojsmerná konzistencia:** ak `C-001.supporting_evidence` obsahuje `E-007`, potom `E-007.proves` musí obsahovať `C-001`. Rozpor je nález `LINK_ASYMMETRY` (warning) — jednosmerne vedená väzba sa po pár mesiacoch rozíde.
- Identifikátory z `evidence` **nie sú** jehly detektora únikov (sú to údaje o listinách, nie o klientovi) — over testom, že pridanie `evidence` záznamu nespôsobí `L3_LEAK` falošný nález.

---

### Úloha 18: Projekcia matice tvrdenie × dôkaz a dôkazné bremeno

Matica z `fact-analyzer` je **deterministická projekcia** z `C-` a `E-` záznamov — presne
to, čo už vie render machinery pre lehoty. Nová mechanika netreba, iba nový blok.

**Files:** `lawoss/okf/src/render.ts`, test `lawoss/okf/tests/render-matrix.test.ts`

**Interfaces — Consumes:** typy `claim` a `evidence` z úlohy 17. **Produces:** nový `BlockName` `"evidence_matrix"`, marker `okf:render:evidence_matrix`.

**Akceptačné kritériá:**
- Blok je **marker-only** (ako `records` po úlohe 2) — sám sa do `_STATUS.md` nepridáva.
- Riadky sú `C-`, stĺpce `E-`, bunka nesie silu väzby; legenda sa renderuje pod tabuľkou.
- Pod maticou sa renderuje **dôkazné bremeno**: pre každé `C-` stĺpce „kto nesie bremeno / stav preukázania".
- Render je **idempotentný** a lokalizovaný — hlavičky v jazyku používateľa, marker kanonický.
- Prázdna množina `C-` nechá blok prázdny, nie rozbitý.
- ⚠️ **Nepočítaj právny záver.** `proof_status` je hodnota, ktorú zapísal advokát; projekcia ju **zobrazuje**, neodvodzuje z počtu dôkazov. Odvodzovať „3 dôkazy = preukázané" je presne ten druh tichej právnej domnienky, ktorý nástroj robiť nesmie.

---

### Úloha 19: Typ `task` — a koniec troch paralelných pamätí

`legal-orchestrator` má `LT-XXX` s overiteľnými akceptačnými kritériami, závislosťami
a stavom. OKF má `question` (otvorená otázka), ale **nemá úlohu**; §5 „Otvorené úlohy"
v `_STATUS.md` je dodnes ručná tabuľka.

**Files:** `lawoss/okf/src/schema.ts`, `src/render.ts`, test `lawoss/okf/tests/task-type.test.ts`

**Interfaces — Produces:** `RecordType` `task` (prefix `T-`), vrstva **L2**.

**Polia:** `assignee`, `depends_on` (zoznam `T-`), `acceptance` (zoznam overiteľných kritérií), `priority`, `state` (`pending` / `in_progress` / `done` / `blocked`), `due`.

**Akceptačné kritériá:**
- Cyklus v `depends_on` je nález `TASK_CYCLE` (error) — inak sa plán zacyklí a nikto si toho nevšimne.
- `state: blocked` bez neuzavretej závislosti je nález (warning) — blokovaná úloha bez blokátora je zabudnutá úloha.
- `due` v minulosti pri `state != done` je warning; **nemieša sa s `deadlines`** — procesná lehota a interná úloha nie sú to isté a zámena je nebezpečná.
- §5 `_STATUS.md` sa renderuje z `T-` záznamov (marker-only blok, rovnaká disciplína ako úloha 18).

> [!IMPORTANT]
> **Súčasťou tejto úlohy je zrušenie konkurenčných pamätí.** Dnes v jednom spise môžu
> žiť **tri**: `pamet/` (OKF), `_memory.md` + obsidiánový mirror (`memory-manager`)
> a `lrd.json` + `progress.txt` + `LEARNINGS.md` + `facts/` + `research/` + `strategy/`
> (`legal-orchestrator`). To je presne tá dvojitá — tu dokonca trojitá — pravda, kvôli
> ktorej OKF vzniká.
>
> **Kritérium:** po tejto úlohe `legal-orchestrator` a `memory-manager` zapisujú do OKF
> záznamov, nie do vlastných súborov. `progress.txt` nahrádza `## History` v zázname,
> `LEARNINGS.md` nahrádza L1 `lesson`, `lrd.json` nahrádzajú `T-` záznamy. Staré súbory
> sa **nemažú** (rovnaká disciplína ako pri `MEMORY.md` v úlohe 10) — len sa do nich
> prestane písať a v `BRAIN.md` sa označia ako archív.

---

### Úloha 20: `subject` o procesné postavenie a spôsobilosť

`fact-analyzer` má v `U-XXX` tri veci, ktoré OKF `subject` nemá a bez ktorých sa nedá
pripraviť podanie: procesné postavenie, zastúpenie a spôsobilosť byť účastníkom.

**Files:** `lawoss/okf/src/schema.ts`, test doplniť do `lawoss/okf/tests/schema-aml.test.ts`

**Polia:** `procedural_role` (žalobca / žalovaný / vedľajší účastník / …), `representation` (advokát a plná moc), `legal_capacity` (spôsobilosť byť účastníkom), `capacity_notes` (opatrovník, insolvencia, likvidácia).

**Akceptačné kritériá:**
- Polia sú **voliteľné** — nevstupujú do AML povinnej sady, tá vychádza zo zákona a nie z procesnej roly.
- `procedural_role` **nie je** to isté ako existujúce `role` (klient / protistrana). Jedno je vzťah ku kancelárii, druhé postavenie v konaní; ten istý subjekt môže byť klient **a** žalovaný. Test to musí ustrážiť, inak ich niekto zlúči.
- `capacity_notes` obsahujúce „insolvencia" pri subjekte v role klienta → warning s odkazom na kontrolu konfliktu záujmov.

---

### Úloha 21: `authority` o časovú platnosť a kontrolu citácie

Šesť „železných pravidiel" z `legal-researcher` je v skutočnosti **validačný kontrakt
pre vrstvu L3**, ktorý v OKF nie je. Dve sú strojovo vynutiteľné hneď.

**Files:** `lawoss/okf/src/schema.ts`, `src/validate.ts`, test `lawoss/okf/tests/authority-validity.test.ts`

**Polia:** `effective_from`, `effective_to` (časová platnosť predpisu), `verified_at` (kedy overené), `verified_against` (proti čomu — URL alebo názov databázy).

**Akceptačné kritériá:**
- Nález `AUTHORITY_STALE` (warning), keď `effective_to` je v minulosti — citácia zrušeného znenia.
- Nález `AUTHORITY_UNVERIFIED` (warning), keď `authority` nemá `verified_at` ani `verified_against`. **Prameň bez stopy overenia je dohad, nie prameň.**
- Kontrola citačného formátu: `§ X ods. Y písm. z) zák. č. A/RRRR Sb.` (CZ) a slovenský ekvivalent `Z. z.` Nesúlad je warning, nie chyba — formátov je v praxi viac a blokovať by otravovalo.
- ⚠️ **Nekontroluj, či predpis existuje.** To by znamenalo sieťové volanie zo `validate`, a jadro je zámerne bez sieťovej plochy. Overenie patrí skillom a MCP konektorom; sem sa zapisuje iba **výsledok** overenia — rovnaká deľba ako pri `screening`.

Táto úloha zároveň **dopĺňa dieru v pôvodnej implementácii**: spec 0002 žiada, aby L3
niesla „jurisdikciu a **časovú platnosť**". Jurisdikcia tam je od začiatku, časová
platnosť nie — bez nej systém nerozozná zastaranú citáciu, a to je chyba, ktorá sa
v podaní pozná neskoro.

---

### Úloha 22: Typovaná položka histórie — udalosť dostane druh, nie vlastný typ

Uzatvára rozbor `event` vyššie. `TimelineEntry.text` je dnes voľný text, takže projekcia
Chronológia nevie odlíšiť doručenie od pojednávania a nedá sa ani filtrovať, ani použiť
na odvodenie lehoty. **Riešením nie je nový typ záznamu, ale voliteľný druh na existujúcej
položke** — udalosť si identitu nezaslúži, kým sa nestane spornou (vtedy je z nej `claim`).

**Files:** `lawoss/okf/src/record.ts` (`TimelineEntry`, `parseTimeline`, `serializeRecord`), `lawoss/okf/src/write.ts` (`sameEntry`), `src/render.ts`, test `lawoss/okf/tests/timeline-kind.test.ts`

**Interfaces — Produces:**

```typescript
export interface TimelineEntry {
  readonly date: string;
  readonly text: string;
  /** Druh udalosti. Voliteľný — staré záznamy ho nemajú a musia ďalej fungovať. */
  readonly kind?: string;
}
```

Serializácia: `- 2026-09-01 [dorucenie] — text`. Dnešný parser je
`/^-\s*(\d{4}-\d{2}-\d{2})\s*[—-]\s*(.*)$/`; stačí doplniť voliteľnú skupinu
`(?:\[([a-z_]+)\]\s*)?` medzi dátum a pomlčku.

**Akceptačné kritériá:**
- **Spätná kompatibilita:** riadok bez `[...]` sa načíta ako doteraz, `kind` je `undefined`. Test nad existujúcimi fixture súbormi to musí ustrážiť.
- Round-trip so `kind` aj bez neho.
- ⚠️ **`sameEntry` vo `write.ts` musí porovnávať aj `kind`.** Dnes porovnáva iba `date` a `text` — bez doplnenia by šlo ticho prepísať druh existujúcej udalosti a `assertAppendOnly` by to pustil. To je diera v append-only záruke, nie kozmetika.
- Render Chronológie zobrazí druh vo vlastnom stĺpci; riadky bez druhu nechá prázdne, nie „—".
- Slovník druhov je **jurisdikčný a otvorený** — `dorucenie`, `podanie`, `pojednavanie`, `rozhodnutie`, `vyzva`, `hovor`, `email`. Neznámy druh je warning `UNKNOWN_EVENT_KIND`, nie chyba; advokátovi sa nebráni zapísať niečo, čo slovník nepozná.

**Čo do tejto úlohy nepatrí:** odvodzovanie lehôt z druhu udalosti. Že z `dorucenie`
plynie lehota, je právny záver a počíta ho `lhuta.py` / skill, nie pamäť. Sem patrí iba
údaj, z ktorého sa dá počítať.

---

## Koordinácia merge

1. [PR #64](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/64) (MČ) je postavený **na vetve `feat/vr-pamat-zjednotenie`**, nie na `main`. Podľa MČ: najprv zlúčiť #64 do VŘ vetvy, potom #63 do `main`.
2. [PR #24](https://github.com/Omni-Legal-Products/lawoss/pull/24) sa mergne až po úlohách 1 a 2.
3. Tento plán je na vetve `plan/okf-dalsie-prace`; po odklepnutí ho zlúč do `main`, aby ho ďalší agent našiel.

---

## Poznámky pre ďalšieho agenta

- **Čísla nálezov MČ ≠ čísla úloh tohto plánu.** Mapovanie je v tabuľke „Stav nálezov k 1. 9." vyššie. Pozor najmä na to, že verdikt review „merge po oprave N1 a N2" znamená úlohy **5 a 2**, nie 1 a 2.
- **N5 a N7 sú už opravené, nerob ich znova.** Over `git log --oneline` na vetve `feat/okf-pamat`; commity `a4b540e` a `55159fb`.
- **Codexis token vypršal 22. 6. 2026** a `cdx-sk` nemá nastavené `CDX_SK_API_URL`. Slovenskú legislatívu ber cez Playwright zo Slov-Lexu: `https://www.slov-lex.sk/ezbierky/pravne-predpisy/SK/ZZ/<rok>/<číslo>/<YYYYMMDD>` — portál vyžaduje JavaScript, `WebFetch` vráti iba hlavičku, `zakonyprolidi.cz` vracia 403.
- **Salvia MCP má vyčerpaný tarif** (3 000 volaní za obdobie). Českú legislatívu ber cez `https://krajta.slv.cz/<rok>/<číslo>/par_<N>`.
- **Overené právne ukotvenie AML sád** (nemeň bez nového overenia): CZ výpočet identifikačných údajov je **§ 5** zák. č. 253/2008 Sb., nie § 8 — ten upravuje vykonanie identifikácie. SK je § 7 ods. 1 zák. č. 297/2008 Z. z. Sady sa vecne líšia; detaily v `README.md` balíčka.
- **`bun` ani `corepack` na vývojovom stroji nie sú.** Používaj `node --test` a `npx -y pnpm@11.4.0`.
- **Schémy pre fázu 3b nájdeš v `/legal`**, nie v tomto repe: `~/.claude/agents/fact-analyzer.md` (typy `U-`/`E-`/`T-`/`D-`, matica, dôkazné bremeno), `~/.claude/agents/legal-orchestrator.md` (`LT-XXX`, štruktúra pamäte), `~/.claude/agents/legal-researcher.md` (železné pravidlá, citačné formáty). Sú to súbory VŘ mimo gitu — ak k nim nemáš prístup, vyžiadaj si ich, neodhaduj obsah.
- **Prefix `D-` je `decision`, nie dôkaz.** Staré spisy prejdené cez `/legal` môžu mať `D-XXX` v zmysle dôkaz; pod novou schémou je dôkaz `E-`. Viď upozornenie v úlohe 10.
- **Git guardrail hook grepuje text príkazu.** Skript alebo heredoc, ktorý len spomína zakázaný vzor, sa zablokuje — súbory s takým obsahom zapisuj cez nástroj na zápis súborov, nie cez `cat` heredoc v shelli.
