# LAWOSS Basic Product Doctrine Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Premietnuť návrh základnej produktovej doktríny schválený MČ a čakajúci na potvrdenie tímom do rozhodnutí, vízie, princípov, verejného README, tímových otázok a pracovných šablón.

**Architecture:** Jeden nový ADR bude autoritatívnym záznamom rozhodnutia. Vízia a princípy budú stručné interpretačné vrstvy, README bude verejný vstup a šablóny zavedú opakovateľný produktový test. Otázka pre tím zostane označená ako otvorená, kým sa nevyjadria MF, IR a VŘ.

**Tech Stack:** Markdown, GitHub pull requests, existujúci Python generátor README, Telegram MCP

**Spec:** `docs/superpowers/specs/2026-08-12-lawoss-zakladna-produktova-doktrina-design.md`

## Global Constraints

- Nepoužiť em dash ani en dash v novom alebo zmenenom texte.
- Neuvádzať neoverené tvrdenia o konkrétnych konkurenčných produktoch ako fakty.
- Zachovať pozitívnu komunikáciu založenú na vlastnostiach LAWOSS.
- Kontrola používateľa, individualizácia, otvorenosť a agent-first architektúra sú jadrom návrhu.
- Právnik zostáva zodpovedným manažérom a supervízorom agentov.
- `CLAUDE.md` zostáva zrkadlom `AGENTS.md` a nesmie sa editovať samostatne.
- AUTO sekcie README sa upravujú iba cez `.github/scripts/update_readme.py`.
- Stagovať iba súbory uvedené v tomto pláne.

---

### Task 1: Autoritatívny ADR

**Files:**
- Create: `decisions/0009-zakladna-produktova-doktrina.md`
- Create: `decisions/0009-zakladna-produktova-doktrina.html`
- Reference: `decisions/template.md`
- Reference: `docs/superpowers/specs/2026-08-12-lawoss-zakladna-produktova-doktrina-design.md`

**Interfaces:**
- Consumes: schválený návrh MČ zo specu
- Produces: stabilný odkaz na rozhodnutie, jeho dôsledky a proces výnimiek

- [x] **Step 1: Prečítať šablónu ADR a schválený spec**

Run:

```bash
sed -n '1,220p' decisions/template.md
sed -n '1,240p' docs/superpowers/specs/2026-08-12-lawoss-zakladna-produktova-doktrina-design.md
```

Expected: štruktúra ADR a všetky záväzné formulácie sú dostupné pred písaním.

- [x] **Step 2: Vytvoriť ADR 0009 a jeho HTML dvojníka**

ADR musí obsahovať:

- stav `Navrhnuté MČ, čaká na potvrdenie MF, IR a VŘ`,
- kontext rizika uniformity a uzavretých black box riešení ako produktovú hypotézu,
- rozhodnutie o dvoch pilieroch,
- šesťbodový produktový test,
- pozitívne a negatívne dôsledky,
- alternatívy: uzavretý jednotný stack, nezáväzná vízia, otvorené modulárne jadro,
- pravidlo, že výnimka potrebuje nový ADR s odôvodnením, mitigáciou a časovým obmedzením,
- vetu `Your law. Your models. Your knowledge. Your agents.`

- [x] **Step 3: Overiť úplnosť ADR a HTML dvojníka**

Run:

```bash
rg -n "kontrol|individual|agent|black box|výnim|alternat|Your law" decisions/0009-zakladna-produktova-doktrina.md
rg -n '\x{2014}|\x{2013}|T[B]D|T[O]DO' decisions/0009-zakladna-produktova-doktrina.md
rg -n '<!doctype html>|@media|prefers-color-scheme|#0d1b2a|#c9a24a' decisions/0009-zakladna-produktova-doktrina.html
```

Expected: prvý príkaz nájde všetky jadrové témy, druhý nevráti nič.

- [x] **Step 4: Commitnúť ADR**

```bash
git add decisions/0009-zakladna-produktova-doktrina.md decisions/0009-zakladna-produktova-doktrina.html
git commit -m "decisions: navrhnúť produktovú doktrínu LAWOSS"
```

### Task 2: Vízia a princípy

**Files:**
- Modify: `docs/vision.md`
- Modify: `docs/principles.md`

**Interfaces:**
- Consumes: `decisions/0009-zakladna-produktova-doktrina.md`
- Produces: zrozumiteľný interný a verejný výklad doktríny

- [x] **Step 1: Prepísať zastaraný úvod vízie**

