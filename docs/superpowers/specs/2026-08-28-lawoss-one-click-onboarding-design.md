# LAWOSS: one-click onboarding – návrh Fázy 1

**Dátum:** 28. augusta 2026  
**Stav:** schválený produktový návrh; implementácia ešte nezačala  
**Rozhodnutie:** onboarding môže mať viac krátkych obrazoviek. „One-click“ označuje jedno hlavné potvrdenie odporúčanej konfigurácie, nie jednu splash obrazovku.

## Cieľ

Technicky menej zdatný advokát má po prvom spustení bez znalosti pojmov ako provider, endpoint, MCP alebo workspace:

1. vytvoriť pracovné miesto,
2. vybrať AI model,
3. zrozumiteľne pochopiť hranice práce s dokumentmi,
4. otvoriť aplikáciu pripravenú na prvú skutočnú úlohu.

Odporúčaný cieľ je dostať používateľa od prvého spustenia k prvej úlohe približne do jednej minúty, ak je AI model už dostupný. Ak chýba oprávnenie, priečinok alebo model, aplikácia má zobraziť iba jeden konkrétny ďalší krok.

## Východisko v súčasnom forku

Súčasný fork už obsahuje potrebné stavebné prvky, ale používateľ ich prechádza ako dlhšiu sekvenciu:

- WelcomePage a WelcomeRoute vytvárajú lokálne pracovisko po výbere priečinka;
- onboarding v session-route.tsx zobrazuje výber AI modelu;
- template-workflows-step.tsx vie spustiť import šablón na pozadí;
- transcription-setup-step.tsx vie voliteľne nainštalovať Office doplnky a transkripčný model;
- po založení pracoviska sa vytvára prvá session.

Fáza 1 tieto funkcie nesupluje novým backendom. Zjednodušuje ich poradie, texty a rozhodnutia.

## Produktové rozhodnutia Fázy 1

- Povinnou súčasťou zostáva výber alebo autorizácia pracovného priečinka.
- AI model sa nevyberá potichu, ak by tým mohlo dôjsť k odoslaniu dokumentov k nejasnému poskytovateľovi.
- Šablóny, Office a transkripcia nesmú blokovať prvé použitie.
- Jurisdikcia Slovensko/Česko, automaticky vytváraný priečinok a jednotný bezpečnostný profil nie sú súčasťou Fázy 1.
- Existujúce správanie analytického súhlasu sa v tejto fáze nemení: používateľ ho vidí na úvodnej obrazovke a môže ho vypnúť.
- Pri pokračovaní sa používajú výrazy „pracovné miesto“, „priečinok s dokumentmi“, „AI model“ a „doplnky“; technické názvy zostávajú v pokročilých nastaveniach.

## Navrhovaný používateľský tok

### Rýchla cesta

Na úvodnej obrazovke je jedno dominantné tlačidlo:

> **Použiť odporúčané nastavenie**

Po jeho stlačení aplikácia:

1. otvorí výber pracovného priečinka, ak ešte nie je známy;
2. použije už pripojený a dostupný AI model, ak existuje;
3. ak model neexistuje, zobrazí obrazovku na jeho pripojenie;
4. vytvorí pracovisko a prvú session;
5. voliteľné doplnky spustí na pozadí;
6. otvorí pracovné okno s prvými návrhmi úloh.

Ak používateľ nechce odporúčané nastavenie, môže zvoliť **Skontrolovať nastavenia** a prejsť rovnaké voľby jednotlivo.

### Obrazovka 1: Začnime

Text má vysvetliť výsledok, nie funkcie:

> **Pripravme LegalWork na vašu prácu**  
> Nastavíme pracovný priečinok, AI model a základné doplnky. Väčšinu nastavení môžete neskôr zmeniť.

Zobrazí sa stručný súhrn toho, čo aplikácia vie nastaviť:

- pracovné dokumenty,
- AI model,
- ochrana pri úpravách súborov,
- Office a hlasová transkripcia, ak sú dostupné.

Primárne tlačidlo je **Použiť odporúčané nastavenie**. Sekundárne akcie sú **Skontrolovať nastavenia** a **Preskočiť na neskôr**.

