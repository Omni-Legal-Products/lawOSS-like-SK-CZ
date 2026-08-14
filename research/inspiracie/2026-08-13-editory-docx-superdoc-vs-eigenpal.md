<div align="center">

# 📄 Editory `.docx` — SuperDoc vs. to, čo máme

**Porovnanie k 2026-08-13** · *fakty z GitHub API a **priamo zo zdrojového kódu LegalWorku***

![Verdikt](https://img.shields.io/badge/verdikt-nenahradzova%C5%A5-orange)
![Dôvod](https://img.shields.io/badge/d%C3%B4vod-licencia%20AGPL-red)
![Znovu otvoriť](https://img.shields.io/badge/znovu%20otvori%C5%A5-pri%20zmene%20licencie-blue)

</div>

- **Zadal:** MČ · 2026-08-13 *(Telegram topic Feature IDEAS)*
- **Súvisí:** [nápady #28–#31](../../planning/napady.md) · [ADR 0003](../../decisions/0003-legal-work-ako-zaklad.md) · [ADR 0004](../../decisions/0004-ako-rozsirit-legalwork.md) · [analýza LegalWorku](legalwork.md)

> [!IMPORTANT]
> **Verdikt: nenahrádzať. Nie kvôli kvalite, ale kvôli licencii.**
> SuperDoc je objektívne zrelší produkt. Je pod **AGPLv3**, čo je presne tá licencia, kvôli ktorej sme zamietli mikeOSS. Editor, ktorý už v LegalWorku máme, je **Apache-2.0** a chýbajúce funkcie sú **vypnuté prepínače, nie chýbajúca funkcionalita**.

---

## 1️⃣ Čo LegalWork má dnes

**Natívny WYSIWYG editor `.docx` priamo v aplikácii** — nie je to chýbajúca funkcia, ako sme sa pôvodne domnievali.

```
apps/app/src/react-app/domains/session/artifacts/artifact-docx-editor.tsx
   └─ @eigenpal/docx-editor-react 1.8.3 + @eigenpal/docx-editor-agents
```

Zapojený je cez panel artefaktov (`artifact-panel.tsx`, lazy-loaded). Súbory `.docx`, `.docm`, `.dotx`, `.dotm` sa mapujú na `preview: "word"` *(`open-target.ts:91`)*.

| Vlastnosť | Stav |
|---|---|
| Stránkovanie verné Wordu | ✅ |
| Sledovanie zmien | ⚠️ **v knižnici áno, v UI nedostupné** — viď nižšie |
| Komentáre a bočný panel | ✅ |
| Bezstratový round-trip *(netknuté OOXML, fonty, makrá, médiá prežijú)* | ✅ deklarované a testované na korpuse |
| Režim len na čítanie | ✅ |
| Spolupráca v reálnom čase | ❌ |

## 2️⃣ Porovnanie

| | **SuperDoc** | **eigenpal** *(v LegalWorku)* |
|---|---|---|
| Repo | [superdoc/docx-editor](https://github.com/superdoc/docx-editor) *(presmerovanie z `Harbour-Enterprises/SuperDoc`)* | [eigenpal/docx-editor](https://github.com/eigenpal/docx-editor) |
| **Licencia** | **AGPLv3** + platená komerčná | **Apache-2.0** *(jadro; pozor na výnimku nižšie)* |
| Vznik | 2024-06-03 — **2 roky** | 2026-07-20 — **4 týždne** |
| Hviezdy · forky | **964 · 201** | 189 · 38 |
| Otvorené issues | 103 | 45 |
| Základ | OOXML natívne, bez HTML medzikroku | kanonický OOXML strom |
| Sledovanie zmien · komentáre | ✅ | ✅ |
| **Spolupráca v reálnom čase** | ✅ *(Yjs)* | ❌ |
| **SDK mimo prehliadača** | ✅ *(Node + Python)* | balík `-agents` |
| Bezstratový round-trip | nedeklaruje | ✅ testované |

*Overené cez GitHub API 2026-08-13.*

## 3️⃣ Prečo SuperDoc nejde — dvojitý problém

**AGPL je vírusová.** LAWOSS je MIT a distribuuje binárku. Zabudovanie AGPL knižnice znamená, že **celý LAWOSS musí byť AGPL** — čo ruší [ADR 0003](../../decisions/0003-legal-work-ako-zaklad.md) aj [ADR 0004](../../decisions/0004-ako-rozsirit-legalwork.md).

> [!CAUTION]
> **Je to presne tá licencia, kvôli ktorej sme zamietli mikeOSS** *(ADR 0003: „AGPL-3.0 a chýbajúci harness")*. Zamietnuť ju raz a o dva mesiace ju pustiť zadnými dverami by bolo nekonzistentné.

**Komerčná licencia to nerieši, len presúva.** Ich README ponúka *„a commercial license for proprietary deployments"*. Stojí peniaze, a podľa [ADR 0002](../../decisions/0002-preco-forkujeme-mikeoss.md) monetizujeme **výhradne školeniami** — nepredávame softvér. Ročný poplatok za komponent v nástroji, ktorý rozdávame zadarmo, nemáme z čoho utiahnuť.

## 4️⃣ ⚠️ Licenčná hranica v eigenpal

GitHub API hlási licenciu ako `NOASSERTION`. Priamo v súbore `LICENSE` stojí:

> Except where a file or directory expressly states different license terms, this repository is licensed under the Apache License, Version 2.0. **The contents of `packages/editor-api/` and `packages/pro/` are not licensed under the Apache License.** They are governed by the EigenPal Pro Evaluation License 1.0.

**LegalWork tie dva priečinky neťahá** — používa len `@eigenpal/docx-editor-react` a `@eigenpal/docx-editor-agents`. **Pri každom upgrade to treba skontrolovať**, aby nám komerčne licencovaný balík nepribudol cez tranzitívnu závislosť.

## 5️⃣ Čo naozaj chýba — a je to naša chyba, nie knižnice

Editor nemá menej funkcií. **LegalWork ich nezapína.**

| | Zistenie | Nápad |
|---|---|---|
| **Sledovanie zmien** | Knižnica má `type EditorMode = 'editing' \| 'suggesting' \| 'viewing'`, kde **`suggesting` = tracked changes**. LegalWork posiela natvrdo `mode={readOnly ? "viewing" : "editing"}` — `suggesting` sa **v UI nedá zapnúť** | [#29](../../planning/napady.md) |
| **Meno autora** | `author = "Legal Cowork"` je natvrdo default *(`artifact-docx-editor.tsx:87`)*, `artifact-panel.tsx` prop **nikdy neposiela**, a appka **nemá nikde nastavenie mena používateľa**. Každá zmena a komentár sa podpíše ako „Legal Cowork" | [#31](../../planning/napady.md) |
| **Mätúca hláška** | Priloženie `.docx` **do chatu** hlási *„format the model can't read"*, hoci appka má vstavaný editor | [#30](../../planning/napady.md) |
| **Zoradenie súborov** | Workspace browser nevie zoradiť podľa dátumu, veľkosti, typu ani názvu | [#28](../../planning/napady.md) |

Prvé tri sú **malé, izolované zmeny v jednom-dvoch súboroch** — vhodné aj ako upstream PR.

## 6️⃣ Odporúčanie

1. **Zostať pri eigenpal.** Je zapojený, Apache-2.0, a jeho bezstratový round-trip je pri cudzích zmluvách dôležitejší než spolupráca v reálnom čase, ktorú štyria ľudia nepotrebujú.
2. **Opraviť to, čo je vypnuté** — v poradí #31 *(meno)* → #29 *(sledovanie zmien)* → #30 *(hláška)* → #28 *(zoradenie)*.
3. **Sledovať SuperDoc.**

> [!NOTE]
> ### 🔔 Spúšťač na znovuotvorenie
> **Ak SuperDoc prejde na permisívnu licenciu** *(MIT, Apache-2.0, BSD)*, toto rozhodnutie sa **znovu otvára**. Spolupráca v reálnom čase, Python SDK a dvojročná zrelosť sú veci, ktoré by sa nám o rok hodili.
>
> **Ako sledovať:** na GitHube *Watch → Custom → Releases* na `superdoc/docx-editor`. Pri väčšej verzii skontrolovať `LICENSE`.
>
> Toto nie je „zamietnuté", ale **„preskúmané a odložené s dôvodom"** — rozdiel je v tom, že vieme, čo má nastať, aby sme sa vrátili.

---

<sub>Pripravil MČ s AI asistenciou, 2026-08-13. Fakty o oboch projektoch overené cez GitHub API k 2026-08-13; tvrdenia o LegalWorku overené priamo v zdrojovom kóde klonu na tagu `v0.1.13`. Licenčný text eigenpal čítaný zo súboru `LICENSE` v `main`, nie z metadát GitHubu, ktoré uvádzajú `NOASSERTION`.</sub>
