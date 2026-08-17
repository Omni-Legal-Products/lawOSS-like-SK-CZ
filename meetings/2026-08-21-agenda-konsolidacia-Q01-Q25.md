# Agenda callu 21. 8. 2026 — konsolidácia Q01–Q25 a proces práce

- **Kedy:** piatok 21. 8. 2026, 17:00
- **Podklady:** [stanoviská tímu Q01–Q25](../planning/2026-08-17-stanoviska-timu-Q01-Q25.md) · [návrh ADR 0011](../decisions/0011-proces-zmien-a-mergovania.md) · odpovede: IR + MF ([PR #26](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/26)), [VŘ](../planning/2026-08-15-odpovedi-VR-Q01-Q25.md)
- **Cieľ:** prijať konsolidované znenie odpovedí en bloc, rozseknúť 6 otvorených bodov, odklepnúť proces práce. Po calle sa znenie prepíše do ADR.

---

## Blok A — konsolidované znenie na prijatie en bloc *(~10 min)*

Nasledujúce znenie zhŕňa odpovede všetkých respondentov tam, kde je zhoda. **Navrhuje sa prijať jedným hlasovaním**; kto má výhradu ku konkrétnemu bodu, vyberie ho z bloku a ide do bloku B.

> [!NOTE]
> Formulácie nižšie sú konsolidát — pri spore platí plné znenie odpovedí v zdrojoch vyššie.

**U1 (Q01) · Product owner je MČ.** Zásadné veci konzultuje vopred; pat rozsekáva on; výhrady a odchýlky od prijatých ADR sa písomne zaznamenávajú. Všetci štyria členovia majú právomoc review a merge v rámci pravidiel ADR 0011.

**U2 (Q02) · Upstream sync** vlastní jeden menovaný maintainer s AI podporou, druhý člen robí review; VŘ robí review CZ vrstvy. Každý zásah do prevzatého kódu sa eviduje v `PATCHES.md`. IR dodá automat, ktorý pri konflikte otvorí PR s prehľadom. *(Mená → bod B2.)*

**U3 (Q03) · Release** vyžaduje product, technickú a doménovú kontrolu; pri regulovaných workflowoch príslušný právny sign-off — **IR za SK, VŘ za CZ**; release security MČ.

**U4 (Q04) · `dev`** zostáva integračnou aj default vetvou; stabilné body sa tagujú.

**U5 (Q05) · Review minimá sú záväzné** aj tam, kde ich GitHub nevynúti: docs po CI, funkčný kód min. 1 ľudský review, regulované témy + sign-off, upstream sync samostatný PR s regresnými testami. **Katalógy lehôt a zoznamy registrov sa počítajú ako funkčný kód.** Porušenie = revert bez drámy.

**U6 (Q06) · Vydávanie:** verejne od začiatku zdrojový kód a návod; verejné binárky **až podpísané a notarizované** (mac aj Windows); nepodpísané buildy len interne s varovaním. Mená IR a VŘ sa nespájajú s distribúciou nepodpísaných binárok *(osobné podmienky účasti)*.

**U7 (Q08) · MVP billing = B:** čas, sadzby, náklady, podklad pre faktúru. Prioritou je **export a rozhranie do existujúcich systémov** kancelárií, nie vlastná fakturácia. Vystavovanie dokladov mimo scope.

**U8 (Q09) · Anonymizácia je mimo V1.** Spúšťače návratu: (1) prvý workflow posielajúci obsah spisu do cloudového modelu, (2) podmienka pilotu u tretej osoby. Detekčné vzory (#36) ležia pripravené.

**U9 (Q10) · Pamäťové vrstvy:** L1 osobné preferencie bez klientskych dát · L2 pamäť jednej veci, prísne lokálna · L3 spoločná právnická pamäť výhradne z verejných zdrojov. Každá vrstva má vlastníka, provenance, verzovanie a retenčné pravidlá. Záznamy sú **typované**; existuje oddelená vrstva „poučenie z chyby". Pamäť žije v otvorených lokálnych súboroch (brain/OKF), prenositeľná medzi harnessami.

**U10 (Q11) · Povýšenie poznatku schvaľuje vždy človek** — agent navrhuje a ukazuje diff. Schválené sa **distribuuje všetkým agentom**. Žiadny režim autonómie to neodomyká.

**U11 (Q12–Q13) · Reconciliation:** okamžitý návrh pri významnej udalosti + týždenná konsolidácia + kontrola pri uzavretí veci. Metriky: navrhnuté/schválené/upravené/odmietnuté, **false promotion rate**, **čas ľudskej kontroly**, duplicity, rollback, provenance + **metrika štýlu** (čo advokát prepísal a v čom).

**U12 (Q14–Q15) · Preverovanie subjektov:** režimy light/medium/hard podľa návrhu MČ (spec doplní); zhodu pri menovcoch potvrdzuje **vždy človek**; každý sankčný screening púšťa **kontrolný dotaz na známy pozitívny prípad**. AML je architektonicky súčasť OKF intake, marketingovo samostatná funkcia.

**U13 (Q16) · Local-first:** klientske dokumenty, L1 a L2 výhradne lokálne; cloudová synchronizácia priečinkov je rozhodnutie používateľa a aplikácia s ňou musí korektne fungovať (vrátane on-demand súborov); telemetria len opt-in bez obsahu spisov; zálohy šifrované u advokáta. Opora: mlčanlivosť advokáta (SK aj § 21 CZ zák. o advokácii).

**U14 (Q17) · OKF/Markdown-first, nie RAG-first.** Jadro je otvorená súborová štruktúra; externé zdroje cez MCP/CLI, ktoré si smú viesť vlastné indexy; žiadny centrálny povinný RAG. Cieľ: prenositeľnosť medzi harnessami. *(Po prijatí prepísať do vlastného ADR.)*

**U15 (Q18) · Platformy:** multiplatformové jadro mac + Windows (Windows first-class cieľ, testuje IR), Linux best-effort, **bez nútenej absolútnej parity**; Apple-only integrácie potrebujú neutrálny fallback; platformovo špecifické funkcie sú prípustné.

**U16 (Q19) · Jurisdikcie:** dátové modely neutrálne pre SK/CZ/PL, implementácia SK/CZ; ďalšie jurisdikcie modulárne cez lokálnych právnikov-contributorov.

**U17 (Q22) · Monetizácia:** všetok kód a moduly open source; zarábame výhradne na školeniach, workshopoch a implementačnej pomoci; žiadne platené moduly. *(Licenčná ochrana pred prevzatím → bod B5.)*

**U18 (Q23) · Publikovanie:** vraciame komunite lokalizácie, opravy upstreamu, modulové rozhranie, OKF špecifikáciu, skilly a MCP; datasety len s vyjasnenou licenciou; AI generovaný korpus komentárov len s varovaním „citovať v podaní nie". Upstream do LegalWorku case-by-case.

**U19 (Q25) · Formáty:** *open formats at the core, compatibility at the edges* — Markdown/HTML/JSON kanonické, OOXML výmenné; **DOCX round-trip má testovací korpus a vizuálnu kontrolu** ako merateľnú podmienku; tracked changes a autorstvo úprav (#29, #31) sú súčasť tejto podmienky.

## Blok B — otvorené body na rozhodnutie *(~30 min)*

| # | Bod | Stav | Odporúčanie na stôl |
|---|---|---|---|
| **B1** | **Q07 — tretia vertikála:** lehoty vs. onboarding subjektov | VŘ + MF: lehoty dnu · IR: náhradník, súhlasí so zámenou · rozhoduje MČ | lehoty do trojice (SK aj CZ právne jadro hotové, engine existuje), onboarding prvý náhradník |
| **B2** | **Q02 — mená:** maintainer a reviewer upstream syncu | otvorené | MČ maintainer + IR reviewer *(alebo obrátene — 5 min diskusia)* |
| **B3** | **K1/Q24 — záväznosť doktríny** | IR + VŘ + MF: záväzná (MF s odľahčenou výnimkou) · MČ pracovne case-by-case | záväzná + odľahčená výnimka (krátke písomné odôvodnenie, mitigácia, časové obmedzenie) |
| **B4** | **K2/Q21 — autonómia a YOLO** | MF + VŘ + IR zhodne; čaká MČ | konfigurovateľná autonómia len vnútri veci; tvrdé hranice (podpis, podanie, odoslanie von, financie, neanonymizovaný cloud, **povýšenie pamäti**) technicky nedostupné v každom režime |
| **B5** | **Licencia — ochrana pred komerčným prevzatím** | MČ otvoril; MIT to nerieši; ADR 0010 stavia na značke | zadať samostatnú rešerš (MIT vs. Apache-2.0 vs. MPL/AGPL vs. source-available) s termínom; do rozhodnutia platí MIT |
| **B6** | **Q20 — sign-off roly** | návrh IR + CZ doplnok VŘ; MF navrhol vlastné rozdelenie v odpovedi | potvrdiť osobne: privacy/pamäť MF+IR · AML IR+MČ · QES/konverzia MČ + právne IR (SK) / VŘ (CZ) · licencie dát IR (SK) / VŘ (CZ) · release security MČ |
| **B7** | **ADR 0011 — proces zmien a mergovania** | návrh v [PR #54](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/54) | odklepnúť vrátane: spätná legitimizácia merge-ov zo 17. 8. · presun `.agents/` a `plugins/` do samostatného repa · záväznosť AGENTS.md pre agentov |
| **B8** | **K3/Q06 — formálne potvrdenie** | prakticky vyriešené | len odklepnúť U6 + rozhodnúť, kto platí podpisové certifikáty a na koho znejú |

## Blok C — výstupy po calle

- [ ] Zápis z callu (`meetings/2026-08-21-...md`) s hlasovaniami
- [ ] Prijaté uznesenia prepísať do ADR: governance (U1–U3, B2) · scope V1 (U7, B1) · pamäť a reconciliation (U9–U11, B4) · dáta a platformy (U13–U16) · monetizácia a publikovanie (U17–U18, B5) · formáty (U19) — čísla 0012+
- [ ] Zlúčiť PR #54 (ADR 0011 + záväzné AGENTS.md), ak odklepnuté
- [ ] MČ podá finálne odpovede do PR #26 (formálne uzavretie hlasovania)
- [ ] Odklepnuté vertikály → issues vo forku s odkazmi na specy
- [ ] Aktualizovať roadmapu a `stav-odpovedi` dokument

---

<sub>Pripravil MČ s AI asistenciou 2026-08-17. Konsolidát vychádza z plných znení odpovedí IR (14. 8.), VŘ (15. 8.), MF (17. 8.) a pracovných stanovísk MČ (15.–17. 8.).</sub>
