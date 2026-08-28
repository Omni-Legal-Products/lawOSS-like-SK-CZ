---
type: agents
title: {{TITLE}} — AGENTS
updated: {{DATE}}
---

# AGENTS.md — vstupný bod pre AI v tomto spise

> Zrkadlené s `CLAUDE.md`. Po zmene spusti `sync_agents_claude.sh`.

**Poradie čítania:** 1) [`spis.md`](./spis.md) 2) [`_STATUS.md`](./_STATUS.md) — najmä **Fáza / Ďalší krok** 3) [`MEMORY.md`](./MEMORY.md) 4) klient [`../../AGENTS.md`](../../AGENTS.md).

<!-- okf:protokol-zapisu:v1 -->
## PROTOKOL ZÁPISU (povinný)

> Kontext konverzácie sa stráca. Tento priečinok je jediná trvalá pamäť veci —
> **čo nezapíšeš, pre budúceho agenta neexistuje.**

**Počas práce — zapíš HNEĎ, keď sa objaví:**

| Čo sa objavilo | Kam to zapísať |
|---|---|
| nový FAKT veci (tvrdenie, zistenie, priznanie, stav veci) | `_STATUS.md` → § Fakty veci |
| udalosť (podanie, doručenie, pojednávanie, hovor, výzva) | `_STATUS.md` → § Chronológia |
| nová / zmenená / zmeškaná LEHOTA | `spis.md` frontmatter `lehoty:` **a** `_STATUS.md` → § Lehoty |
| taktické rozhodnutie, stratégia („takto áno / takto nie") | `MEMORY.md` → TP-XXX |
| poučenie, prekvapenie, čo nabudúce inak | `MEMORY.md` → LL-XXX |
| otvorená otázka bez odpovede | `MEMORY.md` → OQ-XXX |
| nový dokument (prijatý aj náš výstup) | správny podpriečinok **a** `_STATUS.md` → § Kľúčové dokumenty |
| e-mail thread / tel. hovor / správa relevantná pre vec | `_STATUS.md` → § Komunikácia |
| nová úloha alebo záväzok (náš aj klientov) | `_STATUS.md` → § Otvorené úlohy |

**Pred ukončením práce — HARD GATE (nikdy nekonči odpoveď bez tohto):**

- [ ] Všetko z tabuľky vyššie je zapísané? (prejdi konverzáciu spätne)
- [ ] `_STATUS.md`: **Fáza** a **Ďalší krok** navrchu zodpovedajú realite po tejto práci?
- [ ] `updated:` vo frontmatteri každého zmeneného súboru bumpnuté na dnešný dátum?
- [ ] Menil si `AGENTS.md`? → zosynchronizuj `CLAUDE.md` (`sync_agents_claude.sh`)

## Komunikačné pravidlá (tento spis)
- Citácie predpisov/judikátov VŽDY cez MCP (slovlex/judikáty); zdroje pod `# Citations`.
- Korporátne údaje protistrany overené cez ORSR/RPO, nie z pamäte.
- {{DESCRIPTION}}

## Checklist pred odoslaním dokumentu von
- [ ] citácie overené cez MCP
- [ ] údaje protistrany overené cez ORSR
- [ ] dokument uložený do `2 - Drafty/` ako `YYYY-MM-DD typ - popis.ext`
- [ ] `_STATUS.md` aktualizovaný (dokument + chronológia)
