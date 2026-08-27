# Spec 0013: Session log — pracovný denník spisu

- **Stav:** návrh
- **Navrhol:** Marián Čuprík (MČ) · 2026-08-21
- **Zdroj inšpirácie:** skill *Decision Log* z [Granular](https://granular.build) → [rešerš](../research/inspiracie/2026-08-21-granular-brain-a-pamatove-vzory.md) *(closed-source produkt — preberáme koncept, nie kód ani text)*
- **Súvisiace:** [spec 0002 OKF](0002-okf-operacny-system-praxe.md) *(rozširuje)* · [#37 typované záznamy pamäti](navrhy.md) *(VŘ)* · [Q13](../meetings/2026-08-18-zapis-sync-call.md) · [spec 0009 reconcile](0009-reconcile-ucenie-z-uprav.md)

> [!NOTE]
> **Toto je zámerne úzky spec.** Rieši **jeden nový súbor** a **jeden riadok v protokole zápisu**. Vznikol po porovnaní OKF v0.1 s brain vzorom Granularu — z ktorého vyplynulo, že OKF má obsahovo takmer všetko a chýba mu **jediná vec**: záznam o tom, čo sa na spise dialo.

## Problém

OKF v0.1 vie, **aký je stav veci** (`_STATUS.md`), **čo sme sa rozhodli** (`MEMORY.md`) a **čo je vec zač** (`spis.md`). Nevie ale, **čo sa na spise dialo** — kto s ním pracoval, čo pri tom vzniklo a čo zostalo visieť.

Chýba to na troch miestach naraz:

| Kde to chýba | Prejav |
|---|---|
| **Kontinuita medzi sedeniami** | Agent po otvorení spisu vidí výsledok, ale nie cestu. Nevie, či sa niečo už skúšalo a zlyhalo. |
| **Auditovateľnosť** | Pri zápise do pamäte nie je stopa, **kedy a pri akej práci** vznikol. Presne na to upozornil VŘ v návrhu [#37](navrhy.md). |
| **Náhrada metrík** | Na [calle 18. 8.](../meetings/2026-08-18-zapis-sync-call.md) padli formálne metriky reconciliation (**Q13**) s tým, že namiesto nich má byť *„changelog session v OKF"*. Ten zatiaľ neexistuje. |

Rovnaký nedostatok rieši Granular skillom *Decision Log* — agent vedie append-only `PROJECT-LOG.md`, kde je *„každý ask, rozhodnutie a ship zapísaný v momente, keď sa stane."*

## Navrhované riešenie

Nový súbor **`CHANGELOG.md`** v každej OKF entite — append-only pracovný denník, ktorý agent dopĺňa na konci každého sedenia.

### ⚠️ Vymedzenie voči `_STATUS.md` § Chronológia

**Toto je jediné miesto, kde môže vzniknúť drift, tak ho vymedzujeme hneď.** Chronológia v `_STATUS.md` už existuje a na prvý pohľad to vyzerá ako to isté. Nie je:

| Súbor | Čo tam patrí | Príklad |
|---|---|---|
| `_STATUS.md` § **Chronológia** | **udalosti vo veci** — právne relevantné skutočnosti, súčasť SSOT | *5. 9. doručená žaloba* · *12. 9. pojednávanie odročené* |
| `CHANGELOG.md` | **práca na spise** — čo sme robili a čo z toho vzniklo | *21. 8. prešli sme žalobu; doplnené 4 fakty a 1 lehota* |

Pojednávanie je **udalosť veci**. „Agent prešiel žalobu a našiel štyri fakty" je **práca na veci**. Ani jeden záznam nepatrí do druhého súboru.

> [!IMPORTANT]
> **Pravidlo:** ak by záznam mohol niekedy skončiť v podaní na súd, patrí do `_STATUS.md`. Ak zaujíma len nás, patrí do `CHANGELOG.md`.

### Formát záznamu

Štyri riadky, žiadny frontmatter na úrovni záznamu:

```markdown
## 2026-08-21 · 14:20
**Robil:** MČ · Claude Code
**Čo sa dialo:** prešli sme žalobu protistrany; doplnené 4 fakty, 1 lehota
**Zmenené:** `_STATUS.md` (fakty 12–15, lehota 5. 9.) · `MEMORY.md` (TP-004)
**Otvorené:** čaká sa na doručenku; dátum prevzatia výzvy neoverený
```

| Pole | Obsah |
|---|---|
| **Robil** | človek · nástroj (`MČ · Claude Code`, `MF · ručne`) — aby bolo jasné, čo písal agent a čo človek |
| **Čo sa dialo** | jedna veta, ľudsky |
| **Zmenené** | ktoré súbory a ktoré konkrétne položky — toto je tá auditná stopa |
| **Otvorené** | čo zostalo visieť; prázdne pole sa vynecháva |

### Append-only doslova

**Nové záznamy idú na koniec súboru. Staré sa needitujú nikdy.**

Nie je to len zásada — má to praktický dôsledok: `git diff` nad `CHANGELOG.md` je vždy iba pridanie riadkov. Akýkoľvek zásah do histórie je preto **viditeľný na prvý pohľad** bez toho, aby sme na to potrebovali nástroj.

### Kto to píše a kedy

Nikto nový a nič navyše. Do existujúceho **HARD GATE** v `AGENTS.md` *(partial `protokol-zapisu.md`)* pribudne jeden checkbox:

```markdown
- [ ] Zapísaný záznam do `CHANGELOG.md`? (čo sa dialo · čo sa zmenilo · čo zostáva otvorené)
```

Žiadny démon, žiadny cron, žiadna nová disciplína — protokol zápisu už funguje a má hard gate. Toto je jeho piaty riadok.

## Kondenzácia — vedome odložená

**Q10** požaduje kondenzáciu pamäte deň → týždeň → mesiac. Pre tento súbor ju **teraz nestaviame** a hovoríme to nahlas.

Dôvod: spis nazbiera za celý svoj život **desiatky záznamov, nie tisíce**. Mechanizmus, ktorý by ich zlieval, by bol drahší než problém, ktorý rieši — a každý takýto mechanizmus je ďalšia vec, ktorá sa môže pokaziť a ktorú treba udržiavať.

Namiesto neho stačí **pravidlo čítania** v `AGENTS.md`:

> Z `CHANGELOG.md` čítaj **posledných 5 záznamov**. Staršie len vtedy, keď hľadáš konkrétnu vec.

Kontext sa tým nenafúkne a nemáme čo udržiavať. **Spúšťač na prehodnotenie:** ak sa v praxi objaví spis s viac než ~100 záznamami, doplní sa mesačný rollup do `changelog/RRRR-MM.md`. Dovtedy nie.

## Čo sa musí zmeniť v `novy-spis`

Implementácia je v skille [`novy-spis`](0002-okf-operacny-system-praxe.md) (OKF v0.1), nie v appke:

| Kde | Zmena |
|---|---|
| `templates/spis/`, `templates/klient/`, `templates/projekt/` | nový `CHANGELOG.md` (prázdny, s hlavičkou) |
| `templates/partials/protokol-zapisu.md` | +1 riadok do hard gate · +pravidlo čítania posledných 5 |
| `scripts/new-spis.sh`, `new-klient.sh`, `new-projekt.sh`, `new-firma.sh` | zakladať súbor |
| `scripts/retrofit.sh` | doplniť starým entitám — **nedeštruktívne a idempotentné**, ako doteraz |
| `scripts/okf-validate.sh` | kontrola existencie súboru |

Bump OKF na **v0.2**.

## Čo to zatvára

- **Q13** — *„žiadne formálne metriky reconciliation; namiesto nich changelog session v OKF"*. Toto je ten changelog.
- **[#37](navrhy.md) (VŘ)** — auditovateľnosť zápisu do pamäte: pri každom zápise je stopa, kedy a pri akej práci vznikol.
- Časť odrážky **„Audit trail — kto/kedy/čo zapísal"** z checklistu [spec 0002](0002-okf-operacny-system-praxe.md).

Zápis vedie k reconciliation ([spec 0009](0009-reconcile-ucenie-z-uprav.md)) — `Zmenené` a `Otvorené` sú prirodzený vstup pre diff a pre návrh povýšenia poznatku.

## Čo tento spec **nerieši**

Aby bolo jasné, kde končí:

- ❌ **Brain celej praxe (L1)** — povýšený poznatok stále nemá kam padnúť. Samostatná téma.
- ❌ **Typované záznamy v `MEMORY.md`** (pravda × timeline podľa [mindmux vzoru](https://github.com/mindmuxai/brain.md)) — zvažované, odložené.
- ❌ **Vizualizácia** — mapa dokumentov a roadmap boarda z Granularu patria do UI vrstvy ([spec 0011](navrhy.md), PR [#55](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/55)), nie sem.
- ❌ **`BRAIN.md` ako rozcestník** — pri rozbore sa ukázalo, že v spise by dubloval `_STATUS.md`. Na úrovni praxe zmysel má, ale to je bod vyššie.

## Otvorené otázky

- [ ] **Názov súboru** — `CHANGELOG.md` podľa formulácie Q13, alebo `DENNIK.md` (zrozumiteľnejšie pre advokáta)? Na obsahu to nič nemení.
- [ ] **Zakladať ho aj klientovi a projektu**, alebo len spisu? *(návrh: všetkým — konzistencia je lacnejšia než výnimka)*
- [ ] **Multi-user** — keď na spise pracujú dvaja naraz, append-only súbor sa merguje dobre, ale poradie záznamov sa môže prehádzať. Nadväzuje na otvorenú multi-user otázku v [spec 0002](0002-okf-operacny-system-praxe.md).
- [ ] Má sa `CHANGELOG.md` písať **automaticky pri každom sedení**, alebo len keď sa reálne niečo zmenilo? *(návrh: len pri zmene — inak sa zaplní záznamami „nič sa nedialo")*
