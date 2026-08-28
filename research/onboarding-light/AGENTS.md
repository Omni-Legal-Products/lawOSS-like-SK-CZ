# AGENTS.md — pracovný priestor: onboarding + light verzia (vlastník MF)

> Pre AI agentov (Codex, Claude Code, opencode…): toto je **zadanie a pravidlá** pre prácu v tomto priečinku. Najprv si prečítaj koreňový `AGENTS.md` repa (pravidlá git, verejné repo, žiadne klientske dáta), potom toto.

## Kontext v 60 sekundách

**LAWOSS** = open-source AI pracovné prostredie pre SK/CZ advokátov, fork [LegalWork](https://github.com/eigenweltlabs/legalwork) (Electron + opencode agent harness). Doktrína: **agent-first, advokát rozhoduje** ([ADR 0007](../../decisions/0007-agent-first-architektura.md), [ADR 0009](../../decisions/0009-zakladna-produktova-doktrina.md)). Dizajn: [design-system.md](../../docs/design/design-system.md) — LegalWork systém + naše tokeny (tmavá navy, zlatá = razidlo, IBM Plex, hranaté rohy).

**Rozhodnutie z callu 28. 8.** ([zápis](../../meetings/2026-08-28-zapis-sync-call.md), bod 4): appka bude mať **normálnu verziu** (plná, agent-first, bez systémových kompromisov) a **light verziu + jednoduchý onboarding** ako add-on pred verejným spustením — pre advokátov, ktorí sa v plnom rozhraní stratia (odhad MF: 90 %). Bloomberg analógia: light terminál / plný terminál. Light = tie isté funkcie, **poskryté možnosti**, nie iný systém.

## Úloha (výstupy do tohto priečinka)

Vlastní **MF**; agent pripravuje návrhy, MF rozhoduje. Vytvor:

1. **`koncept-onboarding.md`** — onboarding „klik-klik“ (5–10 obrazoviek):
   - povinné kroky: pripojenie modelu (ChatGPT/Claude/Gemini predplatné alebo API kľúč) · meno a jurisdikcia advokáta · výber koreňového priečinka (klienti/spisy)
   - vysvetľujúce kroky (text + neskôr video): „folder = klient“, „prvý krok v spise = inicializácia (agent prečíta a založí OKF súbory)“, ako písať agentovi, čo je model/reasoning effort **v reči advokáta, nie developera**
   - defaultné nastavenia podľa jurisdikcie: ktoré **skills** a **MCP servery** sa zapnú pre SK a ktoré pre CZ (zoznam kandidátov: [mcp-repository-inventory](../../planning/mcp-repository-inventory.md), skills v [`plugins/lawoss-legal`](../../plugins/lawoss-legal/))
   - krok „ako píšete” (voliteľný): ukážka vlastného podania → prvé pravidlá štýlu do pamäte, advokát schváli
2. **`koncept-light-view.md`** — zjednodušený pohľad:
   - čo advokát vidí: chat okno + zoznam klientov/spisov + súbory vygenerované agentom; čo je **skryté**: modely, reasoning, skills správa, MCP admin, terminál…
   - kde je preklik „plná verzia“ a čo sa stane pri prepnutí (nič sa nestratí — len sa odkryjú možnosti)
   - texty chýb a prázdnych stavov v jednoduchej reči
3. **`default-nastavenia.md`** — tabuľka: nastavenie · default light · default normál · kde žije (odkaz na settings tab / config súbor)

## Pravidlá

- Píš **po slovensky** (CZ špecifiká označ), pre **netechnického advokáta** — žiadne „LLM“, „token“, „harness“ bez vysvetlenia jedným dychom.
- Formát: markdown, tabuľky, ASCII wireframy obrazoviek sú vítané; žiadne HTML/kód — toto je koncept, nie implementácia.
- **Neimplementuj nič vo forku** — rozhodnutie o implementácii padne na calle (najbližší: ut 1. 9. 10:30).
- Light nesmie porušiť doktrínu: aj v light verzii platí human gate (návrhy s právnym účinkom advokát potvrdzuje) — zjednodušuje sa rozhranie, nie zodpovednosť.
- Fakty over (odkazy na specy/ADR vyššie); dohady označ „neoverené / na diskusiu“.
- Commituj do vetvy `docs/onboarding-light` a otvor PR (alebo push do main pri drobnostiach — podľa koreňového AGENTS.md).

## Kto je kto

MČ = Marián Čuprík (product owner, dizajn) · MF = Martin Friedrich (vlastník tohto konceptu) · IR = Igor Ribár (Windows, SK právo) · VŘ = Vojta Říha (CZ vrstva). Otázky → Telegram *General CHAT*.
