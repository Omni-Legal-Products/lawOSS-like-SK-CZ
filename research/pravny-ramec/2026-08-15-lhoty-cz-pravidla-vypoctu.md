# Počítání lhůt v českém právu

- **Přispěl:** Vojta Říha (VŘ) · 2026-08-15 · destilát interního deterministického nástroje kanceláře RIHA legal
- **Pro:** [spec 0005 Lehoty & timeline](../../specs/0005-lehoty-timeline.md) — česká část, protějšek [PR #33](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/33) (IR, SK)
- **Stav:** draft na revizi; tvrzení bez ověření nesou tag [OVĚŘIT] a před použitím je musí ověřit advokát

Doplňuje sekce `1.2`, `2.2`, `3.2`, `4.2` a české testovací případy, které podklad IR ponechal otevřené.

> [!IMPORTANT]
> **Metoda ověření se liší od SK podkladu.** IR uvedl, že jeho zdroj má ustanovení ověřená proti úřednímu znění a co ověřeno nemá, označil [OVĚŘIT]. Zde je **každé citované ustanovení načteno v okamžiku psaní z plného znění předpisu** (Salvia / `krajta.slv.cz`, 2026-08-15) a znění pravidla je z něj přepsáno, ne reprodukováno z paměti. Tagy [OVĚŘIT] proto nesou jen ta místa, kde je otevřená **výkladová** otázka, ne kde chybí kontrola textu.
>
> Co ověřeno **není** a je tak označeno: judikatorní ukotvení nad rámec jednoho níže citovaného rozsudku rozšířeného senátu, insolvenční odvolací lhůty, exekuční řád a promlčecí doby OZ.

## Metodické zásady

Přebírám všech pět zásad z podkladu IR (výpočet je kalendářní aritmetika, ne úsudek modelu · fail-closed katalog · pravidla se váží na předpis · nejistota se propaguje · human gate) a doplňuji tři, které vyplynuly z české úpravy:

6. **Předpis určuje aritmetiku, ne jen délku.** V ČR nestačí vědět „30 dnů" — daňový řád počítá konec měsíční lhůty od jiného dne než o. s. ř. (viz P-14 a past T-05). Katalogový záznam proto musí nést dvojici *(délka, režim počítání)*, ne jen délku.
7. **Fikce doručení je samostatný výpočet, ne vstupní datum.** Úložní doba má vlastní konec, který se posouvá (P-16). Teprve od něj běží navazující lhůta. Systém, který bere „datum doručení" jako prostý vstup, tuto vrstvu tiše přeskočí a vyrobí chybu o 1–3 dny.
8. **Zachování lhůty není totéž co konec lhůty.** U některých lhůt nestačí podání odeslat, musí soudu **dojít** (T-09). Kalkulačka, která vrací jen poslední den, svádí k odeslání poslední den — a u těchto lhůt je to zmeškání.

---

## 1.2 Kategorie lhůt — české právo

**Procesní vs. hmotněprávní.** Rozdíl je stejný jako v SK, ale česká úprava jednu z otázek, kterou IR nechal otevřenou, řeší výslovně:

1. **Posun konce.** U procesních lhůt se konec připadající na sobotu, neděli nebo svátek posouvá na nejblíže následující pracovní den (§ 57 odst. 2 o. s. ř., § 60 odst. 3 tr. ř., § 40 odst. 3 s. ř. s., § 40 odst. 1 písm. c) spr. ř., § 33 odst. 4 d. ř.). **U hmotněprávních lhůt platí totéž na základě výslovného ustanovení § 607 o. z.** — na rozdíl od SK, kde IR tuto otázku označil [OVERIŤ]. Česká odpověď je tedy jednoznačná a pozitivněprávní.
2. **Zachování lhůty.** Procesní lhůta je zpravidla zachována už odevzdáním podání orgánu, který má povinnost je doručit (§ 57 odst. 3 o. s. ř., § 60 odst. 4 tr. ř., § 40 odst. 4 s. ř. s., § 40 odst. 1 písm. d) spr. ř.). **Neplatí to univerzálně** — § 199 odst. 1 IZ výslovně vyžaduje, aby žaloba soudu **došla** (T-09).
3. **Prominutí zmeškání.** Obecně § 58 o. s. ř. (15 dnů po odpadnutí překážky + spojit zmeškaný úkon), § 61 tr. ř. (3 dny od pominutí překážky), § 40 odst. 5 s. ř. s. (**2 týdny**, ne 15 dnů), § 41 spr. ř. (15 dnů, absolutní strop 1 rok). **Vyloučeno je** u dovolání (§ 240 odst. 2 o. s. ř.), u správní žaloby (§ 72 odst. 4 s. ř. s.), u kasační stížnosti (§ 106 odst. 2 věta třetí s. ř. s.), u dovolání v trestním řízení (§ 265e odst. 4 tr. ř.) a u odvolání při neoznámení rozhodnutí (§ 84 odst. 1 spr. ř.).

**Zákonné vs. soudcovské.** Stejný režim jako v SK podkladu: soudcovská lhůta se počítá aritmetikou příslušného předpisu, ale délku i právní základ zadává uživatel a systém je musí označit jako neověřené.

---

## 2.2 Pravidla počítání — české právo

### Občanský soudní řád (zákon č. 99/1963 Sb.)

| Č. | Pravidlo | Ustanovení |
|---|---|---|
| P-01 | Do běhu lhůty se nezapočítává den, kdy došlo ke skutečnosti určující počátek lhůty; **to neplatí u lhůty určené podle hodin**. | § 57 odst. 1 |
| P-02 | Lhůty podle týdnů, měsíců nebo let končí uplynutím dne, který se svým označením shoduje se dnem rozhodné skutečnosti; není-li ho v měsíci, posledním dnem měsíce. | § 57 odst. 2 věta první |
| P-03 | Připadne-li konec lhůty na **sobotu, neděli nebo svátek**, je posledním dnem nejblíže následující pracovní den. Sobota je jmenována výslovně. | § 57 odst. 2 věta druhá |
| P-04 | Lhůta je zachována, je-li posledního dne učiněn úkon u soudu **nebo podání odevzdáno orgánu, který má povinnost je doručit**. | § 57 odst. 3 |

