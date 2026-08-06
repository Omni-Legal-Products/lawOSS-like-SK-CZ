<div align="center">

# 💡 Návrhy funkcií — evidencia

Kto čo navrhol, v akom je to stave a kde to žije

</div>

> [!TIP]
> **Chceš podať návrh?** Najjednoduchšie cez GitHub — [**Nový návrh funkcie →**](https://github.com/originalmagneto/lawOSS-like-SK-CZ/issues/new?template=feature-navrh.yml)
> Netreba nič programovať, je to formulár. Dá sa aj z mobilu. Po prerokovaní ho prepíšeme do `specs/`.

## Kto je kto

| Skratka | Meno |
|---|---|
| **MČ** | Marián Čuprík |
| **MF** | Martin Friedrich |
| **IR** | Igor Ribár |
| **VŘ** | Vojta Říha 🇨🇿 *(pridal sa 2026-08-06)* |

## Evidencia návrhov

| # | Návrh | Navrhol | Dátum | Stav | Kde |
|---|---|---|---|---|---|
| 1 | Transkripcia (hovory, porady, diktát → do spisu) | **MČ** | 2026-07-29 | 📝 návrh | [spec 0001](0001-transkripcia.md) |
| 2 | OKF — operačný systém advokátskej praxe | **MČ** | 2026-07-29 | 📝 návrh · ⭐ vysoká priorita | [spec 0002](0002-okf-operacny-system-praxe.md) |
| 3 | Otvorený prompt layer (žiadny black box) | **MČ** | 2026-07-29 | 📝 návrh | [spec 0003](0003-prompt-layer.md) |
| 4 | SK MCP konektory (judikatúra, Slov-Lex, registre) | **MČ** | 2026-07-29 | 📝 návrh | [spec 0004](0004-mcp-sk-konektory.md) |
| 6 | **Attorney workflow MVP** — lehoty, conflict check, research ledger, dokumentový workflow, control plane | **MF** | 2026-07-30 | 📝 rozpracované (lehoty → spec 0005; ledger/control plane sa zlúčia do 0003/0004) | [Issue #1](https://github.com/originalmagneto/lawOSS-like-SK-CZ/issues/1) |
| 7 | **Lehoty & timeline spisu** — extrakcia lehôt s povinným potvrdením + vizuálna chronológia veci (mermaid/excalidraw) | **MF** *(+MČ timeline)* | 2026-07-30 | 📝 návrh · ⭐ kandidát na alfu #1 | [spec 0005](0005-lehoty-timeline.md) |
| 8 | **OCR ingest → markdown** — Mistral OCR quick win (existujúca Quick Action MČ), markdown-first namiesto DOCX-centrizmu | **MČ** | 2026-07-30 | 📝 návrh · quick win do alfy | [backlog](../planning/backlog.md) |
| 5 | **Hybrid routing** — lokálny model pre OKF, subscription pre rešerš, anonymizácia pred assessmentom | **MČ** | 2026-07-29 | 📝 na prerokovanie | [spec 0003 §hybrid](0003-prompt-layer.md#-hybrid-routing--rozdelenie-podľa-vrstvy) |
| 9 | **Orchestrátor a subagenti** — kto riadi workflow, oprávnenia agentov, human gates, auditná stopa | **MF** | 2026-08-04 | 📝 návrh · PR otvorený | [PR #2](https://github.com/originalmagneto/lawOSS-like-SK-CZ/pull/2) |
| 10 | **Digitálna sekretárka** — založenie spisu → priečinky → workflow písaných aj diktovaných zápiskov → markdown do spisu | **MČ** | 2026-08-06 | 💭 nápad · spája 0001 + 0002 | [call 6. 8.](../meetings/2026-08-06-sync-call-volba-zakladu.md) |
| 11 | **UI/CLI prepínač** — UI ako default, CLI ako voliteľný režim | **MČ** *(podnet VŘ)* | 2026-08-06 | ✅ schválené na calle | [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md) |
| 12 | **Markdown/Obsidian interoperabilita** — markdown ako primárny formát, žiadny vendor lock-in | **MČ** *(s VŘ)* | 2026-08-06 | ✅ schválené na calle | [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md) |
| 13 | **MCP Salvia** — CZ judikatúra ako voliteľný modul (~10 € / 3 000 dotazov, lepšia indexácia než Codexis) | **VŘ** | 2026-08-06 | 💭 nápad · overiť licenčné podmienky | [call 6. 8.](../meetings/2026-08-06-sync-call-volba-zakladu.md) |
| 14 | **Špecializovaní agenti podľa právneho odvetvia** — všeobecný agent spotrebuje priveľa dotazov | **VŘ** | 2026-08-06 | 💭 nápad | [call 6. 8.](../meetings/2026-08-06-sync-call-volba-zakladu.md) |
| 15 | **Poľské rozšírenie (PL)** — voľne prístupné poľské právne dáta a judikatúra, evaluácia cez kontakty v PL | **VŘ** | 2026-08-06 | ✅ schválené na calle | [call 6. 8.](../meetings/2026-08-06-sync-call-volba-zakladu.md) |
| 16 | **Modulové rozhranie plug-and-play** — moduly ako LEGO nad jednotným základom, bezpečnostné hranice | **MČ** *(spracúva IR)* | 2026-08-06 | 📝 návrh · IR do 2026-08-19 | [call 6. 8.](../meetings/2026-08-06-sync-call-volba-zakladu.md) |
| 17 | **Rešeršný workflow „one-click"** — dotaz → rešerš → projektové artefakty, cez NotebookLM CLI | **MČ** | 2026-08-06 | 💭 nápad | [call 6. 8.](../meetings/2026-08-06-sync-call-volba-zakladu.md) |
| 18 | **Google Workspace integrácia** — e-maily a marketingový outreach cez harness | **MČ** | 2026-08-06 | 💭 nápad · nízka priorita | [call 6. 8.](../meetings/2026-08-06-sync-call-volba-zakladu.md) |
| 19 | **Natívna autorizácia PDF a XML podľa eIDAS** — QES + QTS, advokátske preukazy, české elektronické podpisy, dôveryhodná služba vytvárania podpisov, časová pečiatka | **MČ** | 2026-08-06 | ⚠️ **propagované vo vizuáloch, ale bez specu** — treba rozpísať | [keyvisualy](../assets/brand/) |
| 20 | **Fakturácia a výkazy času** — v rozhraní na vizuáloch (Fakturácia, Výkazy času, Šablóny) | **MČ** | 2026-08-06 | 💭 nápad · bez specu | [keyvisualy](../assets/brand/) |

### Legenda stavov

| Stav | Význam |
|---|---|
| 💭 nápad | surový, ešte nediskutovaný (patrí do [Issues](https://github.com/originalmagneto/lawOSS-like-SK-CZ/issues)) |
| 📝 návrh | rozpísaný v `specs/`, čaká na prerokovanie |
| ✅ schválené | zhoda všetkých troch → ide do v1 |
| ⏸️ odložené | dobrý nápad, ale nie teraz |
| ❌ zamietnuté | s dôvodom (dôvod zapísať do specu) |

## Ako to funguje

```mermaid
flowchart LR
    N["💭 Nápad<br/>(Telegram / Issue)"] --> I["📋 GitHub Issue<br/>formulár"]
    I --> D{"Prerokovanie<br/>MČ · MF · IR · VŘ"}
    D -->|zhoda| S["📝 Spec v specs/<br/>+ zápis sem"]
    D -->|treba preveriť| R["🔍 Rešerš"]
    R --> D
    S --> A["✅ Schválené → v1"]
```

1. **Nápad** hoď do Telegramu alebo rovno ako [GitHub Issue](https://github.com/originalmagneto/lawOSS-like-SK-CZ/issues/new?template=feature-navrh.yml).
2. **Prerokujeme** spoločne (Telegram / stretko / týždenný stredajší sync call).
3. Ak je zhoda → **rozpíše sa ako spec** v `specs/` a pridá riadok do tabuľky vyššie.
4. Autorstvo sa **vždy uvádza** — v specu aj tu. Aj pri zamietnutých návrhoch (aby sa nevracali dokola).

> [!NOTE]
> Prvý návrh mimo MČ prišiel **30. 7. 2026 od MF** cez formulár ([Issue #1](https://github.com/originalmagneto/lawOSS-like-SK-CZ/issues/1)) — presne takto to má fungovať. Igor, pridávaj rovnako, alebo napíš do Telegramu a zapíšeme to.
