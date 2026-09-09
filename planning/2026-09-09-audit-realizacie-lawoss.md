# Audit podkladov pre realizáciu LAWOSS

Overené 9. 9. 2026. Dopĺňa [realizačný plán](2026-09-09-realizacia-lawoss-a-spolupraca-ai.md). Výsledky platia pre uvedené revízie a čas kontroly. Audit nepridelil úlohy, nezmenil kód aplikácie a nespustil vydanie.

## 1. Revízie a zdroje

| Zdroj | Revízia/stav | Spôsob |
|---|---|---|
| `Omni-Legal-Products/lawoss` | `dev` = `ec0f4c108e17c53152a01b327c57c1b59dfd69f2` | GitHub API, fetch, git show |
| `Omni-Legal-Products/lawOSS-like-SK-CZ` | `main` = `5aa993f48dd3b4a055fcaf6a67027e2b680c9c5b` | fetch, git log |
| `Omni-Legal-Products/lawoss-marketplace` | `main` = `d9631fb39ccc70055a0767a24d270b319baf774f`, public | GitHub API a manifesty |
| Oprava druhého zápisu v deň | `2c8db57` je predkom produktového `dev` | `git merge-base --is-ancestor 2c8db57 origin/dev`, exit 0 |
| Lokálny produktový checkout | iná vetva než `dev`, čistá pri kontrole | `git status`, `git branch --show-current` |

Koordinačný návrh bol uložený do samostatnej worktree a vetvy `docs/plan-realizacie-ai-2026-09-09` od `origin/main`. Pôvodné checkouty ostali nezmenené.

## 2. Dátový kontrakt: potvrdený integračný problém

Samostatný audit exportoval presnú revíziu produktu do dočasného priečinka a pracoval výhradne so syntetickými údajmi. Samostatné sady prešli: **`lawoss/okf` 14/14; `lawoss/okf-pamat` 415/415**. Celá používateľská cesta napriek tomu neprejde:

1. `okf apply spis` vytvorí štruktúru podľa aktuálnej šablóny.
2. `okf-memory init --apply` bez jurisdikcie v karte použije default `cz`.
3. `okf-memory sync --apply` skončí exit 1 na sekcii Lehoty bez potrebných markerov.
4. Starý `okf validate` hlási chybu pri `BRAIN.md`.
5. Spis vytvorený samotným pamäťovým nástrojom starý validátor tiež odmieta: `BRAIN.md`, `_STATUS.md` a `memory/index.md` nespĺňajú jeho očakávania.

To odôvodňuje W1/W2 a spoločný integračný test. Počet passing tests v oddelených balíkoch nie je dôkaz kompatibility. Čítačka musí vracať diagnostiku; neskryť nečitateľné záznamy ako nulový stav.

Potvrdené v kóde:

