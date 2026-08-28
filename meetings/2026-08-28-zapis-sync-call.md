# Zápis: call 28. 8. 2026 — dizajn odklepnutý, OKF ako feature #1, onboarding a light verzia

- **Prítomní:** MČ · VŘ · MF *(IR neprítomný — tento zápis + Telegram post sú pre neho; privíta sa jeho vyjadrenie k čomukoľvek nižšie)*
- **Podklady:** [agenda](2026-08-28-agenda-call-dizajn.md) · [Dizajn systém je LegalWork](../docs/design/2026-08-27-dizajn-system-je-legalwork.md) · [návrhy loga](../assets/brand/loga-navrhy/) · zdroj: transkript callu (lokálne u MČ), zapísané 2026-08-28

## Rozhodnutia

1. **Dizajnový smer odklepnutý.** Interface ostáva čo najbližšie LegalWorku („profi“); ich členenie konektory/skills/plugins sa páči a preberá sa. Individualizácia LAWOSS je primárne **systém v pozadí** (OKF, pamäť, agenti), nie prepisovanie ich UI — meníme tokeny/fonty/elementy a pridávame features, štruktúru nechávame kvôli upstream syncu. *(VŘ: dva nezávislé návrhy došli k rovnakému výsledku — dobrý signál.)*
2. **Tokeny: hranaté namiesto zaoblených.** MČ preferuje hranatejšie rohy („aspoň sa odlíšime“), VŘ súhlas → úprava radius hodnôt v `lawoss/theme/lawoss-tokens.css` (value-only). → issue vo forku.
3. **Globálna settings stránka pre prompty/personalizáciu agentov** — dnes je v appke málo „surface“ pre prompty (LegalWork rieši všetko cez skills). Tri cesty personalizácie (VŘ): skills · systémový prompt · personalizačný príkaz; najčistejší je **systémový prompt**. Model: **personalita a štýl komunikácie globálne** (onboarding), **spôsob práce per spis/kauza**; zvážiť klasifikáciu káuz (trestné · obchod · rodinné → iné pravidlá).
4. **Normálna + light verzia.** MF: 90 % advokátov sa v plnom rozhraní stratí; VŘ: nezahadzovať starších — „mysleli sme aj na vás“, sú kúpna sila. Dohoda: **primárne staviame plnú („normálnu“) verziu agent-first bez systémových kompromisov**; **light verzia + jednoduchý onboarding (klik-klik, pár obrazoviek, videá)** sa spraví ako add-on pred verejným spustením, možnosti poskrývané. Bloomberg analógia: light terminál / plný terminál.
5. **OKF systém = feature #1** a hlavné odlíšenie („operačný systém“, Obsidian-štýl pamäť a prepojenia). Cieľová UX: klik na klienta/spis → **dashboard renderovaný live z OKF markdownov**; nastavenia OKF = klikateľné config súbory. Dva workflowy: (a) nový folder → automatické vytvorenie štruktúry, (b) **retrofit existujúceho foldra**.
6. **Podpisovanie:** engine z autogram-macOS (DSS knižnice Európskej komisie, open source) sa **bude integrovať minimálne na autorizáciu/podpisovanie** (XAdES/PAdES, kvalifikované časové pečiatky, vizuálny podpis, výber certifikátu; mandátny certifikát default pri konverzii). **Zaručená konverzia** = možná neskoršia feature (SK platia appky ~20 €/mes.; CZ výskum VŘ — tam viazané na token/zariadenie), nie teraz.
7. **Marketplace:** oficiálny marketplace s defaultnými skills a MCP; MČ má v organizácii ~14–17 MCP serverov (aj s OAuth pre remote). Pri SK/CZ onboardingu sa integrujú príslušné pre jurisdikciu.
8. **Windows:** vlastní IR; VŘ odporúča **WSL** (izolovaný sandbox, iba preklad ciest) namiesto natívneho Windows behu.
9. **Logo — zatiaľ nerozhodnuté.** Zhoda na **fonte wordmarku z návrhov 11–14** a na shortliste značiek **3 · Konštelácia, 4 · Orbita, 11 · Labyrint, 13 · Kľúč** → ďalšie kolo: kombinácie shortlist značiek s tým fontom. *(Detail v [loga-navrhy/README](../assets/brand/loga-navrhy/README.md).)*
10. **Accessibility/HIG (MF):** áno ako súčasť design systému (kontrast, prístupnosť), ale žiadne prepisovanie na Apple HIG/Material — držíme upstream.

## Akčné body (do utorka 1. 9., call 10:30)

- [ ] **MČ** — dopracovať dizajnové tokeny (vrátane hranatých rohov) a finalizovať design systém; nahrať **svoju OKF implementáciu** (skill `novy-spis`) do koordinačného repa
- [ ] **VŘ** — nahrať **svoju implementáciu pamäťového systému** do koordinačného repa → spoločne zjednotiť s MČ verziou (zápis/čítanie pamäte agentmi je prvá vec na odladenie)
- [ ] **MF** — rozpracovať v koordinačnom repe **koncept onboardingu + light verzie** (ako má vyzerať zjednodušený view, defaultné skills, defaultné MCP, defaultné nastavenia); otestovať OKF na testovacom foldri na Macu
- [ ] **MČ** — fork issue „hranaté tokeny“ + naďalej synchronizuje fork
- [ ] **IR** *(async)* — pozrieť zápis + shortlist loga; Windows stratégia (WSL?) — vyjadriť sa
- [ ] **všetci** — práca na branchoch + worktrees podľa [playbooku](../docs/playbook-spolupraca.md)

**Ďalší call: utorok 1. 9. 2026 o 10:30** *(VŘ ešte potvrdí — prvý deň školy)*. Očakávané: OKF zjednotené a funkčné, MF koncept onboardingu/light.

<sub>Zapísal MČ s AI asistenciou z transkriptu 2026-08-28.</sub>
