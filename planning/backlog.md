# Backlog

Surové nápady patria do GitHub Issues/Discussions — sem sa dostáva to, čo prežilo diskusiu.
Dozreté položky majú vlastnú špecifikáciu v [specs/](../specs/).

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

## Ďalšie nápady (bez specu)

- [ ] Anonymizácia / sanitizačný filter pred LLM (MasKIT + SK regex: rodné číslo, IBAN)
- [ ] SK šablóny podaní a zmlúv
- [ ] Mistral OCR — PDF → Markdown pre naskenované spisy

## Rozhodnúť

- [ ] ⚠️ **Vybrať licenciu a doplniť súbor `LICENSE`** — repo je verejné, ale **bez licencie platí „all rights reserved"**, čo je v rozpore s deklarovaným open-source. Voľba súvisí so základom (mikeOSS = AGPL-3.0 → odvodené dielo musí byť tiež AGPL; LegalWork/Stella = permisívne)
- [ ] Názov projektu *(„mikeOSS Slovakia" je pracovný)*
- [ ] Voľba základu: mikeOSS / Stella / LegalWork → [inspiracie](../research/inspiracie/)
