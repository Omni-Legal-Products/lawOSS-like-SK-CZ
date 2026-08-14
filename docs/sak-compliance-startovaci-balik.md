# SAK compliance štartovací balík pre advokáta používajúceho AI nástroj

**Autor:** JUDr. Igor Ribár, advokát, člen Predsedníctva Slovenskej advokátskej komory
**Status:** DRAFT, osobný odborný materiál autora určený na revíziu pred publikáciou
**Projekt:** LAWOSS (open-source repozitár pre SK/CZ advokátov), nástroj LegalWork (desktopová AI aplikácia s MCP konektormi na právne zdroje)

> **Upozornenie k povahe dokumentu.** Tento materiál je osobným odborným podkladom autora.
> Nie je stanoviskom, usmernením ani odporúčaním Slovenskej advokátskej komory ani žiadneho
> jej orgánu. Členstvo autora v Predsedníctve SAK nezakladá inštitucionálnu povahu tohto
> textu a žiadna jeho časť sa nesmie prezentovať slovami „SAK odporúča" alebo „schválené komorou".

## I. Úvod: prečo advokát pri používaní AI rieši mlčanlivosť a ochranu osobných údajov

Advokát je podľa § 23 ods. 1 zákona č. 586/2003 Z. z. o advokácii povinný zachovávať
mlčanlivosť o všetkých skutočnostiach, o ktorých sa dozvedel v súvislosti s výkonom
advokácie. Povinnosť mlčanlivosti sa podľa § 23 ods. 8 tohto zákona vzťahuje aj na
zamestnancov advokáta a na iné osoby, ktoré sa podieľajú na poskytovaní právnych služieb.
Trvá aj po vyčiarknutí advokáta zo zoznamu advokátov (§ 23 ods. 7) a pozbaviť jej advokáta
môže spravidla len klient, a to písomne (§ 23 ods. 2).

Odoslanie obsahu klientskeho spisu do cloudovej AI služby je z pohľadu tejto povinnosti
sprístupnením informácií tretej osobe (prevádzkovateľovi AI služby). Advokát preto musí
pred každým takýmto krokom vedieť odpovedať na otázku, na akom právnom a zmluvnom základe
k sprístupneniu dochádza. Súbežne advokát vystupuje ako prevádzkovateľ osobných údajov
klienta aj tretích osôb (protistrana, svedkovia) v zmysle všeobecnej úpravy ochrany
osobných údajov; ak AI služba spracúva osobné údaje v jeho mene, ide o vzťah
prevádzkovateľ a sprostredkovateľ, ktorý vyžaduje zmluvu podľa čl. 28 GDPR.

Základná zásada celého materiálu: **AI výstup je vždy iba návrh (draft)**. Právnu službu
poskytuje advokát, ktorý každý výstup pred použitím skontroluje, schváli a nesie zaň plnú
odbornú aj disciplinárnu zodpovednosť. Použitie AI nástroja nezbavuje advokáta žiadnej
povinnosti podľa zákona o advokácii ani predpisov o ochrane osobných údajov a advokát
zodpovednosť za výstup nemôže preniesť na nástroj ani na jeho prevádzkovateľa.

## II. Rozhodovací test: tri režimy prípustného spracúvania klientskych dát s AI

Predsedníctvo SAK sa otázke používania AI nástrojov advokátmi venovalo v uznesení
č. 12/4/2025 [OVERIŤ presné označenie, dátum prijatia a text uznesenia]. Z neho vychádza
rozhodovací test, podľa ktorého je spracúvanie klientskych dát AI nástrojom prípustné
v niektorom z troch režimov [OVERIŤ, či uznesenie vymedzuje práve tieto tri režimy a či
ich formuluje ako alternatívy]:

**Režim (a): informovaný súhlas klienta.** Klient po zrozumiteľnom vysvetlení, aký nástroj
sa použije, aké jeho dáta sa spracujú a aké sú riziká, so spracovaním výslovne súhlasí.
Laicky: klient vie a súhlasí. Vhodné najmä tam, kde sa má spracovať väčší rozsah
neanonymizovaných podkladov alebo kde klient sám používanie AI očakáva. Súhlas odporúčam
zachytiť písomne alebo v inej preukázateľnej forme a poučenie o rizikách dokumentovať.

