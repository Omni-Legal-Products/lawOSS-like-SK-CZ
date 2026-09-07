# Naše OKF × Google „Open Knowledge Format" — kolízia mena a čo si z nej vziať

- **Autor:** Vojta Říha (VŘ) · 2026-09-02
- **Overené:** [spec v0.2](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) načítaná v plnom znení 2. 9. 2026; kanonické repo je [`GoogleCloudPlatform/open-knowledge-format`](https://github.com/GoogleCloudPlatform/open-knowledge-format)
- **Pre koho:** rozhodnutie na call 7. 9.

---

## Čo sa stalo

V júni 2026 vydal Google Cloud (Data Cloud team, Sam McVeety a Amir Hormati) **Open Knowledge Format — skratka OKF**. Je to vendor-neutrálna špecifikácia pre agentmi čitateľné znalosti:

> „A bundle is a directory tree of markdown files… Every concept is a UTF-8 markdown file with YAML frontmatter… no SDK, runtime, or registry."

Máme teda **rovnakú skratku pre rovnaký tvar veci**: adresár markdownu s frontmatterom, ktorý číta agent aj človek. Naše OKF je „organizačný formát advokátskej praxe" (spec 0002), ich je „Open Knowledge Format".

> [!WARNING]
> **Toto nie je len nepríjemná zhoda.** Ich OKF má za sebou blog Google Cloud, MarkTechPost, GitBook, samostatnú doménu `okf.md` a niekoľko komerčných sprievodcov. Kto si vygoogli „OKF", nájde ich. Až doteraz to bola zhoda náhod; odteraz je to naša komunikačná záťaž pri každom školení a každom článku.

*(Pozn.: „OKF" je zároveň zavedená skratka pre **Open Knowledge Foundation** — to je tretia, ešte staršia kolízia.)*

## Tri možnosti

| | Čo to znamená | Cena |
|---|---|---|
| **A. Premenovať naše** | napr. „OFP" (organizačný formát praxe) | prepísať spec 0002, skill `novy-spis`, balíčky, dva PR rozpracované — a stratiť zavedený pojem v tíme |
| **B. Ignorovať** | necháme tak | pri každom vyhľadaní sa objaví Google; v článku o LAWOSS treba zakaždým vysvetľovať |
| **C. Profil ich formátu** ⭐ | „OKF-legal — profil Open Knowledge Format pre advokátsku prax" | zladiť pár polí; skratka zostáva a kolízia sa mení na kompatibilitu |

**Navrhujem C** a nižšie je dôvod, prečo to nie je len marketingový obrat: **formáty sa nezávisle zbehli k tomu istému**, takže zladenie stojí málo.

---

## Kde sme sa zbehli sami od seba

| Google OKF v0.2 | Naša pamäť (`okf-pamat`) | |
|---|---|---|
| bundle = strom markdownu s frontmatterom | `memory/` so záznamami | ✅ zhoda |
| `type` — **jediné povinné pole** | `type` povinné, vrstva sa z neho odvodzuje | ✅ zhoda |
| `index.md` — navigácia | `INDEX.md` | ✅ zhoda (len veľkosť písmen) |
| `log.md` — chronológia zmien | `## History` v každom zázname | ≈ iná granularita, nie spor |
| `verified: [{by, at}]` | `verified_at`, `verified_against` | ≈ **vymysleli sme skoro to isté** |
| `status: draft/stable/deprecated` | `status` | ≈ zhoda |
| `stale_after` | `valid_until`, `effective_to` | ≈ zhoda |
| odkazy = markdown cesty | ✅ **od 2. 9.** (predtým `[[…]]`) | ✅ zhoda |

## Kde sme boli v rozpore — a už nie sme

Špecifikácia je **zámerne zhovievavá pri čítaní**:

> „Consumers MUST NOT reject a bundle because of: Missing optional frontmatter fields, **Unknown `type` values, Unknown additional frontmatter keys**, Broken cross-links, Missing `index.md` files."

Náš parser neznámy kľúč považoval za chybu a **zahodil celý záznam**. Nešlo o teóriu: advokát v Obsidiane si pridá `tags:` — čo je u Googlu dokonca odporúčané pole — a subjekt zmizol zo store aj z jehiel detektora únikov.

**Opravené** ([lawoss#35](https://github.com/Omni-Legal-Products/lawoss/pull/35)): neznáme kľúče sa zachovajú a prežijú round-trip, presne ako žiada spec.

> [!NOTE]
> **Jeden rozpor ponechávame vedome.** Google žiada tolerovať rozbité odkazy („may simply represent knowledge not yet written"). U nás je `BROKEN_LINK` **chyba** — tvrdenie odkazujúce na neexistujúci dôkaz nie je nedopísaná znalosť, je to vada spisu. Rovnako neznámy `type`: vrstva sa odvodzuje z typu, takže neznámy typ nemá kam patriť. Súbor sa preskočí a ohlási, zvyšok pamäte funguje ďalej — bundle teda **neodmietame**, len ten jeden dokument.

---

## Čo si z ich špecifikácie vziať

Zoradené podľa toho, čo prinesie právnej praxi najviac.

### 1. `sources[]` s identifikátormi a atribúcia jednotlivého tvrdenia ⭐

Toto je najsilnejšia vec v celej ich špecifikácii pre nás a **nemáme z nej nič**.

Ich `sources` nie je zoznam reťazcov, ale záznamov:

```yaml
sources:
  - id: ns-22-cdo-2886-2023
    resource: https://…
    title: NS 22 Cdo 2886/2023
    author: Nejvyšší soud
    last_modified: 2023-11-14
```

a jednotlivé tvrdenie sa naň odkáže **markdownovou poznámkou pod čiarou**:

```markdown
Súhlas vlastníka pozemku nie je titulom k stavbe.[^ns-22-cdo-2886-2023]
```

> „Labels are keyed rather than positional because agents constantly rewrite these documents: a positional index misattributes silently."

**Prečo je to pre nás dôležitejšie než pre nich:** presne toto robí advokát v každom podaní — vetu opiera o konkrétne ustanovenie alebo judikát. Naše dnešné `sources: [reťazec]` visí na celom zázname, takže sa nedá povedať, ktorá veta stojí na čom. Pri kontrole podania pred odoslaním je to rozdiel medzi „niekde tu je opora" a „táto veta stojí na tomto".

Zároveň to je **priama obrana proti vymysleným prameňom** — tá istá trieda chýb, kvôli ktorej vzniklo `feedback_neoverene_prameny_v_automatickem_runu`.

**Veľkosť:** stredné. Mení tvar poľa `sources`, takže potrebuje migráciu (starý zoznam reťazcov → záznamy bez `id`).

### 2. `verified: [{by, at}]` ako zoznam, nie jedna hodnota

Máme `verified_at` a `verified_against`, teda **jedno** overenie. Právny prameň sa ale overuje opakovane — po každej novele. Zoznam je vecne správnejší a spec ho už má vrátane pravidla:

> „MUST treat a bare `verified` mapping as a one-element list"

**Veľkosť:** malé, spätne kompatibilné.

### 3. `okf_version` v koreňovom `index.md`

Jeden riadok, ktorý povie, podľa akej verzie formátu priečinok vznikol. Bez neho bude migrácia starých spisov (úloha 10) hádať.

**Veľkosť:** triviálne. **Odporúčam urobiť pred migráciou, nie po nej.**

### 4. `log.md` na úrovni priečinka

Máme `## History` v každom zázname — jemnejšie a pre spis lepšie. Ich `log.md` je navyše prehľad *na úrovni priečinka*: čo sa v spise dialo, bez otvárania záznamov.

Dá sa **generovať** z histórií záznamov pri `sync`, teda bez druhého zdroja pravdy.

**Veľkosť:** malé. Ale pozor: prekrýva sa to s blokom `Chronológia` v `_STATUS.md` — najprv rozhodnúť, či chceme oboje.

### 5. Čo si vziať nemáme

| | Prečo nie |
|---|---|
| `Attested Computation` (v0.2) | je to na reprodukovateľné výpočty nad dátami; v spise nemá čo robiť |
| tolerancia rozbitých odkazov | viď rámček vyššie — v spise je to vada |
| `resource` ako URI konceptu | naše záznamy nepopisujú externé aktívum, ale samotnú vec |
| ich permisívnosť pri `type` | vrstva sa odvodzuje z typu; neznámy typ nemá kam patriť |

---

## Čo to znamená pre bod „publikovať schému ako štandard" (O5, úloha 15)

Plán počítal s vlastným JSON Schema. **Ak ideme cestou C, mení sa to na niečo lacnejšie a silnejšie:** namiesto vlastného štandardu publikujeme **profil existujúceho** — dokument, ktorý povie, ktoré typy a polia OKF-legal pridáva nad OKF v0.2 a kde sa vedome odchyľuje.

Výhody oproti vlastnému štandardu:
- ktorýkoľvek agent, ktorý číta OKF, prečíta aj spis — bez nášho SDK
- ich vizualizér (jeden self-contained HTML súbor, bez backendu) zobrazí graf spisu zadarmo
- nemusíme obhajovať, prečo si robíme vlastný formát

Zapadá to do [`project_cee_legal_open_stack`](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ): profil uznávaného štandardu sa na trhu obhajuje lepšie než formát jednej kancelárie.

---

## Na rozhodnutie 7. 9.

1. **Kolízia mena: A, B alebo C?** Odporúčam **C — profil**.
2. **`sources[]` s atribúciou tvrdení** — áno/nie. Ak áno, patrí to **pred** migráciu (úloha 10), lebo mení tvar poľa.
3. **`okf_version`** — triviálne, odporúčam áno a hneď.
4. **`log.md`** — chceme ho popri bloku Chronológia v `_STATUS.md`, alebo je to zdvojenie?
5. **Úloha 15 (publikácia)** — vlastný JSON Schema, alebo profil OKF?

## Poznámka k metóde

Kolízia sa našla tak, že som hľadal „dokumentáciu k OKF" a prvé výsledky boli o niečom inom. **Naše OKF verejnú dokumentáciu nemá** — spec 0002 je v tomto repe a nie je indexovaná. Čokoľvek, čo agent nájde pod „OKF documentation", je Googlov formát alebo Open Knowledge Foundation. To samo o sebe je argument pre bod 1.
