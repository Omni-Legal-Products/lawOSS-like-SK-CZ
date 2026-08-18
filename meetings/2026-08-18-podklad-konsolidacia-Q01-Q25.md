# Podklad na call — konsolidácia Q01–Q25: otázky, argumenty všetkých štyroch a návrhy znenia

- **Kedy:** call 18. 8. 2026, 17:00 (MČ · MF · VŘ; IR ospravedlnený)
- **Cieľ:** prejsť každú otázku aj s premýšľaním, ktoré za odpoveďami stojí; prijať konsolidované znenie tam, kde je zhoda; v kontexte doriešiť otvorené body; odklepnúť proces práce (ADR 0011).
- **Zdroje v plnom znení:** odpovede IR a MF ([PR #26](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/26)) · [odpovede VŘ](../planning/2026-08-15-odpovedi-VR-Q01-Q25.md) · pracovné stanoviská MČ z hlasových diskusií 15.–17. 8. · [znenie otázok](../planning/2026-08-12-rozhodovacie-otazky-timu.md) · [prehľadová tabuľka](../planning/2026-08-17-stanoviska-timu-Q01-Q25.md)

> [!NOTE]
> **Ako s tým pracovať na calle.** Pri každej otázke je: presné znenie → pozície všetkých štyroch **aj s dôvodmi** → návrh konsolidovaného znenia (U1–U19) → čo ostáva otvorené (B1–B8). Kde je zhoda, stačí odklepnúť znenie; kde nie, argumenty sú na stole vedľa seba. Stanoviská MČ sú **pracovné** — vznikli v hlasových diskusiách a finálne ich MČ podá po calle do PR #26.

---

## 0 · Prierezové postoje MČ, ktoré sa dotýkajú viacerých otázok

Z hlasových diskusií MČ 15.–17. 8. vyplynulo sedem postojov, ktoré nie sú odpoveďou na jednu otázku, ale rámcom pre viaceré — patria na stôl ako kontext:

1. **Čo najrýchlejšie vydať reálne použiteľné MVP** *(→ Q06, roadmapa)*. Na trhu je veľa developerov predávajúcich advokátom jednoduché AI wrapery s nízkou praktickou hodnotou. LAWOSS má byť alternatíva **od reálnych advokátov pre reálnu prax**, overovaná na konkrétnych use cases, nie technologické demo. Cieľ: aby pokročilé AI workflowy neboli dostupné len najväčším kanceláriám. Preferencia: skoré použiteľné MVP → spätná väzba z praxe → iterácie; žiadne čakanie na „dokonalú produkčnú verziu". Sekundárny efekt: aktivizácia komunity.
2. **Free a open source, monetizácia cez služby** *(→ Q22)*. Nejde o SaaS biznis; zarába sa na školeniach, workshopoch, prednáškach a implementačnej pomoci. Jadro sa nezamyká. Zároveň ale MČ otvoril ochranu projektu: nechce „premaľovaný platený fork" ani vyťahovanie funkcií do plateného produktu bez atribúcie — a výslovne nechce stáť na silnej trademarkovej ochrane. **Licenčné rozhodnutie zatiaľ neurobil** *(→ B5)*.
3. **Governance bez bottlenecku** *(→ Q01, Q05)*. Jeden človek smie rozseknúť pat, ale MČ **nechce byť jediný, kto reviewuje a merguje** — všetci štyria majú mať reálnu právomoc review/merge v rámci dohodnutých pravidiel; väčšie veci na pravidelných calloch.
4. **Komunitné príspevky s jasným procesom** *(→ Q23, proces)*. Ktokoľvek môže otvárať issues a PR; feature requests majú jednoduchú formálnu cestu (šablóna, kategórie, transparentné stavy); **priorizáciu drží core tím** — komunitné návrhy nie sú automaticky záväzné.
5. **Dokumentácia pre advokáta, nie pre developera**. Priorita: používateľská dokumentácia, onboarding, návody a reálne use cases; technická dokumentácia len v rozsahu potrebnom na údržbu a prispievanie. Advokát bez technického backgroundu musí vedieť nástroj spustiť a používať.
6. **Roadmapa „free style"** *(→ Q06)*. Orientačná, aktualizovaná nepravidelne, nič sa nesľubuje ako pri platenom produkte; releasy podľa pripravenosti a kapacity. Roadmapa ukazuje „what to look forward to", nevytvára komerčné záväzky.
7. **Integrácie: modulárne, vendor-neutral, kurátorované** *(→ Q19, Q23)*. Nepodporovať všetko bez kontroly, nenapchať do jadra náhodné integrácie, neviazať sa na jedného vendora. Komunita navrhuje, core tím rozhoduje, čo je súčasť hlavného smeru.

---

## A · Riadenie produktu a zodpovednosť

### Q01 · Kto je konečný product owner?

**Znenie:** A — MČ ako product owner, pri zásadných rozhodnutiach konzultuje tím · B — spoločné rozhodovanie všetkých štyroch jednomyseľne · C — iný model. *Odporúčanie dokumentu: A — produkt potrebuje jedného rozhodovateľa pri pate, autorstvo a námietky sa zaznamenávajú.*

> **IR:** „A. Produkt musí mať jedného človeka, ktorý rozsekne pat, a to je prirodzene Majo. Výhrady si zapisujme, ale rozhoduje on."
>
> **VŘ** *(⚠️ bez silnej preferencie)*: „A — Product owner MČ. Produkt potřebuje jednoho člověka, který rozsekne pat; MČ je autor většiny podkladů a jediný, kdo drží celý obraz. **Podmínka:** rozhodnutí, která se odchylují od přijatého ADR, ať mají písemné odůvodnění, aby šlo zpětně dohledat proč."
>
> **MF:** „A — MČ ako product owner; pri zásadných otázkach konzultácia tímu, pri pate jeden rozhodovací bod."

**MČ — myšlienkový proces:** rolu prijíma; jeden vedúci človek kvôli rýchlosti, zásadné veci (doktrína, monetizácia, regulované workflowy) konzultuje vopred. Dôležitý dodatok z prierezového postoja 3: product owner ≠ bottleneck — **všetci štyria majú mať schopnosť review, merge a rozhodovania v rámci pravidiel**; PO rozsekáva pat, nedrží každý kľúč.

**U1 — návrh znenia:** Product owner je MČ. Zásadné veci konzultuje vopred; pat rozsekáva on; výhrady a odchýlky od prijatých ADR sa písomne zaznamenávajú *(podmienka VŘ)*. Všetci štyria členovia majú právomoc review a merge v rámci pravidiel ADR 0011.

---

### Q02 · Kto vlastní upstream sync s LegalWorkom?

**Znenie:** A — jeden menovaný maintainer + AI agent, druhý člen review · B — rotačná zodpovednosť · C — externý technický maintainer. *Odporúčanie: A, s povinným checklistom a `PATCHES.md`.*

> **IR:** „A. Nech sync vlastní jeden človek s AI pomocou a druhý po ňom pozrie. Podmienka: poctivo vedený zoznam našich zásahov do prevzatého kódu, aby sync vedel zopakovať hocikto. **Automat, ktorý pri konflikte sám otvorí PR s prehľadom, dodám.**"
>
> **VŘ** *(✅ opreté o prax)*: „A — Jeden pojmenovaný maintainer s AI asistencí, druhý dělá review. **Nehlásím se o tuto roli** — na upstream sync nemám kapacitu ani prostředí. Beru na sebe review všeho, co se dotýká CZ vrstvy (lokalizace, CZ konektory, CZ právní jádro). Souhlasím s podmínkou IR na poctivě vedený `PATCHES.md`."
>
> **MF:** „A — jeden menovaný maintainer s AI podporou a druhý ľudský reviewer; zásahy do upstreamu evidovať v `PATCHES.md`."

**MČ — myšlienkový proces:** súhlas s modelom A; otvorené je len rozdelenie rolí medzi ním a IR (obaja prichádzajú do úvahy; VŘ sa vylúčil, MF sa neprihlásil). MČ robí denne s agentmi nad oboma repami, IR ponúkol automat — logické kombinácie sú „MČ maintainer + IR reviewer" alebo obrátene.

**U2 — návrh znenia:** Upstream sync vlastní jeden menovaný maintainer s AI podporou; druhý člen robí review, VŘ review CZ vrstvy. Každý zásah do prevzatého kódu sa eviduje v `PATCHES.md` tak, aby sync vedel zopakovať ktokoľvek. IR dodá automat, ktorý pri konflikte otvorí PR s prehľadom. Sync beží ako samostatný PR s regresnými testami; synchronizuje sa z release tagov upstreamu, nie z ľubovoľných commitov.

**B2 — otvorené:** mená. Na stôl: **MČ maintainer + IR reviewer** *(alternatíva: obrátene)*.

---

### Q03 · Kto môže schváliť release?

**Znenie (navrhované minimum):** product owner · technická verifikácia · domain owner funkcií v release · osobitný legal/security sign-off pri regulovaných workflowoch.

> **IR:** „Súhlasím s navrhovaným minimom. Právny sign-off pri citlivých veciach (podpisovanie, konverzia, AML) beriem na seba."
>
> **VŘ** *(✅)*: „Souhlas s navrženým minimem — a **beru na sebe právní sign-off pro české právo** (autorizovaná konverze dle z. č. 300/2008 Sb., ISDS, CZ lhůty, CZ AML), zrcadlově k tomu, co IR vzal za SK. **Bez toho by dvoujurisdikční projekt měl sign-off jen na jednu polovinu.**"
>
> **MF:** „Release vyžaduje product, technickú a doménovú kontrolu; pri regulovaných workflowoch samostatný príslušný právny a bezpečnostný sign-off."

**MČ — myšlienkový proces:** súhlas; berie technickú verifikáciu a release security. Dvojjurisdikčné zrkadlo IR (SK) / VŘ (CZ) považuje za veľký prínos Vojtovej odpovede — bez neho by CZ polovica visela.

**U3 — návrh znenia:** Release schvaľuje product owner + technická verifikácia + doménový vlastník funkcií v release; pri regulovaných workflowoch navyše právny sign-off — **IR za SK, VŘ za CZ**; release security MČ.

---

## B · Vetvy, review a release

### Q04 · Zostane `dev` integračnou aj default vetvou?

**Znenie:** A — áno, kopírujeme upstream, stabilitu označujeme tagmi · B — zaviesť stabilný `main`. *Odporúčanie: A počas MVP — menej odchýlok od upstreamu, menej konfliktov.*

> **IR:** „A. Čím menej sa odchýlime od pôvodného projektu, tým menej roboty s preberaním noviniek. Stabilné body označujme tagmi."
>
> **VŘ** *(⚠️)*: „A — `dev` jako integrační i default větev po dobu prvního MVP. Čím méně odchylek od upstreamu, tím méně práce se sync. Stabilní body značit tagy."
>
> **MF:** „A — `dev` zostáva integračnou/default vetvou a stabilita sa označuje tagmi."

**MČ:** A — zodpovedá realite forku od prvého dňa.

**U4 — návrh znenia:** `dev` zostáva integračnou aj default vetvou; stabilné body sa tagujú (`v<upstream>-lawoss.<n>`). Prehodnotiť pri prvom verejnom pilote.

---

### Q05 · Aké review minimum používame?

**Znenie:** malé docs — autor môže merge po automatických kontrolách · funkčný kód — min. 1 ľudský review · security/privacy/QES/konverzia — domain review + sign-off · upstream sync — samostatný PR a regresné testy. **Otázka: záväzné aj tam, kde to GitHub Free technicky nevynucuje?**

> **IR:** „Áno, a berme to záväzne aj tam, kde nám to GitHub technicky nevynúti. Keď to niekto poruší, zmena sa vráti a ide sa ďalej, žiadna dráma."
>
> **VŘ** *(✅)*: „Ano, závazně — včetně míst, kde to GitHub Free nevynutí. Doplňuji jednu položku: **změna v katalogu lhůt nebo v registrech pro AML je ‚funkční kód', ne ‚docs'**, i když je to markdown. Špatné číslo v tabulce lhůt je stejná škoda jako chyba v kódu, jen se hůř najde."
>
> **MF:** „Áno — minimá review sú záväzné aj vtedy, keď ich GitHub technicky nevynúti."

**MČ — myšlienkový proces:** áno, záväzne — a k tomu governance dodatok: nechce byť jediný reviewer; všetci štyria core členovia majú právo review a merge; komunitné PR sú vítané, ale core tím drží kontrolu kvality. **Kontext zo 17. 8.:** šesť PR vrátane specov bolo zlúčených autorom bez odklepu — pravidlá totiž nehovorili, *kto smie mergovať*. Presne túto dieru zapĺňa [ADR 0011](../decisions/0011-proces-zmien-a-mergovania.md) *(→ B7)*.

**U5 — návrh znenia:** Review minimá sú záväzné aj bez technického vynútenia: docs po CI; funkčný kód min. 1 ľudský review; regulované témy + doménový sign-off; upstream sync samostatný PR s regresnými testami. **Katalógy lehôt a zoznamy registrov sa počítajú ako funkčný kód** *(VŘ)*. Porušenie = revert bez drámy. Kto smie čo mergovať určuje ADR 0011.

---

### Q06 · Čo vydávame v prvej fáze?

**Znenie:** A — iba zdrojový kód a návod · B — nepodpísané testovacie buildy · C — podpísané a notarizované macOS a Windows buildy. *Odporúčanie: A pre interný vývoj, potom C pre verejný pilot; B iba s výrazným varovaním.*

> **IR:** „Najprv len kód a návod (A), verejnosti až podpísané buildy (C). Nepodpísané nanajvýš pre nás štyroch s jasným varovaním. **A moje meno sa so sťahovaním binárok nespája, to je moja červená čiara.**"
>
> **VŘ** *(✅)*: „A, poté C. **Mám tutéž červenou čáru jako IR:** jsem advokát zapsaný v ČAK a nesu kárnou i odpovědnostní expozici. Moje jméno se nespojí s distribucí nepodepsaných binárek. Nepodepsané buildy nanejvýš uvnitř týmu, s výslovným varováním."
>
> **MF:** „A → C — verejne najprv zdrojový kód a návod; verejné binárky až po podpise/notarizácii, nepodpísané iba interne s výslovným upozornením."

**MČ — myšlienkový proces:** obsahovo A → C tiež — ale s dôrazom z prierezového postoja 1: **verejné MVP čo najskôr**. Advokátom dnes predávajú slabé AI wrapery; každý mesiac čakania je mesiac, keď trh formujú iní. Nechce však lámať červené čiary kolegov — riešenie vidí v tom, že „rýchlo" znamená *rýchlo zverejnený kód + rýchlo rozbehnutý podpisový proces*, nie verejné nepodpísané binárky. Dopĺňa vlastné podmienky: pred prvým verejným buildom vyriešená známka LAWOSS (rešerš cez TMview) a `LICENSE` v repe.

**U6 — návrh znenia:** Verejne od začiatku zdrojový kód a návod; verejné binárky **až podpísané a notarizované** (mac aj Windows); nepodpísané buildy len interne s varovaním. Podpisový proces sa rieši **hneď, ako súčasť príprav MVP** — nie „raz". Mená IR a VŘ sa nespájajú s distribúciou nepodpísaných binárok *(osobné podmienky účasti)*.

**B8 — otvorené:** kto platí podpisové certifikáty (Apple Developer, Windows code-signing) a na koho subjekt znejú.

---

## C · Prvá produktová iterácia

### Q07 · Ktoré tri vertikály sú prvé?

**Znenie — kandidáti:** reconciliation s human approval · onboarding subjektov + AML research · základné spisové skills · billing · transkripcia · OCR ingest · lehoty a kalendár. *Odporúčaná trojica: 1. OKF + L2 spisová pamäť, 2. reconciliation, 3. onboarding `light` cez existujúce MCP. L1/L3 sa špecifikujú súbežne, prvá implementácia úzka a merateľná.*

> **IR:** „Súhlasím s trojicou: spisy a pamäť, učenie zo schvaľovania, preverovanie subjektov. Jedna prosba: **lehoty nech sú prvý náhradník**, keď sa uvoľní miesto. Právne jadro k nim už je hotové (#33) a **zmeškaná lehota je to, čo advokáta reálne položí.**"
>
> **VŘ** *(✅, jediná vecná ODCHÝLKA)*: „Navrhuji trojici: **(1) OKF + L2 spisová paměť, (2) reconciliation s human approval, (3) lhůty a timeline.** Tedy lhůty **do** první trojice, nikoli jako první náhradník. **Důvod není preference, ale cena.** Argument proti lhůtám byl vždy, že chybí právní jádro. To už neplatí: SK jádro dodal IR (PR #33 — 12 pravidel, 14 lhůt, 14 pastí, 19 testů), CZ jádro dodávám tímto (30 pravidel, 25 lhůt, 18 pastí, 24 testů, každé ustanovení ověřené proti plnému znění předpisu) a deterministický výpočetní engine pro ČR běží u mě v praxi a jde přispět. Zbývá GUI a zápis do spisu. To je **nejlevnější zbývající vertikála ze všech kandidátů** — a zároveň ta, kterou jako kandidáta č. 1 navrhl MF a o které IR píše, že advokáta reálne položí. Řadit ji za onboarding znamená odložit nejlevnější viditelnou hodnotu. Onboarding v režimu `light` navrhuji jako **první náhradník** — prohození, ne vyřazení."
>
> **MF:** „1. OKF + L2 pamäť, 2. reconciliation s ľudským schválením, **3. deadlines/calendar**. Termíny majú vysokú praktickú hodnotu a existujúce právne jadro; light onboarding je ďalší krok."

**MČ — myšlienkový proces:** OKF + trojvrstvová pamäť je jeho hlavná produktová priorita — o prvých dvoch miestach niet sporu. Pri treťom mieste mal už v pôvodnom drafte poznámku, že Vojtov argument ceny je silný: onboarding `light` je vďaka existujúcim MCP serverom (ORSR, RPO, RPVS, FS…) skôr **integračná** než výskumná práca a počká ako náhradník; lehoty majú hotové právne jadro pre obe jurisdikcie, bežiaci engine a najviditeľnejšiu hodnotu („zmeškaná lehota advokáta položí" je aj marketingovo najzrozumiteľnejší prípad). Stav hlasovania: VŘ + MF za lehoty, IR výslovne súhlasí s vedomou zámenou — **rozhodnutie je na MČ ako PO.**

**B1 — na rozhodnutie:** tretia vertikála. Odporúčanie na stôl: **1. OKF + L2 · 2. reconciliation · 3. lehoty a timeline; onboarding `light` prvý náhradník.**

---

### Q08 · Čo znamená MVP billing?

**Znenie:** A — iba časové záznamy a export · B — čas, sadzby, náklady a podklady pre faktúru · C — vystavenie účtovného dokladu a napojenie na účtovníctvo. *Odporúčanie: B.*

> **IR:** „B. Evidencia času, sadzby a podklad pre faktúru áno; samotné vystavovanie dokladov a účtovníctvo je iná liga zodpovednosti, nechajme na neskôr."
>
> **VŘ** *(✅)*: „B. Doplněk z praxe: **české kanceláře už spisový a fakturační systém většinou mají** (u nás Evolio). Pro reálné nasazení je proto důležitější **exportní formát a rozhraní ven** než vlastní fakturace uvnitř. Kdyby se mělo mezi ‚vlastní billing' a ‚dobrý export' volit, beru export."
>
> **MF:** „B — čas, sadzby, náklady a podklady pre fakturáciu; účtovné doklady až neskôr."

**MČ:** B; Vojtov posun ťažiska na export považuje za správny — LAWOSS nemá nahrádzať účtovníctvo, má doňho vedieť čisto odovzdať dáta.

**U7 — návrh znenia:** MVP billing = čas, sadzby, náklady, podklad pre faktúru. Prioritou je **export a rozhranie do existujúcich systémov kancelárií**; vystavovanie dokladov a účtovné integrácie mimo scope prvej fázy.

---

### Q09 · Je anonymizácia formálne vyradená z V1?

**Znenie:** navrhované rozhodnutie áno (`nice to have`, budúci voliteľný modul); otázkou sú podmienky znovuotvorenia.

> **IR:** „Áno, odložiť. Vrátime sa k tomu, keď prvý z nás bude reálne potrebovať poslať obsah spisu do cloudu; detekčné vzory medzitým ležia pripravené (#36)."
>
> **VŘ** *(✅)*: „Ano, odložit — s podmínkou, že se **předem pojmenuje spouštěč návratu**, ne že se to nechá na citu. Navrhuji: *okamžik, kdy má kterýkoli workflow poslat obsah spisu do cloudového modelu.* Do té doby je to bezpředmětné, od té chvíle blokující. Vázán jsem mlčenlivostí podle § 21 z. č. 85/1996 Sb., která nemá výjimku pro ‚technický mezikrok'."
>
> **MF:** „Áno — anonymizácia mimo V1; znovu otvoriť pri cloudovom spracúvaní vecných dát alebo pri verejnom pilote."

**MČ:** áno (potvrdené už na calle 12. 8.); k Vojtovmu spúšťaču dopĺňa druhý — podmienka pilotu u tretej osoby.

**U8 — návrh znenia:** Anonymizácia je mimo V1. Pomenované spúšťače návratu: **(1)** prvý workflow, ktorý má poslať obsah spisu do cloudového modelu; **(2)** podmienka pilotného nasadenia u tretej osoby; **(3)** verejný pilot *(MF)*. Detekčné vzory (#36) sú pripravené v zásobe.

---

## D · Pamäť a reconciliation

### Q10 · Čo presne patrí do L1, L2 a L3?

**Znenie — treba potvrdiť:** vlastníka každej vrstvy · povolené typy údajov · retention a mazanie · práva čítania/zápisu · pravidlá prenosu medzi vrstvami · provenance a verzovanie.

> **IR:** „Zjednodušene: osobné nastavenia bez klientskych dát, spisová pamäť prísne lokálna per vec, spoločná právnická pamäť len z verejných zdrojov. Vlastníkov vrstiev doklepnime na calle."
>
> **VŘ** *(✅, z vyše roka prevádzky trojvrstvovej pamäte)*:
>
> | Vrstva | Vlastník | Obsah | Kde leží |
> |---|---|---|---|
> | L1 | uživatel / kancelář | preference, formátovací pravidla, styl, zvyklosti | lokálně, bez klientských dat |
> | L2 | jedna věc | fakta, stav, chronologie, lhůty, taktická rozhodnutí | **lokálně, bez výjimky** |
> | L3 | právní znalostní vrstva | zdroje, citace, argumentační vzory, jurisdikce, časová platnost | sdílitelné, **jen z veřejných zdrojů** |
>
> „Dvě věci navíc, obojí z provozu: **(1) záznamy musí být typované** (`user` / `feedback` / `project` / `reference`) — netypovaná paměť po pár měsících splyne v jednu hromadu a přestane se dát revidovat; **(2) musí existovat vrstva ‚poučení z chyby'**, oddělená od faktů — co se model naučil špatně, je jiná kategorie než co je ve spisu, a maže se jinak."
>
> **MF:** „L1 osobné nastavenia bez klientskych dát, L2 lokálna pamäť konkrétnej veci, L3 zdieľaná pamäť iba z verejných a overených zdrojov; **každá vrstva musí mať vlastníka, provenance a retenčné pravidlá.**"

**MČ — myšlienkový proces:** súhlas s definíciami — a dopĺňa architektonický rámec, ktorý v hlasovej diskusii opísal ako „brain/OKF model": pamäť nie je databáza, ale **lokálna súborová štruktúra** — úroveň advokáta → úroveň klienta/projektu → úroveň jednotlivého spisu, všetko v prenositeľných otvorených súboroch (Markdown). Cieľ: **nezávislosť od konkrétneho AI harnessu** — priečinok klienta/spisu má byť otvoriteľný v Claude Code, Codexe, OpenCode alebo čomkoľvek budúcom, a nový agent má z lokálnej štruktúry okamžite načítať kontext, stav a zmeny. Provenance a verzovanie od prvého dňa — bez nich reconciliation (spec 0009) nefunguje. Na calle treba zosúladiť názvoslovie L1/L2/L3 s týmto praktickým modelom (nie je to spor, len dve optiky na to isté).

**U9 — návrh znenia:** L1 osobné preferencie bez klientskych dát · L2 pamäť jednej veci, prísne lokálna · L3 spoločná právnická pamäť výhradne z verejných zdrojov. Každá vrstva má vlastníka, provenance, verzovanie a retenčné pravidlá. Záznamy sú **typované**; existuje oddelená vrstva **„poučenie z chyby"**. Pamäť fyzicky žije ako **brain/OKF v otvorených lokálnych súboroch** (advokát → klient/projekt → spis), prenositeľná medzi harnessami. Detailný dátový kontrakt patrí do specu 0002.

---

### Q11 · Kto schvaľuje povýšenie poznatku?

**Znenie:** povýšenia L2→L1, L2→L3, lokálny vzor → kancelárske pravidlo, právny vzor → spoločná pamäť. *Odporúčanie: žiadne autonómne povýšenie; agent iba navrhuje a vysvetľuje diff.*

> **IR:** „Nič sa nesmie ‚naučiť' samo. Agent navrhne a ukáže rozdiel, schvaľuje človek. Vždy."
>
> **VŘ** *(✅, s doloženým incidentom)*: „Žádné autonomní povýšení — bez výjimky. Mám doloženo proč: v mé praxi se stalo, že **subagent bez přístupu ke sdílené paměti zopakoval judikát, který už byl dřív vyhodnocen jako problematický.** Ponaučení: povýšení poznatku není jen otázka souhlasu, ale i **distribuce** — co se schválí, musí se dostat ke všem agentům, jinak si systém odporuje sám se sebou."
>
> **MF:** „Žiadna autonómna propagácia — agent navrhne diff, ale povýšenie vždy schváli človek; **YOLO túto hranicu neodomyká.**"

**MČ — myšlienkový proces:** súhlas so schvaľovaním človekom. Jediné, čo si v hlasovej diskusii nechal otvorené, bolo, či jeho návrh konfigurovateľnej autonómie (Q21) smie zahŕňať aj povýšenie pamäti. Po odpovediach je stav jasný: IR „vždy", VŘ s doloženým incidentom, MF výslovne „YOLO to neodomyká" — traja z troch za tvrdú hranicu. *(→ B4 na potvrdenie.)*

**U10 — návrh znenia:** Povýšenie poznatku schvaľuje **vždy človek**; agent navrhuje a ukazuje diff. Schválené sa **distribuuje všetkým agentom** *(VŘ — inak si systém odporuje)*. Žiadny režim autonómie túto hranicu neodomyká.

---

### Q12 · Aká je periodicita reconciliation?

**Znenie:** pri každej významnej zmene · denne · týždenne · pri uzavretí fázy/spisu · kombinácia. *Odporúčanie: kombinácia.*

> **IR:** „Kombinácia: hneď pri dôležitej udalosti, raz týždenne upratať, a na záver veci urobiť bodku."
>
> **VŘ** *(✅)*: „Kombinace: okamžitý návrh při významné události, týdenní konsolidace, závěrečná kontrola při uzavření věci."
>
> **MF:** „Event trigger + týždenná konsolidácia + kontrola pri uzavretí veci."

**MČ:** kombinácia; z praxe nemá dôvod na inú kadenciu.

**U11a — návrh znenia:** Reconciliation beží ako kombinácia: okamžitý návrh pri významnej udalosti + týždenná konsolidácia + záverečná kontrola pri uzavretí veci.

---

### Q13 · Aké metriky rozhodnú, že reconciliation funguje?

**Znenie — navrhované minimum:** počty navrhnutých/schválených/upravených/odmietnutých zmien · false promotion rate · duplicity a konflikty · čas ľudskej kontroly · úspešnosť rollbacku · úplnosť provenance.

> **IR:** „Súhlasím s navrhnutým zoznamom. Najviac ma zaujímajú dve čísla: **koľko nezmyslov sa omylom schváli a koľko času nám kontrola reálne berie.**"
>
> **VŘ** *(✅)*: „Souhlas + jedna metrika navíc: **‚kolik z toho, co agent navrhl, advokát přepsal, a v čem'**. Není to metrika správnosti, ale **metrika stylu** — a právě styl je podle spec 0003 to, co advokáta odlišuje. Když toto číslo neklesá, prompt layer se neučí."
>
> **MF:** „Sledovať návrhy, schválenia, úpravy, odmietnutia, false promotion rate, konflikty, čas ľudskej kontroly, rollback a úplnosť provenance."

**MČ — myšlienkový proces:** súhlas so zoznamom; jeho vlastný test úspešnosti je tvrdší — **ak kontrola diffu trvá dlhšie, než by trvalo spraviť vec ručne, funkcia zlyhala** bez ohľadu na ostatné metriky. Vojtovu metriku štýlu považuje za priamu väzbu na prompt layer (spec 0003).

**U11b — návrh znenia:** Metriky reconciliation: navrhnuté/schválené/upravené/odmietnuté, **false promotion rate**, **čas ľudskej kontroly** *(ak prevýši ručnú prácu, funkcia zlyhala)*, duplicity a konflikty, rollback, úplnosť provenance + **metrika štýlu**: koľko z návrhov advokát prepísal a v čom.

---

## E · Subjekty, AML a registre

### Q14 · Čo obsahujú režimy `light`, `medium` a `hard`?

**Znenie — treba určiť:** povinné registre SK/CZ (neskôr PL) · sankčné a diskvalifikačné zdroje · riešenie menovcov · timeout a čiastočný výsledok · cena/limit dotazov · frekvencia re-scanov · formát a retention reportu.

> **IR:** „K zoznamu registrov sa nevyjadrujem, tomu rozumie Majo najlepšie. Jedna podmienka: **pri menovcoch nikdy nesmie zhodu potvrdiť stroj sám, vždy človek.**"
>
> **VŘ** *(✅)*: „Za českou stranu mohu dodat konkrétní seznam registrů. Funkční dnes: obchodní rejstřík a ARES, ISIR, katastr, registr plátců DPH (nespolehlivost + zveřejněné účty), sankční screening. Chybí česká obdoba pěti slovenských konektorů — seznam v [mapě CZ zdrojů](../planning/cz-datove-zdroje.md). Dvě podmínky: (1) souhlasím s IR — jmenovce nikdy nepotvrzuje stroj sám; (2) **vlastní podmínka, ověřená provozem: sankční API bez klíče vrací prázdný výsledek i pro zjevně sankcionované osoby.** Systém proto musí ke každému screeningu pouštět **kontrolní dotaz na známý pozitivní případ**. Bez toho ‚čistý výsledek' znamená jen ‚dotaz neprošel' a metodika AML stojí na fikci."
>
> **MF:** „Zachovať režimy light/medium/hard s presne určenými zdrojmi, timeoutmi, limitmi, riešením menovcov a formátom reportu; zhodu pri menovcoch nikdy nepotvrdzuje stroj sám."

**MČ — myšlienkový proces (vlastník témy, návrh do specu):**
- **light** — SK/CZ core registre zadarmo a do minúty: ORSR/RPO, RPVS, finančná správa (DPH, daňoví dlžníci, index spoľahlivosti), diskvalifikácie, register úpadcov, obchodný vestník; bez uloženého reportu. CZ zrkadlo podľa Vojtovej mapy.
- **medium** — light + súdne rozhodnutia (vlastný mcp-judikaty: 161 k plných textov NS, 53 k ÚS, 1M citačných vzťahov), sankčné zoznamy (EU/OFAC/OpenSanctions), médiá a web; menovci vždy s ľudským potvrdením; štruktúrovaný report do spisu.
- **hard** — medium + KÚV reťazce cez viac jurisdikcií, historické zmeny v registroch, plný OSINT; časovo aj cenovo ohraničené, vždy s timeoutom a čiastočným výsledkom.
- **Re-scan:** pri otvorení novej veci s existujúcim subjektom + ročne pri aktívnych spisoch. **Retention:** report je súčasť spisu — žije a zaniká s ním.

**U12a — návrh znenia:** Režimy light/medium/hard podľa návrhu MČ (rozpíše do specu, CZ stranu dodá VŘ podľa mapy zdrojov). Záväzné poistky: **menovcov potvrdzuje vždy človek** *(IR)* a **každý sankčný screening púšťa kontrolný dotaz na známy pozitívny prípad** *(VŘ — inak je „čistý výsledok" fikcia)*.

---

### Q15 · Je AML onboarding vlajková feature alebo súčasť OKF?

**Znenie:** A — samostatná marketingová feature · B — workflow vo vnútri OKF intake. *Odporúčanie: B architektonicky, A marketingovo.*

> **IR:** „Vnútri nech je to súčasť zakladania spisu (B); navonok to pokojne komunikujme ako samostatnú funkciu." · **VŘ** *(✅)*: totožne. · **MF:** „B — AML ako workflow v OKF intake; samostatné marketingové pomenovanie je možné."

**MČ:** plná zhoda všetkých — B architektonicky, A marketingovo.

**U12b — návrh znenia:** AML onboarding je architektonicky súčasť OKF intake; navonok sa smie komunikovať ako samostatná funkcia.

---

## F · Dáta, modely a platformy

### Q16 · Musia klientské dáta zostať lokálne?

**Znenie — rozhodnúť zvlášť pre:** originálne dokumenty · L2 · L1 · L3 · telemetriu a crash reporty · zálohy.

> **IR:** „Dokumenty klientov a spisová pamäť: len lokálne, bez výnimky. Osobné nastavenia tiež. Spoločná právnická pamäť z verejných zdrojov sa zdieľať môže. Telemetria len dobrovoľná a nikdy nie obsah spisov. Zálohy šifrované a v rukách advokáta."
>
> **VŘ** *(✅)*: totožné rozdelenie + tvrdšia opora: „Pro ČR je opora tvrdší než ‚dobrá praxe': **mlčenlivost podle § 21 z. č. 85/1996 Sb.** Za její porušení nese odpovědnost advokát osobně, ne dodavatel software — což je přesně důvod, proč nemůžeme přijmout architekturu, kde je lokálnost volbou v nastavení."
>
> **MF:** „Local-first — klientské dokumenty, L1 a L2 lokálne; telemetria iba dobrovoľná a bez obsahu spisov; zálohy šifrované a pod kontrolou používateľa."

**MČ — myšlienkový proces (z hlasovej diskusie, rozsiahle):** najprv rozobral samotný predpoklad otázky. LAWOSS je **lokálna desktopová aplikácia** pracujúca s lokálnymi súbormi — v prvej fáze sa nerieši žiadny vlastný cloudový storage LAWOSS. Používateľ si sám rieši, či má priečinky v Google Drive, Dropboxe či OneDrive — **to je jeho rozhodnutie a jeho infraštruktúra**; LAWOSS mu nemá určovať, akú synchronizáciu smie používať, ale musí s takým filesystemom korektne fungovať vrátane **on-demand sťahovaných súborov**. Aplikácia môže na riziká upozorniť a odporučiť bezpečné postupy, ale nepreberá zodpovednosť za používateľovu cloudovú politiku. Druhý pilier: OKF/brain sa tvorí **lokálne v otvorených súboroch** kvôli prenositeľnosti medzi harnessami — špecializovaný cloudový alebo proprietárny backend by ju zabil. Zdieľať sa smú len vrstvy bez klientskych/dôverných údajov.

**U13 — návrh znenia:** LAWOSS je **local-first**: klientske dokumenty, L1 a L2 výhradne lokálne, bez výnimky — lokálnosť nie je voľba v nastaveniach *(opora: mlčanlivosť advokáta, v CZ § 21 z. č. 85/1996 Sb.)*. Cloudová synchronizácia priečinkov je rozhodnutie používateľa; aplikácia s ňou musí korektne fungovať (vrátane on-demand súborov), smie upozorniť na riziká, ale nepreberá za ňu zodpovednosť. L3 z verejných zdrojov sa zdieľať smie. Telemetria výhradne opt-in a nikdy nie obsah spisov. Zálohy šifrované, pod kontrolou advokáta.

---

### Q17 · Je lokálny index predvolený a RAG iba voliteľný?

**Znenie:** navrhované rozhodnutie áno pre prvú verziu; doriešiť veľkosť korpusu, aktualizácie, licencie, citačný graf, distribúciu, diskové limity.

> **IR:** „Áno, lokálne vyhľadávanie ako predvolené." · **VŘ** *(⚠️)*: „Ano — lokální index jako výchozí, RAG volitelný."
>
> **MF:** „Áno — lokálny index je predvolený, RAG voliteľný a **OKF/Markdown-first; bez centrálnej povinnej RAG vrstvy.**"

**MČ — myšlienkový proces (ide ďalej než otázka):** nechce, aby LAWOSS **vôbec stálo na centrálnom RAG systéme** — žiadne povinné chunkovanie, embeddings a vektorová databáza ako jadro. Pri právnych textoch klasický RAG nepovažuje za ideálny základ (presné znenie ustanovenia sa nedá „približne" retrievnuť). Jadrom má byť **OKF + Markdown/Obsidian-style interná wiki**: stav spisu, komunikácia, lehoty, evidencia a znalosti sa zapisujú do samostatných otvorených súborov a agent pracuje nad explicitnou súborovou štruktúrou. Externé právne zdroje (judikatúra, registre, legislatíva) sa pripájajú cez **MCP servery, CLI tools a iné otvorené rozhrania** — a tie si pokojne vedú vlastné interné indexy (judikatúrny MCP presne tak funguje: FTS index se 161 k plnými textami NS beží na vlastnom VPS). Kľúčový dôvod: **harness-agnostic prenositeľnosť** — ten istý spisový priečinok má vedieť použiť OpenCode, Claude Code, Codex aj budúci harness bez proprietárneho LAWOSS backendu. *(Po prijatí si tento princíp zaslúži vlastné ADR.)*

**U14 — návrh znenia:** LAWOSS je **OKF/Markdown-first, nie RAG-first**. Jadro tvorí otvorená súborová štruktúra spisu; externé zdroje sa pripájajú cez MCP/CLI a smú si viesť vlastné indexy; centrálny povinný RAG neexistuje. Lokálne vyhľadávanie je predvolené; RAG/embeddings sú voliteľná externá vrstva. Cieľ: prenositeľnosť medzi agentickými harnessami bez lock-inu. Princíp sa po prijatí prepíše do samostatného ADR.

---

### Q18 · Ktoré platformy podporujeme?

**Znenie:** macOS · Windows · Linux · ktoré CLI integrácie smú zostať macOS-only (Apple Notes, Reminders) · čo musí mať platformovo neutrálny fallback.

> **IR:** „Mac aj Windows rovnocenne od začiatku. Ja mám len Windows, takže testovanie Windows verzie beriem na seba (issue #41). Linux podľa síl; veci viazané na Apple appky nech majú neutrálnu náhradu."
>
> **VŘ** *(✅, poctivo)*: „**Nemohu slíbit Windows.** Pracuji na macOS a nemám prostředí, kde bych Windows build otestoval. Podporuji Windows jako first-class cíl a beru vážně zjištění IR, že tam sedí většina cílové skupiny — ale testování musí vzít někdo, kdo tu platformu má. IR to nabídl, souhlasím. Co garantovat mohu: **CZ nástroje (ISDS, ISIR, katastr, výpočet lhůt) jsou platformově neutrální** — čistý Python bez vazby na macOS."
>
> **MF:** „Multiplatformové jadro pre macOS a Windows bez nútenej parity; Linux a platformovo špecifické funkcie podľa kapacít a s neutrálnym fallbackom."

**MČ — myšlienkový proces:** traja zo štyroch v tíme robia na macOS a mac/Unix prostredie je dnes lepšie podporované lokálnymi agentickými systémami (aj LegalWork/opencode základ prirodzene sedí na Unix). Windows ale nesmie byť zanedbaný — cieľovka na ňom sedí (issue #41). Kľúčový postoj: **multiplatformové jadro áno, ale bez redukcie na najnižší spoločný menovateľ** — ak platforma umožňuje lepšiu integráciu, LAWOSS ju smie využiť; platform-specific features sú prípustné. Dlhodobo nevylučuje popri Electrone **natívnu macOS aplikáciu v SwiftUI** — rýchlejšiu, hlbšie integrovanú do OS. (S humorom dodal, že Windows používatelia by možno mali zvážiť prechod na mac — nie je to produktová podmienka. 🙂)

**U15 — návrh znenia:** Multiplatformové jadro macOS + Windows; **Windows je first-class cieľ** (testuje IR, issue #41), Linux best-effort. **Bez nútenej absolútnej feature parity** — platformovo špecifické funkcie sú prípustné, ak dávajú praktický zmysel; Apple-only integrácie potrebujú neutrálny fallback, inak nepatria do jadra. Do budúcna je prípustná natívna macOS vetva.

---

### Q19 · Patrí Poľsko do prvej architektúry?

**Znenie:** A — od začiatku neutralizovať dátové modely pre SK/CZ/PL, implementovať iba SK/CZ · B — riešiť PL až po stabilnom MVP. *Odporúčanie: A na úrovni schém a kontraktov, B na úrovni prvých integrácií.*

> **IR:** „Pripravme dátové modely tak, aby Poľsko neskôr nebolelo, ale staviame len SK a CZ."
>
> **VŘ** *(✅)*: „Datové modely připravit neutrálně pro SK/CZ/PL, implementovat jen SK a CZ. **Mapování polských zdrojů mám zadané, termín 20. 8.**"
>
> **MF:** „A pre schémy a kontrakty, B pre prvé integrácie — Poľsko pripraviť architektonicky, ale implementovať až po stabilnom SK/CZ."

**MČ — myšlienkový proces:** súhlas + širšia vízia modulárnej internacionalizácie: priebežne hľadať **technicky zdatných advokátov v Poľsku, Maďarsku, na Ukrajine a inde**, ktorí dodajú jurisdiction-specific MCP, skilly, prompty a workflowy nad pripravenou core architektúrou. VŘ môže časom prevziať CZ/PL líniu, ak sa tím dohodne.

**U16 — návrh znenia:** Dátové modely a kontrakty neutrálne pre SK/CZ/PL; implementuje sa SK/CZ. Ďalšie jurisdikcie sa dopĺňajú **modulárne cez lokálnych právnikov-contributorov** (MCP, skilly, workflowy), core na to musí byť pripravené.

---

## G · Regulované a citlivé workflowy

### Q20 · Kto vykonáva sign-off?

**Znenie — oblasti:** privacy a pamäťové hranice · AML metodika · QES a autorizácia · zaručená konverzia · licencie dát a tretích strán · release security.

> **IR:** „Návrh rozdelenia: súkromie a hranice pamäti Martin so mnou; AML ja s Majom; podpisovanie a konverzia Majo s mojím právnym sign-offom; licencie dát ja; bezpečnosť releasov Majo."
>
> **VŘ** *(✅)*: „Přijímám návrh IR a doplňuji českou stranu: **licence dat a třetích stran za ČR beru na sebe** (Salvia, Codexis, korpus komentářů) a rovněž **CZ právní sign-off** dle Q03."
>
> **MF:** „Navrhujem: MF + IR privacy/memory architektúra; IR slovenský právny sign-off; VŘ český právny sign-off; MČ technická implementácia a release security; licencie podľa jurisdikcie IR/VŘ; QES a konverzia technicky MČ, právne príslušný doménový vlastník. **Rozdelenie treba potvrdiť na spoločnom calle.**"

**MČ — myšlienkový proces:** návrhy IR a MF sa prakticky zhodujú a VŘ ich dopĺňa o CZ zrkadlo — vecne je rozdelenie hotové. MČ ale trval na zásade **roly sa neprideľujú v neprítomnosti; každý sa k svojej roli prihlási osobne** — čo MF svojou odpoveďou fakticky urobil. Zostáva to len spoločne vysloviť.

**B6 — na potvrdenie (osobne, každý za seba):** privacy/pamäť **MF + IR** · AML **IR + MČ** · QES a konverzia **MČ technicky + právne IR (SK) / VŘ (CZ)** · licencie dát **IR (SK) / VŘ (CZ)** · release security **MČ**.

---

### Q21 · Aký human-in-the-loop model je záväzný?

**Znenie:** ktoré akcie agent smie autonómne · smie pripraviť, ale nie vykonať · nesmie vôbec · musí zapísať do nemenného audit logu. **Rámec: prijaté [ADR 0007](../decisions/0007-agent-first-architektura.md)** (agent = koncipient; deterministické brány pred modelovými; technické vylúčenie podpisovania a konania navonok).

> **IR:** „Sám smie agent čítať verejné zdroje, pripravovať návrhy a udržiavať poriadok v spise. Pripraviť, ale neodoslať: čokoľvek, čo ide von z kancelárie, a zápisy do pamäti. Nikdy: podať niečo na súd, komunikovať s tretími osobami v mene advokáta, poslať neanonymizovaný spis do cloudu. A toto všetko nech ostáva v nezmazateľnom zázname."
>
> **VŘ** *(✅, najsilnejšie doložená pozícia — presne tento model prevádzkuje)*: tabuľka smie samostatne / smie pripraviť / nesmie nikdy zhodná s IR + kľúčový prevádzkový princíp: „**Hranice nesmí být v promptu, ale v nástroji.** Prompt ‚neodesílej bez potvrzení' model občas obejde. U mě je pravidlo vynucené tak, že odesílací nástroj má povinný `--dry-run` krok a exfiltračně rizikové funkce jsou z nástrojové plochy odstraněné úplně — u jednoho z komunikačních konektorů jsem plochu zúžil ze **79 nástrojů na 12** a vypnul webhook zneužitelný přes prompt injection. Doporučuji zapsat do ADR 0007: **co agent nesmí, mu nemá jít nabídnout.**"
>
> **MF:** „ADR 0007 tvorí záväzný rámec: agent môže autonómne čítať, pripravovať návrhy a organizovať internú prácu, ale výstup sa nesmie použiť bez ľudskej verifikácie. Podpisovanie, podanie, externé odoslanie, finančné úkony a odoslanie neanonymizovaného spisu do cloudu musia byť **technicky nedostupné**; všetky relevantné kroky v audit logu."

**MČ — myšlienkový proces (jeho najväčší vlastný vklad do diskusie):** navrhol, aby miera autonómie bola **konfigurovateľná používateľom**, ako v coding harnessoch (Claude Code, Codex, OpenCode): 1. *always ask* — agent sa pýta pred relevantnými akciami · 2. *ask on sensitive* — autonómne, pýta sa pri citlivých krokoch · 3. *high autonomy* · 4. **YOLO mode** („You Only Live Once") — vedomé povolenie veľmi širokej autonómie. Dôvody: systém nemá všetkým nanútiť jednu úroveň dohľadu; skúsený používateľ s necitlivou agendou nemá klikať potvrdenia; YOLO nikdy nie je default, je to vedomá voľba. Sám pritom uznáva napätie s ADR 0007 a žiada rozlíšiť **technicky povoliteľnú autonómiu** vs. **tvrdé právne/systémové hranice**, ktoré sa nesmú obísť v žiadnom režime.

**Syntéza (K2):** pozície sa zmieria rozdelením na dve roviny — a MF aj VŘ odpovedali presne v tomto duchu:

| Rovina | Obsah |
|---|---|
| **Konfigurovateľná autonómia** *(voľba používateľa)* | vnútorná práca v spise: čítanie, rešerš, drafty, poriadok, výpočty — od *always ask* po YOLO; YOLO nikdy default |
| **Tvrdé hranice** *(technicky nedostupné v každom režime)* | podpis · podanie · odoslanie čohokoľvek von · finančné úkony · neanonymizovaný spis do cloudu · **povýšenie pamäti** *(IR + VŘ + MF zhodne)* |

**B4 — na potvrdenie MČ:** delenie vyššie + zaradenie povýšenia pamäti medzi tvrdé hranice + doplniť do ADR 0007 vetu VŘ *„čo agent nesmie, nemá sa mu dať ponúknuť"* (hranica v nástroji, nie v prompte).

---

## H · Open source, financovanie a komunita

### Q22 · Je celý softvér a všetky základné moduly bezplatné?

**Znenie:** všetko open source, platené len školenia a implementačná pomoc · open core + platené moduly · platené hostovanie/distribúcia.

> **IR:** „Všetko zadarmo a otvorené; zarábame na školeniach a pomoci so zavedením. **Platené moduly odmietam:** v momente, keď predávame softvér, sme dodávateľ softvéru so všetkým, čo k tomu patrí, a presne to sme si na začiatku vylúčili."
>
> **VŘ** *(✅)*: „Vše zdarma a otevřené; souhlasím s IR i v důvodu — v okamžiku, kdy prodáváme software, jsme dodavatel software se vší odpovědností, a tomu jsme se chtěli vyhnout."
>
> **MF:** „Všetko základné zadarmo a otvorené; monetizácia cez školenia a implementačnú pomoc, nie cez uzamknuté jadro."

**MČ — myšlienkový proces:** free/open core potvrdzuje opakovane (prierezový postoj 2): školenia, workshopy, prednášky, onboarding, implementačná pomoc, support a consulting — nie SaaS, nie zamknuté jadro. *(V širšej licenčnej debate raz pripustil, že „do budúcna možno nejaké platené funkcie" nie sú úplne vylúčené — pri finálnej odpovedi na Q22 ale potvrdil základný free/open model; ak má byť zákaz platených modulov absolútny, treba to na calle vysloviť explicitne.)* Samostatnú tému otvoril pri ochrane: nechce premaľovaný platený fork ani vyťahovanie funkcií bez atribúcie, chce čo najpermisívnejší režim s určitou ochranou — a **nechce stáť na trademarkovej ochrane**. Vie, že tieto ciele sa bežnou open-source licenciou nedajú dosiahnuť všetky naraz: zákaz komerčného použitia nie je open source; MIT dovoľuje komerčné forky; copyleft (AGPL) udrží otvorenosť derivátov, ale nezakáže zarábanie. Prijaté [ADR 0010](0010-ochrana-know-how-a-znacky.md) stavia ochranu na značke, komunite a tempe — s jeho výhradou k trademarku je v miernom napätí.

**U17 — návrh znenia:** Všetok kód a všetky základné moduly sú open source; monetizácia výhradne cez školenia, workshopy a implementačnú pomoc; **žiadne platené moduly** *(potvrdenie ADR 0002)*.

**B5 — otvorené (licencia):** zadať samostatnú rešerš **MIT vs. Apache-2.0 vs. MPL-2.0 vs. GPL/AGPL vs. source-available** s ohľadom na ciele MČ (permisívnosť + atribúcia + sťaženie uzavretého komerčného privlastnenia, bez opory v trademarku) a s termínom; do rozhodnutia platí MIT z voľby základu.

---

### Q23 · Čo publikujeme späť komunite?

**Znenie:** SK/CZ lokalizácie · všeobecné opravy LegalWorku · modulové rozhranie · OKF špecifikácia · skills · MCP servery · datasety a indexy s vyjasnenou licenciou.

> **IR:** „Vraciame komunite všetko vymenované, pri dátach s vyjasnenou licenciou. Zbierky zákonov a rozhodnutí NS SR už máme pripravené na zverejnenie, čakajú len na repozitáre (#40 — odblokované)."
>
> **VŘ** *(✅)*: „Vracet vše vyjmenované. Za CZ konkrétně nabízím: CZ pravidla počítání lhůt + testovací sada (připraveno) · mapa CZ datových zdrojů (připraveno) · výpočetní engine lhůt (lze uvolnit) · ISDS/ISIR/katastr nástroje (po odstranění provozních specifik) · korpus ~94 komentářů (Apache-2.0). **⚠️ Výhrada ke korpusu:** je to sekundární, nerecenzovaný materiál generovaný s AI. Publikovat lze, **citovat v podání ne** — mám doložené případy, kdy formulace vynechala slova nosná pro petit. Bez tohoto varování přiděláme kolegům problém místo pomoci. Cennější než korpus je **dvoustupňový vzor ‚navigace → povinné doověření v primárním prameni'**, který je zároveň odpovědí na požadavek spec 0004 na verifikaci citací."
>
> **MF:** „Publikovať upstream opravy, modulové rozhrania, OKF, skills a MCP; datasety a indexy iba s vyjasnenou licenciou a provenance, nikdy klientské dáta."

**MČ — myšlienkový proces:** oddeľuje dve roviny, ktoré sa v diskusii zlievali. **(1) Upstream do LegalWorku:** case-by-case — lokalizácie a všeobecné technické opravy áno; jurisdikčné skilly, MCP, OKF, brain/memory a špecializované právnické workflowy zostávajú LAWOSS moduly, lebo LAWOSS sa bude od upstreamu produktovo čoraz viac odlišovať; neupstreamovať automaticky 100 % nových features. **(2) Publikovanie komunite:** široké — všetko vymenované, s vyjasnenou licenciou zdroja.

**U18 — návrh znenia:** Komunite vraciame všetko vymenované (lokalizácie, opravy upstreamu, modulové rozhranie, OKF špecifikáciu, skilly, MCP); datasety a indexy len s vyjasnenou licenciou a provenance, nikdy klientske dáta. AI generovaný korpus komentárov len s varovaním **„citovať v podaní nie"**; publikuje sa aj vzor „navigácia → povinné dooverenie v primárnom prameni". **Upstream do LegalWorku je case-by-case:** všeobecné opravy a lokalizácie áno, LAWOSS-specific nadstavba nie; rozhoduje maintainer syncu s PO.

---

### Q24 · Prijímame základnú produktovú doktrínu LAWOSS?

**Znenie:** doktrína = kontrola používateľa, individualizácia, otvorenosť, agent-first s právnikom ako supervízorom ([ADR 0009](0009-zakladna-produktova-doktrina.md)). A — záväzná; výnimka len cez ADR s odôvodnením, mitigáciou a časovým obmedzením · B — nezáväzná vízia · C — nie.

> **IR:** „A. Nech je to záväzný meter na budúce rozhodnutia; výnimka len písomne, s dôvodom a časovým obmedzením."
>
> **VŘ** *(✅)*: „A — závazná doktrína, výjimka jen písemně, s odůvodněním a časovým omezením."
>
> **MF:** „**A s odľahčenou výnimkou** — doktrína je záväzná, odchýlka musí mať krátke písomné odôvodnenie, mitigáciu a časové obmedzenie."

**MČ — myšlienkový proces (jediný väčší rozpor, K1):** pôvodná formulácia mu v hlasovej diskusii prišla abstraktná; po preformulovaní na praktickú otázku *„chceme pevné pravidlá, podľa ktorých sa rozhoduje, či funkcia patrí do LAWOSS, alebo rozhodovať prípad od prípadu?"* odpovedal, že preferuje **prípad od prípadu** — doktrína ako orientačný rámec, nie rigidný blocker; pragmatické rozhodovanie ho neviaže pri neočakávaných situáciách. Háčik: A bolo **jeho vlastné pôvodné odporúčanie**, ostatní traja hlasovali za záväznosť a MF práve schválil ADR 0007, ktoré je pilierom doktríny. MF-ova „odľahčená výnimka" je pritom presne mostík medzi oboma polohami: doktrína viaže, ale odchýlka nestojí plný ADR — stačí krátke písomné odôvodnenie + mitigácia + časové obmedzenie. Case-by-case flexibilita tak zostáva, len zanecháva stopu.

**B3 — na rozhodnutie MČ:** prijať **A s odľahčenou výnimkou** *(návrh MF — IR a VŘ s tým nebudú mať problém, je to mäkšia verzia ich A)*, alebo trvať na case-by-case a vysvetliť tímu prečo.

---

### Q25 · Majú byť otvorené formáty jadrom LAWOSS?

**Znenie (návrh MČ):** *Open formats at the core, compatibility at the edges.* A — Markdown/HTML/JSON kanonické, DOCX/XLSX/PPTX ako OOXML výmenné formáty, Teams/SharePoint voliteľné integrácie · B — otvorené formáty + OOXML rovnocenné jadro · C — bez kanonického formátu.

> **IR:** „A, s jednou praktickou podmienkou: **Word nesmie byť druhá kategória.** Súdy a protistrany v ňom žijú, takže import, export a sledované zmeny musia fungovať bezchybne (#29, #31)."
>
> **VŘ** *(✅, s tvrdšou podmienkou)*: „A — ale podmínku IR je potřeba převést z přání na **měřitelný požadavek**, protože ‚compatibility at the edges' není zadarmo a my už víme, kolik stojí. Mám zdokumentovaných **devět konkrétních způsobů**, jak se rozbije generování `.docx` a převod do PDF — prázdné záhlaví tabulky, justified text s měkkými zalomeními, page break prázdným odstavcem, odstavec odkazující na nedefinovaný styl (přijde o veškeré formátování), chybějící `w:eastAsia` u cizojazyčných citací… Zákeřné je, že **textová kontrola je nenajde** — `pdftotext` vrátí správný text i z rozbitého layoutu. Proto: **DOCX round-trip musí mít testovací korpus a vizuální kontrolu**, ne jen ‚podporujeme import a export'. Bez toho je kompatibilita slogan a advokát to zjistí, až když pošle rozsypaný dokument protistraně. Nápady #29 (tracked changes natvrdo vypnuté) a #31 (změny podepsané jako ‚Legal Cowork') potvrzuji jako reálný problém — autorství úprav musí mít advokát pod kontrolou."
>
> **MF:** „A — Markdown/HTML/JSON kanonické, OOXML výmenné; **DOCX round-trip a vizuálna kontrola ako merateľná podmienka.**"

**MČ — myšlienkový proces:** je to jeho vlastný návrh a celý jeho architektonický rámec ho podporuje — OKF v Markdownoch, prenositeľnosť medzi harnessami, file-based architektúra, minimalizácia lock-inu (Q16, Q17). Dôležité spresnenie: A je **dlhodobý smer a postupná tranzícia, nie okamžitý zákaz Microsoft nástrojov** — DOCX/XLSX/PPTX zostávajú prakticky kvalitné vstupno-výstupné formáty, lebo v nich žijú súdy aj protistrany; používateľ rozhoduje, kde súbory fyzicky drží a synchronizuje.

**U19 — návrh znenia:** *Open formats at the core, compatibility at the edges* — Markdown/HTML/JSON kanonické pracovné formáty, OOXML plnohodnotné výmenné formáty. **DOCX round-trip má testovací korpus a vizuálnu kontrolu** ako merateľnú podmienku *(VŘ)*; sledované zmeny a autorstvo úprav (#29, #31) sú súčasť tejto podmienky. Postupná tranzícia, nie zákaz Microsoft nástrojov.

---

## Zhrnutie pre call

### Prijať en bloc *(kde je zhoda všetkých respondentov)*
**U1–U19** — znenia vyššie pri jednotlivých otázkach. Kto má výhradu ku konkrétnemu U, vytiahne ho do diskusie.

### Rozhodnúť *(B-body, v poradí podľa váhy)*

| # | Bod | Kto rozhoduje | Odporúčanie na stôl |
|---|---|---|---|
| **B1** | Q07 — tretia vertikála | MČ ako PO | lehoty do trojice, onboarding náhradník *(VŘ + MF za, IR súhlasí so zámenou)* |
| **B3** | K1/Q24 — záväznosť doktríny | MČ | **A s odľahčenou výnimkou** *(mostík MF)* |
| **B4** | K2/Q21 — autonómia a tvrdé hranice | MČ potvrdzuje | dve roviny; povýšenie pamäti = tvrdá hranica; „čo agent nesmie, nemá sa mu dať ponúknuť" doplniť do ADR 0007 |
| **B6** | Q20 — sign-off roly | každý osobne | rozdelenie IR/MF/VŘ vyššie |
| **B7** | ADR 0011 — proces zmien a mergovania | tím | odklepnúť [PR #54](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/54) vrátane spätnej legitimizácie merge-ov zo 17. 8. a presunu `.agents/` + `plugins/` do samostatného repa |
| **B2** | Q02 — mená pri upstream synci | MČ + IR | MČ maintainer + IR reviewer *(alebo obrátene)* |
| **B5** | licencia | tím zadá rešerš | porovnanie licencií s termínom; dovtedy MIT |
| **B8** | certifikáty na podpis buildov | tím | kto platí a na koho subjekt znejú |

### Výstupy po calle

- [ ] Zápis z callu s hlasovaniami (`meetings/`)
- [ ] Prijaté U-znenia prepísať do ADR 0012+ *(governance · scope V1 · pamäť a reconciliation · dáta a platformy · monetizácia a publikovanie · formáty)*
- [ ] Zlúčiť PR #54, ak odklepnutý; presun `.agents/` a `plugins/`
- [ ] MČ podá finálne odpovede do PR #26 *(formálne uzavretie hlasovania)*
- [ ] Odklepnuté vertikály → issues vo forku s odkazmi na specy
- [ ] Aktualizovať roadmapu, `stav-odpovedi` a prehľadovú tabuľku

---

<sub>Pripravil MČ s AI asistenciou 2026-08-17. Citácie IR a MF sú doslovné z PR #26 (14. a 17. 8.), citácie VŘ doslovné/mierne krátené z [odpovedí VŘ](../planning/2026-08-15-odpovedi-VR-Q01-Q25.md) (15. 8.) so zachovaním argumentov; myšlienkové procesy MČ pochádzajú z hlasových diskusií 15.–17. 8. a sú pracovné. Pri spore platí plné znenie zdroja.</sub>
