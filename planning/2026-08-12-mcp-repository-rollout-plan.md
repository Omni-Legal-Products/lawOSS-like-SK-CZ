# MCP Repository Rollout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to execute this plan task by task.

**Goal:** Pripraviť osobné MCP repozitáre MČ na bezpečnú agentickú spoluprácu a vytvoriť z nich súkromné tímové kópie v organizácii Omni Legal Products bez zmeny osobného vlastníctva alebo neplánovaného zásahu do Dokploy.

**Architecture:** Osobné repozitáre `originalmagneto/*` zostávajú zdrojom pravdy. Každý najprv prejde auditom, dostane repozitárovo špecifické `AGENTS.md` a identický `CLAUDE.md`, následne sa otestuje. Až potom vznikne súkromný organizačný fork. Verejný `cz-agents-mcp` dostane súkromný mirror s explicitným remote `upstream`. Dokploy zostáva počas rollout-u bez zmien.

**Tech Stack:** GitHub CLI `gh`, Git, npm, TypeScript, Vitest alebo Node test runner podľa repozitára, GitHub REST API, existujúce Docker a Dokploy konfigurácie.

## Global Constraints

- Nespracovať `HITL-Forms-MCP` ani `SOI-MCP`.
- Nemať dva nezávislé zdroje pravdy. Funkčné zmeny patria najprv do osobného upstreamu.
- Nevytvárať organizačnú kópiu, kým repozitár neprejde implementačnou bránou z [ADR 0008](../decisions/0008-sprava-mcp-repozitarov.md).
- Nikdy necommitovať `.env`, tokeny, Dokploy secrets, produkčné URL s credentialmi ani klientske dáta.
- Nemeniť MCP tool names ani vstupné a výstupné schémy v tomto rollout-e.
- Nedeployovať, nereštartovať ani neupravovať Dokploy služby. Dokploy sa v tomto pláne iba číta a porovnáva.
- V každom osobnom MCP repozitári pracovať na krátkej vetve `codex/agent-rules`, vytvoriť samostatný PR a mergovať až po úspešnej kontrole.
- `AGENTS.md` a `CLAUDE.md` musia mať po každej zmene rovnaký SHA-256 hash.
- Pred každým pushom overiť `git status`, aby sa nepribalili lokálne alebo citlivé súbory.

## Overený rozsah k 2026-08-12

| Upstream | Organizačný názov | Jurisdikcia | Lokálna verifikácia |
|---|---|---|---|
| `kalkulacky-sk-MCP` | `mcp-kalkulacky-sk` | `slovakia` | `npm run check && npm test && npm run build` |
| `judikaty-mcp` | `mcp-judikaty-sk` | `slovakia` | `npm run check && npm test && npm run build` |
| `slov-lex-mcp-deploy` | `mcp-slovlex` | `slovakia` | `npm test && npm run build` |
| `orsr-mcp` | `mcp-orsr` | `slovakia` | `npm run typecheck && npm test && npm run build` |
| `RPO-MCP` | `mcp-rpo` | `slovakia` | `npm run typecheck && npm test && npm run build` |
| `RPVS-MCP` | `mcp-rpvs` | `slovakia` | `npm run typecheck && npm test && npm run build` |
| `RUZ-MCP` | `mcp-ruz` | `slovakia` | `npm run typecheck && npm test && npm run build` |
| `crz-mcp` | `mcp-crz` | `slovakia` | `npm test && npm run build` |
| `FS-MCP` | `mcp-financna-sprava` | `slovakia` | `npm run typecheck && npm test && npm run build` |
| `OV-MCP` | `mcp-obchodny-vestnik` | `slovakia` | `npm run typecheck && npm test && npm run build` |
| `RU-MCP` | `mcp-register-upadcov` | `slovakia` | `npm run typecheck && npm test && npm run build` |
| `UVO-MCP` | `mcp-uvo` | `slovakia` | `npm run typecheck && npm test && npm run build` |
| `DISQ-MCP` | `mcp-diskvalifikacie` | `slovakia` | `npm run typecheck && npm test && npm run build` |
| `MCP-EURLEX-CELEX` | `mcp-eurlex` | `eu-law` | `npm run typecheck && npm test && npm run build` |
| `cz-agents-mcp` | `mcp-cz-agents` | `czechia` | `npm run lint && npm test && npm run build` |

Všetky upstreamy majú default vetvu `main`. Prvých 14 je private. `cz-agents-mcp` je public fork s licenciou MIT, preto sa nebude vytvárať ako GitHub fork, ale ako private mirror.

---

