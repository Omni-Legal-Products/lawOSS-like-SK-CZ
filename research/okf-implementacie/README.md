# OKF implementácie - zjednotenie (feature #1)

- **Cieľ:** z dvoch reálne používaných implementácií pamäťového/spisového systému (MČ + VŘ) spraviť **jeden zjednotený OKF kontrakt a portable Core**, ktoré budú základom LAWOSS aj práce mimo appky. Dashboard je následná vizualizačná vrstva, nie prvý implementačný krok.
- **Rozhodnuté na calle 28. 8.:** zjednotenie OKF je prvá feature ([zápis](../../meetings/2026-08-28-zapis-sync-call.md), body 5 + akčné body). Kanonický kontrakt a technická architektúra ešte rozhodnuté nie sú.
- **Najbližší krok:** [call MČ + VŘ + MF 1. 9. 2026 o 10:30](../../meetings/2026-08-31-agenda-okf-architektura.md), ktorého cieľom je architektonický mandát pred detailným technickým specom.

## Čo tu je / má byť

| Priečinok | Čo | Stav |
|---|---|---|
| [`mc-novy-spis/`](mc-novy-spis/) | implementácia MČ — skill `novy-spis` (OKF v0.1): profily A/B/C, riadiace súbory, ORSR/RPO audit, retrofit, validácia (`okf-validate.sh`, `okf-freshness.sh`), PROTOKOL ZÁPISU | ✅ nahraté 29. 8. |
| [`vr-pamat/`](vr-pamat/) | implementácia VŘ — typované záznamy, index, oddelená vrstva poučení; prevádzkové čísla a doložené medzery | ✅ nahraté 29. 8. |
| [`zjednotenie.md`](zjednotenie.md) | výstup: porovnanie po vrstvách + zjednotený kontrakt + 5 otvorených bodov na call 1. 9. | 📝 návrh 29. 8. — [PR #24 vo forku](https://github.com/Omni-Legal-Products/lawoss/pull/24) |
| [`stanovisko-mc.md`](stanovisko-mc.md) | odpovede MČ k O1 až O7, vrátane podmienok pre status projekciu a anglického machine contractu | 📝 podklad MČ 29. 8. |
| [`review-pr24.md`](review-pr24.md) | technická revízia prototypu vo forku, nálezy a odporúčané poradie opráv | 📝 review MČ 29. 8. |
| [`porovnanie-a-konsolidacia-2026-08-31.md`](porovnanie-a-konsolidacia-2026-08-31.md) | detailné oddelenie návrhu VŘ, návrhu MČ a nového konsolidovaného kontraktu, vrátane simulácie | 📝 návrh MČ na spoločnú revíziu |
| [`../../assets/diagrams/okf-konsolidacia.html`](../../assets/diagrams/okf-konsolidacia.html) | samostatná interaktívna vizualizácia: čo, prečo, ako, architektúra, ACME simulácia a rozhodnutia | 📝 pripravené na pripomienky |
| [`../../specs/0014-okf-1-kanonicky-kontrakt.md`](../../specs/0014-okf-1-kanonicky-kontrakt.md) | navrhovaný kanonický kontrakt OKF 1.0 a acceptance criteria | 📝 nie je odklepnuté VŘ ani tímom |
| [`../../planning/2026-08-31-okf-lawoss-technicky-navrh-zadanie.md`](../../planning/2026-08-31-okf-lawoss-technicky-navrh-zadanie.md) | zadanie technickej integrácie OKF do LAWOSS, overený stav forku, UI/UX scope a otvorené rozhodnutia | 📝 architektonický discovery, bez oprávnenia implementovať |
| [`../../meetings/2026-08-31-agenda-okf-architektura.md`](../../meetings/2026-08-31-agenda-okf-architektura.md) | 45-minútový prezentačný scenár, rozhodnutia D1 až D9, otázky O1 až O7 a live decision sheet | 🕥 podklad na call 1. 9. 2026 o 10:30 |

## Ako budeme zjednocovať (návrh postupu)

1. **VŘ nahrá svoju implementáciu** do `vr-pamat/` (bez klientskych dát — repo je verejné).
2. **Porovnanie po vrstvách** — pre každú odpovedať „MČ verzia / VŘ verzia / zjednotené“:
   - štruktúra priečinkov (profily: klient→spis, projekt, firma; číslovanie, nomenklatúra),
   - riadiace súbory a ich **schémy** (frontmatter polia, sekcie): karta veci · stav · pamäť · kontext pre agentov,
   - protokol zápisu (ktorý fakt patrí do ktorého súboru; kto smie zapisovať — human vs. skill),
   - workflow: založenie novej veci · **retrofit existujúceho priečinka** (nedeštruktívne, idempotentné) · validácia a drift check,
   - vrstvy pamäte L1/L2/L3 a provenance (spec 0002),
   - dvojjurisdikčnosť: čo je spoločné, čo SK/CZ špecifické (názvoslovie neprekladať ticho).
3. **Kritériá zjednotenia:** prenositeľnosť (funguje v opencode/Claude Code/Codex bez appky) · parsovateľnosť pre UI (deterministický frontmatter/JSON tam, kde z toho appka renderuje — design-system §5) · idempotentné skripty · žiadny zápis bez human gate pri citlivých poliach (ADR 0007).
4. Call MČ + VŘ potvrdí alebo presne upraví kanonický kontrakt a portable Core.
5. Až potom vznikne detailný technický spec platformy: Core, server adaptér, write pipeline, onboarding, agentové tools, registry providers, testy a rollout.
6. Dashboard a custom views sa navrhnú nad stabilným serverovým snapshotom, nie priamym parsovaním Markdownu vo fronte.

## Pre AI agentov, ktorí tu budú pracovať

Prečítaj najprv koreňový `AGENTS.md` repa. Tu navyše platí: **nemeníš cudziu implementáciu** (mc-*/vr-* sú referenčné snapshoty — pripomienky písať do `zjednotenie.md`, nie prepisovať zdroj); porovnanie píš po slovensky, tabuľkovo, s presnými odkazmi na súbory; nič „z hlavy“ — každé tvrdenie o implementácii musí mať cestu k súboru. Testovať skripty môžeš v `/tmp`, nikdy nad reálnymi spismi.
