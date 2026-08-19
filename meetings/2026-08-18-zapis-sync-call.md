# Zápis zo sync callu — 18. 8. 2026, 17:00

- **Prítomní:** Marián Čuprík (MČ) · Martin Friedrich (MF) · Vojta Říha (VŘ)
- **Ospravedlnený:** Igor Ribár (IR) — jeho písomné odpovede na Q01–Q25 boli na stole pri každom bode
- **Podklad:** [konsolidácia Q01–Q25](2026-08-18-podklad-konsolidacia-Q01-Q25.md) · [agenda](2026-08-18-agenda-sync-call.md)
- **Záznam:** audio MČ (Plaud) + prepis VŘ (Whisper Flow / Notetaker)

> [!IMPORTANT]
> **Ako čítať tento zápis.** Prešli sa všetky otázky Q01–Q25 a uzavreli sa otvorené body. Zápis vznikol z **raw prepisu bez identifikácie hovoriacich**, preto sú konkrétne výroky priraďované len tam, kde to z obsahu jednoznačne vyplýva; inde je uvedený záver diskusie bez autorstva. Ak niekomu zápis nesedí, **platí záznam** — pripomienku prosím do PR.
>
> **IR nebol prítomný.** Body označené ⚠️ sa rozhodli **inak, než znela jeho písomná odpoveď** — treba, aby sa k nim vyjadril.

---

## 1 · Čo sa rozhodlo — prehľad

| # | Otázka | Záver z callu | Oproti podkladu |
|---|---|---|---|
| Q01 | Product owner | **MČ**, ale rozhoduje sa **konsenzuálne**; PO rozsekáva len pat | spresnené |
| Q02 | Upstream sync | **MČ berie maintainera na seba** | ✅ uzavreté (B2) |
| Q03 | Release approval | podľa návrhu; **VŘ drží českú stránku** | potvrdené |
| Q04 | `dev` ako default | áno | potvrdené |
| Q05 | Review minimum | ⚠️ **každý si merguje vlastné PR a nesie za ne zodpovednosť**; kontrola je následná, problém sa rieši revertom | **zmena** |
| Q06 | Čo vydávame | kód + návod; kompiláciu si spraví používateľ; oficiálne buildy až s dev účtami a notarizáciou | potvrdené |
| Q07 | Prvé tri vertikály | **1. OKF/spisy + pamäť · 2. lehoty a timeline · 3. reconciliation s human approval** | ✅ uzavreté (B1) |
| Q08 | MVP billing | **mimo MVP**, do roadmapy; **gestor VŘ** | zmena rozsahu |
| Q09 | Anonymizácia | **definitívne mimo V1**; **gestor MF** | potvrdené + gestor |
| Q10 | Pamäť L1/L2/L3 | lokálne markdown súbory, kondenzácia deň/týždeň/mesiac, nezávislosť od harnessov; **názvoslovie zjednotiť** | rozpracované |
| Q11 | Povýšenie poznatku | ⚠️ **nastavenie používateľa** (schvaľovať všetko ↔ YOLO), **žiadne tvrdé stopy v appke** | **zmena** |
| Q12 | Periodicita reconciliation | dokument okamžite · projekt po session + týždeň/mesiac; konfigurovateľné | spresnené |
| Q13 | Metriky reconciliation | ⚠️ **žiadne formálne metriky**; namiesto nich **changelog session v OKF** | **zmena** |
| Q14 | Režimy preverovania | light / medium / hard ako nastavenie; spúšťa sa pri založení spisu | potvrdené |
| Q15 | AML | voliteľná feature nad MCP, nie vlajková loď | potvrdené |
| Q16 | Lokálnosť dát | plne lokálne; **žiadny cloud, žiadna synchronizácia, zodpovednosť používateľa** | potvrdené |
| Q17 | Lokálny index / RAG | RAG len ako add-on; **ani lokálny index či vyhľadávanie neposkytujeme** | sprísnené |
| Q18 | Platformy | jadro univerzálne; **macOS smie mať navyše**, funkcionalita sa nebrzdí kvôli Windows; Windows drží IR | spresnené |
| Q19 | Jurisdikcie | hľadať maintainerov po krajinách + contribution agreement | rozšírené |
| Q20 | Sign-off roly | ⚠️ **formálna matica sa nerobí**; namiesto nej **gestorstvo podľa feature** | **zmena** |
| Q21 | Human-in-the-loop | ⚠️ **konfigurovateľná autonómia vrátane YOLO**; žiadny hand-holding | **zmena** |
| Q22 | Monetizácia | appka zadarmo; školenia, implementačná pomoc, prípadne platená komunita; **vyžadujeme atribúciu** | potvrdené + atribúcia |
| Q23 | Upstream do LegalWorku | case-by-case: lokalizácie a jednoduché opravy áno | potvrdené |
| Q24 | Záväznosť doktríny | **neprebrané** | ❗ ostáva otvorené |
| Q25 | Otvorené formáty | áno, a **aktívne smerovať používateľov preč od Wordu** | sprísnené |

