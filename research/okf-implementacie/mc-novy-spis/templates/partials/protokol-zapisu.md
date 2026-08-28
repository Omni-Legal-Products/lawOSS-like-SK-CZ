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
