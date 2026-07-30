# Napojenie GitHubu na Telegram skupinu

Workflow [`.github/workflows/telegram-notify.yml`](../.github/workflows/telegram-notify.yml) posiela do Telegram skupiny správu pri **pushi do `main`**, **release**, **issue** a **pull requeste**. Ovládame ho my, správy si vieme ľubovoľne upraviť.

> [!IMPORTANT]
> Workflow je už v repe, ale **nič neposiela, kým nenastavíte dva secrets** (`TELEGRAM_TOKEN`, `TELEGRAM_CHAT_ID`). Dovtedy sa krok ticho preskočí (nepadá to na chybu).

## Nastavenie (jednorazovo, ~5 minút)

### 1. Vytvorte bota
1. V Telegrame otvorte [@BotFather](https://t.me/BotFather).
2. `/newbot` → zadajte názov (napr. `MikeOSS SK`) a username (musí končiť na `bot`, napr. `mikeoss_sk_bot`).
3. BotFather vám vypíše **token** v tvare `123456789:AAE...` — uschovajte ho.

### 2. Pridajte bota do skupiny
- V Telegram skupine: **Add members** → nájdite svojho bota → pridajte.
- (Ak má skupina témy/topics alebo je to kanál, dajte botovi rolu admina.)

### 3. Zistite `chat_id` skupiny
Najjednoduchšie: do tej istej skupiny dočasne pridajte [@getidsbot](https://t.me/getidsbot) alebo [@RawDataBot](https://t.me/RawDataBot) — hneď vypíše `Chat ID`. Pre skupiny je to **záporné** číslo (supergroup začína `-100…`). Potom pomocného bota zase vyhoďte.

*Alternatíva bez cudzieho bota:* pošlite v skupine hocijakú správu a otvorte v prehliadači
`https://api.telegram.org/bot<VÁŠ_TOKEN>/getUpdates` → nájdite `"chat":{"id":-100...}`.

### 4. Uložte secrets do GitHub repa
V repe: **Settings → Secrets and variables → Actions → New repository secret** a pridajte dva:

| Name | Hodnota |
|---|---|
| `TELEGRAM_TOKEN` | token z BotFather |
| `TELEGRAM_CHAT_ID` | `chat_id` skupiny (napr. `-1001234567890`) |

### 5. Test
Spravte hocijaký push do `main` (alebo v repe **Actions → Telegram notifikácie → Run workflow**). Do skupiny by mala doraziť správa. Ak nie, pozrite log behu v záložke **Actions**.

## Smerovanie do konkrétneho topicu (forum-skupina)

Ak je skupina vo forum režime (má *Topics*), notifikácie sa dajú posielať len do jedného vybraného topicu.

1. **Zistite ID topicu:** v Telegrame otvorte daný topic → podržte/kliknite pravým na hociktorú správu v ňom → **Copy Link**. Dostanete odkaz v tvare
   `https://t.me/c/2812345678/23/105`
   **Prostredné číslo** (tu `23`) je ID topicu. *(Ak sú v odkaze len dve čísla, ide o hlavné vlákno „General" — to nemá samostatné ID.)*
   Alternatívne pridajte do topicu [@getidsbot](https://t.me/getidsbot), ktorý vypíše *Topic ID*.
2. **Uložte ho ako premennú** (nie secret — nie je citlivé): v repe **Settings → Secrets and variables → Actions → záložka _Variables_ → New repository variable**:

   | Name | Hodnota |
   |---|---|
   | `TELEGRAM_TOPIC_ID` | ID topicu (napr. `23`) |

3. Hotovo. Od ďalšieho pushu chodia správy do tohto topicu. Keď premennú zmažete, notifikácie pôjdu späť do hlavného vlákna.

## Čo sa notifikuje

| Udalosť | Kedy |
|---|---|
| 🚀 Push do `main` | pri každom nasadení zmien (okrem auto-README bota) |
| 🎉 Release | publikovaný nový release |
| 🐛 Issue | otvorené / zatvorené / znovuotvorené |
| 🔀 Pull request | otvorený / zatvorený / merged |
| 💬 Diskusia | nová GitHub Discussion |

Zoznam sa dá rozšíriť úpravou sekcie `on:` a `case` vo workflowe.

## Alternatívy a ďalšie GitHub funkcie

- **Bez GitHub Actions (no-code):** väčšina „RSS to Telegram" botov vie sledovať feed
  `https://github.com/originalmagneto/lawOSS-like-SK-CZ/commits/main.atom`
  a postovať commity do skupiny. Menej kontroly nad formátom, zato nulová konfigurácia.
- **GitHub Mobile** appka — osobné push notifikácie (mentions, review requests), doplnok k skupinovým.
- **Opačný smer (Telegram → GitHub)** — vytváranie issue príkazom z Telegramu je možné, ale vyžaduje malý serverless webhook (napr. Cloudflare Worker). Ak to budeme chcieť, spíšeme ako samostatný [spec](../specs/).
- **GitHub Projects / Discussions** — na plánovanie a hlasovanie o nápadoch (viď [AGENTS.md](../AGENTS.md)); Discussions sa už tiež notifikujú.
