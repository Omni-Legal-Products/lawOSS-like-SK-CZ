# OKF architektúra: review PR #64 a decision sheet

Tento dokument je pracovný review podklad. Rozlišuje výsledok callu 1. 9. 2026 od nového odporúčania. Nenahrádza ďalšie tímové potvrdenie a neoprávňuje nikoho merge, approve ani implementovať produktový kód.

## Zdroje

- [PR #64](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/64)
- [Agenda D1–D9 a O1–O7](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/spec/okf-1-konsolidacia/meetings/2026-08-31-agenda-okf-architektura.md)
- [Zápis z callu 1. 9. 2026](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/spec/okf-1-konsolidacia/meetings/2026-09-01-zapis-okf-architektura.md)
- [Technické zadanie OKF do LAWOSS](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/spec/okf-1-konsolidacia/planning/2026-08-31-okf-lawoss-technicky-navrh-zadanie.md)
- [Spec 0014](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/spec/okf-1-konsolidacia/specs/0014-okf-1-kanonicky-kontrakt.md)
- [Spec 0015 – osobné dashboardy](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/spec/okf-1-konsolidacia/specs/0015-lawoss-okf-osobne-dashboardy.md)

## Záver review

**Odporúčanie: PR #64 neprijímať bez úpravy dokumentácie a bez doplnenia otvorených rozhodnutí.** PR má dobrý základ pre oddelenie OKF kontraktu a prezentačných dashboardov, ale po calle obsahuje neaktuálne tvrdenia o write pipeline a human gates. Je vhodné ho posunúť ako návrh na revíziu po aktualizácii specu 0014, nie ako hotový implementačný mandát.

Overený stav PR: otvorený, `mergeable: true`, `mergeable_state: clean`, 25 zmenených súborov, 7 757 pridaných a 24 odstránených riadkov, 25 commitov, bez review, komentárov a požadovaných reviewerov. Produktový fork v tejto zmene podľa popisu PR upravený nebol.

## D1–D9

| ID | Presný predmet | Záznam z callu | Review a odporúčanie | Tímové potvrdenie |
|---|---|---|---|---|
| D1 | Konsolidácia je kanonický smer podmienený technickým specom. | ✅ Prakticky potvrdené; ide sa pripravovať OKF Core. | **ACCEPTED WITH SCOPE** – doplniť hranice specu a zákaz produktovej implementácie pred mandátom. |  |
| D2 | `AGENTS.md` je kanonický bootstrap a `CLAUDE.md` byte-identický mirror. | ✅ Schválené. | **ACCEPT** – ponechať ako interoperabilný bootstrap a testovať byte-identitu. |  |
| D3 | Klientsky workspace obsahuje viac stabilne identifikovaných prípadov. | ✅ Schválené bez námietok. | **ACCEPT** – zachovať izoláciu stavu jednotlivých prípadov. |  |
| D4 | Perzistenčný machine contract je anglický a ľudské výstupy lokalizované. | ✅ Schválené; zodpovedá O6. | **ACCEPT** – migráciu schémy spojiť s O2; priečinky pre človeka môžu zostať lokalizované. |  |
| D5 | Typované records, `Truth + History`, vrstvy L1/L2/L3 a `lesson` zostávajú. | 🟡 Čiastočné; terminológia vrstiev sa musí písomne zosúladiť a `Truth + History` na calle nezaznelo. | **CHANGED / DEFERRED** – neoznačiť celý bod za schválený, kým sa neuzavrie terminológia a životný cyklus. |  |
| D6 | CLI, agent a LAWOSS používajú spoločný `plan -> validate -> approve -> apply` kontrakt. | ❌ Zamietnuté na calle. | **REJECTED AS WRITTEN** – z PR/specu odstrániť tvrdenie, že tento ceremoniál je schválený; osobitne vyjasniť minimálnu kontrolu konzistencie. |  |
| D7 | Chránené zmeny vynucuje Core a runtime approval, nie prompt alebo self-declared objekt. | ❌ Zamietnuté v tejto podobe; rozsah `L3_LEAK` ostal otvorený. | **REJECTED AS WRITTEN / OPEN L3_LEAK** – zachovať otázku ochrany zdieľanej vrstvy, ale rozhodnúť, či ide o hard validation, warning alebo kancelársku policy. |  |
| D8 | PR #24 je referenčný prototyp na zachovanie konceptov a testov, nie priamy kanonický základ. | ⏳ Na calle sa neprerokovalo. | **DEFERRED** – vyžiadať samostatné rozhodnutie v PR #66 alebo na najbližšom calle. |  |
| D9 | Dashboard sa odloží a MČ dostane mandát dopracovať technický spec. | 🟡 Upravené; dashboard je vizualizačný add-on a skills + technický spec majú ísť paralelne. | **CHANGED** – dashboardové HTML ponechať ako návrh, produktovú implementáciu podmieniť kontraktom a rozhodnutím o scope. |  |

## Kritické otázky

### O1 – `_STATUS.md` bez dvojitej pravdy

**Pozorovanie:** Zápis schválil render lehôt a chronológie z OKF v princípe, nie však konkrétne podmienky. Stanovisko MČ vyžaduje markery v existujúcich sekciách bez tichého appendu duplicitných sekcií, zachovanie freshness kontroly, jedno SSOT pre lehoty, voliteľný blok records a relatívne Markdown odkazy.

**Riziko:** Ak synchronizácia iba dotkne `_STATUS.md`, môže zakryť, že ručné sekcie o dokumentoch alebo úlohách zostali zastarané. Ak sa bez markerov pripojí nová sekcia, vzniknú dve pravdy.

**Odporúčanie:** O1 uzavrieť až po syntetickom fixture a jednom súkromnom pilotnom spise takto:

- lehoty a chronologické záznamy majú jeden kanonický typed record;
- `_STATUS.md` je projekcia iba v označených blokoch v existujúcich sekciách;
- chýbajúci marker pri existujúcej sekcii vyvolá retrofit alebo diagnostiku, nie tichý append;
- freshness používa explicitný ľudský stav alebo inú metódu, ktorú render nezamaskuje;
- `spis.md` frontmatter sa buď generuje z recordu, alebo sa z neho odstráni duplicitné pole;
- odkazy v projekcii sú relatívne Markdown odkazy; blok records je voliteľný.

**Stav:** `OPEN — needs fixture + pilot`.
**Dôkaz na uzavretie:** before/after fixture, test idempotencie, test driftu po renderi a diff bez duplicít.

### O2 – migrácia legacy

**Pozorovanie:** Na calle sa O2 priamo nepreberalo. Zadanie však počíta s retrofitom a stanovisko MČ žiada jednorazový, nedeštruktívny a idempotentný pilot; originálny `MEMORY.md` má zostať nedotknutý.

**Riziko:** Migrácia bez pilotu môže potichu stratiť význam, odkazy alebo nejednoznačné záznamy. Pri súbežnej zmene schémy by sa migrovalo dvakrát.

**Odporúčanie:** O2 spojiť s O6 a vykonať v poradí `detect -> dry-run -> review diff -> apply copy -> validate -> report`. Pilot má:

- pracovať na jednom skutočnom, neverejnom spise mimo gitu;
- zachovať originály, nič nemažeť ani nepresúvať;
- byť opakovateľný a idempotentný;
- explicitne mapovať `TP -> decision`, `LL -> lesson`, `OQ -> question` a nejednoznačné položky ponechať ako finding;
- vložiť status markery ako súčasť toho istého retrofit protokolu;
- používať anglickú cieľovú schému podľa O6;
- do repozitára pridať iba syntetické alebo sanitizované fixtures.

**Stav:** `OPEN — pilot required`.
**Dôkaz na uzavretie:** report z pilotu, hash/originálna kópia, opakovaný dry-run s nulovým neplánovaným diffom a validačný výstup.

### O6 – anglická perzistenčná schéma

**Pozorovanie:** O6/D4 bolo schválené. Machine contract má používať anglické kľúče, enumy, systémové súbory, markery a `memory/`; lokalizácia patrí do UI, ľudských výstupov a názvov priečinkov.

**Odporúčanie:** O6 prijať ako cieľ nového kontraktu a migrácie. Jurisdikcia má byť hodnotou poľa, nie názvom priečinka. Treba ešte vytvoriť mapovaciu tabuľku a fixture SK/CZ, aby sa preklad nezamieňal s odlišným právnym pojmom.

**Stav:** `ACCEPTED IN CALL — spec update required`.
**Dôkaz na uzavretie:** schema map, SK/CZ fixture, byte-identický bootstrap a migrácia bez straty lokalizovaných ľudských priečinkov.

## Ďalšie mismatchy a riziká PR #64

1. **Šírka zmeny:** 7 757 pridaných riadkov a šesť high-fidelity smerov je primeraných na exploration, nie na implicitné schválenie produktu. Spec 0015 správne uvádza HTML ako prezentačný artefakt; túto hranicu treba ponechať viditeľnú.
2. **Dashboard vs. kontrakt:** Dashboardový read model musí byť striktne odvodený z OKF a každá právne významná hodnota musí mať provenance. Personalizácia smie meniť iba layout, widgety a scope.
3. **D6/D7 vs. UI plán:** Ak produktový dashboard neskôr zobrazuje human gate, nesmie tým spätne tvrdiť, že tím schválil zamietnutý `plan -> validate -> approve -> apply` protokol. Zobrazenie provenance a návrhu treba oddeliť od schváleného zápisového mechanizmu.
4. **D8:** PR #24 treba označiť ako `reference prototype`, `source of selected concepts/tests` alebo `superseded`; bez tejto voľby ostáva architektonická hranica nejasná.
5. **D9:** Predvolený preset, scope defaults a prvá sada widgetov sú v spec 0015 stále otvorené produktové rozhodnutia, nie implementačné úlohy.

## Gate pred prijatím PR #64

- [ ] spec 0014 odráža zápis z 1. 9. vrátane zamietnutia D6/D7;
- [ ] O1 má fixture, freshness pravidlo a zákaz duplicitného appendu;
- [ ] O2 má pilotný protokol a mapping na anglickú schému;
- [ ] O6 má mapovaciu tabuľku, SK/CZ fixtures a jasnú hranicu lokalizácie;
- [ ] D5 má zosúladenú terminológiu vrstiev a potvrdený alebo odložený `Truth + History`;
- [ ] D8 je samostatne rozhodnuté;
- [ ] D9 jasne oddeľuje prezentačný návrh od produktovej implementácie;
- [ ] pre dashboard je definovaný rovnaký snapshot, provenance, diagnostika a read-only fallback;
- [ ] sú priložené výsledky syntetických testov a žiadne klientské dáta;
- [ ] tím doplní vlastníkov, termíny a výsledné stavy v rozhodovacom liste.

## Rozhodnutie tímu

| Dátum | Účastníci | Rozhodnutie | Odkaz na zápis/komentár |
|---|---|---|---|
|  |  |  |  |

Kým táto tabuľka nie je doplnená tímom, dokument je odporúčanie a PR #64 zostáva návrhom na revíziu.