> [!NOTE]
> **Systematická poznámka k P-03.** Věta o posunu je umístěna v odstavci 2, jehož první věta se týká lhůt podle týdnů, měsíců a let. Její vlastní znění je však obecné („Připadne-li konec lhůty…") a jako obecné pravidlo s ní zachází i rozšířený senát NSS (4 Afs 264/2018, bod [84] — „pro ně samotné platí pravidlo, již mnohokrát zmíněné, že připadne-li konec lhůty na sobotu, neděli či svátek…"). Aplikace i na lhůty určené podle dní je tedy ustálená; upozorňuji na ni jen proto, že čistě systematický výklad by k ní sám o sobě nevedl.

### Trestní řád (zákon č. 141/1961 Sb.)

| Č. | Pravidlo | Ustanovení |
|---|---|---|
| P-05 | Do lhůty určené podle dní se nezapočítává den, kdy se stala událost určující počátek lhůty. | § 60 odst. 1 |
| P-06 | Lhůta podle týdnů, měsíců nebo let končí uplynutím dne, který svým jménem nebo číselným označením odpovídá dni události; chybí-li tento den v posledním měsíci, posledním dnem měsíce. | § 60 odst. 2 |
| P-07 | Připadne-li konec lhůty na **den pracovního klidu nebo pracovního volna**, je posledním dnem nejbližší příští pracovní den. | § 60 odst. 3 |
| P-08 | Lhůta je zachována i podáním poštovní zásilky adresované orgánu, u něhož má být podáno, dále podáním u soudu/státního zástupce, u náčelníka (ozbrojené sbory), u ředitele nápravného zařízení (vazba, trest) nebo ústně do protokolu u kteréhokoli okresního soudu či okresního státního zástupce. | § 60 odst. 4 písm. a)–e) |

> [!WARNING]
> **P-07 nejmenuje sobotu ani neděli — stejně jako slovenský § 63 ods. 5 TP.** Trestní řád pojem „den pracovního klidu" nedefinuje. Definice je v § 91 odst. 1 zákoníku práce: *„Dny pracovního klidu jsou dny, na které připadá nepřetržitý odpočinek zaměstnance v týdnu, a svátky."* Nepřetržitý odpočinek se přitom váže na rozvrh směn konkrétního zaměstnance (§ 92 zákoníku práce, jehož odst. 3 pouze ukládá zaměstnavateli usilovat, aby do odpočinku spadala neděle). Zahrnutí soboty tedy **neplyne z textu přímo** a § 60 odst. 3 tr. ř. je proto nutné opřít o dovětek „nebo pracovního volna". Praxe sobotu i neděli za takové dny pokládá; **judikatorní oporu jsem neověřoval** [OVĚŘIT]. Implementace to má flagovat, ne tiše předpokládat.

### Soudní řád správní (zákon č. 150/2002 Sb.)

| Č. | Pravidlo | Ustanovení |
|---|---|---|
| P-09 | Lhůta počíná běžet **počátkem dne následujícího** poté, kdy došlo ke skutečnosti určující její počátek; neplatí u lhůt podle hodin. | § 40 odst. 1 |
| P-10 | Lhůta podle týdnů, měsíců nebo roků končí uplynutím dne, který se svým označením shoduje se dnem, **který určil počátek lhůty**; není-li takový den v měsíci, posledním dnem měsíce. | § 40 odst. 2 |
| P-11 | Posun konce ze soboty, neděle nebo svátku na nejblíže následující pracovní den; **neplatí u lhůt podle hodin**. | § 40 odst. 3 |
| P-12 | Lhůta je zachována předáním soudu nebo zasláním prostřednictvím držitele poštovní licence anebo předáním orgánu, který má povinnost je doručit. | § 40 odst. 4 |
| P-13 | Nemá-li zvláštní zákon stanovící lhůtu k podání návrhu k soudu vlastní ustanovení o počítání a běhu lhůt, **použijí se odstavce 1 až 4 obdobně**. | § 40 odst. 6 |

### Správní řád (zákon č. 500/2004 Sb.)

| Č. | Pravidlo | Ustanovení |
|---|---|---|
| P-14a | Nezapočítává se den rozhodné skutečnosti (neplatí u hodin); **v pochybnostech se za počátek považuje den následující po dni, o němž je jisto, že skutečnost již nastala**. | § 40 odst. 1 písm. a) |
| P-14b | Lhůty podle týdnů/měsíců/let končí dnem shodného označení se dnem rozhodné skutečnosti; není-li takový den, posledním dnem měsíce. | § 40 odst. 1 písm. b) |
| P-14c | Posun konce ze soboty, neděle nebo svátku; neplatí u hodin. | § 40 odst. 1 písm. c) |
| P-14d | Lhůta zachována podáním u věcně a místně příslušného správního orgánu nebo podáním poštovní zásilky; při vážných důvodech i podáním u orgánu vyššího stupně. | § 40 odst. 1 písm. d) |
| P-14e | **V pochybnostech se lhůta považuje za zachovanou, dokud se neprokáže opak.** | § 40 odst. 2 |

### Daňový řád (zákon č. 280/2009 Sb.) — ODLIŠNÁ ARITMETIKA

