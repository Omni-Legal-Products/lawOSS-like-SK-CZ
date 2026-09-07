# vr-pamat — pamäťový systém VŘ (referenčný snapshot)

Snímka systému, ktorý JUDr. Vojtěch Říha reálne prevádzkuje v českej praxi
(RIHA legal, AWRA insolvence). **Bez klientskych dát** — príklady sú vymyslené.

Nahrané ako podklad k zjednoteniu podľa [README o úroveň vyššie](../README.md)
a akčného bodu z [callu 28. 8.](../../../meetings/2026-08-28-zapis-sync-call.md).

Porovnanie s `mc-novy-spis` a zjednotený kontrakt: [`../zjednotenie.md`](../zjednotenie.md).

## Čo to je

Plochý adresár markdownových záznamov s YAML frontmatterom a jedným
indexovým súborom. Žiadna databáza, žiadny vektorový index. Agent (Claude Code,
Codex) index načíta na začiatku session a konkrétny záznam dočíta cielene.

```
memory/
├── MEMORY.md              ← index: jeden riadok na záznam
├── case_*.md              ← spisy a kauzy
├── feedback_*.md          ← korekcie a poučenia
├── reference_*.md         ← právne a technické referencie
├── project_*.md           ← dlhodobé projekty
└── cases-1..3/MEMORY.md   ← rozdelený index, keď hlavný prerástol
```

Vedľa toho beží globálna vrstva mimo tohto adresára: `persistent_memory.md`
(dlhodobý stav), `session_changelog.md` (chronológia práce),
`learning_journal.md` (poučenia), `corrections_log.md` (surové používateľské
korekcie) a `patterns.md` (konsolidované vzory).

## Tvar záznamu

```markdown
---
name: case-novak-vypoved-najmu
description: Novák ⁄ Svoboda, výpoveď nájmu — lehota na žalobu do 12. 9. 2026
metadata:
  node_type: memory
  type: project          # user | feedback | project | reference
  modified: 2026-08-29T20:09:53.755Z
---

Text záznamu. Prepojenia na iné záznamy cez [[case-novak-exekuce]].
```

`description` je nosič vybavovania — podľa neho sa rozhoduje, či je záznam
pre aktuálnu úlohu relevantný. Index nesie práve tento jeden riadok.

## Štyri typy

| Typ | Čo do neho patrí | Kde v OKF vrstvách |
|---|---|---|
| `user` | kto je používateľ, jeho preferencie a spôsob práce | L1 |
| `feedback` | korekcia od používateľa aj potvrdený postup; **vždy s „prečo"** | L1 |
| `project` | spis, kauza, prebiehajúca práca | L2 |
| `reference` | právna alebo technická referencia, pasce nástrojov | L3 |

## Stav prevádzky (overené 2026-08-29)

| | |
|---|---|
| záznamov v adresári | **289** |
| priemerná veľkosť záznamu | **7,1 kB** |
| najstarší záznam | 2026-02-26 |
| `type: project` / `reference` / `feedback` | 122 / 61 / 17 |
| **záznamov bez `metadata.type`** | **89 (31 %)** |
| wiki-odkazov medzi záznamami | 507 |
| veľkosť indexu (hlavný + 3 dielčie) | 126 kB |

## Čo sa v prevádzke osvedčilo

- **Typovanie**. Bez neho sa pamäť po pár mesiacoch nedá revidovať — `feedback`
  sa maže inak než `project` a mieša sa zle.
- **`description` ako jediný nosič vybavovania.** Index musí zostať čitateľný
  na jedno načítanie; obsah patrí do súboru, nie do indexu.
- **Wiki-odkazy.** 507 väzieb na 289 záznamov znamená, že súvisiace veci sa
  nájdu bez fulltextu.
- **Oddelená vrstva poučení z chyby.** To, čo sa model naučil zle, je iná
  kategória než obsah spisu.

## Čo sa neosvedčilo — a čo z toho plynie pre OKF

1. **31 % záznamov je bez typu.** Typ nebol vynútený, len odporúčaný — a presne
   to sa stalo. **Pre OKF: typ musí vynucovať nástroj, nie konvencia.**
2. **Index prerástol.** Musel sa deliť na `cases-1..3`, čo je ručná údržba
   a zdroj nekonzistencie. **Pre OKF: index sa má generovať, nie písať.**
3. **Zmena obsahu záznamu nemá stopu.** Prepíše sa text a starý stav zmizne;
   po mesiacoch sa nedá zistiť, prečo sa tvrdenie zmenilo.
   **Pre OKF: to je dôvod pre `Pravda` / `Historie` a atomický zápis oboch.**
4. **Systém nemá bránu proti úniku do zdieľateľnej vrstvy.** `reference_*.md`
   sú zdieľateľné, ale nič nekontroluje, že v nich nezostal klientsky údaj.
   **Pre OKF: to je dôvod pre kontrolu L3_LEAK.**
5. **Pamäť je oddelená od spisu.** Leží v `~/.claude/`, nie pri dokumentoch.
   Advokát ju neotvorí a iný harness ju nenájde.
   **Pre OKF: pamäť patrí do priečinka spisu.**

Body 1–5 sú dôvodom, prečo zjednotenie nie je „vyber si jednu z dvoch
implementácií" — obe majú medzeru, ktorú tá druhá zapĺňa.

## Súvisiace

- [`sablony/`](sablony/) — šablóna záznamu a indexu
- [`priklady/`](priklady/) — vymyslené ukážky všetkých štyroch typov
- [`memory-manager.md`](memory-manager.md) — agent pre režimy SAVE / LOAD / LEARN / REVIEW / EVOLVE
- Implementácia zjednoteného jadra: [PR #24 vo forku](https://github.com/Omni-Legal-Products/lawoss/pull/24)
