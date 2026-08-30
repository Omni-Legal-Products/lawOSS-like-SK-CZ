# Zadanie: technická implementácia OKF do LAWOSS

- **Stav:** architektonické zadanie, návrh ešte nie je odklepnutý
- **Zadal:** Marián Čuprík (MČ)
- **Dátum:** 2026-08-31
- **Priorita:** prvá implementačná vertikála LAWOSS
- **Nadväzuje na:** [spec 0014](../specs/0014-okf-1-kanonicky-kontrakt.md), [porovnanie MČ a VŘ](../research/okf-implementacie/porovnanie-a-konsolidacia-2026-08-31.md), [dizajn systém](../docs/design/design-system.md)

> [!IMPORTANT]
> Tento súbor eviduje zadanie, overený stav a ďalšiu prácu. Neobsahuje schválenú technickú architektúru ani oprávnenie implementovať produktový kód.

## Čo sa otvorilo

LAWOSS má technicky a produktovo rozpracovať OKF ako svoj fundamentálny systém práce s klientmi, prípadmi a agentickou pamäťou. Výstup musí pokryť:

1. portable OKF Core nad otvorenými súbormi,
2. bezpečnú integráciu do existujúceho servera, desktop aplikácie a agentového runtime,
3. detekciu, onboarding a retrofit klientskych priečinkov,
4. read model a file watcher bez druhého zdroja pravdy,
5. schvaľovacie brány pre právne významné zápisy,
6. dashboard klienta a prípadu renderovaný z OKF súborov,
7. timeline, lehoty, kalendár, subjekty, zásadné udalosti, úlohy, findings a provenance,
8. grafický a UX návrh použiteľný pre ne-technického advokáta,
9. SK a CZ lokalizáciu nad jedným machine contractom,
10. testovaciu, migračnú a rollout stratégiu.

## Overený stav produktu k 2026-08-31

Overené lokálne v produktovom forku `/Users/Magneto/PROJECTS/MikeOSS-SLOVAKIA-AI/LAWOSS`, vetva `dev`, commit `4ca4a4f`:

- LAWOSS je React 19 a TypeScript aplikácia nad existujúcim LegalWork shellom.
- Server už pracuje s lokálnymi workspace-mi a má registrované `/workspace/:id/*` API.
- Existuje workspace import s preview, fingerprintom a approval cestou, ktorý je vhodný precedens pre OKF `plan -> approve -> apply`.
- Existuje file watcher a reload event infraštruktúra. Treba ju rozšíriť o OKF invalidáciu, nie stavať druhý všeobecný watcher.
- Existuje auditná infraštruktúra a permission approval modal.
- Upstream aplikácia má workspace provider, session shell, sidebar, file panel a editor artefaktov.
- LAWOSS má pasívne mockup routy `Prehľad`, `Lehoty`, `Konektory` a `Marketplace`. Podľa záväzného dizajn systému nie sú vzorom výslednej integrácie.
- Reálny OKF read model, klientský model a dashboard ešte nie sú implementované.
- Produktový PR #24 je prototyp typovanej pamäte. Nie je integrovaný do appky a nie je kanonickým OKF 1.0.

## Pevné hranice návrhu

- Zdroj pravdy zostáva v OKF súboroch pri klientovi a prípade.
- `AGENTS.md` je kanonický bootstrap, `CLAUDE.md` je mirror a `BRAIN.md` je odvodený.
- LAWOSS môže držať cache, read model, UI stav a krátkodobé approval tokeny, nie paralelnú pravdu spisu.
- UI nesmie zapisovať Markdown vlastnou cestou. Mutácia ide cez OKF Core a schválený write plan.
- Observation, indexácia a findings môžu byť automatické. Identita, lehoty, právna kvalifikácia, stratégia, L1, L3 a mazanie vyžadujú človeka.
- Existujúci LegalWork shell a jeho komponenty sa rozširujú. Nový paralelný aplikačný shell sa nestavia.
- Produktový kód patrí do forku LAWOSS až po odklepnutí technického specu v tomto koordinačnom repozitári.

