# Mapa českých datových zdrojů

- **Zpracoval:** Vojta Říha (VŘ) · 2026-08-15
- **Plní:** úkol *„Zmapovat CZ zdroje (VŘ)"* z [roadmapy](roadmap.md), fáze 0
- **Protějšek:** [spec 0004 SK MCP konektory](../specs/0004-mcp-sk-konektory.md) a [inventář MCP repozitářů](mcp-repository-inventory.md) (SK strana)
- **Stav:** podklad k projednání; sloupec *Zralost* říká, co je hotový nástroj a co zatím jen znalost

> [!IMPORTANT]
> **Tohle není seznam přání.** Zdroje označené `🟢 nástroj` běží v produkci advokátní praxe RIHA legal a jsou denně používané. Zároveň — a to je podstatné pro plánování — **ani jeden z nich zatím není MCP server.** Jsou to CLI skripty, skilly a ověřené postupy. Zabalení do MCP je práce, kterou je třeba naplánovat, ne předpokládat jako hotovou.

## Legenda zralosti

| Značka | Význam |
|---|---|
| 🟢 **nástroj** | funkční kód v denním provozu, včetně ošetřených pastí |
| 🟡 **protokol** | ověřený postup a znalost API, ale bez zabaleného nástroje — volá se ad hoc |
| 🔵 **externí** | služba třetí strany; použitelná, ale nelze ji redistribuovat bez vyřešení licence |
| ⚪ **mezera** | česká obdoba slovenského konektoru chybí |

---

## 1. Souhrn — CZ protějšky slovenských konektorů

Sloupec „SK protějšek" ukazuje, který slovenský konektor ze [spec 0004](../specs/0004-mcp-sk-konektory.md) plní tutéž roli.

| SK protějšek | CZ zdroj | Zralost | Přístup | Zápisové úkony |
|---|---|---|---|---|
| Slov-Lex | **Zákony ČR** přes Salvia (`slv`) / Codexis | 🔵 externí | MCP (Salvia), CLI (`cdx-cli`) | ne |
| Judikatúra SR | **NS, NSS, ÚS, obecné soudy** přes Salvia; vlastní vektorový index | 🔵 externí + 🟢 nástroj | MCP, Pinecone | ne |
| ORSR / RPO | **Obchodní rejstřík** (or.justice.cz) + **ARES** | 🟡 protokol | REST (ARES), WebFetch (OR) | ne |
| RPVS | **Evidence skutečných majitelů** (esm.justice.cz) | ⚪ mezera | — | ne |
| Register úpadcov | **ISIR** — insolvenční rejstřík | 🟢 nástroj | skill `/isir`, agent, scraping | ⚠️ podání |
| Obchodný vestník | **Obchodní věstník** (ov.ihned.cz / OV justice) | ⚪ mezera | — | ne |
| Finančná správa | **Registr plátců DPH** (SOAP `rozhraniCRPDPH`) | 🟡 protokol | SOAP | ne |
| ÚVO | **Věstník veřejných zakázek** (vestnikverejnychzakazek.cz) | ⚪ mezera | — | ne |
| Register diskvalifikácií | **Evidence vyloučených osob** (§ 65 ZOK) | ⚪ mezera | — | ne |
| CRZ | **Registr smluv** (smlouvy.gov.cz) | ⚪ mezera | — | ne |
| slovensko.sk / eID | **Datové schránky (ISDS)** | 🟢 nástroj | SOAP, oficiální API | ⚠️⚠️ **odesílání podání** |
| — (SK nemá) | **Katastr nemovitostí** (ČÚZK) | 🟢 nástroj | REST | ne |
| — (SK nemá) | **InfoSoud** — termíny jednání | 🟡 protokol | přes Evolio | ne |
| — (SK nemá) | **EPR** — elektronický platební rozkaz | 🟡 protokol | XML podání | ⚠️⚠️ **podání k soudu** |
| — (SK nemá) | **OpenSanctions** — sankční screening | 🟡 protokol | REST / hromadné CSV | ne |

---

## 2. Detail — co je hotové

### 🟢 ISDS — datové schránky

Nejsilnější položka a zároveň česká obdoba `slovensko.sk`, kterou spec 0004 označuje jako chybějící a rizikovou.

