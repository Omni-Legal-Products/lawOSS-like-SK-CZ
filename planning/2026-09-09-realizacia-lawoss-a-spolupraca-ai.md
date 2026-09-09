# LAWOSS: plán realizácie a spolupráce s AI agentmi

- **Pripravené:** 9. 9. 2026, AI na zadanie MČ, koordinátora projektu.
- **Stav:** realizačný návrh na rozhodnutie. Neprideľuje záväzne prácu kolegom a nemení prijaté ADR. Implementačné issues vzniknú po potvrdení príslušného rozsahu.
- **Overená báza:** produkt `origin/dev` = `ec0f4c108e17c53152a01b327c57c1b59dfd69f2`; koordinácia `origin/main` = `5aa993f48dd3b4a055fcaf6a67027e2b680c9c5b`; marketplace `main` = `d9631fb39ccc70055a0767a24d270b319baf774f`.
- **Metóda:** čítanie kódu konkrétnych git revízií, GitHub API cez `gh`, samostatné audity OKF a vydávania. Kontrola zdrojov nie je desktopový akceptačný test. Výsledky spustených kontrol sú v §13.
- **Kapacita:** termín 16. 9. pochádza z callu 7. 9.; jeho dnešná záväznosť a časová dostupnosť tímu nie sú v tomto podklade potvrdené. Harmonogram je podmienený, nie prísľub termínu.

## 1. Odporúčanie pre koordinátora

Stavať po malých dokončených používateľských cestách nad jedným dátovým kontraktom. Prvá cesta: **pripraviť kanceláriu → založiť spis → zapísať záznam → zobraziť aktuálny stav → otvoriť jeho zdroj → pokračovať po reštarte**. Marketplace sa pripravuje súbežne, ale pripravenosť balíka sa musí odlišovať od pripravenosti služby.

Vaša hlavná práca je určiť očakávané správanie na príkladoch z praxe a prevziať výsledok. AI pripraví technický návrh, kód, testy a dôkazy. Ty držíš priority, spoločné rozhrania a rozhodnutia; gestor každej oblasti denne preberá jej výsledky. Každý gestor má jedného implementujúceho agenta a podľa rizika čerstvého recenzenta.

Najprv obmedziť počet súčasne otvorených implementácií na **tri**: OKF, používateľská cesta a marketplace. Integrácia a testovanie sú spoločná priebežná činnosť. Limit sa zvyšuje až keď tím stíha preberať výsledky. Rýchlosť meria počet prijatých a fungujúcich scenárov, nie počet agentov alebo commitov.

### Zvažované prístupy

| Prístup | Prínos | Cena a riziko | Záver |
|---|---|---|---|
| Malé funkčné cesty, najprv spoločný kontrakt | Rýchlo sa ukáže funkčná aplikácia; jadro zostáva prenosné | Vyžaduje krátke rozhodnutie na začiatku a disciplinované rozhrania | **Odporúčané** |
| Najprv kompletný OKF 1.0, až potom appka | Menší pohyb formátu počas UI práce | Beta môže čakať na migrácie, taxonómiu a všetky výnimky | Zjednotiť iba jadro potrebné pre prvú cestu |
| Každý agent samostatne dokončí svoju obrazovku | Veľa viditeľnej aktivity | Rozdielne parsery, duplicitné stavy a drahá integrácia | Nepoužiť ako spôsob rozdelenia práce |

## 2. Čo je dnes skutočne implementované

| Oblasť | Overený stav | Význam pre plán |
|---|---|---|
| Electron/React aplikácia nad LegalWork | Fork, branding, tokeny a experimentálne routy existujú | Zachovať existujúci shell, session, editor, workspace a settings mechanizmy |
| Nový spis | `NovySpisPage` inštaluje skill a pribalený CLI súbor; vytvorí session s draftom promptu | Odovzdanie promptu nie je dôkaz vytvoreného spisu. Doplniť reálny plán a overený výsledok |
| OKF vytváranie | `lawoss/okf` má plánovanie, aplikáciu, validáciu a šablóny | Zachovať, zosúladiť šablóny a validátor s pamäťou |
| Pamäť | `lawoss/okf-pamat` má typy, čítanie, zápisy, validácie, indexy, status a Obsidian podporu | Použiť existujúce API; nepísať nový parser v Reacte |
| Onboarding | Odporúčaná/podrobná cesta a uložené `lane`/`step`; workspace a provider flow v upstream route | Nie je to úplný register nastavenia. Cesta priečinka a stav pripravenosti vyžadujú overenie po reštarte |
| Prehľad a Lehoty | Natvrdo zapísané demonštračné dáta | Nahradiť údajmi z jedného spisu, až potom agregovať prax |
| Marketplace UI | Katalóg, filtrovanie, detail, inštalačný náhľad `preview-only` | Inštalácia zatiaľ neprebieha |
| Reálny marketplace | Verejný repozitár, 15 balíkov; 14 má skill, žiadny z kontrolovaných manifestov nemá `mcpServers` ani vlastný `.mcp.json` | Dnes distribuuje znalosti a návody. Nespúšťa automaticky 15 služieb |
| Konektory | LAWOSS pohľad je demo; upstream má MCP settings a plugin import | Rozšíriť existujúce nastavenia a zdroj dát, nevytvárať druhú správu pripojení |
| Aktualizovanie UI | Upstream reload dôvody sú config/agents/skills/commands/plugins/mcp | Existencia watcheru nedokazuje sledovanie `memory/`; doplniť obnovu dát spisu |