**Režim (b): zmluva o spracúvaní osobných údajov (DPA), sprostredkovateľ.** Prevádzkovateľ
AI služby spracúva dáta v mene advokáta na základe zmluvy podľa čl. 28 GDPR, ktorá ho
viaže pokynmi advokáta, dôvernosťou a zákazom použitia dát na vlastné účely. Laicky:
poskytovateľ služby je zmluvne zviazaný pracovať len pre advokáta a mlčať. Toto je bežný
režim pri firemných cloudových nástrojoch, kde advokát uzatvára zmluvu ako podnikateľ.

**Režim (c): komerčné API alebo komerčný plán s no-training zárukou.** Advokát používa
službu na základe obchodných podmienok pre podnikateľov (Commercial Terms alebo ich
ekvivalent), ktoré obsahujú záväzok, že vstupy a výstupy sa nepoužijú na trénovanie
modelov, a záruky dôvernosti spracúvania. Laicky: platený firemný prístup, pri ktorom
poskytovateľ zmluvne garantuje, že sa z dát advokáta nič „neučí" a nikam ďalej ich nedáva.

**Čo režimom (c) nie je: spotrebiteľské predplatné.** Bežné consumer účty AI služieb
(typicky označované Free, Pro, Max, Plus a podobne) sú uzatvárané podľa spotrebiteľských
podmienok, ktoré štandardne neobsahujú DPA, negarantujú no-training režim ako zmluvný
záväzok voči advokátovi a nedávajú advokátovi kontrolu nad ďalším použitím dát. Laicky:
súkromný účet, hoci platený, nie je firemný režim. Advokát, ktorý posiela klientske dáta
cez spotrebiteľský účet, sa nemôže odvolávať na režim (c); prípustnosť by musel založiť
inak, spravidla režimom (a) pri súčasnej dôslednej anonymizácii. Aktuálne podmienky
konkrétneho poskytovateľa je vždy potrebné overiť pred prvým použitím, pretože sa menia.

Prierezové pravidlo pre všetky tri režimy: aj tam, kde je režim splnený, platí zásada
minimalizácie (čl. 5 GDPR, zásada minimalizácie údajov), teda do nástroja sa posiela len
to, čo je pre konkrétnu úlohu nevyhnutné, a identifikátory, ktoré úloha nevyžaduje, sa
anonymizujú alebo pseudonymizujú [OVERIŤ, či a v akej podobe uznesenie č. 12/4/2025
alebo usmernenie SAK výslovne vyžaduje anonymizáciu pred použitím cloudového nástroja].

## III. Vzor informačnej doložky do zmluvy o poskytovaní právnych služieb

Usmernenie SAK k používaniu AI predpokladá v čl. 11 informovanie klienta o používaní AI
nástrojov v zmluve o poskytovaní právnych služieb [OVERIŤ presné označenie usmernenia,
číslo článku a znenie povinnosti]. Nižšie sú dva vzorové varianty doložky v prvej osobe
kancelárie; advokát si ich prispôsobí vlastnej praxi a použitým nástrojom.

### Variant 1: stručná doložka

> Informujeme Vás, že pri poskytovaní právnych služieb používame aj nástroje umelej
> inteligencie, a to výlučne ako podporný prostriedok pri príprave podkladov a návrhov
> dokumentov. Každý výstup takéhoto nástroja kontroluje a schvaľuje advokát, ktorý nesie
> plnú zodpovednosť za poskytnutú právnu službu. Pri používaní týchto nástrojov
> dodržiavame povinnosť mlčanlivosti podľa § 23 zákona č. 586/2003 Z. z. o advokácii
> a predpisy o ochrane osobných údajov. Na Vašu žiadosť Vám poskytneme bližšie informácie
> o použitých nástrojoch a spôsobe ochrany Vašich údajov.

### Variant 2: rozšírená doložka

