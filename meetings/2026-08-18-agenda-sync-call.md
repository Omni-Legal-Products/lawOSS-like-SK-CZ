# Agenda sync callu — 18. 8. 2026, 17:00

- **Prítomní:** MČ · MF · VŘ — **IR sa ospravedlnil**
- **Cieľ:** uzavrieť Q01–Q25, odklepnúť proces práce a **rozdeliť úlohy na samotnej aplikácii**
- **Podklady:** [plný podklad k otázkam](2026-08-21-agenda-konsolidacia-Q01-Q25.md) *(U1–U19 a B1–B8)* · [prehľadová tabuľka](../planning/2026-08-17-stanoviska-timu-Q01-Q25.md) · [návrh ADR 0011](../decisions/0011-proces-zmien-a-mergovania.md) v [PR #54](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/54)

> [!IMPORTANT]
> **Neúčasť IR blokuje len jednu vec.** Odpovedal písomne na všetkých 25 otázok (14. 8.) a vyjadril sa aj k otvoreným PR, takže jeho pozícia je na stole pri každom bode. **Jediné, čo sa bez neho rozhodnúť nedá, je B2** — kto vlastní upstream sync, lebo je sám kandidátom na tú rolu.

## Priebeh (~60 min)

| # | Bod | Čas | Kto rozhoduje | Stav vstupov |
|---|---|---|---|---|
| 1 | **U1–U19 en bloc** — konsolidované znenia tam, kde je zhoda. Kto má výhradu, vytiahne bod do diskusie | 10 | všetci | ✅ všetci štyria odpovedali |
| 2 | **B1 · Q07 — tretia vertikála:** lehoty vs. onboarding subjektov | 10 | **MČ** ako PO | VŘ + MF za lehoty; **IR písomne súhlasí s vedomou zámenou** → dá sa rozhodnúť dnes |
| 3 | **B3 · doktrína (K1)** a **B4 · autonómia a tvrdé hranice (K2)** | 10 | **MČ** potvrdzuje | IR, VŘ aj MF zhodne na papieri → chýba len MČ |
| 4 | **B6 · sign-off roly** — MF a VŘ deklarujú za seba | 5 | každý osobne | IR svoje roly ponúkol písomne → uzavrieť okrem nových rolí preňho |
| 5 | **B7 · ADR 0011** — kto čo merguje + spätná legitimizácia merge-ov zo 17. 8. + presun `.agents/` a `plugins/` do samostatného repa | 10 | tím | PR #54; odklep MF alebo VŘ stačí *(autor nemerguje vlastný ADR)* |
| 6 | **Rozdelenie úloh na aplikácii** — čo kto berie v prvej vertikále | 10 | všetci | závisí od bodu 2 |
| 7 | Rýchlovky: **B5** zadať licenčnú rešerš + termín · **B8** kto platí podpisové certifikáty · **nápad #45** samoúdržba nástrojovej plochy | 5 | všetci | — |

## Čo sa odkladá na IR

- **B2 — maintainer a reviewer upstream syncu.** Na stole: MČ maintainer + IR reviewer, alebo obrátene. IR navyše ponúkol automat na sync s konfliktným reportom.
- Prípadné **nové** sign-off roly pre IR nad rámec tých, ktoré si sám vzal.

## Poznámka k bodu 5 — bez dramatizovania

17. 8. bolo šesť PR (vrátane nového specu 0006 a prepisu specu 0005) zlúčených autorom bez odklepu. **Obsahovo idú v smere odpovedí tímu** — spec 0005 dokonca sedí s riešením Q07. Procesne ale ukázali, že pravidlá nehovorili, kto smie mergovať. ADR 0011 to dopĺňa a merge-y sa **spätne legitimizujú** týmto callom; ak by call rozhodol inak, revertnú sa bežným PR.

## Výstupy

- [ ] Zápis s hlasovaniami
- [ ] Prijaté U-znenia → ADR 0012+
- [ ] Zlúčiť PR #54 *(merguje MF alebo VŘ, nie MČ)*
- [ ] MČ podá finálne odpovede do PR #26
- [ ] Odklepnutá prvá vertikála → issues vo forku s odkazmi na specy
- [ ] Poslať IR na doplnenie: B2 + výsledky hlasovaní