---

## 2 · Rozhodnutia s odôvodnením

### A · Riadenie (Q01–Q03)

**Q01 — product owner MČ, ale konsenzuálne.** MČ rolu prijal s výhradou: *„chcem, aby sme všetky rozhodnutia robili konsenzuálne… myslím, že tu nebudeme mať rozpory, ktoré bude musieť niekto rozsekávať."* Rola je teda **poistka pri pate**, nie riadiaci orgán.

**Q02 — upstream sync berie MČ.** *„Kľudne to môžem riešiť… predpokladám, že to budú len nejaké skripty a aj agenti to spravia."* Tým **padá otvorený bod B2** v časti maintainera. Reviewer nebol menovaný — IR ponúkol automat s konfliktným reportom, dohodne sa s ním.

**Q03 — release approval podľa návrhu.** VŘ drží českú stránku, MČ technickú a release security. Bez námietok.

### B · Vetvy, review, release (Q04–Q06)

**Q04 — `dev` zostáva.** Bez diskusie.

**Q05 ⚠️ — model práce sa zmenil.** Namiesto povinného review platí:

> Fungujeme cez Telegram, issues a PR. **Každý si merguje svoje PR a nesie zaň zodpovednosť.** Keď niekto zlúči hlúposť, upozorní sa naňho a revertne sa to — bez drámy.

Odôvodnenie z callu: *„ani jeden z nás nie je developer… to proste podoladíme počas toho, ako pôjdeme."* Kontrola je teda **následná, nie vstupná**.

