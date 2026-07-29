# 07-29 Návrh open‑source orchestrátora pre advokátov: dvojkoľajná integrácia transkripcie a AI rešerší s BYO‑subscriptions a compliance rámcom

[image]

## Hlavná syntéza

Jadro návrhu je systémovo správne, ale neštruktúrované: projekt mieri k open‑source aplikácii pre advokátov, ktorá musí integrovať dve kritické osi – (1) transkripciu hovorov/stretnutí cez lokálne modely (Whisper) aj cudzie API (OpenAI GPT Transcribe, vlastné servery, Mistral) a (2) orchestráciu „researchu“ cez externé subscription služby (ChatGPT Team/Business, GPT Pro, Refado/ex‑OpenPlot, prípadne taliansky OpenCode variant), aby znížila API náklady a zároveň zvýšila kvalitu rešerší; technický dôkaz je v existujúcom vlastnom transcribe serveri a napojeniach na Refado/Plod, no chýba produktová kostra: štandardizácia práce so súbormi (naming, spisy, evidencia), bezpečnostno‑právna vrstva a jasná stratégia „bring‑your‑own‑subscription“ vs. vlastné API kľúče; ak sa toto nezarovná v architektúre a licencii, rizikom je rozbitá UX, compliance dlhy a fakt, že sľubovaná úspora (20 €/mes. GPT Pro vs. stovky € cez API) sa nepretaví do reprodukovateľného hodnotového toku pre advokátov; my sa musíme explicitne zaviazať k modelu: aplikácia je primárne workflowový orchestrátor s modulárnou integráciou transkripcie a „research“ subscriptions, s povinnou možnosťou vlastných API kľúčov a s kurátorovaným mostom na ChatGPT/Refado – inak projekt uviazne v technickom „toolkitu“ bez reálneho adoptionu.

## Produktový rámec a integračná logika

- Dominantná hodnota: „Workflow nad inteligenciou“
  - Cieľ: Pomôcť advokátom štruktúrovať prácu (názvy súborov, spisy, evidencia, ukladanie) a automatizovať príjem/výstup z AI služieb.
  - Systémová rola: Aplikácia je lepidlo a register (zdroj pravdy), nie monolitický AI engine.

- Integračná architektúra: Dvojkoľajka Transcribe + Research
  - Transkripcia (ingest vrstva)
    - Lokálne: Whisper, lokálne modely cez vlastný server.
    - Cloud: OpenAI (GPT Transcribe), Mistral, vlastný Transcribe server (proxy).
    - Kanály: Upload súboru, synchronizácia cez Refado (ex‑OpenPlot) a Plod.
    - Požiadavka: BYO‑API aj možnosť „subscription“ napojení.
  - Research (orchestračná vrstva)
    - Subscription mosty: ChatGPT Team/Business, GPT Pro (nákladová výhoda), Refado.
    - Orchestrátor otázok: Presmerovanie dotazov do webových/aplikačných subscription služieb, ingest odpovedí späť, evidencia a ukladanie do spisu.
    - Licenčná/ToS citlivosť: BYO subscription preferované, vlastné API ako fallback.

- Compliance a prevádzkové riziká (nutné ošetriť)
  - Dôvernosť a PII: Právnické dáta vyžadujú jasné DPA a data routing (lokálne vs. cloud).
  - Logovanie a evidencia: Audit trail k spisom (kto/kedy/čo transkriboval/vyexportoval).
  - Licencie/subscriptions: Neobchádzať ToS ChatGPT/Team; aplikácia len sprostredkováva.
  - Medzinárodné varianty: Overiť „taliansku verziu“ (OpenCode) pre kompatibilitu integrácií.

- UX a produktové minimum (MVP scope)
  - Štandardy názvoslovia a šablóny spisov (konfigurovateľné).
  - Jednotný inbox pre nahrávky a transkripty; automatický parsing metadát (klient, vec, dátum).
  - „Send to Research“ routovanie s výberom cieľovej subscription a spätné uloženie výstupu.
  - Nastavenia kľúčov: BYO‑API/Subscriptions, per‑organizácia, per‑užívateľ.
  - Exporty a citácie: Generovanie sumárov s citáciami, pripnutie k spisu.

- Ekonomika a prevádzka
  - Nákladová téza: GPT Pro/ChatGPT Team prináša lepší „research za 20 €/mes.“ vs. raw API.
  - Realizácia úspory: Nech je aplikácia len orchestrátor; náklady nesie užívateľ cez vlastné predplatné.
  - Otvorený kód: OS licencia kompatibilná s enterprise adopciou (napr. Apache 2.0) + separátne enterprise pluginy (ak neskôr).

## Ďalšie kroky (akčné položky)

**@Produktový manažér**
- [ ] Definovať MVP špecifikáciu: moduly Transcribe, Research Orchestrator, File/Case Management, Settings (BYO‑API/Subscriptions), Audit trail - [TBD]
- [ ] Navrhnúť naming konvencie a šablóny spisov (konfigurovateľné per firma) - [TBD]
- [ ] Vypracovať ToS/Compliance rámec pre BYO ChatGPT/Team a Refado integrácie (bez porušenia ToS) - [TBD]

**@Tech Lead**
- [ ] Navrhnúť integračnú architektúru s konektormi: Whisper (lokálne), OpenAI Transcribe, Mistral, vlastný Transcribe server, Refado/Plod sync; definovať jednotné rozhranie pre poskytovateľov - [TBD]
- [ ] Implementovať „Provider Registry“ (plugin API) s runtime výberom poskytovateľa a routingom podľa politiky (lokálne vs. cloud) - [TBD]
- [ ] Zaviesť audit trail (immutable log) pre všetky operácie nad spisom a transkriptami - [TBD]

**@Právnik/Compliance**
- [ ] Pripraviť DPA šablóny a klasifikáciu dát (PII/klientské tajomstvo) vrátane pravidiel dátových tokov (EU region pinning, lokálne spracovanie) - [TBD]
- [ ] Overiť licenčné a ToS aspekty ChatGPT Team/Business, GPT Pro a Refado pre „sprostredkované používanie“ cez našu aplikáciu - [TBD]

**@Integrations Engineer**
- [ ] Overiť „taliansku verziu“ (OpenCode) a jej schopnosť integrovať subscriptions; pripraviť porovnanie a plán re‑use komponentov - [TBD]
- [ ] Zrealizovať pilotné napojenie Refado (ex‑OpenPlot) s obojsmerným sync nahrávok a transkriptov do spisov - [TBD]

**@DevOps**
- [ ] Pripraviť bezpečné nasadenie pre lokálne spracovanie (Whisper) vs. cloud routing; tajomstvá a správu kľúčov (Vault) per tenant - [TBD]
- [ ] Zaviesť logovanie a monitorovanie poskytovateľov (latencia, chybovosť, náklady) s prepínaním pri výpadkoch - [TBD]