## Task 1: Vytvoriť auditný záznam a implementačný checklist

**Files:**

- Create: `planning/mcp-repository-inventory.md`
- Reference: `decisions/0008-sprava-mcp-repozitarov.md`

- [ ] **Step 1: Zapísať pre každý upstream aktuálny commit a GitHub metadáta**

Použiť iba read-only volania:

```bash
gh api repos/originalmagneto/REPO
gh api repos/originalmagneto/REPO/commits/main --jq '.sha'
```

Do inventára zapísať: upstream, commit, visibility, fork status, licencia, popis, topics, default branch, Dokploy názov projektu, plánovaný organizačný názov a stav implementačnej brány.

- [ ] **Step 2: Overiť Dokploy source bez mutácie**

Pre každé zodpovedajúce nasadenie načítať source type a dostupné repository metadata. Ak API nevráti presný repository URL alebo commit, označiť stav `neoverené`, nie `zhodné`.

- [ ] **Step 3: Skontrolovať aktuálny strom na zjavné secrets**

Po lokálnom clone použiť minimálne:

```bash
git ls-files | rg '(^|/)(\.env|id_rsa|.*\.pem|.*\.key)$'
rg -n --hidden --glob '!node_modules/**' --glob '!package-lock.json' '(BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|ghp_[A-Za-z0-9]+|sk-[A-Za-z0-9]{20,}|TELEGRAM_TOKEN=|MCP_AUTH_TOKEN=)'
```

Nálezy nezapisovať do inventára v plnom znení. Zapísať iba súbor, typ rizika a výsledok odstránenia alebo blokátor.

- [ ] **Step 4: Commitnúť inventár**

```bash
git add planning/mcp-repository-inventory.md
git commit -m "planning: pridať inventár MCP repozitárov"
```

---

## Task 2: Pripraviť jednotné jadro agentových pravidiel

**Files:**

- Create: `docs/templates/mcp-repository-AGENTS.md`
- Modify: `planning/mcp-repository-inventory.md`

- [ ] **Step 1: Vytvoriť šablónu spoločného jadra**

Šablóna musí obsahovať:

1. účel konkrétneho MCP a jurisdikciu,
2. hranice zdroja dát a upozornenie na externé API alebo scraping,
3. presné `npm ci`, typecheck, test a build príkazy,
4. pravidlo, že live testy sa spúšťajú iba na výslovný pokyn a nesmú meniť externé dáta,
5. zákaz secrets, klientskych dát a produkčných deployment zásahov,
6. spätnú kompatibilitu MCP tool names a schém,
7. oddelenie technickej validácie od právnej a doménovej správnosti,
8. workflow osobný upstream, organizačný fork, LAWOSS integrácia,
9. pravidlo byte-for-byte zhody `AGENTS.md` a `CLAUDE.md`,
10. checklist pred ukončením práce.

- [ ] **Step 2: Nevkladať neoverené univerzálne príkazy**

Šablóna má vyznačiť sekciu `Repository-specific commands`, ale výsledný súbor v každom MCP musí obsahovať konkrétne príkazy z jeho `package.json`. Nepoužívať fiktívny `npm run lint`, ak ho repo nemá.

- [ ] **Step 3: Commitnúť šablónu**

```bash
git add docs/templates/mcp-repository-AGENTS.md planning/mcp-repository-inventory.md
git commit -m "docs: pridať šablónu pravidiel pre MCP repozitáre"
```

---

## Task 3: Opraviť a overiť Slov-Lex upstream ako pilot

**Repository:** `originalmagneto/slov-lex-mcp-deploy`

**Files:**

- Create: `AGENTS.md`
- Create: `CLAUDE.md`
- Verify: `README.md`, `package.json`, `src/**`, `docker-compose.dokploy.yml`
- GitHub metadata: description

- [ ] **Step 1: Overiť identitu repozitára**

README, package name `slov-lex_mcp`, tool names a zdrojové moduly musia potvrdzovať Slov-Lex. Vyhľadať neočakávané zvyšky ORSR:

```bash
rg -n -i 'orsr|obchodn.y register' README.md package.json src docs Dockerfile docker-compose.dokploy.yml
```

Ak ide iba o chybný GitHub description, pokračovať. Ak ORSR zasahuje do runtime kódu alebo deployment konfigurácie, zastaviť pilot a zapísať blokátor.

- [ ] **Step 2: Opraviť GitHub description**

```bash
gh repo edit originalmagneto/slov-lex-mcp-deploy \
  --description "MCP server pre Slov-Lex a slovenské právne predpisy"
```

