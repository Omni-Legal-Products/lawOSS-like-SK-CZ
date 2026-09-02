# Zápis zo sedenia 2. 9. 2026 — sync forku, Experimenty, OKF Fáza A

- **Kto:** MČ (s Claude Code)
- **Repá:** [lawoss](https://github.com/Omni-Legal-Products/lawoss) (fork) · [lawOSS-like-SK-CZ](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ) (koordinácia)
- **Výsledok:** `dev` forku je 42 commitov nad upstreamom a **0 za ním**; chlapci si sťahujú a testujú. Oznámené v Telegrame (General CHAT) aj so screenshotmi.

## Čo sa urobilo (v poradí PR vo forku)

| PR | Čo | Zóna |
|---|---|---|
| [#25](https://github.com/Omni-Legal-Products/lawoss/pull/25) | sync `upstream/dev` — LegalMemory Drive (#89), Personalisation (#91); konflikt v `settings-page.tsx` (oba taby) | 🟡 riadok už v PATCHES.md |
| [#26](https://github.com/Omni-Legal-Products/lawoss/pull/26) · [#28](https://github.com/Omni-Legal-Products/lawoss/pull/28) · [#33](https://github.com/Omni-Legal-Products/lawoss/pull/33) | položka **Experimenty** v sidebare — nakoniec ako rozbaľovacie menu; registry experimentov (`lawoss/experiments`), pravidlo *flag smie iba pridať, nikdy skryť fungujúce* | 🟢 |
| [#27](https://github.com/Omni-Legal-Products/lawoss/pull/27) · [#29](https://github.com/Omni-Legal-Products/lawoss/pull/29) | uvítacia obrazovka v LAWOSS farbách s obsahom MF návrhu onboardingu + rámček „dokončí MF“; wordmark prevzatý stroke-for-stroke z lawoss.app (nie je to font), znak prekreslený monolineárne; preč upstream `PageBackground` (modré škvrny) | 🟢 + 1 🟡 import |
| [#30](https://github.com/Omni-Legal-Products/lawoss/pull/30) | **OKF Fáza A**: `lawoss/okf` CLI (detect · plan · apply · validate · render, 14 testov), skill `/novy-spis`, stránka *Nový spis (OKF)* pod Experimentmi | 🟢 |
| [#32](https://github.com/Omni-Legal-Products/lawoss/pull/32) · [#34](https://github.com/Omni-Legal-Products/lawoss/pull/34) | opravy z testovania: scroll a ťahanie okna v experimentoch, koreňový priečinok s výberom, updater presmerovaný na feed forku + skip pri `0.0.0` | 🟡 `updater.mjs`, `updater.test.mjs` |

Koordinačné repo: **spec 0013** ([PR #67](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/67)) — čo je `okf` CLI, prenositeľnosť, Fáza A pred B, profily vecí; grafické návrhy v `assets/design/okf-cli/`.

## Rozhodnutia MČ

1. **Fáza A pred B** — najprv skill + CLI bez zásahu do servera; server adaptér ostáva cieľ.
2. **Zvyšok appky ostáva vanilla LegalWork**, mení sa iba dizajn; všetko rozpracované ide pod Experimenty.
3. **Prenositeľnosť medzi harness-mi je tvrdá podmienka** — čítanie priečinka nesmie vyžadovať CLI; test: ručne vyrobený priečinok musí prejsť `okf validate`.
4. **Typy vecí ako profily**, nie nové systémy (`matter.type` + `matter.mode`) — ešte neschválené tímom, otvorené v spec 0013.
5. Upstream sync sa robí z `upstream/dev` na dátumovej vetve (prax PR #16 a #25), nie z release tagu — AGENTS.md forku hovorí inak; treba zosúladiť.

## Zistenia, ktoré stoja za zapamätanie

- Skill `novy-spis` MČ (v0.4.0) už má **Profil C — korporátny klient**; profily vecí sú jeho zovšeobecnenie. Jeho `scripts/` sú de facto CLI v0 (bash, 1 097 riadkov, testy).
- Existujú **dve generácie OKF**: v0.1 = formát (Google OKF, Markdown + `type:`), 1.0 = kancelársky kontrakt z konsolidácie 1. 9. CLI stojí na v0.1, vnútro sa vymení, keď 1.0 sadne.
- Konsolidácia OKF 1.0 z 1. 9. **nespomína** korporát, IP, RPVS ani insolvencie.
- Updater forku pozeral na upstream feed a lokálny build má `0.0.0` → „Update available“ navždy, a odkliknutie by fork prepísalo LegalWorkom.
- Chromium počíta ťahaciu oblasť okna ako *drag mínus no-drag obdĺžniky* bez ohľadu na z-index — `no-drag` nikdy na celé panely.
- `gh pr create` v repe, ktoré je GitHub fork, mieri na parent repo — PR zakladať cez `gh api repos/…/pulls`.

## Ďalšie kroky

1. OKF nastavenia do natívneho Settings (tab v `getGlobalSettingsTabs`; riadok v PATCHES.md už je) — *MČ*
2. Napojenie dialógu *Nový spis* na upstream „Add folder“ (jeden 🟡 riadok) — *MČ*
3. Test naživo na testovacom workspace: krok 1 (skill + CLI) a krok 2 (session s požiadavkou) — *chlapci*
4. OKF architektúra s VŘ — samostatné vlákno „OKF architektúra – call podklady“
5. Otvorené z PATCHES.md: bez záznamu sú `apps/app/src/i18n/index.ts`, `apps/app/src/react-app/shell/app-root.tsx`, `scripts/i18n-audit.mjs`; pri `app-sidebar.tsx` je zapísaný len brand-mark import, nie `<LawossNav />`
