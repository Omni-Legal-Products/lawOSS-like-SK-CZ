# Zaručená konverzia v Slovenskej republike – právny rámec, technické špecifikácie a integračné možnosti

## Úvod a účel zaručenej konverzie

Zaručená konverzia je zákonom regulovaný proces prevodu dokumentov medzi listinnou a elektronickou formou, resp. medzi rôznymi formátmi elektronických dokumentov, pri ktorom sa zachovávajú právne účinky pôvodného dokumentu. Novovzniknutý dokument spojený s osvedčovacou doložkou zaručenej konverzie má rovnaké právne účinky a je použiteľný na právne úkony rovnako ako pôvodný dokument. Účelom zaručenej konverzie je umožniť bezpečnú digitálnu transformáciu dokumentov (napr. digitalizáciu listín alebo transformáciu starších elektronických podpisových formátov) pri zachovaní dôveryhodnosti a kontrolovateľnosti procesu.[^1][^2][^3][^4]

## Právny rámec zaručenej konverzie

Základnú právnu úpravu zaručenej konverzie obsahuje zákon č. 305/2013 Z. z. o e-Governmente, najmä ustanovenia § 35 a nasledujúce (vrátane § 37 a § 39 o zázname a osvedčovacej doložke). Vykonávacím predpisom je vyhláška Ministerstva investícií, regionálneho rozvoja a informatizácie SR č. 70/2021 Z. z. o zaručenej konverzii v znení neskorších predpisov, vrátane novely č. 63/2024 Z. z., ktorá upravila formáty novovzniknutých dokumentov a osvedčovacej doložky. Historicky bola vykonávacia úprava obsiahnutá vo vyhláške č. 331/2018 Z. z., ktorú novšia vyhláška MIRRI nahradila, pričom centrálna evidencia záznamov o konverzii vyplýva z tejto líniovej regulácie.[^5][^6][^7][^8][^3][^9][^10]

## Subjekty oprávnené vykonávať zaručenú konverziu

Zaručenú konverziu môžu vykonávať len zákonom definované „oprávnené osoby“, medzi ktoré patria orgány verejnej moci, advokáti, notári, poštový podnik poskytujúci univerzálnu službu ako IOMO, patentoví zástupcovia (s obmedzeniami), Slovenský pozemkový fond a niektoré štátne právnické osoby pri konverzii dokumentov súvisiacich s pohľadávkami. Žiadateľom o vykonanie konverzie môže byť fyzická alebo právnická osoba, ktorá požaduje transformáciu svojho dokumentu na inú podobu pri zachovaní právnych účinkov. Orgán verejnej moci vykonáva zaručenú konverziu dokumentov, ktoré vznikli z jeho činnosti, bezodplatne, v ostatných prípadoch má nárok na úhradu hotových výdavkov podľa sadzobníka vo vyhláške.[^3][^5][^1]

## Typy zaručenej konverzie

Zákon o e-Governmente rozlišuje tri základné typy zaručenej konverzie: z elektronického dokumentu do listinnej podoby (E2L), z listinnej podoby do elektronického dokumentu (L2E) a z elektronického dokumentu do elektronického dokumentu v inom formáte (E2E). Každý typ konverzie má špecifický postup, štruktúru osvedčovacej doložky a záznamu o konverzii, ako aj technické náležitosti novovzniknutého dokumentu. Spoločným menovateľom je povinnosť vytvoriť záznam o vykonanej zaručenej konverzii a osvedčovaciu doložku, ktoré musia byť autorizované a zaslané do centrálnej evidencie záznamov.[^4][^9][^10][^11][^3]

## Centrálna evidencia záznamov o vykonanej zaručenej konverzii (IS EZZK)

Centrálna evidencia záznamov o vykonanej zaručenej konverzii (IS EZZK) je informačný systém verejnej správy, ktorý eviduje záznamy o všetkých zaručených konverziách vykonaných oprávnenými osobami. Záznam o vykonanej zaručenej konverzii obsahuje údaje o pôvodnom dokumente, jeho autorizácii a overení, údaje o novovzniknutom dokumente, údaje o osobe vykonávajúcej konverziu a evidenčné údaje vrátane evidenčného čísla záznamu. Záznam sa zasiela do centrálnej evidencie do 24 hodín od jeho vytvorenia a uchováva sa dlhodobo (v súčasnej úprave sa uvádza horizon 70 rokov, resp. bez časového obmedzenia v predchádzajúcich verziách).[^12][^13][^9][^10][^4]