- [Zakladacia karta](https://github.com/Omni-Legal-Products/lawoss/blob/ec0f4c108e17c53152a01b327c57c1b59dfd69f2/lawoss/okf/templates/spis/spis.md) nemá `jurisdiction`, má natvrdo meno advokáta, `lehoty: []` a odkaz na `MEMORY.md`.
- [Pokyny vytvoreného spisu](https://github.com/Omni-Legal-Products/lawoss/blob/ec0f4c108e17c53152a01b327c57c1b59dfd69f2/lawoss/okf/templates/spis/AGENTS.md) prikazujú dvojitý zápis lehôt a používajú starú pamäťovú štruktúru.
- [Pamäťové verejné API](https://github.com/Omni-Legal-Products/lawoss/blob/ec0f4c108e17c53152a01b327c57c1b59dfd69f2/lawoss/okf-pamat/src/index.ts) už exportuje `readStore`, `readScope`, `validateStore`, `syncStatus` a ďalšie použiteľné funkcie.
- [Workspace konfigurácia](https://github.com/Omni-Legal-Products/lawoss/blob/ec0f4c108e17c53152a01b327c57c1b59dfd69f2/pnpm-workspace.yaml) zahŕňa `apps/*` a `packages/*`, nie `lawoss/*`. Samotná zmena tohto zoznamu ešte nedokazuje úspešné zabalenie servera.
- [Schema](https://github.com/Omni-Legal-Products/lawoss/blob/ec0f4c108e17c53152a01b327c57c1b59dfd69f2/lawoss/okf-pamat/src/schema.ts) stále obsahuje slovenské `EVENT_KINDS`; kompatibilita starých záznamov už musí byť súčasť zmeny.

## 3. UI a marketplace

`NovySpisPage` upsertuje skill a CLI resource, otvorí session a uloží prompt draft. Neoveruje výsledné vytvorenie spisu. Kontrola cesty `startsWith` je iba UI pomôcka; nie dostatočná serverová hranica prístupu.

`PrehladPage` a `LehotyPage` nemajú napojenie na pamäť; obsahujú pevné ukážkové údaje. Registry experimentov stále uvádza marketplace ako fiktívny návrh, hoci má reálne interakcie nad lokálnym katalógom. `onboarding-state.ts` persistuje iba `lane` a `step`. Úplnú obnovu konfigurácie tým nemožno vyhlásiť za hotovú.

`claude-plugin-bundle.ts` používa existujúci GitHub import a načítava plugin komponenty. Serverové `installCloudPlugin` je dostupné cez existujúci endpoint s kontrolami oprávnení. Integrácia sa má napojiť sem, nie duplikovať importér.

Aktuálny verejný marketplace má **15 balíkov, 14 so skillom, 0 s `mcpServers` alebo vlastným `.mcp.json` v kontrolovaných plugin manifestoch**. Setup dokumentácia výslovne rozlišuje inštaláciu skillu, zostavenie servera a vlastné nasadenie. [Manifest](https://github.com/Omni-Legal-Products/lawoss-marketplace/blob/d9631fb39ccc70055a0767a24d270b319baf774f/.claude-plugin/marketplace.json), [príklad setup návodu](https://github.com/Omni-Legal-Products/lawoss-marketplace/blob/d9631fb39ccc70055a0767a24d270b319baf774f/plugins/slovlex/docs/SETUP.md).

`releases.json` stále obsahuje `visibility: private`; živé GitHub API potvrdzuje public. Ide o drift metadát. Kontrola nerobila OAuth ani živé volania právnych registrov.

Upstream `reload-fingerprint.ts` sleduje config, agents, skills, commands, plugins a mcp. Tento mechanizmus sám neposkytuje aktuálny snapshot obsahu spisu.

## 4. CI a ochrana vetvy

Pre `ec0f4c1` GitHub Actions vykonal a úspešne dokončil:

- [LegalWork Tests — run 34130210022](https://github.com/Omni-Legal-Products/lawoss/actions/runs/34130210022): `legalwork-tests (ubuntu-latest)` a `legalwork-tests (macos-14)`; app/server/desktop testy, Electron IPC typecheck a app e2e podľa workflow.
- [OKF pamäť — run 34130209875](https://github.com/Omni-Legal-Products/lawoss/actions/runs/34130209875): typecheck a testy Ubuntu/macOS.
- [i18n — run 34130209919](https://github.com/Omni-Legal-Products/lawoss/actions/runs/34130209919): úspešný audit.

Workflow pre `legalwork-ui-mcp` sa na tento diff nespúšťal podľa path filtra; nejde o zlyhaný job. Z úspechu CI nevyplýva balenie, notarizácia ani fungovanie aktualizácie desktopového inštalátora.

Živá ochrana `dev`:

| Kontrola | Stav |
|---|---|
| Počet required review | 1 |
| Zneplatnenie starého review | zapnuté |
| Vyriešenie konverzácií | povinné |
| Required status checks | **žiadne (`null`)** |
| Vynútenie pre administrátorov | **vypnuté** |
| Code owner review / last push approval | vypnuté |

Odporúčanie plánu D9 je doplniť vynucovanie existujúcich užitočných kontrol. Kontrola s path filtrom sa nesmie stať required bez zabezpečenia, že vie dokončiť výsledok aj pre nesúvisiaci PR. Žiadna ochrana sa počas auditu nemenila.

## 5. Vydanie a upstream

- Fork pri kontrole nemal žiadny GitHub release ani predchádzajúci beh Alpha/Release workflowov.
- Kontrolované LAWOSS update cesty vracali 404. Bez publikovaného prvého release to znamená chýbajúcu distribučnú cestu; nie je to meranie existujúcej produkčnej služby.
- Alpha workflowy macOS aj Windows zostavujú URL `https://github.com/eigenweltlabs/legalwork/releases/download/${releaseTag}`, hoci upload používajú cez `$GITHUB_REPOSITORY`. To je konkrétna chyba, ktorú treba opraviť pred prvou alpha distribúciou.
- [macOS alpha workflow](https://github.com/Omni-Legal-Products/lawoss/blob/ec0f4c108e17c53152a01b327c57c1b59dfd69f2/.github/workflows/alpha-macos-aarch64.yml#L248), [Windows alpha workflow](https://github.com/Omni-Legal-Products/lawoss/blob/ec0f4c108e17c53152a01b327c57c1b59dfd69f2/.github/workflows/alpha-windows-x64.yml#L297).
- `productName` je LAWOSS, ale `appId` je `com.eigenweltlabs.legalwork`, protokol `legalwork` a viaceré ďalšie identifikátory zostávajú upstreamové. Existujúci `PATCHES.md` to vysvetľuje kontinuitou dát/keychain; súbežná inštalácia a migrácia identity vyžadujú vlastné rozhodnutie a test.
- `PATCHES.md` má 14 riadkov. Odporúčanie „pod desať, kde sa dá“ je cieľ údržby, nie automatický zákaz feature; kontrolovať najmä úplnosť evidencie zásahov.
- Pravidlo syncu je presný upstream release tag, nie náhodný `upstream/dev`. Lokálne upstream refs boli pri audite staršie než live GitHub; pred plánovaním syncu fetchnúť a nanovo vypočítať delta. Žiadny sync sa teraz nevykonal.

Prvý kandidát potrebuje dôkaz podpísania/notarizácie podľa zvoleného kanála, kontrolu manifestu a hashov a čistú inštaláciu. In-place update sa dá overiť až s dvoma po sebe idúcimi testovacími verziami; dnes starší LAWOSS release neexistuje. Oddeliť test programu od testu distribúcie. Podpisové tajomstvá sa neskúmali ani nevypisovali.

Alpha workflowy vytvárajú verejné prereleases a aktualizujú rolling pointer; manuálne spustenie nie je súkromný test. `Release App` má voľby `draft`, `publish_npm` a ďalšie publikačné kroky; pre review treba explicitne zvoliť draft a vypnúť nezamýšľané publikovanie. Static builder publish owner/repo na overenom `origin/dev` už správne uvádza `Omni-Legal-Products/lawoss`; starší lokálny checkout nie je podklad na opačné tvrdenie.

## 6. Kontrolné príkazy pre aktualizovanie tohto snapshotu

Príkazy sa spúšťajú v príslušnom produktovom repe, bez zápisov do klientskych spisov:

```sh
git fetch origin
git rev-parse origin/dev
git merge-base --is-ancestor 2c8db57 origin/dev
gh api repos/Omni-Legal-Products/lawoss/branches/dev/protection
gh run view 34130210022 -R Omni-Legal-Products/lawoss --json headSha,conclusion,jobs
gh api 'repos/Omni-Legal-Products/lawoss/releases?per_page=5' --jq length
gh api repos/Omni-Legal-Products/lawoss-marketplace --jq '{visibility,default_branch,pushed_at}'
git show origin/dev:apps/app/src/lawoss/experiments/registry.ts
git show origin/dev:lawoss/okf/templates/spis/spis.md
git show origin/dev:lawoss/okf-pamat/src/index.ts
```

Reprodukcia integračného problému a presné testovacie príkazy sú doplnené nižšie. Oprava sa musí overiť na novom head SHA; tento historický záznam sa neprepisuje na „zelené“ bez dôkazu.

### Syntetická reprodukcia

Audit používal čistý export produktu do dočasného priečinka. Fixture počas auditu ležala v `/var/folders/0f/c88qjz9j7q1c93sdnqvy02040000gn/T/tmp.NHnAzzWCce/fixture`; táto dočasná cesta sa nemusí zachovať. Z exportovaného koreňa produktu možno vytvoriť novú:

```sh
fixture=$(mktemp -d)
node lawoss/okf/bundle/okf.js apply spis "$fixture" --title "Synteticka vec" --klient "Test klient" --date 2026-09-09
node lawoss/okf-pamat/bin/okf-memory.ts init "$fixture" --apply
node lawoss/okf-pamat/bin/okf-memory.ts sync "$fixture" --apply
node lawoss/okf/bundle/okf.js validate "$fixture"
node lawoss/okf-pamat/bin/okf-memory.ts validate "$fixture"
```

Očakávané historické výsledky: sync exit 1 (sekcia Lehoty bez markerov), starý validate exit 1 (BRAIN.md), pamäťový validate exit 0. Surové `.ts` CLI vyžaduje kompatibilný Node runtime; tento postup nie je prísľub podpory všetkých Node verzií.

Samostatné sady z príslušných adresárov: `bun test test/` pre `lawoss/okf`, `node --test 'tests/**/*.test.ts'` pre `lawoss/okf-pamat`. Prvá sada overuje 14 testov, druhá 415. Presný existujúci testovací príkaz sa má pred následnou implementáciou porovnať s package manifestom aktuálneho headu.

Dodatočná integračná prekážka: `apps/server/tsconfig.json` používa `rootDir: src`, zatiaľ čo `okf-pamat` exportuje surový TypeScript mimo serverového koreňa a `okf` nemá vlastné exports. Potrebné je vyriešiť skutočný build/import; samotné pridanie balíkov do workspace nestačí.
