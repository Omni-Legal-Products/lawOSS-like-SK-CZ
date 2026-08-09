# Roadmapa

> Checkboxy v tomto priečinku automaticky napájajú progress bary v README.

## Fáza 0 — Príprava a plánovanie (Q3 2026)

- [x] Založiť plánovacie repo a štruktúru
- [x] Nastaviť auto-aktualizované README
- [x] **Analýza architektúry základu** — LegalWork stojí na pinnutom [opencode](https://github.com/sst/opencode); MCP, agenti a skills sú konfiguračné → [analýza](../research/inspiracie/legalwork.md)
- [x] **ADR 0003: voľba základu — LegalWork** *(nahrádza ADR 0002)* → [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md)
- [x] **Licencia: MIT** — vyplýva z voľby základu → [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md)
- [ ] ⚠️ **Doplniť `LICENSE`, `NOTICE`, `CONTRIBUTING`** do tohto repa *(MČ)*
- [x] **[ADR 0004: forkujeme LegalWork pod vlastným brandingom](../decisions/0004-ako-rozsirit-legalwork.md)** *(rozhodol MČ; MF podmienečne podporil 2026-08-09; IR · VŘ čakajú)*
- [ ] ⚠️ **[ADR 0005: štruktúra repozitárov](../decisions/0005-struktura-repozitarov.md)** — koordinácia oddelene od kódu; návrh na prerokovanie
- [ ] Rozhodnúť, či zakladáme **GitHub organizáciu** — ak áno, **pred forkom**
- [ ] Zriadiť **Apple Developer účet** pre notarizáciu macOS buildov
- [ ] Zmapovať SK dátové zdroje (Slov-Lex, ORSR, RPVS, judikatúra, OV, FS)
- [ ] Zmapovať existujúce slovenské MCP servery
- [ ] Zmapovať CZ zdroje *(VŘ)* a PL zdroje *(VŘ)*
- [ ] Právny rámec: GDPR, predpisy SAK, mlčanlivosť, AI Act
- [x] Potvrdenie ADR 0003 od MF — potvrdené 2026-08-09 komentárom k PR #5

## Fáza 1 — Fork & MVP (Q4 2026)

- [ ] **Založiť fork** cez GitHub *Fork* z [eigenweltlabs/legalwork](https://github.com/eigenweltlabs/legalwork) *(kandidát na tag: `v0.1.13`)*
- [ ] Nastaviť `upstream` remote a rytmus synchronizácie pri ich releasoch
- [ ] Založiť `PATCHES.md` — evidencia každého zásahu do upstream súborov
- [ ] Rebranding: `tauri.conf.json` + `productName` + ikona *(overené: iba 2 miesta)*
- [ ] Doplniť podpisové tajomstvá do GitHub Secrets forku
- [ ] **SK + CZ lokalizácia rozhrania** — ani jeden z 12 podporovaných jazykov; čistý príspevok do upstreamu
- [ ] Prvý SK MCP server integrovaný *(registrácia v configu, bez zásahu do jadra)*
- [ ] UI/CLI prepínač *(VŘ)*
- [ ] Interné testovanie (MČ · MF · IR · VŘ)

## Fáza 2 — Pilot a komunita (2027)

- [ ] Pilotná skupina advokátov
- [ ] Prvý workshop/školenie
- [ ] Zber spätnej väzby a iterácie
- [ ] Dokumentácia pre prispievateľov
