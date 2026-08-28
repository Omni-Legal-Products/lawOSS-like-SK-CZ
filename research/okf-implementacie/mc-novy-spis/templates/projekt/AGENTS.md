---
type: agents
title: {{TITLE}} — AGENTS
updated: {{DATE}}
---

# AGENTS.md — projektový vstupný bod ({{TITLE}})

Najprv prečítaj [`projekt.md`](./projekt.md) a [`MEMORY.md`](./MEMORY.md).

<!-- okf:protokol-zapisu:v1 -->
## PROTOKOL ZÁPISU (povinný)

> Čo nezapíšeš, pre budúceho agenta neexistuje.

| Čo sa objavilo | Kam to zapísať |
|---|---|
| rozhodnutie / zmena smeru | `MEMORY.md` |
| poučenie, čo nabudúce inak | `MEMORY.md` (LL-XXX) |
| otvorená otázka | `MEMORY.md` (OQ-XXX) |
| zmena stavu / milestone | `projekt.md` frontmatter (`status`, `milestones`) + `_STATUS.md` ak existuje |

**Pred ukončením práce:** zapísané? `updated:` bumpnuté v zmenených súboroch?
