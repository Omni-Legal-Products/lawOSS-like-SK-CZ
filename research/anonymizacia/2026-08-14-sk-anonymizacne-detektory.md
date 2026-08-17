# SK anonymizačné detektory: vzory a prevádzkové lekcie

Stav: draft na pripomienkovanie (LAWOSS).

Referenčná architektúra: štruktúrované slovenské identifikátory (číselné
štruktúry) chytá deterministický regex s vysokým skóre; otvorené triedy
(mená, organizácie, adresy v texte) chytá lokálny NER model a regex ich
dopĺňa kontextovo kotvenými vzormi. Nálezy sa nahrádzajú čitateľnými
placeholdermi typu OSOBA_1, SPIS_1; reverzibilná mapa ostáva šifrovaná
lokálne a nikdy sa nepublikuje. Čo v kóde nie je, je označené [NÁVRH].

## 1. Katalóg detektorov

**Rodné číslo** (skóre 0.9)
- Vzor: `\b\d{6}/\d{3,4}\b`; kontextové slová: rodné číslo, rč, narodený.
- Validácia: lomka robí vzor vysoko presným, preto referenčná implementácia
  ďalšiu validáciu nerobí. [NÁVRH] druhý stupeň: pri 10-miestnom RČ over
  deliteľnosť celého čísla jedenástimi a platnosť dátumovej časti (mesiac
  1 až 12, u žien +50); zdvihne presnosť pri RČ písanom bez lomky.

**IBAN SK** (skóre 0.95)
- Vzor: `\bSK\d{2}(?:\s?\d{4}){5}\b` (prefix SK, 2 kontrolné číslice,
  20 cifier, tolerované medzery po štvoriciach); kontext: IBAN, účet, banka.
- Validácia: [NÁVRH] kontrolný súčet ISO 7064 mod 97 (presuň prvé 4 znaky na
  koniec, písmená prepíš na čísla, zvyšok po delení 97 musí byť 1); vzor sám
  ho nepočíta.

**Spisové značky súdov** (3 vzory)
- Všeobecné súdy (0.85): `\b\d+\s?[A-ZČŠŽ][<sk-písmená>]*\s?/?\s?\d+/\d{4}\b`,
  kde `<sk-písmená>` je trieda slovenských písmen s diakritikou; pokrýva
  tvary ako 13Cb/45/2024 alebo 6Sžfk/12/2024.
- Prokuratúra (0.9): `\b\d+\s?[KGP]v\s+\d+/\d{2,4}(?:/\d+)?(?:-\d+)?\b`
  (registre Pv, Kv, Gv, s voliteľným kódom útvaru a stranou).
- Ústavný súd (0.9): senát rímskou číslicou alebo plénum "PL.", potom "ÚS"
  a číslo/rok; senát aj skratka sú vynútene case-sensitive, aby text "us
  12/2024" nedával falošnú pozitivitu. Prevádzková lekcia: prvé verzie mali
  len vzory začínajúce arabskou číslicou, takže celá ústavnosúdna trieda
  formátov unikala; kalibruj katalóg vzorov proti zoznamu reálnych formátov
  všetkých súdnych sústav, nie proti jednému typickému tvaru.
- Doplnok: číslo vyšetrovacieho spisu polície (0.9):
  `\b(?:ORP|KRP|PPZ)-\d+/[A-Za-z0-9-]*\d{4}\b`.

**IČO / DIČ / IČ DPH**
- IČ DPH (0.95): `\bSK\d{10}\b`; špecifický prefix, vyhodnocuj pred IČO
  a DIČ.
- DIČ (0.4): `\b\d{10}\b`; IČO (0.4): `\b\d{8}\b` plus variant s medzerami
  `\b\d{2}\s\d{3}\s\d{3}\b` (0.5), lebo podania IČO bežne členia.
- Holé 8 a 10-ciferné čísla sú náchylné na falošné pozitíva (telefón,
  sumy), preto majú nízke základné skóre a istotu dvíhajú až kontextové
  slová (IČO, DIČ, s.r.o., platiteľ dane). [NÁVRH] kontrolná číslica IČO
  (vážený súčet mod 11) ako deterministický druhý stupeň.

**Telefónne čísla**
- V referenčnej implementácii ich pokrýva NER vrstva (label telefónne
  číslo), nie regex. [NÁVRH] deterministický vzor pre SK formáty:
  `(?:\+421|00421|0)\s?\d{2,3}[\s/]?\d{3}\s?\d{3}\b` s kontextom tel.,
  mobil, kontakt; NER ponechaj pre netypické zápisy.

**Tituly pred a za menom ako kontext mien**
- Titul nie je samostatná entita, ale kontext, ktorý dvíha istotu, že
  nasledujúce slová sú meno: `(?:Ing\.|JUDr\.|MUDr\.|Mgr\.|PhDr\.|Bc\.|doc\.|prof\.)`
  pred vzorom Krstné Priezvisko (obe s veľkým začiatočným písmenom,
  priezvisko aj zložené so spojovníkom).
- Rolová kotva: meno chytené aj cez procesnú rolu pred ním (svedok,
  svedkyňa, znalec, poškodený, obvinený, obžalovaný, navrhovateľ, odporca,
  vypovedal, zastúpený) v zero-width lookbehinde, skóre 0.65; dopĺňa NER,
  nenahrádza ho, lebo mená sú otvorená trieda.
