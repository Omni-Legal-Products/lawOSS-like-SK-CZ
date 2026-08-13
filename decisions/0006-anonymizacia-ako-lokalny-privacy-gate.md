# ADR 0006: Anonymizácia ako lokálny privacy gate

- **Dátum:** 2026-08-11
- **Stav:** návrh
- **Rozhodli:** na prerokovanie tímom MČ · MF · IR · VŘ

## Kontext

LAWOSS chce ponechať klientské dáta u advokáta a súčasne umožniť kontrolovaný výber lokálneho alebo externého modelu. V backloge existuje návrh anonymizácie pred LLM, ale bez architektonickej hranice, licenčného pravidla a zmluvy medzi desktopovým produktom a lokálnym anonymizerom.

Koordinačný repozitár neobsahuje produktový kód. Vybraný upstream LegalWork má aktuálne Electron desktop shell a deklaratívne extension resource typy vrátane `local-service` a `native-binary`. To vytvára vhodný budúci boundary, ale neodôvodňuje vendorovanie cudzieho alebo samostatne vyvíjaného runtime.

## Navrhované rozhodnutie

Anonymizácia má zostať samostatným lokálnym komponentom s vlastnou licenciou, release evidence a bezpečnostným lifecycle. LAWOSS ju má integrovať do budúceho produktu cez riadený sidecar alebo local-service extension.

Záväzné architektonické pravidlá:

- originál sa nikdy neprepíše;
- externý model môže dostať iba `published` artefakt;
- `candidate`, `automated-verified` a `review-confirmed` sú lokálne stavy;
- publikovanie vyžaduje automatické overenie a výslovné potvrdenie advokátom;
- adaptér je matter-scoped, loopback-only, token-authenticated a bez ľubovoľného filesystem prístupu;
- kontrakt prenáša hashovanú provenance a maskované výsledky, nie raw identifikátory;
- chyba, timeout alebo chýbajúca závislosť je fail-closed;
- platformová podpora a redistribúcia sú samostatné release gates.

## Zvažované alternatívy

- **Skopírovať Python anonymizer do LAWOSS repozitára** — nie. Koordinačný repozitár nemá obsahovať produktový runtime; vznikol by licenčný, packagingový a upstream merge problém.
- **Vystaviť anonymizer ako všeobecný MCP server** — nie. Príliš široká filesystem a capability hranica by sťažila matter scope, audit a fail-closed routing.
- **Nechať anonymizáciu iba ako prompt alebo regex vo vnútri orchestrátora** — nie. Chýbala by nezávislá kontrola DOCX/PDF skrytých kanálov, vizuálneho OCR a publikovacieho lifecycle.
- **Vyžadovať cloudovú anonymizačnú službu** — nie. Bolo by to v rozpore s lokálnou privacy hranicou a s cieľom, aby klientské dáta zostali u advokáta.

## Dôsledky

### Pozitívne

- jasná hranica medzi spisom a externým providerom;
- zachovanie použiteľnosti anonymizera aj mimo LAWOSS;
- nezávislé testovanie a release evidence;
- kompatibilita s OKF, human gates a auditným workflow;
- menší diff voči LegalWork upstreamu, pretože integrácia žije v samostatnej vrstve.

### Negatívne a otvorené

- treba licenciu a samostatné balenie Python/Tesseract/PDF/DOCX runtime;
- Windows a Linux vyžadujú vlastnú certifikáciu;
- pribudne sidecar lifecycle, token exchange, port discovery a aktualizácia;
- treba rozhodnúť CLI/JSON vs. extension manifest ako prvý adaptér;
- report a OKF ledger musia dostať presný model provenance bez raw hodnôt.

## Dôsledok pre verziovanie

Privacy gate je architektonický P0 pred externým routingom. Plná používateľská integrácia je kandidát V1.1/P1 po schválení licencie, OS packagingu, JSON kontraktu a syntetického acceptance corpus.

Toto ADR je návrh na prerokovanie; neudeľuje licenciu, neschvaľuje automatické publikovanie a nevydáva právny záver o anonymite.
