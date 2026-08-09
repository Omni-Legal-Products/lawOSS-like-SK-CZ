# Spec 0005: Lehoty & timeline spisu

- **Stav:** rozpracované · alfa vertical slice · čaká na schválenie tímom
- **Navrhol:** Martin Friedrich (MF) · 2026-07-30 · [Issue #1](https://github.com/originalmagneto/lawOSS-like-SK-CZ/issues/1)
- **Doplnil:** Marián Čuprík (MČ) — timeline/diagramy, markdown-first
- **Súvisiace:** [0002 OKF](0002-okf-operacny-system-praxe.md) · [0001 transkripcia](0001-transkripcia.md) · [0006 orchestrátor a subagenti](0006-orchestrator-subagenti.md)

> [!IMPORTANT]
> Toto je prvý kandidát na alfa vertical slice. Cieľom nie je „automaticky počítať právo“, ale bezpečne premeniť dokument na **kandidátnu lehotu s dôkazom, výpočtom, neistotou a povinným potvrdením advokátom**.

## Problém

Lehoty dnes advokát loví ručne z uznesení, podaní, zmlúv a e-mailov a prepisuje ich do kalendára. Každý ručný krok je priestor na chybu; jedna prehliadnutá lehota môže viesť k zodpovednosti alebo škode.

## Cieľ alfa vertical slice

Alfa má pokryť jednu úplnú, auditovateľnú cestu:

**dokument → extrakcia kandidáta → zdroj a presný locator → transparentný výpočet → povinné potvrdenie advokátom → Markdown/OKF zápis → ICS kalendárový export → audit**

### Vstup

Prvá verzia prijíma jeden lokálny alebo syntetický dokument:

- rozhodnutie alebo uznesenie;
- podanie;
- e-mail alebo záznam o doručení;
- anonymizovanú transkripciu.

OCR a ingest môžu byť samostatný upstream krok. Tento spec definuje kontrakt od okamihu, keď je text dokumentu dostupný.

### Výstup

Po potvrdení advokátom vznikne:

- záznam lehoty v Markdown/OKF štruktúre spisu;
- kalendárová udalosť v ICS formáte;
- auditná udalosť s pôvodným kandidátom, úpravami a rozhodnutím človeka;
- voliteľná timeline spisu v Markdown/HTML.

### Mimo rozsahu prvej alfy

- automatické odosielanie e-mailov alebo podaní;
- eID, slovensko.sk a iné externé právne úkony;
- priame zapisovanie do Google Calendar alebo iného vzdialeného kalendára;
- tiché vytváranie alebo posúvanie termínu bez potvrdenia;
- rozhodovanie, či je právny prostriedok prípustný alebo či lehota skutočne začala plynúť;
- produkčné tvrdenia o právnych pravidlách bez overenia podľa aktuálnych primárnych zdrojov.

## Navrhované riešenie

1. **Ingest:** dokument dostane identifikátor, zdroj, typ a čas prijatia.
2. **Extrakcia:** model alebo pravidlá navrhnú spúšťaciu udalosť, právny základ, dĺžku, jednotku a kandidátny konečný dátum.
3. **Provenance:** každý kandidát musí obsahovať dokument, presný locator, verziu zdroja a čas získania.
4. **Výpočet:** deterministická výpočtová vrstva zopakuje výpočet z explicitných vstupov. Model nesmie byť jedinou výpočtovou autoritou.
5. **Verifier:** označí rozpory, chýbajúce údaje, časové neistoty a otázky pre advokáta.
6. **Human gate:** bez potvrdenia sa záznam nesmie zapísať ako aktívna lehota ani exportovať do kalendára.
7. **Zápis:** po potvrdení vznikne idempotentný Markdown/OKF záznam, ICS export a auditná udalosť.
8. **Oprava:** odmietnutý alebo zmenený kandidát zostane v histórii; pôvodný návrh sa neprepíše.

## Stavový model

| Stav | Význam | Povolený ďalší krok |
|---|---|---|
| draft | dokument ešte nie je vyhodnotený | extrakcia |
| candidate | existuje návrh lehoty | verifikácia |
| needs_review | chýba údaj, zdroj alebo súlad výpočtu | doplnenie alebo odmietnutie |
| confirmed | advokát potvrdil údaje a výpočet | zápis a ICS export |
| rejected | advokát návrh odmietol | oprava alebo archivácia |
| superseded | lehota bola nahradená novou verziou | zachovať históriu |
| failed | workflow sa bezpečne nedokončil | manuálny zásah |

## Minimálny dátový model

| Pole | Povinnosť | Obsah |
|---|---:|---|
| deadline_id | áno | stabilný identifikátor, ktorý prežije opakované spustenie |
| matter_id | áno | identifikátor anonymizovaného alebo lokálneho spisu |
| jurisdiction | áno | SK, CZ alebo iná výslovne uvedená jurisdikcia |
| legal_area | áno | procesná, hmotnoprávna, správna, pracovná alebo iná oblasť |
| source_ref | áno | súbor, dokument alebo autorizovaný zdroj |
| source_locator | áno | strana, odsek, článok, časová pozícia alebo iný presný locator |
| source_version | ak relevantné | verzia predpisu, rozhodnutia alebo dokumentu v čase |
| trigger_event | áno | udalosť, od ktorej sa výpočet odvíja |
| trigger_date | áno alebo needs_review | dátum udalosti a spôsob jeho zistenia |
| duration | áno | počet a jednotka, napríklad dni, týždne alebo mesiace |
| calculation_basis | áno | kalendárne/pracovné dni, začiatok, koniec, sviatky a ďalšie pravidlá |
| candidate_due_at | áno alebo needs_review | kandidátny konečný dátum a časové pásmo |
| calculation_trace | áno | opakovateľné kroky výpočtu v zrozumiteľnej forme |
| uncertainty | áno | neznáme, sporné alebo neoverené vstupy |
| status | áno | stav podľa stavového modelu vyššie |
| human_decision | po review | potvrdenie, úprava alebo odmietnutie a odôvodnenie |
| confirmed_at | po potvrdení | dátum a čas potvrdenia |
| calendar_export_ref | po potvrdení | identifikátor ICS exportu |
| audit_ref | áno | odkaz na auditnú udalosť |

## SK/CZ pravidlá a právna hranica

Výpočtová vrstva nesmie obsahovať nezdokumentované univerzálne pravidlá. Pre každý kandidát musí byť jasné:

- či ide o slovenskú, českú alebo inú jurisdikciu;
- či ide o procesnú alebo hmotnoprávnu lehotu;
- z akej udalosti lehota plynie: doručenie, fikcia doručenia, zverejnenie, úkon účastníka alebo iná udalosť;
- či sa používajú kalendárne alebo pracovné dni;
- aký je režim začiatku a konca počítania;
- ako sa riešia sviatky, víkendy, prerušenie, predĺženie alebo osobitné prechodné pravidlá;
- podľa akého právneho textu a v akej verzii sa pravidlo použilo;
- aké údaje musí potvrdiť advokát, ak ich dokument neobsahuje.

SK a CZ pravidlá sa nesmú zamieňať iba preto, že majú podobnú terminológiu. Ak chýba dátum doručenia, právny základ, relevantná verzia predpisu alebo iný rozhodujúci vstup, výsledkom je needs_review alebo indeterminate, nie odhad vydávaný za termín.

## Povinné ľudské potvrdenie

Obrazovka alebo Markdown review musí pred potvrdením zobraziť:

- pôvodný dokument a presný locator;
- spúšťaciu udalosť a dátum;
- použitý právny základ a jeho časovú verziu;
- jednotlivé kroky výpočtu;
- kandidátny konečný dátum a časové pásmo;
- neistoty a rozpory;
- čo sa zapíše do spisu a čo sa exportuje do kalendára.

Advokát musí mať možnosti **potvrdiť**, **upraviť**, **odmietnuť** alebo **odložiť**. Každá voľba sa zaznamená do auditu.

## Timeline spisu

Chronológia celej veci sa generuje zo spisu: skutky, úkony, lehoty a aktéri.

- primárne Markdown/HTML, aby bola verzovateľná a čitateľná bez vendor lock-in;
- Mermaid timeline alebo Gantt ako základný výstup;
- Excalidraw iba ako voliteľný vizuálny export;
- zobrazenie musí odlišovať potvrdené, kandidátne a odmietnuté udalosti;
- timeline nesmie z kandidátnej lehoty urobiť potvrdený fakt.

## Syntetické testy pre alfu

| Test | Očakávaný výsledok |
|---|---|
| SK syntetické rozhodnutie s jasným dátumom doručenia a uvedeným právnym základom | vznikne kandidát s locatorom, výpočtovou stopou a stavom candidate; bez potvrdenia sa nič nezapíše |
| CZ syntetické oznámenie s nejasným dátumom doručenia | stav needs_review; žiadny kalendárový export |
| Dokument obsahuje dve rozporné lehoty | verifier zobrazí rozpor; workflow čaká na rozhodnutie advokáta |
| Lehota je kratšia než konfigurovaný bezpečnostný prah | označenie pre zvýšenú alebo dvojitú kontrolu; prah nie je právny záver |
| Rovnaký dokument sa spracuje dvakrát | nevznikne duplicitná potvrdená lehota ani duplicitný ICS export |
| Zmení sa verzia použitého právneho textu | vznikne nová verzia výpočtu; starý audit zostane zachovaný |
| MCP alebo model nie je dostupný | stav failed alebo needs_review, nikdy completed |
| Používateľ odmietne kandidáta | stav rejected; žiadny aktívny zápis ani externá akcia |

## Akceptačné kritériá

Alfa sa považuje za pripravenú na syntetické testovanie iba ak:

1. každý kandidát má zdroj, presný locator a čas získania;
2. každý výpočet je opakovateľný z uložených vstupov;
3. model nemôže sám vytvoriť potvrdenú lehotu;
4. chýbajúce alebo rozporné údaje vedú do needs_review;
5. SK/CZ jurisdikcia a právna oblasť sú explicitné;
6. zapisuje sa verzia právneho textu, ak je otázka časovo citlivá;
7. potvrdenie, úprava a odmietnutie sú auditované;
8. opakované spustenie je idempotentné;
9. prvý kalendárový výstup je iba ICS export, nie automatický zápis do vzdialeného kalendára;
10. všetky testy používajú syntetické dáta a obsahujú aspoň jednu neistú alebo chybovú cestu.

## Otvorené otázky pred implementáciou

- Ktoré konkrétne SK/CZ právne pravidlá a sviatky patria do prvej testovacej sady?
- Kto schváli pravidlový katalóg a ako sa bude versionovať?
- Je pre alfu dostatočný ICS export, alebo je nevyhnutný CalDAV?
- Aký je presný OKF formát pre potvrdenú lehotu a audit?
- Aký bezpečnostný prah vyvolá dvojitú kontrolu?
- Kto v tíme preberie právnu kontrolu pravidiel výpočtu?

> [!NOTE]
> Táto špecifikácia definuje produktový a bezpečnostný kontrakt. Nie je samostatným právnym stanoviskom k výpočtu konkrétnej slovenskej alebo českej lehoty.
