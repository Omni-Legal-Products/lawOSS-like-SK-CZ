---
type: note
title: Review PR #24 (fork) - pamäťové jadro OKF
updated: 2026-08-29
---

# Review - [PR #24](https://github.com/Omni-Legal-Products/lawoss/pull/24) `feat/okf-pamat`

**Verdikt: merge po oprave N1 a N2.** Kód je čistý, bez runtime závislostí, komentáre vysvetľujú *prečo*. Brány zápisu sú naozaj v nástroji, nie v prompte - to je presne ADR 0007. Nálezy nižšie sú tri vecné a zvyšok drobnosti.

## Overené lokálne (nie prevzaté z popisu PR)

```bash
git fetch origin 'refs/pull/24/head:refs/remotes/pr/24'
git archive pr/24 lawoss/okf | tar -x -C <tmp>
cd <tmp>/lawoss/okf && corepack pnpm install --ignore-workspace --frozen-lockfile
corepack pnpm typecheck && corepack pnpm test
```

- **70/70 testov zelených, typecheck čistý** (node 24.19.0, pnpm 11.22.0).
- **Projekcia je idempotentná** - dvojitý `sync --apply` nezmenil bajt (md5 zhodné).
- `validate` na čistej pamäti vracia `OK` a exit 0.

## Uzavreté: CI workflow **nie je** zásah do upstreamu

Handoff to viedol ako 🟡. **Nie je to nález.** `PATCHES.md` hovorí doslova: *„New LAWOSS-owned files do not need an entry."* `ci-okf-pamat.yml` je nový súbor, nie zmena zdedeného - a precedens už máme (`telegram-notify.yml`, commit `dfaea7a`, tiež bez riadku v PATCHES). Tvrdenie PR o nula zmenených upstream súboroch **sedí**. Prosím nerozoberať to na calle.

Balíček mimo pnpm workspace s vlastným lockfile je takisto v poriadku a zámerné - `--ignore-workspace --frozen-lockfile` v CI to drží konzistentné a upstream strom nepribral uzol.

---

## N1 🔴 `init` nezaloží adresár pamäte → slovenský spis dostane český `pamet/` a české nadpisy

`cli.ts init` sľubuje „BRAIN.md a adresár pamäte", ale volá iba `ensureBrain()`. Adresár nevznikne. `readStore()` potom jurisdikciu deteguje **výhradne podľa existencie priečinka** (`detect()`), nenájde nič a padne na default `"cz"` - a prvý zápis založí `pamet/` aj v spise, ktorý bol inicializovaný s `--sk`.

**Repro (šablóna `_STATUS.md` z `mc-novy-spis`):**

```
$ okf-memory init <spis> --sk --apply
Založené: BRAIN.md (sk).
$ ls <spis>            → BRAIN.md  _STATUS.md          # žiadne pamat/
# zápis SK záznamu cez API (jurisdiction: "sk")
$ ls <spis>            → BRAIN.md  _STATUS.md  pamet/  # ← český priečinok
$ okf-memory sync <spis> --apply
→ do _STATUS.md pribudlo:  ## Lhůty / ## Chronologie / ## Záznamy paměti
   s hlavičkami | Datum | Věc | Záznam |
```

Slovenský spis tak dostane českú nomenklatúru a už ju nikdy nestratí - `detect()` bude navždy vracať `cz`.

**Návrh opravy:**
- `init` vytvorí `pamat/` / `pamet/` podľa jurisdikcie (a `ensureBrain` nech je až druhý krok).
- `readStore()` nech jurisdikciu berie zo `spis.md` / z jurisdikcie zapisovaného záznamu; keď ju nevie určiť a adresár neexistuje, nech **zlyhá** namiesto tichého `?? "cz"`.
- `applyRecordWrite` nech odmietne zápis SK záznamu do `pamet/` (a naopak) - mix jurisdikcií v jednom spise je chyba, nie stav.

> Poznámka: **ak prejde O6** (kanonická angličtina v jadre, [`stanovisko-mc.md`](stanovisko-mc.md)), celá táto trieda chýb zaniká - priečinok je jeden `memory/` a jurisdikcia je hodnota poľa, nie názov adresára. Potom sa neopravuje `detect()`, ale sa ruší.

## N2 🔴 `renderStatus` pripája duplicitné sekcie namiesto vyplnenia existujúcich

Bez markerov `appendBlock` pripojí novú sekciu na koniec. Na mojej šablóne výsledok obsahuje `## 3. Lehoty` (ručná, prázdna) **aj** `## Lhůty` (renderovaná) - dvojitá pravda, teda presne to, čo má O1 odstrániť.

**Návrh:** markery patria do šablóny vnútri `§3` a `§4`, do existujúcich spisov ich injektuje `retrofit.sh`. Keď render nájde nadpis Lehoty/Chronológia bez markerov, nech skončí chybou s odkazom na retrofit, nie tichým appendom. Detaily a súvisiace podmienky: [`stanovisko-mc.md`](stanovisko-mc.md), O1.

## N3 🟡 Štvrtá brána (`L3_LEAK`) nie je v ceste zápisu

