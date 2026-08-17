# Metodika kvality skillov: ako písať skilly, ktoré sa spoľahlivo aktivujú

Stav: draft na pripomienkovanie (LAWOSS).

Skill je zbalený súbor inštrukcií, ktorý agent načíta do kontextu až pri
aktivácii: pri štarte session sa číta len názov a popis (description), telo
až po aktivácii a referencie až pri reálnom otvorení. Dĺžka tela je preto
lacná; o tom, či sa skill vôbec spustí, rozhoduje kvalita popisu.

## 1. Prečo skill existuje: predikovateľnosť procesu

Skill existuje na to, aby zo stochastického systému vydoloval determinizmus.
Meria sa predikovateľnosť PROCESU, nie výstupu: rešeršný skill má
predikovateľne divergovať (tokeny sa líšia, správanie nie), draftovací skill
má predikovateľne prejsť rovnakými krokmi v rovnakom poradí. Cena behu
a udržiavateľnosť sú symptómy predikovateľnosti, nie konkurenčné ciele;
každú vetu posudzuj otázkou, či robí správanie predvídateľnejším.

## 2. Katalóg zlyhaní: pomenuj, potom lieč

| Zlyhanie | Test | Liek |
|---|---|---|
| Premature completion: krok sa ukončí skôr, než je reálne hotový | je completion criterion kroku vágne ("dosiahnuté porozumenie")? | zostri kritérium na overiteľné ("každá citácia má zdrojový tag"); ak je neredukovateľne fuzzy a rush reálne pozoruješ, skry nasledujúce kroky za kontextovú hranicu (subagent, handoff) |
| Negácia: riadenie zákazom vťahuje zakázané správanie do kontextu | začína riadiaca veta "nikdy", "nesmie", "nepíš"? | formuluj pozitívny cieľ; zákaz ponechaj len ako tvrdý guardrail a vždy v páre s pozitívnym cieľom |
| No-op: inštrukcia, ktorú model robí aj bez nej | zmení riadok správanie oproti defaultu modelu? (spor sa rieši testovacím behom, nie debatou) | zmaž celú vetu, neorezávaj slová; slabé kľúčové slovo posilni, neobaľuj ho ďalším textom |
| Duplikácia: jeden význam žije na dvoch miestach | vyžaduje zmena významu úpravu na N miestach? | single source of truth: jeden domov, ostatné miesta naň odkazujú (odkaz alebo vyvolanie iného skillu, nie kópia) |
| Sediment: vrstvy starého obsahu, ktoré nikto nečistí | koľko riadkov už nenesie aktuálne správanie? | pruning pri každom zvýšení verzie: každý riadok obhajuje relevanciu |
| Sprawl: skill je pridlhý, hoci je všetko živé a unikátne | musí agent prebrodiť veľa textu, kým môže konať? | progressive disclosure: hĺbku presuň do referencií, telo rozdeľ podľa vetiev alebo sekvencie |

Nástroje pozitívneho tvaru, ktoré liečbu podporujú:

- Overiteľné completion criteria: každý krok končí podmienkou, pri ktorej
  agent vie rozlíšiť hotové od nehotového.
- Checkable signals namiesto vágnych varovaní: nie "pozor na povrchné
  review", ale "2 a viac cyklov review bez jediného nálezu znamená, že
  validuješ, nepochybuješ".
- Kanonické príklady namiesto vyčerpávajúcich zoznamov: pár dobrých
  príkladov model generalizuje, zoznam okrajových prípadov len brodí.
  Zoznam si nechaj tam, kde je enumerácia sama obsahom (tabuľka predpisov).
- Ustálené odborné pojmy (steelman, red team, ratio decidendi) kotvia
  exekúciu aj aktiváciu lepšie než vymyslené slová, ktoré nenesú žiadny
  význam z pretréningu.

## 3. Description ako routing signál

Description hovorí, ČO skill robí a KEDY ho aktivovať. Nikdy nesumarizuje
postup: ak popis obsahuje zhrnutie krokov, agent nasleduje zhrnutie a telo
skillu vôbec neprečíta (dvojstupňový proces sa v praxi zredukuje na
jednostupňový, lebo popis spomenul len jeden krok).

Dobrý popis obsahuje obe polarity:

- Aktivačné situácie: typické formulácie požiadaviek, pri ktorých sa skill
  má spustiť, v rôznych štýloch (skratka, dlhá veta, opisná situácia).
- Výluky "NEAKTIVUJ pri": blízke situácie, ktoré patria inému skillu, ideálne
  s presmerovaním na jeho názov. Výluka nie je balast; pre routing je to
  plnohodnotný pozitívny signál, ktorý ostrí hranicu medzi susednými skillmi.

Prečo dlhý všeobjímajúci popis škodí:

- Prostredia popis orezávajú (bežné limity sú rádovo 1000 až 1500 znakov);
  trigger frázy za hranicou sa do routingu nikdy nedostanú.
- Pri podobnostnom routingu dlhý text riedi signál: čím viac generických
  slov, tým menej popis vyčnieva presne pri tých požiadavkách, pre ktoré
  skill existuje.
- Správna metóda pri pretečení: exhaustívny zoznam triggerov presuň do tela
  skillu (sekcia "Aktivačné spektrum"); telo nemá limit a načíta sa po
  aktivácii, takže sa obsah nestráca.

## 4. Testy aktivácie

Pred zaradením skillu do produkčného používania má existovať minimálny test
harness:

- triggers: minimálne 3 vety, ktoré skill MAJÚ aktivovať, každá v inom
  formulačnom štýle (skratky, dlhé vety, otázka, opis situácie bez pokynu).
- no-triggers: minimálne 3 vety BLÍZKE triggerom, ktoré aktivovať NESMÚ;
  testujú falošnú pozitivitu a hranicu voči susedným skillom.
- case: minimálne 1 prípad vstup a výstup so štruktúrou:

  ```text
  ## Vstup
  (kontext + úloha)

  ## Očakávaný výstup
  (čo má skill vyprodukovať alebo aké rozhodnutie urobiť)

  ## Akceptačné kritériá
  - bullet kritériá, čo musí výstup obsahovať
  ```

Dve doplnkové pravidlá z praxe:

- Prove-It pri oprave: pri oprave chybného správania najprv napíš padajúci
  case, ktorý zlé správanie reprodukuje, až potom uprav skill. Case zostáva
  v harnesse ako regresný test.
- Kolísavý test je nález, nie odpad: testy bežia v čerstvom kontexte, teda
  nedeterministicky; jedna vzorka klame. Spúšťaj 3 razy a nezhodné verdikty
  zatrieď: kolíše skill (pravidlo neviaže, zostri formuláciu), scenár
  (zadanie pripúšťa viac čítaní, zostri zadanie) alebo hodnotiace kritérium
  (vágne kritérium prepíš na checkable signal). Výsledok 2/3 sa eviduje tak,
  ako dopadol; produkčný status vyžaduje 3/3.

## 5. Disciplínové skilly: Iron Law, tabuľka výhovoriek, red flags

Skill, ktorý vynucuje pravidlo (citačná disciplína, overovanie pred
tvrdením, brána pred publikáciou), potrebuje inú formu než skill, ktorý vedie
postup. Osvedčená trojica:

1. Iron Law: jedno neporušiteľné pravidlo v samostatnom bloku, bez výnimiek,
   s explicitným uzavretím obchádzok a vetou "porušenie litery pravidla je
   porušením ducha pravidla". Neutrálny príklad:

   > IRON LAW: Necituj súdne rozhodnutie, ktorého existenciu si neoveril
   > v autoritatívnom zdroji. Žiadne výnimky: nie pre "notoricky známe
   > rozhodnutia", nie pre "len pracovný draft", nie pre "advokát to aj tak
   > skontroluje". Porušenie litery pravidla je porušením ducha pravidla.

2. Racionalizačná tabuľka výhovorka/realita: doslovné výhovorky zachytené
   z baseline behov bez skillu (nie hypotetické), každá s vecným
   protiargumentom. Neutrálny príklad:

   | Výhovorka | Realita |
   |---|---|
   | "Spisovú značku si pamätám presne, overovanie je formalita." | Pamäť modelu produkuje presvedčivé, ale neexistujúce značky; overenie trvá sekundy, kompromitované podanie roky. |
   | "Je to len interný draft, doladí sa pri finalizácii." | Neoverená citácia v drafte sa pri finalizácii už javí ako overená; brána funguje len na vstupe. |

3. Red flags: pozorovateľné signály, že k porušeniu práve dochádza, každý ako
   checkable signal ("píšeš spisovú značku a v kontexte nie je otvorený
   žiadny zdroj"), zakončené jednou vetou, čo urobiť ("všetky znamenajú:
   STOP, vráť sa ku kroku overenia").

Formu prispôsob typu zlyhania: prohibícia s tabuľkou lieči porušovanie
pravidla pod tlakom; zlý tvar výstupu lieči pozitívny recept (čo výstup JE,
z akých častí, v akom poradí); vynechávanie povinného prvku lieči povinný
slot v šablóne, nie prozaická pripomienka. Zmäkčujúce klauzuly ("iba ak na
tom záleží") znovu otvárajú vyjednávanie; reálnu výnimku vyjadri ako
samostatnú podmienku na pozorovateľnom predikáte.

Disciplínové skilly navyše testuj pod tlakom: scenár kombinuje minimálne dva
tlaky (časový tlak, sunk cost, autorita, únava dlhej session) a pokúša agenta
pravidlo obísť. Zachyť baseline správanie bez skillu vrátane doslovných
racionalizácií, potom uprav skill tak, aby porazil práve tie; nová
racionalizácia v ďalšom behu znamená nový explicitný protiargument.

## 6. Checklist pred zaradením skillu

- [ ] Description popisuje ČO a KEDY, neobsahuje kroky postupu.
- [ ] Description obsahuje aktivačné situácie aj výluky "NEAKTIVUJ pri"
      s presmerovaním; zmestí sa do limitu prostredia.
- [ ] Existujú minimálne 3 triggers, 3 no-triggers a 1 case so vstupom,
      očakávaným výstupom a akceptačnými kritériami; všetky prechádzajú.
- [ ] Každý krok tela má overiteľné completion criterion.
- [ ] Každý riadok prešiel no-op testom: mení správanie oproti defaultu.
- [ ] Žiadny význam nežije na dvoch miestach; hĺbka je v referenciách,
      referencie sú jednu úroveň hlboko a dlhšie majú obsah na začiatku.
- [ ] Disciplínový skill má Iron Law, racionalizačnú tabuľku z reálnych
      baseline behov, red flags a pressure testy so stabilným výsledkom 3/3.
- [ ] Verzia a zmena sú zaznamenané; pri oprave správania existuje regresný
      case, ktorý pred opravou padal.
