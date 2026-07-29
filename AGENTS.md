# AGENTS.md — ako pracovať v tomto repozitári

> **Single source of truth pre ľudí aj AI agentov.** `CLAUDE.md` je symlink na tento súbor — needituj ho zvlášť.
> Ak si AI agent a práve si načítal toto repo: **prečítaj celý tento súbor pred prvou zmenou.**

---

## 🎯 O projekte v 30 sekundách

Traja slovenskí advokáti (**Marián Čuprík**, **Martin Friedrich**, **Igor Ribár** — SAK, pracovná skupina pre elektronizáciu advokácie) staviajú **open-source AI nástroj pre slovenských advokátov, zadarmo**.

| | |
|---|---|
| **Toto repo** | prípravné a plánovacie — **neobsahuje kód** produktu. Brainstorming, rešerše, rozhodnutia, plánovanie. |
| **Monetizácia** | výhradne **školenia a workshopy**. Nepredávame softvér ani službu (SaaS) — to by z advokáta spravilo poskytovateľa. Viď [ADR 0002](decisions/0002-preco-forkujeme-mikeoss.md). |
| **Voľba základu** | ⚠️ **otvorená** — mikeOSS / Stella / LegalWork. Viď [research/inspiracie/](research/inspiracie/). Nepíš nikde, že je to rozhodnuté. |
| **Názov** | „MikeOSS Slovakia" je **pracovný**, nie finálny. |

**Začni čítaním:** [`decisions/`](decisions/) (čo je rozhodnuté a prečo) → [`specs/`](specs/) (čo staviame) → [`planning/roadmap.md`](planning/roadmap.md) (kde sme).

---

## 🚦 Zlaté pravidlá — toto nikdy

| ❌ Nikdy | Prečo |
|---|---|
| **Needituj AUTO sekcie v `README.md`** (medzi `<!-- AUTO:X -->`) | generuje ich GitHub Action, tvoje zmeny sa prepíšu |
| **Nerob `git push --force` ani prepis histórie** | pracujú tu traja, zmažeš cudziu prácu — **`main` to aj technicky blokuje** |
| **Neprepisuj cudzie autorstvo** návrhov a rozhodnutí | evidencia v [`specs/navrhy.md`](specs/navrhy.md) musí sedieť |
| **Nemeň cudzí ADR** — namiesto toho pridaj nový, ktorý ten starý nahrádza | rozhodnutia sú záznam v čase |
| **Nepíš fakty „z hlavy"** — over ich (GitHub API, web, MCP) a označ, čo je overené a čo dohad | staviame na tom právne rozhodnutia |
| **Nedávaj do gitu veľké médiá** (audio, video) | `.gitignore` ich blokuje; použi GitHub Release |
| **Nedávaj sem klientske dáta ani tajomstvá** | repo je **verejné** |

---

## 🔀 Git a spolupráca — ako sa neprebíjať

> **Toto je najdôležitejšia sekcia.** Repo je verejné, `main` nie je chránený, a **beží nad ním bot**, ktorý sám commituje.

### ⚠️ Pozor: auto-README bot commituje do `main`

Po každom pushi sa spustí Action, ktorá prepíše AUTO sekcie v `README.md` a **spraví vlastný commit**. Dôsledok: **remote sa ti pohne pod rukami** a tvoj ďalší push bude odmietnutý (`rejected — fetch first`).

**Preto vždy:**

```bash
git pull --no-rebase          # PRED každým pushom, aj keď si si istý
# ... práca ...
git add <konkrétne súbory>    # nie `git add -A` naslepo
git commit -m "..."
git pull --no-rebase          # ešte raz, bot mohol medzitým pushnúť
git push
```

Ak push aj tak zlyhá → `git pull --no-rebase` a push znova. **Nikdy to nerieš force-pushom.**

### 🔒 Ochrana vetvy `main`

Na `main` je zapnutá ochrana *(platí aj pre adminov)*:

| | |
|---|---|
| ❌ **force-push** | zablokovaný |
| ❌ **zmazanie vetvy** | zablokované |
| ✅ **bežný push** | funguje normálne — **žiadny povinný PR review**, aby vás to nezdržovalo |

Ak ti git odmietne push, **nikdy to nerieš `--force`** (aj tak neprejde) — urob `git pull --no-rebase` a push znova.

### Kedy priamo do `main` a kedy branch + PR

| Typ zmeny | Postup |
|---|---|
| Drobnosť — preklep, doplnenie riadku do backlogu, oprava odkazu | priamo do `main` (s pull pred/po) |
| **Nový spec, nový ADR, zmena štruktúry, väčší prepis** | **branch + Pull Request** — nech to ostatní dvaja vidia skôr, než to je v `main` |
| Čokoľvek, čo mení už **schválené** rozhodnutie | **vždy PR** + rozprava v Telegrame |

```bash
git checkout -b spec/nazov-veci
# ... práca, commity ...
git push -u origin spec/nazov-veci
gh pr create --fill
```

### Aby ste si nešliapali po nohách

