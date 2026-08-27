# docs/design — redesign LAWOSS (kick-off 2026-08-23, v2)

> v1 (tmavý SaaS dashboard s kartami) bola 23. 8. zamietnutá MČ; v2 = LegalWork + LAWOSS vrstva pre 4 tentpoles, svet „podací denník na tmavom stole“.

Dizajnové rozhodnutia sa robia tu (koordinačné repo); implementácia ide do forku až po odklepe. Poradie čítania:

| # | Dokument | Čo odpovedá |
|---|---|---|
| 1 | [Audit súčasnej appky](2026-08-23-audit-sucasnej-appky.md) | kde sme: routy, tokeny, hex dlh, UX model, MCP, riziká |
| 2 | [Dizajnový jazyk LAWOSS](2026-08-23-dizajnovy-jazyk-lawoss.md) | svet „podací denník na tmavom stole“: zákazy, farby, IBM Plex, stavebné prvky, pečať |
| 3 | [IA, screen plán, komponenty](2026-08-23-ia-screen-plan-a-komponenty.md) | LegalWork + vrstva: záložky, 5 pohľadov × 4 tentpoles, napojovacie body, API náčrty |
| 3b | [**Dizajn systém je LegalWork**](2026-08-27-dizajn-system-je-legalwork.md) | integrácia namiesto paralelného sveta: mapa prekryvov s existujúcimi plochami appky, pravidlo reuse-first, čo s demom — podklad na call 28. 8. |
| 4 | [Implementačný plán A–D](2026-08-23-implementacny-plan-fazy-A-D.md) | fázy, zóny, `PATCHES.md` rozpočet, čo treba rozhodnúť |
| 5 | [**Hi-fi prototyp v2**](hifi/lawoss-hifi.html) | živé: Prehľad · Spis + OKF Brain · Kontrola lehoty (brána + pečať) · Konektory + Marketplace · Reconcile; svet „podací denník na tmavom stole“, IBM Plex |
| — | [Playbook spolupráce](../playbook-spolupraca.md) | ako na tom pracujeme — ľudia aj AI agenti, obe repá |

Po nasadení Pages je prototyp živý na `omni-legal-products.github.io/lawOSS-like-SK-CZ/docs/design/hifi/lawoss-hifi.html`.

Baseline screenshoty aktuálnej appky (mac + Windows) pribudnú do `baseline/` ako prvá úloha Fázy A.