| Č. | Pravidlo | Ustanovení |
|---|---|---|
| P-15 | Lhůta podle **týdnů, měsíců nebo let** počíná běžet dnem následujícím po dni rozhodné skutečnosti a **končí uplynutím dne, který se shoduje se dnem, kdy započal běh lhůty**. Není-li takový den v měsíci, připadne poslední den lhůty na jeho poslední den. | § 33 odst. 1 |
| P-16 | Lhůta podle **dní** počíná běžet dnem následujícím po dni rozhodné skutečnosti. | § 33 odst. 2 |
| P-17 | Lhůta v jednotkách kratších než dny se počítá od okamžiku rozhodné skutečnosti. | § 33 odst. 3 |
| P-18 | Posun konce ze soboty, neděle nebo svátku; neplatí u jednotek kratších než dny. | § 33 odst. 4 |

> [!CAUTION]
> **P-15 je jediné pravidlo v této tabulce, které se liší od všech ostatních předpisů — a liší se o jeden den.**
> Zatímco § 57 odst. 2 o. s. ř. (a shodně tr. ř., s. ř. s., spr. ř.) váže konec na den **rozhodné skutečnosti**, § 33 odst. 1 d. ř. jej váže na den, kdy **započal běh lhůty**, tedy na den následující.
> Doručení 31. 3., lhůta 3 měsíce → podle o. s. ř. konec **30. 6.**, podle daňového řádu konec **1. 7.** (testovací případ 16).
> **U lhůt podle dní k rozdílu nedochází** (oba režimy počítají od následujícího dne — testovací případ 15). Chyba se tedy projeví jen u týdnů, měsíců a let, což ji dělá o to zákeřnější: na denních lhůtách se sdílená implementace jeví jako správná.

### Občanský zákoník (zákon č. 89/2012 Sb.) — hmotněprávní lhůty a doby

| Č. | Pravidlo | Ustanovení |
|---|---|---|
| P-19 | Lhůta nebo doba určená podle dnů počíná dnem následujícím po skutečnosti rozhodné pro její počátek. | § 605 odst. 1 |
| P-20 | Konec lhůty/doby podle týdnů, měsíců nebo let připadá na den, který se pojmenováním nebo číslem shoduje se dnem rozhodné skutečnosti; není-li takový den v posledním měsíci, na poslední den měsíce. | § 605 odst. 2 |
| P-21 | Polovinou měsíce se rozumí patnáct dnů, středem měsíce jeho patnáctý den; je-li lhůta určena na měsíce a část měsíce, počítá se část měsíce naposled. | § 606 |
| P-22 | **Připadne-li poslední den lhůty na sobotu, neděli nebo svátek, je posledním dnem lhůty pracovní den nejblíže následující.** | § 607 |
| P-23 | Lhůta/doba v jednotkách kratších než dny se počítá od okamžiku, kdy začne, do okamžiku, kdy skončí. | § 608 |

### Dny pracovního klidu a svátky

| Č. | Pravidlo | Pramen |
|---|---|---|
| P-24 | **Státní svátky (7):** 1. 1. Den obnovy samostatného českého státu · 8. 5. Den vítězství · 5. 7. Cyril a Metoděj · 6. 7. Mistr Jan Hus · 28. 9. Den české státnosti · 28. 10. Vznik samostatného československého státu · 17. 11. Den boje za svobodu a demokracii. | § 1 z. č. 245/2000 Sb. |
| P-25 | **Ostatní svátky (7):** 1. 1. Nový rok · **Velký pátek** · **Velikonoční pondělí** · 1. 5. Svátek práce · 24. 12. Štědrý den · 25. 12. 1. svátek vánoční · 26. 12. 2. svátek vánoční. | § 2 z. č. 245/2000 Sb. |
| P-26 | Státní i ostatní svátky jsou dny pracovního klidu. | § 3 z. č. 245/2000 Sb. |

Kalendářně jde o **13 různých dnů** (1. leden je uveden v obou paragrafech pod dvěma názvy), z toho dva pohyblivé odvozené od data Velikonoční neděle (Meeusův algoritmus). Na rozdíl od SK podkladu je tento seznam **ověřen proti úplnému znění zákona** — vygenerovaná tabulka pro roky 2026 a 2027 byla porovnána s § 1 a § 2 a souhlasí.

⚠️ Zůstává platná výhrada IR, že jde o **časově proměnný údaj**: Velký pátek je dnem pracovního klidu až od novely účinné pro rok 2016. Výpočet pro historické datum musí použít znění zákona k rozhodnému dni; implementace, která má jen aktuální tabulku, nesmí počítat zpětně bez varování.

---

## Katalog ověřených lhůt

Všechna ustanovení načtena z plného znění předpisu 2026-08-15.

