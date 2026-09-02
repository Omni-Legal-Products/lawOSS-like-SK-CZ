# OKF implementácie — zjednotenie (feature #1)

- **Cieľ:** z dvoch reálne používaných implementácií pamäťového/spisového systému (MČ + VŘ) spraviť **jednu zjednotenú OKF špecifikáciu + skills**, ktoré budú základom appky (dashboard spisu renderovaný z markdownov) aj prenositeľného systému mimo nej.
- **Rozhodnuté na calle 28. 8.** ([zápis](../../meetings/2026-08-28-zapis-sync-call.md), body 5 + akčné body) · nadväzuje na [spec 0002 OKF](../../specs/0002-okf-operacny-system-praxe.md) a [design-system §5](../../docs/design/design-system.md).

## Čo tu je / má byť

| Priečinok | Čo | Stav |
|---|---|---|
| [`mc-novy-spis/`](mc-novy-spis/) | implementácia MČ — skill `novy-spis` (OKF v0.1): profily A/B/C, riadiace súbory, ORSR/RPO audit, retrofit, validácia (`okf-validate.sh`, `okf-freshness.sh`), PROTOKOL ZÁPISU | ✅ nahraté 29. 8. |
| [`vr-pamat/`](vr-pamat/) | implementácia VŘ — typované záznamy, index, oddelená vrstva poučení; prevádzkové čísla a doložené medzery | ✅ nahraté 29. 8. |
| [`zjednotenie.md`](zjednotenie.md) | výstup: porovnanie po vrstvách + zjednotený kontrakt + 5 otvorených bodov na call 1. 9. | 📝 návrh 29. 8. — [PR #24 vo forku](https://github.com/Omni-Legal-Products/lawoss/pull/24) |

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
4. Výstup `zjednotenie.md` → aktualizácia spec 0002 → skills `novy-spis` v2 (SK + CZ) → parser `lawoss/okf/read.ts` vo forku.

## Pre AI agentov, ktorí tu budú pracovať

Prečítaj najprv koreňový `AGENTS.md` repa. Tu navyše platí: **nemeníš cudziu implementáciu** (mc-*/vr-* sú referenčné snapshoty — pripomienky písať do `zjednotenie.md`, nie prepisovať zdroj); porovnanie píš po slovensky, tabuľkovo, s presnými odkazmi na súbory; nič „z hlavy“ — každé tvrdenie o implementácii musí mať cestu k súboru. Testovať skripty môžeš v `/tmp`, nikdy nad reálnymi spismi.
