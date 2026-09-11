# DRAFT · Tisková zpráva — česká odborná veřejnost

> [!CAUTION]
> **NEPUBLIKOVÁNO.** Návrh k připomínkování. Před odesláním komukoli musí projít [kontrolním seznamem](README.md) a být odklepnut MČ; česká právní tvrzení potvrzuje VŘ.

**Embargo:** `[DATUM — až po podepsaných buildech]`
**Kontakt:** `[JMÉNO · E-MAIL · TELEFON]`
**Cílová média:** odborný právnický tisk a stavovské zpravodaje `[UPŘESNIT — konkrétní tituly a redaktoři]`

---

## Nadpis

> Advokáti si postavili vlastní AI nástroj. Zdrojový kód dali k dispozici zdarma

**Podnadpis:** Otevřená aplikace `[PRACOVNÍ NÁZEV]` organizuje spis, hlídá lhůty podle § 57 o. s. ř. a nechává klientská data v počítači advokáta. Vznikla jako společný česko-slovenský projekt.

---

## Perex

`[MĚSTO]`, `[DATUM]` — Skupina advokátů z Česka a Slovenska zveřejnila otevřený nástroj pro advokátní praxi. Na rozdíl od komerčních právnických AI služeb je zdrojový kód veřejný, používání bezplatné a klientské údaje neopouštějí počítač uživatele.

## Co je na tom pro advokáta podstatné

**Mlčenlivost.** Dokumenty i spisová paměť jsou obyčejné soubory u advokáta. Aplikace neprovozuje server ani uživatelské účty. Za porušení povinnosti mlčenlivosti podle § 21 zákona č. 85/1996 Sb. odpovídá advokát osobně, nikoli dodavatel softwaru — proto lokálnost dat není volba v nastavení, ale vlastnost architektury.

**Lhůty.** Konec procesní lhůty se počítá deterministicky, ne odhadem modelu — s uvedením ustanovení, ze kterého lhůta plyne, a s vysvětlením výpočtu. Zápis do spisu vyžaduje potvrzení advokáta.

> Podklad k českým pravidlům počítání lhůt je součástí projektu: 30 pravidel v šesti předpisech, katalog 25 lhůt, 18 zdokumentovaných pastí a 24 spočítaných testovacích případů. Znění každého citovaného ustanovení bylo ověřeno proti plnému textu předpisu.

**Ověřené zdroje.** Napojení na `[ZOZNAM CZ KONEKTORŮ — doplnit podle stavu k vydání]` má bránit tomu, aby model vymýšlel paragrafy a spisové značky.

**Otevřené pokyny.** Advokát vidí a mění každý pokyn, který model dostává. V právu je odlišnost výstupu konkurenční výhodou — pokud všichni používají tentýž skrytý pokyn, začnou všechna podání vypadat stejně.

## Kdo za tím stojí

`[JMÉNA A STRUČNÉ PROFILY — schvaluje každý sám za sebe]`

> [!WARNING]
> **Funkce ve stavovských orgánech se uvádějí výhradně jako osobní údaj** a s výslovným dodatkem, že projekt není stanoviskem ani doporučením České advokátní komory ani Slovenskej advokátskej komory. Jakákoli formulace, která by naznačovala opak, je nepřípustná.

## Model fungování

Software je zdarma a zůstane otevřený. Autoři nepředávají licence ani neprovozují placenou službu; věnují se školením, workshopům a pomoci se zaváděním do praxe.

## Poznámka ke komentářovým podkladům

Součástí projektu jsou generované komentáře k předpisům. `[UVÁDĚT POUZE S TÍMTO ODSTAVCEM:]` Jde o **sekundární, nerecenzovaný materiál vytvořený s asistencí AI**, určený k orientaci v právu a k nalézání souvislostí. **Není pramenem a nesmí se citovat v podání** — každé ustanovení i každé rozhodnutí je nutné ověřit v primárním prameni. Jsou doložené případy, kdy formulace komentáře vynechala slova nosná pro petit.

---

## Poznámky pro redakci — nepublikovat

- Text je **návrh**; údaje v `[…]` se před vydáním doplní a ověří.
- Nepoužívat „schváleno ČAK", „doporučeno komorou" ani odvozené formulace.
- Vizuály jsou **koncepty rozhraní**, nikoli snímky hotového produktu; data v nich jsou vymyšlená.
- Údaj o počtu pravidel a testů u lhůt je doložitelný v repozitáři; jiné číselné údaje bez ověření neuvádět.