| Č. | Lhůta | Délka | Počátek běhu | Ustanovení |
|---|---|---|---|---|
| K-01 | Odvolání (o. s. ř.) | 15 dnů | doručení písemného vyhotovení rozhodnutí | § 204 odst. 1 |
| K-02 | Odvolání při chybějícím/nesprávném poučení (o. s. ř.) | 3 měsíce | doručení | § 204 odst. 2 |
| K-03 | Dovolání (o. s. ř.) | 2 měsíce | doručení rozhodnutí odvolacího soudu | § 240 odst. 1 |
| K-04 | Dovolání při chybějícím/nesprávném poučení (o. s. ř.) | 3 měsíce | doručení | § 240 odst. 3 |
| K-05 | Odpor proti platebnímu rozkazu | 15 dnů | doručení platebního rozkazu | § 172 odst. 1 |
| K-06 | Námitky proti směnečnému (šekovému) platebnímu rozkazu | 15 dnů | doručení; náhradní doručení vyloučeno | § 175 odst. 1 |
| K-07 | Návrh na prominutí zmeškání lhůty (o. s. ř.); připojit zmeškaný úkon | 15 dnů | odpadnutí překážky | § 58 odst. 1 |
| K-08 | Odvolání (tr. ř.) | **8 dnů** | doručení opisu rozsudku | § 248 odst. 1 |
| K-09 | Stížnost proti usnesení (tr. ř.) | **3 dny** (kalendářní) | oznámení usnesení | § 143 odst. 1 |
| K-10 | Dovolání (tr. ř.) | 2 měsíce | doručení rozhodnutí | § 265e odst. 1 |
| K-11 | Žádost o navrácení lhůty (tr. ř.) | 3 dny | pominutí překážky | § 61 odst. 1 |
| K-12 | Žaloba proti rozhodnutí správního orgánu (s. ř. s.) | 2 měsíce | oznámení rozhodnutí doručením písemného vyhotovení; strop 1 rok od právní moci, neoznamuje-li se | § 72 odst. 1 |
| K-13 | Kasační stížnost (s. ř. s.) | **2 týdny** | doručení rozhodnutí; při opravném usnesení běží znovu od jeho doručení | § 106 odst. 2 |
| K-14 | Doplnění náležitostí kasační stížnosti | 1 měsíc | doručení výzvy; prodloužitelné nejdéle o měsíc | § 106 odst. 3 |
| K-15 | Odvolání (spr. ř.) | 15 dnů | oznámení rozhodnutí | § 83 odst. 1 |
| K-16 | Odvolání při chybějícím/neúplném/nesprávném poučení (spr. ř.) | 15 dnů od oznámení opravného usnesení, **nejpozději 90 dnů** od oznámení rozhodnutí | oznámení | § 83 odst. 2 |
| K-17 | Odvolání účastníka, jemuž rozhodnutí nebylo oznámeno (spr. ř.) | 30 dnů od dozvědění, **nejpozději 1 rok**; prominutí vyloučeno | dozvědění se | § 84 odst. 1 |
| K-18 | Odvolání (daňový řád) | 30 dnů | doručení rozhodnutí (lze i před doručením) | § 109 odst. 4 |
| K-19 | Odvolání při vadném poučení (daňový řád) | 30 dnů od doručení opravného rozhodnutí, **nejpozději 3 měsíce** od doručení rozhodnutí | doručení | § 110 odst. 1 |
| K-20 | Ústavní stížnost | 2 měsíce | doručení rozhodnutí o posledním procesním prostředku | § 72 odst. 3 z. č. 182/1993 Sb. |
| K-21 | Ústavní stížnost, není-li procesní prostředek | 2 měsíce od dozvědění, **nejpozději 1 rok** od zásahu | dozvědění se o zásahu | § 72 odst. 5 z. č. 182/1993 Sb. |
| K-22 | Přihláška pohledávky do insolvenčního řízení | 2 měsíce | rozhodnutí o úpadku (výzva dle písm. d)) | § 136 odst. 2 písm. d) IZ |
| K-23 | Incidenční žaloba věřitele na určení popřené nevykonatelné pohledávky | 30 dnů od přezkumného jednání, **avšak neskončí dříve než 15 dnů od doručení vyrozumění** | přezkumné jednání / doručení vyrozumění | § 198 odst. 1 IZ |
| K-24 | Žaloba insolvenčního správce při popření vykonatelné pohledávky | 30 dnů od přezkumného jednání; **žaloba musí soudu dojít** | přezkumné jednání | § 199 odst. 1 IZ |
| K-25 | Neplatnost rozvázání pracovního poměru (hmotněprávní) | 2 měsíce | den, kdy měl pracovní poměr skončit tímto rozvázáním | § 72 zákoníku práce |

---

## 3.2 Doručování a fikce doručení — české právo

Tady je česká část **podstatně bohatší než SK podklad**, který fikci doručení vyčlenil jako neimplementovanou etapu. Česká úprava i judikatura otázku řeší a lze ji implementovat deterministicky.

### Fikce doručení — tři režimy

| Režim | Mechanismus | Ustanovení |
|---|---|---|
| **Datová schránka** | Dokument je doručen okamžikem přihlášení oprávněné osoby. Nepřihlásí-li se **do 10 dnů** od dodání, považuje se za doručený posledním dnem této lhůty. Neplatí, vylučuje-li jiný předpis náhradní doručení. | § 17 odst. 3 a 4 z. č. 300/2008 Sb. |
| **Do vlastních rukou poštou** | Nezastižen → písemnost se uloží a zanechá se výzva. Nevyzvedne-li si ji adresát **do 10 dnů** ode dne, kdy byla připravena k vyzvednutí, považuje se posledním dnem této lhůty za doručenou, i když se adresát o uložení nedozvěděl. | § 49 odst. 4 o. s. ř. |
| **Jiné písemnosti** | Nezastižen → vhození do schránky, doručeno vhozením. Nelze-li vhodit → vrácení soudu a vyvěšení na úřední desce, doručeno **desátým dnem po vyvěšení**. | § 50 odst. 1 a 2 o. s. ř. |

Doručení do datové schránky podle § 17 odst. 3 nebo 4 má **stejné právní účinky jako doručení do vlastních rukou** (§ 17 odst. 6). Náhradní doručení je vyloučeno tam, kde to stanoví zákon nebo nařídil předseda senátu (§ 49 odst. 5) — u platebního rozkazu je vyloučeno, **s výjimkou doručování do datové schránky** (§ 173 odst. 1 o. s. ř.).

### ⭐ Desetidenní úložní doba se posouvá — rozšířený senát NSS

Tohle je nejdůležitější zjištění celého podkladu a nejčastější zdroj chyby o jeden až tři dny.