| | |
|---|---|
| **Co existuje** | odeslání, seznam zpráv, stažení příloh, vyhledání schránky, stažení **oficiální PDF doručenky** z portálu, společný modul pro autentizaci |
| **Navíc** | **automatické rozřazování příchozích zpráv do spisu** — tříúrovňová klasifikace: (1) spisová značka z předmětu, (2) ID odesílající schránky proti registru klientů, (3) klíčová slova v přílohách + LLM fallback |
| **Přístup** | oficiální ISDS API, přihlašovací údaje per schránka |
| **Provozní pravidlo** | **nikdy neodeslat bez výslovného potvrzení uživatelem**; každé odeslání se nejdřív spustí jako `--dry-run` |
| **Past** | schránka advokáta nemá právo číst obsah zpráv adresovaných jiné schránce (ISDS chyba 1207) |
| **Formát `.zfo`** | není ZIP, ale PKCS#7 SignedData (CMS) ASN.1 DER — `unzip` selže; extrakce přes `openssl smime`, přílohy jsou base64 v `<dmEncodedContent>` |

> [!WARNING]
> **ISDS je zápisový kanál.** Platí zde varování ze spec 0004 v plné síle: doručení podání datovou schránkou má tytéž účinky jako podepsané podání. Jedna halucinovaná akce = podání, které nikdo nechtěl. **Read-only jako default, odeslání pouze s výslovným potvrzením člověkem, nikdy automaticky.**

