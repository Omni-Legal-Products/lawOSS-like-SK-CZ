# docs/design — redesign LAWOSS (kick-off 2026-08-23, v2)

> v1 (tmavý SaaS dashboard s kartami) bola 23. 8. zamietnutá MČ; v2 = LegalWork + LAWOSS vrstva pre 4 tentpoles, svet „podací denník na tmavom stole“.

Dizajnové rozhodnutia sa robia tu (koordinačné repo); implementácia ide do forku až po odklepe. Poradie čítania:

| # | Dokument | Čo odpovedá |
|---|---|---|
| ⭐ | [**Design systém (živý)**](design-system.md) | záväzný referenčný dokument pre každý feature — tokeny (hranaté), typografia + wordmark, vzory, OKF dashboard mapovanie, PR checklist |
| 1 | [Audit súčasnej appky](2026-08-23-audit-sucasnej-appky.md) | kde sme: routy, tokeny, hex dlh, UX model, MCP, riziká |
| 2 | [Dizajnový jazyk LAWOSS](2026-08-23-dizajnovy-jazyk-lawoss.md) | svet „podací denník na tmavom stole“: zákazy, farby, IBM Plex, stavebné prvky, pečať |
| 3 | [IA, screen plán, komponenty](2026-08-23-ia-screen-plan-a-komponenty.md) | LegalWork + vrstva: záložky, 5 pohľadov × 4 tentpoles, napojovacie body, API náčrty |
| 3b | [**Dizajn systém je LegalWork**](2026-08-27-dizajn-system-je-legalwork.md) | integrácia namiesto paralelného sveta: mapa prekryvov s existujúcimi plochami appky, pravidlo reuse-first, čo s demom — podklad na call 28. 8. |
| 4 | [Implementačný plán A–D](2026-08-23-implementacny-plan-fazy-A-D.md) | fázy, zóny, `PATCHES.md` rozpočet, čo treba rozhodnúť |
| 5 | [**Hi-fi prototyp v2**](hifi/lawoss-hifi.html) | živé: Prehľad · Spis + OKF Brain · Kontrola lehoty (brána + pečať) · Konektory + Marketplace · Reconcile; svet „podací denník na tmavom stole“, IBM Plex |
| — | [Playbook spolupráce](../playbook-spolupraca.md) | ako na tom pracujeme — ľudia aj AI agenti, obe repá |

## OKF dashboard · osobné UI presety

- [**Spec 0015: osobné dashboardy nad OKF**](../../specs/0015-lawoss-okf-osobne-dashboardy.md)
- [**High-fidelity varianty 1 až 3**](hifi/lawoss-okf-personal-dashboard-presets-1-3.html): Visual Command Center, Minimal Focus, Information Dense
- [**High-fidelity varianty 4 až 6**](hifi/lawoss-okf-personal-dashboard-presets-4-6.html): Process & Evidence, Calendar First, Modular Personal Cockpit
- [Implementačný plán po odklepnutí](../superpowers/plans/2026-09-01-lawoss-okf-osobne-dashboardy.md)
- [Pôvodný exploration set informačných smerov](hifi/okf-dashboard-directions.html) a jeho [rozsah](2026-08-31-okf-dashboard-sest-smerov.md)

Nové presety predstavujú šesť rôznych UI a UX podôb tej istej obrazovky a rovnakých fiktívnych OKF dát. Cieľom je natívna integrácia do existujúcej LAWOSS route `/prehlad`, nie WebView. Osobná konfigurácia môže meniť iba preset, widgety, poradie a veľkosť. Nejde o finálne tímové rozhodnutie ani o produktovú implementáciu.

Po nasadení Pages je prototyp živý na `omni-legal-products.github.io/lawOSS-like-SK-CZ/docs/design/hifi/lawoss-hifi.html`.

Baseline screenshoty aktuálnej appky (mac + Windows) pribudnú do `baseline/` ako prvá úloha Fázy A.
