# Návod: pripojenie MCP serverov do LegalWorku (nultý krok)

- **Prispel:** Igor Ribár (IR) · 2026-08-14
- **Stav:** v1 draft. Kroky v rozhraní treba overiť na živej appke (označené ⚠️),
  screenshoty a adresy serverov doplní tím. Vychádza z overenia tímu z 2026-08-06,
  že MCP servery sa v LegalWorku pridávajú cez UI.
- **Pre:** „nultý krok" z [agendy 12. 8.](../meetings/2026-08-12-agenda-mvp.md) ·
  [spec 0004 MCP konektory](../specs/0004-mcp-sk-konektory.md)

> [!NOTE]
> Tento návod je pre advokáta bez technického zázemia. Cieľ: za 15 minút mať
> v LegalWorku AI, ktorá pri otázke na slovenské právo číta skutočný Slov-Lex
> a skutočné rozhodnutia súdov namiesto vlastnej pamäte.

## Čo tým získate

AI asistenti (ChatGPT, Claude a ďalšie) nevedia, čo je dnes v Slov-Lexe, a pri
konkrétnych paragrafoch a spisových značkách si vymýšľajú. Pre advokáta je
vymyslená citácia horšia než žiadna. Po pripojení konektorov si AI každé
znenie paragrafu a každé rozhodnutie vyžiada z reálneho zdroja a odpovie
s odkazom, ktorý si viete overiť.

## Čo je MCP, ľudskou rečou

MCP (Model Context Protocol) je štandardná zásuvka, cez ktorú si AI aplikácia
vie zavolať externý nástroj: „daj mi znenie § 121 CSP", „vyhľadaj rozhodnutia
k § 371 TP". Nástroj (MCP server) beží mimo appky; vy do appky len zadáte jeho
adresu. Naše konektory sú **iba na čítanie**: AI cez ne nič nepodáva, nič
nepodpisuje, nikam nezasahuje.

## Predpoklady

1. Nainštalovaný **LegalWork** ([github.com/eigenweltlabs/legalwork](https://github.com/eigenweltlabs/legalwork)).
2. Prihlásenie k AI modelu: vlastný **API kľúč** (odporúčané), alebo existujúce
   predplatné (ChatGPT / Claude). Pri predplatnom appka zobrazí upozornenie na
   podmienky poskytovateľa; berte ho vážne, je to vaša informovaná voľba
   (detail v [spec 0003](../specs/0003-prompt-layer.md)).
3. **Adresy MCP serverov** [doplní tím: adresy nasadených serverov judikatúra
   a Slov-Lex + prípadný prístupový token].

## Pridanie servera (cez rozhranie, bez programovania)

> ⚠️ Presné názvy položiek menu treba overiť na živej appke; screenshoty doplníme.

1. Otvorte **Settings** (nastavenia).
2. Nájdite sekciu **MCP / Extensions / Connectors** a zvoľte **pridať server**.
3. Vyplňte:
   - **Názov:** napr. `judikatura-sk`
   - **Adresa servera:** [doplní tím]
   - **Token:** [doplní tím, ak server vyžaduje]
4. Uložte a reštartujte rozhovor, aby sa nástroje načítali.
5. Zopakujte pre druhý server (`slov-lex`).

*(sem screenshot 1: nastavenia; sem screenshot 2: vyplnený formulár servera)*

## Odporúčaná prvá dvojica

| Server | Čo dáva | Príklad otázky |
|---|---|---|
| **Slov-Lex** | znenia predpisov, aj k dátumu | „Aké je aktuálne znenie § 121 ods. 4 CSP? Cituj doslovne a uveď zdroj." |
| **Judikatúra SR** | rozhodnutia súdov, vyhľadávanie | „Nájdi rozhodnutia NS SR k § 371 ods. 1 písm. i) Trestného poriadku z posledných troch rokov a vypíš spisové značky." |

## Ako overíte, že to funguje

Položte testovaciu otázku z tabuľky vyššie. Správna odpoveď:

- obsahuje **doslovné znenie** alebo **konkrétne spisové značky**,
- uvádza **zdroj** (odkaz alebo identifikátor, ktorý si viete rozkliknúť alebo dohľadať),
- pri nedostupnom zdroji AI povie, že údaj nevie overiť, namiesto tipovania.

Červená vlajka: odpoveď s paragrafmi či spisovými značkami **bez zdroja**.
Takú odpoveď nepoužívajte a skontrolujte, či je server pripojený.

## Bezpečnostné zásady pre advokáta

1. **Do otázok nepíšte klientske údaje** (mená, rodné čísla, čísla konaní
   živých vecí). Konektory sú na verejné právo; otázku formulujte abstraktne.
2. **Každú citáciu pred použitím v podaní overte** kliknutím na zdroj. Nástroj
   znižuje riziko výmyslu, nenahrádza kontrolu advokáta.
3. Konektory sú **read-only**; nič v mene advokáta nekonajú.

## Keď niečo nejde

| Problém | Čo skúsiť |
|---|---|
| Appka server nevidí | skontrolujte adresu (preklep, https), reštartujte appku |
| Odpoveď prichádza bez zdrojov | v otázke si výslovne vypýtajte „použi pripojený nástroj a uveď zdroj"; skontrolujte, či je server zapnutý pre aktuálny rozhovor |
| Server neodpovedá (timeout) | server môže byť dočasne mimo prevádzky; napíšte do Telegram topicu *General CHAT* |

## Čo bude ďalej

Po tejto dvojici pripojíme ďalšie zdroje z flotily organizácie (obchodný
register, RPVS, register úpadcov, EUR-Lex a ďalšie) a návod rozšírime. Spätnú
väzbu píšte do Telegramu alebo ako GitHub Issue.