V `docs/vision.md` odstrániť tvrdenie, že voľba základu je otvorená. Uviesť LegalWork ako zvolený MIT základ a odkázať na ADR 0003.

- [x] **Step 2: Doplniť jadro vízie**

Úvod musí jasne povedať:

```markdown
LAWOSS dáva právnikom úplnú kontrolu nad ich AI.
```

Nasledujúce sekcie vysvetlia dva piliere, rozsah používateľovej kontroly, agent-first pracovné prostredie a právnika ako supervízora.

- [x] **Step 3: Rozšíriť princípy**

`docs/principles.md` musí obsahovať najmenej:

1. otvorené a upraviteľné jadro,
2. výber modelu podľa úlohy,
3. prenositeľné skilly, MCP a workflowy,
4. kontrolu dát a pamäte,
5. audit a provenance,
6. agent-first architektúru s human approval,
7. zákaz povinného vendor lock-in,
8. platformovú špecializáciu bez nútenej parity,
9. overovanie tvrdení o konkurencii,
10. výnimky iba cez ADR.

- [x] **Step 4: Overiť súlad oboch dokumentov**

Run:

```bash
rg -n "úplnú kontrolu|model|skill|MCP|agent|supervízor|black box" docs/vision.md docs/principles.md
rg -n '\x{2014}|\x{2013}|T[B]D|T[O]DO' docs/vision.md docs/principles.md
```

Expected: jadrové pojmy sú prítomné a zakázané alebo nedokončené formulácie chýbajú.

- [x] **Step 5: Commitnúť víziu a princípy**

```bash
git add docs/vision.md docs/principles.md
git commit -m "docs: ukotviť víziu kontroly nad AI"
```

### Task 3: Záväzná otázka pre tím

**Files:**
- Modify: `planning/2026-08-12-rozhodovacie-otazky-timu.md`

**Interfaces:**
- Consumes: návrh rozhodnutia z ADR 0009
- Produces: jednoznačne identifikovateľnú otázku na vyjadrenie MF, IR a VŘ

- [x] **Step 1: Doplniť otázku Q24**

Znenie:

```markdown
### Q24: Prijímame základnú produktovú doktrínu LAWOSS?

Prijímame kontrolu používateľa, individualizáciu, otvorenosť a agent-first architektúru s právnikom ako supervízorom za záväznú produktovú doktrínu LAWOSS a za test všetkých budúcich významných rozhodnutí?

- **A:** áno, ako záväznú doktrínu; výnimka vyžaduje ADR s odôvodnením, mitigáciou a časovým obmedzením,
- **B:** áno, iba ako nezáväznú víziu,
- **C:** nie; uviesť, ktorý princíp alebo dôsledok tím odmieta.
- **Odporúčanie MČ:** A.
```

Doplniť odkaz na ADR 0009 a dizajnový spec.

- [x] **Step 2: Aktualizovať počet otázok a návod na odpoveď**

Všetky odkazy na rozsah `Q01 až Q23` zmeniť na `Q01 až Q24`.

- [x] **Step 3: Overiť číslovanie**

Run:

```bash
rg -n '^### Q[0-9]{2}:' planning/2026-08-12-rozhodovacie-otazky-timu.md
rg -n 'Q01 až Q23|\x{2014}|\x{2013}|T[B]D|T[O]DO' planning/2026-08-12-rozhodovacie-otazky-timu.md
```

Expected: otázky Q01 až Q24 sú unikátne a druhý príkaz nič nenájde.

- [x] **Step 4: Commitnúť tímovú otázku**

```bash
git add planning/2026-08-12-rozhodovacie-otazky-timu.md
git commit -m "planning: otvoriť otázku produktovej doktríny"
```

### Task 4: Verejný vstup a opakovateľný produktový test

**Files:**
- Modify: `README.md`
- Modify: `.github/PULL_REQUEST_TEMPLATE.md`
- Modify: `.github/ISSUE_TEMPLATE/feature-navrh.yml`
- Modify: `.github/scripts/update_readme.py` iba ak je nový text súčasťou AUTO sekcie

**Interfaces:**
- Consumes: víziu, princípy a ADR 0009
- Produces: stručnú verejnú tézu a kontrolu budúcich PR

- [x] **Step 1: Identifikovať bezpečné miesto v README**

Run:

```bash
rg -n '<!-- AUTO:|Vízia|Prečo|LAWOSS' README.md
```

Expected: je jasné, či sa text pridá mimo AUTO sekcie alebo cez generátor.

