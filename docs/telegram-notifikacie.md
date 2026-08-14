# GitHub notifikácie v Telegrame

> **Overené:** Telegram MCP a GitHub API, 2026-08-12.

## Zdroj pravdy

| Položka | Hodnota |
|---|---|
| Telegram skupina | `LawOSS (SLOVAKIA | CZECHIA) + AI Frontier Labs` |
| `TELEGRAM_CHAT_ID` | `-1003828145652` |
| Bot | `@mikeossSK_bot` |
| Koordinačný repo | `Omni-Legal-Products/lawOSS-like-SK-CZ` |
| Produktový repo | `Omni-Legal-Products/lawoss` |

Token bota sa nikdy nezapisuje do dokumentácie, commitu, issue, PR ani logu. Patrí iba do GitHub Actions secretu `TELEGRAM_TOKEN`.

## Smerovanie podľa repozitára

| Repozitár | Vetva | Topic | Topic ID | Workflow | Udalosti |
|---|---|---|---:|---|---|
| `Omni-Legal-Products/lawOSS-like-SK-CZ` | `main` | `GitHub · Ops` | `2` | `.github/workflows/telegram-notify.yml` | push do `main`, PR, issue, release, diskusia |
| `Omni-Legal-Products/lawoss` | `dev` | `GitHub · App` | `293` | `.github/workflows/telegram-notify.yml` v produktovom repe | PR, issue, release, zlyhanie CI |

Produktový workflow neposiela každý push. Cieľom je zachytiť udalosti vyžadujúce pozornosť bez zahltenia tímového chatu.

## Stav produktového napojenia

- Topic `GitHub · App` bol vytvorený 2026-08-12 s ID `293`.
- Topicy boli **2026-08-14 premenované** na `GitHub · Ops` a `GitHub · App` — spoločný prefix ich drží pri sebe a pôvodné `SK Mike GH` odkazovalo na zamietnutý MikeOSS. **Premenovanie nemení ID**, takže workflow ani premenné sa nedotklo.
- Repository variables sú nastavené:
  - `TELEGRAM_CHAT_ID=-1003828145652`
  - `TELEGRAM_TOPIC_ID=293`
- Workflow je pripravený v [produktovom PR #2](https://github.com/Omni-Legal-Products/lawoss/pull/2) proti vetve `dev`.
- Chýba repository alebo organization secret `TELEGRAM_TOKEN`.
- Notifikácie sa aktivujú až po nastavení tokenu a merge PR #2.

## Udalosti produktového repozitára

| Udalosť | Správa do `GitHub · App` |
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

> [!TIP]
> **Od 2026-08-14 sú obe repá v jednej organizácii**, takže token sa dá nastaviť **raz na úrovni organizácie** namiesto zvlášť v každom repe:
> `Organization settings → Secrets and variables → Actions → New organization secret`, s prístupom pre vybrané repozitáre. Pri ďalších repozitároch (MCP servery) sa tým odpadne opakované nastavovanie.

## Aktivácia produktového repozitára

> [!NOTE]
> **Stav k 2026-08-14:** premenné `TELEGRAM_CHAT_ID` (`-1003828145652`) a `TELEGRAM_TOPIC_ID` (`293`) sú vo forku **už nastavené**. Zostáva secret s tokenom a merge PR #2.
>
> ⚠️ **Pozor na typ.** Workflow vo forku číta chat a topic ako **premenné** (`vars.`), nie ako secrets — v koordinačnom repe je `TELEGRAM_CHAT_ID` historicky secret. Kto by to kopíroval podľa vzoru, nastaví secret a workflow **ticho nepošle nič**.

1. Otvoriť `Omni-Legal-Products/lawoss`.
2. Prejsť do `Settings` → `Secrets and variables` → `Actions`.
3. Vytvoriť repository secret `TELEGRAM_TOKEN` s tokenom `@mikeossSK_bot`.
4. Schváliť a mergnúť [PR #2](https://github.com/Omni-Legal-Products/lawoss/pull/2) do `dev`.
5. V `Actions` spustiť workflow `LAWOSS Telegram notifications` cez `Run workflow`.
6. Overiť testovaciu správu v topicu `GitHub · App`.

Ak sa použije organization secret, musí byť sprístupnený minimálne repozitáru `Omni-Legal-Products/lawoss`. Hodnotu secretu GitHub po uložení spätne nezobrazí.

## Mapa tímových topicov

| Topic | ID | Účel |
|---|---:|---|
| `General CHAT` | `1` | tímová komunikácia a koordinácia |
| `GitHub · Ops` | `2` | automatizácie koordinačného repozitára |
| `GitHub · App` | `293` | automatizácie produktového repozitára |
| `DESIGN` | `5` | produktový a vizuálny dizajn |
| `Research` | `6` | rešerše |
| `AI Frontier Labs` | `7` | súvisiace AI témy |
| `Feature IDEAS` | `97` | surové návrhy pred spracovaním v koordinačnom repe |

## Pravidlá pre AI agentov

1. Koordinačné notifikácie nesmerovať do `GitHub · App`.
2. Produktové notifikácie nesmerovať do `GitHub · Ops`.
3. Nepridávať bežné push notifikácie do produktového topicu bez tímového rozhodnutia.
4. Nikdy nevypisovať ani nekopírovať hodnotu `TELEGRAM_TOKEN`.
5. Pri zmene názvu workflowu aktualizovať aj zoznam v `workflow_run.workflows`, inak sa zlyhanie CI nemusí oznámiť.
6. Po každej zmene smerovania overiť repository variables, názvy secrets, testovací beh a cieľový topic.
7. MCP repozitáre zatiaľ nemajú vlastné automatické Telegram notifikácie. Ak sa doplnia, preferuje sa jeden spoločný topic `MCP GH`, nie topic pre každý server.
