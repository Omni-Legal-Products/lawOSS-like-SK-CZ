# Paper cuts a rýchle vylepšenia — report na víkend

- **Dátum:** 2026-08-21
- **Pre:** tím (MF · IR · VŘ) — plní akčný bod MČ z [callu 18. 8.](../meetings/2026-08-18-zapis-sync-call.md): *„zosumarizovať paper cuts a naplánovať roadmapu implementácie do konca týždňa"*
- **Cieľ:** vyriešiť dnes / cez víkend, aby **v pondelok 24. 8.** mohol začať oficiálna vývoj na LAWOSS forku
- **Overenie:** všetky zistenia overené v kóde forku `Omni-Legal-Products/lawoss` (`dev` @ `c5e177a`, sync s upstreamom vrátane #88) **2026-08-21**

## Stav forku (ráno 21. 8.)

- `dev` je synchronizovaný s upstreamom `eigenweltlabs/legalwork` (`v0.1.13` + ich fix #88) aj s našimi 10 commitmi (Telegram notifikácie, docs, PATCHES.md)
- Naše zásahy do upstream súborov: zatiaľ len README.md a AGENTS.md — **merge dlh nulový**, máme čisté ihrisko

## 🔴 P1 — dnes (blokátory každodennej práce advokáta)

| # | Papercut | Kde v kóde *(overené)* | Rozsah | Ako |
|---|---|---|---|---|
| [#30](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues) | Zavádzajúca hláška pri priložení `.docx` — tvrdí *„format the model can't read"*, hoci appka má Word editor; má nasmerovať na workspace | `session-surface.tsx:1149` · `usechat-adapter.ts:54` | **~15 min**, zmena reťazca | upstream PR |
| [#31](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues) | Meno advokáta — tracked changes aj komentáre sa podpisujú natvrdo **„Legal Cowork"** (`author = "Legal Cowork"` default, nikdy sa neposiela); appka nemá nastavenie mena | `artifact-docx-editor.tsx:87` | **2–3 h**: pole v nastaveniach + prepojenie do editora | žltý zásah → PATCHES.md |
| [#29](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues) | Režim sledovania zmien nedostupný — `mode={readOnly ? "viewing" : "editing"}` je natvrdo; editor podporuje `suggesting`, ale UI ho nikdy nezapne | `artifact-docx-editor.tsx:208` | **1–2 h**: prepínač režimu v artifact panely + indikátor | žltý zásah / upstream PR |

## 🟡 P2 — víkend

| # | Vylepšenie | Kde | Rozsah | Ako |
|---|---|---|---|---|
| [#28](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues) | Zoraďovanie súborov vo workspace browseri — panel nemá **žiadny sort** (overené: 0 výskytov) | `workspace-files-panel.tsx` (258 riadkov, self-contained) | **pol dňa**: sort ovládanie do toolbara + persist per workspace | upstream PR (univerzálna funkcia) |
| [#32](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues) | Nomenklatúra pomenovania súborov — konvencia v nastaveniach + skill „usporiadaj spis" | agent vrstva, nie appka | **pol dňa** (skill + prompt) | 🟢 zelená zóna |

## 🟢 P3 — paralelne (nezavislé od UI)

| Čo | Poznámka |
|---|---|
| **SK/CZ locale kostra** (`sk.ts`, `cs.ts`) | nové súbory = nulový konflikt; pozor: ich `ci-i18n.yml` kontroluje kompletnosť prekladov — buď kompletne preložiť, alebo dohodnúť s upstreamom postupný nástup. Ideálny **prvý upstream PR** (ADR 0004 pravidlo č. 4) |
| **Opencode bump `v1.17.18` → `v1.18.20`** | **overené 21. 8.: SDK diff je čisto additívny** (7 riadkov typov). Ale: plán forku dáva bump do 🔴 zóny → treba mini ADR amendment (nápad [#48](napady.md)); samotný bump ~1 h + smoke test |

## Rozdelenie (návrh)

| Kto | Čo |
|---|---|
| **MČ** | #30 (reťazec) + opencode bump ADR + upstream PR koordinácia |
| **MF** | #31 (meno advokáta — settings + editor wiring) |
| **IR** | #29 (suggesting toggle) + Windows sanity check |
| **VŘ** | #32 (nomenklatúra skill) + CZ strana locale kostry |

> Každý si merguje svoje PR a nesie za ne zodpovednosť (Q05). Zásah do upstream súboru = riadok v `PATCHES.md` v tom istom PR.

## Definícia „hotovo pre pondelok"

- [ ] P1 (#30, #31, #29) merged vo forku, `PATCHES.md` aktualizované
- [ ] ADR amendment k opencode bumpu zapísaný (implementácia môže nasledovať)
- [ ] Locale kostra rozhodnutá (kompletné vs. postupné)
- [ ] Všetci majú funkčný lokálny build a zapisujú ďalšie paper cuts počas víkendového používania

---

<sub>Sestavil AI agent pre MČ, 2026-08-21. Všetky tvrdenia o kóde overené grepom/čítaním zdrojov forku `lawoss@dev` (`c5e177a`). Rozsahy sú odhady.</sub>