Rozšířený senát Nejvyššího správního soudu, rozsudek ze dne 26. 5. 2022, **č. j. 4 Afs 264/2018-85** ([mcp.slv.cz](https://mcp.slv.cz/ECLI:CZ:NSS:2022:4.Afs.264.2018.85)), bod **[86]** — přepsáno z plného znění odůvodnění:

> „Ustanovení § 17 odst. 4 zákona o elektronických úkonech, stejně jako § 45 odst. 4 daňového řádu, § 24 odst. 1 správního řádu, **§ 49 odst. 4 o. s. ř.** a **§ 64 odst. 4 trestního řádu**, je tedy třeba vykládat tak, že **úložní doba podle těchto ustanovení (i její elektronický ekvivalent při doručování do datové schránky) končí podle pravidel pro lhůty upravených příslušnými procesními řády.**"

Bod **[87]** rozšiřuje totéž pravidlo na doručování veřejnou vyhláškou a vyvěšením na úřední desce (§ 49 odst. 3 d. ř., § 25 odst. 2 věta třetí spr. ř., § 42 odst. 4 s. ř. s., § 50l odst. 1 o. s. ř.) a dodává: *„Od takto počítané doby se odvíjejí i právní důsledky doručovaného rozhodnutí (právní moc, běh lhůt k podání opravných prostředků aj.)"*

Úřední právní věta rozsudku je formulovaná úžeji (jen „při správě daní"); **obecné pravidlo je v bodě [86] odůvodnění**, ne ve větě. Kdo si přečte jen headnote, dojde k závěru, že se to civilního řízení netýká — a bude počítat špatně.

Rozšířený senát přitom navázal na **stanovisko pléna Nejvyššího soudu ze dne 5. 1. 2017, sp. zn. Plsn 1/2015**, které bod [74] cituje ve znění: *„lhůta podle § 17 odst. 4 zákona o elektronických úkonech je lhůtou procesní, jejíž běh se při doručování písemností v občanském soudním řízení počítá podle § 57 odst. 1 a 2 o. s. ř. a při doručování písemností v trestním řízení podle § 60 odst. 1 a 3 tr. ř."*

⚠️ **Stanovisko Plsn 1/2015 jsem nečetl v původním znění**, přebírám je z citace v rozsudku rozšířeného senátu, který jsem načetl celý [OVĚŘIT verbatim před citací v podání].

**Důsledek pro implementaci:** fikce doručení je dvoustupňový výpočet.
1. dodání/uložení → +10 dnů → **posun na pracovní den** → *datum doručení*
2. datum doručení → délka lhůty → posun → *poslední den lhůty*

Naivní implementace kroku 1 bez posunu dává chybu 1–3 dny (testovací případy 21–23).

### Insolvenční specifikum

§ 74 odst. 2 IZ: je-li s doručením písemnosti, pro kterou zákon stanoví **zvláštní způsob doručení**, spojen počátek běhu lhůty k podání opravného prostředku nebo k jinému procesnímu úkonu, běží lhůta **ode dne doručení zvláštním způsobem**, nikoli od zveřejnění v insolvenčním rejstříku. Zveřejnění v rejstříku je přitom dokladem o doručení i při zvláštním způsobu doručení (§ 74 odst. 1). Dvě různá data u téže písemnosti — viz past T-08.

### Vícero adresátů

| Situace | Pravidlo | Ustanovení |
|---|---|---|
| Rozsudek se doručuje obžalovanému i obhájci a opatrovníkovi | lhůta běží od **nejpozdějšího** doručení | § 248 odst. 2 tr. ř. |
| Usnesení se oznamuje obviněnému i opatrovníkovi/obhájci | lhůta běží od **nejpozdějšího** oznámení | § 143 odst. 1 tr. ř. |
| Dovolání, doručuje-li se obviněnému i obhájci a opatrovníkovi | lhůta od **nejpozdějšího** doručení | § 265e odst. 2 tr. ř. |
| Osoby oprávněné podat stížnost ve prospěch obviněného | končí **týmž dnem** jako obviněnému | § 143 odst. 2 tr. ř. |
| **Státní zástupce** | běží **vždy samostatně** | § 143 odst. 2 tr. ř. |
| Jiné osoby dle § 247 odst. 2 tr. ř. (kromě SZ) | končí týmž dnem jako obžalovanému | § 248 odst. 3 tr. ř. |

---

## 4.2 Zvláštní pasti — české právo

| Č. | Past | Opora |
|---|---|---|
| T-01 | **Rozhodná událost se liší podle typu lhůty:** doručení (o. s. ř., d. ř.), doručení opisu rozsudku (tr. ř.), oznámení (spr. ř., stížnost tr. ř.), právní moc, dozvědění se, odpadnutí překážky, den kdy měl skončit pracovní poměr. Formálně správný výpočet z nesprávného data je nejtišší chyba. | katalog K-01 až K-25 |
| T-02 | **Stížnost podle § 143 odst. 1 tr. ř. je 3 dny KALENDÁŘNÍ.** Slovenský protějšek (§ 187 ods. 1 TP) je **3 pracovní dny**. Kdo přenese SK logiku na CZ věc, prodlouží si lhůtu o víkend a zmešká ji. Zrcadlově: kdo přenese CZ logiku na SK, podá zbytečně brzy. **Toto je nejnebezpečnější rozdíl mezi oběma jurisdikcemi v celém katalogu.** | § 143 odst. 1 tr. ř. vs. § 187 ods. 1 TP |
| T-03 | **Odvolání v trestním řízení je 8 dnů, v civilním 15.** Obojí se počítá podle § 60 tr. ř., resp. § 57 o. s. ř., které mají jinak formulovaný posun konce (P-03 vs. P-07). | § 248 odst. 1 tr. ř., § 204 odst. 1 o. s. ř. |
| T-04 | **Kasační stížnost je 2 TÝDNY, ne měsíc a ne 15 dnů.** Byla-li vydáno opravné usnesení, běží znovu od jeho doručení. Prominutí je vyloučeno. | § 106 odst. 2 s. ř. s. |
| T-05 | **Daňový řád počítá konec měsíční lhůty o jeden den později než o. s. ř.** (§ 33 odst. 1 váže konec na den započetí běhu, nikoli na den rozhodné skutečnosti). U denních lhůt k rozdílu nedochází — sdílená implementace proto projde denními testy a selže až na měsíčních. | § 33 odst. 1 d. ř. vs. § 57 odst. 2 o. s. ř. |
| T-06 | **Desetidenní úložní doba u fikce doručení se posouvá**, připadne-li její konec na sobotu, neděli nebo svátek — a to i podle § 49 odst. 4 o. s. ř. a § 17 odst. 4 z. č. 300/2008 Sb. Posune se tím i celá navazující lhůta. Úřední právní věta rozsudku rozšířeného senátu je užší než jeho bod [86]; kdo cituje jen větu, aplikuje pravidlo jen na daně. | 4 Afs 264/2018, body [86] a [87] |
| T-07 | **Chybějící nebo nesprávné poučení mění délku lhůty, a v každém předpisu jinak:** o. s. ř. 15 dnů → 3 měsíce · dovolání 2 měsíce → 3 měsíce · spr. ř. 15 dnů od opravného usnesení, strop 90 dnů · d. ř. 30 dnů od opravného rozhodnutí, strop 3 měsíce. Katalog musí nést variantu „bez poučení" jako samostatný záznam, ne jako poznámku. | § 204 odst. 2, § 240 odst. 3 o. s. ř., § 83 odst. 2 spr. ř., § 110 odst. 1 d. ř. |
| T-08 | **V insolvenci má táž písemnost dvě data.** Zveřejnění v ISIR je dokladem o doručení, ale je-li s doručením spojen počátek lhůty k opravnému prostředku a jde o zvláštní způsob doručení, běží lhůta až od doručení zvláštním způsobem. Kdo počítá od zveřejnění v rejstříku, počítá od dřívějšího data. | § 74 odst. 1 a 2 IZ |
| T-09 | **U žaloby dle § 199 odst. 1 IZ nestačí podání odeslat — musí soudu DOJÍT.** *„Lhůta je zachována, dojde-li žaloba nejpozději posledního dne lhůty soudu."* To je opak obecného § 57 odst. 3 o. s. ř. Kalkulačka, která vrací jen poslední den, svádí k odeslání poslední den poštou — a tím je lhůta zmeškána. | § 199 odst. 1 IZ vs. § 57 odst. 3 o. s. ř. |
| T-10 | **Složená lhůta s podlahou.** Incidenční žaloba dle § 198 odst. 1 IZ běží 30 dnů od přezkumného jednání, *„tato lhůta však neskončí dříve než uplynutím 15 dnů od doručení vyrozumění"*. Rozhodný je **pozdější** z obou konců. Jednosložkový výpočet dá u pozdě doručeného vyrozumění kratší lhůtu, než jaká ve skutečnosti běží. | § 198 odst. 1 ve spojení s § 197 odst. 2 IZ |
| T-11 | **Řetězení svátku a víkendu.** Posun se opakuje, dokud první den není pracovní: konec 1. 5. 2026 (pátek, svátek) se posouvá přes sobotu a neděli až na pondělí 4. 5. 2026. Vánoční blok 24.–26. 12. umí ve spojení s víkendem posunout konec i o pět dnů. | P-03, P-07, P-11, P-18, P-22 |
| T-12 | **Měsíční lhůta z konce měsíce.** Neexistuje-li v cílovém měsíci den shodného označení (31., 30., 29. února), končí lhůta posledním dnem měsíce — v únoru tedy 28., v přestupném roce 29. | P-02, P-06, P-10, P-14b, P-15, P-20 |
| T-13 | **Posun se uplatní jen na konec lhůty.** Dny pracovního klidu uvnitř běhu se započítávají. Na rozdíl od SK **nemá české právo v katalogu žádnou lhůtu určenou v pracovních dnech** — proto zde chybí protějšek slovenské pasti T-04. | P-03, P-07, P-11, P-18 |
| T-14 | **Prominutí zmeškání má v každém předpisu jinou lhůtu a někde je vyloučeno:** o. s. ř. 15 dnů · tr. ř. 3 dny · s. ř. s. **2 týdny** · spr. ř. 15 dnů se stropem 1 rok. Vyloučeno u dovolání (o. s. ř. i tr. ř.), správní žaloby, kasační stížnosti a odvolání dle § 84 spr. ř. Systém nesmí nabídnout „návrh na prominutí" tam, kde je vyloučeno. | § 58 o. s. ř., § 61 tr. ř., § 40 odst. 5 s. ř. s., § 41 spr. ř., § 240 odst. 2 o. s. ř., § 265e odst. 4 tr. ř., § 72 odst. 4 a § 106 odst. 2 s. ř. s., § 84 odst. 1 spr. ř. |
| T-15 | **Lhůty určené podle hodin jsou vyloučeny z posunu i z pravidla o nezapočítání prvního dne** (§ 57 odst. 1 a 2 o. s. ř., § 40 odst. 1 a 3 s. ř. s., § 40 odst. 1 písm. a) a c) spr. ř., § 33 odst. 3 a 4 d. ř., § 608 o. z.). Automatický výpočet je má odmítnout, ne „dopočítat" po dnech. | tamtéž |
| T-16 | **Subsidiarita u zvláštních zákonů.** § 40 odst. 6 s. ř. s. přikazuje použít pravidla odst. 1–4 obdobně, nemá-li zvláštní zákon stanovící lhůtu k podání návrhu vlastní úpravu. Systém musí vědět, který předpis lhůtu zakládá **a** který ji počítá — nejsou to vždy tytéž předpisy. | § 40 odst. 6 s. ř. s. |
| T-17 | **Hmotněprávní prekluze v pracovním právu.** § 72 zákoníku práce: 2 měsíce ode dne, kdy měl pracovní poměr skončit — nikoli od doručení výpovědi. Po marném uplynutí právo zaniká. Posun konce dle § 607 o. z. se uplatní. Přímý protějšek slovenské pasti T-08 (§ 77 ZP SK), včetně toho, že počátek se váže na skončení poměru, ne na doručení. | § 72 ZP, § 605 a § 607 o. z. |
| T-18 | **Pochybnost o počátku ve správním řízení nejde k tíži účastníka:** § 40 odst. 1 písm. a) spr. ř. určuje, že v pochybnostech je počátkem den následující po dni, o němž je jisto, že skutečnost nastala, a § 40 odst. 2 stanoví domněnku zachování lhůty, dokud se neprokáže opak. Deterministický výpočet toto pravidlo nesmí přepsat tvrdým datem. | § 40 odst. 1 písm. a) a odst. 2 spr. ř. |