## Úloha EZZK v procese a overovanie záznamov

IS EZZK prideľuje oprávnenej osobe evidenčné číslo záznamu o zaručenej konverzii, ktoré sa uvádza v osvedčovacej doložke a zázname. Prostredníctvom portálu ezzk.iomo.sk môžu používatelia overiť, či bol predložený dokument skonvertovaný v súlade so zákonom, oprávnenou osobou a či novovzniknutý dokument má účinok osvedčenej kópie. EZZK je dostupná cez používateľské rozhranie a aplikačné rozhranie, čo umožňuje integračným partnerom (napr. advokátskym kanceláriám) realizovať automatizované zápisy záznamov.[^13][^10][^12][^3][^4]

## Formáty novovzniknutých dokumentov a osvedčovacích doložiek

Vyhláška 70/2021 Z. z. v znení novely 63/2024 ustanovuje, že novovzniknutý elektronický dokument pri konverzii podľa § 35 ods. 1 písm. b) a c) (L2E a E2E) môže byť vo formáte PDF alebo PNG. Osvedčovacia doložka, ak je samostatnou časťou novovzniknutého elektronického dokumentu, sa vyhotovuje ako elektronický dokument vo formáte XML, ktorý je zahrnutý ako príloha v PDF súbore. V prípade listinnej osvedčovacej doložky je možné ju umiestniť na samostatný list alebo na opačnú stranu novovzniknutého dokumentu, pričom obsahuje identifikačné údaje o zázname z EZZK a vyhlásenie osoby vykonávajúcej konverziu o dodržaní postupu.[^6][^2][^14][^1]

## Štruktúra XML formulárov – osvedčovacia doložka

Elektronické formuláre osvedčovacích doložiek sú zverejnené v module elektronických formulárov (eForm) ÚPVS; pre konverziu elektronického dokumentu do listinnej podoby má formulár root element `ConversionCertificateOfElectronicDocumentToPaper`. HTML reprezentácia formulára na portáli Slovensko.sk obsahuje detailné vysvetlenie jednotlivých polí, vrátane pravidiel pre názov pôvodného dokumentu, formát dokumentu a identifikátor osoby vykonávajúcej autorizáciu. Pole „formát dokumentu“ používa hodnoty ako "PDF", "TXT", "PNG" alebo "XMLDataContainer" v súlade s výnosom MF SR č. 55/2014 Z. z. o štandardoch pre IS verejnej správy, čo je dôležité pre jednoznačnú identifikáciu typu elektronického dokumentu v XML štruktúre.[^15][^16]

## Štruktúra zápisu o konverzii – dátová príloha vyhlášky

Príloha k vyhláške (napr. príloha k predpisu 331/2018) podrobne opisuje dátovú štruktúru záznamu o konverzii vrátane jednotlivých údajov, ich výskytu (multiplicity) a dátových typov pre XML. Uvádzajú sa údaje o pôvodnom elektronickom dokumente (názov, druh, formát, hodnota elektronického odtlačku, hash funkcia), o novovzniknutom dokumente (názov, formát, elektronický odtlačok), autorizačné prvky pôvodného dokumentu (typ autorizácie, elektronické podpisy/pečate, výsledok overenia, čas overenia, miesto autorizácie, identifikátor autorizujúcej osoby, mandát, časová pečiatka). Ďalej sa uvádzajú údaje o zaručenej konverzii, konkrétne evidenčné číslo záznamu, použitý prostriedok (technický alebo programový prostriedok alebo manuálny prepis), dátum a čas vykonania konverzie a údaje o osobe, ktorá konverziu vykonala (IČO, názov osoby, meno, priezvisko, funkcia).[^10]

## Identifikácia osoby, autorizácie a mandátu v XML osvedčovacej doložke

