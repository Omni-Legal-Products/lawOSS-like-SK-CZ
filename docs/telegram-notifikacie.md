# GitHub notifikácie v Telegrame

> **Overené:** Telegram MCP a GitHub API, 2026-08-12.

## Zdroj pravdy

| Položka | Hodnota |
|---|---|
| Telegram skupina | `LawOSS (SLOVAKIA | CZECHIA) + AI Frontier Labs` |
| `TELEGRAM_CHAT_ID` | `-1003828145652` |
| Bot | `@mikeossSK_bot` |
| Koordinačný repo | `originalmagneto/lawOSS-like-SK-CZ` |
| Produktový repo | `Omni-Legal-Products/lawoss` |

Token bota sa nikdy nezapisuje do dokumentácie, commitu, issue, PR ani logu. Patrí iba do GitHub Actions secretu `TELEGRAM_TOKEN`.

## Smerovanie podľa repozitára

| Repozitár | Vetva | Topic | Topic ID | Workflow | Udalosti |
|---|---|---|---:|---|---|
| `originalmagneto/lawOSS-like-SK-CZ` | `main` | `SK Mike GH` | `2` | `.github/workflows/telegram-notify.yml` | push do `main`, PR, issue, release, diskusia |
| `Omni-Legal-Products/lawoss` | `dev` | `LAWOSS APP GH` | `293` | `.github/workflows/telegram-notify.yml` v produktovom repe | PR, issue, release, zlyhanie CI |

Produktový workflow neposiela každý push. Cieľom je zachytiť udalosti vyžadujúce pozornosť bez zahltenia tímového chatu.

## Stav produktového napojenia

- Topic `LAWOSS APP GH` bol vytvorený 2026-08-12 s ID `293`.
- Repository variables sú nastavené:
  - `TELEGRAM_CHAT_ID=-1003828145652`
  - `TELEGRAM_TOPIC_ID=293`
- Workflow je pripravený v [produktovom PR #2](https://github.com/Omni-Legal-Products/lawoss/pull/2) proti vetve `dev`.
- Chýba repository alebo organization secret `TELEGRAM_TOKEN`.
- Notifikácie sa aktivujú až po nastavení tokenu a merge PR #2.

## Udalosti produktového repozitára

| Udalosť | Správa do `LAWOSS APP GH` |
|---|---|
| Pull request | otvorený, znovuotvorený, pripravený na review, zatvorený alebo mergnutý |
| Issue | otvorené, znovuotvorené alebo zatvorené |
| Release | publikovaný release |
| CI | iba neúspešné dokončenie sledovaného workflowu |
| Manuálny test | `workflow_dispatch` |

Sledované CI workflowy:

- `Alpha Channel (macOS arm64)`
- `Alpha Channel (Windows x64)`
- `i18n Audit`
- `legalwork-ui-mcp`
- `LegalWork Tests`
- `Release App`

## Aktivácia produktového repozitára

1. Otvoriť `Omni-Legal-Products/lawoss`.
2. Prejsť do `Settings` → `Secrets and variables` → `Actions`.
3. Vytvoriť repository secret `TELEGRAM_TOKEN` s tokenom `@mikeossSK_bot`.
4. Schváliť a mergnúť [PR #2](https://github.com/Omni-Legal-Products/lawoss/pull/2) do `dev`.
5. V `Actions` spustiť workflow `LAWOSS Telegram notifications` cez `Run workflow`.
6. Overiť testovaciu správu v topicu `LAWOSS APP GH`.

Ak sa použije organization secret, musí byť sprístupnený minimálne repozitáru `Omni-Legal-Products/lawoss`. Hodnotu secretu GitHub po uložení spätne nezobrazí.

## Mapa tímových topicov

| Topic | ID | Účel |
|---|---:|---|
| `General CHAT` | `1` | tímová komunikácia a koordinácia |
| `SK Mike GH` | `2` | automatizácie koordinačného repozitára |
| `LAWOSS APP GH` | `293` | automatizácie produktového repozitára |
| `DESIGN` | `5` | produktový a vizuálny dizajn |
| `Research` | `6` | rešerše |
| `AI Frontier Labs` | `7` | súvisiace AI témy |
| `Feature IDEAS` | `97` | surové návrhy pred spracovaním v koordinačnom repe |

## Pravidlá pre AI agentov

1. Koordinačné notifikácie nesmerovať do `LAWOSS APP GH`.
2. Produktové notifikácie nesmerovať do `SK Mike GH`.
3. Nepridávať bežné push notifikácie do produktového topicu bez tímového rozhodnutia.
4. Nikdy nevypisovať ani nekopírovať hodnotu `TELEGRAM_TOKEN`.
5. Pri zmene názvu workflowu aktualizovať aj zoznam v `workflow_run.workflows`, inak sa zlyhanie CI nemusí oznámiť.
6. Po každej zmene smerovania overiť repository variables, názvy secrets, testovací beh a cieľový topic.
7. MCP repozitáre zatiaľ nemajú vlastné automatické Telegram notifikácie. Ak sa doplnia, preferuje sa jeden spoločný topic `MCP GH`, nie topic pre každý server.