### Obrazovka 2: Pracovné dokumenty

Nadpis:

> **Kde máte pracovné dokumenty?**

Primárna akcia použije priečinok vybraný v systémovom dialógu. Aplikácia vysvetlí:

> LegalWork bude pracovať so súbormi v tomto priečinku. Pred úpravou alebo odstránením súboru si vypýta potvrdenie.

Ak je možné bezpečne ponúknuť naposledy použitý priečinok, zobrazí sa ako odporúčaná voľba. Fáza 1 nevytvára nový predvolený priečinok bez súhlasu používateľa.

Pre desktop sa znovu použije existujúci výber priečinka. Pre web alebo vzdialené pracovisko zostáva existujúci formulár na pripojenie vzdialeného pracoviska.

### Obrazovka 3: AI model

Nadpis:

> **Vyberme AI pre vašu prácu**

Každá voľba má jednu vetu o použití a o dátovej hranici. Používateľ nemusí rozumieť technickému spôsobu pripojenia.

Poradie volieb:

1. **Použiť odporúčaný model** – predvyplnené, ak je model už pripojený a použiteľný;
2. **Pripojiť firemný model** – existujúci auth flow s vysvetlením, že údaje zadáva používateľ svojmu poskytovateľovi;
3. **Použiť skúšobný model** – iba ak je dostupný, s jasným upozornením, že nie je určený na klientské, privilegované ani spisové dáta;
4. **Nastavím neskôr** – iba vtedy, ak aplikácia má použiteľný fallback alebo môže pokračovať do pracoviska bez spustenia AI úlohy.

Pred potvrdením musí byť jasné, že dokumenty môžu byť odoslané iba k zvolenému modelu. Ak model nie je dostupný, onboarding nesmie predstierať, že aplikácia je pripravená na AI prácu; zobrazí stav **Vyžaduje pripojenie AI modelu** a jednu akciu **Pripojiť model**.

### Obrazovka 4: Doplnky

Nadpis:

> **Chcete si pripraviť aj doplnky?**

Ak zariadenie podporuje Word, Outlook alebo lokálnu transkripciu, aplikácia ich ponúkne ako voliteľné nastavenia. Používateľ môže stlačiť:

- **Nastaviť vybrané**;
- **Pokračovať bez toho**.

Inštalácia alebo sťahovanie môže pokračovať na pozadí. Chyba doplnku sa zobrazí ako stav na neskôr a nebráni otvoreniu pracoviska.

Import firemných šablón sa z kritickej cesty odstráni. Po prvom použití sa zobrazí nenásilná karta **Pridajte svoje šablóny a vytvorte pracovné postupy**.

### Obrazovka 5: Aplikovanie a dokončenie

Ak používateľ prešiel kontrolu nastavení, zobrazí sa súhrn:

- pracovné miesto: vybraný priečinok,
- AI model: názov a stručná dátová informácia,
- ochrana dokumentov: potvrdenie pred úpravou alebo odstránením,
- doplnky: pripravené, pripravujú sa alebo neskôr.

Dominantná akcia:

> **Nastaviť LegalWork za mňa**

Počas aplikovania sa zobrazujú konkrétne stavy, napríklad **Pripravujeme pracovné miesto**, **Pripájame AI model** a **Spúšťame doplnky na pozadí**. Po dokončení:

> **Hotovo. Môžete začať pracovať.**

Tlačidlo **Otvoriť pracovisko** otvorí prvú session.

## Prvá úloha

Prvá session nesmie pôsobiť ako prázdny dashboard. Pri kurzore alebo v prázdnom stave sa zobrazia tri návrhy:

- **Zhrnúť dokument**;
- **Skontrolovať zmluvu**;
- **Porovnať dva dokumenty**.

Kliknutie vloží zrozumiteľný návrh úlohy do kompozéra. Používateľ následne vyberie alebo pretiahne dokument. Pri úprave, uložení alebo odstránení súboru zostáva zachované potvrdenie človekom.

## Výnimky a chybové stavy

