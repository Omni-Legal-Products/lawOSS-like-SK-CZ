# Backlog

Surové nápady patria do GitHub Issues/Discussions — sem sa dostáva to, čo prežilo diskusiu.
Dozreté položky majú vlastnú špecifikáciu v [specs/](../specs/).

## 🚀 Alfa — vydať ASAP (zúžený scope)

- [ ] ⏰ **Lehoty + kalendár** → [spec 0005](../specs/0005-lehoty-timeline.md) *(MF; kandidát #1)*
- [ ] 📁 **OKF + prijatie veci s conflict checkom** (ORSR/RPO MCP už bežia)
- [ ] 📄 **OCR ingest → markdown** — Mistral OCR quick win (existujúca Quick Action MČ)

## Kandidáti na v1 (majú spec)

- [ ] 📁 **OKF — operačný systém advokátskej praxe** → [spec 0002](../specs/0002-okf-operacny-system-praxe.md) *(vysoká priorita, jadro odlíšenia)*
- [ ] 🎙️ **Transkripcia** (hovory, porady, diktát → do spisu) → [spec 0001](../specs/0001-transkripcia.md)
- [ ] 🔓 **Otvorený prompt layer** (žiadny black box, voľba modelu) → [spec 0003](../specs/0003-prompt-layer.md)
- [ ] 🔌 **SK MCP konektory** (judikatúra, Slov-Lex, registre) → [spec 0004](../specs/0004-mcp-sk-konektory.md)

## Konektory (väčšina už existuje, treba zabaliť)

- [ ] MCP: Slov-Lex (zákony a predpisy)
- [ ] MCP: ORSR / RPO (obchodný register)
- [ ] MCP: RPVS (koneční užívatelia výhod)
- [ ] MCP: judikatúra (rozhodnutia súdov)
- [ ] Verifikácia citácií (§ a spisové značky) — anti-halucinačná poistka
- [ ] Integrácia na slovensko.sk *(pozor: zápisové úkony = vysoké riziko, viď [spec 0004](../specs/0004-mcp-sk-konektory.md))*

## 🆕 Z callu 6. 8. 2026

Zdroj: [zápis zo sync callu](../meetings/2026-08-06-sync-call-volba-zakladu.md) · evidencia v [navrhy.md](../specs/navrhy.md)

- [ ] 🗂️ **Digitálna sekretárka** — založenie spisu → priečinky → workflow písaných aj diktovaných zápiskov → markdown do spisu *(MČ; spája [spec 0001](../specs/0001-transkripcia.md) + [spec 0002](../specs/0002-okf-operacny-system-praxe.md))*
- [ ] 🖥️ **UI/CLI prepínač** — UI ako default, CLI ako voliteľný režim *(MČ, podnet VŘ)*
- [ ] 📄 **Markdown/Obsidian interoperabilita** — žiadny vendor lock-in, rešpektovať existujúce systémy používateľov *(MČ s VŘ)*
- [ ] 🧩 **Modulové rozhranie plug-and-play** — moduly ako LEGO, konfigurácia, bezpečnostné hranice *(IR do 2026-08-19)*
- [ ] ⚖️ **MCP Salvia** — CZ judikatúra ako voliteľný modul *(VŘ; ~10 € / 3 000 dotazov — **overiť licenčné podmienky pre komunitné zdieľanie**)*
- [ ] 🎯 **Špecializovaní agenti podľa právneho odvetvia** — všeobecný agent spotrebuje priveľa dotazov *(VŘ)*
- [ ] 🇵🇱 **Poľské rozšírenie** — mapovanie voľne dostupných PL zdrojov *(VŘ do 2026-08-20)*
- [ ] 🌍 **Jurisdikčne neutrálny intake** pre SK/CZ/PL *(MČ do 2026-08-18)*
- [ ] 🔍 **Rešeršný workflow „one-click"** cez NotebookLM CLI *(MČ)*
- [ ] 📦 **Balíček „Community Skills"** — OKF, rešerše, judikatúra + dokumentácia *(MČ do 2026-08-15)*
- [ ] 💾 **Publikovať legálne použiteľné datasety** na GitHub, nech nemusí každý scrapovať od nuly *(MČ do 2026-08-10)*
- [ ] 📧 **Google Workspace integrácia** — e-maily, outreach *(MČ; nízka priorita)*
- [ ] 🔬 **Analýza repozitára Determo** — prenositeľné koncepty a bezpečnostné vzory *(VŘ do 2026-08-12)*

## Ďalšie nápady (bez specu)

- [ ] Anonymizácia / sanitizačný filter pred LLM (MasKIT + SK regex: rodné číslo, IBAN)
- [ ] SK šablóny podaní a zmlúv
- [x] Mistral OCR — PDF → Markdown: presunuté do alfy (quick win, existujúca Quick Action)

## Rozhodnúť

- [x] ✅ **Voľba základu — rozhodnuté 2026-08-06: LegalWork** → [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md) *(nahrádza [ADR 0002](../decisions/0002-preco-forkujeme-mikeoss.md); čaká na potvrdenie MF)*
- [x] ✅ **Licencia — MIT**, vyplýva z voľby základu (LegalWork je MIT) → [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md)
- [ ] ⚠️ **Doplniť súbory `LICENSE`, `NOTICE`, `CONTRIBUTING`** — repo je verejné, ale **bez `LICENSE` platí „all rights reserved"** *(MČ do 2026-08-08)*
- [x] ✅ **Ako rozšíriť LegalWork — rozhodnuté: forkujeme pod vlastným brandingom** → [ADR 0004](../decisions/0004-ako-rozsirit-legalwork.md) *(rozhodol MČ; na potvrdenie tímom)*
- [ ] ⚠️ **Kto rieši merge konflikty pri upstream syncu** — v tíme dnes nikto; overiť, či to zvládne AI asistencia
- [ ] ⚠️ **Apple Developer účet a podpisovanie** — bez notarizácie Gatekeeper macOS build zablokuje
- [ ] ⚠️ **Štruktúra repozitárov** — koordinácia oddelene od kódu → **[ADR 0005](../decisions/0005-struktura-repozitarov.md)** *(návrh napísaný; zahŕňa GitHub organizáciu a zverejnenie `judikaty-mcp`)*
- [ ] Ktorá verzia LegalWork sa forkne (tag/commit)?
- [ ] Čím nahradiť marketingovú expozíciu po upustení od Mikea *(názov LAWOSS zostáva)*
- [ ] 🎨 **Zjednotiť wordmark — všade „CZECHIA · SLOVAKIA"** — pregenerovať `keyvisual-mobile.png` (má len „SLOVAKIA") a `moodboard.png` (starý wordmark + odkaz `t.me/LawOSS_Slovakia`) → [pravidlo v assets/brand](../assets/brand/README.md)
