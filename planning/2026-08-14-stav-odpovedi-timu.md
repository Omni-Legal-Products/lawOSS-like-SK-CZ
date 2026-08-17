<div align="center">

# 🗳️ Stav odpovedí tímu — Q01 až Q25

**Živý prehľad** · aktualizované 2026-08-16

![IR](https://img.shields.io/badge/IR-25%2F25%20odpovedan%C3%BDch-brightgreen)
![VR](https://img.shields.io/badge/V%C5%98-25%2F25%20odpovedan%C3%BDch-brightgreen)
![MF](https://img.shields.io/badge/MF-0%2F25-lightgrey)
![MC](https://img.shields.io/badge/M%C4%8C-0%2F25%20%C2%B7%20rozpracovan%C3%A9-yellow)

</div>

> [!IMPORTANT]
> **Načo tento dokument je.** Otázky [Q01–Q25](2026-08-12-rozhodovacie-otazky-timu.md) sú rozsiahle a odpovede sa strácajú v komentároch pod PR. Tu sú na jednom mieste, aby **každý videl, čo už odpovedali ostatní, skôr než odpovie sám**.
>
> **Ako doplniť svoju odpoveď:** komentár do [PR #26](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/26) v tvare `Q01: A, pretože…`, alebo vlastný súbor v `planning/` ako to spravil VŘ. Zapíše sa to sem.
>
> ⚠️ **Vidieť cudziu odpoveď pred vlastnou má aj tienistú stránku** — zvádza to prikývnuť. Ak s niečím nesúhlasíš, **je to cennejšie než súhlas**; rozdielne stanovisko sa zapíše rovnako.

> [!NOTE]
> **Zdroje odpovedí.** IR odpovedal v komentároch pod PR #26 a v PR #13, #14, #16, #19, #27, #31 — tu sú **skrátené**, plné znenie je v origináli. VŘ odpovedal vlastným súborom → [`2026-08-15-odpovedi-VR-Q01-Q25.md`](2026-08-15-odpovedi-VR-Q01-Q25.md), tu sú tiež skrátené. **Ak niekde skratka mení význam, platí originál.**
>
> VŘ pri každej odpovedi uvádza, ako pevné stanovisko za ňou stojí: ✅ *opreté o prax* · ⚠️ *bez silnej preferencie, pokojne prehlasujte*.

---

## Tabuľka

| # | Otázka | 🟢 **IR** *(2026-08-14)* | 🟢 **VŘ** *(2026-08-15)* | ⏳ MF | ⏳ MČ |
|---|---|---|---|---|---|
| **Q01** | Kto je konečný product owner? | A. Produkt musí mať jedného človeka, ktorý rozsekne pat, a to je prirodzene Majo. Výhrady si zapisujme, ale rozhoduje on. | **A** ⚠️ MČ je autor väčšiny podkladov a jediný, kto drží celý obraz. Podmienka: rozhodnutia, ktoré sa odchyľujú od prijatého ADR, nech majú **písomné odôvodnenie**, aby sa dalo spätne dohľadať prečo. | | |
| **Q02** | Kto vlastní upstream sync s LegalWorkom? | A. Nech sync vlastní jeden človek s AI pomocou a druhý po ňom pozrie. Podmienka: poctivo vedený zoznam našich zásahov do prevzatého kódu, aby sync vedel zopakovať hocikto. Automat, ktorý pri konflikte sám ot… | **A** ✅ **O rolu maintainera sa nehlási** — nemá na to kapacitu ani prostredie. Berie na seba **review všetkého, čo sa dotýka CZ vrstvy** (lokalizácia, CZ konektory, CZ právne jadro). Súhlasí s podmienkou IR na `PATCHES.md`. | | |
| **Q03** | Kto môže schváliť release? | Súhlasím s navrhovaným minimom. Právny sign-off pri citlivých veciach (podpisovanie, konverzia, AML) beriem na seba. | ✅ Súhlas s minimom — a **berie na seba právny sign-off za české právo** (autorizovaná konverzia podľa z. č. 300/2008 Sb., ISDS, CZ lehoty, CZ AML), zrkadlovo k tomu, čo za SK vzal IR. | | |
| **Q04** | Zostane `dev` integračnou aj default vetvou? | A. Čím menej sa odchýlime od pôvodného projektu, tým menej roboty s preberaním noviniek. Stabilné body označujme tagmi. | **A** ⚠️ `dev` integračná aj default počas prvého MVP, stabilné body značiť tagmi. | | |
| **Q05** | Aké review minimum používame? | Áno, a berme to záväzne aj tam, kde nám to GitHub technicky nevynúti. Keď to niekto poruší, zmena sa vráti a ide sa ďalej, žiadna dráma. | ✅ Áno, záväzne. Dopĺňa položku: **zmena v katalógu lehôt alebo v registroch pre AML je „funkčný kód", nie „docs"**, aj keď je to markdown. Zlé číslo v tabuľke lehôt je rovnaká škoda ako chyba v kóde, len sa horšie nájde. | | |
| **Q06** | Čo vydávame v prvej fáze? | Najprv len kód a návod (A), verejnosti až podpísané buildy (C). Nepodpísané nanajvýš pre nás štyroch s jasným varovaním. A moje meno sa so sťahovaním binárok nespája, to je moja červená čiara. | **A, potom C** ✅ **Tá istá červená čiara ako IR** — je advokát zapísaný v ČAK a nesie kárnu aj zodpovednostnú expozíciu. Jeho meno sa nespojí s distribúciou nepodpísaných binárok. | | |
| **Q07** | Ktoré tri vertikály sú prvé? | Súhlasím s trojicou: spisy a pamäť, učenie zo schvaľovania, preverovanie subjektov. Jedna prosba: lehoty nech sú prvý náhradník, keď sa uvoľní miesto. Právne jadro k nim už je hotové (#33) a zmeškaná lehota… | ⚠️ **ODCHÝLKA od IR aj od odporúčania.** Navrhuje (1) OKF + L2, (2) reconciliation, (3) **lehoty** — onboarding subjektov ako prvý náhradník. Dôvod je **cena, nie preferencia**: SK jadro (#33) aj CZ jadro (#48) sú hotové, engine mu beží v praxi, zostáva GUI a zápis do spisu. | | |
| **Q08** | Čo znamená MVP billing? | B. Evidencia času, sadzby a podklad pre faktúru áno; samotné vystavovanie dokladov a účtovníctvo je iná liga zodpovednosti, nechajme na neskôr. | **B** ✅ Doplnok z praxe: **české kancelárie spisový a fakturačný systém väčšinou už majú** (u neho Evolio). Preto je dôležitejší **exportný formát a rozhranie von** než vlastná fakturácia vnútri. Keby si má vybrať, berie export. | | |
| **Q09** | Je anonymizácia formálne vyradená z V1? | Áno, odložiť. Vrátime sa k tomu, keď prvý z nás bude reálne potrebovať poslať obsah spisu do cloudu; detekčné vzory medzitým ležia pripravené (#36). | ✅ Áno, odložiť — ale **so spúšťačom pomenovaným vopred**, nie na cit. Navrhuje: *okamih, keď má ktorýkoľvek workflow poslať obsah spisu do cloudového modelu.* Mlčanlivosť podľa § 21 z. č. 85/1996 Sb. nemá výnimku pre „technický medzikrok". | | |
| **Q10** | Čo presne patrí do L1, L2 a L3? | Zjednodušene: osobné nastavenia bez klientskych dát, spisová pamäť prísne lokálna per vec, spoločná právnická pamäť len z verejných zdrojov. Vlastníkov vrstiev doklepnime na calle. | ✅ Rovnaké rozdelenie, doložené vlastnou trojúrovňovou pamäťou v prevádzke vyše roka. **Dve veci navyše oproti spec 0002:** záznamy musia byť **typované** (`user`/`feedback`/`project`/`reference`), inak pamäť po pár mesiacoch splynie v hromadu; a musí existovať **oddelená vrstva „poučenie z chyby"**. | | |
| **Q11** | Kto schvaľuje povýšenie poznatku? | Nič sa nesmie „naučiť" samo. Agent navrhne a ukáže rozdiel, schvaľuje človek. Vždy. | ✅ Bez výnimky. Doložené z praxe: **subagent bez prístupu k zdieľanej pamäti zopakoval judikát, ktorý už bol skôr vyhodnotený ako problematický.** Poučenie: povýšenie nie je len otázka súhlasu, ale aj **distribúcie** — čo sa schváli, musí sa dostať ku všetkým agentom. | | |
| **Q12** | Aká je periodicita reconciliation? | Kombinácia: hneď pri dôležitej udalosti, raz týždenne upratať, a na záver veci urobiť bodku. | ✅ Kombinácia — okamžitý návrh pri významnej udalosti, týždenná konsolidácia, záverečná kontrola pri uzavretí veci. | | |
| **Q13** | Aké metriky rozhodnú, že reconciliation funguje? | Súhlasím s navrhnutým zoznamom. Najviac ma zaujímajú dve čísla: koľko nezmyslov sa omylom schváli a koľko času nám kontrola reálne berie. | ✅ Súhlas + jedna metrika navyše: **koľko z toho, čo agent navrhol, advokát prepísal a v čom.** Nie je to metrika správnosti, ale **štýlu** — a štýl je podľa [spec 0003](../specs/0003-prompt-layer.md) to, čo advokáta odlišuje. Keď číslo neklesá, prompt layer sa neučí. | | |
| **Q14** | Čo obsahujú režimy `light`, `medium` a `hard`? | K zoznamu registrov sa nevyjadrujem, tomu rozumie Majo najlepšie. Jedna podmienka: pri menovcoch nikdy nesmie zhodu potvrdiť stroj sám, vždy človek. | ✅ Za CZ dodáva konkrétny zoznam (ARES, ISIR, kataster, platitelia DPH, sankčný screening) → [mapa CZ zdrojov](cz-datove-zdroje.md). Súhlasí s IR pri menovcoch. **Vlastná podmienka z prevádzky: sankčné API bez kľúča vracia prázdny výsledok aj pre zjavne sankcionovanú osobu** → povinný kontrolný dotaz na známy pozitívny prípad. | | |
| **Q15** | Je AML onboarding vlajková feature alebo súčasť OKF? | Vnútri nech je to súčasť zakladania spisu (B); navonok to pokojne komunikujme ako samostatnú funkciu. | **B architektonicky, A marketingovo** ✅ Zhodné s IR. | | |
| **Q16** | Musia klientské dáta zostať lokálne? | Dokumenty klientov a spisová pamäť: len lokálne, bez výnimky. Osobné nastavenia tiež. Spoločná právnická pamäť z verejných zdrojov sa zdieľať môže. Telemetria len dobrovoľná a nikdy nie obsah spisov. Zálohy… | ✅ Zhodné s IR. Pre ČR je opora **tvrdšia než „dobrá prax"**: mlčanlivosť podľa § 21 z. č. 85/1996 Sb. Za jej porušenie nesie zodpovednosť **advokát osobne, nie dodávateľ softvéru** — a to je presne dôvod, prečo lokálnosť nesmie byť voľbou v nastaveniach. | | |
| **Q17** | Je lokálny index predvolený a RAG iba voliteľný? | Áno, lokálne vyhľadávanie ako predvolené. | **Áno** ⚠️ Lokálny index východiskový, RAG voliteľný. | | |
| **Q18** | Ktoré platformy podporujeme? | Mac aj Windows rovnocenne od začiatku. Ja mám len Windows, takže testovanie Windows verzie beriem na seba (detaily v issue #41). Linux podľa síl; veci viazané na Apple appky nech majú neutrálnu náhradu. | ✅ **Windows sľúbiť nemôže** — pracuje na macOS a nemá prostredie na test. Windows ako first-class cieľ podporuje a zistenie IR berie vážne, ale testovanie musí vziať niekto, kto tú platformu má. Garantuje, že **CZ nástroje sú platformovo neutrálne** (čistý Python), neprinášajú mac-only závislosť. | | |
| **Q19** | Patrí Poľsko do prvej architektúry? | Pripravme dátové modely tak, aby Poľsko neskôr nebolelo, ale staviame len SK a CZ. | **A na úrovni schém, B na úrovni integrácií** ✅ Zhodné s IR. Mapovanie poľských zdrojov má zadané, termín **20. 8.** | | |
| **Q20** | Kto vykonáva sign-off? | Návrh rozdelenia: súkromie a hranice pamäti Martin so mnou; AML ja s Majom; podpisovanie a konverzia Majo s mojím právnym sign-offom; licencie dát ja; bezpečnosť releasov Majo. | ✅ Prijíma návrh IR a **dopĺňa doň českú stranu**: licencie dát a tretích strán za ČR (Salvia, Codexis, korpus komentárov) berie na seba, rovnako **CZ právny sign-off** podľa Q03. | | |
| **Q21** | Aký human-in-the-loop model je záväzný? | Sám smie agent čítať verejné zdroje, pripravovať návrhy a udržiavať poriadok v spise. Pripraviť, ale neodoslať: čokoľvek, čo ide von z kancelárie, a zápisy do pamäti. Nikdy: podať niečo na súd, komunikovať s… | ✅ Rovnaké tri kategórie ako IR. **Doplnok, ktorý zatiaľ nikde nezaznel: hranica nesmie byť v prompte, ale v nástroji.** Prompt „neodosielaj bez potvrdenia" model občas obíde. U neho vynútené povinným `--dry-run` a odstránením rizikových funkcií z nástrojovej plochy. **Navrhuje zapísať do ADR 0007.** | | |
| **Q22** | Je celý softvér a všetky základné moduly bezplatné? | Všetko zadarmo a otvorené; zarábame na školeniach a pomoci so zavedením. Platené moduly odmietam: v momente, keď predávame softvér, sme dodávateľ softvéru so všetkým, čo k tomu patrí, a presne to sme si na z… | ✅ Zhodné s IR, vrátane dôvodu: v okamihu, keď predávame softvér, sme dodávateľ softvéru so všetkou zodpovednosťou, ktorá k tomu patrí. | | |
| **Q23** | Čo publikujeme späť komunite? | Vraciame komunite všetko vymenované, pri dátach s vyjasnenou licenciou. Zbierky zákonov a rozhodnutí NS SR už máme pripravené na zverejnenie, čakajú len na repozitáre (#40). | ✅ Za CZ ponúka: pravidlá lehôt + testovaciu sadu, mapu CZ zdrojov, výpočtový engine lehôt, ISDS/ISIR/kataster nástroje, korpus ~94 komentárov (Apache-2.0). ⚠️ **Výhrada ku korpusu: je nerecenzovaný a AI-generovaný — publikovať áno, citovať v podaní nie.** | | |
| **Q24** | Prijímame základnú produktovú doktrínu LAWOSS? | A. Nech je to záväzný meter na budúce rozhodnutia; výnimka len písomne, s dôvodom a časovým obmedzením. | **A** ✅ Záväzná doktrína, výnimka len písomne, s odôvodnením a časovým obmedzením. Zhodné s IR. | | |
| **Q25** | Majú byť otvorené formáty jadrom LAWOSS? | A, s jednou praktickou podmienkou: Word nesmie byť druhá kategória. Súdy a protistrany v ňom žijú, takže import, export a sledované zmeny musia fungovať bezchybne (#29, #31). | **A, s tvrdšou podmienkou než IR** ✅ Podmienku IR treba previesť z priania na **merateľnú požiadavku**. Má zdokumentovaných **deväť** spôsobov, ako sa rozbije generovanie `.docx` a prevod do PDF. Zákerné je, že **textová kontrola ich nenájde** — `pdftotext` vráti správny text aj z rozsypaného layoutu. → **round-trip musí mať testovací korpus a vizuálnu kontrolu.** | | |

---

## ⚔️ Jediná vecná odchýlka v tíme — Q07

> [!WARNING]
> **IR a VŘ sa zhodli na 24 z 25 otázok. Rozchádzajú sa v jedinej — v poradí prvých troch vertikál.**

| | IR *(2026-08-14)* | VŘ *(2026-08-15)* |
|---|---|---|
| **1.** | OKF + L2 spisová pamäť | OKF + L2 spisová pamäť |
| **2.** | reconciliation s human approval | reconciliation s human approval |
| **3.** | **onboarding subjektov** *(`light` cez existujúce MCP)* | **lehoty a timeline** |
| **prvý náhradník** | lehoty a timeline | onboarding subjektov |

**Nie je to spor o hodnote, ale o cene.** Obaja hovoria to isté o dôležitosti lehôt — IR: *„zmeškaná lehota je to, čo advokáta reálne položí."* Rozdiel je v tom, čo VŘ tvrdí o zostávajúcej práci:

- SK právne jadro lehôt dodal **IR** → [PR #33](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/33), 12 pravidiel, 14 lehôt, 14 pascí, 19 testov
- CZ právne jadro dodal **VŘ** → [PR #48](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/48), 30 pravidiel, 25 lehôt, 18 pascí, 24 testov *(zlúčené 2026-08-16)*
- deterministický výpočtový engine pre ČR **beží VŘ v praxi a dá sa prispieť**

Ak to platí, zostáva **GUI a zápis do spisu** — čím sa z lehôt stáva najlacnejšia zostávajúca vertikála. Je to zároveň vertikála, ktorú ako kandidáta č. 1 navrhol **MF** ([Issue #1](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/1)).

> [!NOTE]
> **Rozseknúť to má MČ** ako product owner — na tejto role sa IR aj VŘ nezávisle zhodli v Q01. VŘ výslovne píše, že sa nebráni pôvodnému poradiu, ale chce, aby padlo s vedomím, že cena lehôt medzitým klesla.

---

## 🆕 Nové podmienky, ktoré predtým na stole neboli

### Od IR *(2026-08-14)*

> [!WARNING]
> **Windows ako first-class cieľ (Q18).** *„Tím vyvíja na macu, ale cieľová skupina SK/CZ advokátov sedí prevažne na Windows a ja sám Mac nemám."* IR berie testovanie Windows na seba → [issue #41](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/41).
> Toto je vážne: **celý onboarding nález z 12. 8. je mac-centrický** (Xcode CLT, keychain pri Word add-ine). Ak je cieľovka na Windows, testovali sme zatiaľ menšinovú platformu.
> **VŘ to potvrdzuje, ale Windows garantovať nevie** — takže testovanie stojí a padá na IR.

> [!WARNING]
> **Červená čiara (Q06) — už dvakrát.** IR: *„Moje meno sa so sťahovaním binárok nespája."* VŘ nezávisle to isté ako advokát zapísaný v ČAK. **Dvaja zo štyroch si to dali ako osobnú podmienku účasti**, nie ako odporúčanie zo stratégie. Prakticky to znamená, že podpisovanie a notarizácia sa stávajú **podmienkou verejného vydania**, nie položkou v backlogu.

### Od VŘ *(2026-08-15)*

> [!WARNING]
> **DOCX round-trip potrebuje testovací korpus a vizuálnu kontrolu (Q25).** VŘ pritvrdzuje podmienku IR z priania na merateľnú požiadavku: má zdokumentovaných **deväť** konkrétnych spôsobov, ako sa rozbije generovanie `.docx` a prevod do PDF — prázdna hlavička tabuľky, justified text s mäkkými zalomeniami, page break prázdnym odstavcom, odstavec odkazujúci na štýl, ktorý šablóna nedefinuje *(príde o **všetko** priame formátovanie)*, chýbajúci `w:eastAsia` pri cudzojazyčných citáciách a ďalšie.
> **Najhoršie je, že textová kontrola ich nenájde** — `pdftotext` vráti správny text aj z úplne rozsypaného layoutu. Bez korpusu je „kompatibilita na hranách" slogan a advokát to zistí, až keď pošle rozsypaný dokument protistrane.

> [!WARNING]
> **Sankčný screening potrebuje kontrolný dotaz (Q14).** Z prevádzky: **sankčné API bez kľúča vracia prázdny výsledok aj pre zjavne sankcionovanú osobu.** Systém preto musí ku každému screeningu púšťať dotaz na známy pozitívny prípad — inak „čistý výsledok" znamená len „dotaz neprešiel" a **metodika AML stojí na fikcii**.

> [!IMPORTANT]
> **Hranica patrí do nástroja, nie do promptu (Q21).** Prompt *„neodosielaj bez potvrdenia"* model občas obíde. U VŘ je pravidlo vynútené tak, že odosielací nástroj má **povinný `--dry-run` krok** a exfiltračne rizikové funkcie sú z nástrojovej plochy odstránené úplne — u jedného komunikačného konektora zúžil plochu **zo 79 nástrojov na 12** a vypol webhook zneužiteľný cez prompt injection.
> **Navrhuje zapísať do [ADR 0007](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/19): *čo agent nesmie, mu nemá ísť ponúknuť.*** Ten ADR ale stále čaká na MF.

> [!NOTE]
> **Anonymizácia potrebuje pomenovaný spúšťač (Q09).** Obaja súhlasia s odložením, ale VŘ trvá na tom, že sa spúšťač návratu určí **vopred**, nie na cit: *okamih, keď má ktorýkoľvek workflow poslať obsah spisu do cloudového modelu.* Opora: § 21 z. č. 85/1996 Sb. nemá výnimku pre „technický medzikrok".

> [!NOTE]
> **Export je dôležitejší než vlastná fakturácia (Q08).** *„České kancelárie spisový a fakturačný systém väčšinou už majú."* (u VŘ Evolio) Keby sa malo voliť medzi vlastným billingom a dobrým exportom, berie export. Mení to ťažisko Q08 z „čo staviame" na „s čím sa musíme spojiť".

> [!NOTE]
> **Pamäť musí byť typovaná a musí mať vrstvu poučenia z chyby (Q10).** Z vyše roka prevádzky: netypovaná pamäť po pár mesiacoch splynie v jednu hromadu a prestane sa dať revidovať. A to, čo sa model naučil zle, je iná kategória než to, čo je v spise — maže sa inak.

> [!NOTE]
> **Povýšenie poznatku je aj otázka distribúcie (Q11).** Doložený prípad: subagent bez prístupu k zdieľanej pamäti zopakoval judikát, ktorý už bol vyhodnotený ako problematický. Čo sa schváli, musí sa dostať **ku všetkým agentom**, inak si systém odporuje sám so sebou.

> [!CAUTION]
> **Korpus komentárov s výhradou (Q23).** VŘ ponúka ~94 komentárov k českým a EU predpisom pod Apache-2.0, ale hovorí nahlas: je to **sekundárny, nerecenzovaný materiál generovaný s AI**. Publikovať ho možno, **citovať v podaní nie** — má doložené prípady, kde bola formulácia v komentári menej presná než zákon a vynechala slová nosné pre petit. *„Radšej to hovorím nahlas hneď, než aby na to niekto prišiel až u súdu."*
> Cennejší než samotný korpus je podľa neho **dvojstupňový vzor „navigácia → povinné doověrenie v primárnom prameni"**, ktorý je zároveň odpoveďou na požiadavku [spec 0004](../specs/0004-mcp-sk-konektory.md) na verifikáciu citácií.

---

## Čo z odpovedí vyplýva

### Odblokované — IR a VŘ sa zhodli

| Bod | Dôsledok |
|---|---|
| **Q01 product owner = MČ** | Zhoda IR aj VŘ. Pat sa dá rozseknúť. VŘ dopĺňa podmienku: odchýlka od prijatého ADR nech má **písomné odôvodnenie**. |
| **Q05 review minimum záväzne** | Zhoda. VŘ dopĺňa: **katalóg lehôt a registre pre AML sú „funkčný kód", nie „docs"** — aj keď sú to markdowny. |
| **Q11 žiadne autonómne povýšenie** | Zhoda, bez výnimky. |
| **Q16 lokálnosť klientskych dát** | Zhoda. VŘ pridáva právnu oporu za ČR (§ 21 z. č. 85/1996 Sb.) a dôsledok: **lokálnosť nesmie byť voľbou v nastaveniach**. |
| **Q20 rozdelenie sign-offu** | IR navrhol mená, VŘ doplnil CZ stranu → *súkromie a pamäť* MF+IR · *AML* IR+MČ · *podpisovanie a konverzia* MČ s právnym sign-offom IR · *licencie dát* IR (SK) + VŘ (CZ) · *CZ právny sign-off* VŘ · *bezpečnosť releasov* MČ. **MF má pridelenú rolu bez toho, aby sa vyjadril.** |
| **Q22 monetizácia** | Zhoda: *„Platené moduly odmietam."* (IR) Potvrdzuje [ADR 0002](../decisions/0002-preco-forkujeme-mikeoss.md). |
| **Q24 doktrína** | Obaja **A** — [ADR 0009](../decisions/0009-zakladna-produktova-doktrina.md) ako záväzný meter, výnimka len písomne a s časovým obmedzením. |
| **Q25 otvorené formáty** | Obaja **A**, obaja s podmienkou k Wordu — VŘ ju robí merateľnou. |

### Otvorené — čaká na MČ a MF

| Bod | Čo treba |
|---|---|
| **Q07 poradie vertikál** | Jediná vecná odchýlka. Rozseknúť má MČ. |
| **Q06 podpisovanie** | Ak sú podpísané buildy podmienkou dvoch členov, treba rozhodnúť **kto platí certifikáty a na koho účet znejú**. Súvisí s otvorenou úlohou *Apple Developer účet* v [roadmape](roadmap.md). |
| **Q18 Windows** | IR testovanie berie, VŘ nemôže, MČ a MF sa nevyjadrili. Je Windows first-class od MVP *(teda CI buildy hneď)*, alebo od pilotu? → [issue #41](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/41) |
| **Q21 → ADR 0007** | Doplniť princíp *„čo agent nesmie, mu nemá ísť ponúknuť"* do [ADR 0007](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/19), alebo samostatný ADR? ADR 0007 čaká na MF. |
| **Q14 sankčný canary** | Prijať do metodiky AML ako povinnú súčasť screeningu? |
| **Q25 DOCX korpus** | Prijať testovací korpus a vizuálnu kontrolu ako podmienku k Q25? |

---

## Stanoviská IR k otvoreným PR

| PR | Stanovisko | Podstatné |
|---|---|---|
| [#13](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/13) plán forku | ✅ súhlas | **Ponúka automat na upstream sync** s konfliktným reportom viazaným na `PATCHES.md` — rieši otvorený bod „kto vlastní sync". |
| [#14](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/14) stratégia | ✅ súhlas | **Potvrdzuje osobne tri roly** z kapitoly 6 vrátane červenej čiary. *„Transparentné priznanie vzťahu k SAK bez náznaku endorsementu komory je pre mňa podmienka účasti."* |
| [#16](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/16) reconcile | ✅ súhlas, aj so zaradením do V2 | Spája to so svojím [#37](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/37): *„destilát je stav veci, reconcile je učenie z úprav; spolu dávajú nápadu #21 obe chýbajúce polovice."* |
| [#19](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/19) agent-first | ✅ súhlas s princípom | Rešpektuje, že ADR čaká na MF. Doložil prevádzkový podklad [#38](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/38) — **zapracovaný do ADR**. |
| [#27](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/27) platformová stratégia | ✅ súhlas so smerovaním | Windows first-class ako priorita. |
| [#31](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/31) stavy + týždenný prehľad | ✅ súhlas | *„Sám som sa dnes presvedčil, že bez neho veci zapadnú."* |

---

## Čo priniesli ako prácu

### IR — za jeden deň, 2026-08-14

| # | Čo | Typ | Stav |
|---|---|---|---|
| [#33](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/33) | pravidlá počítania lehôt SK pre spec 0005 | rešerš | otvorené |
| [#34](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/34) | návod na pripojenie MCP serverov do LegalWorku | dokumentácia | otvorené |
| [#35](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/35) | metodika kvality skillov — katalóg zlyhaní, testy | dokumentácia | otvorené |
| [#36](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/36) | SK anonymizačné detektory a vzory | rešerš | otvorené |
| [#37](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/37) | spisový destilát ako L2 vrstva pamäti | rešerš | otvorené |
| [#38](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/38) | orchestrácia agentov a human gates — rok prevádzky | rešerš | otvorené |
| [#39](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/39) | SAK compliance štartovací balík | dokumentácia | draft |
| [#42](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/42) | validátor skillov + CI brána | **kód** | otvorené |
| [#40](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/40) | žiada založiť repá `zakony-sk-mirror`, `judikatura-nssr-mirror`, `mcp-eslp` | issue | **blokujúce** |
| [#41](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/41) | Windows ako first-class cieľ | issue | otvorené |

### VŘ — 2026-08-15

| # | Čo | Typ | Stav |
|---|---|---|---|
| [#48](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/48) | pravidlá počítania lehôt CZ — 30 pravidiel, 25 lehôt, 18 pascí, 24 testov; každé ustanovenie overené proti plnému zneniu predpisu | rešerš | ✅ zlúčené 16. 8. |
| [#49](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/49) | mapa českých dátových zdrojov — 15 zdrojov so stavom zrelosti, 5 pomenovaných medzier; plní úlohu z roadmapy | rešerš | ✅ zlúčené 16. 8. |
| [#50](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/50) | odpovede na Q01–Q25 | rozhodnutia | ✅ zlúčené 16. 8. |

**Ďalej ponúka na uvoľnenie:** výpočtový engine lehôt (§ 57 o. s. ř. + sviatky), nástroje ISDS / ISIR / kataster *(po odstránení prevádzkových špecifík kancelárie)* a korpus ~94 komentárov *(Apache-2.0, s výhradou vyššie)*.

> [!CAUTION]
> **[Issue #40](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/40) je blokujúce a čaká na MČ.** IR má pripravený **per-paragrafový mirror 20 slovenských predpisov (~6300 súborov, 44 MB)** vrátane dôvodových správ a zbierku rozhodnutí NS SR — ale **member účet nemá právo zakladať repozitáre**. Buď mu ich MČ založí, alebo povolí *repo creation* pre členov.

---

## Chýbajú

| Kto | Stav |
|---|---|
| **MČ** | odpovede **rozpracované**, zatiaľ nenahraté *(k 2026-08-16)*. Pri Q07, Q06, Q18, Q21, Q14 a Q25 je jeho hlas rozhodujúci — na role product ownera sa IR aj VŘ zhodli. |
| **MF** | **ani jedna odpoveď.** Pripomenuté v Telegrame 2026-08-14. Navyše na neho čaká [ADR 0007](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/19) a potvrdenie [ADR 0003](../decisions/0003-legal-work-ako-zaklad.md), a Q20 mu prideľuje sign-off za súkromie a hranice pamäti. |

<sub>Zostavil MČ s AI asistenciou. Odpovede IR zapísané 2026-08-14 z komentárov v PR #26 a v PR #13, #14, #16, #19, #27, #31; odpovede VŘ doplnené 2026-08-16 z [PR #50](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/50). Obe sú **skrátené pre prehľad** — plné znenie je vždy v origináli. Ak niekde skratka mení význam, platí originál. Tvrdenia VŘ o prevádzkových skúsenostiach nie sú ďalej doložené než odkazom na jeho prax; tvrdenia o obsahu predpisov sa opierajú o [podklad k CZ lehotám](../research/pravny-ramec/2026-08-15-lhoty-cz-pravidla-vypoctu.md).</sub>
