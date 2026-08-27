# Podklad na call 27. 8. 17:00 — kick-off vývoja: čo je hotové, rozdelenie práce, ako pracujeme

- **Zostavil:** Marián Čuprík (MČ) s AI asistenciou · 2026-08-27
- **Cieľ callu:** odklepnúť dizajnový smer (PR #62), rozdeliť prácu, dohodnúť pracovný režim (vetvy, worktrees, review) — a **dnes začať**.

## 1 · Stav k 15:50 (overené)

| Čo | Stav |
|---|---|
| Upstream | žiadny nový release tag po `v0.1.13`; `upstream/dev` +1 commit (790af25, MCP logout fix #87) |
| **Sync** | [lawoss PR #16](https://github.com/Omni-Legal-Products/lawoss/pull/16) — `sync/upstream-2026-08-27`, bez konfliktov, typecheck ✅ → **review IR** |
| **Fáza A (skin)** | [lawoss PR #17, draft](https://github.com/Omni-Legal-Products/lawoss/pull/17) — `design/faza-a-tokeny`: token override, IBM Plex, dark default; overené v behu (`--lw-canvas #0A0E14`, zlatý akcent, Plex). **Draft do odklepu #62** |
| Dizajn | [koordinačný PR #62](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/62): jazyk v2 „podací denník na tmavom stole“, IA (chat v strede + panel), plán A–E, prototyp 5 pohľadov, playbook — **na odklep dnes** |
| Fork issues | #5–#12 (paper cuts P1–P3) otvorené; PR #13–#15 od MF čakajú na review — **#15 (meno advokáta v DOCX) sa prekrýva s C8** — doriešiť, kto to vlastní, skôr než sa niekto pustí do editora |

## 2 · Na odklep (10 min)

1. **PR #62** — dizajnový smer + rozsah v2 (body „Na prerokovanie“ v PR, najmä: iba tmavá téma, IBM Plex → brand concept, locale stratégia, `PATCHES.md` ≤ 11).
2. **Sync pravidlo:** tagy sú preferované, ale kým upstream netaguje, sync z `upstream/dev` ako doteraz (precedens c5e177a). Áno/nie?
3. **PR #16** merge (po review IR) → potom rebase #17 a undraft.

## 3 · Návrh rozdelenia práce (od dnes)

| Kto | Úloha | Vetva | Odkaz |
|---|---|---|---|
| **MČ** | Fáza A dokončiť (screenshoty A1/A8, merge po odklepe) → Fáza B záložky + routy (B1–B4) → upstream PR „tokenize colors“ (A9) | `design/faza-a-tokeny`, `design/faza-b-shell` | plán §1–2 |
| **MF** | review PR #16/#17 tech; DOCX editor: dokončiť svoj #15 + suggesting režim (#7/C8) — **jeden vlastník celého editora**; potom lehoty doména (spec 0005, C3) | `feat/docx-editor`, `feat/lehoty` | plán §3 |
| **IR** | review sync #16; **Windows overenie Fázy A** (Plex rendering, škálovanie); skill `lehoty-sk` (#33) pripraviť na C3; MCP health pre hub (C6) | `feat/lehoty-sk-skill` | plán §3, issue #41 |
| **VŘ** | `cs.ts` strana locale kostry (B6, issue #10) + CZ copy review prototypu; CZ vrstva marketplace položiek (lehoty-cz) | `loc/cs-locale` | plán §2 |

Locale (B6): rozhodnúť stratégiu voči `ci-i18n.yml` — návrh: kompletný strojový preklad + ľudská korektúra kľúčových obrazoviek (MČ SK / VŘ CZ).

## 4 · Ako pracujeme (zhrnutie playbooku — [celý tu](../docs/playbook-spolupraca.md))

- **Fork:** nikdy priamo do `dev`; vetvy `design/*` `feat/*` `fix/*` `loc/*` `sync/*`; PR = 1 approval + zelené CI; 🟡 zásah = riadok v `PATCHES.md` v tom istom PR (reviewuje MČ); UI PR = screenshot.
- **Worktrees:** jedna worktree na úlohu/AI session: `git worktree add ../lawoss-<uloha> <vetva>` — aby si agenti nešliapali po priečinku. Po merge `git worktree remove`.
- **Jeden súbor = jeden vlastník naraz** — pred začatím pozri otvorené PR (dnešný prípad: #15 vs C8).
- **AI agenti:** každý agent začína protokolom „prvých 5 minút“ z playbooku §2 (AGENTS.md, zóny, zdroj úlohy, ohlásenie).
- Väčšiu prácu ohlás v Telegrame (General CHAT); merge ≠ odklep; ticho ≠ súhlas.

## 5 · Po calle (mechanika, ~15 min, spraví MČ/agent)

1. Merge #16 → rebase #17 → undraft → merge po review.
2. Založiť issues vo forku pre B1–B7 a C1–C8 s odkazmi na plán + labely `fáza A/B/C`, `zóna 🟡`, `SK/CZ`, `windows`, `design-review`.
3. Zapísať odklepy z callu do zápisu `meetings/2026-08-27...md` + aktualizovať stav v PR #62.

---

<sub>Fakty overené 2026-08-27 (git fetch, gh api). Odhady orientačné.</sub>