> Informujeme Vás, že pri poskytovaní právnych služieb používame nástroje umelej
> inteligencie ako podporný prostriedok, najmä pri rešerši právnych predpisov
> a judikatúry, príprave pracovných verzií dokumentov a organizácii podkladov. Tieto
> nástroje nikdy nenahrádzajú odborné posúdenie advokáta: každý výstup je iba pracovným
> návrhom, ktorý advokát pred použitím skontroluje, upraví a schváli, a za poskytnutú
> právnu službu zodpovedá výlučne naša kancelária.
>
> Vaše údaje pri tom chránime nasledovne: (i) údaje spracúvame prednostne v nástrojoch,
> ktoré ich neodosielajú mimo zariadení kancelárie; (ii) ak použijeme cloudovú službu,
> robíme tak len na základe zmluvných záruk dôvernosti a zákazu použitia údajov na
> trénovanie modelov (zmluva o spracúvaní osobných údajov podľa čl. 28 GDPR alebo
> komerčné podmienky s takýmito zárukami), prípadne po odstránení identifikačných údajov;
> (iii) rozsah odosielaných údajov obmedzujeme na nevyhnutné minimum; (iv) o použití
> nástrojov vedieme internú evidenciu. Povinnosť mlčanlivosti podľa § 23 zákona
> č. 586/2003 Z. z. o advokácii zostáva použitím týchto nástrojov nedotknutá.
>
> Máte právo požiadať nás o bližšie informácie o konkrétnych použitých nástrojoch,
> o kategóriách údajov, ktoré sa v nich spracúvajú, ako aj právo vzniesť proti použitiu
> cloudových AI nástrojov na Vaše podklady námietky; v takom prípade s Vami dohodneme
> postup, ktorý Vašej požiadavke vyhovie.

## IV. Vzor internej smernice kancelárie o používaní AI (kostra)

1. **Účel.** Smernica upravuje pravidlá používania nástrojov umelej inteligencie
   v kancelárii tak, aby bola zachovaná mlčanlivosť podľa § 23 zákona č. 586/2003 Z. z.,
   ochrana osobných údajov a odborná zodpovednosť advokáta za každý výstup.
2. **Definície.** AI nástroj; lokálny nástroj (dáta neopúšťajú zariadenie kancelárie);
   cloudový nástroj; anonymizácia; pseudonymizácia; klientske dáta; výstup AI.
3. **Dovolené použitia.** Rešerš verejných právnych zdrojov; práca s anonymizovanými
   podkladmi; príprava pracovných verzií dokumentov; interné organizačné úlohy bez
   klientskych dát; spracovanie klientskych dát výlučne v režime podľa bodu 5.
4. **Zakázané použitia.** Odosielanie klientskych dát cez spotrebiteľské účty AI služieb;
   použitie AI výstupu bez kontroly advokátom; zadávanie prístupových údajov, hesiel
   a bezpečnostných tajomstiev do AI nástrojov; automatizované odosielanie výstupov
   klientom, súdom alebo protistranám bez schválenia advokátom.
5. **Klasifikácia dát a prípustné režimy.** Verejné dáta (predpisy, judikatúra,
   odborná literatúra): bez obmedzenia. Interné dáta kancelárie (know-how, šablóny bez
   klientskych údajov): cloudové nástroje len s firemnými zmluvnými zárukami. Klientske
   dáta: výlučne lokálny nástroj, alebo cloudový nástroj v režime (a), (b) alebo (c)
   podľa čl. II tohto balíka, so zásadou minimalizácie.
6. **Pravidlo anonymizácie pred cloudom.** Pred odoslaním klientskeho podkladu do
   cloudového nástroja sa odstránia alebo nahradia identifikátory (mená, rodné čísla,
   adresy, dátumy narodenia, čísla účtov, ďalšie identifikátory podľa povahy veci),
   ak nie sú pre úlohu nevyhnutné. Výnimku schvaľuje zodpovedná osoba.
7. **Human gate na výstupy.** Žiadny AI výstup neopustí kanceláriu bez kontroly
   a schválenia advokátom. Výstup sa do schválenia označuje ako pracovný návrh.
8. **Evidencia použitia.** O použití AI nástroja pri klientskej veci sa vedie záznam
   (dátum, nástroj, režim, rozsah dát, kontrolujúci advokát), primerane rozsahu praxe.
9. **Zodpovedná osoba.** Kancelária určí advokáta zodpovedného za AI compliance:
   schvaľuje nástroje a ich zmluvné podmienky, rieši incidenty, školí spolupracovníkov.
10. **Revízia.** Smernica sa reviduje najmenej raz ročne a vždy pri zmene podmienok
    používaného nástroja, pri zmene stavovských predpisov alebo po incidente.

## V. Disclaimer set k open-source nástroju LegalWork

Každý blok je samostatne citovateľný a určený na prevzatie do README, dokumentácie
alebo obrazovky nástroja.

> **1. Nástroj nie je právna služba.** LegalWork je softvérový nástroj. Nie je advokátskou
> kanceláriou, neposkytuje právne služby ani právne poradenstvo a nenahrádza posúdenie
> veci advokátom. Použitie nástroja nezakladá vzťah advokát a klient.

