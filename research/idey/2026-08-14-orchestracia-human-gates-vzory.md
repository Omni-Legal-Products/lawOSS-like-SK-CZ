# Orchestrácia agentov a human gates v právnom workflow: overené vzory z praxe

Status: draft na diskusiu k spec 0006 (orchestrátor a subagenti, autor MF).
Zdroj: rok produkčnej prevádzky AI asistencie v advokátskej kancelárii (SK).
Ide o destilát procesných vzorov; neobsahuje právne know-how ani interné
detaily konkrétnej implementácie. Všetko nižšie je prenositeľné na ľubovoľný
harness so subagentmi.

## 1. Čo sa za rok prevádzky osvedčilo

### 1.1 Subagent na ťažké čítanie dlhých dokumentov (izolácia kontextu)

Dlhé dokumenty (rozsudky, zápisnice, znalecké posudky, podania protistrany)
nečíta hlavný agent, ale subagent vo vlastnom izolovanom kontexte. Vráti
štruktúrovaný faktový destilát s odkazmi na zdrojové miesta; do hlavného
kontextu tak ide pár tisíc tokenov namiesto stoviek tisíc, ktoré by sa inak
platili pri každom ďalšom volaní. Osvedčila sa aj deľba rolí: čítajúci
subagent extrahuje verbatim a uvádza zdroj, ale nehodnotí relevanciu;
hodnotenie patrí inej vrstve. Zmiešanie čítania a hodnotenia v jednom behu
zvádza k skratkám a citáciám z pamäte. Pri paralelnom čítaní viacerých
zdrojov delíme subagentov podľa roly a podľa právnej otázky, nikdy podľa
dátového zdroja: delenie po zdrojoch fragmentuje analýzu jednej otázky.

### 1.2 Adversariálna verifikácia nálezov v čistom kontexte

Draft výstupu posudzuje nezávislý agent v čistom kontexte, ktorý dostane len
text draftu a zadanie, nie úvahy autora. Autor (agent aj človek) je zaťažený
obhajobou vlastného textu; recenzent, ktorý reťaz úvah nevidel, hodnotí len
to, čo v texte reálne stojí. Recenzent draft neprepisuje: vracia zoznam
nálezov zoradený podľa závažnosti a rozhodnutie o zapracovaní ostáva
v hlavnom kontexte, pod dohľadom advokáta.

### 1.3 Rola-based adversariálni recenzenti ako vrstva pred human gate

Pred odovzdaním draftu advokátovi ho postupne testujú agenti v rolách:
protistrana (na každú námietku najsilnejší protiargument s odhadom sily),
sudca (prognóza per námietka: obstojí, neobstojí, hraničná, s dôvodom
v optike zákonných prieskumných dôvodov, nikdy percentá) a senior partner
(strategický pohľad voči cieľu klienta, ako posledný, s prístupom k nálezom
predchádzajúcich). Poradie je zámerné: obsahový útok, potom procesná
prognóza, potom stratégia. Advokát tak na human gate dostáva draft aj
predpripravenú mapu rizík, nie holý text.

### 1.4 Deterministické brány pred modelovými bránami

Lacné a reprodukovateľné kontroly bežia prv: validácia štruktúry, testy,
kontrola citačného ukotvenia (verbatim citát musí existovať v zdrojovom
korpuse, inak sa výstup zablokuje a citácia sa označí na overenie).
Modelová recenzia beží až nad tým, čo deterministickou bránou prešlo.
Opačné poradie plytvá drahými behmi na chyby, ktoré odhalí skript.

### 1.5 Audit trail per výstup

Každý výstup má strojovo čitateľný záznam: kto (človek alebo agent), čo,
kedy, z akých vstupov. AI provenance sa eviduje oddelene od autorstva
advokáta: každý AI výstup je draft, právnym autorom je advokát, ktorý ho
schválil, a záznam umožňuje toto oddelenie kedykoľvek preukázať. Audit
trail je zároveň najlacnejší re-entry bod: nová session z neho vyčíta
posledný stav práce bez čítania celej histórie.

### 1.6 Human gate vždy pred odoslaním čohokoľvek von

Nič nejde von bez explicitného potvrdenia advokáta: podanie na súd, mail
klientovi alebo protistrane, publikácia obsahu. Platí to bez ohľadu na to,
koľko automatických a adversariálnych brán výstup predtým prešiel; tie
human gate pripravujú, nie nahrádzajú. Autonómny režim je prípustný len nad
verejnými dátami a len pre úlohy so strojovo overiteľnou podmienkou
hotovosti; právna substancia doň nepatrí.

## 2. Čo sa neosvedčilo

### 2.1 Reťazová aktivácia (nástroj volá nástroj bez kontrolného bodu)

Ak plánovací alebo orchestrálny prvok rovno spúšťa ďalšie kroky, human gates
sa obchádzajú mlčky. Preto: plán je text, nie príkaz; plánovač nesmie
aktivovať naplánované kroky a každá aktivácia prechádza hlavným kontextom.

### 2.2 Globálne verdikty namiesto per-námietka prognóz

Verdikt typu „podanie ako celok uspeje" je nekalibrovateľný a advokátovi
nepomôže. Funguje prognóza per námietka s dôvodom; celkovú dôvodnosť
posudzuje výlučne advokát.

### 2.3 Spoliehanie na self-report agenta

Tvrdenie „hotovo" bez artefaktu nie je hotovo. Podmienka dokončenia kroku
musí byť kontrolovateľná zvonku: artefakt existuje na disku a je zapísaný
v priebežnom zázname behu. Bez toho subagenti občas reportujú dokončenie
práce, ktorá neprebehla alebo prebehla čiastočne.

### 2.4 Dlhé sessions bez reštartu z overeného bodu

Dlhé behy strácajú stav pri kompakcii kontextu a prerušení session. Riešenie,
ktoré sa osvedčilo: stav žije na disku, nie v konverzácii. Priebežný záznam
(ledger) sa dopĺňa po každom dokončenom kroku; medzi agentmi sa odovzdávajú
cesty k súborom a krátky sumár, nikdy plné texty. Nová session sa obnovuje
čítaním ledgera a hotové kroky nereštartuje.

## 3. Odporúčania pre spec 0006

| Vzor | Prínos | Cena |
|---|---|---|
| Subagent na ťažké čítanie | malý hlavný kontext, nižšie náklady na volanie | latencia, réžia zadania a schémy výstupu |
| Verifikácia v čistom kontexte | odhalí chyby, ktoré autor neuvidí | jeden beh modelu navyše na výstup |
| Rola-based recenzenti | mapa rizík pred human gate, per-námietka granularita | dva až tri behy navyše, disciplína rolí |
| Deterministické brány prv | lacné, reprodukovateľné, blokujú halucinácie citácií | údržba validačných skriptov |
| Audit trail per výstup | preukázateľné oddelenie AI a autorstva, lacný re-entry | disciplína zápisu pri každom úkone |
| Human gate pred odoslaním | zodpovednosť ostáva u advokáta | advokát je priepustnostný limit, s tým treba rátať |
| Ledger + file-handoff | behy prežijú kompakciu aj pád session | append-only réžia po každom kroku |

Tri návrhy priamo pre orchestrátor v spec 0006: (1) orchestrátor sám nerobí
obsahovú prácu, iba riadi tok, paralelizuje a zlučuje; (2) subagenti sa delia
podľa roly a podľa otázky, nie podľa dátového zdroja; (3) dokončenie fázy
definovať artefaktom na disku, nie odpoveďou subagenta. Radi doplníme
skúsenosti z prevádzky v diskusii pod spec.