Formulár osvedčovacej doložky definuje presnú štruktúru identifikácie fyzickej a právnickej osoby prostredníctvom atribútov v certifikáte (napr. `organisationName`, `serialNumber`, `organizationIdentifier`, `givenName`, `surname`, `serialNumber`). Identifikátor právnickej osoby sa tvorí z trojznakového prefixu (VAT, NTR, SZ) nasledovaného kódom krajiny podľa ISO 3166 (napr. "SK") a vlastným identifikátorom oddeleným pomlčkou, napr. "SZ:SK-123123". Identifikátor fyzickej osoby používa prefixy PNO, IDC, PAS s kódom krajiny a číselným identifikátorom, napr. "IDCSK-123123", pričom formulár rieši aj používanie pseudonymu cez atribúty "pseudonym" a "commonName".[^16]

## Kvalifikovaný elektronický podpis, pečať a validácia

Osvedčovacia doložka obsahuje informáciu, či certifikát použitý pri autorizácii je kvalifikovaný a či privátny kľúč je uložený na bezpečnom zariadení (QSCD), v textovom formáte „certifikát – kvalifikovaný“ / „certifikát – nekvalifikovaný“ a „certifikát na QSCD“ / „certifikát nie je na QSCD“. Kvalifikovaný certifikát musí obsahovať rozšírenie QcCompliance OID (0.4.0.1862.1.1) a príslušnú politiku NBÚ v attribute `certificatePolicies` (OID 2.5.29.32), pričom vydavateľ certifikátu je uvedený v európskom dôveryhodnom zozname (EU Trusted List). Osoba vykonávajúca konverziu je od 1. marca 2022 povinná používať kvalifikovanú službu validácie kvalifikovaných elektronických podpisov a pečatí podľa § 3 ods. 4 vyhlášky 70/2021 Z. z., čo prakticky znamená využitie akreditovanej validačnej služby pri overovaní autorizácie pôvodného dokumentu.[^17][^16]

## Výsledok overenia podpisu/pečate v zázname o konverzii

Dátová štruktúra záznamu o konverzii obsahuje položku „Výsledok overenia podpisu/pečate“, ktorá obsahuje validačnú správu o splnení požiadaviek článku 32 nariadenia eIDAS (910/2014) alebo výstup validácie podpísaný/zapečatený kvalifikovanou dôveryhodnou službou validácie. Táto položka je povinná a zabezpečuje, aby bolo možné spätne preukázať, že použitý elektronický podpis alebo pečať spĺňal požiadavky kvalifikovaného podpisu/pečate v čase konverzie. Záznam obsahuje aj čas overenia autorizácie, prípadné údaje o časovej pečiatke (typ, stav, čas vystavenia, vydavateľ, čas overenia), ktoré sú kritické pre dlhodobú dôveryhodnosť elektronických podpisov.[^11]

## Proces vytvorenia záznamu o konverzii a osvedčovacej doložky

Podľa metodického usmernenia MIRRI osoba vykonávajúca zaručenú konverziu musí najprv overiť autorizáciu pôvodného dokumentu (podpis, pečať, časová pečiatka), následne vytvoriť novovzniknutý dokument v príslušnom formáte (PDF/PNG alebo listinná podoba) a vyhotoviť záznam o konverzii v elektronickej forme. Záznam o konverzii sa vyplní podľa elektronického formulára zverejneného v module elektronických formulárov, autorizuje sa kvalifikovaným elektronickým podpisom alebo pečaťou osoby vykonávajúcej konverziu a zašle do EZZK. Na základe údajov z centrálnej evidencie osoba vytvorí osvedčovaciu doložku (listinnú alebo elektronickú), ktorú neoddeliteľne spojí s novovzniknutým dokumentom; pri elektronickej podobe sa osvedčovacia doložka vyhotovuje ako XML súbor zahrnutý v PDF/ASiC kontejneri.[^9][^6][^10][^11]

## Generovanie XML súboru z formulára – technický postup

Pri vyplnení elektronického formulára (napr. osvedčovacej doložky) na Slovensko.sk je možné vygenerovať XML súbor obsahujúci údaje z formulára pomocou tlačidla „Vygenerovať súbor“. Po vygenerovaní sa zobrazí ikona „spinky“ s názvom súboru vo formáte XML; súbor možno uložiť do počítača, opätovne načítať do formulára cez „Načítať súbor“ a podpísať kvalifikovaným elektronickým podpisom. Podpísaný XML súbor – formulár sa následne pripája k podaniu na portáli Slovensko.sk, pričom podpis zabezpečuje integritu a nezmeniteľnosť údajov v XML osvedčovacej doložke alebo zázname o konverzii.[^18]

