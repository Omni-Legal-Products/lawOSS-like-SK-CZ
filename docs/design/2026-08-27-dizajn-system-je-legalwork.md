# Dizajn systém je LegalWork — integrácia namiesto paralelného sveta

- **Zostavil:** Marián Čuprík (MČ) s AI asistenciou · 2026-08-27 · podklad na call 28. 8. 17:00
- **Stav:** 📝 návrh na odklep — **koriguje** časť [dizajnového jazyka v2](2026-08-23-dizajnovy-jazyk-lawoss.md) a mockup stránky z fork PR #20
- **Podnet:** MČ po prezretí forku — *„rozhranie appky nie je MVP, je to slušný a veľký systém; vezmime existujúci a nevytvárajme môj oddelený“*

## 1 · Princíp (na odklep)

**LAWOSS dizajn systém = dizajn systém LegalWorku s našimi hodnotami.** Neforkuje sa, nestavia sa vedľa — preberá sa:

| Vrstva | Zdroj pravdy | Naša rola |
|---|---|---|
| Tokeny (`--lw-*`) | upstream `tokens.css` **+ naša value-only vrstva** `lawoss/theme/lawoss-tokens.css` (navy/zlatá/Plex, dark default) — **už merged, fáza A** | meniť len hodnoty, nikdy štruktúru |
| Komponenty | `@legalwork/ui` (36 primitív) + `@/components/ui` (shadcn/Base UI) + design-system vzory appky | **reuse first**; nový komponent len keď žiadny existujúci nesedí, a v ich idióme |
| Layout a shell | upstream sidebar, settings shell, side panel, artifact panel, command palette | naše pohľady žijú **vnútri** tohto shellu, nie vo vlastnom |
| Identita | čo ostáva naše: hodnoty tokenov, pečať/brána vzor, mikro-copy, brand (mark, názov) | identita cez tokeny a obsah, nie cez paralelný CSS svet |

Čo z jazyka v2 **ostáva v platnosti**: farby, písmo, „zlatá = rozhodnutie“, brána/pečať vzor, zákazy (žiadne pills/eyebrows/glow…), jeden diagram na pohľad. Čo sa **ruší**: vlastný `lw-desk` layout, vlastné registrové záložky ako náhrada shellu, vlastné button/row triedy tam, kde má appka ekvivalent.

## 2 · Mapa prekryvov: naše features × čo už v appke JE (overené v kóde 2026-08-27)

| Naša feature | Už existuje v LegalWorku | Čo reálne dopĺňame (delta) |
|---|---|---|
| **Prehľad praxe** | `dashboard.*` je workspace chooser, nie practice dashboard | ✅ nové — ale ako pohľad v shelli, z existujúcich primitív |
| **Spis + OKF Brain** | workspace = priečinok; `workspace-files-panel` (file browser); **markdown renderer** (`components/markdown`); artifact preview; `context_panel` (authorized folders) | interpretácia OKF `.md` súborov (spis.md/_STATUS.md/MEMORY.md/lehoty.md) do **jednotného zobrazenia v spise** — čítačka + panel, nie nová obrazovka |
| **Dokument s editáciou** | ✅ kompletné: `artifact-docx-editor` (tracked changes, suggesting podporované), text/spreadsheet editor | len prepínač suggesting (#29), meno advokáta (#31), onSave hook |
| **Reconcile / učenie** | **`learnings-route` + Learning v sidebari** — upstream už má „poučenia“ plochu | preskúmať a **nadviazať na Learnings**, nie stavať paralelný reconcile view (spec 0009 = náš protokol, ich plocha) |
| **Konektory (MCP)** | ✅ `settings › extensions/mcp` (mcp-view), connections store, OAuth modaly, connector katalóg modal | trust label, health/canary, lokálne nástroje (Autogram/OCR/Whisper), BYO — **rozšírenie existujúceho mcp-view**, nie nová stránka |
| **Marketplace (skills/pluginy)** | ✅ `settings › skills` (+ skill_resources), `plugins-view`, `extensions-view`, claude-plugin-import | náš registry (piny, allowlist) ako **zdroj v existujúcich views** |
| **Prompty/agent nastavenia** | ✅ `identities.*` (137 kľúčov! agent behavior, súbory agentov), `config-view` | LAWOSS profil advokáta a štýl = **rozšírenie identities/config**, nie vlastný tab-svet |
| **Lehoty + brána** | ✗ nič také | ✅ jediná úplne nová plocha — stavať z ich primitív (Card/Row/Badge idiom appky + naše tokeny) |
| **Firm hub** | `firm_hub.*` (66 kľúčov — team/usage) | pozor, nekolidovať pri „kancelária“ features |

**Dôsledok:** z pôvodných 4 „nových stránok“ sú reálne nové len **Prehľad** a **Lehoty**. Konektory a Marketplace = rozšírenia settings; Brain = interpretácia markdownov v spise; Reconcile = nadviazať na Learnings. Menší diff, menej údržby, viac synchronizácie s upstreamom.

## 3 · Čo s demom z PR #20

Mockup stránky ostávajú ako referencia smeru, ale **preintegrujú sa**: rovnaká téma a vizuál ako zvyšok appky (jej shell, jej primitívy), a pod tým sekcia **„Ukážka (demo)“** — jasne oddelená, kým ju fáza C nenahradí reálnymi dátami. Vlastný `lw-desk`/rail layout sa odstráni; `lawoss.css` sa zredukuje na pár vecí bez ekvivalentu (pečiatka NÁVRH, pás lehôt/timeline SVG, pečať). → issue vo forku.

## 4 · Pravidlo pre všetky budúce features (návrh na odklep)

> Pred návrhom čohokoľvek: **(1)** over v kóde, či plocha/feature v LegalWorku už neexistuje *(i18n namespaces sú rýchla mapa: dashboard, identities, firm_hub, learnings, skills, mcp…)*; **(2)** ak existuje — rozšír ju; **(3)** ak nie — postav ju z ich primitív v ich shelli; **(4)** vlastný komponent/CSS len na to, čo nemá ekvivalent, a zapíš prečo.

Sedí to s AGENTS.md („small downstream diff“, „use components from @/components“) aj s upstream-first (ADR 0004). Markdown OKF súbory sa interpretujú do jednotného rozhrania spisu — appka je čítačka a brána nad nimi, formát ostáva prenositeľný.

## 5 · Na zajtrajší call

1. Odklep princípu §1 + pravidla §4.
2. Odklep mapy §2 (najmä: Reconcile cez Learnings? Konektory/Marketplace v settings?).
3. Rozdelenie features (každý jednu, na branchi): **Lehoty+brána** · **Spis/Brain čítačka OKF** · **Konektory rozšírenie** · **Marketplace/registry** · (editor #29/#31 — MF už má PR #15).
4. Kto preintegruje demo (§3).

<sub>Prekryvy overené čítaním kódu forku `dev` 2026-08-27 (i18n namespaces, domains/, artifacts/, panel/). </sub>