- **Používateľ zruší výber priečinka:** zostane na obrazovke priečinka bez všeobecnej chyby a môže skúsiť znova alebo onboarding preskočiť.
- **Server alebo pracovisko nie je dostupné:** zobrazí sa dôvod a akcia **Skúsiť znova**; aplikácia nehlási úspešné dokončenie.
- **Pripojenie modelu zlyhá:** voľba zostane zachovaná, používateľ sa vráti na obrazovku modelu a môže zmeniť iba potrebnú voľbu.
- **Office alebo transkripcia zlyhá:** stav je **Nastavíme neskôr** a pracovisko sa otvorí.
- **Aplikácia sa zavrie počas onboardingu:** po opätovnom spustení pokračuje od posledného nedokončeného kroku a neopakuje hotové kroky.
- **Vytvorenie prvej session zlyhá:** používateľ môže otvoriť pracovisko, skúsiť vytvoriť session znova alebo pokračovať cez existujúce pracovisko.

## Rozsah implementácie

Fáza 1 má byť zameraná na existujúce rozhrania:

- zjednodušiť WelcomePage a WelcomeRoute na rýchlu a kontrolovanú cestu;
- upraviť poradie a stavový prechod v session-route.tsx;
- zachovať existujúci auth flow v ProviderSelectionStep, ale skryť technické pojmy a zjednotiť odporúčanú voľbu;
- presunúť TemplateWorkflowsStep z kritickej cesty do následnej ponuky v pracovisku;
- ponechať TranscriptionSetupStep ako voliteľný neblokujúci krok;
- doplniť prvé návrhy úloh do prázdneho stavu prvej session;
- zachovať existujúce hasCompletedOnboarding a stav analytického súhlasu;
- nepridávať nový serverový endpoint ani nový konfiguračný formát.

## Mimo rozsahu Fázy 1

- automatické vytvorenie priečinka Dokumenty/LAWOSS bez výberu používateľa;
- automatická voľba jurisdikcie Slovensko/Česko a jej používanie v právnych workflowoch;
- jednotný bezpečnostný profil meniaci serverové alebo nástrojové oprávnenia;
- tichá OAuth autorizácia alebo tiché odoslanie dokumentov novému poskytovateľovi;
- zavedenie novej slovenskej alebo českej lokalizácie ako súčasť tejto UX zmeny;
- redesign nastavení, provider auth store alebo modelovej konfigurácie nad rámec potrieb onboardingu.

## Akceptačné kritériá

- Nový používateľ sa pri dostupnom modeli dostane z úvodnej obrazovky do prvej session jednou hlavnou cestou a bez technických pojmov.
- Odporúčané nastavenie má na každej obrazovke viditeľnú predvolenú voľbu.
- Povinné rozhodnutia používateľa sú najviac výber pracovného priečinka a pripojenie AI modelu, ak model ešte nie je dostupný.
- Šablóny, Office a transkripcia neblokujú otvorenie pracoviska.
- Zrušenie, chyba a opätovné spustenie nespôsobia stratu už dokončených krokov.
- Aplikácia jasne oznámi, aký AI model sa používa a akú dátovú hranicu má používateľ očakávať.
- Existujúci používateľ s hasCompletedOnboarding sa do nového onboardingu nevráti.
- Analytický súhlas zostane v súlade s existujúcou implementáciou a rešpektuje uloženú voľbu používateľa.
- Prvá session ponúkne najmenej tri konkrétne návrhy úloh.

## Overenie

Pred implementáciou a počas nej treba pripraviť aspoň tieto scenáre:

1. desktop, nový používateľ, dostupný model, úspešné vytvorenie pracoviska;
2. desktop, nový používateľ bez modelu, úspešné pripojenie modelu;
3. zrušenie výberu priečinka a opakovanie;
4. zlyhanie voliteľného Office alebo transkripčného kroku s úspešným otvorením session;
5. obnovenie onboardingu po zatvorení aplikácie;
6. existujúci používateľ s dokončeným onboardingom;
7. prvá úloha zo všetkých troch návrhov v prvej session.

Ak je zapnuté meranie používania, udalosti sa môžu sledovať iba v rámci existujúceho súhlasu. Minimálna sada je začatie onboardingu, výber priečinka, pripojenie modelu, dokončenie onboardingu a spustenie prvej úlohy.