## Vzťah medzi XML, PDF/PNG a podpisovým kontajnerom (ASiC)

Vyhláška 70/2021 Z. z. predpisuje, že pri konverzii do elektronickej podoby sa osvedčovacia doložka vo forme XML musí autorizovať spoločne s novovzniknutým dokumentom (PDF/PNG) v jednom podpisovom kontajneri (ASiC). To znamená, že technická implementácia musí vytvoriť kontajner, ktorý obsahuje minimálne dva súbory – novovzniknutý dokument (napr. `document.pdf`) a osvedčovaciu doložku (`certificate.xml`) – a spoločnú elektronickú autorizáciu (KEP alebo pečať) viazanú na celý kontajner. Pri niektorých typoch konverzie sa od povinnosti uvádzať digitálny odtlačok novovzniknutého dokumentu upúšťa, ak je novovzniknutý dokument spojený s osvedčovacou doložkou do jedného PDF súboru, čo zjednodušuje technickú realizáciu.[^2][^6][^1][^13]

## Evidencia záznamov u osoby vykonávajúcej konverziu vs. centrálna evidencia

Historicky bola osoba vykonávajúca zaručenú konverziu povinná viesť „lokálnu“ evidenciu záznamov o konverzii, ktorá obsahovala všeobecnú a osobitnú časť so záznamami o jednotlivých konverziách. V súčasnosti sa smeruje k upusteniu od povinnosti lokálnej evidencie a k plnej rely na centrálnej evidencii IS EZZK, pričom návrhy zmien od 1. októbra 2025 počítajú s povinným nahrávaním údajov do EZZK a zjednodušením náležitostí osvedčovacích doložiek. Cieľom týchto zmien je posilniť dôveryhodnosť novovzniknutých dokumentov, odbúrať administratívnu záťaž spojenú s lokálnymi evidenciami a zabezpečiť jedno centrálne miesto overenia záznamu o konverzii.[^19][^20][^12][^13][^10]

## Sadzby úhrad za zaručenú konverziu

Vyhláška MIRRI stanovuje sadzby za jednotlivé úkony zaručenej konverzie, vrátane vytvorenia osvedčovacej doložky, transformácie každej (aj začatej) strany novovzniknutého dokumentu v listinnej podobe v závislosti od formátu (A4, A3) a používania technológie OCR. Sadzobník obsahuje tiež sadzby za hotové výdavky, ako sú výdavky na tlač dokumentov (jednostranné a obojstranné listy A4/A3), a výdavky na kvalifikovanú dôveryhodnú službu validácie podpisov a pečatí. Orgán verejnej moci má pri konverzii dokumentov z vlastnej činnosti nárok len na úhradu hotových výdavkov; pri konverzii pre iné subjekty sa uplatňujú aj sadzby za úkony konverzie.[^5][^1]

## Najdôležitejšie dátové prvky pre technickú integráciu

Z pohľadu technickej integrácie aplikácie na zaručenú konverziu sú kľúčové tieto dátové prvky: identifikátor záznamu o konverzii (URL podľa schémy `https://data.gov.sk/id/egov/conversion-record/ID`), údaje o pôvodnom dokumente (názov, formát, hash, typ autorizácie, výsledok validácie), údaje o novovzniknutom dokumente (názov, formát, hash), údaje o osobe vykonávajúcej konverziu (IČO, meno, priezvisko, funkcia) a použité technické/progamové prostriedky. XML formuláre osvedčovacích doložiek definujú presný XML schema (XSD) pre tieto dátové prvky, vrátane formátu `dateTime` pre údaje o čase autorizácie, overenia a konverzie a textových reťazcov pre identifikátory. Pri integrácii s EZZK je nevyhnutné implementovať aplikačné rozhranie (API) na prideľovanie evidenčných čísel, odosielanie záznamov a načítanie dát pre vytvorenie osvedčovacej doložky.[^14][^12][^13][^16]

## Technický postup generovania a podpisovania XML – praktické aspekty

