# Audit otvorených PR — stav k 11. 9. 2026

- **Pripravil:** Vojta Říha (VŘ) · 11. 9. 2026
- **Ako overené:** GitHub API cez `gh` (stav, slučiteľnosť, CI, komentáre každého PR), assety releasu [`v0.1.14`](https://github.com/Omni-Legal-Products/lawoss/releases/tag/v0.1.14) a obsah vetvy `dev` vo forku — všetko 11. 9. 2026
- **Prečo:** OKF reťaz je zlúčená, ale v oboch repách leží **17 otvorených PR, 8 z nich od augusta**. Tento dokument hovorí, kto má ktorý krok v rukách, aby sa zásoba zrazila bez ďalšieho callu.

## V troch riadkoch

1. Reťaz OKF (`lawoss#24 → #31 → #35`, `coord#63 · #66 · #68 · #69 · #70`) zlúčil MČ 7. 9. Nadväzujúci [lawoss#54](https://github.com/Omni-Legal-Products/lawoss/pull/54) — body 2, 3 a 5 z callov 7. a 11. 9. — je otvorený, CI zelené, čaká na approve.
2. Tri malé PR od MF vo forku čakajú od 21. 8. **len na approve** — a v každom je jedna konkrétna vec na opravu (nižšie).
3. Päť PR v koordinačnom repe má konflikt v `specs/navrhy.md` — tá istá kolízia riadku 49, ktorú MČ ohlásil 21. 8. Rebase vie urobiť len autor.

## Fork `lawoss`

| PR | Autor | Stav | Zistenie | Ďalší krok |
|---|---|---|---|---|
| [#54](https://github.com/Omni-Legal-Products/lawoss/pull/54) podmienky poverenia · brána úniku · kontrakt spisu | VŘ | CI 6/6, čaká na approve | — | **MČ/MF:** review |
| [#41](https://github.com/Omni-Legal-Products/lawoss/pull/41) Telegram: odkazy na inštalátory | MF | slučiteľné, čaká na approve | Názvy assetov sedia s `v0.1.14` (x64 AppImage je naozaj `linux-x86_64`). **Po #44** (prefix `legalwork-` → `lawoss-`) budú odkazy mŕtve; #44 sahá do toho istého workflow. | **VŘ:** approve · **MF:** zlúčiť #41 pred #44 a prefix opraviť v #44 |
| [#44](https://github.com/Omni-Legal-Products/lawoss/pull/44) odstrániť upstream identitu | MF | **konflikt s `dev`** | Nový riadok s odkazmi používa `lawoss-linux-x64-<v>.AppImage`; x64 AppImage sa volá `x86_64` (`x64` je len `.tar.gz`) → Linux odkaz bude 404. | **MF:** rebase + oprava názvu |
| [#13](https://github.com/Omni-Legal-Products/lawoss/pull/13) sidecar bez `shell: true` | MF | draft | Oprava správna. Nový test `prepare-sidecar-path.test.mjs` **nie je** v `test` skripte `apps/desktop/package.json` (súbory sú vymenované explicitne) → v CI nikdy nebeží. | **MF:** zapojiť test, zrušiť draft · **VŘ:** approve |
| [#14](https://github.com/Omni-Legal-Products/lawoss/pull/14) README: jeden MCP endpoint | MF | slučiteľné | Popisuje funkciu ako schválenú; spec [coord#57](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/57) je draft s konfliktom a odklep v zápisoch nie je. Pravidlo toku: najprv spec. | **MF:** podržať do zlúčenia #57 |
| [#15](https://github.com/Omni-Legal-Products/lawoss/pull/15) meno advokáta v DOCX | MF | draft, konflikt | 143 commitov za `dev`. | **MF:** rebase alebo zavrieť |

## Koordinačné repo

| PR | Autor | Stav | Zistenie | Ďalší krok |
|---|---|---|---|---|
| [#54](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/54) ADR 0011 — kto merguje | MČ | slučiteľné od 19. 8. | Sám sa označuje za návrh, kým sa nevyjadrí **IR** (na calle 18. 8. nebol). | **IR:** stanovisko · potom zlúči ne-autor |
| [#56](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/56) ADR 0012 — bump opencode cez bránu | MČ | slučiteľné od 21. 8. | Nemerguje autor. Bez odklepu stojí [lawoss#11](https://github.com/Omni-Legal-Products/lawoss/issues/11). **VŘ odporúča prijať:** rutinný bump cez typecheck · testy · smoke · drift, major ostáva v 🔴 zóne. | **MF/IR:** stanovisko · ne-autor zlúči |
| [#64](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/64) OKF 1.0 + dashboardy · [#67](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/67) spec 0013 | MČ | **konflikt** | `README.md` (bot), `planning/roadmap.md`, `specs/navrhy.md` (riadok MF z 9. 9.). | **MČ:** rebase |
| [#55](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/55) spec 0011 · [#57](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/57) spec 0012 (draft) · [#58](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/58) spec 0013 | MČ / MF / MČ | **konflikt** | Kolízia riadku 49 v `navrhy.md` z 21. 8. | **autori:** rebase v poradí zlúčenia |
| [#76](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/76) logo B a jednotný shell | MČ | slučiteľné | — | **MČ:** merguje sám |
| [#72](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/72) drafty tlačových správ | VŘ | slučiteľné, 8 dní bez reakcie | Dokumenty, nie rozhodnutie. | **VŘ:** zlúči sám (režim z 18. 8.) |
| [#39](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/39) SAK compliance balík · [#10](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/10) paper research skill | IR / MF | drafty, od augusta bez pohybu | — | **autori:** dokončiť alebo zavrieť |

## Čo sa neaudituje

Obsah špecifikácií 0011–0015 — tento dokument rieši len to, **prečo PR stojí**, nie či je vecne správne.