---

## 5. Testovací případy — české právo

Očekávané datumy **nejsou odhad** — byly vypočteny deterministickým skriptem (`~/.claude/lhuta.py`, § 57 o. s. ř. + tabulka svátků dle z. č. 245/2000 Sb.) a u daňového řádu jeho variantou implementující § 33 odst. 1. Dny v týdnu ověřeny týmž výpočtem. Formát DD.MM.RRRR.

### Základní aritmetika (o. s. ř.)

| Č. | Lhůta | Délka | Rozhodná událost | Očekávaný poslední den | Odůvodnění |
|---|---|---|---|---|---|
| 1 | odvolání | 15 dnů | doručení 02.03.2026 (po) | **17.03.2026** (út) | Den doručení se nezapočítává (§ 57/1); 15. den je pracovní, bez posunu. |
| 2 | odvolání | 15 dnů | doručení 15.12.2026 (út) | **30.12.2026** (st) | Vánoční svátky 24.–26. 12. leží uvnitř běhu, započítávají se (T-13); konec je pracovní den. |
| 3 | dovolání | 2 měsíce | doručení 31.12.2026 (čt) | **01.03.2027** (po) | 31. 2. neexistuje → konec 28.02.2027 (§ 57/2 věta první); neděle → posun na pondělí. |
| 4 | odvolání bez poučení | 3 měsíce | doručení 30.11.2026 (po) | **01.03.2027** (po) | 30. 2. neexistuje → 28.02.2027; neděle → pondělí (§ 204/2 + § 57/2). |
| 5 | odpor proti PR | 15 dnů | doručení 30.04.2026 (čt) | **15.05.2026** (pá) | 15. den je pracovní; svátek 1. 5. leží uvnitř běhu a započítává se. |
| 6 | modelová denní | 1 den | událost 30.04.2026 (čt) | **04.05.2026** (po) | Naivní konec 01.05. je svátek (pátek), následuje víkend → řetězení posunu na pondělí (T-11). |
| 7 | modelová měsíční | 1 měsíc | událost 31.01.2026 (so) | **02.03.2026** (po) | Den shodného označení v únoru není → 28.02.2026; sobota → pondělí. |
| 8 | modelová roční | 1 rok | událost 29.02.2024 (čt) | **28.02.2025** (pá) | V nepřestupném roce den shodného označení není → poslední den února; bez posunu. |