Implementácia vlastnej aplikácie musí podporovať generovanie XML súboru podľa štruktúry elektronického formulára (napr. prostredníctvom XSD schémy a mapovania na interné dátové modely), jeho uloženie a následné kvalifikované podpísanie (napr. pomocou KEP karty alebo serverového podpisu). Z pohľadu používateľa formulárov na Slovensko.sk sa XML generuje cez „Vygenerovať súbor“ a podpisuje sa v externej aplikácii, pričom rovnaký princíp je možné implementovať aj v integračnom riešení (interná generácia a podpis, následné odoslanie do EZZK). Aplikácia musí zabezpečiť, aby podpis pokrýval celý XML dokument bez možnosti jeho modifikácie po konverzii, a pri použití kontajnera ASiC musí podpis pokrývať všetky súbory v kontajneri.[^6][^2][^12][^16][^18]

## Budúci vývoj – EZZK 2.0 a zjednodušenie procesu

Dokumenty MIRRI a MetaIS poukazujú na projekt EZZK 2.0, ktorého cieľom je modernizácia centrálnej evidencie záznamov zaručenej konverzie, zjednodušenie integrácie a posilnenie dôveryhodnosti procesu. Návrhy zmien vyhlášky počítajú s možnosťou zachovania pôvodného formátu dokumentu pri konverzii v prípadoch, keď sa mení iba formát podpisu (napr. zo starého XAdES_ZEP/ZEPf na nový formát v súlade s európskym právom), a so zjednodušením osvedčovacích doložiek (neuvádzanie vnorených kontajnerov a digitálneho odtlačku, ak sú technické podmienky limitujúce). Tieto zmeny podporujú praktické scenáre, ako je mass-konverzia historických elektronických dokumentov s podpisom v národnom formáte na dokumenty s podpisom v európskom štandarde bez zmeny vlastného obsahu dokumentu.[^21][^2][^13]

## Zhrnutie praktických dopadov pre vlastnú aplikáciu

Pre vývoj vlastnej aplikácie na zaručenú konverziu je kľúčové rešpektovať právny rámec zákona o e-Governmente a vyhlášky MIRRI a implementovať technické požiadavky na formáty dokumentov, XML osvedčovacích doložiek a integráciu s EZZK. Z technického hľadiska nejde „len“ o vytvorenie XML súboru, ale o zabezpečenie kvalifikovanej autorizácie (KEP/pečať) celého balíka (dokument + doložka), správneho hashovania, validácie pôvodných podpisov a komunikácie s centrálnou evidenciou. Vlastná aplikácia musí implementovať generovanie záznamu o konverzii podľa dátovej štruktúry, jeho podpis a odoslanie do EZZK, vytvorenie osvedčovacej doložky v súlade s eForm špecifikáciami a neoddeliteľné spojenie doložky s novovzniknutým dokumentom v listinnej alebo elektronickej podobe.[^2][^12][^16][^9][^6]

---

## References