- [x] **Step 2: Doplniť verejnú formuláciu**

README má obsahovať túto nosnú vetu a slogan:

```markdown
LAWOSS dáva právnikom úplnú kontrolu nad ich AI.

**Your law. Your models. Your knowledge. Your agents.**
```

Krátky sprievodný text má vysvetliť výber modelov, vlastné skilly a MCP, otvorené pracovné postupy a právnika ako supervízora.

- [x] **Step 3: Doplniť kontrolný checklist aj do šablóny návrhu funkcie**

Do `.github/PULL_REQUEST_TEMPLATE.md` pridať sekciu `Produktová doktrína` s checkboxmi a do `.github/ISSUE_TEMPLATE/feature-navrh.yml` polia pre kontrolu používateľa, otvorenosť, riadenie agentov a prípadnú ADR výnimku:

- zmena zachováva alebo zvyšuje kontrolu používateľa,
- nevytvára povinný black box alebo vendor lock-in,
- zachováva audit a primerané human approval,
- platformovú alebo dočasnú výnimku odôvodňuje príslušný ADR.

- [x] **Step 4: Pregenerovať README a skontrolovať diff**

Run:

```bash
python3 .github/scripts/update_readme.py
git diff --check
ruby -e 'require "yaml"; YAML.load_file(".github/ISSUE_TEMPLATE/feature-navrh.yml"); puts "YAML OK"'
rg -n '\x{2014}|\x{2013}|T[B]D|T[O]DO' README.md .github/PULL_REQUEST_TEMPLATE.md .github/ISSUE_TEMPLATE/feature-navrh.yml
```

Expected: generovanie prejde, diff nemá whitespace chyby a posledný príkaz nič nenájde v nových riadkoch.

- [x] **Step 5: Commitnúť verejný vstup a checklist**

```bash
git add README.md .github/PULL_REQUEST_TEMPLATE.md .github/ISSUE_TEMPLATE/feature-navrh.yml .github/scripts/update_readme.py
git commit -m "docs: preniesť doktrínu do verejného vstupu"
```

Ak `.github/scripts/update_readme.py` nebol zmenený, nestagovať ho.

### Task 5: Finálna verifikácia a tímová distribúcia

**Files:**
- Verify: všetky súbory z Tasks 1 až 4 vrátane `decisions/0009-zakladna-produktova-doktrina.html` a `.github/ISSUE_TEMPLATE/feature-navrh.yml`

**Interfaces:**
- Consumes: kompletnú dokumentačnú zmenu
- Produces: pripravený PR a tímovú výzvu na rozhodnutie Q24

- [ ] **Step 1: Skontrolovať rozsah a čistotu**

Run:

```bash
git status --short
git diff --check origin/main...HEAD
git diff --stat origin/main...HEAD
git log --oneline origin/main..HEAD
```

Expected: iba plánované súbory a malé tematické commity.

- [ ] **Step 2: Overiť pokrytie specu**

Run:

```bash
rg -n "Your law|úplnú kontrolu|agent-first|supervízor|vendor lock-in|Q24" decisions/0009-zakladna-produktova-doktrina.md docs/vision.md docs/principles.md README.md planning/2026-08-12-rozhodovacie-otazky-timu.md .github/PULL_REQUEST_TEMPLATE.md
```

Expected: doktrína, slogan, tímová otázka a produktový test sú dohľadateľné v príslušných dokumentoch.

- [ ] **Step 3: Pushnúť vetvu a otvoriť ready PR**

```bash
git pull --no-rebase
git push -u origin codex/core-doctrine-design
gh pr create --base main --head codex/core-doctrine-design --title "docs: ukotviť základnú produktovú doktrínu" --body-file <pr-body-file>
```

PR popis musí uviesť, že MČ znenie schválil a MF, IR a VŘ sa majú vyjadriť k Q24.

- [ ] **Step 4: Poslať tímovú výzvu na Telegram**

Do chatu `LawOSS (SLOVAKIA | CZECHIA) + AI Frontier Labs` poslať:

```text
Chalani, doplnili sme zásadnú otázku Q24 o dôvode existencie LAWOSS. Prosím, prejdite si ju cez svojho AI agenta spolu s ADR 0009 a vyjadrite sa možnosťou A, B alebo C s krátkym dôvodom. Ide o záväzný test budúcich features a partnerstiev, nie iba o marketingový slogan.
```

Pridať priamy odkaz na nový PR. Po odoslaní prečítať posledné správy a overiť doručenie.
