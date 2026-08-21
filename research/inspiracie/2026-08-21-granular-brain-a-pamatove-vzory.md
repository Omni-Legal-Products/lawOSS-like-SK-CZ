# Rešerš: Granular Project Brain a pamäťové vzory pre OKF

- **Dátum:** 2026-08-21
- **Spôsob overenia:** priamo načítaná stránka [granular.build](https://granular.build) (plný obsah vrátane FAQ a marketplace) + web rešerš súvisiacich projektov. **Neoverené:** samotná aplikácia (closed-source, early access) — vychádza sa z produktových tvrdení na stránke.
- **Podnet:** MČ, [topic *Feature IDEAS*](https://t.me/c/3828145652/97), spomenuté aj na [callu 18. 8.](../../meetings/2026-08-18-zapis-sync-call.md) ako inšpirácia pre zjednotenie pamäťového názvoslovia (**Q10**)
- **Súvisí:** [spec 0002 OKF](../../specs/0002-okf-operacny-system-praxe.md) · [návrh #37](../../specs/navrhy.md) *(typované záznamy pamäti, VŘ)* · [spec 0011](../../specs/0011-rozsirujuca-vrstva-ui-a-konektory.md) *(timeline panel fáza 2)* · [#45](../..//planning/napady.md) *(samoúdržba)*

## Čo je Granular

[Granular](https://granular.build) — macOS aplikácia od Omara Farooka ([@buildwithomar](https://x.com/buildwithomar)), pozicionovaná ako *„the terminal for everybody"*: agentic OS pre netechnických používateľov (founders, marketeri, dizajnéri). Early access; Free má limitované počty projektov/sessions, Pro $20/mes., $192/rok alebo $399 lifetime.

Architektúra je nápadne blízka LegalWorku/LAWOSS:

| Prvok Granular | Náš ekvivalent |
|---|---|
| BYO agenti — Claude Code / Codex cez vlastné loginy, „never resold" | opencode harness + vlastné modely (spec 0003) |
| Boss agent + worker subagenti vo worktreeoch | orchestrátor a subagenti (#9, spec 0006) |
| Nástroje cez MCP, „pick how careful, fast, costly to run" | MCP konektory (spec 0004) + konfigurovateľná autonómia (Q21) |
| Lokálne súbory + git, „build it local, own it all" | Q16 plne lokálne, OKF markdown |
| Telegram bot (ping keď agent skončí / potrebuje schválenie) | telegram-notifikácie (už beží) |
| Vault na secrets — šifrované, injektované len pri použití | relevantné pre #45 bezpečnostný rámec |
| Marketplace: skills, brains, templates, MCP presets | connector registry (spec 0011 časť B) |

## 🧠 Project Brain — vzor hodný pozornosti

Každý projekt ukázaný na Granular dostane priečinok `brain/`:

1. **`BRAIN.md` ako „predné dvere"** — *„short on purpose — every note is reachable in a hop or two."* Krátky indexový súbor: Mission → Goals → Decisions → Roadmap → How We Work, všetko wiki-linkami. Agent ho číta **prvý** a od neho sa naviguje.
2. **„Living map", ktorú agenti udržiavajú** — brain nie je len čitateľný, agenti ho **aktívne aktualizujú** počas práce (roadmap karty sa posúvajú, keď agent shipuje).
3. **Decision Log skill** — append-only `PROJECT-LOG.md`: každý ask, rozhodnutie a ship zapísaný v momente vzniku.
4. **Roadmap board „that moves itself"** — každá karta je task, klik na kartu otvorí session; vizuálna boarda žije nad tým istým markdownom.

### ⚠️ Naša adaptácia: pred `BRAIN.md` musí byť `AGENTS.md` (+ mirror `CLAUDE.md`)

Granular predpokladá svoj harness. My potrebujeme **nezávislosť od harnessu** (Q10): ľubovoľný agent (opencode, Claude Code, Codex, Cursor…) po otvorení spisu musí vedieť, čo a v akom poradí čítať. Preto reťazec vstupných bodov:

```
spis/
├── AGENTS.md          ← univerzálny kontrakt (čítajú všetky harnessy)
├── CLAUDE.md          ← obsahový mirror (Claude Code ho hľadá pod týmto menom)
└── BRAIN.md           ← protokol pamäti: ako čítať/písať brain/
    (naň odkazuje AGENTS.md)
└── brain/
    ├── mission.md · goals.md · decisions/ · lehoty.md · changelog/
    └── …
```

Toto je zároveň náš existujúci repozitárový vzor (`AGENTS.md` ako single source of truth, `CLAUDE.md` symlink/mirror) a povinnosť z [ADR 0008](../../decisions/0008-sprava-mcp-repozitarov.md) pre MCP repozitáre. Rozšírenie do každého **spisu** je prirodzené.

## Bonusové nálezy — open štandardy pamäti

Web rešerš okolo Granular priniesol dva projekty priamo relevantné pre zjednotenie názvoslovia L1/L2/L3 (otvorená položka z callu 18. 8.):

### 1. [`BRAIN.md` štandard (mindmux/brain.md)](https://github.com/mindmuxai/brain.md) — ⭐ najsilnejší kandidát

Open, agent-agnostický štandard: `BRAIN.md` protokol + `brain/` pages, zápisy výhradne cez zero-dependency CLI (žiadny server, žiadny MCP daemon). Kľúčové vzory:

- **Typované pages**: `decision` / `concept` / `project` / `person` / `reference` — presne sedí na VŘ návrh [#37](../../specs/navrhy.md) (*„netypovaná pamäť po pár mesiacoch splynie v hromadu"*)
- **Split `compiled_truth` × `timeline`**: page nesie aktuálnu overenú pravdu + append-only históriu dôkazov, rozhodnutí a reversálov. Zmena pravdy bez trace-u je **štruktúrne nemožná** (atomický zápis oboch naraz). Rieši to auditovateľnosť, ktorú VŘ požadoval
- **Agent-agnostic**: skills pre Claude Code, Codex, Cursor, Pi aj **OpenCode** — priama podpora nášho harnessu
- Inšpirácia pre reconciliation (#34): `update-truth` vyžaduje summary *prečo sa to zmenilo*

### 2. [Brain OS](https://brainos-hq.com/) a [Brain Memory](https://brainmemory.ai/) — operacionálna pamäť

- `.brain/` priečinok so štrukturovaným stavom: rozhodnutia s **zamietnutými alternatívami**, blockers, plány
- **Conflict detection**: pri novom rozhodnutí systém nájde kolízie s predchádzajúcimi a povrchí ich s pôvodným odôvodnením — agent *namieta* namiesto yes-anding. Inšpirácia pre reconciliation a distribúciu poznatku (#40)
- Brain Memory: decay/spreading-activation model — **pozor**, to už je ťažší mechanizmus než potrebujeme; Q17 hovorí jasnie nie embeddingom a indexom

## Odporúčanie pre OKF pamäť

1. **Prebrať front-door vzor**: krátky indexový `BRAIN.md` per spis, za `AGENTS.md`/`CLAUDE.md`, „reachable in a hop or two"
2. **Zvážiť typovaný truth/timeline model** (mindmux vzor) ako odpoveď na zjednotenie L1/L2/L3 + #37 — je to plain markdown, žiadna runtime závislosť, kompatibilné s Q16/Q17
3. **Roadmap board UI** z Granular = potvrdenie vízie fázy 2 panel tabu „Lehoty" zo [spec 0011](../../specs/0011-rozsirujuca-vrstva-ui-a-konektory.md)
4. **Marketplace bezpečnostný princíp** Granularu (inštalácia kopíruje súbory, kód sa sám nespúšťa) zhodný s naším connector registry — potvrdenie smeru
5. ❌ Neberať: decay/embedding pamäťové mechanizmy (odporuje Q17), closed-source závislosti

---

<sub>Rešerš vypracoval AI agent pre MČ, 2026-08-21. Zdroj: granular.build (načítané priamo), github.com/mindmuxai/brain.md, brainos-hq.com, brainmemory.ai (web rešerš). Samotná Granular appka nebola testovaná — closed-source, early access.</sub>
