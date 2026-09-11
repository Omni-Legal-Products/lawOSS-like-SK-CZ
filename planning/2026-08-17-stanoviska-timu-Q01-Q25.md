<div align="center">

# 🧭 Stanoviská tímu k rozhodovacím otázkam Q01–Q25

**Všetky štyri pohľady na jednom mieste** · zostavené 2026-08-17

![IR](https://img.shields.io/badge/IR-25%2F25-brightgreen)
![VŘ](https://img.shields.io/badge/V%C5%98-25%2F25-brightgreen)
![MČ](https://img.shields.io/badge/M%C4%8C-pracovn%C3%A9%20stanovisk%C3%A1-yellow)
![MF](https://img.shields.io/badge/MF-25%2F25-brightgreen)

</div>

> [!CAUTION]
> **Tento dokument zachytáva stav pred callom 18. 8. 2026.** Otázky sa medzitým prerokovali a **niektoré sa rozhodli inak, než znejú písomné odpovede nižšie** — najmä Q05, Q11, Q13, Q20 a Q21. **Aktuálny stav je v [zápise z callu](../meetings/2026-08-18-zapis-sync-call.md).** Tento prehľad zostáva ako záznam východiskových pozícií jednotlivých členov.

> [!IMPORTANT]
> **Pre koho je tento dokument.** Pre kohokoľvek — aj mimo tímu — kto chce pochopiť, ako sa LAWOSS rozhoduje o svojom smerovaní: čo sú otázky, kto na nich stojí na akej pozícii a prečo, kde je zhoda a kde nie.
>
> **Čo to je:** [25 rozhodovacích otázok](2026-08-12-rozhodovacie-otazky-timu.md) pokrýva riadenie produktu, release model, prvú iteráciu, pamäť, AML, dáta, platformy, regulované workflowy a open source. Každý člen tímu odpovedá formou *možnosť + dôvod + podmienka + vlastníctvo ďalšieho kroku*.
>
> **Stav odpovedí:** IR ([plné znenie](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/26), 14. 8.) a VŘ ([plné znenie](2026-08-15-odpovedi-VR-Q01-Q25.md), 15. 8.) odpovedali kompletne. **Stanoviská MČ sú pracovné** — vznikli v hlasových diskusiách 15.–17. 8. a finálne ich podá do PR #26. **MF** odpovedal 17. 8. jednotným návrhom ([komentár v PR #26](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/26)) — „reverzibilný, local-first MVP s povinnou ľudskou verifikáciou a technicky vynútenými hranicami agenta".

## Kto je kto

| Skratka | Meno | Rola v projekte | Jurisdikcia |
|---|---|---|---|
| **MČ** | Marián Čuprík | iniciátor projektu, navrhovaný product owner, MCP infraštruktúra | 🇸🇰 SK |
| **MF** | Martin Friedrich | právny oponent architektúry, autor návrhu attorney workflow MVP | 🇸🇰 SK |
| **IR** | Igor Ribár | predsedníctvo SAK; SK právny sign-off, rešerše, dáta, Windows testovanie | 🇸🇰 SK |
| **VŘ** | Vojta Říha | CZ právny sign-off, CZ dátové zdroje a nástroje, prevádzkové skúsenosti s agentmi | 🇨🇿 CZ |

---

## Prehľadová tabuľka

**Legenda:** ✅ = zhodná pozícia · ⚡ = vecná odchýlka · 🕐 = čaká sa na stanovisko · pracovné stanoviská MČ sú označené *(prac.)*

| # | Otázka (skrátene) | IR | VŘ | MČ *(prac.)* | MF | Stav |
|---|---|---|---|---|---|---|
| Q01 | Product owner | A — MČ | A — MČ | A — prijíma | A — MČ | ✅ zhoda 4/4 |
| Q02 | Upstream sync | A + `PATCHES.md`, dodá automat | A, rolu neberie, review CZ vrstvy | A — maintainer/reviewer doriešiť | A + `PATCHES.md` | ✅ smer jasný, mená otvorené |
| Q03 | Release approval | súhlas; SK právny sign-off berie | súhlas; **CZ právny sign-off berie** | súhlas; technika + release security | súhlas s minimom | ✅ |
| Q04 | `dev` ako default | A | A | A | A | ✅ |
| Q05 | Review minimum | áno, záväzne | áno, záväzne; katalóg lehôt = kód | áno, záväzne; všetci 4 môžu review/merge | áno, záväzne | ✅ |
| Q06 | Čo vydávame | A → C; červená čiara: bez nepodpísaných binárok | A → C; **rovnaká červená čiara** | A → C; tlak na rýchle verejné MVP | A → C | ✅ s napätím rýchlosť × podpis |
| Q07 | Prvé tri vertikály | trojica z odporúčania; lehoty náhradník | ⚡ **lehoty do trojice** namiesto onboardingu | rozhodne ako PO; sympatie k lehotám | ⚡ **lehoty do trojice** | ⚡ VŘ + MF: lehoty dnu · IR: náhradník → rozhodne MČ |
| Q08 | MVP billing | B | B + export dôležitejší než vlastná fakturácia | B | B | ✅ |
| Q09 | Anonymizácia mimo V1 | áno, odložiť | áno + pomenovaný spúšťač návratu | áno + spúšťače | áno + spúšťače | ✅ |
| Q10 | Obsah L1/L2/L3 | zjednodušená definícia | + typované záznamy, vrstva „poučení z chyb" | + provenance a verzovanie; brain/OKF v súboroch | súhlas + vlastník, provenance a retencia každej vrstvy | ✅ komplementárne doplnky |
| Q11 | Povýšenie poznatku | len človek, vždy | len človek + **distribúcia schváleného** | len človek; vzťah k YOLO doriešiť | len človek; **YOLO to neodomyká** | ✅ (pozri kolíziu K2) |
| Q12 | Periodicita reconciliation | kombinácia | kombinácia | kombinácia | kombinácia | ✅ |
| Q13 | Metriky reconciliation | zoznam + 2 kľúčové čísla | + metrika štýlu (čo advokát prepísal) | zoznam + rovnaké 2 čísla | súhlas so zoznamom | ✅ |
| Q14 | Režimy preverovania | podmienka: menovcov potvrdzuje človek | + kontrolný dotaz na známy pozitívny prípad | navrhol obsah light/medium/hard | zachovať režimy; menovcov vždy človek | ✅ MČ vlastní spec |
| Q15 | AML: vlajková vs. OKF | B vnútri, A navonok | B vnútri, A navonok | B vnútri, A navonok | B vnútri, A navonok | ✅ |
| Q16 | Lokálnosť klientskych dát | lokálne bez výnimky | lokálne; opora § 21 CZ zák. o advokácii | **local-first**; cloud sync je vec používateľa | local-first | ✅ |
| Q17 | Lokálny index vs. RAG | lokálne ako default | lokálne ako default | ⚡ ide ďalej: **OKF/Markdown-first, žiadny centrálny RAG** | áno; OKF/Markdown-first | ✅ smer; MČ ostrejšie |
| Q18 | Platformy | mac + Windows rovnocenne; testuje Windows | Windows podporuje, testovať nevie; CZ nástroje neutrálne | multiplatformové jadro **bez povinnej parity** | multiplatformové jadro bez nútenej parity | ✅ s nuansou parity |
| Q19 | Poľsko v architektúre | A schémy, B integrácie | A schémy, B integrácie; PL mapa do 20. 8. | A schémy, B integrácie + modularita jurisdikcií | A schémy, B integrácie | ✅ |
| Q20 | Sign-off roly | navrhol konkrétne rozdelenie | prijíma + dopĺňa CZ stranu | **odložiť na spoločný call** — roly sa neprideľujú v neprítomnosti | návrh rozdelenia; potvrdiť na calle | 🕐 agenda na call |
| Q21 | Human-in-the-loop | striktný trojstupňový model | + **hranica v nástroji, nie v prompte** | ⚡ konfigurovateľná autonómia vrátane YOLO | schválil ADR 0007 | ⚡ kolízia K2 |
| Q22 | Všetko zadarmo | áno; platené moduly odmieta | áno; rovnaký dôvod | áno; licenčná ochrana pred prevzatím = samostatná téma | áno | ✅ |
| Q23 | Čo publikujeme | všetko s vyjasnenou licenciou | + CZ balík; výhrada ku korpusu komentárov | upstream case-by-case; publikovanie širšie | súhlas; datasety len s licenciou | ✅ po oddelení upstream/publikovanie |
| Q24 | Záväznosť doktríny | **A — záväzná** | **A — záväzná** | ⚡ *(prac.)* case-by-case rámec | **A s odľahčenou výnimkou** | ⚡ K1 — IR+VŘ+MF za záväznú; MČ (prac.) case-by-case |
| Q25 | Otvorené formáty | A; Word nie druhá kategória | A; + **merateľný DOCX round-trip test** | A — jeho vlastný návrh | A + merateľný DOCX round-trip | ✅ so sprísnením VŘ |

---

## Kľúčové udalosti okolo otázok

- **ADR 0007 (agent-first architektúra) je prijaté.** MF ho po druhom posúdení **schválil 16. 8.** — potvrdil zapracovanie svojich troch požiadaviek (povinná ľudská verifikácia pred použitím výstupu v právnej službe, oddelenie recenzenta architektúry od zodpovedného advokáta, technické vylúčenie podpisovania a konania navonok agentom). PR #19 **zlúčený 17. 8.** ADR 0007 je odteraz platný rámec pre Q11 a Q21.
- **IR a VŘ sa zhodli na 24 z 25 otázok.** Jediná vecná odchýlka je poradie vertikál v Q07 — a nie je to spor o hodnote, ale o cene (viď nižšie).
- **MF odpovedal 17. 8. na všetkých 25 otázok** jednotným návrhom vrátane stanovísk ku všetkým trom kolíziám. V Q07 sa pridal k VŘ (lehoty do trojice), v Q24 k IR a VŘ (záväzná doktrína, s odľahčenou výnimkou), v Q21 za tvrdé technicky vynútené hranice. Zároveň potvrdil **ADR 0003** (voľba LegalWork — potvrdenie visel od 6. 8., reálne dané už 9. 8., zaevidované v PR #12).
- **MF 17. 8. sám zlúčil šesť svojich PR** (#2, #4, #8, #9, #11, #12) — vrátane **specu 0006 (orchestrátor)** a **veľkého prepisu specu 0005 (lehoty → auditovateľný alfa workflow)** bez odklepu tímom, a pridania Codex skillov a pluginov priamo do koordinačného repa. Obsahovo idú zmeny v smere odpovedí tímu; **procesne to ale odhalilo dieru v pravidlách** — kto smie čo mergovať zatiaľ nie je záväzne dohodnuté. Rieši [návrh ADR 0011](../decisions/0011-proces-zmien-a-mergovania.md).
- **Issues vo forku [`lawoss`](https://github.com/Omni-Legal-Products/lawoss) boli vypnuté — od 17. 8. sú zapnuté.** Implementačné chyby a úpravy z testovania (issue #47) tak už majú kam smerovať.

---

## Detailné pozície podľa oblastí

### A · Riadenie produktu (Q01–Q03)

**Zhoda troch:** product owner je MČ (Q01) — „produkt musí mať jedného človeka, ktorý rozsekne pat" (IR); VŘ dopĺňa podmienku, aby odchýlky od prijatých ADR mali písomné odôvodnenie. MČ rolu prijíma s tým, že zásadné veci (doktrína, monetizácia, regulované workflowy) konzultuje vopred — a výslovne **nechce byť jediný, kto reviewuje a merguje**: všetci štyria majú mať reálnu právomoc review/merge v rámci dohodnutých pravidiel.

**Upstream sync (Q02):** všetci traja za model „jeden maintainer + AI agent, druhý review, poctivý `PATCHES.md`". IR ponúka automat, ktorý pri konflikte sám otvorí PR s prehľadom. VŘ sa o rolu **nehlási** (kapacita), berie review CZ vrstvy. Otvorené zostáva len rozdelenie maintainer/reviewer medzi MČ a IR.

**Release approval (Q03):** navrhované minimum nikto nespochybnil. Právne sign-offy sa poskladali prirodzene dvojjurisdikčne: **IR za SK, VŘ za CZ** (autorizovaná konverzia podľa z. č. 300/2008 Sb., ISDS, CZ lehoty, CZ AML), technická verifikácia a release security MČ.

### B · Vetvy, review, release (Q04–Q06)

`dev` zostáva default (Q04, zhoda troch — menej odchýlok od upstreamu, stabilita tagmi). Review minimum je záväzné aj tam, kde ho GitHub Free nevynúti (Q05); VŘ dôležito dopĺňa, že **katalóg lehôt a zoznamy registrov sú „funkčný kód", nie docs** — zlé číslo v tabuľke lehôt škodí ako chyba v kóde, len sa horšie hľadá.

**Q06 nesie jediné vnútorné napätie zhody:** všetci traja odpovedajú A → C (najprv kód a návod, verejnosti až podpísané buildy). IR **aj** VŘ však majú **totožnú osobnú červenú čiaru** — ako advokáti s disciplinárnou zodpovednosťou nespoja meno s distribúciou nepodpísaných binárok. MČ zároveň silno tlačí na **čo najrýchlejšie verejné MVP** („na trhu je veľa AI wrapperov s nízkou hodnotou; LAWOSS má byť alternatíva od reálnych advokátov"). Zmierenie: rýchlosť sa dosiahne skorým zverejnením kódu a návodu + čo najskorším podpisovým procesom, nie obchádzkou červenej čiary.

### C · Prvá iterácia (Q07–Q09)

**Q07 je jediná vecná odchýlka v tíme.** Obaja respondenti zhodne: 1. OKF + L2 spisová pamäť, 2. reconciliation s human approval. Tretie miesto:

| | IR | VŘ |
|---|---|---|
| 3. vertikála | onboarding subjektov `light` | **lehoty a timeline** |
| prvý náhradník | lehoty a timeline | onboarding subjektov |

Argument VŘ nie je preferencia, ale **cena**: proti lehotám vždy stálo chýbajúce právne jadro — to už neplatí (SK jadro dodal IR v PR #33: 12 pravidiel, 14 lehôt, 19 testov; CZ jadro dodal VŘ: 30 pravidiel, 25 lehôt, 24 testov, deterministický engine mu beží v praxi). Zostáva GUI a zápis do spisu — najlacnejšia zostávajúca vertikála, a pritom kandidát #1 pôvodného návrhu MF. IR sám píše: „zmeškaná lehota je to, čo advokáta reálne položí." **Rozhodnutie je na MČ ako PO** — obaja s tým počítajú.

**Q08 billing:** zhoda na B (čas, sadzby, podklad pre faktúru; vystavovanie dokladov je „iná liga zodpovednosti"). VŘ z praxe: CZ kancelárie už spisové a fakturačné systémy majú (Evolio) — **exportný formát a rozhranie von je dôležitejšie než vlastná fakturácia**.

**Q09 anonymizácia:** zhoda — mimo V1. VŘ žiada pomenovať spúšťač návratu vopred: *okamih, keď má ktorýkoľvek workflow poslať obsah spisu do cloudového modelu.* MČ súhlasí a dopĺňa druhý spúšťač: podmienka pilotu u tretej osoby. Detekčné vzory ležia pripravené (#36).

### D · Pamäť a reconciliation (Q10–Q13)

Táto oblasť je príklad, ako sa odpovede **dopĺňajú namiesto prekrývania**:

- **IR** dal pracovnú definíciu vrstiev: L1 osobné nastavenia bez klientskych dát · L2 spisová pamäť prísne lokálna per vec · L3 spoločná právnická pamäť len z verejných zdrojov.
- **VŘ** pridal dve prevádzkové lekcie z vlastného ročného behu trojvrstvovej pamäte: (1) **záznamy musia byť typované** (`user`/`feedback`/`project`/`reference`), inak pamäť po mesiacoch splynie v nerevidovateľnú hromadu; (2) potrebná je oddelená vrstva **„poučenie z chyby"** — čo sa model naučil zle, je iná kategória než fakty spisu a maže sa inak.
- **MČ** dopĺňa architektonický rámec: pamäť žije ako **brain/OKF v otvorených lokálnych súboroch** (úroveň advokáta → klienta/projektu → spisu), s provenance a verzovaním od prvého dňa, prenositeľná medzi AI harnessami.

**Q11 (povýšenie poznatku):** absolútna zhoda — „nič sa nesmie ‚naučiť' samo; agent navrhne a ukáže rozdiel, schvaľuje človek. Vždy" (IR). VŘ má aj doložený incident, prečo: subagent bez prístupu k zdieľanej pamäti zopakoval judikát, ktorý už bol skôr vyhodnotený ako problematický — poučenie: povýšenie nie je len schválenie, ale aj **distribúcia** schváleného ku všetkým agentom. *Pozor: vzťah Q11 k návrhu YOLO režimu MČ treba doriešiť — viď kolízia K2.*

**Q12–Q13:** zhoda na kombinovanej kadencii (event + týždenná konsolidácia + bodka pri uzavretí) a na metrikách; kľúčové čísla pre IR aj MČ sú **false promotion rate** a **čas ľudskej kontroly** („ak kontrola diffu trvá dlhšie než spraviť to ručne, funkcia zlyhala"), VŘ pridáva **metriku štýlu** — koľko z navrhnutého advokát prepísal a v čom; keď neklesá, prompt layer sa neučí.

### E · Subjekty, AML, registre (Q14–Q15)

Obsah režimov `light`/`medium`/`hard` vlastní MČ (navrhol: light = SK/CZ core registre do minúty; medium = + judikatúra, sankcie, médiá a štruktúrovaný report; hard = + KÚV reťazce, história, plný OSINT s timeoutom). K tomu dve podmienky respondentov, obe prijaté:

1. **IR:** zhodu pri menovcoch nikdy nepotvrdí stroj sám — vždy človek.
2. **VŘ (overené provozom):** sankčné API bez kľúča vracia prázdny výsledok aj pre zjavne sankcionované osoby → každý screening musí púšťať **kontrolný dotaz na známy pozitívny prípad**, inak „čistý výsledok" znamená len „dotaz neprešiel".

Za CZ stranu VŘ dodal [mapu dátových zdrojov](cz-datove-zdroje.md) (15 zdrojov, 5 medzier). Q15: úplná zhoda — architektonicky súčasť zakladania spisu, marketingovo samostatná funkcia.

### F · Dáta, modely, platformy (Q16–Q19)

**Q16 local-first — najsilnejšia zhoda v celom dokumente.** Klientske dokumenty a spisová pamäť lokálne bez výnimky; telemetria len opt-in bez obsahu spisov; zálohy šifrované u advokáta. VŘ dáva tvrdšiu oporu než „dobrá prax": mlčanlivosť podľa **§ 21 z. č. 85/1996 Sb.** — zodpovednosť nesie advokát osobne, nie dodávateľ softvéru, preto lokálnosť nemôže byť len voľba v nastaveniach. MČ spresňuje hranicu zodpovednosti: LAWOSS je lokálna desktopová aplikácia nad lokálnymi súbormi; či si používateľ priečinky synchronizuje cez Drive/Dropbox/OneDrive, je jeho rozhodnutie a infraštruktúra — aplikácia s tým musí vedieť korektne fungovať (vrátane on-demand súborov), ale cloudová politika používateľa nie je zodpovednosť jadra.

**Q17:** IR aj VŘ — lokálny index ako default. MČ ide o krok ďalej a formuluje architektonický princíp: **LAWOSS má byť OKF/Markdown-first, nie RAG-first.** Jadrom je otvorená súborová štruktúra (interná wiki spisu); externé zdroje (judikatúra, registre, legislatíva) sa pripájajú cez MCP/CLI a **smú si viesť vlastné indexy** (napr. judikatúrny MCP so 161 k plnými textami NS SR) — ale centrálny RAG s povinným chunkovaním a embeddings nie je jadro produktu. Dôvod: **harness-agnostic prenositeľnosť** — ten istý spisový priečinok má vedieť otvoriť Claude Code, Codex, OpenCode aj budúci harness bez proprietárneho backendu. *Tento princíp si zaslúži vlastné ADR.*

**Q18 platformy:** zhoda na multiplatformovom jadre mac + Windows (Linux best-effort) s dvomi poctivými spresneniami: VŘ Windows podporuje, ale **testovať ho nevie** (nemá prostredie) — testovanie drží IR (issue #41); jeho CZ nástroje sú platformovo neutrálny Python. MČ odmieta **povinnú absolútnu feature paritu**: produkt sa nemá obmedzovať na najnižší spoločný menovateľ; platformovo špecifické funkcie sú prípustné, ak dávajú zmysel, a do budúcna nevylučuje natívnu macOS aplikáciu (SwiftUI) popri Electron jadre.

**Q19 Poľsko:** úplná zhoda — A na úrovni schém, B na úrovni integrácií. MČ dopĺňa víziu modulárnej multi-jurisdikčnosti: priebežne hľadať technicky zdatných advokátov (PL, HU, UA…), ktorí dodajú jurisdiction-specific MCP, skilly a workflowy. VŘ má mapovanie PL zdrojov rozpracované s termínom 20. 8.

### G · Regulované workflowy (Q20–Q21)

**Q20 (sign-off roly):** IR navrhol konkrétne rozdelenie (súkromie a pamäť MF+IR · AML IR+MČ · podpisovanie a konverzia MČ s právnym sign-offom IR · licencie dát IR · release security MČ) a VŘ ho prijal s doplnením CZ strany (CZ právny sign-off, CZ licencie dát — Salvia, Codexis, korpus komentárov). **MČ vedome necháva otvorené:** roly sa majú prijať osobne na spoločnom calle, nie prideliť v neprítomnosti — týka sa najmä MF.

**Q21 (human-in-the-loop):** rámec dáva čerstvo prijaté **ADR 0007** — a k nemu dve dôležité pozície:

- **VŘ (najsilnejšie doložená pozícia diskusie):** presne tento model prevádzkuje. Tabuľka smie samostatne / smie pripraviť / nesmie nikdy zodpovedá IR aj ADR. Kľúčový prevádzkový princíp: **„hranice nesmí být v promptu, ale v nástroji"** — prompt „neodosielaj bez potvrdenia" model občas obíde; vynútenie patrí do nástroja (povinný `--dry-run`, odstránenie rizikových funkcií z nástrojovej plochy — u jedného konektora zúžil 79 nástrojov na 12 a vypol webhook zneužiteľný cez prompt injection). Odporúča zapísať do ADR 0007: *čo agent nesmie, nemá sa mu dať nabídnout.*
- **MČ (nový návrh):** miera autonómie má byť **konfigurovateľná používateľom** ako v coding harnessoch — od „always ask" cez „ask on sensitive" až po vedomý **YOLO režim** (nikdy nie default). Systém nemá všetkým vnucovať jednu úroveň dohľadu.

Tieto pozície sa dajú zmieriť, ale vyžaduje to explicitné rozhodnutie — viď kolízia K2.

### H · Open source, financovanie, formáty (Q22–Q25)

**Q22:** trojitá zhoda — všetko zadarmo a otvorené, zarábame na školeniach, workshopoch a implementačnej pomoci; platené moduly sa odmietajú s totožným dôvodom (IR aj VŘ: „v momente, keď predávame softvér, sme dodávateľ softvéru so všetkým, čo k tomu patrí"). Samostatnou témou zostáva **licenčná ochrana pred komerčným prevzatím**: MČ chce permisívny režim s atribúciou, ale bez „premaľovaného plateného forku" — čo bežná open-source licencia nezaručí. Prijaté [ADR 0010](../decisions/0010-ochrana-know-how-a-znacky.md) stavia ochranu na značke, komunite a tempe; MČ zároveň signalizoval, že na trademarkovej ochrane stáť nechce — **licenčná otázka (MIT vs. Apache-2.0 vs. MPL/AGPL) zostáva otvorená na samostatné strategické rozhodnutie.**

**Q23:** zhoda na vracaní všetkého vymenovaného s vyjasnenou licenciou. MČ oddeľuje dve roviny: **upstream do LegalWorku** (case-by-case: všeobecné opravy a lokalizácie áno; OKF, brain, jurisdikčné skilly a MCP zostávajú LAWOSS moduly) vs. **publikovanie komunite** (široké). VŘ ponúka konkrétny CZ balík (pravidlá lehôt + testy, mapa zdrojov, výpočtový engine, ISDS/ISIR/katastr nástroje) s dôležitou výhradou: **korpus ~94 AI generovaných komentárov publikovať len s varovaním „citovať v podaní nie"** — má doložené prípady, keď formulácia komentára vynechala slová nosné pre petit. Cennejší než korpus je vzor *„navigácia → povinné dooverenie v primárnom prameni"*.

**Q24 (záväznosť doktríny): tu je najväčší otvorený rozpor.** IR: A. VŘ: A. Pracovné stanovisko MČ z hlasovej diskusie 17. 8.: **case-by-case** — doktrína ako orientačný rámec, nie rigidný blocker. Viď kolízia K1.

**Q25 (otvorené formáty):** zhoda na A — *open formats at the core, compatibility at the edges* (návrh MČ). IR podmieňuje: Word nesmie byť druhá kategória. VŘ podmienku **sprísňuje z priania na merateľnú požiadavku**: má zdokumentovaných deväť konkrétnych spôsobov, ako sa rozbije DOCX generovanie a PDF konverzia, pričom textová kontrola ich nenájde — preto **DOCX round-trip musí mať testovací korpus a vizuálnu kontrolu**, nie len deklaráciu „podporujeme import a export". Nadväzuje na nápady #29 (tracked changes v editore zakázané natvrdo) a #31 (zmeny sa podpisujú ako „Legal Cowork").

---

## Tri kolízie, ktoré treba explicitne rozseknúť

### K1 · Q24: záväzná doktrína (IR + VŘ + MF) vs. case-by-case (MČ, pracovne)

> **Stav 17. 8.:** MF sa pridal k záväznej doktríne, ale s **odľahčenou výnimkou** (krátke písomné odôvodnenie + mitigácia + časové obmedzenie namiesto plného ADR) — čo je presne kompromisná cesta navrhnutá nižšie. Zostáva potvrdenie MČ.

IR a VŘ hlasovali za doktrínu ako záväzný meter s písomnou výnimkou; pracovné stanovisko MČ sa posunulo k pragmatickému posudzovaniu prípad od prípadu. Pikantné je, že **A bolo pôvodné odporúčanie samotného MČ** — a MF práve schválil ADR 0007, ktoré je pilierom doktríny. Ak MČ na case-by-case trvá, malo by to byť vedomé rozhodnutie so zdôvodnením; kompromisná cesta je doktrína záväzná + nízkonákladová výnimka (krátke písomné odôvodnenie namiesto plného ADR).

### K2 · Q21: konfigurovateľná autonómia / YOLO (MČ) vs. hranica v nástroji (VŘ) a ADR 0007 (MF schválil)

> **Stav 17. 8.:** MF odpovedal presne v duchu delenia nižšie — „nastaviteľná autonómia iba vnútri veci; hard boundaries technicky nedostupné a **povýšenie pamäte vždy ľudské**". Tým sa aj otvorená položka povýšenia pamäti kloní k tvrdým hraniciam (IR, VŘ aj MF zhodne). Zostáva potvrdenie MČ.

Riešiteľné rozdelením na dve roviny, ktoré sa dnes zlievajú:

| Rovina | Návrh |
|---|---|
| **Konfigurovateľná autonómia** | pre *vnútornú* prácu v spise (čítanie, drafty, poriadok, výpočty) — od „always ask" po YOLO; voľba používateľa, YOLO nikdy default |
| **Tvrdé hranice** | podpis, podanie, odoslanie čohokoľvek von, finančné úkony, neanonymizovaný spis do cloudu — **technicky nedostupné v nástroji**, neodomkne ich žiadny režim vrátane YOLO |

Otvorená ostáva jedna položka: **povýšenie pamäti (Q11)** — IR aj VŘ ho chcú vždy s ľudským schválením; treba rozhodnúť, či patrí do tvrdých hraníc (odporúčanie respondentov), alebo ho smie YOLO odomknúť.

### K3 · Q06: rýchle verejné MVP (MČ) vs. červené čiary na nepodpísané buildy (IR + VŘ)

> **Stav 17. 8.:** MF odpovedal zhodne s cestou nižšie (verejný kód od začiatku, verejné binárky až po podpise). K3 je prakticky vyriešená — na calle stačí formálne potvrdiť.

Obe strany chcú to isté — dostať LAWOSS medzi advokátov. Cesta, ktorá rešpektuje obe: verejný je od začiatku **kód + návod**; podpisový a notarizačný proces (macOS aj Windows) sa rieši **skoro, ako súčasť M-brán**, nie až „raz"; nepodpísané buildy výhradne interne so zreteľným varovaním.

---

## Čo ešte visí a na kom

| Čo | Kto | Poznámka |
|---|---|---|
| ~~Odpovede na Q01–Q25~~ | ~~MF~~ | **hotové 17. 8.** — jednotný návrh v PR #26 |
| Finálne podanie odpovedí do PR #26 | **MČ** | pracovné stanoviská v tomto dokumente → formát `Qxx: možnosť, dôvod, podmienka, ownership` |
| Rozhodnutie Q07 (poradie vertikál) | **MČ** ako PO | VŘ + MF: lehoty do trojice · IR: náhradník, ale súhlasí s vedomou zámenou |
| Kolízie K1–K3 | **MČ + tím** | ideálne na najbližšom calle |
| Q20 rozdelenie sign-off rolí | **celý tím na calle** | MF sa musí k svojej roli prihlásiť osobne |
| ~~7 starších draftov MF~~ | ~~MF~~ | **6 zlúčených 17. 8. autorom** (procesná otázka → ADR 0011); otvorené drafty #10 a #53 |
| Odklepnúť [návrh ADR 0011](../decisions/0011-proces-zmien-a-mergovania.md) — kto čo merguje a ako sa integrujú funkcie | **celý tím na calle 21. 8.** | reakcia na samostatné mergovanie specov |
| Dokončiť draft #39 (SAK compliance balík) | **IR** | označený ako draft na revíziu |
| MCP konsolidácia — zber a benchmark | **všetci** | issue #45, zatiaľ reagoval len MČ |
| ~~Revízia PR od IR a MČ~~ | — | **hotové 17. 8.** — zlúčených 16 PR (podklady IR #33–#38 + #42, dokumenty MČ #13, #14, #16, #27, #51, #52 a ďalšie) |
| Testovanie forku | **všetci** | issue #47, zatiaľ bez reakcií; issues vo forku už zapnuté |
| Licenčné podmienky Salvia · CZ rámec autorizovanej konverzie · PL zdroje (20. 8.) · analýza DetermO | **VŘ** | jeho vlastný zoznam úloh |

---

<sub>Zostavil MČ s AI asistenciou, 2026-08-17. Pozície IR sú doslovné/kondenzované z [PR #26](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/26) (2026-08-14), pozície VŘ z [planning/2026-08-15-odpovedi-VR-Q01-Q25.md](2026-08-15-odpovedi-VR-Q01-Q25.md) (2026-08-15), pozícia MF z jeho posudkov ADR 0007 v [PR #19](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/19) (2026-08-12 a 2026-08-16). Pracovné stanoviská MČ pochádzajú z hlasových diskusií 2026-08-15 až 2026-08-17 a **nie sú finálnym hlasovaním** — to príde ako komentár do PR #26. Pri skratkách platí originál zdroja.</sub>