1. [Zaručená konverzia dokumentov – zmeny od 1. 4. 2024](https://www.podnikajte.sk/uctovne-doklady/zarucena-konverzia-dokumentov-od-1-4-2024) - Zaručená konverzia umožňuje transformovať napr. listinný dokument do elektronického sveta so zachova...

2. [PI/Zmena Vyhlášky o zaručenej konverzii](https://www.minv.sk/?ros_ministerstvo-investicii-regionalneho-rozvoja-a-informatizacie-slovenskej-republiky&sprava=pi-zmena-vyhlasky-o-zarucenej-konverzii) - Predkladateľ: MIRRI SR Oblasť: Informatizácia Typ: PI Dňa 05.06.2023 bola zverejnená predbežná infor...

3. [Zaručená konverzia | Ministerstvo investícií, regionálneho rozvoja a ...](https://mirri.gov.sk/sekcie/informatizacia/dokumenty/zakon-o-e-governmente/zarucena-konverzia/) - Informácie o stránke Zaručená konverzia

4. [1. Čo je zaručená konverzia?](https://mirri.gov.sk/wp-content/uploads/2019/10/QA-EZZK.pdf)

5. [70/2021 Z. z. Vyhláška o zaručenej konverzii | Aktuálne znenie](https://www.zakonypreludi.sk/zz/2021-70) - Vyhláška č. 70/2021 Z. z. - Vyhláška Ministerstva investícií, regionálneho rozvoja a informatizácie ...

6. [slovenskej republiky - Zbierka zákonov SR](https://static.slov-lex.sk/pdf/SK/ZZ/2024/63/ZZ_2024_63_20240401.pdf)

7. [Vyhláška o zaručenej konverzii](https://mirri.gov.sk/sekcie/informatizacia/dokumenty/zakon-o-e-governmente/vyhlaska-o-zarucenej-konverzii/) - Informácie o stránke Vyhláška o zaručenej konverzii

8. [ZBIERKA](https://static.slov-lex.sk/pdf/SK/ZZ/2018/331/ZZ_2018_331_20200627.pdf)

9. [Zákony.Judikáty.info](https://zakony.judikaty.info/predpis/zakon-305/2013-ucinnost-od-01.10.2025/audit) - Všetky konsolidované znenia ZBIERKY ZÁKONOV SR od roku 1945, podzákonné predpisy,dôvodové správy k z...

10. [slovenskej republiky - Zbierka zákonov SR](https://static.slov-lex.sk/pdf/SK/ZZ/2018/331/ZZ_2018_331_20191201.pdf)

11. [Metodické usmernenie Ministerstva investícií, regionálneho ...](https://mirri.gov.sk/wp-content/uploads/2021/03/Metodicke-usmernenie-k-vykonavaniu-zarucenej-konverzie.pdf)

12. [Centrálna evidencia záznamov o vykonanej zaručenej ...](https://mirri.gov.sk/sekcie/informatizacia/dokumenty/zakon-o-e-governmente/centralna-evidencia-zaznamov-o-vykonanej-zarucenej-konverzii/) - Informácie o stránke Centrálna evidencia záznamov o vykonanej zaručenej konverzii

13. [[PDF] Zaručená konverzia a IS EZZK - MetaIS](https://metais.slovensko.sk/wiki/wiki/ps2/download/PS2/Zasadnutia%20PS2/Spolo%C4%8Dn%C3%A9%20zasadnutie%20PS%202%20(22.%20zasadnutie)%20a%20PS%204%20(24.%20zasadnutie)/WebHome/Prezent%C3%A1cia%20k%20t%C3%A9me%20Zaru%C4%8Den%C3%A1%20konverzia%20a%20IS%20EZZK.pdf?rev=1.2)

14. [Osvedčovacia doložka zaručenej konverzie listinného dokumentu do elektronickej podoby](https://www.slovensko.sk/static/eForm/dataset/50349287.ConversionCertificateOfPaperToElectronicDocument_2021.sk/1.4/Content/form.2.html)

15. [[PDF] Elektronický formulár - Slovensko.sk](https://www.slovensko.sk/static/eForm/dataset/50349287.ConversionCertificateOfElectronicDocumentToPaper/1.2/Content/form.1.help.sk.pdf)

16. [Osvedčovacia doložka zaručenej konverzie vytlačeného ...](https://www.slovensko.sk/static/eForm/dataset/50349287.ConversionCertificateOfElectronicDocumentToPaper/1.2/Content/form.1.html)

17. [Kvalifikované overenie elektronického podpisu.](https://www.dstore.sk/page/kop)

18. [Ako vygenerujem xml súbor z formulára?](https://www.justice.gov.sk/faq/ako-vygenerujem-xml-subor-z-formulara/) - Z vyplneného formulára je potrebné vygenerovať súbor vo formáte XML, uložiť do počítača a následne p...

19. [Úpravy k zaručenej konverzii dokumentov](https://www.isamosprava.sk/clanky/upravy-k-zarucenej-konverzii-dokumentov/)

20. [Vyhláška o zaručenej konverzii (návrh) - Podnikajte.sk](https://www.podnikajte.sk/pripravovane-zmeny-v-legislative/vyhlaska-zarucena-konverzia) - Vyhláška je vykonávacím predpisom pre zaručenú konverziu. Umožňuje prevod listinnej formy dokumentu ...

21. [IDEOVÝ ZÁMER](https://metais.slovensko.sk/api/dms/file/6681fe5a-dba9-4ff3-a81c-af09aa9f606c)

