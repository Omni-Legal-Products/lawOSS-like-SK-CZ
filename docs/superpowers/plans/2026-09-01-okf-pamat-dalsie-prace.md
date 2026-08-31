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

**Stav nálezov k 1. 9. 2026** — over pred začatím, časť je už hotová:

| Nález | Stav |
|---|---|
| N5 jeden pokazený záznam zhodí store | ✅ **hotové** (commit `a4b540e`) — v úlohe 6 zostáva len premenovať kód na `PARSE_ERROR` |
| N7 `L3_LEAK` falošné nálezy | ✅ **hotové** (commit `55159fb`) — celé slovo, meno → `warning`, identifikátory → `error`. Kryje väčšinu O7. |
| N6 čiarka v zozname | ✅ **hotové 1. 9.** (commit `1a42187`) — úloha 1 dokončená |
| N2 duplicitné sekcie | ❌ otvorené — **úloha 2** |
| N3 štvrtá brána mimo zápisu | ❌ otvorené — **úloha 3** |
| N4 `Approval` self-declared | ❌ otvorené — **úloha 4** |
| N1 `init` nezaloží adresár | ❌ otvorené — **úloha 5**, závisí od D1 |
| N8 drobnosti | ❌ otvorené — **úloha 6** |

---

## D1 — Brána rozhodnutia (call 1. 9. 2026, 10:30)

**Toto nie je úloha na implementáciu. Je to brána.** Úlohy 5 a vyššie sa nesmú začať, kým nie je rozhodnuté.

Na hlasovanie idú body O1–O7 podľa [`stanovisko-mc.md`](../../../research/okf-implementacie/stanovisko-mc.md). Pre kód sú rozhodujúce dva:

- **O6 — kanonická angličtina v jadre.** Ak prejde: `pamet/`/`pamat/` → jeden `memory/`, kľúče a enumy po anglicky, `## Pravda` → `## Truth`, mapovacia tabuľka prestane byť perzistenčnou schémou a stane sa i18n vrstvou. **Zaniká tým celá trieda chýb N1.**
- **O1 podmienky** — markery do existujúcich sekcií, `records` blok von zo `_STATUS.md`, markdown odkazy namiesto `[[…]]`, oprava maskovania driftu cez `sync`.

**Po calle zapíš rozhodnutie sem** (aby ho ďalší agent nemusel dohľadávať):

```
D1 rozhodnuté dňa: ____________
O1: ÁNO / NIE / s podmienkami: ____________
O6 kanonická angličtina: ÁNO / NIE
O7 konfigurovateľné prahy: ÁNO / NIE
Ostatné (O2–O5): ____________
```

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

### Úloha 2: Render pripája duplicitné sekcie namiesto vyplnenia existujúcich (N2) 🔴

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

- [ ] **Krok 1: Napíš padajúci test**

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

- [ ] **Krok 2: Spusti test a over, že padá**

```bash
node --test tests/render-conflict.test.ts
```

Očakávané: import `RenderConflictError` zlyhá, takže padne celý súbor. Po pridaní triedy padnú prvé dva testy na tom, že sa výnimka nevyhadzuje.

- [ ] **Krok 3: Implementuj**

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

- [ ] **Krok 4: Zachyť výnimku v CLI a uprav starý test**

V `lawoss/okf/src/cli.ts` doplň import `RenderConflictError` z `./render.ts` a obaľ telo vetvy `case "sync"` do `try { … } catch (e) { if (e instanceof RenderConflictError) return { code: 1, out: \`KONFLIKT: ${e.message}\` }; throw e; }`.

V `lawoss/okf/tests/render.test.ts` uprav test „chybajuci blok sa doplni aj s markermi" — má očakávať doplnenie iba blokov `deadlines` a `timeline`. Pridaj k nemu komentár, že `records` je odteraz marker-only podľa podmienky MČ k O1.

- [ ] **Krok 5: Spusti testy**

```bash
node --test 'tests/**/*.test.ts' && ./node_modules/.bin/tsc -p tsconfig.json --noEmit
```

Očakávané: 0 fail, typecheck exit 0.

- [ ] **Krok 6: Commit**

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

### Úloha 5: `init` nezaloží adresár pamäte a jurisdikcia sa háda (N1)

⚠️ **Závisí od D1/O6.** Ak O6 prejde, **táto úloha zaniká** — adresár je jeden `memory/` a jurisdikcia je hodnota poľa, nie názov priečinka. Vtedy preskoč na úlohu 8.

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

`TP-XXX → decision`, `LL-XXX → lesson`, `OQ-XXX → question`. Pôvodný `MEMORY.md` zostáva **nedotknutý** — konverzia je čítanie → zápis. Idempotentné, žiadne mazanie ani presuny. Id nesie prefix odvodený z typu (`D-`, `L-`, `Q-`, `S-`, `A-`), nie ploché `R-`. `LL → lesson` je L1, takže migračný skript beží **ako človek** s jedným súhrnným diffom na odklep. Súčasťou je injektáž markerov do `_STATUS.md`. **Najprv pilot na jednom reálnom spise, až potom dávka.**

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

Posledná v poradí podľa MČ. `lawoss/okf/read.ts` ako vstup pre appku, dashboard renderovaný z markdownov (design-system §5). **Nezačínaj pred dokončením úlohy 10** — dashboard nad nemigrovanými dátami nemá čo zobraziť.

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
- **Git guardrail hook grepuje text príkazu.** Skript alebo heredoc, ktorý len spomína zakázaný vzor, sa zablokuje — súbory s takým obsahom zapisuj cez nástroj na zápis súborov, nie cez `cat` heredoc v shelli.
