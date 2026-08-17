# Validátor skillov LAWOSS

Validátor kontroluje štruktúru a frontmatter skillov v repozitári
lawOSS-like-SK-CZ. Hľadá súbory `plugins/<plugin>/skills/<name>/SKILL.md`
a `skills/<name>/SKILL.md` (rekurzívne pod `plugins/` aj `skills/`).

## Spustenie lokálne

Vyžaduje Node.js 20 alebo novší, žiadne npm závislosti.

```
node scripts/validate-skills.mjs            # koreň repa je aktuálny adresár
node scripts/validate-skills.mjs cesta/k/repu
node scripts/validate-skills.mjs tests-fixtures   # samotest na fixtures
```

## Chyba vs. varovanie

CHYBY (exit kód 1, blokujú merge v CI):

- chýbajúci alebo neparsovateľný YAML frontmatter,
- chýbajúce pole `name` alebo `description`,
- `name` nie je kebab-case (malé písmená, číslice, spojovníky),
- `name` sa nezhoduje s názvom adresára skillu,
- duplicitné `name` naprieč repozitárom,
- prázdne telo pod frontmatterom.

VAROVANIA (exit kód 0, neblokujú, ale vypíšu sa v reporte):

- `description` nad 1024 znakov,
- `description` bez negatívneho vymedzenia (nenašiel sa žiadny z reťazcov
  „NEAKTIVUJ", „Neaktivuj", „Do not use", „not for"),
- chýba `tests/` adresár, chýba triggers súbor, alebo triggers súbor má
  menej než 3 aktivačné vety,
- `description` obsahuje číslované kroky postupu (heuristika: „1." a „2."),
- podobnostná kolízia popisov: Jaccard podobnosť tokenov dvoch descriptions
  nad 0.5 (riziko, že si router skillov bude popisy pliesť).

## Exit kódy

- 0: bez chýb (varovania môžu existovať),
- 1: aspoň jedna chyba,
- 2: chybné použitie (zadaný koreň neexistuje).

## CI

Workflow `.github/workflows/validate-skills.yml` beží na každý pull request,
ktorý mení `plugins/**` alebo `skills/**`, a spustí validátor nad koreňom repa.

## Poznámky k implementácii

- YAML parser je zámerne minimálny: ploché polia `key: value`, blokové
  skaláre `>` a `|` (bežné pri dlhých descriptions) a jednoduché úvodzovky.
  Vnorené štruktúry vo frontmatteri hlási ako neparsovateľný frontmatter.
- Adresáre `.git` a `node_modules` sa preskakujú.
