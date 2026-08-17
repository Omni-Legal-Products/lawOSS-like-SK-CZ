# Backlog

Surové nápady patria do **[zberného koša](napady.md)** — sem sa dostáva to, čo prežilo diskusiu.
Dozreté položky majú vlastnú špecifikáciu v [specs/](../specs/).

> [!TIP]
> **Máš nový nápad?** Nepíš ho sem — hoď ho do Telegram topicu *Feature IDEAS*, cez [formulár](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/new?template=feature-navrh.yml), alebo do [zberného koša](napady.md). Odtiaľ ho po prerokovaní presunieme.
>
> **Scope V1 sa spresnil na calle 12. 8.** → [zápis a priority](../meetings/2026-08-12-produktova-vizia-okf-pamat.md). Otvorené rozhodnutia sú v [Q01 až Q25](2026-08-12-rozhodovacie-otazky-timu.md).

## 🚀 Alfa — vydať ASAP (zúžený scope)

- [ ] 📁 **OKF + tri vrstvy pamäte + reconciliation** → [spec 0002](../specs/0002-okf-operacny-system-praxe.md) *(hlavná produktová priorita MČ; rozhodnutie z callu 2026-08-12)*
- [ ] 🔍 **Prijatie veci + subjektový research** - conflict check, AML, sankcie, diskvalifikácie a registre cez MCP
- [ ] 🧩 **Základné skills pre prácu so spisom** - zápis, čerstvosť, audit a pravidelná reconciliácia

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
- [x] 🇨🇿 **Mapa českých dátových zdrojov** — 15 zdrojov so stavom zrelosti, 5 pomenovaných medzier *(VŘ, hotové 2026-08-15)* → [cz-datove-zdroje.md](cz-datove-zdroje.md)
- [ ] 🇵🇱 **Poľské rozšírenie** — mapovanie voľne dostupných PL zdrojov *(VŘ do 2026-08-20; potvrdené v odpovedi na Q19)*
- [ ] 🌍 **Jurisdikčne neutrálny intake** pre SK/CZ/PL *(MČ do 2026-08-18)*
- [ ] 🔍 **Rešeršný workflow „one-click"** cez NotebookLM CLI *(MČ)*
- [ ] 📦 **Balíček „Community Skills"** — OKF, rešerše, judikatúra + dokumentácia *(MČ do 2026-08-15)*
- [ ] 💾 **Publikovať legálne použiteľné datasety** na GitHub, nech nemusí každý scrapovať od nuly *(MČ do 2026-08-10)*
- [ ] 📧 **Google Workspace integrácia** — e-maily, outreach *(MČ; nízka priorita)*
- [ ] 🔬 **Analýza repozitára Determo** — prenositeľné koncepty a bezpečnostné vzory *(VŘ do 2026-08-12)*

## Ďalšie nápady (bez specu)

