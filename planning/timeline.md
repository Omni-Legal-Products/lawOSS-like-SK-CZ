# Timeline

> Aktualizované 2026-08-07. Prehľad funkcií podľa verzií: [zberný kôš](napady.md) · [grafický prehľad](https://originalmagneto.github.io/lawOSS-like-SK-CZ/specs/prehlad.html)

## Najbližšie termíny

| Termín | Míľnik | Zodpovedný | Stav |
|---|---|---|---|
| **2026-08-12** | **Sync call — odklepnúť scope V1 (MVP)** → [agenda](../meetings/2026-08-12-agenda-mvp.md) | všetci | 🔵 pripravené |
| 2026-08-12 | Analýza repozitára Determo · CZ a PL integračná stránka | VŘ | ⚪ čaká |
| 2026-08-12 | PM rámec, backlog, konvencie vetiev a PR | IR | ⚪ čaká |
| 2026-08-13 | Praktické otestovanie LegalWorku na vlastných dátach | všetci | ⚪ čaká |
| 2026-08-19 | Návrh modulového rozhrania (plug-and-play) | IR | ⚪ čaká |
| 2026-08-20 | Mapovanie poľských právnych zdrojov | VŘ | ⚪ čaká |

## Blokátory pred štartom V1

Musia padnúť skôr, než sa dá začať — detail v [agende](../meetings/2026-08-12-agenda-mvp.md).

| Čo | Zodpovedný | Stav |
|---|---|---|
| Potvrdenie [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md) od MF | MF | 🔴 čaká |
| Rozhodnúť o GitHub organizácii *(ak áno, pred forkom)* | všetci | 🔴 čaká |
| Vybrať tag LegalWorku na fork *(kandidát `v0.1.13`)* | MČ | 🔴 čaká |
| Určiť, kto rieši merge konflikty pri upstream syncu | všetci | 🔴 čaká |
| Zriadiť Apple Developer účet na notarizáciu | — | 🔴 čaká |
| Doplniť `LICENSE` do repa | MČ | 🔴 čaká |
| Zverejniť `judikaty-mcp` a doplniť mu licenciu | MČ | 🔴 čaká |

## Fázy

| Obdobie | Fáza | Obsah |
|---|---|---|
| **2026-Q3** | Príprava a plánovanie | ✅ voľba základu (LegalWork) · ✅ ADR 0003–0005 · 🔵 scope V1 · ⚪ fork a rebranding |
| **2026-Q4** | V1 — MVP | SK/CZ lokalizácia · OKF · MCP judikatúra a Slov-Lex · lehoty · OCR ingest |
| **2027-Q1** | V2 | tiered memory · transkripcia do spisu · prompt layer · podpisovanie QES/QTS |
| **2027** | Pilot a komunita | testovanie s advokátmi · workshopy · spätná väzba → iterácie |

> [!NOTE]
> **Nultý krok sa dá spraviť bez forku.** MCP servery sa v LegalWorku pridávajú cez UI, takže judikatúrny a Slov-Lex konektor viete dať kolegom ako návod so screenshotmi hneď — a mať prvý reálny výstup, kým sa fork ešte len rozbieha.
