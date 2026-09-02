# Plán: nasadenie OKF pamäte do aplikácie (fáza C1–C3)

- **Navrhol:** Vojta Říha (VŘ) · 2026-09-02
- **Nadväzuje na:** [plán ďalších prác na OKF pamäti](2026-09-01-okf-pamat-dalsie-prace.md) · [PR lawoss#24](https://github.com/Omni-Legal-Products/lawoss/pull/24) · [PR lawoss#31](https://github.com/Omni-Legal-Products/lawoss/pull/31)
- **Stav:** návrh — čaká na odklep

---

## Prečo tento plán

Po bráne D1 (1. 9.) zostáva väčšina zvyšných úloh pamäťového plánu **za nerozhodnutými bodmi** — O1 podmienky, O7, bod c, migrácia. Zároveň platí, že jadro je hotové, obidva PR sú `mergeable` a CI zelené. Vzniká tým stav, ktorý sa ľahko prehliadne: **kód, ktorý nikto nevidí v aplikácii, je z pohľadu advokáta zatiaľ nulová hodnota.**

Tento plán pomenúva presne tú časť, ktorá je **schválená, odblokovaná a dá sa písať hneď** — bez toho, aby predbiehala čokoľvek, o čom sa má rozhodnúť 7. 9.

## Čo je schválené a čo nie

| Bod | Stav po D1 | Dopad na tento plán |
|---|---|---|
| **O6** kanonická angličtina | ✅ **ÁNO** | jadro hotové, schéma stabilná — čítať sa dá |
| **O1** render lehôt a chronológie | ✅ **ÁNO v princípe** | projekcia schválená; otvorené sú len *podmienky* (markery, drift, SSOT, odkazy) |
| **O3** AML u klienta | ✅ bez námietok | `subject`/`screening` sa dajú zobraziť |
| **D8** PR #24 | ✅ vyriešené technicky 2. 9. | `lawoss/okf-pamat/` a `lawoss/okf/` koexistujú |
| **O7** + bod c (`L3_LEAK`) | ⛔ otvorené | **nedotýkať sa** — úloha 14 |
| **O1 podmienky** | ⛔ otvorené | **nedotýkať sa** — úlohy 11, 12, 13 |
| **O2** migrácia | ⛔ chce pilot na reálnom spise | **nedotýkať sa** — úloha 10 |

## Odblokovanie úlohy 16 — dôvod, ktorý prestal platiť

Pamäťový plán hovorí pri úlohe 16 (parser pre UI a dashboard): *„nezačínaj pred dokončením úlohy 10 — dashboard nad nemigrovanými dátami nemá čo zobraziť."*

**Ten dôvod padol 2. 9.** Fáza A od MČ je na `dev` a `/novy-spis` zakladá **nové** spisy priamo v OKF tvare. Pre ne nie je čo migrovať. Migrácia už teda nie je podmienkou dashboardu — je to len **rozšírenie jeho záberu na staré spisy**.

Poradie sa tým otáča a je to k lepšiemu: dashboard postavený nad novými spismi je zároveň **prvý reálny test schémy**, ktorý úloha 15 (publikácia štandardu) aj tak vyžaduje — len ho dostaneme skôr a lacnejšie než cez dávkovú migráciu klientskych dát.

## Čo aplikácia už má a na čo čaká

`apps/app/src/lawoss/experiments/registry.ts` má tri obrazovky, ktoré na pamäť priamo čakajú:

| Obrazovka | Poznámka MČ v registry | Súbor |
|---|---|---|
| **Prehľad** | *„fiktívne dáta, čaká na `lawoss/okf/read.ts` (fáza C1)"* | `apps/app/src/lawoss/domains/prehlad/prehlad-page.tsx` |
| **Lehoty** | *„fiktívne dáta, SK a CZ sa musia modelovať zvlášť"* | `apps/app/src/lawoss/domains/lehoty/lehoty-page.tsx` |
| Nový spis | Fáza A, **hotová** | `novy-spis-page.tsx` |

`read.ts` je teda **pomenovaná závislosť od MČ**, nie môj nápad. Tento plán ju dodáva.

### Dve zistenia, ktoré návrh zjednodušujú

1. **Šesť z deviatich modulov jadra je už browser-safe.** `node:fs` sa dotýkajú iba `store.ts`, `config.ts` a `cli.ts`. `schema` · `record` · `render` · `validate` · `mask` · `write` sú čisté. **Refaktor netreba.**
2. **Aplikácia importuje jadro relatívnou cestou, nie cez názov balíčka** — `apps/app/tests/lawoss-okf.test.ts` robí `import … from "../../../lawoss/okf/src/core"`. Netreba teda ani `exports` mapu, ani `browser.ts`. Stačí, aby `read.ts` sám neimportoval `store.ts`.

> [!WARNING]
> `index.ts` re-exportuje `store.ts`, takže **z aplikácie sa nesmie importovať `index.ts`** — pritiahol by `node:fs` do bundle. Vstupom pre UI je výhradne `read.ts`.

---

## C1 — `read.ts`: čítanie pamäte pre UI

**Files:** `lawoss/okf-pamat/src/read.ts` (nový), `lawoss/okf-pamat/src/render.ts` (extrakcia), `lawoss/okf-pamat/tests/read.test.ts` (nový)

Čistá funkcia nad obsahom súborov. **Nesiaha na disk** — súbory načíta volajúci (v aplikácii cez `legalmemory-tree` / desktop bridge, v CLI cez `store.ts`). Vďaka tomu je testovateľná bez dočasných adresárov a použiteľná v prehliadači.

```ts
export type Subor = { path: string; content: string };

export type PrehladSpisu = {
  zaznamov: number;
  lehoty: LehotaRiadok[];       // zoradené, najbližšia prvá
  otvoreneUlohy: UlohaRiadok[];
  nalezy: Finding[];            // z validateStore, bez druhého parsovania
  necitatelne: { path: string; dovod: string }[];
};

export function citajPamat(subory: readonly Subor[], dnes: string): PrehladSpisu;
```

**Extrakcia, nie duplikácia.** `render.ts` dnes stavia riadky lehôt a úloh priamo do markdownu. Vytiahnuť z neho čisté `zberLehot(records)` a `zberUloh(records)`, ktoré budú používať **obidve** cesty — markdownová projekcia aj `read.ts`. Druhá implementácia toho istého by sa o pol roka rozišla.

**Akceptačné kritériá:**
- `citajPamat` neimportuje `node:fs` ani `store.ts` — stráži to test, ktorý číta zdroják a hľadá `node:`.
- Poškodený súbor **nezhodí celé čítanie** — skončí v `necitatelne` s dôvodom a zvyšok sa spracuje. Dashboard, ktorý spadne na jednom rozbitom zázname, je horší než dashboard bez neho.
- Lehoty sú zoradené vzostupne a nesú `id` záznamu, aby sa dalo prekliknúť.
- `nalezy` pochádzajú z existujúceho `validateStore`, nie z novej kontroly.
- Prázdny vstup vráti prázdny prehľad, nie výnimku.

## C2 — Prehľad nad reálnymi dátami

**Files:** `apps/app/src/lawoss/domains/prehlad/prehlad-page.tsx`, `apps/app/src/lawoss/okf/citanie.ts` (nový — spojenie `read.ts` s workspace), `apps/app/tests/lawoss-prehlad.test.ts`

Dnes je stránka hardcoded JSX s fiktívnymi číslami (24 spisov, 7 lehôt). Nahradiť skutočnými z `citajPamat`.

**Akceptačné kritériá:**
- Čísla v hlavičke pochádzajú z pamäte, nie z literálov.
- **Prázdny stav je navrhnutý**, nie nula: keď workspace nemá OKF spis, stránka povie čo urobiť (založ spis cez `/novy-spis`), nie „0 spisov".
- Zlyhanie spojenia na server nezhodí stránku — ukáže sa hláška a stránka zostane použiteľná.
- Test overuje mapovanie dát na zobrazené hodnoty, nie vzhľad.

## C3 — Lehoty nad reálnymi dátami (čiastočne)

**Files:** `apps/app/src/lawoss/domains/lehoty/lehoty-page.tsx`, test

> [!IMPORTANT]
> **Vedomé obmedzenie.** Záznam dnes nesie lehotu ako `deadlines: [dátum]` — dátum a nič viac. Odkiaľ lehota plynie, koľko dní má a či je procesná alebo interná, schéma zatiaľ nevie; to je **úloha 13 (SSOT lehôt), ktorá je blokovaná O1**.
>
> C3 preto zobrazí **dátum + vec + odkaz na záznam** a nič viac. Počítanie lehôt (§ 57 o. s. ř., SK zvlášť) do tejto fázy **nepatrí** — vyžaduje rozhodnutie 13 a CZ/SK sa modeluje oddelene.

**Akceptačné kritériá:**
- Zoznam je zoradený a rozlišuje „po termíne" od „tento týždeň".
- Stránka **nikde netvrdí, že lehotu vypočítala** — zobrazuje zapísanú.
- CZ a SK spisy môžu ležať vedľa seba (jurisdikcia je hodnota poľa).

---

## Čo v tejto fáze zámerne nerobíme

| Nerobiť | Prečo |
|---|---|
| Úlohy 11, 12, 13 | podmienky O1 nie sú dorozhodnuté |
| Úloha 14 (prahy) | O7 a bod c otvorené |
| Úloha 10 (migrácia) | chce pilot na reálnom spise — a **už nie je podmienkou** dashboardu |
| Zápis z UI | zápis vedie cez `okf-memory write`. UI v tejto fáze **iba číta.** |
| Počítanie lehôt | úloha 13 + oddelené CZ/SK modelovanie |
| Zliatie balíčkov `okf` + `okf-pamat` | otázka na 7. 9., nič neblokuje |

**Read-only je zámer, nie zjednodušenie.** Kým sa nedorozhodne bod c a podmienky O1, nemá zmysel stavať zápisovú cestu, ktorá sa môže zmeniť. Čítanie žiadnu z otvorených otázok nepredbieha.

## Poradie a odhad

| | Čo | Závisí od | Veľkosť |
|---|---|---|---|
| **C1** | `read.ts` + extrakcia z `render.ts` | nič — dá sa začať hneď | malé |
| **C2** | Prehľad | C1 | stredné (hlavne prázdny stav a chybové cesty) |
| **C3** | Lehoty | C1 | malé |

C1 sa dá odovzdať samostatným PR do `lawoss/okf-pamat/` ešte pred zlúčením #24, ak sa tím rozhodne #24 podržať.

## Overenie

```bash
# jadro
cd lawoss/okf-pamat && node --test 'tests/**/*.test.ts' && npx tsc --noEmit -p .

# aplikácia
cd apps/app && bun test tests/ && pnpm typecheck
```

Ručne, na skutočnom spise: založiť spis cez `/novy-spis` (Fáza A), zapísať doň zopár záznamov cez `okf-memory write`, otvoriť Prehľad a Lehoty a overiť, že čísla sedia s obsahom `memory/`. Potom ten istý spis **vyprázdniť** a overiť prázdny stav — to je stav, v ktorom obrazovku uvidí každý nový používateľ ako prvý.

## Otvorené otázky pre tím

1. **Vlastníctvo obrazoviek.** Prehľad a Lehoty sú v registry vedené na MČ. Tento plán ich napĺňa dátami — **prevzatie treba potvrdiť**, nech si nešliapeme po nohách.
2. **Kde má `read.ts` bývať.** MČ ho v registry pomenoval `lawoss/okf/read.ts`, teda vo svojom balíčku. Navrhujem `lawoss/okf-pamat/src/read.ts`, lebo číta pamäť, nie štruktúru priečinka — ale ak sa balíčky 7. 9. zlejú, otázka zanikne.
3. **Prehľad je dnes „praxe", nie „spis".** Fiktívne čísla agregujú celú prax (24 spisov). `citajPamat` číta jeden spis. Agregácia naprieč spismi je ďalší krok — patrí do C4, alebo sa má robiť rovno?
