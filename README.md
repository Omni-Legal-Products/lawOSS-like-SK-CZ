<div align="center">

# ⚖️ MikeOSS Slovakia

**Open-source právny asistent pre slovenských advokátov**
*Fork projektu [MikeOSS](https://github.com/Open-Legal-Products/mike), špecializovaný pre slovenské právo a jurisdikciu SR*

[![Status](https://img.shields.io/badge/f%C3%A1za-pr%C3%ADprava%20%26%20pl%C3%A1novanie-blue)](planning/roadmap.md)
[![Upstream](https://img.shields.io/badge/upstream-Open--Legal--Products%2Fmike-black?logo=github)](https://github.com/Open-Legal-Products/mike)
[![License](https://img.shields.io/badge/licencia-open--source-green)](LICENSE)
[![Jurisdiction](https://img.shields.io/badge/jurisdikcia-%F0%9F%87%B8%F0%9F%87%B0%20Slovensko-red)](docs/vision.md)

</div>

> [!NOTE]
> Toto repo **zatiaľ neobsahuje kód forku**. Slúži na brainstorming, rešerše, plánovanie a spoločnú evidenciu podkladov (vrátane `AGENTS.md` / `CLAUDE.md`) pred založením samotného fork repozitára.

---

## 🎯 Vízia

Priniesť slovenským advokátom **užitočný open-source nástroj úplne zadarmo** — postavený na MikeOSS, obohatený o slovenské pluginy a MCP servery (Slov-Lex, ORSR, RPVS, judikatúra…), prispôsobený slovenskému právu, s možnosťou neskoršieho rozšírenia o ďalšie krajiny.

| | |
|---|---|
| 👥 **Tím** | Marián Čuprík · Martin Friedrich · Igor Ribár (advokáti SAK, pracovná skupina pre elektronizáciu advokácie) |
| 💰 **Model** | Nástroj zadarmo, open-source. Monetizácia výhradne cez workshopy a školenia. |
| 🔄 **Stratégia forku** | Slovenské úpravy ako pluginy/overlay vrstva → priebežné pull-ovanie upstream aktualizácií bez konfliktov |
| 💬 **Komunikácia** | Telegram skupina + GitHub Issues/Discussions |

## 🏗️ Architektúra forku (návrh)

```mermaid
flowchart TB
    subgraph upstream["🌍 Upstream"]
        MIKE["MikeOSS<br/>Open-Legal-Products/mike"]
    end

    subgraph fork["🇸🇰 MikeOSS Slovakia"]
        CORE["Jadro MikeOSS<br/><i>nedotknuté – čisté pull-ovanie</i>"]
        OVERLAY["SK overlay / konfigurácia"]
        PLUGINS["SK pluginy"]
    end

    subgraph mcp["🔌 Slovenské MCP servery"]
        SLOVLEX["Slov-Lex<br/>zákony a predpisy"]
        ORSR["ORSR / RPO<br/>obchodný register"]
        RPVS["RPVS<br/>koneční užívatelia výhod"]
        JUD["Judikatúra<br/>rozhodnutia súdov"]
        OV["Obchodný vestník,<br/>FS, ÚVO…"]
    end

    MIKE -- "git pull (priebežne)" --> CORE
    CORE --> OVERLAY --> PLUGINS
    PLUGINS --> SLOVLEX & ORSR & RPVS & JUD & OV

    ADVOKAT(["👩‍⚖️ Advokát"]) --> fork
```

## 🎨 Vizuálny koncept

Ranný náčrt značky a produktu — logo (monogram „M" s váhami spravodlivosti), tmavo-zlatá paleta, typografia **Inter + Playfair Display** a koncept dashboardu (Spisy · Klienti · Dokumenty · Fakturácia · AI Asistent). Päť pilierov: **dôvera a bezpečnosť · efektivita · prehľadnosť · spolupráca · modernosť**.

> Celý moodboard a rozpis: **[docs/brand-concept.md](docs/brand-concept.md)** · *(ide o koncept, nie schválený finálny dizajn)*

## 🔬 Rešerše

Prvý **deep-research** balík (NotebookLM, 245 zdrojov, 6 kôl) o open-source AI pre slovenskú advokáciu — MCP servery, anonymizácia (MasKIT/Stella), integrácia vlastného a lokálneho API (BYOK), a compliance (SAK 2025, EU AI Act).

- 📊 **Grafický report (rich markdown):** [research/deep-research/](research/deep-research/)
- 🌐 **Živý HTML report:** [originalmagneto.github.io/mikeOSS-SLOVAKIA/research/deep-research/report.html](https://originalmagneto.github.io/mikeOSS-SLOVAKIA/research/deep-research/report.html)
- 🎧 **Audio podcast (SK):** [Releases](https://github.com/originalmagneto/mikeOSS-SLOVAKIA/releases/tag/research-2026-07-10)

## 🗺️ Roadmapa

```mermaid
timeline
    title Fázy projektu
    section Fáza 0 · Príprava
        Q3 2026 : Toto repo – brainstorming, rešerše : Analýza upstreamu MikeOSS : ADR – stratégia forku a licencia
    section Fáza 1 · Fork & MVP
        Q4 2026 : Založenie fork repozitára : Prvé SK MCP servery : SK lokalizácia
    section Fáza 2 · Pilot
        2027 : Testovanie s advokátmi : Workshopy a školenia : Spätná väzba → iterácie
```

Detailný harmonogram: [planning/timeline.md](planning/timeline.md) · Backlog: [planning/backlog.md](planning/backlog.md)

## 📊 Progress

<!-- AUTO:PROGRESS -->
| Súbor | Progress | Hotovo |
|---|---|---|
| [`backlog.md`](planning/backlog.md) | `░░░░░░░░░░░░░░░░░░░░` | 0/5 (0 %) |
| [`roadmap.md`](planning/roadmap.md) | `██░░░░░░░░░░░░░░░░░░` | 2/17 (12 %) |
| [`workshopy.md`](planning/workshopy.md) | `░░░░░░░░░░░░░░░░░░░░` | 0/3 (0 %) |
<!-- /AUTO:PROGRESS -->

## 🗂️ Štruktúra repozitára

<!-- AUTO:TREE -->
```text
mikeOSS-SLOVAKIA/
├── assets/
│   └── brand/
│       └── README.md
├── decisions/
│   ├── 0002-preco-forkujeme-mikeoss.html
│   ├── 0002-preco-forkujeme-mikeoss.md
│   └── template.md
├── docs/
│   ├── brand-concept.md
│   ├── glossary.md
│   ├── principles.md
│   ├── telegram-notifikacie.md
│   └── vision.md
├── meetings/
├── planning/
│   ├── backlog.md
│   ├── roadmap.md
│   ├── timeline.md
│   └── workshopy.md
├── research/
│   ├── deep-research/
│   │   ├── audio/
│   │   │   └── 2026-07-10-mikeoss-research-podcast-sk.m4a
│   │   ├── 2026-07-10-open-source-legaltech-EU-mcp-anonymizacia.md
│   │   ├── 2026-07-10-zdroje.md
│   │   ├── README.md
│   │   └── report.html
│   ├── idey/
│   │   ├── 2026-07-29-build-open-vs-buy-closed.md
│   │   ├── 2026-07-29-orchestrator-transkripcia-byo-subscriptions.md
│   │   └── README.md
│   ├── inspiracie/
│   │   ├── porovnanie.html
│   │   └── README.md
│   ├── mcp-servery/
│   ├── mikeoss/
│   ├── pravny-ramec/
│   └── sk-datove-zdroje/
├── specs/
│   └── template.md
├── AGENTS.md
├── CLAUDE.md
└── README.md
```
<!-- /AUTO:TREE -->

<details>
<summary><b>Na čo slúžia jednotlivé priečinky</b></summary>

| Priečinok | Účel |
|---|---|
| `docs/` | Vízia, princípy, glosár |
| `decisions/` | ADR — zaznamenané rozhodnutia (čo, prečo, aké alternatívy) |
| `research/` | Rešerše: upstream MikeOSS, inšpirácie, SK dátové zdroje, MCP servery, právny rámec |
| `planning/` | Roadmapa, timeline, backlog, plán workshopov |
| `specs/` | Konkrétne návrhy funkcií (dozreté nápady z backlogu) |
| `meetings/` | Zápisky zo stretnutí (`RRRR-MM-DD.md`) |
| `assets/` | Diagramy, obrázky, PDF podklady |
| `AGENTS.md` | Kontext pre agentické systémy — **single source of truth** |
| `CLAUDE.md` | Mirror `AGENTS.md` — needitovať priamo |

</details>

## 🔄 Ako pracujeme s rozhodnutiami

```mermaid
flowchart LR
    A["💡 Nápad<br/>(Telegram / Issue)"] --> B{"Diskusia<br/>traja partneri"}
    B -->|zhoda| C["📄 ADR v decisions/"]
    B -->|treba preveriť| D["🔍 Rešerš v research/"]
    D --> B
    C --> E["📋 Backlog / Spec"]
    E --> F["🚀 Implementácia<br/>(vo fork repe)"]
```

## 📈 Aktivita

<!-- AUTO:ACTIVITY -->
**35 commitov** · **33 súborov**

| Commit | Dátum | Autor | Správa |
|---|---|---|---|
| `201b1bb` | 2026-07-10 | github-actions[bot] | docs: auto-update README [skip ci] |
| `d7c9729` | 2026-07-10 | Marián Čuprík | docs(ADR): 0002 — prečo forkujeme mikeOSS (rich markdown + HTML) |
| `e6560fa` | 2026-07-10 | github-actions[bot] | docs: auto-update README [skip ci] |
| `4bc3c74` | 2026-07-10 | Marián Čuprík | docs: regenerácia README po merge |
| `699ea51` | 2026-07-10 | Majo Cuprik | Merge branch 'main' of https://github.com/originalmagneto/mikeOSS-SLOVAKIA |
| `ecd57c3` | 2026-07-10 | Marián Čuprík | docs: odkaz na deep-research (report, živý HTML, audio) v hlavnom README |
| `3b431a3` | 2026-07-10 | github-actions[bot] | docs: auto-update README [skip ci] |
| `f8a11e0` | 2026-07-10 | Marián Čuprík | chore: .nojekyll — GitHub Pages servuje HTML report priamo |
<!-- /AUTO:ACTIVITY -->

---

<div align="center">
<sub>Sekcie označené 🤖 sa aktualizujú automaticky GitHub Action pri každom pushi — needitujte ich ručne.<br/>
<b>Posledná automatická aktualizácia:</b> <!-- AUTO:UPDATED -->2026-07-29 16:50 UTC<!-- /AUTO:UPDATED --></sub>
</div>