- [NÁVRH] tituly za menom (PhD., CSc., MBA, LL.M.) ako pravostranný kontext;
  referenčná implementácia ich zatiaľ nepoužíva.

**Adresy** (2 vzory)
- Plná ulicová adresa (0.85): ulica (vynútené veľké začiatočné písmeno,
  aj tvar "29. augusta") + číslo domu `\d{1,4}(?:/\d{1,3})?[A-Za-z]?` +
  PSČ `\d{3}\s?\d{2}` + obec. PSČ je silná kotva, bez neho vzor nematchuje.
- Adresa bez PSČ (0.6): kotvená kontextovým slovom v zero-width lookbehinde
  (bytom, trvale bytom, trvalý pobyt, adresa, sídlo, na ulici, bydlisko),
  potom ulica + číslo a voliteľná obec. Pri prekryve s plnou adresou vyhrá
  vyššie skórujúci plný span.

**Ďalšie identifikátory v referenčnej implementácii**: číslo občianskeho
preukazu `\b[A-Z]{2}\d{6}\b` (0.85), vložka obchodného registra
`(?i)vložka\s+(?:č\.|číslo)\s*\d{1,6}\s*/\s*[A-Z]\b` (0.85) a VIN
(17 znakov bez I, O, Q, s vynútenou číslicou aj písmenom cez lookaheady,
0.85).

## 2. Prevádzkové lekcie

- Regex stačí na uzavreté číselné štruktúry (RČ, IBAN, spisové značky,
  IČO); na otvorené triedy (mená vrátane skloňovaných tvarov, organizácie)
  treba NER model. Rolovo kotvený regex je doplnok NER pre prípady, keď
  model meno pri procesnom uvedení minie.
- Poradie detekcie: štruktúrované identifikátory pred menami. Prakticky sa
  vynucuje skóre (štruktúrovaný vzor 0.85 až 0.95 vyhrá prekryv nad NER
  nálezom) a špecifickosťou: vzor so špecifickým prefixom (IČ DPH so "SK")
  sa vyhodnocuje pred generickým počtom cifier (DIČ, IČO).
- Fail-closed: pri chybe radšej odmietnuť než prepustiť. Obnova originálov
  hlási každý placeholder, ktorý sa nepodarí zreštaurovať, nikdy nezlyhá
  ticho; sken bez OCR podpory vyhodí chybu s návodom namiesto tichého
  preskočenia strán; nerozpoznaný typ dokumentu dostane odporúčanie na
  manuálnu kontrolu, nie automatický priechod.
- Ak engine púšťa vzory case-insensitive, triedy `[A-Z]` matchujú aj malé
  písmená a vzor sa "rozlezie" do kontextového slova; veľké začiatočné
  písmeno vynucuj scoped skupinou `(?-i:...)`.
- Kontextové kotvy drž ako zero-width lookbehind, aby sa kotviace slovo
  (bytom, svedok) neanonymizovalo spolu s nálezom; pri engine s fixnou
  šírkou lookbehindu píš každú kotvu ako samostatnú alternatívu.
- NER modely majú obmedzené okno; dlhý dokument bez chunkovania model ticho
  oreže (telo viacstranového podania sa vôbec neanalyzuje). Deľ text na
  prekrývajúce sa okná po hraniciach slov a nálezy z prekryvu dedupuj.
- Propagačná druhá vlna: NER je per-výskyt pravdepodobnostný, tú istú firmu
  v hlavičke chytí a v petite minie. Čo už raz je v mape, nahraď
  deterministicky vo všetkých doslovných výskytoch; dlhšie originály najprv,
  originály kratšie než 3 znaky preskoč (kolízie iniciál a čísel).
- Falošné pozitíva rieš vrstvene: nízke základné skóre + kontextové slová
  (IČO, DIČ), stoplist generických procesných rolí (žalobca, súd, advokát)
  filtrovaný len pre jednoslovné nálezy, a allowlist verejných citácií
  judikatúry ako vedomé rozhodnutie advokáta, nie automatika.
- Akumuluj mapu per vec: druhý dokument tej istej veci sa naseeduje
  existujúcou mapou, takže tá istá osoba dostane ten istý placeholder
  a nedôjde k tichej krížovej zámene identít medzi dokumentmi.

## 3. Integrácia do privacy gate (spec 0008)

Detektory zapoj do stavového modelu kandidát → overené → potvrdené
advokátom → publikované:

- kandidát: každý nález detektora vstupuje ako kandidát so skóre, typom
  a identifikáciou detektora, ktorý ho vyprodukoval.
- overené: deterministická validácia povyšuje kandidáta (kontrolný súčet
  mod 97 pri IBAN, deliteľnosť 11 pri RČ, kontextové slová pri IČO a DIČ);
  kandidát, ktorý validáciou neprejde, ostáva v zozname na ľudské
  posúdenie, nezahadzuje sa.
- potvrdené advokátom: človek prechádza úplný zoznam kandidátov vrátane
  nízkoskórových; fail-closed znamená, že dokument nesmie postúpiť, kým
  existuje jediný nerozhodnutý kandidát.
- publikované: až po potvrdení; publikuje sa výhradne anonymizovaný text,
  mapa placeholderov ostáva lokálna a šifrovaná.

Každý prechod stavu loguj (kto, kedy, ktorý detektor); audit trail je
súčasť brány, nie voliteľný doplnok.