Zdroje: [produktová revízia](https://github.com/Omni-Legal-Products/lawoss/tree/ec0f4c108e17c53152a01b327c57c1b59dfd69f2), [merge pamäte #37](https://github.com/Omni-Legal-Products/lawoss/pull/37), [marketplace #36](https://github.com/Omni-Legal-Products/lawoss/pull/36), [distribučný manifest](https://github.com/Omni-Legal-Products/lawoss-marketplace/blob/d9631fb39ccc70055a0767a24d270b319baf774f/.claude-plugin/marketplace.json).

### Opravy obrazu zo starších podkladov

1. Marketplace už nie je private. `releases.json` ešte obsahuje starý údaj; pre viditeľnosť platí živé GitHub API. Verejnosť však nepreukazuje fungujúce endpointy.
2. PR #24/#31/#35/#36 sú zlúčené, ale merge sám neznamená splnenie všetkých follow-up podmienok. Napríklad `EVENT_KINDS` má stále slovenské hodnoty.
3. Dátový kontrakt sa rozchádza: šablóna používa `klient.md`, `MEMORY.md`, vlastné lehoty, chýbajúcu jurisdikciu a napevno vložené meno advokáta; pamäťové jadro má vlastnú štruktúru a projekcie.
4. Evidencia experimentov zaostáva za marketplace implementáciou. Stavy funkcií treba aktualizovať podľa preukázaného správania.
5. Playbook, viaceré ADR a specy majú aj po zlúčení súborov stav návrhu. **Existencia v `main` nie je schválenie ich obsahu.**

## 3. Rozhodnutia, ktoré treba uzavrieť

Nasledujúce odporúčania sú návrhy. Rozhodnutie má mať jednu vetu, dátum, rozhodujúceho človeka, dotknutý spec a rozsah platnosti. Technické detaily potom rieši gestor s agentom.

| ID | Rozhodnutie | Odporúčaný výsledok | Kto má uzavrieť | Čo naň čaká |
|---|---|---|---|---|
| D1 | Rozsah prvej bety | Jeden funkčný spis, obnovenie po reštarte, prehľad a obmedzený marketplace; bez veľkej migrácie a automatického výpočtu lehôt | MČ s tímom | Akceptácia a poradie práce |
| D2 | Jeden kontrakt a autorita súborov | Typované záznamy sú autorita pre fakty/úlohy/udalosti; index a označené časti statusu sú projekcie; metadata spisu nesmú duplicitne vlastniť rovnaký údaj | MČ + VŘ | OKF, dashboard, migrácia |
| D3 | Kanonické názvy a kompatibilita | Existujúce názvy nemeníme plošne. Určiť názov klientského markeru a kancelárie; staré mená čítať cez explicitný kompatibilný režim, nový zápis má jeden formát | MČ + VŘ | Zakladanie a detekcia scope |
| D4 | Vrstvy a zápis | L1 pravidlá/poučenia kancelárie, L2 klient/spis, L3 zdieľateľné pramene; rutinný zápis bez novej ceremónie, presné podmienky poverenia oddelene | MČ + VŘ; právne použitie kontroluje príslušný advokát | Protokol agentov a settings |
| D5 | Lehoty | Prvá beta zobrazuje evidované dátumy so zdrojom. Chýbajúce potvrdenie nesmie zmeniť na „potvrdené“. Určiť jeden nosič, zrušiť povinný dvojitý zápis | MČ + VŘ | Timeline a validácia |
| D6 | Typy vecí | Oddeliť druh veci od typu pamäťového záznamu. Minimálny rozsah pokryje spor aj poradenskú/zmluvnú vec; konkrétny zoznam potvrdiť | MČ + VŘ | Šablóny a testovacie scenáre |
| D7 | Profil kancelárie | Jeden verzovaný profil s jurisdikciou, podpriečinkami, rolami priečinkov a nomenklatúrou; systémové názvy pevné | MČ + MF + VŘ | Onboarding → nový spis |
| D8 | Spustenie MCP | Zvoliť pre malú defaultnú sadu lokálny runtime alebo konkrétne používateľom spravované remote pripojenie; žiadne implicitné použitie osobných endpointov MČ | MČ + MF | Skutočné pripojenie po inštalácii |
| D9 | Merge a vydávanie | Bežná schválená funkcia: iný človek prevezme PR + automatické kontroly. MČ rozhoduje spoločné kontrakty, zásahy do upstreamu a vydanie | MČ s tímom | Pravidlá práce agentov |
| D10 | Podporované platformy bety | macOS a Windows podľa preukázaných buildov/testov; prípadné zúženie verejne označiť a vedome rozhodnúť | MČ s tímom | Release akceptácia |
| D11 | Identity, updater a dátový profil | Potvrdiť správanie vedľa LegalWorku, používaný appId/protokol a update kanál. Identitu nemení náhodný branding PR | MČ + release gestor | Distribúcia mimo vývojárov |

**Názov OKF, úplné premenovanie stromu a všetky budúce taxonómie nemusia blokovať čítačku.** Spoločné pole, ktoré už budú ukladať nové spisy, však musí byť uzavreté pred ich vytváraním. Pri `EVENT_KINDS` už treba zachovať čítanie starých hodnôt; append-only históriu neprepisovať len kvôli jazyku enumu.

### Ako spracovať otvorené návrhy bez ďalšej duplicity

- [PR #64](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/64): spec 0014 má vlastniť kontrakt, spec 0015 dashboard/presety. Vyriešiť konflikty a odstrániť už zamietnuté brány z normatívnych častí; pôvodný návrh zachovať v histórii.
- [PR #67](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/67): zakladanie, retrofit a profily; odkaz na kontrakt 0014, bez jeho kópie.
- [PR #74](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/74): používateľská cesta; upraviť starý zoznam zdrojových súborov, doplniť stav dokončenia a odkaz na 0015. Zachovať autorstvo MF.
- [PR #55](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/55): zosúladiť rozširujúcu UI vrstvu s existujúcimi settings a aktuálnym dizajnovým rozhodnutím.
- [PR #54](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/54): uzavrieť proces spolupráce; nový plán je podklad, nie druhá sada záväzných pravidiel.
- [PR #56](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/56): vyriešiť pravidlo pre opencode bump skôr, než sa taký bump zaradí do práce. Dovtedy platí červená zóna.
- Staré implementačné PR #15/#14/#13 posúdiť podľa aktuálneho diffu. Nezatvárať cudzie návrhy iba podľa názvu; duplicitu potvrdiť porovnaním výsledného správania.

## 4. Technická architektúra, ktorú odporúčam

### 4.1 Spoločné jadro, tenké adaptéry

```text
Advokát: onboarding / spis / prehľad / nastavenia
                         │
Existujúci React shell a LAWOSS komponenty
                         │ workspace ID + oprávnený scope
Existujúci autentifikovaný LegalWork server
                         │ malý LAWOSS adaptér
         ┌───────────────┴────────────────┐
     OKF vytváranie                  OKF pamäť
  plan / apply / validate     read / write / validate / sync
         └───────────────┬────────────────┘
                 Jednotný kontrakt
                         │
       Prenosný priečinok klienta/spisu + memory/

Vývojový alebo produktový agent → CLI/skill → tie isté operácie
Dashboard ← čítací model ← súbory; dashboard nevymýšľa fakty
```

Nezlúčiť oba balíky do veľkého monolitu iba preto, že sa zjednocuje formát. Zachovať zodpovednosti: jeden vytvára štruktúru, druhý spravuje pamäť. Spoločná inicializácia ich spojí a spoločné testy potvrdia kompatibilitu. Až konkrétna duplicita odôvodní malý zdieľaný modul.

### 4.2 Súbory a zodpovednosti

| Vrstva | Existujúce miesto | Navrhovaná zmena |
|---|---|---|
| Plánovanie štruktúry | `lawoss/okf/src/core.ts`, `fs.ts`, `templates.ts`, `templates/**` | Profil, jurisdikcia, kanonické markery, neprepisovanie existujúcich súborov |
| Pamäť a projekcie | `lawoss/okf-pamat/src/{schema,store,record,render,validate,config,write,cli}.ts` | Kompatibilita, spoločná inicializácia, ohraničený scope, diagnostika |
| Čítací model | navrhované `lawoss/okf-pamat/src/read.ts` | Čistá projekcia existujúcich záznamov a problémov do dát pre UI |
| Server adaptér | nový LAWOSS modul pri serveri, napr. `apps/server/src/lawoss/okf.ts` | Overiť workspace a scope, zavolať knižnicu, vrátiť výsledok. Registrácia v `server.ts` je žltý zásah |
| Prenos a hook | `apps/app/src/lawoss/okf/connection.ts`; nové súbory pri tomto adaptéri | Načítať snapshot, obnoviť po zmene, otvoriť zdroj v existujúcom file/artifact paneli |
| Nový spis | `apps/app/src/lawoss/domains/novy-spis/novy-spis-page.tsx` | Skutočný plán; odovzdanie skillu; overiť vytvorenie a ponúknuť otvorenie |
| Onboarding | `domains/onboarding/*`, upstream `welcome-route.tsx` | Profil + register dokončenia, obnovenie zo skutočného stavu |
| Prehľad a timeline | `domains/prehlad/*`, `domains/lehoty/*` | Jeden vybraný spis a údaje z rovnakého snapshotu |
| Marketplace | `domains/marketplace/{catalog,marketplace-page}.tsx/ts` a existujúci plugin importer | Reálne metadáta, konkrétny pin, existujúca inštalácia a diagnostika |
| Build | `pnpm-workspace.yaml`, príslušné package manifests, server build | Zahrnúť balíky s definovanými JS/type exports a dependency spotrebiteľa; overiť import v zostavenom artefakte |

Nové cesty sú návrhy umiestnenia; presný diff vznikne v pláne príslušnej úlohy. Registrácia servera, dependencies, router, locale a workflowy majú jedného integrátora naraz. Každý zmenený upstream súbor sa zaznamená do `PATCHES.md`. `apps/server/src/extensions/` a LegalMemory sa týmto plánom neotvárajú.

### 4.3 Kontrakt čítačky

Nadviazať na `OkfDashboardSnapshot` zo spec 0015, nezavádzať tretí konkurenčný názov a tvar. Pre prvú verziu konkretizovať jeho podmnožinu:

- Kontext: `workspaceId`, relatívny identifikátor spisu a `jurisdiction`. Cesta kancelárie nie je automaticky totožná s cestou workspace.
- `revision` z čítaných súborov, `generatedAt` a diagnostika úplnosti. Pri zmene obsahu počas čítania opakovať čítanie alebo označiť snapshot ako nestabilný.
- Identita, fakty/záznamy, úlohy, otázky, udalosti a evidované termíny.
- Každá položka: stabilné ID, zdrojový súbor, locator dostupný z parsera, revízia zdroja a pôvod stavu. Ak locator chýba, odkaz na celý súbor; nevymýšľať číslo riadku.
- Oddeliť **technicky validné**, **pochádza od agenta** a **potvrdené advokátom**. Úspešný parser ani test nie sú právna verifikácia.
- Chybný záznam sa objaví v diagnostike s cestou a dôvodom. Nula údajov pri chybe nesmie vyzerať ako prázdny spis. Surový markdown zobrazovať cez existujúci bezpečný renderer bez vykonávania vloženého HTML/scriptov.

**Hranica prístupu:** endpoint prijíma identifikátor registrovaného workspace a relatívny spis. Cestu vyhodnotí na serveri, overí reálnu cestu vrátane symlinkov a povolené korene. Jednoduché `startsWith` nestačí. Pamäť klienta a kancelárie môže čítať len v explicitne oprávnenom scope; prechod k rodičom nesmie nepozorovane rozšíriť prístup.

### 4.4 Zápis a dokončenie úlohy

Zápis aj zobrazený plán musia používať rovnakú deterministickú operáciu. Dnešný náhľad zostavený z formulára je orientačný; nepozná konflikty na disku. Reálny plán musí pomenovať vytvárané, zachované a konfliktné súbory.

V prvej integrácii zachovať cestu cez existujúci skill/CLI a session. Výsledok overovať čítačkou a validátorom, nie poslednou vetou agenta. Ak sa agent zastaví, UI ukáže rozpracovaný stav a možnosť pokračovať; nesmie označiť vytvorenie za úspešné. Opakované pokračovanie musí byť idempotentné. Konflikt počas zápisu vyvolá nový plán nad aktuálnymi súbormi.

Nepísať nový univerzálny orchestrátor. Ak je potrebný malý štruktúrovaný výsledok CLI, definovať ho v konkrétnej úlohe a testovať úspech, čiastočný zápis aj chybu. Bežné aktualizácie pamäte nesmú znovu zaviesť zamietnuté potvrdzovanie každej zmeny.

**Dôležitá hranica:** validačná knižnica nevie zabrániť agentovi s voľným Bash prístupom, aby prepísal súbor priamo. Pre prvú betu presne opísať dôveryhodný lokálny režim a skutočne vynucované oprávnenia harnessu. Tvrdenie „agent si nemôže sám dať poverenie“ musí mať technický dôkaz; zákaz v prompte takým dôkazom nie je. Ochrana konania navonok patrí konkrétnemu nástroju a autorizačnej hranici.

### 4.5 Obnova a live dashboard

Prvá verzia: načítať pri otvorení spisu, po návrate z asistenta, po dokončení známej operácie a po návrate fokusu. Doplniť tlačidlo Obnoviť a zobraziť čas posledného úspešného načítania. Pre priebežné aktualizácie navrhujem polling iba viditeľného aktívneho spisu, napr. každých 5 sekúnd; interval je cieľ na zmeranie, nie dnešná vlastnosť.

Pri výpadku ponechať posledný snapshot označený ako neaktuálny. Po prepnutí spisu zrušiť starý request a neprepísať ním nový kontext. Sledovanie súborov doplniť až keď meranie ukáže potrebu; nevytvárať rekurzívny watcher nad celým cloudovým diskom. Do prvej bety nepatrí vektorová databáza ani nový vyhľadávací server.

### 4.6 Prenositeľnosť a migrácia

Zdieľaný formát je dôležitejší než fyzické spojenie balíkov. Súčasné Node/Bun rozdiely vyriešiť balením a testom konkrétneho release runtime. Funkčnosť v node teste nedokazuje funkčnosť v serverovom bun bundle. Skill mimo LAWOSS musí vedieť zavolať dokumentované CLI; v aplikácii nemá advokát ručne inštalovať vývojové závislosti.

Konkrétne: server má TypeScript `rootDir: src`, pamäť exportuje surový `.ts` mimo tohto koreňa a zakladací balík nemá vlastné `exports`. Navrhujem buildovateľné lokálne balíky s JS a typmi, explicitnou dependency servera a testom importu po zostavení. Alternatívou je existujúci serverový bundler s doloženou podporou týchto zdrojov; nestačí iba pridať riadok do `pnpm-workspace.yaml`. Pribaliť aj vykonateľný pamäťový CLI a testovať runtime, ktorý bude skutočne v desktopovom balíku. Node 18/20 ani Windows podporu nevyhlasovať iba z testov na Node 24.

Alternatíva pre neskorší krok: UI zavolá deterministické serverové `plan/apply` nad tým istým jadrom, ktoré používa CLI. Tým sa odstráni závislosť zakladania na dostupnosti modelu. Táto voľba však mení dnešnú cestu cez agenta a musí sa vecne zosúladiť s PR #74; prvá beta môže zachovať skill/session cestu s reálnym plánom a overením výsledku. Obe cesty nesmú vytvoriť dve implementácie zápisu ani nový univerzálny schvaľovací systém.

Najprv overiť úplne nový spis a jeden syntetický starý spis. Migrácia reálneho archívu je samostatná úloha: kópia → inventár → plán zmien → transformácia → kontrola rozdielov → prevzatie. Zachovať originály, staré ID a históriu; neznáme polia nestratiť. Zdieľaný cloudový priečinok neznamená vyriešené súbežné zápisy z viacerých počítačov. Beta má mať explicitne obmedzený režim zapisovania, kým sa táto situácia neotestuje.

## 5. Marketplace ako tri oddelené veci

1. **Balík:** skill, manifest, návod a verzia v `lawoss-marketplace`.
2. **Runtime/pripojenie:** lokálny proces alebo používateľom zvolený remote endpoint s vlastnou autentifikáciou.
3. **Schopnosť:** až úspešné inicializovanie, zoznam nástrojov a malý read-only test znamenajú, že vie urobiť sľúbenú úlohu.

Použiť existujúci `claude-plugin-bundle.ts` a `installCloudPlugin` namiesto ďalšieho inštalátora. Katalóg musí odkazovať na správny podpriečinok pluginu v konkrétnej revízii; import celého monorepa bez výberu plugin rootu môže vybrať nesprávny balík. Pin inštalácie naviazať na skutočne načítanú revíziu, nie iba na popisný tag v UI.

Stavy pre používateľa: **dostupné → balík nainštalovaný → treba nastaviť → pripojené → overené fungovanie / chyba**. Verifikácia má dátum a rozsah; historická úspešná kontrola nie je dnešné zdravie servera. Aktualizácia skillu automaticky neaktualizuje samostatne nasadený server.

Pre betu vybrať jeden užitočný skill a po jednom merateľnom read-only scenári pre SK/CZ. Konkrétne registre a spôsob nasadenia určí D8. Ak sa lokálne procesy ukážu drahé, najprv obmedziť aktívnu sadu a merať štart/stop; výstavba jednotného gateway endpointu je osobitné rozhodnutie, nie rýchla náhrada inštalácie.

Pamäť merať rovnakým postupom: čistý štart appky, workspace, modelové pripojenie, jedna a potom viaceré integrácie; zaznamenať platformu, verzie a procesný strom. RSS/working set nie sú medzi OS priamo porovnateľné. Cieľ okolo 4 GB z callu nie je nameraná vlastnosť. Číslo RAM v katalógu musí byť meranie s podmienkami alebo jasne označený odhad.

## 6. Pracovné balíky a poradie

ID nižšie sú lokálne označenia plánu, nie založené GitHub issues. Odhadnúť ich až po prvom overenom priechode; nedeliť ich na umelé päťminútové úlohy.

| Balík | Výstup, ktorý sa dá samostatne prevziať | Závisí od | Navrhovaný gestor | Preberá |
|---|---|---|---|---|
| W0a | Zelená báza samostatných testov a reprodukcia chýb spoločného scenára | žiadne | MČ + integrujúci agent | iný člen tímu |
| W0b | Vynucované CI a jasné pravidlo pre merge | D9, W0a | MČ + integrujúci agent | iný člen tímu |
| W1 | Minimálny kanonický kontrakt + spoločné SK/CZ fixtúry | D2–D6 | VŘ + MČ | MČ/VŘ krížovo |
| W2 | Nový spis vytvorí pamäť kompatibilnú so sync/validate | W0a, W1 | VŘ; MČ pre šablóny | MF + doménový test MČ |
| W3 | Čítací model a autentifikovaný adaptér servera | W0a, W1 | MČ + integrujúci agent | VŘ |
| W4 | Profil kancelárie a obnoviteľný onboarding | D7, W1 | MF | MČ |
| W5 | Nový spis: plán, vykonanie cez skill, overený výsledok | W2, W3, W4 | MF; MČ pre používateľskú cestu | VŘ |
| W6 | Reálny prehľad jedného spisu + timeline + zdroje | W3 | MČ + UI agent | MF + VŘ pre CZ |
| W7 | Reálny marketplace a jedna overená cesta inštalácie | D8; W0a, W0b pred merge | MF, obsah MČ | VŘ |
| W8 | Build kandidáta, macOS/Windows scenáre, RAM, návrat na predchádzajúci build | W5, W6, W7 | release gestor určený MČ | človek na druhom stroji |

MF nemá súčasne implementovať W4, W5 aj W7 ako tri rozbehnuté vetvy. Buď ich zoradí, alebo MČ pridelí jedného AI pracovníka ku konkrétnej úlohe a MF preberá jeho výsledok. Pri obmedzenej dostupnosti IR ho nezaraďovať do kritickej cesty; Windows test musí mať dostupného náhradníka alebo sa obmedzí podporovaná platforma.

**W0b je spoločná podmienka merge implementačných balíkov do `dev`.** Kód v izolovaných vetvách a read-only práca môžu napredovať podľa uzavretých závislostí. Zlyhávajúci spoločný scenár z W0a sa stane zeleným regresným testom v W2; W0a nepredstiera, že už je integrované jadro funkčné.

### W0 — stabilná báza

- [ ] Zvoliť konkrétny `dev` SHA; porovnať všetky lokálne opravné vetvy a otvorené PR, nič neprepnúť naslepo.
- [ ] Nadviazať na zelené kontroly presného `dev` SHA a doplniť chýbajúci spoločný test oboch OKF nástrojov. Opakovať dotknuté kontroly po zmene; prípadnú novú regresiu opraviť pred ďalšou funkciou.
- [ ] Rozšíriť spúšťanie OKF CI aj na feature základy stohovaných PR, aby testy neboli vynechané iba kvôli názvu cieľovej vetvy.
- [ ] Zapísať minimálne required checks a ich skutočné názvy: dnešné `legalwork-tests (ubuntu-latest)`, `legalwork-tests (macos-14)`, `i18n-audit`; pre OKF najprv vytvoriť vždy prítomnú súhrnnú kontrolu, ktorá na relevantnej zmene vykoná testy. Path-filtered job nemožno bez úpravy vyžadovať aj na PR, kde sa vôbec nespustí. Zmenu ochrany a vynútenie aj pre administrátorov vykonať v schválenom D9.
- [ ] Overiť zostavenie servera s balíkmi OKF vrátane JS/type exports a dependency spotrebiteľa; rozsah runtime podpory zaznamenať.

### W1/W2 — spoločný spis

- [ ] Napísať malú tabuľku „údaj → autoritatívny súbor → projekcia → kto smie meniť“.
- [ ] Pripraviť nový SK spis a nový CZ spis, jeden spor a jednu zmluvnú/poradenskú vec, bez klientskych dát.
- [ ] Zmeniť šablóny: jurisdikcia, používateľ z profilu, klientský marker, pamäť, generované markery, AGENTS/CLAUDE mirror.
- [ ] Overiť sled `plan → apply → memory init/write → validate → sync → druhý sync` na tom istom priečinku. Druhý sync nesmie vytvárať ďalšie zmeny.
- [ ] Testovať zmenu dvakrát v ten deň, starú hodnotu enumu, neznáme pole, konflikt a poškodený záznam.
- [ ] Existujúci spis iba kontrolovať alebo migrovať v explicitnom režime; bežné otvorenie ho neprepisuje.

### W3/W6 — dáta a zobrazenie

- [ ] Vytvoriť čítací kontrakt a rovnakú fixtúru zdieľať medzi jadrom, serverom a UI.
- [ ] Na serveri odmietnuť nepovolený scope, súrodeneckú cestu s rovnakým prefixom a symlink mimo oprávneného koreňa.
- [ ] V UI spraviť prázdny, načítavací, čiastočný, chybový a neaktuálny stav skôr než sa zaplnia registre.
- [ ] Každý údaj otvára svoj skutočný zdroj; potvrdenie sa nezískava len zo zelenej validácie.
- [ ] Zmeniť markdown mimo appky, obnoviť pohľad a overiť výsledok. Pri prepnutí spisu sa nesmú premiešať dáta.
- [ ] Až po tomto odstrániť pevné demo údaje z príslušnej funkčnej route; demonštračné fixtures zostávajú jasne oddelené.

### W4/W5 — používateľská cesta

- [ ] Onboarding ukladá profil a overuje pripravenosť priečinka, modelu a voliteľných rozšírení osobitne.
- [ ] Po prerušení zistí skutočný existujúci workspace; nevytvorí jeho duplikát a nevyhlási dokončenie len podľa `localStorage`.
- [ ] UI ukáže reálny plán vrátane konfliktov. Agent dostane presný cieľ a existujúce CLI.
- [ ] Úspech sa potvrdí čítačkou a validáciou. Tlačidlo otvorí výsledný spis a jeho zdroje.
- [ ] Overiť názvy s diakritikou, medzerami a Windows cestami, opakované kliknutie, výpadok modelu a servera.
- [ ] Nové obrazovky používajú upstream komponenty; nový shell ani celý redesign nie sú súčasť tejto práce.

### W7 — balík a pripojenie

- [ ] Nahradiť demo katalóg skutočnými položkami, pinmi a podpriečinkami.
- [ ] Import vykonať existujúcou serverovou cestou; zobraziť presný rozsah zmien a výsledok.
- [ ] Pre vybraný default dokončiť runtime alebo manuálne pripojenie; nepoužiť osobný endpoint z pracovného stroja autora.
- [ ] Overiť inštaláciu, opakovanie bez duplicít, chybný pin, nedostupný endpoint, vypnutie a odstránenie bez zmazania cudzích skills.
- [ ] V samostatnom integračnom teste s testovacími oprávneniami overiť inicializáciu, `tools/list` a jeden čítací scenár.

### W8 — kandidát na vydanie

- [ ] Opraviť alpha manifesty macOS/Windows, ktoré stále zostavujú download URL do `eigenweltlabs/legalwork`, hoci upload ide do forku. Presmerovanie runtime feedu samo túto chybu nerieši.
- [ ] Zostaviť konkrétny SHA a označiť build, runtime a platformu. Na review použiť lokálne artefakty alebo vedome nastavený `Release App` s `draft=true` a `publish_npm=false`; samostatne posúdiť publikovanie sidecarov. Súčasné Alpha workflowy vytvárajú verejné prereleases a menia rolling pointer, preto ich nespúšťať ako domnelý súkromný test. Aj `Release App` môže pri `draft=false` publikovať.
- [ ] Prejsť celú používateľskú cestu na stroji iného člena tímu, vrátane reštartu.
- [ ] Overiť produktovú identitu, prístup k dátam a správanie vedľa LegalWorku. Skontrolovať aj odkazy v `electron-alpha.ts`, `electron/main.mjs` a loading overlay: presmerovať na LAWOSS alebo doložiť účelnú výnimku.
- [ ] Pred zapnutím distribučného kanála overiť HTTP 200 manifestu, správne URL assetov forku a zhodu hashov. Pre stable kanál ide o `lawoss.app/update/latest-mac.yml` a funkčný GitHub fallback; pre alpha jeho samostatný pointer. Súkromný draft automaticky nespĺňa verejnú updater cestu. Prvý kandidát musí prejsť čistou inštaláciou; in-place update overiť až s dvoma po sebe idúcimi testovacími verziami.
- [ ] Priložiť výsledky výkonu a známe obmedzenia. Nesplnený zásadný scenár znamená užší rozsah alebo odklad vydania.
- [ ] Vydanie schváli MČ. Návrat binárky a obnova dát sa posudzujú osobitne; starší build nesmie otvoriť nekompatibilne migrovaný spis bez kontroly.

## 7. Ako spolupracujú advokáti a AI

### Ľudské roly — návrh na potvrdenie

| Rola | Zodpovednosť | Čo nemusí robiť |
|---|---|---|
| **MČ — koordinátor produktu a integrácie** | Priorita, rozsah, rozhodovací register, spoločné rozhrania, spisový UX, finálne vydanie | Ručne písať kód a schvaľovať každý bežný interný krok agenta |
| **VŘ — gestor OKF a dátového správania** | Kontrakt, pamäť, CZ prípady, kritické testy, review read modelu | Rozhodovať za MČ o celom produktovom rozsahu |
| **MF — gestor onboardingu a rozšírení** | Prvá používateľská cesta, marketplace, integrácie a metodika merania | Paralelne vlastniť všetky rozpracované implementácie |
| **IR — doménové prevzatie a pilot podľa dostupnosti** | SK scenáre, nezávislé prevzatie, prípadne Windows | Byť neohlásenou povinnou závislosťou každého PR |

Každá úloha má **gestora aj konkrétneho preberajúceho človeka ešte pred štartom**. Pri neprítomnosti sa náhradník zapíše do issue. Rozdelenie vyššie nadväzuje na doterajšie príspevky, ale je návrh, nie tvrdenie, že kolegovia prijali nové záväzky.

### AI roly

| Agent | Vstup | Výstup | Obmedzenie |
|---|---|---|---|
| Koordinujúci/technický | Stav repa, schválené rozhodnutia, závislosti | Malé issues, návrh rozhraní, prehľad blokátorov a integrácie | Nemení produktový rozsah bez rozhodnutia |
| Implementujúci | Jedno issue, base SHA, povolené súbory, kontrakt, akceptačné scenáre | Kód, relevantné testy, lokálny build, PR podklad | Jeden vlastník zápisu; neotvára susedné iniciatívy |
| Recenzujúci | Zadanie a skutočný diff, nezávislý kontext | Konkrétne chyby, reprodukcia a posúdenie kritérií | Prvý priechod iba číta; nepovažuje autorovo zhrnutie za dôkaz |
| Overovací | Konkrétny build a scenár | Výsledok, screenshot/video, log bez tajomstiev | Testuje výsledné správanie, nie iba vzhľad |

Na jednoduchú opravu stačí implementujúci agent, existujúca kontrola a človek, ktorý preberie zmenu. Pri kontrakte, migrácii, autorizácii, update mechanizme a súbežnom zápise pridať nezávislé technické review. Druhý model alebo harness môže odhaliť iné chyby, ale nezaručuje nezávislosť úsudku; rozhodujú reprodukovateľné dôkazy.

V aktuálnom Codex prostredí možno uplatniť vaše preferované roly: Luna na úzky prieskum, Terra na bežnú implementáciu, Sol na zložitejšiu integráciu, Astra na jedno ohraničené posúdenie zásadnej neistoty. Je to pracovná voľba podľa úlohy, nie benchmark alebo prísľub ceny. Ak koordinátor už používa Astru, druhá Astra na rovnakú otázku nepridáva automaticky hodnotu.

### Dva rôzne druhy agentov

**Vývojoví agenti** pracujú s repozitármi, syntetickými fixtúrami a testovacími účtami. **Agenti v produkte LAWOSS** pracujú v oprávnenom spise používateľa. Ich oprávnenia a dáta sa nemiešajú. To, že vývojový agent vie upraviť kód, neznamená, že produktový agent smie odoslať podanie alebo meniť nastavenia oprávnení.

Žiadny univerzálny zákaz/allowlist v markdown pokynoch sám netvorí sandbox. Technické hranice sa musia opierať o reálne možnosti servera, operačného systému a konkrétneho harnessu.

## 8. Pravidlá práce naprieč repozitármi a harnessmi

### Jedna stopa úlohy

```text
Koordinačný spec/ADR + záznam schválenia
                  ↓
Issue vo forku: gestor, reviewer, závislosti, akceptácia
                  ↓
Samostatná vetva a worktree, jeden implementujúci agent
                  ↓
Testy + nezávislé review + konkrétne demo
                  ↓
Ľudské prevzatie + povinné CI → merge do dev
                  ↓
Spoločný build → akceptácia kandidáta → rozhodnutie o vydaní
```

- Rozhodnutia a UX specy zostávajú v `lawOSS-like-SK-CZ`; implementačné issue/PR v `lawoss`; distribučné metadáta v `lawoss-marketplace`; kód MCP v jeho vlastnom repe.
- Jeden malý GitHub Project môže prepojiť issues z týchto repozitárov. Pre začiatok stačia aj labels a milestone; nevytvárať nový vlastný systém na riadenie agentov.
- Stavy: **návrh → čaká na rozhodnutie → pripravené → implementácia → review → akceptácia → hotovo**. Blokátor je atribút s dôvodom a vlastníkom. „Hotovo“ znamená prijaté správanie v integrovanom builde, nie otvorený PR.
- Povinné údaje issue: gestor, reviewer, rozsah súborov, závislosti, schválený zdroj, cieľový míľnik, odkaz na dôkazy. Krátky denný prehľad sa odvodzuje z issues; neudržiavať ďalší ručne kopírovaný backlog v piatich súboroch.
- Základ je vždy aktuálny schválený `origin/dev` SHA. Používateľov otvorený lokálny checkout môže byť iná vetva.
- **Jedna worktree na jednu píšucu úlohu.** Codex, Claude Code či iný harness nesmú naraz meniť tú istú worktree. Recenzent môže čítať oddelenú revíziu.
- Paralelizácia je bezpečná až po dohodnutí rozhrania. UI môže začať nad schválenou testovacou fixtúrou, ale do funkčnej časti sa prijme až s reálnym adaptérom.
- Zdieľané súbory (schema, router, server registrácia, manifests, lockfile, tokeny, CI) má počas integrácie jedného vlastníka. Ostatní mu odovzdajú požiadavku alebo zmenu zaradia do vlastného PR po jeho merge.
- Stohované PR používať len pri skutočnej závislosti. Po merge rodiča explicitne skontrolovať cieľ ďalšieho PR a spustenie kontrol. Dôvodom je reálna skúsenosť #35 → #37.
- Po zmene base vetvy alebo relevantnej časti diffu zopakovať dotknuté kontroly. Zelený test iného SHA sa neprenáša automaticky.
- V koreňoch držať `AGENTS.md` a `CLAUDE.md` totožné. Dlhé pravidlá spolupráce iba odkazovať na schválený playbook; nešíriť jeho kópie.

Codex podporuje izolované worktrees a zdieľateľné setup skripty pre lokálne prostredia. Odporúčam v nich jednotné inštalovanie z lockfile a projektové akcie na test/server/build; tajomstvá sa do gitu ani automatického kopírovania pracovných stromov nedávajú. Iné harnessy používajú tie isté git pravidlá a projektové príkazy. [Oficiálne worktrees](https://learn.chatgpt.com/docs/environments/git-worktrees), [lokálne prostredia](https://learn.chatgpt.com/docs/environments/local-environment), [AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md).

### Prvý briefing implementujúceho agenta

```text
Úloha: W3 — čítačka jedného spisu a serverový adaptér.
Gestor a človek, ktorý preberá: uvedení v issue.
Zdroj: schválená revízia spec 0014/0015 a rozhodnutia D2–D5.
Báza: konkrétny SHA origin/dev uvedený v issue.

Najprv načítaj AGENTS.md/CLAUDE.md a over git status, base SHA,
otvorené PR a existujúce API. Navrhni najmenší potrebný diff.
Použi existujúci parser a autentifikáciu servera. Nové rozhranie
musí zodpovedať schválenému snapshotu a spoločnej fixtúre.

Akceptácia: SK/CZ spis, chybné YAML, chýbajúca pamäť, odkaz na zdroj,
odmietnutie nepovoleného scope; čítanie nesmie meniť žiadny súbor.
Presný zoznam povolených ciest a príkazov priloží issue po D2–D5.
Nemeň red zone, podpisovanie, deployment ani klientske dáta.
Pri konflikte kontraktu označ rozhodnutie, ktoré potrebuje gestor;
pokračuj iba nezávislou prácou v schválenom rozsahu.

Odovzdaj diff, presné testy a výsledky, limity, screenshot pri UI,
PATCHES.md pri upstream zásahu a krátky návod na prevzatie.
Vytvor lokálny commit a podklad PR; push/PR/merge podľa rozsahu
výslovného poverenia v issue. Žiadne automatické odosielanie správ.
```

Tento briefing je vzor pre zadanie po rozhodnutí o kontrakte. Konkrétny vykonávací plán jedného balíka musí obsahovať presné súbory, rozhrania a testy; nevymýšľať ich dopredu pre ešte neschválené rozhrania.

### Briefing recenzenta a odovzdanie

Recenzent dostane issue, schválený spec, base/head SHA a diff. Požiadavka: „Nájdi nedodržané kritériá a reprodukovateľné chyby; prioritizuj stratu dát, cesty/scope, nepravdivé potvrdenie, runtime/bundle a zlyhania obnovy. Rozlišuj nález od otázky. Bez úprav a bez zmeny rozsahu.“

Odovzdanie po každom prerušení: **cieľ; repo/vetva/base/head; dokončené; zostávajúce; testy s výsledkom; rozhodnutia a povolenia; blokátor; najbližší krok**. Nový agent číta tento krátky záznam a odkazy, nie celú históriu rozhovorov. Dve neúspešné opravy rovnakého problému sú dôvod na reprodukciu a diagnostiku v čerstvom kontexte, nie na nekonečné opakovanie promptu.

## 9. Ako advokát preberie technickú prácu

Človek nemusí rozumieť každému riadku TypeScriptu. Musí dostať spustiteľný výsledok a vedieť overiť: **čo som zadal, čo vzniklo, kde je zdroj, čo sa stane pri chybe a či sa zachovali moje dáta**.

Každý funkčný PR má krátky recept: vstupný testovací priečinok, 3–7 krokov, očakávaný výsledok a kontrolný súbor. AI review je technická pomoc; GitHub approval vykoná oprávnený človek, nie agent vydávajúci sa za nezávislého kolegu.

| Scenár | Čo overuje človek | Čo musí automaticky overiť test |
|---|---|---|
| Nová kancelária | Zrozumiteľnosť a správne umiestnenie dát | Profil, reštart, žiadny duplikovaný workspace |
| Nový SK/CZ spis | Správny obsah a názvoslovie | Rovnaká inicializácia a kompatibilita jadier |
| Zmena faktu | Nový stav a dohľadateľná história | Zmena dvakrát v deň, append-only história, konflikt |
| Markdown upravený mimo appky | Prehľad sa obnoví a ukáže zdroj | Invalidácia, nevymiešanie spisov, chybný súbor |
| Termín | Viditeľný dátum, pôvod a neistota | Žiadne automatické potvrdenie alebo vymyslený výpočet |
| Inštalácia pluginu | Vie, čo sa nainštalovalo a čo ešte treba | Pin, podpriečinok, idempotencia, chyba a odstránenie |
| Reštart/výpadok | Pokračuje bez straty a falošnej hlášky hotovo | Persistencia, obnova, čiastočný výsledok |
| Druhý počítač | Inštalácia bez vývojárskeho prostredia | Build a runtime závislosti pre danú platformu |

Čisto technické kontroly nemajú závisieť od živého modelu alebo registra. Sieťové a modelové scenáre sú samostatná sada s testovacími účtami a evidovaným dátumom. Právnu správnosť hodnotí advokát na očakávaných odpovediach a zdrojoch; nevyvodzuje sa z počtu zelených unit testov.

Pri nevysvetlenom náleze v autorizácii, migrácii alebo updateri si vyžiadať úzko zadané nezávislé technické posúdenie človekom so skúsenosťou s danou oblasťou. Nie je nutný pre každý bežný PR; je vhodný tam, kde tím nevie reprodukciou a kontrolami uzavrieť materiálnu neistotu.

## 10. Rytmus koordinácie

- **Krátke denné prevzatie:** gestor otvorí výsledok, prejde scenár, zapíše prijaté/vrátené/blokované. Navrhovaná rezerva 20–30 minút na gestora je pracovný predpoklad, nie zistená kapacita.
- **MČ raz denne:** súhrn len „čo dnes funguje v spoločnom builde, čo čaká na rozhodnutie, ktorý PR čaká na človeka, riziko míľnika“. Udržať najviac tri aktívne implementácie.
- **Spoločné demo 2× týždenne alebo po dokončení cesty:** ten istý build a tie isté fixtúry. Agentovo video môže pomôcť, ale nenahrádza prevzatie kolegom.
- **Rozhodovací call:** každý otvorený bod má odporúčanie, alternatívu a dopad. Výsledok sa zapíše do koordinačného repa; samotná správa v chate nezostane jediným zdrojom.
- **Čakanie na review:** po jednom pracovnom dni koordinátor určí dostupného preberajúceho. Neprítomnosť nie je súhlas.
- **Integrácia priebežne:** preferovať nezávislé malé PR do `dev`; žiadna dlhá integračná vetva, ktorá začne fungovať až večer pred vydaním.

## 11. Podmienený harmonogram a rozsah

### Ak zostáva 16. 9. cieľom

| Okno | Očakávaný výsledok | Kontrolný bod |
|---|---|---|
| 9.–10. 9. | W0, minimálne D1–D9, kontrakt a fixtúry | Jadro má zelenú bázu; žiadne paralelné nekompatibilné rozhrania |
| 10.–12. 9. | W2/W3, základ profilu, reálny katalóg | Jeden spis prejde od vytvorenia po čítanie |
| 12.–14. 9. | W4/W5/W6, jedna cesta rozšírenia | Kolega prejde celý scenár v integrovanej appke |
| 14.–15. 9. | Kandidát, druhý stroj, Windows, RAM a opravy | Nové features sa už nepridávajú |
| 16. 9. | Rozhodnutie o uzavretej bete | Len podľa dôkazov, s presným rozsahom a obmedzeniami |

Toto je ambiciózny cieľ, nie odhad podložený rýchlosťou tímu. **Ak 12. 9. neprejde spoločný spis end-to-end, treba zúžiť betu alebo termín posunúť.** Prvým výsledkom môže byť interná integračná alfa; netváriť sa, že splnila celý rozsah bety s marketplace a onboardingom.

### Ak termín nie je pevný

Plánovať dve pracovné iterácie: prvá kontrakt + nový spis + reálny prehľad; druhá obnovenie onboardingu + marketplace + platformy a kandidát. Dĺžku iterácie určiť po W0–W3 podľa skutočného času na review, opravy a testy. Vývoj AI môže byť rýchly, ľudské prevzatie a integračné chyby stále určujú priechodnosť.

### Rozšírenia po prvom funkčnom jadre

| Nasledujúca funkcia | Na čom stojí | Samostatný výsledok |
|---|---|---|
| Prehľad celej praxe a klienta | Stabilný snapshot + ohraničený zoznam oprávnených spisov | Súhrn bez dvojitého počítania klientských záznamov |
| Osobné dashboardové presety | Jeden dátový model, overené widgety | Presety zo spec 0015 menia kompozíciu; žiadna druhá evidencia faktov |
| Reconciliácia | Rozlíšené autoritatívne dáta a projekcie | Najprv deterministická obnova indexov/statusov; učenie z úprav dokumentov je ďalšia samostatná funkcia |
| E-mail/kalendár | Pripojenie účtu, evidencia udalosti, deduplikácia | Príjem → návrh záznamu/termínu → kontrola; odosielanie osobitne |
| Nomenklatúra a usporiadanie dokumentov | Profil kancelárie a plán súborových zmien | Náhľad premenovaní/presunov, návrat a kontrola odkazov |
| Migrácia existujúcich spisov | Kompatibilita a pilot na kópii | Jeden prevzatý skutočný spis, až potom dávka |
| Výpočet lehôt, AML workflow | Overené jurisdikčné pravidlá a odborné testovacie prípady | Oddelené SK/CZ správanie a zdroj rozhodnutia |
| Hlas, transkripcia, OCR | Existujúce upstream funkcie a test dokumentového toku | Najprv overiť upstream možnosť, potom dopĺňať konkrétnu medzeru |
| Podpisovanie, konverzia, anonymizácia | Príslušný schválený spec a samostatná odborná akceptácia | Nevkladať do bety nepriamo cez marketplace kartu |
| Benchmark právnych úloh | Stabilný build, testovacie prípady a hodnotiace kritériá | Verzionovaný výsledok modelu/harnessu; technické testy a odborná kvalita oddelene |

## 12. Čo konkrétne urobiť ako prvé

1. MČ z tohto podkladu vyberie rozsah bety a potvrdí dostupných gestorov/reviewerov.
2. VŘ + MČ uzavrú minimálnu tabuľku kontraktu a opravný základ W0. Súbežne MF pripraví návrh profilu a vybraného rozšírenia, bez implementovania vlastného dátového formátu.
3. Zosúladiť existujúce PR #64/#67/#74 a proces #54. Schvaľovať po zrozumiteľných častiach, nie jedným neurčitým odklepom všetkých starých dokumentov.
4. Založiť implementačné issues W2/W3/W4/W7 len s uzavretými závislosťami. Ku každému priložiť scenár a pomenovaného preberajúceho človeka.
5. Spustiť najviac tri oddelené implementácie. Po prvom výsledku odmerať, koľko práce zostáva na review a integráciu, a upraviť harmonogram.

## 13. Dôkazy a limity auditu

Tento dokument je návrh výstavby, nie potvrdenie pripravenosti na vydanie. Podrobnosti sú v [sprievodnom auditnom zázname](2026-09-09-audit-realizacie-lawoss.md). Neukladali sa klientske dáta, nemenili sa endpointy, oprávnenia repozitárov ani produkčné nastavenia. Žiadna implementačná úloha sa týmto automaticky nepridelila kolegom.

**Overené výsledky:** samostatné OKF testy 14/14 a pamäťové testy 415/415 prešli; spoločný syntetický scenár vytvorenie → inicializácia → sync zlyhal. GitHub Actions pre `ec0f4c1` majú zelené LegalWork testy na Ubuntu/macOS, OKF pamäť a i18n. Oprava `2c8db57` pre druhú zmenu v ten istý deň je už predkom `dev`; netreba ju znovu implementovať.

**Prevádzkové medzery:** ochrana `dev` vyžaduje jeden review, ale neobsahuje required status checks a nevynucuje sa pre administrátorov. Fork zatiaľ nemá GitHub release ani záznam o spustenom Alpha/Release workflow; update cesty pri kontrole vracali 404. To je chýbajúca prvá distribúcia, nie dôkaz poruchy existujúcej produkčnej služby. Alpha workflowy navyše obsahujú potvrdené upstream download URL. Podpisovanie, notarizácia, čistá inštalácia a aktualizácia ešte nemajú doloženú akceptáciu.

Použité zdroje:

- [Call 7. 9.](../meetings/2026-09-07-zapis-tyzdenne-stretnutie.md) a [dopady callu](2026-09-07-dopady-callu-na-okf-a-appku.md): rozhodnutia a vtedy otvorené otázky.
- [Doterajší playbook](../docs/playbook-spolupraca.md): návrh rolí a práce s agentmi; jeho status zostáva návrhový.
- [Pravidlá koordinačného repa](../AGENTS.md) a [pravidlá forku](https://github.com/Omni-Legal-Products/lawoss/blob/ec0f4c108e17c53152a01b327c57c1b59dfd69f2/AGENTS.md): platné pracovné hranice.
- [Reuse dizajnu LegalWorku](../docs/design/2026-08-27-dizajn-system-je-legalwork.md): existujúce miesta rozšírenia; historické tvrdenia o implementácii overovať proti kódu.
- PR #64/#67/#74/#54/#55/#56 odkazované vyššie: návrhy, nie automaticky schválené požiadavky.
- GitHub API a `git show origin/dev:<path>`: aktuálny kód, viditeľnosť a stav merge; lokálny checkout produktu bol na inej vetve, preto sa z neho nevyvodzoval stav `dev`.

Právne predpisy ani konkrétne subjekty sa v tomto technickom audite neposudzovali. Slov-Lex, judikáty a ORSR MCP neboli použité; pri implementovaní právnych pravidiel sa použijú podľa projektových pokynov. Potvrdenie funkčného MCP transportu samo nepotvrdzuje vecnú správnosť právnej odpovede.
