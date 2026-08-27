# Zápis: quick call 27. 8. 2026 — zosúladenie postupu: najprv dizajn, potom implementácia

- **Prítomní:** MČ · IR · VŘ *(MF neprítomný — MČ ho informuje)*
- **Podklad:** [podklad na call](../planning/2026-08-27-podklad-call-kickoff-vyvoja.md) · mockupy v README a [docs/design](../docs/design/) · mockup pohľady priamo vo forku (merged PR #16–#20)
- **Zdroj:** transkript callu (lokálne u MČ), zapísané 2026-08-27

## Závery

1. **Najprv dizajn, potom implementácia.** Zhoda (návrh IR: ustáliť vzhľad na mockupoch, aby sa neprerábala funkcionalita; MČ pôvodne preferoval rovno produkciu — prijal poradie: mockupy → odklep smeru → design systém → features). Nejde o „demá“: mockup pohľady sú už vo forknutej appke a testuje sa na reálnych kópiách spisov cez OKF (git = rollback).
2. **Smer vizuálu na posúdenie tímom:** dark mode so zlatými akcentmi, „profi aplikácia, nie vygenerované kódom“ — každý si pozrie mockupy (koordinačné repo README + appka) a vyjadrí sa.
3. **Design systém = source of design truth.** Po odklepnutí smeru sa design systém záväzne implementuje a **všetky features sa stavajú v ňom** (podklad: [dizajnový jazyk v2](../docs/design/2026-08-23-dizajnovy-jazyk-lawoss.md) + `lawoss/theme/lawoss-tokens.css` vo forku).
4. **Rozdelenie práce:** každý člen si vezme **jednu feature zo sidebaru** a robí ju na svojom branchi; merge do testovacích vetiev, potom do hlavnej. Kto chce vstúpiť do cudzieho branchu, dohodne sa s vlastníkom feature a pracuje vo **worktree**. **MČ maintainuje a merguje.** Pravidlá spolupráce sú v repách (AGENTS.md + playbook) — agent si ich načíta sám.
5. **Pravidelná komunikácia** je podmienka MČ — priebežné cally/odklepy, nie tiché rozhodnutia.

## Nápady zaznamenané z callu

- **TUI (Terminal User Interface)** ako alternatíva k Electron appke pre používateľov, ktorí preferujú terminál → [`planning/napady.md` #49](../planning/napady.md).

## Akčné body

- [ ] **IR** — pozrieť mockupy (README + appka) a napísať pripomienky async v priebehu 28. 8. *(zajtra je celý deň mimo)*
- [ ] **VŘ** — pozrieť mockupy; **call zajtra 28. 8. o 17:00** k overall design systému (bude na cestách, pripojí sa)
- [ ] **MČ** — informovať MF o dohodnutom postupe; pozvať ho na call 28. 8.
- [ ] **MČ** — po odklepe smeru pripraviť rozpis features zo sidebaru na rozdelenie (Prehľad/OKF · Lehoty · Konektory · Marketplace + editor/reconcile)
- [ ] **všetci** — naklonovať si obe repá; od 2. septembrového týždňa sa začína naplno

<sub>Zapísal MČ s AI asistenciou z transkriptu 2026-08-27.</sub>
