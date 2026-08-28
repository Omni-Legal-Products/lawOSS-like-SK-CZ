# Agenda: call 28. 8. 17:00 — odklep dizajnového smeru + rozdelenie features

- **Pripravil:** MČ s AI asistenciou · 2026-08-28 · nadväzuje na [zápis z 27. 8.](2026-08-27-zapis-quick-call.md)
- **Cieľ:** odklepnúť smer a design systém, vybrať logo (alebo zúžiť), rozdeliť features — od budúceho týždňa sa implementuje.

## Scenár so zdieľaním obrazovky (~45 min)

### 1 · Logo (10 min) — Telegram + GitHub
- Telegram › General CHAT: 2 albumy + **2 ankety** (výsledky hlasov naživo)
- Popisy a príbehy: https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/tree/main/assets/brand/loga-navrhy
- Rozhodnúť: víťaz / užší výber 2–3 na prekreslenie do SVG. *(IR pripomienka k váham — návrh 10 „Mandát“ ich nesie len ako obrys.)*

### 2 · Smer vizuálu (5 min) — mockupy
- 10 marketingových mockupov: https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/tree/main/assets/brand/mockupy
- Klikateľný hi-fi prototyp (5 pohľadov, brána + pečať, reconcile): https://htmlpreview.github.io/?https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/design/redesign-plan/docs/design/hifi/lawoss-hifi.html
- Otázka: „dark + zlatá, profi“ — OK ako smer?

### 3 · Živá appka (10 min) — LAWOSS.app (build `dev` @ 4ca4a4f)
- Ukázať: LAWOSS branding a ikona · dark default · slovenčina (Nastavenia › Appearance) · demo pohľady Prehľad / Lehoty / Konektory / Marketplace (pečiatka NÁVRH) · reálny chat pod „Asistent“
- Kto chce doma: `git pull && pnpm install && pnpm dev`

### 4 · Design systém — hlavný odklep (10 min)
- **[Dizajn systém je LegalWork](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/design/redesign-plan/docs/design/2026-08-27-dizajn-system-je-legalwork.md)** — §1 princíp (ich systém + naše hodnoty), §2 mapa prekryvov (reálne nové sú len Prehľad a Lehoty), §2b reconcile v toku práce, §4 reuse-first pravidlo
- Referencie: [dizajnový jazyk v2](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/blob/design/redesign-plan/docs/design/2026-08-23-dizajnovy-jazyk-lawoss.md) · tokeny v kóde: https://github.com/Omni-Legal-Products/lawoss/blob/dev/lawoss/theme/lawoss-tokens.css
- Diskusia + odklep: [PR #62](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/62)

### 5 · Rozdelenie features (8 min)
| Feature | Návrh vlastníka | Podklad |
|---|---|---|
| Lehoty + brána | MF *(spec 0005 je jeho)* + IR skill `lehoty-sk` (#33) | plán C3 |
| Spis / OKF Brain čítačka | MČ | plán C1–C2, spec 0011 |
| DOCX editor (#29/#31) + reconcile hook | MF *(už má fork PR #15!)* | plán C5/C8 |
| Konektory rozšírenie mcp-view | IR | plán C6 |
| Marketplace / registry + CZ vrstva | VŘ | plán C7, spec 0011 B |
| Preintegrácia dema do shellu | MČ / dobrovoľník | fork issue [#21](https://github.com/Omni-Legal-Products/lawoss/issues/21) |

Pravidlá: každý na svojom branchi, worktrees pri zdieľaní, 1 approval + CI, MČ merguje 🟡 a sync ([playbook](../docs/playbook-spolupraca.md)).

### 6 · Rest (2 min)
- Fork PR #13–#15 (MF) čakajú na review — #15 sa prekrýva s C8, doriešiť vlastníctvo editora
- Locale: jadro SK/CZ je v appke (278 kľúčov), dopĺňa sa postupne; CZ korektúra VŘ
- Nápad #51 TUI (VŘ) zaznamenaný
- Otvorené PR koordinácie: #54 (ADR 0011 — čaká IR), #55 (spec 0011), #62 (dizajn)

## Očakávané výstupy
1. Logo: víťaz alebo shortlist. 2. Smer vizuálu: áno/nie. 3. Design systém §1+§4: odklep → merge PR #62. 4. Features rozdelené s menami. 5. Termín ďalšieho callu.
