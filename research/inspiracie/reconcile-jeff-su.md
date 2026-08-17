# Reconcile (Jeff Su) — učenie AI z vlastných chýb

*Analýza k 2026-08-11 — zdroj: súbor `reconcile.zip` (SKILL.md) zdieľaný MČ; web overený cez fetch coworkacademy.ai 2026-08-11.*

## Čo to je

Agent skill **reconcile** od Jeffa Su (Cowork Academy, ex-Google, ~2M odberateľov na YouTube). Rieši jednoduchý, ale zásadný problém: **AI draft nikdy nie je finál** — používateľ ho upraví a tie úpravy sú najcennejší tréningový signál, ktorý sa bežne zahodí. Skill porovná draft s finálnou verziou a z rozdielov vytiahne **najmenšiu možnú zmenu inštrukcií**, ktorá by tej istej chybe nabudúce zabránila.

## Ako funguje (mechanika, vlastnými slovami)

| Fáza | Čo robí |
|---|---|
| 1. Porovnanie | úplný súpis zmien draft → finál; triedenie na **materiálne** (zmysel, štruktúra, tón, opakovateľný vzor) vs. **triviálne** (preklepy, jednorazovosti) |
| 2. Diagnóza | čo materiálna zmena **demonštruje** (nie „čo si používateľ myslel") a ako sa vzťahuje k existujúcim inštrukciám |
| 3. Brána presnosti | 5 testov pred každou zmenou inštrukcií: dôkaz · opakovateľnosť · prevencia · rozsah · umiestnenie |
| 4. Návrh | dispozícia v poradí preferencie: **delete → merge → move → rewrite → stage → add** — teda najprv orezať existujúce, pridávať až keď nič menšie nefunguje |
| 5. Aplikácia | len po schválení používateľom; overiť, že zmena by pôvodnú chybu naozaj zachytila |

## Prečo je to múdre (a čo si berieme)

1. **„Prune before adding"** — kratší a ostrejší súbor inštrukcií je spoľahlivejší než rastúci zoznam úzkych pravidiel. Priama ochrana proti degradácii promptov časom.
2. **„Stage" dispozícia** — jedna úprava ešte nie je pravidlo; slabé signály sa odkladajú, kým sa nepotvrdia. Ochrana proti preučeniu z jednorazovosti.
3. **Poistky:** nikdy neprepisovať inštrukcie bez súhlasu · ak finál vyzerá horší než draft, zmenu zahodiť (nie sa ju „naučiť") · konflikt učenia s existujúcim explicitným pravidlom sa flaguje, nerieši sa tichým prepisom.
4. **Atribúcia k textu, nie k úmyslu** — skill popisuje, čo zmena textu demonštruje, nešpekuluje o skrytých motívoch.

## ⚠️ Licencia a použitie

- Skill je **súčasť plateného kurzu** (AI Command Center, coworkacademy.ai) — *overené fetchom webu 2026-08-11*. Zip neobsahuje licenciu, web redistribúciu nerieši.
- **Dôsledok: pôvodný text skillu sa do tohto verejného repa nekopíruje** a nekopíruje sa ani do budúceho LAWOSS balíka. Adaptujeme **koncept a mechaniku vlastnými slovami** s uvedením zdroja — koncepty nie sú chránené, vyjadrenie áno.

## Vzťah k našim nápadom

- **Konkretizuje #21 (tiered memory)** — reconcile je presne ten *mechanizmus učenia*, ktorý nápadu #21 chýbal: definuje, ČO sa do pamäti zapisuje a kedy.
- **Kŕmi spec 0003 (prompt layer)** — učenia menia prompty; otvorený prompt layer je miesto, kam sa zapisujú.
- **Sedí na OKF (spec 0002)** — originál je zámerne standalone („nevyžaduj štruktúru"); my štruktúru máme, takže umiestnenie učení dostáva prirodzený rebrík (spis → kancelária → komunita). **Presne v tom je celá naša adaptácia** → [spec 0009](../../specs/0009-reconcile-ucenie-z-uprav.md).

---

<sub>Spracoval MČ s AI asistenciou, 2026-08-11. Zdroj: SKILL.md zo zipu (lokálne, necommitované) + coworkacademy.ai (fetch 2026-08-11).</sub>