- [ ] **Step 3: Pridať repozitárovo špecifické pravidlá**

Uviesť presné príkazy:

```bash
npm ci
npm test
npm run build
```

Live smoke `npm run smoke` oddeliť od povinných lokálnych testov a označiť ako sieťový test, ktorý sa smie spustiť až po výslovnom pokyne.

- [ ] **Step 4: Vytvoriť identický mirror**

```bash
cp AGENTS.md CLAUDE.md
shasum -a 256 AGENTS.md CLAUDE.md
```

Očakávanie: oba riadky majú rovnaký hash.

- [ ] **Step 5: Overiť pilot**

```bash
npm ci
npm test
npm run build
git diff --check
git status --short
```

- [ ] **Step 6: Vytvoriť PR do osobného upstreamu**

```bash
git add AGENTS.md CLAUDE.md
git commit -m "docs: pridať pravidlá pre AI agentov"
git push -u origin codex/agent-rules
gh pr create --repo originalmagneto/slov-lex-mcp-deploy --fill
```

Merge až po kontrole, že PR neobsahuje runtime alebo deployment zmeny.

---

## Task 4: Rollout agentových pravidiel do ostatných slovenských MCP

**Repositories:** `kalkulacky-sk-MCP`, `judikaty-mcp`, `orsr-mcp`, `RPO-MCP`, `RPVS-MCP`, `RUZ-MCP`, `crz-mcp`, `FS-MCP`, `OV-MCP`, `RU-MCP`, `UVO-MCP`, `DISQ-MCP`

**Files in each repository:**

- Create or Modify: `AGENTS.md`
- Create or Modify: `CLAUDE.md`
- Verify: `package.json`, `README.md` or `DEPLOYMENT.md`, Docker configuration

- [ ] **Step 1: Spracovať každý repo samostatne**

Pre každý repo vytvoriť čistý clone a vetvu `codex/agent-rules`. Nekopírovať pracovný strom medzi repozitármi.

- [ ] **Step 2: Zachovať existujúce špecifiká**

V `OV-MCP`, `RU-MCP` a `UVO-MCP` existujúce pravidlá doplniť, nie zahodiť. Pred zmenou potvrdiť, že existujúce `AGENTS.md` a `CLAUDE.md` sú zhodné. V ostatných repozitároch vytvoriť oba súbory.

- [ ] **Step 3: Zapísať presné povinné príkazy**

Použiť tabuľku v sekcii Overený rozsah. Live príkazy ako `test:live`, `test:mcp-live`, `test:tools` a HTTP smoke testy nepatria do povinného offline minima. Zdokumentovať ich oddelene aj s požiadavkou na výslovný pokyn.

- [ ] **Step 4: Overiť každý repo**

Pre každý repo:

```bash
npm ci
# spustiť presnú verifikáciu z tabuľky
shasum -a 256 AGENTS.md CLAUDE.md
git diff --check
git status --short
```

Ak test zlyhá už na čistom `main`, zapísať baseline zlyhanie a neforkovať repo, kým sa neopraví alebo tím výslovne neschváli dokumentovaný blokátor.

- [ ] **Step 5: Jeden PR na jeden upstream**

Každý PR má obsahovať iba `AGENTS.md` a `CLAUDE.md`, prípadne malú opravu dokumentácie, ktorá je nevyhnutná pre pravdivé príkazy. Žiadne hromadné runtime refaktory.

Commit message:

```text
docs: pridať pravidlá pre AI agentov
```

---

## Task 5: Pripraviť EUR-Lex a CZ Agents

### 5A: `originalmagneto/MCP-EURLEX-CELEX`

**Files:** `AGENTS.md`, `CLAUDE.md`

- [ ] Pridať jurisdikciu `eu-law`, CELEX špecifiká a presné príkazy `npm run typecheck && npm test && npm run build`.
- [ ] Oddeliť `test:live` a `test:tools` od offline minima.
- [ ] Overiť hash oboch pravidiel, testy, build a vytvoriť samostatný PR.

### 5B: `originalmagneto/cz-agents-mcp`

**Files:** `AGENTS.md`, `CLAUDE.md`

- [ ] Overiť upstream a licenčnú väzbu existujúceho verejného forku.
- [ ] Zdokumentovať npm workspaces a povinné `npm run lint && npm test && npm run build`.
- [ ] Zachovať existujúce repo pravidlá z `.claude/`; nevydávať ich automaticky za root pravidlá bez kontroly.
- [ ] Pridať informáciu, že organizačná kópia bude mirror, nie GitHub fork.
- [ ] Overiť hash, testy, build a vytvoriť samostatný PR.