- **Ohlás sa v Telegrame** (topic *General CHAT*), keď ideš robiť väčšiu zmenu — „idem prepisovať specs/0002".
- **Malé, časté commity** > jeden veľký. Ľahšie sa mergujú.
- **Jeden súbor = jeden autor v jednom čase.** Markdown sa merguje zle, keď dvaja prepisujú tú istú sekciu.
- **Commit správa po slovensky**, formát `typ: čo` — `docs:`, `research:`, `specs:`, `feat:`, `fix:`, `chore:`.

### Riešenie konfliktu

Konflikt v markdowne rieš **ručne a obe strany zachovaj** (nie „moja verzia vyhráva"). Ak si nie si istý, čí text je aktuálnejší — **spýtaj sa v Telegrame**, neháp.

---

## 📁 Kam čo patrí

```
decisions/    ADR — rozhodnutia: čo, prečo, aké alternatívy sme zvážili
specs/        špecifikácie funkcií (+ navrhy.md = evidencia, kto čo navrhol)
research/     rešerše — deep-research/, inspiracie/, idey/, sk-datove-zdroje/…
planning/     roadmap, timeline, backlog, workshopy (checkboxy → progress v README)
meetings/     zápisky zo stretnutí, RRRR-MM-DD.md, na konci VŽDY akčné body
docs/         vízia, princípy, glosár, návody
assets/       obrázky, diagramy, brand
```

**Pravidlá pre obsah:**

1. **Rozhodnutie** → ADR do `decisions/` podľa [`template.md`](decisions/template.md). Vždy uveď **zvažované alternatívy a prečo NIE**.
2. **Návrh funkcie** → spec do `specs/` **+ riadok do [`specs/navrhy.md`](specs/navrhy.md)**.
   Hlavička specu musí obsahovať `- **Navrhol:** <Meno> (<skratka>) · <dátum>`.
   Skratky: **MČ** = Marián Čuprík · **MF** = Martin Friedrich · **IR** = Igor Ribár.
   *Autorstvo nevymýšľaj — ak nevieš, kto návrh podal, spýtaj sa.*
3. **Úloha** → checkbox `- [ ]` v `planning/`. README z nich sám počíta progress.
4. **Rešerš** → `research/<oblasť>/`. Uveď **dátum a spôsob overenia**.

---

## ✍️ Ako písať

- **Po slovensky.** Technické termíny môžu ostať anglicky (*fork, commit, prompt, MCP*).
- **Oddeľuj overené od dohadov.** Píš „overené cez GitHub API 2026-07-29" vs „pravdepodobne, neoverené". Nikdy nevydávaj dohad za fakt.
- **Uvádzaj dátum** pri všetkom, čo starne (stav projektu, počty hviezd, aktivita repa).
- **Rich markdown je štandard** — tabuľky, mermaid diagramy, `> [!NOTE]` / `> [!WARNING]` bloky.
- **Dôležité dokumenty majú aj HTML dvojníka** (`.md` + `.html`), ktorý sa nasadí cez GitHub Pages. HTML musí byť **self-contained** (žiadne CDN), responzívne a s light/dark režimom. Farby značky: navy `#0d1b2a`, zlatá `#c9a24a`.

---

## 🤖 Automatizácie — nebojuj s nimi

| Čo | Kde | Správanie |
|---|---|---|
| **Auto-README** | [`.github/workflows/update-readme.yml`](.github/workflows/update-readme.yml) | po pushi prepíše AUTO sekcie (progress, strom, aktivita) a **sám commitne** |
| **Telegram notifikácie** | [`.github/workflows/telegram-notify.yml`](.github/workflows/telegram-notify.yml) | push/issue/PR/release → topic *SK Mike GH*. Secrets: `TELEGRAM_TOKEN`, `TELEGRAM_CHAT_ID`; premenná `TELEGRAM_TOPIC_ID` |
| **GitHub Pages** | z `main`, root, `.nojekyll` | HTML dokumenty sú živé na `originalmagneto.github.io/mikeOSS-SLOVAKIA/...` |

**Lokálne si vieš README pregenerovať:** `python3 .github/scripts/update_readme.py`

---

## ✅ Pred ukončením práce

- [ ] `git pull --no-rebase` a až potom push
- [ ] Nové rozhodnutie má ADR · nový návrh má spec **a riadok v `navrhy.md`**
- [ ] Fakty majú uvedený dátum a spôsob overenia
- [ ] Neoverené veci sú **označené ako neoverené**
- [ ] Žiadne klientske dáta ani tajomstvá (repo je verejné)
- [ ] Veľké médiá nie sú v gite (Release / `.gitignore`)
- [ ] Ak si menil HTML → over, že sa nasadil (Pages build) a neobsahuje poškodené znaky

---

## 🔗 Odkazy

- **Repo:** https://github.com/originalmagneto/mikeOSS-SLOVAKIA
- **Kandidáti na základ:** [mikeOSS](https://github.com/Open-Legal-Products/mike) · Stella (CZ) · [LegalWork](https://github.com/eigenweltlabs/legalwork)
- **Podať návrh funkcie:** [formulár](https://github.com/originalmagneto/mikeOSS-SLOVAKIA/issues/new?template=feature-navrh.yml)
- **Komunikácia:** Telegram *MikeOSS (SLOVAKIA) + AI Frontier Labs* — topics: General CHAT · SK Mike GH · DESIGN · Research · AI Frontier Labs
