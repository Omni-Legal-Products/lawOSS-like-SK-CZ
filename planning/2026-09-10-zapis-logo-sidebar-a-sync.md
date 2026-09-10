# Zápis 10. 9. 2026 — logo B, jednotný sidebar a príprava sync callu

**Stav k 10. 9. 2026.** Zadanie a výber identity: MČ v pracovnej konverzácii. Zápis zachytáva vykonanú prácu; časť pre call je návrh programu, nie zápis už uskutočneného stretnutia. MČ oznámil sync call na **11. 9. 2026**; čas a účasť tu nie sú potvrdené.

## Aktuálny výsledok

Logo B je integrované do aplikácie, hlavná navigácia a Experimenty používajú jeden shell a testovací macOS build je publikovaný. Produktový PR **#39 je OPEN a vyžaduje review**; koordinačný PR **#76 je OPEN**. Publikovaný preview nie je merge do `dev` ani stabilné notarizované vydanie.

| Podklad | Odkaz / identifikátor |
|---|---|
| Implementácia | [lawoss PR #39](https://github.com/Omni-Legal-Products/lawoss/pull/39), `fix/unified-experiments-shell` |
| Rozhodnutie a vizuálne zdroje | [koordinačný PR #76](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/76), `design/unified-shell-and-six-logos` |
| Stiahnutie appky | [Preview — logo B a jednotný sidebar](https://github.com/Omni-Legal-Products/lawoss/releases/tag/preview/logo-b-sidebar-20260910) |
| Presný commit publikovaného buildu | `1b544a7fd2d730d9832b88793c1731b101798678` |
| Verzia v aplikácii | `0.1.18-lawoss.local.20260910` |
| ZIP | `LAWOSS-0.1.18-logo-B-mac-arm64.zip`, 302 360 756 bajtov |
| SHA-256 ZIP | `73f93ccb4d72349d72bb530d09b925c499d8ab1d36666acc812ecb99e00cfbaa` |

Neskoršie dokumentačné commity v PR nemenia obsah už publikovaného ZIP. Pre reprodukciu používajte uvedený build commit, nie pohyblivý HEAD vetvy.

## Rozhodnutia MČ a priebeh práce

1. Pôvodný hlavný sidebar a samostatný experimentálny sidebar pôsobili ako dve aplikácie. MČ požadoval jeden súvislý spôsob navigácie pred integráciou ďalších funkcií.
2. Vzniklo šesť alternatív identity a evidencia skorších stĺpových návrhov. MČ odmietol komplikované SVG a plochý žltý odtieň; požadoval jednoduchší grécky/rímsky stĺp a kovové zlato s odleskami.
3. MČ dodal dve pôvodné obrazové referencie a následne výslovne vybral **B**. Platná identita: zlatý portikus v otvorenom kruhu, biely wordmark LAWOSS; marketingový lockup používa podtitul **CZECHIA SLOVAKIA AND BEYOND**. Malá ikona používa samotný znak. Staršie varianty sú archív, nie rovnocenné finálne možnosti.
4. MČ autorizoval integráciu, aktualizáciu lokálnej appky, publikáciu stiahnuteľného buildu a oznámenie tímu cez Telegram.

Zdroje: [evidencia loga a originálov](../assets/brand/loga-2026-09-10/README.md), [dizajnový systém](../docs/design/design-system.md), [jednotný shell](../docs/design/2026-09-10-jednotny-shell.md).

## Čo sa implementovalo

- Experimentálne stránky renderuje existujúci `SessionRoute` vo svojom hlavnom paneli. Priečinky, relácie a ovládanie aplikácie zostávajú v spoločnom sidebare.
- Samostatný ľavý rail experimentov a návrat „Späť do aplikácie“ nahradila navigácia nad obsahom.
- Experimenty majú rovnaké odsadenie ikony a textu ako ostatné položky. Opravené je zachovanie experimentálnej URL a návrat z pomocných panelov na rovnaký experiment.
- Hustejšie obrazovky reagujú na šírku obsahového panelu. Nové funkcie majú využívať existujúci shell.
- B je zapojené do sidebaru, desktopových ikon a faviconov. Produkt má spoločný SVG master a skript na generovanie ikon. Vlastné firemné názvy a logá zostávajú podporované.
- Identita aplikácie `com.eigenweltlabs.legalwork` zostala zachovaná pre kontinuitu profilu. Existujúca aplikácia a profil boli pred lokálnou výmenou zálohované.

Táto práca nepridáva backend nových funkcií, nedokončuje OKF integráciu a nepotvrdzuje pripravenosť všetkých experimentov na produkciu. Nasadenie novej identity na živý web lawoss.app nebolo súčasťou tohto vydania.

## Overenie a jeho hranice

| Overenie | Výsledok |
|---|---|
| TypeScript a produkčný renderer/desktop build | Prešli; desktop zahŕňa renderer, Word add-in, sidecary a kontroly bridge/závislostí/pluginov |
| Testy experimentov | 12 úspešných |
| Desktop testy | 104 úspešných, 1 preskočený, 0 zlyhaní |
| CI buildu v PR #39 | Linux, macOS a i18n audit úspešné na uvedenom build commite |
| Navigácia v prehliadači | Experimenty → Lehoty → Workflows → návrat na rovnaké Lehoty; jeden sidebar a zhodné odsadenie |
| Nainštalovaný Electron na macOS arm64 | Existujúci priečinok a relácia sa načítali; relácia → Experimenty zachováva sidebar |
| Distribučný ZIP | Po rozbalení prešlo `codesign --verify --deep --strict`; GitHub digest zodpovedá lokálnemu SHA-256; verejný download odpovedal HTTP 200 |
| Windows / Intel Mac | Runtime neoverený; v tomto preview nie sú tieto binárky |
| Podpis a updater | Ad-hoc podpis, bez Apple notarizácie; stabilný updater sa nemení |

Smoke test navigácie nie je overenie spracovania reálneho právneho prípadu. Do verejného repozitára išla iba čistá ukážka UI; pracovné profily, zálohy a screenshot s klientskymi údajmi neboli publikované.

## Publikovanie a Telegram

Preview obsahuje ZIP, `SHA256SUMS.txt` a release notes s inštalačnými obmedzeniami. Odkaz je aj v oboch PR. Oznámenie odoslal existujúci GitHub Actions workflow cez bota do topicu **GitHub · App / LAWOSS APP GH (293)**; nejde o priamy Telegram MCP konektor v Codexe.

[Notifikačný workflow run 34466275079](https://github.com/Omni-Legal-Products/lawoss/actions/runs/34466275079) skončil úspešne a potvrdil prijatie správy Telegram API. Oznámenie bolo viditeľné aj v desktopovom Telegrame. To potvrdzuje doručenie, nie prečítanie jednotlivými členmi tímu.

## Podklad na sync call — 11. 9. 2026

**Navrhovaný cieľ:** prevziať vizuálny základ, určiť reviewerov a dohodnúť prvú integrovanú používateľskú cestu. Nejde o nový prísľub termínu dodania.

| Poradie | Navrhovaná téma | Potrebný výstup |
|---|---|---|
| 1 · 5 min | Demo B a jednotnej navigácie na preview | Konkrétne pripomienky alebo akceptácia vizuálneho výsledku |
| 2 · 5 min | Produktový PR #39 a koordinačný PR #76 | Reviewer a podmienky merge; vlastníka určí tím |
| 3 · 5 min | Distribúcia | Vlastník notarizácie, platformovej matice a overenia updatera; preview samo tieto body neuzatvára |
| 4 · 10 min | Začiatok integrácie nových funkcií | Vybrať jednu cestu, vstupy/výstupy a akceptačný scenár podľa [realizačného plánu](2026-09-09-realizacia-lawoss-a-spolupraca-ai.md) |
| 5 · 5 min | Rozdelenie práce | Gestor, implementátor, reviewer a preberajúci pre každý schválený balík; termíny potvrdiť na calle |

Historický [audit z 9. 9.](2026-09-09-audit-realizacie-lawoss.md) uvádzal problém spoločnej cesty OKF → pamäť → sync. V tejto dizajnovej práci sa neopravoval ani znovu nereprodukoval; pred plánovaním integrácie treba overiť aktuálny stav. Návrh prvej cesty z plánu: nastaviť kanceláriu → založiť SK/CZ spis → zapísať záznam → zobraziť stav a zdroj → pokračovať po reštarte.

### Akčné body na uzavretie

- [ ] Tím: prideliť review PR #39 a vykonať merge až po schválení a zelených kontrolách.
- [ ] Tím: prejsť PR #76 a potvrdiť spoločný referenčný bod pre ďalšie obrazovky.
- [ ] Tím: otestovať preview a zapisovať reprodukovateľné chyby do produktu; nemenovať preview stabilným vydaním.
- [ ] Vlastník na určenie: dokončiť notarizáciu, platformové testy a overiť aktualizácie pred stabilným vydaním.
- [ ] Vlastník na určenie: znovu overiť spoločný OKF kontrakt a navrhnúť prvý schválený integračný balík.
- [ ] Koordinátor: po calle doplniť skutočné rozhodnutia, vlastníkov a termíny do samostatného zápisu stretnutia.

## Zdroje a dátum kontroly

Stav PR, release, presný tag/commit, digest a doručenie: GitHub CLI/API a notifikačný log, overené 10. 9. 2026. Lokálne testy a smoke scenáre: vykonané v tejto pracovnej konverzácii 10. 9. 2026. Výber B a dátum callu: výslovné vyjadrenia MČ v konverzácii. HTML verzia: [otvoriť podklad](2026-09-10-zapis-logo-sidebar-a-sync.html).