> [!WARNING]
> **Toto je opak toho, čo písomne odpovedali IR, VŘ aj MF** — všetci traja v Q05 uviedli, že review minimá majú byť záväzné aj tam, kde ich GitHub nevynúti. Na calle proti tomu nikto nenamietal, ale **IR o tom nevie**. Dôsledok: **[ADR 0011](../decisions/0011-proces-zmien-a-mergovania.md) v podobe, v akej leží v [PR #54](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/54), je prekonaný** a treba ho prepísať na model „vlastníctvo + následný revert".

**Q06 — vydávanie.** Najprv zdrojový kód a návod; **kompiláciu si spraví používateľ sám**. Oficiálne buildy až keď si zaplatíme vývojárske účty — potom sa binárky pre macOS, Windows aj Linux zostavujú a podpisujú automaticky cez GitHub a používateľ klikne na *download*. **Certifikáty platíme štyria spoločne** (~100 € ročne Apple + Windows) — tým **padá bod B8**. Žiadny serverový komponent, žiadne účty; jediná trvalá údržba je notarizácia.

### C · Prvá iterácia (Q07–Q09)

**Q07 ✅ — poradie vertikál uzavreté:**

1. **OKF — spisy a pamäť** *(vlajková loď, to, čo iní nemajú)*
2. **Lehoty a timeline** *(druhý pilier — presadili IR aj VŘ)*
3. **Reconciliation s human approval** *(+ self-healing)*

Onboarding subjektov z prvej trojice vypadol — zostáva ako feature nad MCP (Q15). VŘ: *„Určite, za mňa takto to dáva zmysel."*

**Q08 — billing mimo MVP.** Dôvod: DPH, domáce aj cezhraničné fakturovanie — príliš zložité na začiatok. **Gestorom je VŘ**, ide do roadmapy. MČ opísal fungujúci vzor zo svojej praxe: pri založení spisu sa eviduje dohodnutá sadzba, agent si po každej session zapíše schválený čas do ledgera a pri fakturácii rozpíše, čo sa kedy robilo, a cez API to odovzdá fakturačnému systému. Ťažisko je teda na **evidencii času a exporte**, nie na vlastnej fakturácii.

**Q09 — anonymizácia definitívne mimo V1.** Zhoda, že je to zložité a prepojené so všetkým ostatným (pamäť, diarizácia, priraďovanie k spisu). **Gestorom je MF** — má funkčné riešenie a môže ho v ďalšej verzii navrhnúť ako experiment. Ako jednorazová funkcia (anonymizuj dokument → chatuj nad ním) je prípustná, ale **bez agentickej integrácie**.

### D · Pamäť a reconciliation (Q10–Q13)

**Q10 — pamäť ako lokálna súborová štruktúra.** Zhoda na modeli: markdown súbory viazané na spis, ktoré sa **priebežne kondenzujú (deň → týždeň → mesiac)**, aby sa kontext nenafukoval. Cieľ je **nezávislosť od harnessu** — po otvorení priečinka v ľubovoľnom agentovi sa načíta `AGENTS.md` / `CLAUDE.md` a agent má hneď prehľad, lehoty, stav spisu, pomenovanie súborov aj subjekty.

VŘ opísal svoj bežiaci systém: **systémová pamäť · changelog · pamäť prípadu · Obsidian** (najväčšie podrobnosti), prepojené wiki linkami, plne lokálne a prenositeľné. Zhoda, že **Obsidian sa od advokátov vyžadovať nebude** — ostávame na obyčajných lokálnych markdownoch.

**Úloha:** zjednotiť názvoslovie (L1/L2/L3 z podkladu × brain/OKF model × systém VŘ) do **jedného systému** a ten implementovať. Ako inšpiráciu MČ poslal do *Feature IDEAS* nástroj **[granular.build](https://granular.build)** — podľa jeho opisu má brain na úrovni celej praxe aj jednotlivých projektov, pekne poprepájaný *(samotný produkt neoverený — stránka je zatvorená pre automatické načítanie)*.

**Q11 + Q21 ⚠️ — autonómia je nastavenie, nie pravidlo appky.** MČ: *„Nemám rád, keď je hard stop v každej práci automaticky… to je otravné."* Záver: advokát si zvolí režim — od schvaľovania každého kroku až po **YOLO**. Zodpovednosť je na advokátovi, nie na aplikácii:

> Je to presne ako s koncipientom. Keď dáš dôležitú vec lacnému koncipientovi a on to pokazí a ty to podpíšeš, zodpovedný si ty. Handholding patrí do stavovských smerníc, nie do aplikácie.

VŘ vzniesol výnimku pre judikatúru a právnu úpravu — aby sa dala dohľadať správnosť. **Vyriešilo sa inak než tvrdým stopom:** povinnosť uvádzať overiteľný zdroj (odkaz, ECLI) patrí do **promptov a systémových inštrukcií**, nie do blokujúcej brány. VŘ súhlasil.

> [!WARNING]
> **Toto je v rozpore s písomnými odpoveďami IR aj MF.** IR: *„Nič sa nesmie naučiť samo… Vždy."* MF: *„Povýšenie vždy schváli človek; YOLO túto hranicu neodomyká."* Na calle sa rozhodlo opačne — povýšenie pamäti je súčasťou konfigurovateľnej autonómie. **Formálne to neporušuje [ADR 0007](../decisions/0007-agent-first-architektura.md)** (ten viaže ľudskú verifikáciu pred *použitím výstupu v právnej službe* a technické vylúčenie podpisu a konania navonok — tie zostávajú), ale **odporuje to Q11 v znení, ako ho odpovedali IR a MF**. Treba to potvrdiť písomne, IR sa musí vyjadriť.

**Q12 — periodicita.** Na úrovni dokumentu **okamžite**: keď agent vytvorí dokument a advokát ho upraví, agent má k dispozícii diff a zapíše si z neho poznatok. Na úrovni projektu **po každej session** a ďalej **týždenne alebo mesačne**. Všetko ako **nastavenie** — vrátane možnosti pustiť reconciliation na lacnom modeli, lebo je s ňou spojená spotreba tokenov.

**Q13 ⚠️ — metriky sa zatiaľ nerobia.** Namiesto formálnych metrík *(false promotion rate a spol.)* sa poznatky z reconciliation zapisujú do **changelogu session v rámci OKF** — *„logovanie bude súčasťou OKF tak či tak."* Odôvodnenie: zatiaľ nevieme, ako sa to bude v praxi správať. **Odchýlka od písomných odpovedí všetkých troch**, ktorí navrhovali konkrétne metriky.

### E · Subjekty a AML (Q14–Q15)

**Q14 — režimy potvrdené.** MČ opísal fungujúci vzor: registre a diskvalifikácie ako **MCP server**, skill sa pri založení spisu spýta na subjekty a na hĺbku previerky, potom prejde konflikty. Ostáva light / medium / hard ako **voľba používateľa**. VŘ z praxe: hard využil za celý čas raz *(klient s rovnakým menom ako poslanec ruskej Dumy — preveroval aj ruské periodiká)*, čiže drahá hĺbka má byť možnosť, nie default.

**Q15 — AML nie je vlajková loď.** Je to feature nad MCP: *„zapnite si to alebo nezapnite, integrujte si do onboardingu, čo chcete."*

### F · Dáta a platformy (Q16–Q19)

**Q16 — plne lokálne, bez cloudu a bez synchronizácie.** Kto má súbory na OneDrive, Google Drive či Dropboxe, rieši si to sám a je to **jeho zodpovednosť**. Neposkytujeme úložisko, nemaintainujeme ho a nič nevyžadujeme. Synchronizáciu medzi inštanciami neriešime — kto si otvorí appku na druhom počítači, agent si načíta kontext nanovo z lokálnych súborov.

**Q17 — bez RAG a bez vlastného vyhľadávania.** Jadro je OKF/markdown. RAG len ako add-on pre toho, kto ho chce. Nad rámec podkladu sa dohodlo, že **neposkytujeme ani lokálny index či vyhľadávanie** — na to má každý OS vlastné nástroje. Argument VŘ z praxe: kombinácia MCP + odkazy na komentáre dáva **kvalitnejšie výstupy pri nižšej spotrebe tokenov**, lebo model menej háda; *„za embeddingy neručíme a nevieme, na akých kľúčoch sú postavené."*

**Q18 — jadro univerzálne, macOS smie mať navyše.** Univerzálne a rovnaké všade: **prompty, OKF, MCP napojenia, práca so súbormi a textom**. Nad tým sa funkcionalita **nebude brzdiť len preto, že sa nedá na Windows** — macOS má Brew a balíčkové systémy, teda viac možností integrácií (spomenuté ako príklad nové CLI na Reminders a Apple Notes). **Windows drží IR**, ktorý ho testuje a môže platformu rozširovať. VŘ doplnil, že na Windows funguje **WSL** výborne — harnessy aj CLI tam bežia bez rozdielu, slabšie sú len integrácie typu WhatsApp. Linux teda nezahadzujeme. Do budúcna MČ nevylučuje natívny macOS fork (SwiftUI), ale mimo scope tohto produktu.

**Q19 — internacionalizácia cez lokálnych maintainerov.** Priebežne hľadať kolegov v jednotlivých krajinách a ponúknuť im rolu **oficiálneho maintainera** pre jurisdikciu, s contribution agreementom *(ozvali sa aj Ukrajinci)*.

**Stav VŘ:** nahráva kompletnú českú právnu úpravu — **1,33 mil. súborov**, prenos beží 12 dní; dorobené aj nižšie súdy *(~560 tis. rozhodnutí)*. **Poľské zdroje začína sťahovať 19. 8.**

**Nový nápad z tejto diskusie:** namiesto Google Drive distribuovať korpusy cez **Hugging Face alebo torrent** a v aplikácii k tomu spraviť **jedno tlačidlo** — používateľ klikne, appka stiahne, rozbalí a naindexuje. VŘ: *„To mi vôbec neklaplo, že je tá možnosť."* → zapísané do koša.

### G · Regulované workflowy (Q20–Q21)

**Q20 ⚠️ — formálna matica sign-offov sa nerobí.** Namiesto nej **gestorstvo podľa feature**: kto si funkciu vezme za svoju, ten ju maintainuje a zodpovedá za ňu — pokiaľ nerozbije dohodnuté core features. Pomenovaní gestori:

| Oblasť | Gestor |
|---|---|
| Fakturácia a evidencia času | **VŘ** |
| Anonymizácia | **MF** |
| QES podpisovanie, autorizácia, konverzia | **MČ** |
| Windows platforma | **IR** *(z jeho písomnej odpovede)* |
| Česká právna stránka a CZ zdroje | **VŘ** |

K MCP serverom MČ upresnil, že si ich bude maintainovať na tej istej úrovni ako pre seba, ale **bez zodpovednosti voči ostatným** — appka je otvorená, každý si môže forknúť a napojiť vlastné servery. Kryje to licenčný disclaimer.

**Q21** — viď Q11 vyššie.

### H · Open source a formáty (Q22–Q25)

**Q22 — appka zadarmo, monetizácia okolo nej.** Platené moduly sa neriešia. Prípustná je **platená komunita** (typu Skool) a **implementačná pomoc**. Ochrana pred prevzatím: **vyžadujeme explicitnú atribúciu** — kto našu funkcionalitu implementuje, musí uviesť pôvod. Technicky nikomu brániť nebudeme.

Diskusia k pozicioningu: na trhu sa dnes predávajú prompty a skilly zabalené do webových appiek *(spomenuté ForLegal v ČR; Practiq, Codexis a spol. ako black boxy)*. **Náš diferenciátor je opak black boxu** — advokát vidí prompty a personalizuje si ich. *„Poskytneme plain field. Forkni si to, uprav si to."* Poznámka VŘ: skill bez kontextu je aj tak bezcenný — hodnotu dáva až to, ako sa v ňom advokát zlepšuje.

**Q23 — upstream case-by-case.** Lokalizácie áno, jednoduché opravy áno, náš brain a OKF nie. Konkrétne nálezy MČ z forku, ktoré sú kandidáti na upstream:
- `.docx` sa nedá pretiahnuť priamo do chatu — najprv sa musí importovať do worktree, čo je neintuitívne
- pri redline a komentároch **sa nedá nastaviť meno** *(nadväzuje na nápady #29 a #31)*

**Q24 — neprebrané.** Otázka záväznosti produktovej doktríny sa v hovore neotvorila. **Ostáva otvorená.**

**Q25 — otvorené formáty, aktívne smerovanie preč od Wordu.** MČ sa vymedzil ako *„druhý extrém"* oproti podmienke IR: nielenže Word nemá byť druhá kategória — **advokátov chceme od Wordu odviesť**. Predvolený výstup má byť PDF, HTML alebo markdown; Word až keď to niekto výslovne potrebuje. Používateľ rozdiel neuvidí, lebo OOXML sa naďalej podporuje. Zhrnutie postoja:

> Je to aplikácia pre AI agentov, nie pre ľudí. Pre ľudí je to len interface na manažment práce tých agentov.

---

## 3 · Akčné body

| Kto | Čo | Termín |
|---|---|---|
| **všetci** | Nainštalovať a **reálne používať fork LegalWorku**; zapisovať **paper cuts** a malé feature requesty | do konca týždňa *(24. 8.)* |
| **všetci** | Zamyslieť sa nad názvom — *LAWOSS* je zatiaľ pracovný | priebežne |
| **MČ** | Zosumarizovať paper cuts a naplánovať roadmapu implementácie | do konca týždňa |
| **MČ** | Prepísať [ADR 0011](../decisions/0011-proces-zmien-a-mergovania.md) na model „vlastníctvo + následný revert" | — |
| **MČ** | Poslať tento zápis IR a vyžiadať vyjadrenie k bodom ⚠️ | hneď |
| **tím** | Od budúceho týždňa **začať implementovať vlajkové features** — OKF, pamäťový systém, práca so spisom a lehoty | od 25. 8. |
| **VŘ** | Začať sťahovať poľské zdroje | od 19. 8. |
| **VŘ** | Zvážiť distribúciu korpusov cez Hugging Face / torrent namiesto Google Drive | — |
| **IR** | Vyjadriť sa k Q05, Q11, Q13, Q20, Q21 — rozhodlo sa inak, než odpovedal | — |

## 4 · Čo zostáva otvorené

- **Q24 — záväznosť produktovej doktríny.** Neprebrané.
- **Reviewer upstream syncu.** Maintainer je MČ; kto robí review, sa dohodne s IR.
- **Licencia (B5).** Nerozhodnutá, ale z callu vyšiel jasný signál: **permisívne + povinná atribúcia**. Rešerš (MIT × Apache-2.0 × MPL × source-available) stále treba.
- **Zjednotenie pamäťového názvoslovia** — L1/L2/L3 × brain/OKF × systém VŘ do jedného modelu.
- **Vyjadrenie IR** k piatim bodom vyššie.

## 5 · Dôsledky pre existujúce dokumenty

| Dokument | Čo s ním |
|---|---|
| [ADR 0011 v PR #54](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/54) | **prepísať** — navrhovaný model gated approval bol nahradený vlastníctvom a následným revertom |
| [Prehľad stanovísk Q01–Q25](../planning/2026-08-17-stanoviska-timu-Q01-Q25.md) | doplniť stĺpec „záver callu" |
| [Roadmapa](../planning/roadmap.md) | zaviesť poradie vertikál z Q07 a presunúť billing medzi neskoršie |
| [Zberný kôš](../planning/napady.md) | doplnené: distribúcia korpusov cez HF/torrent; #45 má podporu z callu |
| ADR 0012+ | z prijatých záverov spísať ADR pre governance, scope V1, pamäť a autonómiu |

<sub>Zápis zostavil MČ s AI asistenciou 2026-08-19 z raw prepisu hovoru 18. 8. 2026. Prepis neobsahuje identifikáciu hovoriacich — výroky sú priraďované len tam, kde to z obsahu jednoznačne vyplýva. Pri spore platí zvukový záznam.</sub>
