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
- [ ] Zmapovať SK dátové zdroje (Slov-Lex, ORSR, RPVS, judikatúra, OV, FS)
- [x] Zmapovať existujúce slovenské MCP servery → [inventár](mcp-repository-inventory.md)
- [x] Vytvoriť 14 private organizačných MCP forkov a jeden private mirror s topics `mcp-server`, `majo-mcp`, `lawoss`, `legaltech`
- [x] **Zmapovať CZ dátové zdroje** *(VŘ)* — 15 zdrojov so stavom zrelosti, 5 pomenovaných medzier → [mapa CZ zdrojov](cz-datove-zdroje.md)
- [ ] Zmapovať PL zdroje *(VŘ, termín 20. 8.)*
- [x] **Pravidlá počítania lehôt** — SK *(IR, [PR #33](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/33))* a CZ *(VŘ, [podklad](../research/pravny-ramec/2026-08-15-lhoty-cz-pravidla-vypoctu.md))*; spolu 42 pravidiel, 39 lehôt, 32 pascí, 43 testov
- [ ] Právny rámec: GDPR, predpisy SAK, mlčanlivosť, AI Act
- [ ] Potvrdenie ADR 0003 od MF *(nezúčastnil sa callu 6. 8.)*
- [ ] ⚠️ **Odblokovať [issue #40](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/40)** *(MČ)* — IR má pripravený mirror 20 SK predpisov (~6300 súborov) a rozhodnutia NS SR, ale ako member nemôže zakladať repozitáre

## Fáza 1 — Fork & MVP (Q4 2026)

- [x] **Založiť fork** [Omni-Legal-Products/lawoss](https://github.com/Omni-Legal-Products/lawoss) z [eigenweltlabs/legalwork](https://github.com/eigenweltlabs/legalwork)
- [ ] Nastaviť `upstream` remote a rytmus synchronizácie pri ich releasoch
- [ ] Založiť `PATCHES.md` — evidencia každého zásahu do upstream súborov
- [ ] Rebranding: `apps/desktop/electron-builder.yml` (`appId`, `productName`, URL schéma) + runtime identifikátory v `apps/desktop/electron/main.mjs` + ikona *(overené 2026-08-12: tri miesta; zmena `appId` mení macOS bundle identitu — keychain, Launchpad, TCC)*
- [ ] Doplniť podpisové tajomstvá do GitHub Secrets forku
- [ ] **SK + CZ lokalizácia rozhrania** — ani jeden z 12 podporovaných jazykov; čistý príspevok do upstreamu
- [ ] Prvý SK MCP server integrovaný *(registrácia v configu, bez zásahu do jadra)*
- [ ] UI/CLI prepínač *(VŘ)*
- [ ] Interné testovanie (MČ · MF · IR · VŘ)
- [ ] **OKF ako jadro MVP** - tri vrstvy pamäte, reconciliation s human approval a auditom
- [ ] **Onboarding spisu a subjektov** - conflict check, AML, sankcie, diskvalifikácie a registre cez MCP
- [ ] **Základné skills pre spis** - zápis, kontrola čerstvosti, periodická konsolidácia a rollback
- [ ] **Anonymizácia odložená** - neimplementovať v aktuálnej fáze; zachovať ako budúci voliteľný modul
- [ ] **Tímové rozhodnutia Q01 až Q25** — ✅ IR *(14. 8.)* · ✅ VŘ *(15. 8.)* · ⏳ MČ rozpracované · ⏳ MF zatiaľ nič → [živý prehľad](2026-08-14-stav-odpovedi-timu.md)
- [ ] ⚔️ **Rozseknúť Q07** *(MČ ako product owner)* — jediná vecná odchýlka medzi IR a VŘ: patria lehoty do prvej trojice vertikál, alebo onboarding subjektov?
- [ ] **Prepísať uzavreté odpovede do ADR** — governance, branching a release, scope prvej iterácie, pamäťové hranice, lokálnosť dát a platformy, monetizácia, architektúra formátov

## Fáza 2 — Pilot a komunita (2027)

- [ ] Pilotná skupina advokátov
- [ ] Prvý workshop/školenie
- [ ] Zber spätnej väzby a iterácie
- [ ] Dokumentácia pre prispievateľov