> **2. AI výstup je návrh.** Výstupy nástroja vrátane výstupov jazykových modelov sú
> pracovné návrhy, ktoré môžu obsahovať chyby, neúplnosti alebo nesprávne citácie.
> Každý výstup vyžaduje pred akýmkoľvek použitím odbornú kontrolu zodpovednou osobou,
> pri právnych výstupoch advokátom.

> **3. Bez záruk.** Prevádzkovateľ a prispievatelia projektu LAWOSS poskytujú nástroj
> v stave, v akom je („as is"), bez akýchkoľvek záruk, výslovných alebo implicitných,
> vrátane záruk správnosti, úplnosti, aktuálnosti výstupov a vhodnosti na konkrétny účel,
> v rozsahu prípustnom právnymi predpismi a v súlade s podmienkami open-source licencie.

> **4. Mlčanlivosť používateľa trvá.** Používateľ, ktorý je advokátom, zostáva pri
> používaní nástroja plne viazaný povinnosťou mlčanlivosti podľa § 23 zákona
> č. 586/2003 Z. z. o advokácii a predpismi o ochrane osobných údajov. Za voľbu režimu
> spracúvania klientskych dát, konfiguráciu nástroja a rozsah odoslaných dát zodpovedá
> výlučne používateľ.

## VI. Compliance pohľad na routing modelov

LegalWork používa hybridný routing: lokálny model pre operácie s klientskymi dátami,
cloudový model pre abstraktnú rešerš a anonymizačnú vrstvu pred posúdením prípadu
cloudovým modelom. Compliance mapa vrstiev:

| Vrstva | Typ dát | Prípustný režim | Poznámka |
|---|---|---|---|
| Lokálny model (on-device) | klientske dáta vrátane osobných údajov | lokálny | Dáta neopúšťajú zariadenie; režimy (a)/(b)/(c) sa nevyžadujú. Zabezpečiť treba samotné zariadenie (šifrovanie disku, prístupy). |
| Cloud, abstraktná rešerš | všeobecná právna otázka bez skutkových identifikátorov | ktorýkoľvek komerčný aj bez režimu | Otázka nesmie obsahovať klientske fakty umožňujúce identifikáciu; kombinácia detailov skutku môže identifikovať vec aj bez mena. |
| MCP konektory na právne zdroje | verejné dáta (predpisy, judikatúra) | bez obmedzenia | Pozor na obsah vyhľadávacích dopytov; dopyt s klientskymi faktami patrí do riadku vyššie, nie sem. |
| Cloud, posúdenie prípadu po anonymizácii | anonymizované klientske dáta | (b) alebo (c); pri reziduálnom riziku identifikácie doplniť (a) | Anonymizáciu pred odoslaním skontrolovať; zvyškové identifikátory (funkcie osôb, miesta, sumy, dátumy) vyhodnotiť osobitne. |
| Cloud, neanonymizované klientske dáta | osobné údaje a obsah spisu | (a) a súčasne (b) alebo (c) odporúčané kumulatívne | Len ak je anonymizácia pre úlohu nemožná alebo by znehodnotila výsledok; minimalizácia rozsahu, záznam v evidencii. |

K poslednému riadku: kumulatívne spojenie súhlasu klienta so zmluvnými zárukami
poskytovateľa je odporúčanie autora nad rámec minimálnych požiadaviek; či rozhodovací
test SAK pripúšťa samostatný režim bez ďalších opatrení aj pri neanonymizovaných dátach,
je potrebné overiť v texte uznesenia č. 12/4/2025 [OVERIŤ].

## VII. Záver

Tento materiál je vzdelávací podklad pre advokátov zvažujúcich nasadenie AI nástrojov,
nie právne poradenstvo pre konkrétny prípad ani výklad stavovských predpisov s autoritou
komory. Posúdenie, ktorý režim spracúvania je v konkrétnej veci prípustný a vhodný,
vykonáva každý advokát samostatne, s prihliadnutím na povahu veci, pokyny klienta,
aktuálne znenie zákona o advokácii, stavovských predpisov SAK a predpisov o ochrane
osobných údajov, ako aj na aktuálne zmluvné podmienky konkrétneho poskytovateľa AI
služby. Pri pochybnostiach je namieste zdržanlivosť: neposlať, anonymizovať, alebo si
vyžiadať súhlas klienta.

Pripomienky k tomuto draftu sú vítané v issue trackeri projektu LAWOSS.