## Verejne overená inšpirácia Granular

Verejné materiály Granular k 2026-08-31 ukazujú tieto relevantné vzory:

- lokálny projekt ako workspace nad reálnymi súbormi,
- projektový brain z prepojených Markdown poznámok,
- list a map view dokumentov,
- krátky front-door dokument s detailom v susednom paneli,
- roadmap board odvodený z projektových súborov,
- chat, terminál, preview a docs ako prepojené pracovné plochy,
- viditeľné agentové akcie a preview pred zásahom.

Zdroj: [Granular produkt](https://granular.build/), [Granular dokumentácia](https://granular.build/docs/), [company brain](https://granular.build/use-cases/company-brain/), overené 2026-08-31.

Tieto vzory sú inšpirácia, nie licencia na kopírovanie dizajnu alebo proprietárnej implementácie. LAWOSS potrebuje právnickú informačnú architektúru, provenance a human gates, ktoré Granular verejná ukážka nerieši.

## Čo sa musí navrhnúť

### Technika

- umiestnenie balíka OKF Core v monorepe a jeho verejné TypeScript API,
- canonical schema, parser, preservation neznámych polí a version gates,
- detect, init, retrofit, plan, apply, validate, reconcile, migrate a render,
- serverové služby, endpointy, eventy, audit a approval tokeny,
- read model a cache invalidácia,
- workspace a client/matter routing,
- registry provider kontrakt,
- agentové tools a bezpečný write protocol,
- zlyhania po súboroch, atomicita, optimistic concurrency a recovery,
- testovacia pyramída, fixtures, migrácia a feature flags.

### UI a UX

- informačná architektúra kancelária -> klient -> prípad,
- prvý dashboardový vertical slice,
- matter overview, client overview a neskôr practice overview,
- timeline a lehota ako rozdielne, ale prepojené pohľady,
- kalendár, subjekty, dokumenty, úlohy, decisions, findings a audit,
- source-to-UI trace a otvorenie pôvodného Markdown súboru na riadku,
- karta brány s presným diffom a vetou, čo sa zapíše a kam,
- empty, partial, stale, parse-error, future-version a offline stavy,
- keyboard, accessibility, reduced motion a SK/CZ lokalizácia.

## Prvé rozhodnutie

Treba určiť prvý end-to-end vertical slice:

1. **prípadový dashboard**, ktorý číta jeden matter root a rieši celý tok od parsera po UI,
2. **klientský dashboard**, ktorý agreguje viac prípadov jedného klienta,
3. **prehľad celej praxe**, ktorý agreguje všetkých klientov a prípady.

Odporúčaný je prípadový dashboard. Má najmenší bezpečný scope, overí celý kontrakt a vytvorí základ, z ktorého sa klientský a kancelársky pohľad neskôr iba agregujú.

## Ďalšie kroky

- [ ] MČ potvrdí prvý vertical slice.
- [ ] Porovnať tri technické prístupy a odklepnúť odporúčaný.
- [ ] Prejsť návrh po sekciách: architektúra, data flow, write gates, UI/UX, chyby, testy a rollout.
- [ ] Zapísať schválený technický spec a samostatnú interaktívnu UI vizualizáciu.
- [ ] Vykonať LAWOSS spec review.
- [ ] Po tímovom odklepnutí vytvoriť implementačný plán a issues vo forku.

## Explicitne nerozhodnuté

- prvý dashboardový vertical slice,
- konečná fyzická hranica L1 kancelárskeho brainu,
- konkrétny storage engine read modelu,
- presný shape API a eventov,
- konkrétne Basic registry providers,
- či sa PR #24 upraví alebo sa jeho použiteľné časti prenesú do nového core,
- finálny layout dashboardu a jeho navigácia v session shelli.