### Trestní řízení

| Č. | Lhůta | Délka | Rozhodná událost | Očekávaný poslední den | Odůvodnění |
|---|---|---|---|---|---|
| 9 | odvolání (§ 248/1) | 8 dnů | doručení opisu rozsudku 02.03.2026 (po) | **10.03.2026** (út) | Den doručení se nezapočítává (§ 60/1); konec je pracovní den. |
| 10 | stížnost (§ 143/1) | **3 dny kalendářní** | oznámení 05.03.2026 (čt) | **09.03.2026** (po) | Naivní konec neděle 08.03. → posun na pondělí (§ 60/3). **Slovenský § 187 ods. 1 TP by při téže události dal 10.03. (tři pracovní dny) — viz T-02.** |
| 11 | dovolání (§ 265e/1) | 2 měsíce | doručení 31.12.2026 (čt) | **01.03.2027** (po) | 31. 2. neexistuje → 28.02.2027 (§ 60/2); neděle → pondělí (§ 60/3). |

### Správní soudnictví a správní řízení

| Č. | Lhůta | Délka | Rozhodná událost | Očekávaný poslední den | Odůvodnění |
|---|---|---|---|---|---|
| 12 | žaloba (§ 72/1 s. ř. s.) | 2 měsíce | doručení 02.03.2026 (po) | **04.05.2026** (po) | Den shodného označení 02.05. je sobota → posun na pondělí (§ 40/2 a /3). |
| 13 | kasační stížnost (§ 106/2) | **2 týdny** | doručení 02.03.2026 (po) | **16.03.2026** (po) | Dva týdny od počátku běhu; konec je pracovní den. |
| 14 | odvolání (§ 83/1 spr. ř.) | 15 dnů | oznámení 17.04.2026 (pá) | **04.05.2026** (po) | Naivní konec sobota 02.05. → posun na pondělí (§ 40/1 písm. c)); svátek 1. 5. leží uvnitř běhu. |

### Daňové řízení — demonstrace rozdílu P-15

| Č. | Lhůta | Délka | Rozhodná událost | Podle daňového řádu | Podle o. s. ř. | Odůvodnění |
|---|---|---|---|---|---|---|
| 15 | odvolání (§ 109/4) | 30 dnů | doručení 02.03.2026 | **01.04.2026** (st) | 01.04.2026 (st) | **Shoda.** U denních lhůt počítají oba režimy od následujícího dne (§ 33/2 d. ř. ≈ § 57/1 o. s. ř.). |
| 16 | vadné poučení (§ 110/1) | 3 měsíce | doručení 31.03.2026 | **01.07.2026** (st) | 30.06.2026 (út) | **Rozdíl jednoho dne.** § 33/1 váže konec na den započetí běhu (01.04.), § 57/2 na den rozhodné skutečnosti (31.03. → 30.06.). |

### Ústavní stížnost a hmotněprávní lhůta

| Č. | Lhůta | Délka | Rozhodná událost | Očekávaný poslední den | Odůvodnění |
|---|---|---|---|---|---|
| 17 | ústavní stížnost (§ 72/3) | 2 měsíce | doručení rozhodnutí 02.03.2026 (po) | **04.05.2026** (po) | Den shodného označení 02.05. je sobota → pondělí. |
| 18 | neplatnost rozvázání PP (§ 72 ZP) | 2 měsíce | PP měl skončit 31.10.2026 (so) | **31.12.2026** (čt) | Hmotněprávní prekluze; den shodného označení existuje a je pracovní (§ 605/2 o. z.), posun dle § 607 se neuplatní. |

