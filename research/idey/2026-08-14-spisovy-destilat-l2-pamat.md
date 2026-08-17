# Spisový destilát ako prvá vrstva pamäti: vzor pre tiered memory

Status: draft na diskusiu k trojvrstvovej pamäti L1/L2/L3 a OKF štruktúre
spisu. Zdroj: produkčná prevádzka AI asistencie v advokátskej kancelárii (SK),
vzor nasadený na desiatkach spisov. Neobsahuje právne know-how ani interné
detaily implementácie.

## 1. Problém

AI asistent sa do spisu vracia opakovane: replika, ďalšie vyjadrenie, nová
lehota, opravný prostriedok. Bez trvalej spisovej pamäti pri každom návrate
číta všetko odznova, čo má tri samostatné náklady:

- Drahé: veľký spis v kontexte sa neplatí raz, ale pri každom volaní modelu
  (opakované čítanie nahromadeného kontextu, cache read). Stovky tisíc
  tokenov v kontexte krát stovky volaní je dominantná položka spotreby.
- Pomalé: orientácia v spise pri každom re-entry trvá minúty až desiatky
  minút práce agenta, ktorá sa nikam neukladá.
- Nekonzistentné: každá session si poskladá mierne iný obraz veci; dva
  návraty do toho istého spisu nedávajú tú istú východiskovú pozíciu.

## 2. Vzor: trvalý destilát spisu

### 2.1 Artefakt

Jeden markdown súbor per spis, žijúci priamo v spise (v dôvernej zóne, mimo
verejného verziovania), s pevnou šablónou sekcií. Minimálny obsah:

- identifikácia veci a aktuálny stav konania,
- aktívne lehoty (typ, koniec, zdroj výpočtu),
- register dokumentov: každý dokument jedna veta anotácie plus odkaz na súbor,
- timeline posledných udalostí (doručenia, úkony, rozhodnutia),
- otvorené body a rozpracovaná práca.

Cieľová veľkosť je 4–8 tisíc tokenov. Destilát drží kontext malý bez straty
prehľadu o veci; nie je to zhrnutie pre človeka, je to vstupný bod pre agenta.

### 2.2 Re-entry pravidlo

Agent pri návrate do spisu číta destilát, nie spis. Plné znenia otvára len
cielene cez odkazy v registri, a len keď úloha vyžaduje verbatim (presná
formulácia výpovede, znenie výroku, citát do podania). Dve tvrdé zásady:

1. Destilát je mapa, nie prameň. Citácia do výstupu sa vždy overuje proti
   originálu dokumentu, nikdy proti destilátu; inak destilát halucinácie
   nebrzdí, ale amplifikuje.
2. Žiadne čítanie „celého spisu pre istotu". Aj jedna výnimka vráti presne
   tú spotrebu, ktorú vzor odstraňuje. Dôkladnosť je cielené dočítanie
   relevantného, nie všetko naraz v kontexte.

### 2.3 Aktualizačná disciplína

Destilát je živý dokument. Prepisuje sa pri troch udalostiach: pribudol
dokument (do registra ide jednovetová anotácia s odkazom, nikdy kópia
plného znenia), pribudla alebo sa zmenila lehota, konanie sa posunulo
(rozhodnutie, úkon, doručenie). História sa dopĺňa, neprepisuje: timeline
je append-only, mení sa len sekcia aktuálneho stavu. Session, ktorá na
spise pracovala, destilát pred ukončením aktualizuje; zastaraný destilát
je horší než žiadny, lebo mu agent verí.

### 2.4 Založenie destilátu: ťažké čítanie subagentom

Prvé založenie je jednorazová investícia, ktorá sa vráti pri druhom dotyku
s vecou. Aby založenie nezničilo kontext hlavného agenta:

- objemné plné znenia (rozsudok, zápisnice, žaloba, vyjadrenia, posudky)
  číta subagent v izolovanom kontexte a vráti faktový destilát s odkazmi,
- kratšie strategické súbory (poznámky, medzivýstupy) číta hlavný agent sám,
- destilát sa zloží podľa šablóny a založenie sa zapíše do audit logu veci.

Ak subagent zlyhá, destilát sa poskladá z dostupného a neoverená faktografia
sa explicitne označí ako neoverená, s odkazom na zdrojový súbor. V prostredí
advokácie navyše platí, že pred prvým čítaním klientskych dát sa určí režim
ich spracovania (lokálne, so súhlasom klienta, alebo cez spracovateľa s DPA
a no-training zárukou); orientácia v spise už je spracovanie dát.

## 3. Väzba na LAWOSS

### 3.1 Destilát ako L2 spisová vrstva

Vzor sadá na trojvrstvovú pamäť takto: L1 nesie nadspisové znalosti
(preferencie používateľa, štýl, procesné vzory kancelárie), L2 je navrhovaný
destilát (jeden na spis, obsah veci), L3 sú plné dokumenty v OKF štruktúre.
Tok medzi vrstvami je jednosmerný nadol pri čítaní (agent vstupuje cez L2,
do L3 siaha cielene cez odkazy) a nahor pri zápise (udalosť v L3 sa premietne
do L2 ako anotácia s odkazom, nikdy kopírovaním obsahu).

Register dokumentov v destiláte sa dá generovať deterministicky z OKF
štruktúry spisu (skript bez AI: inventár súborov, cesty, dátumy); AI dopĺňa
len anotácie a stavové sekcie. Odporúčame toto rozdelenie zakotviť v spec:
deterministické časti destilátu generuje nástroj, interpretačné časti agent,
a oboje je v súbore rozlíšiteľné.

### 3.2 Osvedčené doplnky do spec

- Prednosť generovanej projekcie: ak spis má aj ručne vedený destilát, aj
  destilát generovaný z udalostného záznamu, nech spec určí jednoznačnú
  prednosť; dva konkurenčné destiláty sú horšie než jeden neúplný.
- Kotviace súbory: agent má pri vstupe do spisu najprv lacno zistiť, čo
  existuje (destilát, audit log, inventár, plán práce), bez čítania obsahu,
  a až potom čítať.
- Racionalizačná tabuľka do spec: zoznam typických výhovoriek („malý spis,
  prečítam celý", „potrebujem vidieť všetko") s odpoveďou; v praxi je to
  najúčinnejšia časť pravidla, lebo porušenia prichádzajú práve tadiaľto.

### 3.3 Otvorené otázky

1. Kto destilát schvaľuje? Náš stav: destilát je pracovný artefakt bez
   formálneho schválenia a kompenzuje to pravidlo overovania citácií proti
   originálu. Alternatíva: advokát schvaľuje aspoň sekciu stavu a lehôt.
   Pre LAWOSS treba rozhodnúť, či je L2 autoritatívna alebo len cache.
2. Konflikt pri viacerých používateľoch: dve súčasné sessions nad jedným
   spisom môžu destilát prepísať navzájom. Možnosti: single-writer zámok,
   merge cez append-only timeline, alebo destilát ako čistá projekcia
   udalostného záznamu (konflikt rieši záznam, nie projekcia).
3. Validácia schémy: má spec vyžadovať strojovú kontrolu, že destilát
   pokrýva povinné sekcie? Náš postoj: áno, je to lacná deterministická
   brána pred tým, než destilátu začnú agenti veriť.
