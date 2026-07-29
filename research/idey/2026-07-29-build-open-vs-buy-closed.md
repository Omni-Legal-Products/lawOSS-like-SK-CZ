# 07-29 Právnický AI stack: Verdikt „Build-open vs. Buy-closed“, architektúra, náklady a akčné kroky

[image]

## Jadrová synopsia

Trh právnických AI nástrojov sa láme na tri osi: všeobjímajúci ekosystém Microsoft 365 Copilot, generické subscriptions k veľkým modelom (OpenAI, Anthropic, Google) a špecializované „legal AI“ aplikácie typu Harvey/Legora či lokálne klony; faktická realita je, že Microsoft vyhráva infraštruktúrou a integráciou, ale prehráva pre advokátov v presnosti a hĺbke doménových funkcií, zatiaľ čo špecializované riešenia sa opierajú o dobré prompty a legal workflow, no často šetria na modeloch, uzatvárajú prompty do black boxov a tým uniformizujú výstupy; najvyššia páka pre právnikov preto leží v otvorenom, modulárnom stacku: vlastná aplikácia nad kombináciou open-source komponentov (napr. Mistral OCR pre PDF→Markdown) a voliteľných prémiových modelov, s transparentnými promptami, self-healing pipeline, kontinuálnym učením a slobodou voľby modelov a subscriptionov. Engineering/produktový tím uvádza dôkazy: Microsoft dodáva „všetko“ a kredity, ale musí obsluhovať celý trh (marketing, logistika, školstvo, government), čo vedie k prehŕňaniu funkcií bez hĺbky; špecializované legal AI zasa zamykajú know-how do promptov, sú cenovo citlivé a tým degradujú kvalitu; my berieme záväzok staviť na otvorenosť a individualizáciu, lebo v práve je diferenciácia výstupu konkurenčná výhoda, a uzamknuté prompty túto výhodu ničia.

------

## Architektúra možností a verdikt: „Build-open vs. Buy-closed“

### 1. Tri kategórie riešení a ich systémová logika
- Microsoft 365 + Copilot (ekosystémová voľba)
  - Silné: infraštruktúra, prepojenia, úložiská, bezpečnostný rámec, kredity k AI.
  - Slabé: nešpecializované pre právo, príliš široké, funkčná hĺbka pre niche potreby absentuje.
- Generické subscriptions k LLM (OpenAI/Anthropic/Google)
  - Silné: voľba kvalitných/drahších modelov, flexibilita, vlastná promptová tvorba.
  - Slabé: nutnosť vlastnej architektúry, integrácie, prompt engineeringu, governance.
- Špecializované „legal AI“ aplikácie (Harvey, Legora, lokálni poskytovatelia)
  - Silné: doménová UX/logika, pripravené workflow.
  - Slabé: šetrenie na modeloch, black-box prompty, uniformné výstupy, obmedzená prispôsobiteľnosť.

### 2. Dialektika: prečo špecializované black-boxy zlyhávajú v diferenciácii
- Téza: Legal AI s „dobrými promptmi“ skráti čas a učí sa doménu.
- Antitéza: Uzamknuté prompty = identické štýly a štruktúry naprieč užívateľmi; znižuje sa jedinečnosť argumentácie a reputačná diferenciácia.
- Syntéza: Otvorený prompt layer + voľba modelu + vlastné úpravy = zachovanie konkurenčného podpisu advokáta.

### 3. Operačný návrh: otvorený, modulárny legal stack
- Komponenty (príklady):
  - OCR/Parsing: Mistral OCR pre PDF→Markdown (lacné, účinné).
  - Prompt layer: transparentné, editovateľné prompty per užívateľ/vec.
  - Pipeline: self-healing systém (detekcia chýb, re-run), kontinuálne učenie z korekcií.
  - Model orchestration: voľba modelu per úloha (syntetické/open-source vs. prémiové).
  - Integrácie: selektívna koexistencia s Microsoft 365 (úložiská, bezpečnosť) bez závislosti na Copilot logike.
- Systémová veta: Centralizujte dáta a bezpečnosť, decentralizujte modelovú voľbu a promptovú kontrolu.

### 4. Politika nákladov vs. kvalita modelu
- Pozorovanie: Špecializované appky často skresávajú náklady cez slabšie modely, čo degraduje právnu kvalitu.
- Rozhodovacia logika: Pre kritické výstupy (podania, zmluvy) je racionálne zaplatiť prémiový model; pre nízkorizikové úlohy (OCR, prepisy, sumarizácie) je správne použiť lacné open-source komponenty.

### 5. Miestne zdroje a rozšírenia
- Kandidáti: Mistral OCR; nešpecifikovaný taliansky open-source systém (na posúdenie možnej integrácie).
- Kritériá integrácie: licenčné podmienky, kvalita na právne use-cases, kompatibilita s prompt layerom, nákladový profil.

------

## Ďalší ťah (Action Items)

**@Produktový vedúci**
- [ ] Navrhnúť modulárnu architektúru legal stacku (OCR, prompt layer, model orchestration, self-healing, learning loop) s jasnými rozhraniami - [TBD]
- [ ] Definovať governance pre prompty (verzovanie, audit trail, per-user/per-matter prispôsobenia) - [TBD]

**@Technický líder**
- [ ] Vyhodnotiť Mistral OCR na vzorke 50 právnych PDF (metrika: presnosť konverzie do Markdownu, čas/€/dokument) - [TBD]
- [ ] Preskúmať taliansky open-source systém (licencia, kompatibilita, výkon) a pripraviť integračný návrh - [TBD]
- [ ] Implementovať model routing: mapovanie úloh na modely (lacné vs. prémiové) s fallback mechanizmom - [TBD]

**@Bezpečnostný/Compliance manažér**
- [ ] Stanoviť dátové zásady pri koexistencii s Microsoft 365 (úložiská, šifrovanie, audit) a požiadavky na právnu dôvernosť - [TBD]

**@UX dizajnér**
- [ ] Navrhnúť UI pre transparentné, editovateľné prompty vrátane štýlových profilov „podpisu advokáta“ - [TBD]