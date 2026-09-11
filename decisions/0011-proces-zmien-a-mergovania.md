# ADR 0011: Proces zmien a mergovania — vlastníctvo namiesto brány

- **Dátum:** 2026-08-17, **prepísané 2026-08-19** podľa záverov [callu 18. 8.](../meetings/2026-08-18-zapis-sync-call.md)
- **Stav:** **návrh** — rozhodnuté na calle za účasti MČ, MF a VŘ; **čaká na vyjadrenie IR**
- **Navrhol:** Marián Čuprík (MČ)
- **Súvisí s:** [ADR 0005](0005-struktura-repozitarov.md) · [ADR 0007](0007-agent-first-architektura.md) · odpovede tímu na Q02 a Q05

## Kontext

Pravidlá hovorili, *že* väčšie zmeny idú cez branch a PR, ale **nehovorili, kto smie PR zlúčiť**. `main` nemá povinný review — vedomé rozhodnutie, aby to nezdržovalo. 17. 8. sa ukázalo, že je to diera: šesť PR vrátane nového specu a väčšieho prepisu specu bolo zlúčených autorom. Obsahovo zmeny sedeli s odpoveďami tímu, procesne to ale nebolo ošetrené.

**Pôvodný návrh tohto ADR** *(zo 17. 8.)* na to reagoval bránou: rozhodovací obsah — spec, ADR, `AGENTS.md` — nemerguje autor, treba odklep aspoň jedného ďalšieho člena.

**Call 18. 8. rozhodol inak.** Prevládol argument, že nikto z tímu nie je vývojár, produkt sa ladí za pochodu a vstupná brána by len brzdila:

> Fungujeme cez Telegram, issues a PR. Každý si merguje svoje PR a nesie za ne zodpovednosť. Keď niekto zlúči hlúposť, upozorní sa naňho a revertne sa to — bez drámy.

## Rozhodnutie

### 1 · Vlastníctvo namiesto brány

| | |
|---|---|
| **Kto merguje** | **autor svojho PR** — v koordinačnom repe bez rozdielu typu obsahu |
| **Kto nesie zodpovednosť** | **autor**, za obsah aj za dôsledky |
| **Kde je kontrola** | **následná** — všetci sledujú zmeny cez Telegram most a GitHub |
| **Čo pri chybe** | upozorniť autora a **revertnúť bežným PR**. Bez drámy, bez eskalácie |

**Praktické minimum, ktoré ostáva v platnosti:**

- `git pull --no-rebase` pred pushom aj po ňom *(auto-README bot commituje do `main`)*
- väčšia zmena sa **ohlási v Telegrame** vopred — nie na schválenie, ale aby si dvaja nešliapali po tom istom súbore
- nové rozhodnutie má **ADR**, nový návrh má **spec a riadok v `navrhy.md`** — proces evidencie sa nemení
- **nemeníme cudzie autorstvo** a nemeníme cudzí ADR; namiesto toho sa pridáva nový, ktorý starý nahrádza

### 2 · Fork `lawoss` — tu brána zostáva

V produktovom forku je **povinný review technicky vynútený** cez branch protection a `AGENTS.md` forku hovorí *„every PR requires at least one approval"*. Tento ADR to **nemení**: koordinačné repo sú dokumenty, fork je kód, ktorý sa distribuuje advokátom.

> [!NOTE]
> **Na doriešenie:** či sa má povinný review vo forku ponechať aj po tom, čo call zvolil ľahší režim pre koordinačné repo. Návrh MČ je ponechať — cena chyby v kóde je vyššia než v dokumente.

### 3 · Tok od nápadu k implementácii — nemení sa

Nápad → `napady.md` + `navrhy.md` → spec alebo ADR → **odklep tímom** → issue vo forku s odkazom späť → PR do `dev`. Odklep sa naďalej deje na calle alebo v PR; **merge nie je odklep** a odklep nie je merge. Kto zlúči vlastný spec, tým ho nespravil rozhodnutím tímu — rozhodnutím sa stáva až vyjadrením ostatných.

### 4 · Gestorstvo namiesto matice sign-offov

Call zamietol formálnu maticu sign-offov (Q20). Platí: **kto si funkciu vezme za svoju, ten ju maintainuje a zodpovedá za ňu**, pokiaľ nerozbije dohodnuté core features. Aktuálni gestori sú v [zápise z callu](../meetings/2026-08-18-zapis-sync-call.md#g--regulované-workflowy-q20q21).

### 5 · Ticho a eskalácia

Ticho **nie je súhlas** pri rozhodnutiach *(ADR, spec, zmena prijatého rozhodnutia)*. Ak sa k odklepu nikto nevyjadrí do troch pracovných dní, autor to pripomenie v Telegrame; pri pate rozhoduje product owner a zapíše prečo.

## Zvažované alternatívy — a prečo nie

| Alternatíva | Prečo nie |
|---|---|
| **Brána: rozhodovací obsah nemerguje autor** *(pôvodný návrh tohto ADR)* | Call ju zamietol — pri štyroch ľuďoch, z ktorých ani jeden nie je vývojár na plný úväzok, by vstupná brána brzdila viac, než by chránila. Kontrola sa presunula za merge. |
| **Povinný review technicky vynútiť aj v koordinačnom repe** | Rovnaký dôvod; navyše by blokoval aj rešerše a drobnosti, ktoré majú tiecť voľne. |
| **Všetko merguje product owner** | MČ výslovne odmietol byť bottleneck. |
| **Status quo bez zápisu** | Práve zlyhalo — nikto nevedel, čo platí. |

## Dôsledky

- Merge-e zo 17. 8. sú **v súlade s takto zapísaným pravidlom** — riešili sa spätne a nie je ich potrebné revertovať.
- Riziko, ktoré vedome prijímame: **spec sa môže dostať do `main` skôr, než ho tím prerokoval.** Poistkou je, že merge nie je odklep *(bod 3)* a že sa všetko dá revertnúť.
- `AGENTS.md` treba zosúladiť s týmto znením — sekcia „kto smie PR zlúčiť" hovorí opak.

> [!WARNING]
> **Odchýlka od písomných odpovedí tímu.** V Q05 **IR, VŘ aj MF** písomne uviedli, že review minimá majú byť záväzné aj tam, kde ich GitHub nevynúti. Call rozhodol inak a nikto z prítomných proti tomu nenamietal, ale **IR na calle nebol**. Kým sa nevyjadrí, je toto ADR **návrh, nie prijaté rozhodnutie**.
