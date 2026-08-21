# Spec 0011: Rozširujúca vrstva LAWOSS — UI architektúra a konektory

- **Stav:** 📝 spec · návrh na odklep *(sync call streda)*
- **Navrhol:** Marián Čuprík (MČ) · 2026-08-21
- **Súvisiace:** [ADR 0004](../decisions/0004-ako-rozsirit-legalwork.md) *(tri zóny forku)* · [ADR 0008](../decisions/0008-sprava-mcp-repozitarov.md) *(správa MCP repozitárov)* · [spec 0002 OKF](0002-okf-operacny-system-praxe.md) · [spec 0004 MCP konektory](0004-mcp-sk-konektory.md) · [spec 0005 lehoty/timeline](0005-lehoty-timeline.md) · [zberný kôš #45](../planning/napady.md) *(samoúdržba)* · [#48](../planning/napady.md) *(opencode sync pipeline)* · [zápis callu 18. 8.](../meetings/2026-08-18-zapis-sync-call.md) *(Q07 vertikály, Q11/Q21 autonómia, Q16 lokálnosť)*

> [!NOTE]
> Fakty o UI štruktúre LegalWorku boli overené v kóde upstreamu `eigenweltlabs/legalwork` **2026-08-21** (adresár `apps/app/src/react-app/`). Ide o verziu `v0.1.13`; pri synce treba overiť, že napojovacie body stále platia.

## Problém

V1 scope z callu 18. 8. (OKF/spisy + pamäť, lehoty a timeline, reconciliation) je z ~90 % v zelenej zóne forku — skills, prompty, šablóny. Chýba však odpoveď na tri otázky:

1. **Kde v UI žije naša funkcionalita?** Nastavenie modularity OKF, meno advokáta, nomenklatúra súborov, default autonómia — to všetko potrebuje miesto v nastaveniach, inak z toho bude rozhádzané tlačidlo vedľa každého tlačidla.
2. **Ako sa používateľ dostane k timeline a kalendáru lehôt?** V appke nie je mermaid renderer *(overené — `apps/app` nemá mermaid závislosť)*, takže vizualizácia nemôže ísť cez markdown v chate.
3. **Ako sa pripájajú MCP servery, od ktorých skills závisia?** Subjektový research vyžaduje RPVS, ORSR, register úpadcov, Finančnú správu. Zároveň používatelia (vrátane MČ) majú **vlastné remote servery**, ktoré chcú používať namiesto našich.

## Časť A — UI architektúra

### Princíp: jeden vstupný bod, nie tlačidlá po celom UI

LegalWork má štyri hotové rozšíriteľné UI povrchy. Naše V1 funkcie sa zmestia do troch drobných registrácií:

| Povrch | Overený stav v upstreamu | Naše využitie | Merge cena |
|---|---|---|---|
| **Settings** | `settings-page.tsx` má dátový zoznam tabov (`ai`, `account`, `safety`, …), podmienene rozširovaný | nový tab `lawoss` | 1 riadok v zozname + nový súbor |
| **Bočný panel** | tab-based (`panel-tab-store`, `useSidePanelTabs`) — súbory, artifacty aj browser sú len taby | fáza 2: tab „Lehoty" | nový komponent + pár riadkov registrácie |
| **Command palette** | existujúci `command-palette.tsx` s akciami | „Nový spis", „Usporiadaj spis" | pár riadkov |
| **Artifact preview** | renderuje interaktívne HTML artefakty (`preview.tsx`) | fáza 1: timeline/kalendár | **0 riadkov** |

### Settings tab „LAWOSS"

Jedno miesto pre všetko naše:

- **Meno advokáta** *(nápad #31)* → author prop pri tracked changes a komentároch
- **Nomenklatúra pomenovania súborov** *(nápad #32)*
- **Default autonómia** pre nové spisy *(Q11/Q21 — od schvaľovania každého kroku po YOLO)*
- **Default výstupný formát** dokumentov *(Q25 — PDF/HTML/markdown pred Wordom)*
- **Konektory** — viď časť B

Per-spis nastavenia do globálneho UI nepatria — tie žijú v `lawoss.config.md` priamo v spise *(agent ich číta, UI ich len zobrazí)*.

### Nový spis — agent-driven wizard, nie formulár

Vstupný bod: command palette akcia „Nový spis". Ďalej **skill, nie UI kód**: wizard sa pýta cez existujúce question modaly appky *(typ spisu, subjekty, režim preverovania light/medium/hard podľa Q14, zapnuté moduly)* a na základe odpovedí vygeneruje štruktúru OKF + `lawoss.config.md`. Sedí to na doktrínu z callu: *„aplikácia pre AI agentov, UI len interface na manažment práce tých agentov."*

Modularita OKF = **config, nie UI**: zapnuté moduly spisu sú riadky v `lawoss.config.md`, čitateľné agentom aj ľuďmi. Do settings patrí len globálny default pre nové spisy.

### Timeline a kalendár — dve fázy

- **Fáza 1 (V1, 0 riadkov UI kódu):** lehoty sa ukladajú štruktúrovane — `lehoty.md` s JSON front-matter v spise. Skill generuje **interaktívny HTML timeline/mesačný kalendár ako artifact**, ktorý sa otvorí v existujúcom preview. Dáta zostávajú v lokálnom markdowne (Q16/Q17 — žiadna databáza, žiadny index).
- **Fáza 2 (neskôr, ak HTML nestáčí):** natívny panel tab „Lehoty" — vždy viditeľný, s badge najbližších lehôt. Nový komponent v našom adresári + registrácia v tab store. Stále malý evidovaný zásah.

## Časť B — Connector registry

### Tri vrstvy konektorov

| Vrstva | Čo | Správanie |
|---|---|---|
| **1. Povinné jadro** | MCP, bez ktorých feature nefunguje (RPVS, ORSR, register úpadcov, Finančná správa → subjektový research) | skill deklaruje závislosť; keď server chýba, feature sa nespustí, ale povie **čo chýba a ponúkne inštaláciu** (question modal). Blokuje feature, nie appku. |
| **2. Katalóg (registry)** | voliteľné aj povinné konektory ponúkané na inštaláciu | každý manifest má **local aj remote variant** inštalácie |
| **3. Vlastné servery (BYO)** | servery používateľa — remote URL alebo lokálny stdio príkaz | zapisujú sa priamo do opencode configu cez Settings; registry do toho nesmie zasahovať |

### Prepojenie skill ↔ MCP cez „schopnosti", nie mená serverov

Skill nežiada *„server mcp-rpvs"*, ale schopnosť (*„overenie KÚV"*). Mapovanie schopnosť → server žije v configu:

```markdown
# lawoss.config.md (globálne alebo per spis)
konektory:
  overenie-kuv: mcp-rpvs                 # default z katalógu
  obchodny-register: moj-vlastny-orsr    # používateľ presmeroval na svoj server
```

- Default = náš konektor z katalógu
- Používateľ môže presmerovať na vlastný server, ak poskytuje kompatibilné nástroje — nadväzuje na agentické pravidlo z [ADR 0008](../decisions/0008-sprava-mcp-repozitarov.md): *zachovať spätnú kompatibilitu názvov MCP tools a ich schém*
- Skill pri štarte skontroluje dostupnosť; chýba = jasná hláška + cesta k inštalácii, nie padnutý tool call

### Manifest konektora

Nové samostatné repo `Omni-Legal-Products/lawoss-registry` *(mimo forku — nulový merge dlh; sedí na rozhodnutie o presune MF marketplace manifestu do samostatného repa)*:

```jsonc
{
  "id": "mcp-orsr",
  "source": "Omni-Legal-Products/mcp-orsr",       // org fork (ADR 0008)
  "upstream": "originalmagneto/orsr-mcp",          // zdroj pravdy
  "pin": "v1.4.2",                                 // známa dobrá verzia
  "install": {
    "remote": { "url": "…" },
    "local":  { "type": "stdio", "command": "…" }
  },
  "requires": ["overenie-kuv"],                    // schopnosti, ktoré poskytuje
  "skills": ["novy-spis", "subjektovy-research"],  // čo na ňom závisí
  "healthcheck": { "canary": "známy pozitívny prípad" }
}
```

### Mechanizmus „up to date"

```
osobný upstream tag → org fork sync → registry pin bump → appka pri reštarte zbadá nový pin
```

1. **Kontrola verzií**: skript porovná pin vs. najnovší tag org repa → report do Telegramu. **Upozorní, neaktualizuje sám** (Q21).
2. **Inštalácia/aktualizácia**: deterministicky cez skill/CLI, **nie model rozhoduje** *(princíp #36 — hranica vynútená v nástroji)*. Allowlist = len repá z registry.
3. **Rollback**: vrátenie pinu; stará verzia ostáva lokálne.
4. **Canary health check** pri pripojení servera *(vzor návrhu #35)* — prázdny výsledok musí byť odlíšený od „čistého výsledku".

### Sekcia „Konektory" v settings

- zoznam: nainštalované / bežia / chýbajúce (stav z health checku)
- „Inštalovať z katalógu" — výber local/remote variantu
- „Pridať vlastný server" — remote URL + auth, alebo stdio príkaz
- ⚠️ **trust label**: remote server = dáta odchádzajú zo stroja. Pri Q16 (plne lokálne) musí byť táto skutočnosť v UI viditeľná, nie skrytá. Rozlišovať *vlastný server* vs. *server tretej strany*.

## Rozpočet merge dlhu (🟡 zóna)

| Zásah | Rozsah |
|---|---|
| Registrácia settings tabu `lawoss` | ~1 riadok |
| Command palette akcie | pár riadkov |
| Panel tab „Lehoty" *(až fáza 2)* | registrácia v tab store |

Všetko ostatné = nové súbory v zelenej zóne (`lawoss/**`, `lawoss-registry`). `PATCHES.md` ostáva pod 10 riadkami. Ich hard-coded extension registry (`apps/server/src/extensions/`, 🔴 zóna) **nepoužívame vôbec** — celá naša vrstva beží nad configom.

## Otvorené otázky

1. **Private → public cesta**: registry dnes ukazuje na private repá; po zverejnení MCP (blokátor issue #40) sa menia len manifesty — potvrdiť, že nič iné.
2. **Pomenovanie**: „marketplace" naznačuje platby — navrhujeme **connector registry**.
3. **Kompatibilita tool schém BYO serverov**: čo presne znamená „kompatibilný server" pre presmerovanie schopnosti — minimálna množina tools + schém na definovanie per schopnosť.
4. **Spúšťač kondenzácie pamäte** *(súvisí s #48 a Q10)* — custom command vs. skript; zostáva v zelenej zóne, treba navrhnúť.
5. **Vyjadrenie IR** — Windows platforma (Q18) a či registry/inštalátor musí bežať aj na Windows od prvého dňa.

## Akceptačné kritériá V1

- [ ] Settings tab „LAWOSS" obsahuje meno advokáta, nomenklatúru, default autonómiu, default výstupný formát a sekciu Konektory
- [ ] „Nový spis" ide cez command palette + agent wizard bez vlastného formulárového UI
- [ ] Timeline lehôt je viditeľný ako HTML artifact vo fáze 1
- [ ] Chýbajúci povinný konektor sa prejaví zrozumiteľnou hláškou s cestou k inštalácii, nie pádom tool callu
- [ ] Vlastný remote server používateľa je možné pridať cez Settings a presmerovať naň aspoň jednu schopnosť
- [ ] `PATCHES.md` má po implementácii ≤ 3 nové riadky

---

<sub>Navrhol MČ s AI asistenciou 2026-08-21 na základe diskusie o integrácii additions do LAWOSS. Fakty o UI štruktúre LegalWorku overené v kóde upstreamu 2026-08-21 (v0.1.13). Návrhy označené ako otvorené otázky nie sú rozhodnutia.</sub>
