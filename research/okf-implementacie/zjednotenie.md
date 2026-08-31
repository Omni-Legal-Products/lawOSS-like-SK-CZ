# Zjednotenie OKF pamäte — MČ × VŘ

- **Účel:** z dvoch reálne prevádzkovaných implementácií spraviť jeden kontrakt, ktorý je základom appky aj prenositeľného systému mimo nej.
- **Podklad:** [`mc-novy-spis/`](mc-novy-spis/) (OKF v0.1, MČ) · [`vr-pamat/`](vr-pamat/) (VŘ) · [spec 0002](../../specs/0002-okf-operacny-system-praxe.md) · [rešerš pamäťových vzorov 21. 8.](../inspiracie/2026-08-21-granular-brain-a-pamatove-vzory.md) · [spisový destilát L2](../idey/2026-08-14-spisovy-destilat-l2-pamat.md)
- **Rozhodnuté na** [calle 28. 8.](../../meetings/2026-08-28-zapis-sync-call.md), bod 5 a akčné body.
- **Stav:** návrh na odklepnutie na calle 1. 9. Implementácia zjednotenej pamäťovej časti beží v [PR #24 vo forku](https://github.com/Omni-Legal-Products/lawoss/pull/24).

> [!NOTE]
> Nemení sa ani jedna z pôvodných implementácií — `mc-novy-spis/` aj `vr-pamat/` zostávajú referenčnými snímkami. Tento dokument je návrh spoločného kontraktu.

## Prečo nestačí vybrať jednu

Nie je to voľba medzi dvomi riešeniami toho istého. Každá implementácia rieši, čo tá druhá nemá:

| | MČ `novy-spis` | VŘ `vr-pamat` |
|---|---|---|
| **silné** | štruktúra spisu, disciplína zápisu, validácia, retrofit | typovanie, vybavovanie cez `description`, väzby, oddelené poučenia |
| **medzera** | pamäť je netypovaná (voľné sekcie TP/LL/OQ) | žiadna štruktúra spisu; pamäť leží mimo spisu, v konfigu agenta |

Obe medzery sú doložené prevádzkou. U VŘ **31 % z 289 záznamov nemá typ**, hoci typ bol od začiatku odporúčaný — konvencia bez vynútenia nedrží. U MČ je pravda o veci na dvoch miestach (`_STATUS.md` a `MEMORY.md`), preto musel vzniknúť `okf-freshness.sh` ako liečba driftu.

## Porovnanie po vrstvách

### 1. Štruktúra priečinkov

| | MČ | VŘ | Zjednotené |
|---|---|---|---|
| profily | A klient→spis, B projekt, C firma | — (nemá) | **preberáme MČ bez zmeny** |
| kde leží pamäť | v spise (`MEMORY.md`) | mimo spisu (`~/.claude/…/memory/`) | **v spise**, podpriečinok `pamet/` (SK `pamat/`) |
| číslovanie a nomenklatúra | oblasti 1–6, `YYYY-MM Protistrana - Vec - typ` | prefixy `case_`, `feedback_`, … | **MČ pre priečinky, typ zo schémy pre záznamy** |

**Dôvod:** pamäť mimo spisu advokát neotvorí a iný harness ju nenájde. Prenositeľnosť (Q10) vyžaduje, aby všetko o veci ležalo pri veci.

### 2. Riadiace súbory a schémy

| Súbor | MČ | VŘ | Zjednotené |
|---|---|---|---|
| karta veci | `spis.md` / `klient.md` / `projekt.md` | — | **MČ bez zmeny** |
| stav veci | `_STATUS.md` (SSOT, 7 sekcií, ručne) | — | **`_STATUS.md` zostáva, tabuľky sa renderujú** ⚠ viď otvorený bod O1 |
| pamäť | `MEMORY.md` (TP / LL / OQ) | `case_*.md`, `feedback_*.md`, … | **`pamet/<ID>-<slug>.md`, jeden typovaný záznam = jeden súbor** |
| index | — | `MEMORY.md` (ručný, delený na `cases-1..3`) | **`pamet/INDEX.md`, generovaný** |
| vstup pre agenta | `AGENTS.md` + `CLAUDE.md` | konfig agenta | **`AGENTS.md`/`CLAUDE.md` (MČ) + `BRAIN.md` ako protokol pamäte** |

`BRAIN.md` je front-door vzor z [rešerše 21. 8.](../inspiracie/2026-08-21-granular-brain-a-pamatove-vzory.md): krátky súbor, ktorý povie, čo čítať a v akom poradí, a od ktorého je všetko na jeden-dva skoky.

### 3. Schéma záznamu

Zjednotený tvar spája typovanie VŘ s truth/timeline modelom z rešerše:

```markdown
---
okf: 1
id: R-001
typ: rozhodnuti          # SK: rozhodnutie
nazev: Nenapadat mistni prislusnost      # SK: nazov
popis: Zdrzeni prevazuje nad vyhodou zmeny soudu
vrstva: L2
jurisdikce: cz           # SK: jurisdikcia
stav: platny
vznik: 2026-08-29
zmena: 2026-08-29
lhuty: ["2026-09-12"]    # SK: lehoty
---

## Pravda
Aktuálny overený stav. Prepisuje sa.

## Historie                # SK: História
- 2026-08-29 — rozhodnuté po porade s klientom
```

`popis` je nosič vybavovania — preberáme funkciu `description` od VŘ. Rozdelenie `Pravda` × `Historie` je odpoveď na medzeru, ktorú majú **obe** implementácie: dnes ani jedna nevie povedať, prečo sa tvrdenie zmenilo.

### 4. Typy a vrstvy

| Kanonický typ | CZ / SK | Vrstva | MČ ekvivalent | VŘ ekvivalent |
|---|---|---|---|---|
| `matter` | `spis` | L2 | `_STATUS.md` | `type: project` |
| `decision` | `rozhodnuti` / `rozhodnutie` | L2 | `TP-XXX` | — |
| `subject` | `subjekt` | L2 | tabuľka Strany | — |
| `question` | `otazka` | L2 | `OQ-XXX` | — |
| `subject` (AML) | `subjekt` | L2 | tabuľka Strany | — |
| `screening` | `provereni` / `preverenie` | L2 | — | — |
| `rule` | `pravidlo` | **L1** | — | `type: user` |
| `lesson` | `pouceni` / `poucenie` | **L1** | `LL-XXX` | `type: feedback` |
| `authority` | `pramen` | **L3** | `# Citations` | `type: reference` |

`lesson` je samostatný typ, nie podtyp poznámky — [návrh #37](../../specs/navrhy.md). Poučenie z chyby sa maže inak než obsah spisu.

Vrstva sa **neurčuje ručne, vyplýva z typu**. Nedá sa omylom založiť právny prameň ako spisový záznam.

### 5. Protokol zápisu

MČ protokol (čo kam patrí) preberáme celý a dopĺňame o štyri brány, ktoré sú **v nástroji, nie v prompte** — princíp z [odpovedí VŘ, Q21](../../planning/2026-08-15-odpovedi-VR-Q01-Q25.md):

| Brána | Čo vynucuje | Odkiaľ požiadavka |
|---|---|---|
| **atomicita pravdy** | zmena `## Pravda` musí v tom istom zápise pridať riadok do `## Historie` | rešerš 21. 8., mindmux vzor |
| **append-only história** | stará história musí byť doslovnou predponou novej | spec 0002 — „periodická konsolidácia bez straty histórie" |
| **human gate** | do L1, do L3 a pri mazaní zapíše iba človek; agent dostane diff | spec 0002, Q11, Q21 |
| **zákaz úniku L2 → L3** | právny prameň nesmie niesť IČO, dátum narodenia ani obchodné meno zo subjektov spisu; triedi sa podľa **sily zhody** (viď nižšie) | spec 0002 — „L3 nesmie obsahovať klientsky identifikujúce údaje" |

Zápis do L2 agent vykoná sám (to je „udržiavať poriadok v spise" z Q21). Zápis do L1 a L3 iba navrhne.

**Sila zhody pri kontrole úniku.** Falošný poplach a únik nemajú rovnakú cenu — únik je porušenie mlčanlivosti, falošný poplach iba zdržuje. Kontrola preto triedi:

| Sila | Čo to je | Nález |
|---|---|---|
| `hard` | IČO (aj písané po trojiciach), dátum narodenia (ISO aj český zápis s bodkami) | **chyba** — blokuje |
| `strong` | celé meno alebo obchodná firma, aj bez právnej formy | **chyba** — blokuje |
| `weak` | samotné krátke priezvisko | varovanie na revíziu, neblokuje |

Zhoda sa hľadá na hranici slova a po normalizácii diakritiky, takže „Rada" nechytí „porada" a „Modry Kamen" chytí „Modrý Kámen". Prahy sú pomenované konštanty — **je to rozhodnutie o hranici zodpovednosti, nie technický detail**, a je otvorené na pripomienky.

### 6. Workflow

| Krok | MČ | Zjednotené |
|---|---|---|
| založenie veci | `new-klient.sh`, `new-spis.sh`, `new-projekt.sh` | **bez zmeny — zostáva MČ** |
| retrofit | `retrofit.sh` (nedeštruktívny, idempotentný) | **bez zmeny**; pamäť sa dopĺňa `okf-memory init` |
| validácia štruktúry | `okf-validate.sh` | **bez zmeny** |
| validácia pamäte | — | `okf-memory validate` (schéma, únik L2→L3, odkazy, duplicity) |
| drift `_STATUS.md` | `okf-freshness.sh` | **v generovaných sekciách zaniká** ⚠ viď O1 |
| projekcia | — | `okf-memory sync` |

### 7. Dvojjurisdikčnosť

Rozdiel CZ/SK žije v **jednej mapovacej tabuľke**, nie v dvoch kópiách kódu. Nové pole sa pridáva raz. Testy iterujú cez obe lokalizácie z tej istej tabuľky, takže zabudnutá varianta spadne v CI.

Kľúče a hodnoty enumov sú technické identifikátory → bez diakritiky. Ľudské texty diakritiku nesú. Markery v `_STATUS.md` sú **kanonické** (`deadlines`, `timeline`, `records`), takže spis pri zmene jazyka o projekciu nepríde.

Právne pojmy sa neprekladajú ticho — `lhuty` a `lehoty` sú dve polia jednej schémy, nie preklad jedného.

### 8. AML evidencia

Pribudlo na žiadosť VŘ 31. 8. Ani jedna pôvodná implementácia AML nepokrývala, hoci [spec 0002](../../specs/0002-okf-operacny-system-praxe.md) má celú sekciu „Onboarding subjektov a AML research" vrátane režimov `light` / `medium` / `hard` a periodického rescanu.

Dve veci, ktoré sa nesmú zliať do jednej:

| | `subject` | `screening` |
|---|---|---|
| čo to je | **kto to je** — identifikácia podľa § 8 | **čo som k dátumu zistil** — úkon v čase |
| obsah | rodné číslo, miesto narodenia, pohlavie, občianstvo, pobyt, doklad; pri PO právna forma, sídlo, zápis, konajúce osoby, skutočný majiteľ | dátum, režim, prehľadané registre, PEP, sankcie, pôvod prostriedkov, riziko, záver, platnosť |
| početnosť | jeden na osobu | **jeden na každé preverenie** — § 9 vyžaduje priebežnú kontrolu, § 16 archiváciu 10 rokov |

**Kde to leží — tým sa uzatvára bod O3.** Identifikácia sa robí raz pri vzniku obchodného vzťahu, nie pri každej kauze, a archivuje sa 10 rokov od skončenia **vzťahu**, nie kauzy. `subject` a `screening` preto žijú v zložke **klienta**; spis na ne odkazuje `[[S-001]]`. Zložka klienta sa hľadá podľa `klient.md` až štyri úrovne nad spisom, takže MČ profil A (klient → oblasť → spis) sedí bez úpravy.

**Citlivé polia.** Rodné číslo, číslo dokladu, trvalý pobyt a dátum narodenia sú v tabuľke označené `sensitive`, čo má dva automatické dôsledky: maskujú sa vo výstupoch pre človeka (`750101/••••`) a **stávajú sa jehlami detektora úniku do L3**. Pridať citlivý údaj a zabudnúť rozšíriť bránu preto nejde — to bola najväčšia hrozba tejto zmeny. Maskovanie nie je bezpečnostné opatrenie; kto má prístup k adresáru, má prístup k údajom.

**Jadro preverenie nevykonáva** — nesie jeho výsledok a stráži lehotu. Volanie registrov, PEP a sankcií patrí skillom a MCP konektorom.

> [!IMPORTANT]
> **Slovenská povinná sada nie je implementovaná — čaká na MČ.** CZ vychádza z § 8 zák. č. 253/2008 Sb. a je overená proti reálne používanému identifikačnému formuláru. Slovenský predpis je zák. č. 297/2008 Z. z.; jeho požiadavky VŘ neoveril a predstierať ich by bolo tiché prekladanie právnych pojmov medzi jurisdikciami. `AML_REQUIRED.sk` preto zámerne chýba a validátor hlási `AML_RULESET_UNVERIFIED` namiesto toho, aby vynucoval české pravidlá na slovenský spis.
>
> **Otázka na MČ:** aká je povinná identifikačná sada podľa slovenského AML pre FO a pre PO? Doplní sa ako jeden riadok do tabuľky.

## Čo už beží

[PR #24](https://github.com/Omni-Legal-Products/lawoss/pull/24) — `lawoss/okf/`, 70 testov, bez runtime závislostí, mimo pnpm workspace, nula zmenených upstream súborov.

Implementuje body 2–5 a 7. Body 1 a 6 (štruktúra a workflow založenia) zostávajú `mc-novy-spis` — **v jeho implementácii som nič nemenil.**

## Otvorené body na odklepnutie 1. 9.

**O1 — `_STATUS.md` prestáva byť ručný v tabuľkových sekciách.** ⚠ *Toto je jediná vecná zmena MČ kontraktu a rozhodnutie patrí obom.*
Hlavička Fáza / Ďalší krok a vlastné sekcie zostávajú advokátovi a neprepisujú sa. Tabuľky Lehoty / Chronológia / Záznamy sa renderujú medzi markermi. Dôsledok: drift v nich nemôže vzniknúť a `okf-freshness.sh` tam stráca úlohu.
*Alternatíva, ak sa O1 zamietne:* pamäť žije vedľa a `_STATUS.md` zostáva celý ručný — za cenu, že tá istá pravda je na dvoch miestach natrvalo.

**O2 — migrácia existujúcich spisov.** MČ spisy majú `MEMORY.md` s TP/LL/OQ. Konverzia na typované záznamy môže byť jednorazová a nedeštruktívna (pôvodný súbor zostáva), ale treba potvrdiť, že sa do nej ide.

**O3 — kde žijú nadspisové záznamy.** ✅ **Vyriešené pre AML** (31. 8.): `subject` a `screening` žijú u klienta, spis odkazuje. Zostáva otvorené pre **L1 kancelárie** (pravidlá, poučenia), ktoré sú nad klientom — návrh `<koreň spisov>/_kancelaria/pamet/`.

**O4 — multi-user.** Otvorená otázka zo spec 0002 zostáva otvorená. Append-only história konflikt zmierňuje (dva zápisy sa dajú zliať), ale `## Pravda` je stále last-write-wins.

**O6 — slovenská AML sada.** Povinná identifikačná sada podľa zák. č. 297/2008 Z. z. pre FO a PO. Bez nej sa na slovenských spisoch úplnosť nekontroluje. Patrí MČ.

**O5 — publikovať schému samostatne?** Spec 0002 sa pýta, či OKF vydať ako dokumentovaný štandard. Schéma je v jednej tabuľke, takže je to lacné — ale je to rozhodnutie tímu.
