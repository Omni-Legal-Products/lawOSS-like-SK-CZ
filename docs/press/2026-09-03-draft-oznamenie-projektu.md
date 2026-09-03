# DRAFT · Tlačová správa — oznámenie projektu

> [!CAUTION]
> **NEPUBLIKOVANÉ.** Návrh na pripomienkovanie. Pred odoslaním komukoľvek musí prejsť [kontrolným zoznamom](README.md) a byť odklepnutý MČ.

**Embargo:** `[DÁTUM — až po podpísaných buildoch, viď Q06]`
**Kontakt pre médiá:** `[MENO · E-MAIL · TELEFÓN — určí MČ]`

---

## Nadpis

> `[PRACOVNÝ NÁZOV]` — otvorený nástroj pre advokátov, ktorý si prax riadi sama

**Podnadpis:** Štyria advokáti z Česka a Slovenska zverejnili open-source aplikáciu, ktorá organizuje advokátsky spis a necháva umelú inteligenciu pracovať pod dohľadom právnika. Softvér je zadarmo, dáta zostávajú v počítači advokáta.

---

## Perex

`[MESTO]`, `[DÁTUM]` — Skupina štyroch advokátov z Českej a Slovenskej republiky uvoľnila `[NÁZOV]`, otvorený nástroj pre advokátske kancelárie. Aplikácia stojí na existujúcom open-source základe a dopĺňa ho o to, čo v hotových riešeniach chýba: štruktúru spisu, sledovanie lehôt a napojenie na české a slovenské právne zdroje. Zdrojový kód je verejný, používanie bezplatné.

## Jadro — čo to rieši

Právnické AI nástroje na trhu dnes fungujú ako uzavreté služby: používateľ nevidí, aké pokyny model dostáva, ani kam idú údaje z jeho spisov. `[NÁZOV]` ide opačnou cestou.

- **Poriadok v spise, nie ďalší chatbot.** Ťažiskom je organizácia praxe — aplikácia zakladá spisy, udržiava ich štruktúru a stráži, aby agent pracoval s aktuálnym stavom veci.
- **Lehoty pod kontrolou.** Výpočet konca lehoty je deterministický, s uvedením ustanovenia a výpočtu; zápis do spisu vyžaduje potvrdenie advokáta. Zmeškaná lehota je najčastejší dôvod zodpovednosti advokáta — preto tu AI nič nezapisuje sama.
- **Overené právne zdroje.** Napojenie na `[ZOZNAM KONEKTOROV — doplniť podľa stavu k vydaniu]` má brániť tomu, aby model vymýšľal paragrafy a spisové značky.
- **Otvorené pokyny.** Advokát vidí a mení každý pokyn, ktorý model dostáva. Vlastný štýl práce zostáva jeho konkurenčnou výhodou, nie vlastnosťou dodávateľa.
- **Dáta zostávajú lokálne.** Spisy a pamäť veci sú súbory v počítači advokáta. Aplikácia neprevádzkuje server ani účty.

## Prečo to robíme

`[CITÁT — schvaľuje MČ; 2–3 vety o tom, prečo vznikol projekt a pre koho]`

`[CITÁT — schvaľuje IR alebo MF; 1–2 vety o pohľade z praxe]`

> [!WARNING]
> **Pri citátoch pozor na pravidlo 1:** funkcie v stavovských orgánoch sa uvádzajú len ako osobný údaj hovoriaceho a s výslovným dodatkom, že projekt nie je stanoviskom ani podporou komory.

## Model fungovania

Aplikácia je a zostane bezplatná a otvorená. Autori nepredávajú softvér ani službu — venujú sa školeniam, workshopom a pomoci so zavedením do praxe. Zdrojový kód je dostupný pod licenciou `[LICENCIA — otvorený bod B5]`.

## O projekte

`[NÁZOV]` je otvorený projekt pre českú a slovenskú advokátsku prax. Vznikol v roku 2026 a stojí na základe `[UPSTREAM — LegalWork nad opencode, doplniť presné znenie a atribúciu]`.

**Web:** lawoss.app · **Kód:** github.com/Omni-Legal-Products

---

## Poznámky pre redakciu — nepublikovať

- Text je **návrh**. Fakty označené `[…]` sa pred vydaním doplnia a overia.
- **Nepoužívať formulácie** typu „schválené komorou", „odporúčané ČAK/SAK" ani odvodené. Projekt nie je stanoviskom stavovských orgánov.
- Ak sa v rozhovore dostane reč na **komentárové korpusy**, platí: sekundárny, nerecenzovaný materiál generovaný s AI, určený na navigáciu v práve — **nie na citovanie v podaní**.
- Snímky obrazovky sú **koncepty rozhrania**, nie fotografie hotového produktu; dáta v nich sú vymyslené.