### Insolvence

| Č. | Lhůta | Délka | Rozhodná událost | Očekávaný poslední den | Odůvodnění |
|---|---|---|---|---|---|
| 19 | přihláška pohledávky | 2 měsíce | rozhodnutí o úpadku 02.03.2026 | **04.05.2026** (po) | Den shodného označení 02.05. je sobota → pondělí. Pozor na T-08 (od kterého data se počítá). |
| 20 | incidenční žaloba (§ 198/1) | 30 dnů **s podlahou 15 dnů** | přezkumné jednání 05.03.2026; vyrozumění doručeno 25.03.2026 | **09.04.2026** (čt) | 30 dnů od přezkumného jednání = 07.04.2026 (út). Podlaha 15 dnů od doručení vyrozumění = 09.04.2026 (čt). **Rozhodný je pozdější z obou** — jednosložkový výpočet by dal o dva dny méně (T-10). |

### Fikce doručení — dvoustupňový výpočet

| Č. | Situace | Dodání / uložení | 10. den úložní doby | Fikce doručení | Konec odvolací lhůty 15 dnů | Naivní výpočet |
|---|---|---|---|---|---|---|
| 21 | DS, § 17/4 z. č. 300/2008 | 02.03.2026 (po) | 12.03.2026 (čt) — pracovní, bez posunu | **12.03.2026** | **27.03.2026** (pá) | shodně 27.03. |
| 22 | DS, § 17/4 — konec úložní doby na neděli | 23.04.2026 (čt) | 03.05.2026 (**ne**) → posun | **04.05.2026** (po) | **19.05.2026** (út) | ⚠️ 18.05. — **chyba o 1 den** |
| 23 | § 49/4 o. s. ř. — konec úložní doby na sobotu | 22.04.2026 (st) | 02.05.2026 (**so**) → posun | **04.05.2026** (po) | **19.05.2026** (út) | ⚠️ 18.05. — **chyba o 1 den** |
| 24 | DS — konec úložní doby na svátek 1. 5. | 21.04.2026 (út) | 01.05.2026 (**svátek, pá**) → řetězení | **04.05.2026** (po) | **19.05.2026** (út) | ⚠️ 18.05. — **chyba o 1 den** |

Sloupec „naivní výpočet" ukazuje, co vrátí implementace, která posune jen konec navazující lhůty, ale ne konec úložní doby (T-06).

---

## 6. Témata nepokrytá tímto podkladem

1. **Promlčecí a prekluzivní doby občanského zákoníku** (§ 609 a násl. o. z.) — obecná tříletá doba, subjektivní/objektivní běh, stavení a přetržení. Neověřováno.
2. **Exekuční řád** (z. č. 120/2001 Sb.) a lhůty ve výkonu rozhodnutí. Neověřováno.
3. **Insolvenční odvolací lhůty** mimo K-22 až K-24 — lhůty proti jednotlivým typům usnesení, lhůty v oddlužení (§ 398 a násl. IZ), popěrné úkony dlužníka. Neověřováno.
4. **Lhůty v řízení před ESLP a SDEU.**
5. **Zvláštní řízení soudní** (z. č. 292/2013 Sb.) — vlastní odchylky od o. s. ř.
6. **Judikatorní ukotvení** — podklad obsahuje jedinou judikatorní kotvu (4 Afs 264/2018, načteno celé). Stanovisko Plsn 1/2015 je převzato z jeho citace [OVĚŘIT verbatim].
7. **Zahrnutí soboty pod „den pracovního klidu nebo pracovního volna"** dle § 60 odst. 3 tr. ř. — opřeno o § 91 odst. 1 zákoníku práce a praxi, judikatorně neověřeno [OVĚŘIT].
8. **Historické verze tabulky svátků** — Velký pátek je dnem pracovního klidu až od roku 2016; výpočet pro starší data vyžaduje znění zákona k rozhodnému dni.
9. **Neúčinnost doručení** — § 50d o. s. ř., § 17 odst. 5 z. č. 300/2008 Sb., § 24 odst. 2 spr. ř. Mění datum doručení zpětně, tedy i všechny navazující lhůty. Neověřováno.

---

## Návrh dopadu do spec 0005

1. **Katalog musí nést trojici** *(délka, počátek, režim počítání)*, ne dvojici. Důvod: P-15.
2. **Fikce doručení je samostatný krok pipeline**, ne vstupní datum. Důvod: T-06.
3. **Příznak „zachování lhůty"** u každého záznamu: postačí odeslání, nebo musí dojít? Důvod: T-09.
4. **Příznak „prominutí zmeškání"**: přípustné / nepřípustné / lhůta k návrhu. Důvod: T-14.
5. **Složené lhůty** (max ze dvou konců) musí být v datovém modelu od začátku, ne dodělané. Důvod: T-10.
6. **Jurisdikční přepínač je povinný, ne volitelný.** T-02 ukazuje, že tatáž věta („stížnost, tři dny") znamená v ČR a na SK jiné datum. Sdílený katalog bez tvrdého rozlišení CZ/SK je nebezpečnější než dva oddělené.

---

<sub>Připravil VŘ s AI asistencí, 2026-08-15. Znění všech citovaných ustanovení načteno 2026-08-15 z plného znění předpisů (Salvia, `krajta.slv.cz`); rozsudek 4 Afs 264/2018 načten v plném rozsahu odůvodnění. Testovací datumy vypočteny deterministickým skriptem, nikoli odhadem. Místa označená [OVĚŘIT] nesou otevřenou výkladovou otázku a před citací v podání je nutné je ověřit.</sub>
