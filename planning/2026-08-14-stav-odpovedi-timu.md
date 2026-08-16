<div align="center">

# 🗳️ Stav odpovedí tímu — Q01 až Q25

**Živý prehľad** · aktualizované 2026-08-14

![IR](https://img.shields.io/badge/IR-25%2F25%20odpovedan%C3%BDch-brightgreen)
![MF](https://img.shields.io/badge/MF-0%2F25-lightgrey)
![VR](https://img.shields.io/badge/V%C5%98-0%2F25-lightgrey)
![MC](https://img.shields.io/badge/M%C4%8C-0%2F25-lightgrey)

</div>

> [!IMPORTANT]
> **Načo tento dokument je.** Otázky [Q01–Q25](2026-08-12-rozhodovacie-otazky-timu.md) sú rozsiahle a odpovede sa strácajú v komentároch pod PR. Tu sú na jednom mieste, aby **každý videl, čo už odpovedali ostatní, skôr než odpovie sám**.
>
> **Ako doplniť svoju odpoveď:** komentár do [PR #26](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/26) v tvare `Q01: A, pretože…`, alebo PR do tohto súboru. Zapíšem to sem.
>
> ⚠️ **Vidieť cudziu odpoveď pred vlastnou má aj tienistú stránku** — zvádza to prikývnuť. Ak s niečím nesúhlasíš, **je to cennejšie než súhlas**; rozdielne stanovisko sa zapíše rovnako.

---

## Tabuľka

| # | Otázka | 🟢 **IR** *(2026-08-14)* | MF | VŘ | MČ |
|---|---|---|---|---|---|
| **Q01** | Kto je konečný product owner? | A. Produkt musí mať jedného človeka, ktorý rozsekne pat, a to je prirodzene Majo. Výhrady si zapisujme, ale rozhoduje on. | | | |
| **Q02** | Kto vlastní upstream sync s LegalWorkom? | A. Nech sync vlastní jeden človek s AI pomocou a druhý po ňom pozrie. Podmienka: poctivo vedený zoznam našich zásahov do prevzatého kódu, aby sync vedel zopakovať hocikto. Automat, ktorý pri konflikte sám ot… | | | |
| **Q03** | Kto môže schváliť release? | Súhlasím s navrhovaným minimom. Právny sign-off pri citlivých veciach (podpisovanie, konverzia, AML) beriem na seba. | | | |
| **Q04** | Zostane `dev` integračnou aj default vetvou? | A. Čím menej sa odchýlime od pôvodného projektu, tým menej roboty s preberaním noviniek. Stabilné body označujme tagmi. | | | |
| **Q05** | Aké review minimum používame? | Áno, a berme to záväzne aj tam, kde nám to GitHub technicky nevynúti. Keď to niekto poruší, zmena sa vráti a ide sa ďalej, žiadna dráma. | | | |
| **Q06** | Čo vydávame v prvej fáze? | Najprv len kód a návod (A), verejnosti až podpísané buildy (C). Nepodpísané nanajvýš pre nás štyroch s jasným varovaním. A moje meno sa so sťahovaním binárok nespája, to je moja červená čiara. | | | |
| **Q07** | Ktoré tri vertikály sú prvé? | Súhlasím s trojicou: spisy a pamäť, učenie zo schvaľovania, preverovanie subjektov. Jedna prosba: lehoty nech sú prvý náhradník, keď sa uvoľní miesto. Právne jadro k nim už je hotové (#33) a zmeškaná lehota… | | | |
| **Q08** | Čo znamená MVP billing? | B. Evidencia času, sadzby a podklad pre faktúru áno; samotné vystavovanie dokladov a účtovníctvo je iná liga zodpovednosti, nechajme na neskôr. | | | |
| **Q09** | Je anonymizácia formálne vyradená z V1? | Áno, odložiť. Vrátime sa k tomu, keď prvý z nás bude reálne potrebovať poslať obsah spisu do cloudu; detekčné vzory medzitým ležia pripravené (#36). | | | |
| **Q10** | Čo presne patrí do L1, L2 a L3? | Zjednodušene: osobné nastavenia bez klientskych dát, spisová pamäť prísne lokálna per vec, spoločná právnická pamäť len z verejných zdrojov. Vlastníkov vrstiev doklepnime na calle. | | | |
| **Q11** | Kto schvaľuje povýšenie poznatku? | Nič sa nesmie „naučiť" samo. Agent navrhne a ukáže rozdiel, schvaľuje človek. Vždy. | | | |
| **Q12** | Aká je periodicita reconciliation? | Kombinácia: hneď pri dôležitej udalosti, raz týždenne upratať, a na záver veci urobiť bodku. | | | |
| **Q13** | Aké metriky rozhodnú, že reconciliation funguje? | Súhlasím s navrhnutým zoznamom. Najviac ma zaujímajú dve čísla: koľko nezmyslov sa omylom schváli a koľko času nám kontrola reálne berie. | | | |
| **Q14** | Čo obsahujú režimy `light`, `medium` a `hard`? | K zoznamu registrov sa nevyjadrujem, tomu rozumie Majo najlepšie. Jedna podmienka: pri menovcoch nikdy nesmie zhodu potvrdiť stroj sám, vždy človek. | | | |
| **Q15** | Je AML onboarding vlajková feature alebo súčasť OKF? | Vnútri nech je to súčasť zakladania spisu (B); navonok to pokojne komunikujme ako samostatnú funkciu. | | | |
| **Q16** | Musia klientské dáta zostať lokálne? | Dokumenty klientov a spisová pamäť: len lokálne, bez výnimky. Osobné nastavenia tiež. Spoločná právnická pamäť z verejných zdrojov sa zdieľať môže. Telemetria len dobrovoľná a nikdy nie obsah spisov. Zálohy… | | | |
| **Q17** | Je lokálny index predvolený a RAG iba voliteľný? | Áno, lokálne vyhľadávanie ako predvolené. | | | |
| **Q18** | Ktoré platformy podporujeme? | Mac aj Windows rovnocenne od začiatku. Ja mám len Windows, takže testovanie Windows verzie beriem na seba (detaily v issue #41). Linux podľa síl; veci viazané na Apple appky nech majú neutrálnu náhradu. | | | |
| **Q19** | Patrí Poľsko do prvej architektúry? | Pripravme dátové modely tak, aby Poľsko neskôr nebolelo, ale staviame len SK a CZ. | | | |
| **Q20** | Kto vykonáva sign-off? | Návrh rozdelenia: súkromie a hranice pamäti Martin so mnou; AML ja s Majom; podpisovanie a konverzia Majo s mojím právnym sign-offom; licencie dát ja; bezpečnosť releasov Majo. | | | |
| **Q21** | Aký human-in-the-loop model je záväzný? | Sám smie agent čítať verejné zdroje, pripravovať návrhy a udržiavať poriadok v spise. Pripraviť, ale neodoslať: čokoľvek, čo ide von z kancelárie, a zápisy do pamäti. Nikdy: podať niečo na súd, komunikovať s… | | | |
| **Q22** | Je celý softvér a všetky základné moduly bezplatné? | Všetko zadarmo a otvorené; zarábame na školeniach a pomoci so zavedením. Platené moduly odmietam: v momente, keď predávame softvér, sme dodávateľ softvéru so všetkým, čo k tomu patrí, a presne to sme si na z… | | | |
| **Q23** | Čo publikujeme späť komunite? | Vraciame komunite všetko vymenované, pri dátach s vyjasnenou licenciou. Zbierky zákonov a rozhodnutí NS SR už máme pripravené na zverejnenie, čakajú len na repozitáre (#40). | | | |
| **Q24** | Prijímame základnú produktovú doktrínu LAWOSS? | A. Nech je to záväzný meter na budúce rozhodnutia; výnimka len písomne, s dôvodom a časovým obmedzením. | | | |
| **Q25** | Majú byť otvorené formáty jadrom LAWOSS? | A, s jednou praktickou podmienkou: Word nesmie byť druhá kategória. Súdy a protistrany v ňom žijú, takže import, export a sledované zmeny musia fungovať bezchybne (#29, #31). | | | |

---

## Čo z odpovedí IR vyplýva

### Odblokované — ak s tým ostatní súhlasia

| Bod | Dôsledok |
|---|---|
| **Q01 product owner = MČ** | Pat sa dá rozseknúť. Výhrady sa zapisujú, rozhoduje MČ. |
| **Q20 rozdelenie sign-offu** | IR navrhol konkrétne mená ku každej oblasti: *súkromie a pamäť* MF+IR · *AML* IR+MČ · *podpisovanie a konverzia* MČ s právnym sign-offom IR · *licencie dát* IR · *bezpečnosť releasov* MČ. |
| **Q22 monetizácia** | *„Platené moduly odmietam."* Potvrdzuje [ADR 0002](../decisions/0002-preco-forkujeme-mikeoss.md) — zarábame na školeniach. |
| **Q24 doktrína** | Prijíma [ADR 0009](../decisions/0009-zakladna-produktova-doktrina.md) ako záväzný meter, výnimka len písomne a s časovým obmedzením. |

### Nové podmienky, ktoré predtým na stole neboli

> [!WARNING]
> **Windows ako first-class cieľ (Q18).** *„Tím vyvíja na macu, ale cieľová skupina SK/CZ advokátov sedí prevažne na Windows a ja sám Mac nemám."* IR berie testovanie Windows na seba → [issue #41](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/41).
> Toto je vážne: **celý onboarding nález z 12. 8. je mac-centrický** (Xcode CLT, keychain pri Word add-ine). Ak je cieľovka na Windows, testovali sme zatiaľ menšinovú platformu.

> [!WARNING]
> **Červená čiara IR (Q06).** *„Moje meno sa so sťahovaním binárok nespája."* Verejne až podpísané buildy; nepodpísané nanajvýš pre štyroch s varovaním. Sedí to na bránu M2 zo [stratégie](../docs/strategia.md), ale je to teraz **osobná podmienka účasti**, nie odporúčanie.

> [!NOTE]
> **Lehoty ako prvý náhradník (Q07).** IR súhlasí s trojicou vertikál, ale: *„lehoty nech sú prvý náhradník, keď sa uvoľní miesto. Zmeškaná lehota je to, čo advokáta reálne položí."* Právne jadro k nim už dodal → [PR #33](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/33).

> [!NOTE]
> **Word nesmie byť druhá kategória (Q25).** Súhlasí s otvorenými formátmi, ale s podmienkou: *„Súdy a protistrany v ňom žijú, takže import, export a sledované zmeny musia fungovať bezchybne."* Odkazuje na naše nápady [#29 a #31](napady.md).

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

## Čo IR priniesol ako prácu

Za jeden deň, **2026-08-14**:

| # | Čo | Typ |
|---|---|---|
| [#33](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/33) | pravidlá počítania lehôt SK pre spec 0005 | rešerš |
| [#34](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/34) | návod na pripojenie MCP serverov do LegalWorku | dokumentácia |
| [#35](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/35) | metodika kvality skillov — katalóg zlyhaní, testy | dokumentácia |
| [#36](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/36) | SK anonymizačné detektory a vzory | rešerš |
| [#37](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/37) | spisový destilát ako L2 vrstva pamäti | rešerš |
| [#38](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/38) | orchestrácia agentov a human gates — rok prevádzky | rešerš |
| [#39](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/39) | SAK compliance štartovací balík | dokumentácia |
| [#42](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/42) | validátor skillov + CI brána | **kód** |
| [#40](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/40) | žiada založiť repá `zakony-sk-mirror`, `judikatura-nssr-mirror`, `mcp-eslp` | issue |
| [#41](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/41) | Windows ako first-class cieľ | issue |

> [!CAUTION]
> **[Issue #40](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/40) je blokujúce a čaká na MČ.** IR má pripravený **per-paragrafový mirror 20 slovenských predpisov (~6300 súborov, 44 MB)** vrátane dôvodových správ a zbierku rozhodnutí NS SR — ale **member účet nemá právo zakladať repozitáre**. Buď mu ich MČ založí, alebo povolí *repo creation* pre členov.

---

## Chýbajú

**MF** a **VŘ** — ani jedna odpoveď. Pripomenuté v Telegrame 2026-08-14.

<sub>Zostavil MČ s AI asistenciou, 2026-08-14, z komentárov IR v PR #26 a v PR #13, #14, #16, #19, #27, #31. Odpovede sú **skrátené pre prehľad** — plné znenie je vždy v [PR #26](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/26). Ak niekde skratka mení význam, platí originál.</sub>
