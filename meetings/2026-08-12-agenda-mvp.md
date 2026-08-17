<div align="center">

# 🎯 Agenda: rozhodnutie o MVP (verzia 1)

**Streda 12. 8. 2026 · sync call**

![Cieľ](https://img.shields.io/badge/cie%C4%BE-odklepn%C3%BA%C5%A5%20scope%20V1-orange)
![Podklad](https://img.shields.io/badge/podklad-26%20n%C3%A1padov-blue)

</div>

> [!IMPORTANT]
> **Cieľ stretnutia je jediný: odsúhlasiť konkrétny zoznam funkcií pre V1 a vydať ju čo najskôr.**
> Všetko ostatné (26 nápadov) je v [zbernom koši](../planning/napady.md) a nikam neutečie.

---

## 🔄 Aktualizácia 12. 8. ráno — čo sa zmenilo od prípravy agendy

> [!NOTE]
> Agenda nižšie vznikla **7. 8.** Odvtedy pribudli tri podklady a jeden blokátor padol. Tento blok agendu **nemení, len dopĺňa** — pôvodné body ostávajú v platnosti.

### Čo pribudlo do repa

| Kedy | Čo | Stav |
|---|---|---|
| 11. 8. | **PR #17 (MF)** — spec 0008 anonymizačný gate + [ADR 0006](../decisions/0006-anonymizacia-ako-lokalny-privacy-gate.md) | **zlúčené do `main`**; ADR je v stave *návrh* → čaká na odklep tímom |
| 10. 8. | **PR #13** — [vykonávací plán forku a workflow](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/13) | otvorený, `mergeable` |
| 10. 8. | **PR #14** — [strategické zamyslenie](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/14) | otvorený, `mergeable` |
| 11. 8. | **PR #16** — [spec 0009 reconcile](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/16) (kandidát na V2) | otvorený, `mergeable` |

### Fakty o upstreame — preverené znova 12. 8. ráno *(GitHub API)*

- Najnovší release je **stále `v0.1.13`** (4. 8.) → kandidát na tag forku platí bez zmeny.
- Posledný push do upstreamu **8. 8.**, default branch `dev`, licencia MIT.
- **90 ⭐ · 17 forkov · 2 prispievatelia** — čísla zo strategického zamyslenia sedia.
- Meno **`lawoss`** na GitHube vracia **404** → stále voľné (definitívne sa potvrdí pri zakladaní organizácie).

### Body na odklep **navyše** k bodu 6️⃣

Vyplývajú z PR #13 a #14, agenda ich ešte neobsahuje:

1. ☐ **[ADR 0006](../decisions/0006-anonymizacia-ako-lokalny-privacy-gate.md) — anonymizačný gate:** schvaľujeme? A patrí do **V1, alebo V2**? *(scope V1 v bode 3️⃣ ho zatiaľ neobsahuje)*
2. ☐ **Brána M2 — verejná distribúcia binárok:** security owner · podpisový kľúč s rotáciou · incident proces · disclaimer set · ADR
3. ☐ **Brána lehôt:** doménové testy SK aj CZ · povinné potvrdenie advokátom · disclaimer · review MF
4. ☐ **Exit plán z upstreamu** do `AGENTS.md` forku *(≥3 mesiace bez releasu · odchod maintainera · pivot na closed-core · konflikt >1 týždňa práce)*
5. ☐ **Rola IR** — tri navrhované roly a červená čiara podľa [ADR 0002](../decisions/0002-preco-forkujeme-mikeoss.md); **potvrdzuje IR osobne**
6. ☐ **Pravidlá forku** z PR #13 — PR povinný, `PATCHES.md`, tri zóny, verzovanie `v*-lawoss.n`, dvojjurisdikčná štruktúra `sk/`/`cz/`

### 🧭 Smerový bod na diskusiu — **rozhodnutie NIE dnes**

- **[ADR 0007 — agent-first architektúra](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/19)** *(návrh MČ, 12. 8.)* — tvrdí, že primárny používateľ softvéru je **agent, nie človek**, a ľudské rozhranie je riadiaci panel. Rámec: *agent je koncipient — pracuje samostatne, ale nepodpisuje.* **Scope V1 sa tým nemení**, princíp hovorí *ako* stavať, nie *čo* je v V1. Cieľom dnes je len **počuť názory**, hlavne od **MF** — ADR stojí na jeho stavovom automate z ADR 0006 a bez jeho stanoviska sa neprijíma.

### 🔧 Faktická oprava na vedomie

- **[PR #18](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/18) — ADR 0004 uvádzalo nesprávnu technológiu.** LegalWork je **Electron**, nie Tauri; rebranding sedí na **troch** miestach, nie na dvoch, a zmena `appId` mení macOS bundle identitu (keychain, Launchpad, TCC). **Rozhodnutie forkovať sa nemení**, mení sa odhad ceny rebrandingu. Na nezrovnalosť upozornil MF v spec 0008.
- **Dobrá správa z toho istého overenia:** upstream medzitým pridal locale `fr`, `ja`, `pt-BR` (11 jazykov) → **preklady aktívne priberá**, čo zvyšuje šancu na prijatie nášho SK/CZ PR. `sk` ani `cs` tam stále nie sú.
- **Onboarding zo zdrojáku je náročnejší, než README priznáva** *(overené 12. 8. na reálnom klone)*: Node 24 + pnpm 11.4 + **Bun** *(README ho vôbec nespomína)* + Xcode CLT/Swift, a sideload Word add-inu žiada **heslo do keychainu** kvôli CA certifikátu. Word add-in teda **nie je „zadarmo"**, ako uvádza bod 1️⃣ — pre netechnického advokáta je to netriviálny krok.

### Blokátory z bodu 5️⃣ — stav k 12. 8. ráno

| Blokátor | Stav |
|---|---|
| Potvrdenie ADR 0003 od MF | ✅ **potvrdené** (MF, Telegram 11. 8.) — ale **PR #12**, ktorý to zapisuje do repa, je stále *draft* → domergovať |
| GitHub organizácia `lawoss` | ⏳ na odklep dnes — meno voľné (overené 12. 8.) |
| Tag forku `v0.1.13` | ⏳ na odklep dnes — stále najnovší release |
| Kto rieši merge konflikty pri syncu | ⏳ **stále nikto** — runbook je v PR #13, chýba meno |
| Apple Developer účet | ⏳ neriešené |
| `LICENSE` do repa | ⏳ **stále chýba** |
| Zverejniť `judikaty-mcp` | ⏳ stále private a bez licencie |

<sub>Doplnil MČ s AI asistenciou, 2026-08-12 ráno. Fakty o upstreame overené cez GitHub API k 2026-08-12. Stavy PR overené cez `gh` k 2026-08-12.</sub>

---

## 1️⃣ Východisko — čo už máme zadarmo

Toto je najdôležitejší bod, lebo mení, čo vôbec treba stavať. **[LegalWork](../decisions/0003-legal-work-ako-zaklad.md) nám hotové dáva:**

| Máme | Netreba stavať |
|---|---|
| Chat a lokálny agent, práca so súbormi | ✅ |
| Word, Excel a PowerPoint add-iny s tracked changes | ✅ |
| On-device transkripcia (whisper.cpp, parakeet) | ✅ |
| Tabular review s citáciami | ✅ |
| Voľba modelu — vlastné predplatné aj API kľúč | ✅ |
| UI na pridávanie MCP serverov a skillov | ✅ |

**Z toho vyplýva: MVP nie je „appka". MVP je to, čo z LegalWorku spraví nástroj pre slovenského a českého advokáta.**

---

## 2️⃣ Kritériá výberu do V1 — návrh

Aby sa dalo rozhodovať rýchlo, navrhujem štyri filtre. Funkcia ide do V1, ak spĺňa **všetky štyri**:

| # | Kritérium | Prečo |
|---|---|---|
| 1 | **Dá sa vydať rýchlo** | staviame na hotovom, nie od nuly |
| 2 | **Má hodnotu aj samostatne** | advokát ju ocení, aj keď zvyšok nie je |
| 3 | **Nízke riziko** | nič regulované, nič, čo koná v mene advokáta |
| 4 | **Väčšinu už máme** | MCP servery a OKF skilly existujú |

---

## 3️⃣ Návrh scope V1

```mermaid
flowchart TB
    subgraph V1["📦 V1 — MVP"]
        L["🇸🇰🇨🇿 SK/CZ lokalizácia"]
        O["📁 OKF — spisy a štruktúra"]
        M["🔌 MCP: judikatúra + Slov-Lex"]
        D["⏰ Lehoty"]
        C["📄 OCR ingest → markdown"]
    end
    LW["🖥️ LegalWork<br/><i>chat · add-iny · transkripcia · UI</i>"]
    V1 --> LW
    classDef v fill:#0b4f2a,stroke:#3ad98b,color:#fff
    class V1 v
```

| Funkcia | Odkiaľ | Prečo do V1 | Kto |
|---|---|---|---|
| **SK/CZ lokalizácia rozhrania** | [ADR 0004](../decisions/0004-ako-rozsirit-legalwork.md) | Bez nej to advokát nepoužije. Sú to **nové súbory locale** → nulový merge konflikt, a ich CI to aj testuje. Zároveň náš prvý upstream PR. | MČ + VŘ |
| **OKF — založenie spisu a štruktúra** | [spec 0002](../specs/0002-okf-operacny-system-praxe.md) | Jadro odlíšenia. MČ to má osobne rozbehnuté — ide o zabalenie, nie o vynález. | MČ |
| **MCP konektory: judikatúra + Slov-Lex** | [spec 0004](../specs/0004-mcp-sk-konektory.md) | Najviditeľnejšia hodnota. Servery existujú, read-only = nízke riziko. | MČ |
| **Lehoty a timeline spisu** | [spec 0005](../specs/0005-lehoty-timeline.md) | Kandidát #1 od MF. Zmeškaná lehota je najčastejší dôvod zodpovednosti advokáta — hodnota aj samostatne. | MF |
| **OCR ingest → markdown** | návrh #8 | Quick win, MČ má hotovú Quick Action. | MČ |

> [!TIP]
> **Jedna vec sa dá vydať budúci týždeň, bez forku a bez programovania.**
> MCP servery sa v LegalWorku pridávajú **cez UI** (*Settings → pridať MCP server*). Čiže judikatúrny a Slov-Lex konektor viete dať kolegom **hneď** ako návod so screenshotmi — a máme prvý reálny výstup, kým sa fork ešte len rozbieha. Odporúčam to spraviť ako nultý krok.

---

## 4️⃣ Čo do V1 vedome NEDÁVAME

Toto je rovnako dôležité — bez toho sa MVP rozleje.

| Funkcia | Prečo nie teraz |
|---|---|
| **Tiered memory s compaction** *(#21)* | Najsilnejší diferenciátor, ale najväčší build. **OKF v MVP pokryje základnú „pamäť prípadu"** — štruktúra a markdown v spise. Plná verzia vo V2. |
| **Podpisovanie QES + QTS** *(#19)* | Regulované, potrebuje human gate a overenie advokátskeho preukazu. → V2 |
| **Zaručená konverzia** *(#26)* | **Rozhodnuté 7. 8.: až ďalšia verzia.** Regulovaná činnosť. |
| **Zjednotenie komunikačných kanálov** *(#22)* | Najsilnejšie pomenovaná bolesť (VŘ), ale veľký scope a nejasné riešenie. |
| **Transkripcia do spisu** *(#1)* | LegalWork už transkribuje sám — naviazanie na spis je pridaná hodnota, nie podmienka. |
| Fakturácia, self-healing, PL, Workspace | → [zberný kôš](../planning/napady.md) |

---

## 5️⃣ Blokátory, ktoré musia padnúť skôr

> [!WARNING]
> **Bez týchto rozhodnutí sa V1 nedá začať.** Sú otvorené z minulého callu.

- [ ] **Potvrdenie [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md) od MF** — nezúčastnil sa calle 6. 8.
- [ ] **Zakladáme GitHub organizáciu?** Ak áno, **pred forkom** — [ADR 0005](../decisions/0005-struktura-repozitarov.md)
- [ ] **Ktorý tag LegalWorku forkneme?** *(kandidát `v0.1.13`)*
- [ ] **Kto rieši merge konflikty pri upstream syncu?** V tíme dnes nikto
- [ ] **Kto zriadi Apple Developer účet** na notarizáciu macOS buildov
- [ ] **Doplniť `LICENSE`** do repa — stále chýba
- [ ] **Zverejniť `judikaty-mcp`** — je private a bez licencie, čím blokuje komunitnú časť

---

## 6️⃣ Čo odklepnúť

1. **Prijímame kritériá výberu** z bodu 2?
2. **Prijímame scope V1** z bodu 3 — alebo z neho niečo vypadne?
3. **Ide sa nultý krok** (MCP konektory ako návod, bez forku)?
4. **Termín V1** — dokedy chceme vydať?
5. **Rozdelenie práce** — kto berie ktorú položku?
6. Prejsť blokátory z bodu 5.

---

## 📎 Podklady

[Zberný kôš — všetkých 26 nápadov](../planning/napady.md) · [Evidencia návrhov](../specs/navrhy.md) · [Backlog](../planning/backlog.md) · [Roadmapa](../planning/roadmap.md) · [Zápis z callu 6. 8.](2026-08-06-sync-call-volba-zakladu.md) · [Spracovanie topicu Feature IDEAS](../research/idey/2026-08-07-feature-ideas-telegram.md)

---

<sub>Podklad pripravil MČ s AI asistenciou, 2026-08-07. Návrh scope je **návrh na prerokovanie**, nie rozhodnutie.</sub>