- [ ] ⏸️ **Lokálny anonymizačný gate pred externým LLM** → [spec 0008](../specs/0008-anonymizacia-a-privacy-gate.md) · [Issue #15](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/15) - nice to have, odložené mimo prvej verzie; zachované ako podklad pre budúci voliteľný modul
- [ ] SK šablóny podaní a zmlúv
- [x] Mistral OCR — PDF → Markdown: presunuté do alfy (quick win, existujúca Quick Action)

## 🗳️ Z odpovedí na Q01 až Q25

Prišlo s odpoveďami IR *(14. 8.)* a VŘ *(15. 8.)*. Evidencia v [navrhy.md](../specs/navrhy.md) **#34–#41**, plné znenie v [zbernom koši](napady.md) · [prehľad odpovedí](2026-08-14-stav-odpovedi-timu.md)

- [ ] 📄 **DOCX round-trip s testovacím korpusom a vizuálnou kontrolou** — [návrh #34](../specs/navrhy.md) *(VŘ)*; deväť zdokumentovaných spôsobov, ako sa rozbije `.docx` → PDF, ktoré **textová kontrola nenájde**. Podmienka k Q25.
- [ ] 🚨 **Kontrolný dotaz (canary) pri sankčnom screeningu** — [návrh #35](../specs/navrhy.md) *(VŘ)*; bez neho „čistý výsledok" znamená len „dotaz neprešiel". Podmienka k Q14 a k metodike AML.
- [ ] 🔒 **Hranica vynútená v nástroji, nie v prompte** — [návrh #36](../specs/navrhy.md) *(VŘ)*; *„čo agent nesmie, mu nemá ísť ponúknuť."* Navrhnuté do [ADR 0007](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/19), ten čaká na MF.
- [ ] 🧠 **Typované záznamy pamäte + oddelená vrstva „poučenie z chyby"** — [návrh #37](../specs/navrhy.md) *(VŘ)*; doplnok k [spec 0002](../specs/0002-okf-operacny-system-praxe.md) z vyše roka prevádzky.
- [ ] 📊 **Metrika „koľko z návrhu advokát prepísal a v čom"** — [návrh #38](../specs/navrhy.md) *(VŘ)*; metrika štýlu, nie správnosti. Keď neklesá, prompt layer sa neučí.
- [ ] 📤 **Export do existujúcich spisových a fakturačných systémov** — [návrh #39](../specs/navrhy.md) *(VŘ)*; české kancelárie ich väčšinou už majú. Mení ťažisko Q08.
- [ ] 🔁 **Distribúcia schváleného poznatku ku všetkým agentom** — [návrh #40](../specs/navrhy.md) *(VŘ)*; doložený prípad, keď subagent zopakoval už zamietnutý judikát.
- [ ] 🔧 **Automat na upstream sync s konfliktným reportom** — [návrh #41](../specs/navrhy.md) *(IR)*; viazaný na `PATCHES.md`. Rieši otvorenú položku *„Kto rieši merge konflikty pri upstream syncu"* nižšie.

## Rozhodnúť

- [x] ✅ **Voľba základu — rozhodnuté 2026-08-06: LegalWork** → [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md) *(nahrádza [ADR 0002](../decisions/0002-preco-forkujeme-mikeoss.md); čaká na potvrdenie MF)*
- [x] ✅ **Licencia — MIT**, vyplýva z voľby základu (LegalWork je MIT) → [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md)
- [ ] ⚠️ **Doplniť súbory `LICENSE`, `NOTICE`, `CONTRIBUTING`** — repo je verejné, ale **bez `LICENSE` platí „all rights reserved"** *(MČ do 2026-08-08)*
- [x] ✅ **Ako rozšíriť LegalWork — rozhodnuté: forkujeme pod vlastným brandingom** → [ADR 0004](../decisions/0004-ako-rozsirit-legalwork.md) *(rozhodol MČ; na potvrdenie tímom)*
- [x] ✅ **GitHub organizácia a produktový fork** - [Omni Legal Products](https://github.com/Omni-Legal-Products) + [LAWOSS](https://github.com/Omni-Legal-Products/lawoss), overené cez GitHub API 2026-08-12
- [x] ✅ **Private tímové kópie MCP serverov** - 14 forkov a jeden mirror → [inventár](mcp-repository-inventory.md)
- [ ] 👥 **Prijať pozvánky do organizácie** - MF, IR a VŘ; overené cez GitHub API 2026-08-12 ako čakajúce
- [ ] 🗳️ **Vyjadriť sa k Q01 až Q25** — ✅ IR *(14. 8.)* · ✅ VŘ *(15. 8.)* · ⏳ **MČ** rozpracované · ⏳ **MF** zatiaľ nič → [živý prehľad odpovedí](2026-08-14-stav-odpovedi-timu.md)
- [ ] ⚔️ **Rozseknúť Q07 — poradie prvých troch vertikál** *(MČ)*; jediná vecná odchýlka medzi IR a VŘ: lehoty vs. onboarding subjektov v prvej trojici
- [ ] ⚠️ **Odblokovať [issue #40](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/40)** *(MČ)* — IR nemôže ako member zakladať repozitáre; čaká mirror 20 SK predpisov a rozhodnutia NS SR
- [ ] 🔏 **Rozhodnúť, kto platí podpisové certifikáty a na koho účet znejú** — IR aj VŘ si dali podpísané buildy ako **osobnú podmienku účasti** (Q06), takže to už nie je položka v backlogu, ale brána vydania
- [ ] ⚠️ **Kto rieši merge konflikty pri upstream syncu** — v tíme dnes nikto; overiť, či to zvládne AI asistencia
- [ ] ⚠️ **Apple Developer účet a podpisovanie** — bez notarizácie Gatekeeper macOS build zablokuje
- [ ] ⚠️ **Štruktúra repozitárov** — koordinácia oddelene od kódu → **[ADR 0005](../decisions/0005-struktura-repozitarov.md)** *(návrh napísaný; zahŕňa GitHub organizáciu a zverejnenie `judikaty-mcp`)*
- [ ] Ktorá verzia LegalWork sa forkne (tag/commit)?
- [ ] Čím nahradiť marketingovú expozíciu po upustení od Mikea *(názov LAWOSS zostáva)*
- [x] ✅ **Zjednotiť wordmark — keyvisualy pregenerované 2026-08-06** so správnym „CZECHIA · SLOVAKIA" → [pravidlo v assets/brand](../assets/brand/README.md)
- [ ] 🎨 Pregenerovať `moodboard.png` — stále nesie starý wordmark „LAWOSS SLOVAKIA" a odkaz `t.me/LawOSS_Slovakia`
- [ ] 🔏 **Podpisovanie QES + QTS a zaručená konverzia** → **[spec 0007](../specs/0007-podpisovanie-a-zarucena-konverzia.md)** *(návrhy [#19 a #26](../specs/navrhy.md))*. Cez [Autogram](https://github.com/slovensko-digital/autogram) ako externý proces — CLI aj HTTP API na `localhost:37200`. ⚠️ EUPL-1.2 → nevendorovať.
- [ ] 💳 Overiť v praxi, či **slovenský advokátsky preukaz** funguje v Autograme cez PKCS#11 *(MČ)*
- [ ] 🇨🇿 Potvrdiť **český rámec autorizovanej konverze** *(VŘ)*
- [ ] 🤔 Rozhodnúť, či LAWOSS volá **Autogram priamo, alebo vlastnú konverznú appku MČ** — nech nevzniknú dve cesty
- [ ] 💰 **Fakturácia a výkazy času** — [návrh #20](../specs/navrhy.md); dizajnový prieskum, bez specu

## 💡 Z Telegram topicu Feature IDEAS

Spracované 2026-08-07 → [celý rozbor](../research/idey/2026-08-07-feature-ideas-telegram.md)

- [ ] 🧠 **Tiered memory s compaction** — [návrh #21](../specs/navrhy.md); denné → týždenné → mesačné + sumarizácie na úrovni klienta. **Najsilnejší kandidát na vlajkovú funkciu alfy** — MČ aj VŘ sa na tom zhodli nezávisle. Stavať nad [OKF](../specs/0002-okf-operacny-system-praxe.md), nie replikovať LegalMemory.
- [ ] 📨 **Zjednotenie komunikačných kanálov do spisu** — [návrh #22](../specs/navrhy.md); jediný explicitne pomenovaný nevyriešený problém z praxe *(VŘ)*
- [ ] 🔄 **Self-healing a self-updating integrácie** — [návrh #23](../specs/navrhy.md); otvorené: čo pri breaking change a rollbacku
- [ ] 🧬 **Self-evolving / self-correcting systém** — [návrh #24](../specs/navrhy.md); nerozvinuté
- [ ] 📋 **CMR a case audit systém** — [návrh #25](../specs/navrhy.md); zatiaľ len heslo
- [ ] 🔍 Preskúmať konkurenciu: **forlegal.ai** *(CZ, platený)*, **legaltools.cz**, **buzz.xyz**
- [ ] ❓ Doplniť, o aký „jednotný štandard" išlo v odkaze na OpenAI devs