---

## Task 6: Vytvoriť súkromné organizačné forky

**GitHub organization:** `Omni-Legal-Products`

**Repositories:** prvých 14 položiek z tabuľky, bez `cz-agents-mcp`

- [ ] **Step 1: Overiť implementačnú bránu tesne pred forkom**

Pre každý upstream potvrdiť v inventári:

- agentové pravidlá sú na `main`,
- oba súbory majú identický blob SHA,
- posledná verifikácia prešla,
- secret scan nemá nevyriešený nález,
- Slov-Lex má opravený description,
- Dokploy väzba je overená alebo výslovne označená ako neoverená.

- [ ] **Step 2: Povoliť private forking iba ak je to potrebné**

Najprv skúsiť fork cez API. Ak organizácia alebo osobný účet private fork nepovolí, meniť `allow_forking` iba pre konkrétny upstream a iba na čas operácie. Nezverejňovať repo.

- [ ] **Step 3: Vytvoriť fork a premenovať ho**

Príklad pre Slov-Lex:

```bash
gh api --method POST repos/originalmagneto/slov-lex-mcp-deploy/forks \
  -f organization=Omni-Legal-Products \
  -f name=mcp-slovlex \
  -f default_branch_only=true
```

Po vytvorení pollovať konkrétny cieľový repo, kým API nevráti `200`. Potom overiť:

```bash
gh api repos/Omni-Legal-Products/mcp-slovlex \
  --jq '{private, fork, parent: .parent.full_name, default_branch}'
```

Očakávanie: `private=true`, `fork=true`, správny `parent`, `default_branch=main`.

- [ ] **Step 4: Nastaviť description a topics**

Každý repo dostane `mcp-server`, `majo-mcp`, `lawoss`, `legaltech` a príslušnú jurisdikciu. Topics nastaviť jedným API requestom, aby nevznikol čiastočný stav:

```bash
gh api --method PUT repos/Omni-Legal-Products/mcp-slovlex/topics \
  -H 'Accept: application/vnd.github+json' \
  --input - <<< '{"names":["mcp-server","majo-mcp","lawoss","legaltech","slovakia"]}'
```

- [ ] **Step 5: Overiť ochranu a prístupy**

Nastaviť rovnaký praktický model ako pri `lawoss`: členovia s write prístupom pracujú cez PR, MČ ako admin môže merge vykonať sám. Force push a zmazanie `main` musia zostať zakázané. Nevyžadovať povinný externý review od MČ pre jeho vlastný merge.

- [ ] **Step 6: Zapísať výsledok do inventára**

Uviesť cieľový URL, parent väzbu, commit SHA, visibility, topics a dátum vytvorenia.

---

## Task 7: Vytvoriť private mirror CZ Agents

**Source:** `originalmagneto/cz-agents-mcp`

**Target:** `Omni-Legal-Products/mcp-cz-agents`

- [ ] **Step 1: Vytvoriť prázdny private repo**

```bash
gh repo create Omni-Legal-Products/mcp-cz-agents --private \
  --description "Private LAWOSS mirror of Majo's Czech MCP servers"
```

- [ ] **Step 2: Mirrorovať všetky vetvy a tagy**

Použiť samostatný dočasný bare clone mimo pracovných projektov:

```bash
git clone --mirror git@github.com:originalmagneto/cz-agents-mcp.git /private/tmp/mcp-cz-agents.git
git -C /private/tmp/mcp-cz-agents.git push --mirror git@github.com:Omni-Legal-Products/mcp-cz-agents.git
```

Pred `push --mirror` potvrdiť, že cieľ je presne nový prázdny repo `Omni-Legal-Products/mcp-cz-agents`. Nikdy nepoužiť mirror push na osobný upstream.

- [ ] **Step 3: Zdokumentovať väzbu na upstream**

V organizačnom README pridať krátku sekciu `Upstream and synchronization`, ktorá uvedie `originalmagneto/cz-agents-mcp` ako zdroj pravdy a presný sync postup. Táto organizačná odchýlka sa nesmie spätne poslať upstreamu, ak ide iba o organizačné metadata.

- [ ] **Step 4: Nastaviť topics a ochranu**

Topics: `mcp-server`, `majo-mcp`, `lawoss`, `legaltech`, `czechia`. Použiť rovnakú ochranu `main` a prístupy ako pri ostatných organizačných MCP.

- [ ] **Step 5: Overiť mirror**

Porovnať `main` commit a tagy:

