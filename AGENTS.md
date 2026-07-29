# AGENTS.md — kontext pre agentické systémy

> Single source of truth. `CLAUDE.md` je len mirror (symlink) — editujte vždy tento súbor.

## O projekte

MikeOSS Slovakia je pripravovaný fork open-source projektu [MikeOSS](https://github.com/Open-Legal-Products/mike), špecializovaný pre slovenské právo. Toto repo je **prípravné a plánovacie** — neobsahuje kód forku.

- **Tím:** Marián Čuprík, Martin Friedrich, Igor Ribár — advokáti SAK, pracovná skupina pre elektronizáciu advokácie.
- **Cieľ:** open-source nástroj pre advokátov úplne zadarmo; monetizácia iba cez workshopy/školenia.
- **Kľúčový princíp forku:** slovenské úpravy ako pluginy/overlay mimo jadra, aby sa dali priebežne pull-ovať aktualizácie z upstreamu.

## Pravidlá pre agentov

1. Rozhodnutia zapisuj ako ADR do `decisions/` (použi `decisions/template.md`).
2. Rešerše patria do `research/<oblasť>/`, dozreté návrhy funkcií do `specs/`.
   **Každý spec musí mať v hlavičke `- **Navrhol:** <Meno> (<skratka>) · <dátum>`** a riadok v [`specs/navrhy.md`](specs/navrhy.md).
   Skratky: **MČ** = Marián Čuprík · **MF** = Martin Friedrich · **IR** = Igor Ribár.
   Autorstvo neprepisuj a nevymýšľaj — ak nevieš, kto návrh podal, spýtaj sa.
3. Úlohy a harmonogram sú v `planning/` — používaj markdown checkboxy (`- [ ]`), README z nich automaticky počíta progress.
4. Zápisky zo stretnutí: `meetings/RRRR-MM-DD.md`, na konci vždy akčné body.
5. Needituj AUTO sekcie v `README.md` (medzi `<!-- AUTO:X -->` markermi) — generuje ich GitHub Action.
6. Píš po slovensky; technické termíny môžu ostať v angličtine.

## Dôležité odkazy

- Upstream: https://github.com/Open-Legal-Products/mike
- Inšpirácia (fork/overlay prístup): https://github.com/stella/stella
