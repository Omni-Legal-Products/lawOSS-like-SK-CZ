# Roadmapa

> Checkboxy v tomto priečinku automaticky napájajú progress bary v README.

## Fáza 0 — Príprava a plánovanie (Q3 2026)

- [x] Založiť plánovacie repo a štruktúru
- [x] Nastaviť auto-aktualizované README
- [x] **Analýza architektúry základu** — LegalWork stojí na pinnutom [opencode](https://github.com/sst/opencode); MCP, agenti a skills sú konfiguračné → [analýza](../research/inspiracie/legalwork.md)
- [x] **ADR 0003: voľba základu — LegalWork** *(nahrádza ADR 0002)* → [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md)
- [x] **Licencia: MIT** — vyplýva z voľby základu → [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md)
- [ ] ⚠️ **Doplniť `LICENSE`, `NOTICE`, `CONTRIBUTING`** do tohto repa *(MČ)*
- [x] **[ADR 0004: forkujeme LegalWork pod vlastným brandingom](../decisions/0004-ako-rozsirit-legalwork.md)** *(rozhodol MČ; na potvrdenie MF · IR · VŘ)*
- [x] **Založiť organizáciu [Omni Legal Products](https://github.com/Omni-Legal-Products)** a oddeliť koordináciu od produktového kódu
- [x] **Založiť verejný fork [Omni-Legal-Products/lawoss](https://github.com/Omni-Legal-Products/lawoss)** z `eigenweltlabs/legalwork`, default vetva `dev`
- [ ] ⚠️ **Potvrdiť [ADR 0005: štruktúra repozitárov](../decisions/0005-struktura-repozitarov.md)** tímom a zosúladiť ho so skutočným stavom organizácie
- [ ] Zriadiť **Apple Developer účet** pre notarizáciu macOS buildov
- [ ] Spísať platformovú maticu: spoločné jadro, macOS integrácie a Windows integrácie
- [ ] Zmapovať SK dátové zdroje (Slov-Lex, ORSR, RPVS, judikatúra, OV, FS)
- [x] Zmapovať existujúce slovenské MCP servery → [inventár](mcp-repository-inventory.md)
- [x] Vytvoriť 14 private organizačných MCP forkov a jeden private mirror s topics `mcp-server`, `majo-mcp`, `lawoss`, `legaltech`
- [ ] Zmapovať CZ zdroje *(VŘ)* a PL zdroje *(VŘ)*
- [ ] Právny rámec: GDPR, predpisy SAK, mlčanlivosť, AI Act
- [ ] Potvrdenie ADR 0003 od MF *(nezúčastnil sa callu 6. 8.)*

## Fáza 1 — Fork & MVP (Q4 2026)

- [x] **Založiť fork** [Omni-Legal-Products/lawoss](https://github.com/Omni-Legal-Products/lawoss) z [eigenweltlabs/legalwork](https://github.com/eigenweltlabs/legalwork)
- [ ] Nastaviť `upstream` remote a rytmus synchronizácie pri ich releasoch
- [ ] Založiť `PATCHES.md` — evidencia každého zásahu do upstream súborov
- [ ] Rebranding: `tauri.conf.json` + `productName` + ikona *(overené: iba 2 miesta)*
- [ ] Doplniť podpisové tajomstvá do GitHub Secrets forku
- [ ] **SK + CZ lokalizácia rozhrania** — ani jeden z 12 podporovaných jazykov; čistý príspevok do upstreamu
- [ ] Prvý SK MCP server integrovaný *(registrácia v configu, bez zásahu do jadra)*
- [ ] UI/CLI prepínač *(VŘ)*
- [ ] **macOS ako hlavná platforma** - natívne integrácie viesť bez požiadavky na úplnú paritu s Windows *(MČ · MF · VŘ)*
- [ ] **Windows integračná vetva** - návrh, overovanie a natívne Windows výhody *(IR)*
- [ ] Interné testovanie (MČ · MF · IR · VŘ)
- [ ] **OKF ako jadro MVP** - tri vrstvy pamäte, reconciliation s human approval a auditom
- [ ] **Onboarding spisu a subjektov** - conflict check, AML, sankcie, diskvalifikácie a registre cez MCP
- [ ] **Základné skills pre spis** - zápis, kontrola čerstvosti, periodická konsolidácia a rollback
- [ ] **Anonymizácia odložená** - neimplementovať v aktuálnej fáze; zachovať ako budúci voliteľný modul
- [ ] **Tímové rozhodnutia Q01 až Q25** - MF, IR a VŘ prejdú otázky cez svojich agentov; Q24 rieši produktovú doktrínu, Q25 nezáväzný návrh otvorených formátov

## Fáza 2 — Pilot a komunita (2027)

- [ ] Pilotná skupina advokátov
- [ ] Prvý workshop/školenie
- [ ] Zber spätnej väzby a iterácie
- [ ] Dokumentácia pre prispievateľov
