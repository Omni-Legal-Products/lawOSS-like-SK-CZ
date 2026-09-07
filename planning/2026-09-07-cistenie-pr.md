# Čistenie repozitárov pred fázou „beta 16. 9."

- **Stav overený:** 7. 9. 2026 cez GitHub API (`gh pr list`, `gh pr view`)
- **Rozsah:** 18 otvorených PR v koordinačnom repe · 8 vo forku
- **Cieľ:** nič nezahodiť bez dôvodu, ale mať pred betou prázdny stôl

---

## Výsledok — 7. 9. 2026 večer

**Fork `lawoss`.** Zlúčené `#24 → #31 → #35`, potom `#23` (hranaté rohy) a `#36` (marketplace katalóg). Pri merge sa stali dve veci, ktoré stoja za zapamätanie:

1. **`#35` sa zlúčil do svojej pôvodnej bázy, nie do `dev`.** Po merge `#31` sa základňa `#35` automaticky nepretargetovala, takže jeho obsah (Obsidian vault, konformita s OKF v0.2) v `dev` chýbal. Naprávalo sa to cez [#37](https://github.com/Omni-Legal-Products/lawoss/pull/37), ktorý tú deltu doniesol. **Poučenie: pri stohovanej reťazi treba každý ďalší PR pretargetovať ručne.**
2. **CI odhalil vadu, ktorá tam ležala od 4. 9.** — test `isir-nalezy` padal, lebo brána `assertUpdatedBumped` odmietla druhú zmenu obsahu v ten istý deň. Pri schválenom zápise do L1/L3 totiž CLI opečiatkuje `updated` dňom schválenia, takže druhá zmena už nemá čo posunúť. Je to presne vada pomenovaná v [podklade zo 6. 9.](2026-09-06-rozhodovaci-podklad-mc.md) („záznam sa nedá zmeniť dvakrát v ten istý deň"). Nikto si toho nevšimol, lebo `#31` aj `#35` mierili na vetvy, nad ktorými sa workflow `okf-pamat` nespúšťa.

   Opravené v `2c8db57`: brána zmenu pustí, keď `updated` už nesie dnešok; zablokovaná zostáva zmena, ktorá `updated` nechá v minulosti. Doplnený regresný test s dnešným dátumom, aby výsledok nezávisel od dňa, keď beží CI. 415/415 testov prejde.

**Koordinačné repo.** Zlúčená celá skupina 1 (`#65`, `#63`, `#66`, `#68`, `#69`, `#70`, `#71`).

> [!WARNING]
> **`#64` sa zavrelo ako vedľajší efekt.** Mazanie vetvy pri merge `#63` odstránilo `feat/vr-pamat-zjednotenie`, na ktorej `#64` stálo — GitHub ho preto automaticky zavrel. Vetva bola obnovená, `#64` znovu otvorené a pretargetované na `main`. Je teraz v stave `CONFLICTING`, lebo obsah `#63` je už v `main`; konflikt sa vyrieši pri prepise podľa R11.

**Vetvy.** Vo forku zmazaných 11 zlúčených vetiev. Zostáva osem: tri patria otvoreným PR (`#13`, `#14`, `#15`) a štyri sú zrkadlá upstreamu (`claude/*`, `fix/recorder-plus-button`) — tie sa mazať nemajú, po syncu by sa aj tak vrátili.

**Stav po čistení:** koordinačné repo **11 otvorených PR** (bolo 18; sedem zlúčených, #64 znovu otvorené), fork **3** (boli 4 plus reťaz). Všetky zostávajúce sú v skupine 2 a 3 nižšie, teda čakajú na obsahovú prácu alebo na vyjadrenie autora.

---

## Koordinačné repo — `lawOSS-like-SK-CZ`

### Skupina 1 — zlúčiť tak, ako sú *(čisté prírastky, bez konfliktu, call ich potvrdil alebo sú to záznamy v čase)*

| PR | Autor | Čo | Prečo teraz |
|---|---|---|---|
| [#65](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/65) | MČ | oprava týždenného prehľadu (`gh --jq --arg`) | jednosúborová oprava workflowu, blokuje pondelkový report |
| [#63](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/63) | VŘ | snapshot `vr-pamat` + `zjednotenie.md` | `zjednotenie.md` je referencia na kontrakt, dnes žije mimo repa |
| [#66](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/66) | VŘ | plán ďalších prác na OKF (16 úloh) | záznam v čase; pri merge doplniť vetu, čo z toho call 7. 9. prekonal |
| [#68](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/68) | VŘ | plán nasadenia OKF pamäte (C1–C3) | podklad pre čítací kanál a Prehľad |
| [#69](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/69) | VŘ | naše OKF × Google Open Knowledge Format | call potvrdil „maják" — toto je jeho odôvodnenie |
| [#70](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/70) | VŘ | podklad VŘ na call 7. 9. | podklad k zápisu, ktorý je už v `main` |
| [#71](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/71) | VŘ | zber nápadov z Telegramu 1.–2. 9. | zberný kôš, nič sa nezahadzuje |

### Skupina 2 — najprv upraviť, potom zlúčiť

| PR | Autor | Čo treba | Kto |
|---|---|---|---|
| [#67](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/67) | MČ | spec 0013: opraviť vetu o Google formáte, doplniť `kind` + `procedure` namiesto `matter.type` *(F1)* | MČ |
| [#64](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/64) | MČ | spec 0014/0015: prepísať §9, §10, §15 a P1 podľa callu — brány sú len tie v nástroji, L1/L3 „človek alebo písomné poverenie", dva nástroje a jeden kontrakt | MČ |
| [#54](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/54) | MČ | ADR 0011 (proces mergovania) mení aj `AGENTS.md` — overiť, či po troch týždňoch ešte sedí | MČ |
| [#56](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/56) | MČ | ADR 0012 (opencode bump cez verifikačnú bránu) — doplniť, či to platí aj po zmene rytmu syncu | MČ |
| [#55](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/55) | MČ | 🔴 konflikt v `specs/navrhy.md`; číslo 0011 je voľné | MČ |
| [#57](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/57) | MF | 🔴 konflikt; obsah („jeden MCP endpoint pre viacero zdrojov") je po diskusii o RAM **znova aktuálny** — nezahadzovať | MF |
| [#58](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/58) | MČ | 🔴 konflikt **a kolízia čísla**: hlási sa ako 0013, ale 0013 je OKF CLI (#67) → prečíslovať na 0016 | MČ |
| [#72](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/72) | VŘ | tlačové správy + pravidlá komunikácie navonok. **Repo je verejné** — merge = zverejnenie draftov. Zosúladiť s rozhodnutím 22 (marketingový naratív) a odklepnúť vedome | MČ + VŘ |

### Skupina 3 — cudzie drafty, rozhodne autor

| PR | Autor | Čo | Návrh |
|---|---|---|---|
| [#10](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/10) | MF | `lawoss-paper-research` skill *(9. 8., draft)* | skilly už žijú v `lawoss-marketplace` → presunúť tam a PR zavrieť |
| [#53](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/53) | MF | tri skilly: citations, law-drift, workflow-router *(17. 8., draft)* | to isté — sú to dobré skilly na zlom mieste |
| [#39](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/pull/39) | IR | SAK compliance štartovací balík *(14. 8., draft)* | jediný Igorov príspevok — dokončiť s ním, nie zavrieť ticho |

---

## Fork — `lawoss`

| PR | Autor | Čo | Návrh |
|---|---|---|---|
| [#24](https://github.com/Omni-Legal-Products/lawoss/pull/24) → [#31](https://github.com/Omni-Legal-Products/lawoss/pull/31) → [#35](https://github.com/Omni-Legal-Products/lawoss/pull/35) | VŘ | OKF pamäťové jadro · trvalé poverenie · Obsidian vault | **zlúčiť v poradí**; pred #35 premenovať `EVENT_KINDS` do angličtiny *(G3)*; podmienky k povereniu ako follow-up *(G1)* |
| [#23](https://github.com/Omni-Legal-Products/lawoss/pull/23) | MČ | hranaté rohy (issue #22) | rebase a zlúčiť — visí od 28. 8. |
| [#36](https://github.com/Omni-Legal-Products/lawoss/pull/36) | MF | governovaný marketplace katalóg | model kanálov a typov zachovať, **demo dáta vymeniť za našich 15 pluginov** *(H3)*; PR nesie aj `document-author.ts`, release workflow a updater — zlúčiť ako celok |
| [#15](https://github.com/Omni-Legal-Products/lawoss/pull/15) | MF | meno advokáta do autorstva DOCX *(draft, konflikt)* | **prekryté PR #36**, ktoré tú istú funkciu prináša v `apps/app/src/app/lib/document-author.ts` → zavrieť ako duplicitu |
| [#14](https://github.com/Omni-Legal-Products/lawoss/pull/14) | MF | docs: jednotný MCP endpoint do features *(draft)* | viazané na coord #57 — rozhodnúť spolu s ním |
| [#13](https://github.com/Omni-Legal-Products/lawoss/pull/13) | MF | bezpečné spúšťanie orchestrator sidecaru *(draft)* | posúdiť samostatne; ak je to živé, dokončiť, inak zavrieť |

---

## Poradie

1. **Fork najprv** — reťaz #24 → #31 → #35 (s `EVENT_KINDS`), potom #23, potom #36 s vymenenými dátami. Odblokuje čítací kanál aj marketplace.
2. **Koordinačné repo, skupina 1** — sedem merge-ov za sebou, každý s `git pull --no-rebase` (auto-README bot commituje do `main`).
3. **Skupina 2** — MČ prejde svojich päť, MF #57, spolu #72.
4. **Skupina 3** — jedna správa do Telegramu pre MF a IR: „toto sú vaše otvorené PR-ká, chcete ich dokončiť, presunúť, alebo zavrieť?"
5. **Vetvy** — po merge zmazať zlúčené vetvy; vo forku sú aj staré (`chore/initial-lawoss-setup`, `codex/mf-remaining-tasks`, `loc/sk-cz-kostra`, `docs/tok-napad-implementacia`).

## Čo sa tým vyčistí

Z 26 otvorených PR ostane po skupine 1 a forku **otvorených ~11**, z toho 8 s konkrétnym vlastníkom a úlohou. To je stav, s ktorým sa dá ísť do bety.