```bash
gh api repos/originalmagneto/cz-agents-mcp/commits/main --jq .sha
gh api repos/Omni-Legal-Products/mcp-cz-agents/commits/main --jq .sha
git -C /private/tmp/mcp-cz-agents.git show-ref --tags
```

---

## Task 8: Nastaviť udržateľnú synchronizáciu bez autonómneho deployu

**Files:**

- Create: `docs/mcp-repository-workflow.md`
- Modify: `planning/mcp-repository-inventory.md`

- [ ] **Step 1: Zdokumentovať upstream-first workflow**

Dokument má vysvetliť ne-developerovi:

1. agent otvorí osobný upstream,
2. vytvorí krátku branch a PR,
3. spustí offline testy,
4. MČ alebo tím PR mergne,
5. organizačný fork sa synchronizuje,
6. až označený commit alebo tag môže byť kandidát na Dokploy alebo LAWOSS.

- [ ] **Step 2: Zdokumentovať sync fork-u**

Preferovať GitHub synchronizáciu fork-u alebo fast-forward z osobného upstreamu. Zakázať automatický force push. Pri divergencii zastaviť a vyriešiť zmenu cez PR späť do osobného upstreamu.

- [ ] **Step 3: Zdokumentovať sync mirror-u**

Pre `mcp-cz-agents` použiť explicitné remotes:

```bash
git remote -v
git fetch upstream --prune --tags
git push origin refs/remotes/upstream/main:refs/heads/main
git push origin --tags
```

Nepoužiť plánovaný cron alebo GitHub Action, kým tím nerozhodne, kto zodpovedá za riešenie konfliktov a audit zmien.

- [ ] **Step 4: Commitnúť dokumentáciu**

```bash
git add docs/mcp-repository-workflow.md planning/mcp-repository-inventory.md
git commit -m "docs: popísať workflow osobných a tímových MCP"
```

---

## Task 9: Finálna akceptácia

- [ ] **Step 1: Skontrolovať všetkých 15 cieľov cez GitHub API**

Pre každý organizačný repo overiť:

- private visibility,
- správny názov a description,
- päť povinných topics,
- správny default branch,
- `AGENTS.md` a `CLAUDE.md` na `main`,
- zhodný obsah pravidiel,
- branch protection bez force push a deletion,
- pri forkoch správny parent, pri CZ Agents zdokumentovaný upstream.

- [ ] **Step 2: Potvrdiť nulový zásah do Dokploy**

Porovnať stav Dokploy pred a po rollout-e. Nesmie vzniknúť deployment, restart ani zmena environmentu. Ak sa stav zmenil mimo tohto rollout-u, označiť ho ako externú zmenu a neprivlastniť si ju.

- [ ] **Step 3: Aktualizovať inventár a roadmap**

**Files:**

- Modify: `planning/mcp-repository-inventory.md`
- Modify: `planning/roadmap.md`

Zaznamenať pre každý repo `hotovo`, `blokované` alebo `odložené` aj s dôvodom. Pridať ďalšiu samostatnú úlohu pre výber spoločného MCP základu v LAWOSS. Tento rollout nemá implementovať MCP priamo do aplikácie.

- [ ] **Step 4: Spustiť kontrolu dokumentácie**

```bash
python3 .github/scripts/update_readme.py
git diff --check
git status --short
```

Skontrolovať, že auto-README zmeny zodpovedajú novým planning checkboxom a že sa nepridal `assets/brand/logo sub 1M.png`.

- [ ] **Step 5: Vytvoriť finálny PR v prípravnom repozitári**

```bash
git add planning/mcp-repository-inventory.md planning/roadmap.md docs/mcp-repository-workflow.md docs/templates/mcp-repository-AGENTS.md README.md
git commit -m "planning: dokončiť MCP repository rollout"
git pull --no-rebase
git push
gh pr create --fill
```

## Definition of Done

Rollout je hotový iba vtedy, keď:

- všetkých 15 spracovaných osobných upstreamov má pravdivé a identické `AGENTS.md` a `CLAUDE.md`,
- povinné lokálne testy a buildy prešli alebo je konkrétny repo vedome zablokovaný a ešte nemá organizačnú kópiu,
- Slov-Lex description je opravený a obsahovo overený,
- 14 súkromných upstreamov má správne súkromné organizačné forky,
- CZ Agents má správny súkromný mirror,
- organizačné repozitáre majú požadované topics vrátane `majo-mcp`,
- osobné upstreamy zostávajú zdrojom pravdy,
- Dokploy nebol týmto rollout-om zmenený,
- inventár umožňuje spätne priradiť každý organizačný repo ku konkrétnemu upstreamu a commitu.