Souvisí s [nápadem #22](napady.md) (sjednocení komunikačních kanálů do spisu) — ISDS je jeden z kanálů, které do spisu ústí.

### 🟢 ISIR — insolvenční rejstřík

| | |
|---|---|
| **Co existuje** | skill pro monitoring řízení, analytický agent (perspektiva věřitel / dlužník / správce), paměť případu |
| **Ověřené pasti** | scraper přes `evidence_upadcu` vrací **jen část spisu** — kompletní je pouze `evidence_upadcu_detail.do?details=13`; datové řádky jsou `<TR>` velkými písmeny; přímé URL přes IČO často vrací HTTP 500 |
| **PDF přihlášek** | mají posunuté kódování (+31 v ASCII); **číslice se ztrácejí — nikdy z nich nebrat IČO, data ani částky** |
| **XFA formuláře** | přihlášku pohledávky lze plnit programově; past: regex `<xfa:data[^>]*>` chytá i `<xfa:datasets` |
| **Zápisové úkony** | podání do insolvenčního řízení — stejný režim jako ISDS |

### 🟢 Katastr nemovitostí (ČÚZK)

Skill nad REST API `api-kn.cuzk.gov.cz` — parcely, budovy, jednotky, řízení, listy vlastnictví.

⚠️ **Ověřené omezení:** API **neumí hledat podle vlastníka.** Převod vlastnictví se ověřuje nepřímo — proxy testem na změnu LV a přítomnost plomby.

### 🟢 Výpočet lhůt

Deterministický engine podle § 57 o. s. ř. včetně tabulky svátků (z. č. 245/2000 Sb.) a pohyblivých velikonočních dnů. Podrobně v [podkladu k lhůtám](../research/pravny-ramec/2026-08-15-lhoty-cz-pravidla-vypoctu.md), který právě otevírá otázku, že engine **nepokrývá odlišnou aritmetiku daňového řádu ani posun úložní doby u fikce doručení** — obojí je popsané a připravené k doplnění.

Navazuje skill, který z volných poznámek po jednání vytáhne lhůty všech stran a založí je do kalendáře s upomínkami.

### 🟢 Vektorový index judikatury

Vlastní Pinecone index rozhodnutí NS, ÚS a SDEU. Doplňuje fulltext o sémantické hledání.

⚠️ Ověřené pasti: frontmatter u NS záznamů **nesouhlasí se spisovou značkou** v textu; limit 507 tokenů a 96 záznamů na upsert; **výsledky nejsou setříděné podle skóre** (SDK 9.x).

---

## 3. Detail — co je znalost, ne nástroj

### 🟡 Obchodní rejstřík a ARES

Ověřovací protokol pro údaje o právnických osobách. Jádro postupu: vyhledat aktuální výpis, načíst jej **vždy s parametrem `typ=PLATNY`** (ne `UPLNY`), převzít přesné znění jména, datum narození, bydliště, datum zápisu funkce a způsob jednání.

⚠️ **ARES vrací i vymazané záznamy** — je nutné filtrovat `datumVymazu`; autoritativní je výpis soudu, ne ARES.

Metodicky navazuje na pravidlo, které pokládám za přenositelné do OKF: **údaje o právnických osobách se nikdy nedoplňují z paměti modelu ani ze starší smlouvy**, protože zápisy v rejstříku se mění. Neověřený údaj patří do placeholderu `[DOPLNIT]`. To je přesně princip, který [spec 0002](../specs/0002-okf-operacny-system-praxe.md) formuluje jako *„subjekty se ověří přes MCP — ne z hlavy"*.

### 🟡 Registr plátců DPH

Nespolehlivost plátce a zveřejněné bankovní účty jsou dostupné **pouze přes SOAP** `rozhraniCRPDPH`. Prázdný element znamená „žádný zveřejněný účet", ne chybu.

Praktický význam pro AML a pro kontrolu platebních instrukcí v transakcích.

### 🟡 InfoSoud

**Termíny soudních jednání nejsou v datové schránce ani v kalendáři soudu** — jediný zdroj je InfoSoud. V naší praxi se k němu přistupuje přes spisový systém.

### 🟡 EPR — elektronický platební rozkaz

Znalost XML schématu v37-b: struktura příslušenství, kódy soudů, měna zapisovaná jako `KČ` velkými písmeny.

### 🟡 Sankční screening

⚠️ **Ověřeno: OpenSanctions API bez klíče vrací prázdný výsledek i pro zjevně sankcionované osoby.** Použitelné je hromadné CSV; ke každému dotazu patří kontrolní dotaz na známý pozitivní případ, jinak systém tiše hlásí „čisto".

Přímo relevantní pro **Q14** (obsah režimů `light` / `medium` / `hard`) a pro zásadu ze spec 0002, že *„neověřený nebo nedostupný registr se nesmí prezentovat jako čistý výsledek"*.

---

## 4. Externí zdroje a licenční překážky

| Zdroj | Co poskytuje | Licenční stav |
|---|---|---|
| **Codexis** (`cdx-cli`, REST v3) | česká i slovenská legislativa, judikatura, komentáře, vzory | 🔴 **placená databáze třetí strany — nelze redistribuovat.** Použitelná jen s vlastním předplatným uživatele. |
| **Salvia** (MCP `slv`) | judikatura NS / NSS / ÚS / obecné soudy + legislativa + ISIR index | 🟡 **licenční podmínky pro komunitní sdílení neověřeny** — otevřený úkol VŘ z [backlogu](backlog.md), návrh [#13](../specs/navrhy.md) |
| **open-commentary.com** | ~94 komentářů k českým a EU předpisům, vlastní korpus | 🟢 Apache-2.0, lze publikovat — **ale viz varování níže** |

> [!CAUTION]
> **Korpus komentářů je navigační vrstva, ne pramen.** Jde o sekundární, **nerecenzovaný** materiál generovaný s AI asistencí. Nesmí se citovat v podání ani z něj přebírat znění paragrafu či spisovou značku — komentář používá zkratkovité formulace, které bývají méně přesné než zákon.
>
> Ověřeno na konkrétní věci (7/2026): u § 79f tr. ř. korpus paušálně uváděl „stížnost s odkladným účinkem", ač odkladný účinek dopadá jen na část případů; u § 79b odst. 2 vynechal slova **„nebo na jiné určené místo"** — což byla přitom nosná opora eventuálního petitu.
>
> **Metodické doporučení pro LAWOSS:** korpus zařadit jako vrstvu, která najde souvislosti napříč předpisy, a **za ní povinně doověření proti primárnímu prameni**. Tenhle dvoustupňový vzor je pro projekt cennější než korpus samotný a je přímou odpovědí na požadavek spec 0004 na *„verifikaci citací jako antihalucinační pojistku"*.

---

## 5. Mezery — co v ČR chybí

Pět slovenských konektorů nemá českou obdobu. Všechny cílové zdroje jsou veřejné a strojově dostupné; jde o práci, ne o překážku.

- [ ] **Evidence skutečných majitelů** (esm.justice.cz) — protějšek RPVS, potřebné pro AML
- [ ] **Obchodní věstník** — protějšek Obchodného vestníka
- [ ] **Registr smluv** (smlouvy.gov.cz) — protějšek CRZ
- [ ] **Věstník veřejných zakázek** — protějšek ÚVO
- [ ] **Evidence vyloučených osob** dle § 65 ZOK — protějšek registru diskvalifikácií

## 6. Úkoly

- [ ] Ověřit licenční podmínky Salvia pro komunitní sdílení *(VŘ)*
- [ ] Rozhodnout, které CZ nástroje se zabalí jako MCP a v jakém pořadí *(VŘ + MČ)*
- [ ] Doplnit pět chybějících konektorů do backlogu jako samostatné položky *(VŘ)*
- [ ] Sjednotit s IR formát katalogu registrů pro režimy `light` / `medium` / `hard` (Q14) *(VŘ + IR)*
- [ ] Potvrdit český rámec autorizované konverze pro [spec 0007](../specs/0007-podpisovanie-a-zarucena-konverzia.md) *(VŘ, samostatný úkol)*

---

<sub>Zpracoval VŘ, 2026-08-15. Zralost každé položky odráží stav v praxi RIHA legal k tomuto datu. Uvedené pasti jsou zjištěny provozem, ne převzaty z dokumentace zdrojů — dokumentace je ve většině případů neuvádí.</sub>