`zjednotenie.md` uvádza štyri brány „v nástroji, nie v prompte". Tri naozaj sú (`assertAppendOnly`, `assertTruthTraced`, `authorize`). Kontrola úniku L2→L3 žije iba v `okf-memory validate` - `applyRecordWrite` ju nevolá, takže záznam s IČO klienta v prameni na disk **prejde** a chytí ho až samostatný beh validácie.

Zmierňujúca okolnosť: zápis do L3 aj tak vyžaduje schválenie človekom, takže to nie je tichý únik. Ale kontrakt treba zosúladiť - buď `applyRecordWrite` pustí `validateStore` nad dotknutým záznamom a pri `error` zápis odmietne, alebo `zjednotenie.md` prestane tvrdiť, že brány sú štyri.

## N4 🟡 `Approval` je self-declared - bránu si volajúci vie vyrobiť sám

`authorize()` prejde pri akomkoľvek neprázdnom `{ by, at }`. Knižničný volajúci (aj agent) si súhlas jednoducho zostrojí. Human gate je teda **konvencia API**, nie hranica.

Dnes to nehorí, lebo CLI zápis záznamov vôbec nemá. **Návrh:** urobiť z CLI jedinú zápisovú hranicu (`okf-memory write … --approve-as "<meno>"` s interaktívnym potvrdením diffu) a do `SKILL.md` napísať, odkiaľ `Approval` smie pochádzať. Inak sa o rok nájde agent, ktorý si `by: "agent"` napíše sám.

## N5 🟡 Jeden pokazený záznam zhodí celý store

`readStore()` volá `parseRecord()` v cykle a prvá výnimka prebublá až von - `okf-memory validate` skončí neošetreným stack tracom namiesto nálezu. Nástroj na kontrolu konzistencie by mal nekonzistenciu **nahlásiť**, nie na nej spadnúť.

```
$ printf -- '---\nnieco: zle\n---\n' > <spis>/pamet/R-999-zly.md
$ okf-memory validate <spis>
Error: Nedá sa určiť jurisdikcia - ...  ← stack trace, exit 1
```

**Návrh:** zbierať chyby po súboroch a vracať ich ako `Finding` s kódom `PARSE_ERROR`.

## N6 🟡 Čiarka v zoznamovom poli ticho rozbije záznam - trafí `s.r.o.` a `a.s.`

`emit()` serializuje zoznamy ako `["a", "b"]`, `parseScalar()` ich delí na **každej** čiarke a `unquote()` už polovice neopraví. Slovenské a české obchodné meno má čiarku v kanonickom tvare - a `strany:` je presne pole, kam patrí.

```
zapísané:   strany: ["Doprava, s.r.o.", "Novák, a.s."]
prečítané:  ["\"Doprava", "s.r.o.\"", "\"Novák", "a.s.\""]
```

Dva subjekty sa zmenia na štyri zmrzačené reťazce, **bez chyby a bez varovania** - pri prvom read-modify-write cykle. To isté sa týka `zdroje:`, `oblast_prava:` aj `suvisi:`. Skalárne polia sú v poriadku (`nazov: Doprava, s.r.o.` round-trip prežije), rozpadajú sa iba zoznamy.

**Návrh:** buď parsovať zoznamy s rešpektom k úvodzovkám (jednoduchý stavový split), alebo zoznamy zapisovať v blokovej YAML forme (`- "Doprava, s.r.o."`). Do testov patrí round-trip s čiarkou v hodnote - dnes ho tam žiadny nie je.

Či to blokuje merge spolu s N1/N2, nechávam na tíme; ako „drobnosť" to ale nesmie zapadnúť, lebo mlčky kazí dáta na najbežnejšom legitímnom vstupe.

## N7 🟢 `L3_LEAK` má priestor na falošné nálezy

Hľadá sa substring z `title` subjektu už od 4 znakov, case-insensitive. Prameň, ktorý cituje `Slovenská republika` alebo bežné slovo v obchodnom mene protistrany, spadne ako `error`. Pri obchodných menách typu „Doprava s.r.o." to bude bolieť. Návrh: identifikátory (IČO, dátum narodenia) držať ako `error`, zhodu na mene ako `warning`, prípadne hľadať celé slovo, nie substring.

## N8 🟢 Drobnosti

- `writeIndex()` aj `renderRecords()` majú ternárny operátor, ktorého obe vetvy sú identické (`| Záznam | Typ | ... |`). Buď sa CZ hlavička má líšiť, alebo ternár preč.
- `planWrite` nekontroluje, že `update` bumpol `zmena:`. `STALE_UPDATED` to chytí až vo `validate` - logickejšie je to pri zápise.
- `init` má default jurisdikcie `cz` (`--sk` je opt-in). V SK spisoch to bude častý omyl; default nech ide zo `spis.md`, nie z prepínača.

---

## Poradie prác

1. N1 + N2 opraviť v PR #24 (obe majú test, ktorý dnes chýba: SK spis end-to-end a render nad šablónou `mc-novy-spis`).
2. Call 1. 9. - odklep O1 s podmienkami.
3. Merge koordinácia #63 → fork #24.
4. Až potom parser pre UI a napojenie dashboardu spisu (design-system §5).
