# LAWOSS: lokálny anonymizačný gate pred externým LLM

- **Dátum:** 2026-08-11
- **Stav:** schválený návrh na prípravu GitHub Issue a draft PR
- **Cieľový repozitár:** `originalmagneto/lawOSS-like-SK-CZ`
- **Súvisiaci návrh:** backlogová položka „Anonymizácia / sanitizačný filter pred LLM"

## Cieľ

Navrhnúť bezpečnostnú hranicu medzi dôverným spisom a externým modelom. Dokument
sa smie odoslať do cloudového alebo iného externého modelu až po lokálnej
detekcii, vytvorení anonymizačného kandidáta, automatickom overení a výslovnom
potvrdení advokátom.

Návrh sa týka koordinácie a špecifikácie. Nepridáva Python runtime do tohto
koordinačného repozitára a nepredpokladá, že anonymizácia je právna záruka
úplnej anonymity.

## Východiská overené 2026-08-11

- LAWOSS je v tomto repozitári stále koordinačný projekt bez produktového kódu.
- Backlog už uvádza anonymizáciu ako sanitizačný filter pred LLM, ale bez
  vlastnej špecifikácie.
- Lokálna aplikácia v `/Users/martinfriedrich/Anonymiser` podporuje TXT, DOCX,
  textové a skenované PDF, profily redakcie, OCR, kontrolu skrytých kanálov,
  dočasné pracovné priestory a povinnú automatickú aj ľudskú kontrolu.
- Čistá kópia aktuálneho anonymizera prešla 284 testami; lokálny release gate
  overil aktuálny approval manifest. Testovací checkout s existujúcim approval
  manifestom však odhaľuje stavovú neizolovanosť testov „fresh install“.
- Vybraný upstream LegalWork má aktuálne Electron desktop shell a deklaratívne
  resource typy `local-service` a `native-binary`; staršie LAWOSS poznámky o
  Tauri treba pri implementácii považovať za neaktuálne.

## Navrhovaná architektúra

Anonymizer zostáva samostatným lokálnym komponentom. Budúci LAWOSS fork ho
spúšťa ako riadený sidecar alebo local-service extension; nesmie ísť o
ľubovoľné MCP volanie, ktoré by mohlo dostať klientsky dokument mimo určenej
hranice.

```text
spisový dokument
      |
      v
lokálny anonymizer: detekcia + redakčný kandidát
      |
      v
nezávislé overenie textu, metadát, balíkov a vizuálnych PDF kanálov
      |
      v
manuálna kontrola advokátom + doplnenie prehliadnutých údajov
      |
      v
publikovaný anonymizovaný artefakt + auditná stopa
      |
      v
voliteľné externé LLM / rešeršný provider
```

Originál sa nesmie prepísať. Neoverený alebo nepotvrdený kandidát sa nesmie
objaviť v cloudovom requeste. Chyba detektora, OCR, verifikátora, workeru,
časového limitu alebo platformovej závislosti je odmietnutie operácie, nie
„best effort“ pokračovanie.

## Minimálny integračný kontrakt

Adaptér LAWOSS má používať stabilný CLI alebo lokálny JSON kontrakt, nie
parsovanie HTML obrazovky. Kontrakt musí obsahovať:

- vstupný artefakt identifikovaný opaque ID a hashom;
- jurisdikciu a vybraný redakčný profil;
- stav `candidate`, `automated-verified`, `review-confirmed`, `published`,
  `rejected` alebo `failed`;
- hash zdroja a hash publikovaného výstupu;
- verziu politiky, detektorov, OCR a verifikátora;
- zoznam kontrolovaných kanálov a bezpečný počet nálezov;
- informáciu, či je potrebné ľudské potvrdenie;
- dôvod odmietnutia bez pôvodných hodnôt, názvov klientskych súborov alebo
  tracebackov.

Raw identifiers, mappingy a pôvodné dokumenty zostávajú iba v lokálnom
dočasnom pracovnom priestore s obmedzenými právami. Report určený pre LAWOSS
obsahuje iba maskované nálezy a auditné metadáta.

## Bezpečnostné a platformové podmienky

Pred kódovou integráciou musia byť splnené tieto podmienky:

1. anonymizer má výslovnú redistribučnú licenciu kompatibilnú s LAWOSS;
2. sidecar používa dynamický loopback port a per-process capability token;
3. balenie definuje Python/runtime, Tesseract jazykové dáta a PDF/DOCX nástroje
   pre každý podporovaný OS;
4. Windows a Linux majú vlastnú release-certificate cestu, nie iba POSIX
   predpoklad;
5. syntetický corpus overuje SK/CZ osobné údaje, právnické osoby, spisové
   značky, DOCX skryté kanály, PDF metadata/formuláre/attachments a OCR;
6. end-to-end test dokazuje, že originálny artefakt ani neoverený kandidát sa
   nedostanú do externého modelového requestu;
7. každé publikovanie je spätne dohľadateľné podľa hashov, verzie politiky,
   času a identity lokálneho review kroku bez ukladania pôvodných hodnôt do
   verejného reportu.

## Rozsah GitHub Issue a draft PR

### Issue

Issue má zachytiť produktový problém, prínos, návrh stavového toku, riziká a
otázky na rozhodnutie tímu. Má odkazovať na existujúcu backlogovú položku a na
nový spec; nemá tvrdiť, že anonymizácia garantuje úplnú anonymitu.

### Draft PR

PR má obsahovať iba dokumentačné zmeny:

- nový `specs/0008-anonymizacia-a-privacy-gate.md`;
- nový ADR o oddelenom local-service/sidecar boundary;
- riadok v `specs/README.md`;
- evidenciu v `specs/navrhy.md`;
- zaradenie a implementačné podmienky v `planning/backlog.md`.

PR nesmie meniť automaticky generované sekcie README, pridávať klientské dáta,
kopírovať zdrojový kód anonymizera ani rozhodnúť platformový rozsah bez tímovej
diskusie.

## Kritériá prijatia návrhu

Návrh je pripravený na tímové prerokovanie, ak:

- jasne rozlišuje architektonický P0 privacy gate od implementácie V1.1/P1;
- definuje human gate a fail-closed správanie;
- obsahuje strojovo čitateľný integračný kontrakt bez úniku raw hodnot;
- zachováva oddelenie koordinačného repozitára a budúceho produktového forku;
- pomenúva licenciu, OS, packaging, test isolation a provenance ako podmienky,
  nie ako neskoršie poznámky;
- obsahuje iba overené tvrdenia alebo ich označuje ako otázky na rozhodnutie.

## Otázky na prerokovanie v Issue

1. Prijíma tím anonymizáciu ako povinnú architektonickú hranicu a ako
   implementačný kandidát V1.1/P1?
2. Je prvý pilot oprávnené obmedziť na macOS, kým sa certifikuje Windows a
   Linux packaging?
3. Kto poskytne a schváli redistribučnú licenciu anonymizera?
4. Má byť prvý adaptér CLI/JSON sidecar, alebo má budúci fork najprv rozšíriť
   LegalWork local-service extension manifest?
5. Ktoré auditné polia sú povinné pre OKF a cloud-routing ledger?
