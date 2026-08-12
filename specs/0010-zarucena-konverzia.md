# Spec 0010: Zaručená konverzia — samostatná funkcionalita

- **Stav:** návrh · **zaradenie: NIE V1, NIE V2** *(rozhodnutie MČ 2026-08-07 potvrdené rešeršou 2026-08-12)*
- **Navrhol:** Marián Čuprík (MČ) · 2026-08-07 *(návrh [#26](navrhy.md))* · vyčlenené zo [spec 0007](0007-podpisovanie-a-zarucena-konverzia.md) dňa 2026-08-12
- **Podklad:** [rešerš právneho rámca](../research/pravny-ramec/2026-08-12-zarucena-konverzia-sk.md) — tri nezávislé AI rešerše, kľúčové tvrdenia overené v Slov-Lexe · [surové zdroje](../research/pravny-ramec/zdroje-zarucena-konverzia/) *(neoverené, len na dohľadanie pôvodu tvrdení)*
- **Súvisiace:** [spec 0007 podpisovanie](0007-podpisovanie-a-zarucena-konverzia.md) · [ADR 0007 agent-first](../decisions/0007-agent-first-architektura.md) *(zatiaľ len v [PR #19](https://github.com/originalmagneto/lawOSS-like-SK-CZ/pull/19))* · [spec 0002 OKF](0002-okf-operacny-system-praxe.md)

> [!NOTE]
> **Čo agent číta a čo človek** *(povinná otázka podľa [ADR 0007](../decisions/0007-agent-first-architektura.md))*
> Agent číta a píše: metadáta konverzie a zaradenie výstupu do spisu. Človek robí: **vizuálnu kontrolu bezpečnostných prvkov listiny** *(zákonná povinnosť, § 3 ods. 1 vyhlášky — nedelegovateľné)* a **autorizáciu mandátnym certifikátom**. Táto funkcia je z podstaty ukotvená na ľudskej strane hranice.

## Prečo samostatný spec

Pôvodne bola zaručená konverzia súčasťou [spec 0007](0007-podpisovanie-a-zarucena-konverzia.md) spolu s podpisovaním, s odôvodnením, že „zdieľajú ten istý engine a tie isté bezpečnostné hranice". **Rešerš z 12. 8. ukázala, že to neplatí:**

| | Podpisovanie (spec 0007) | Zaručená konverzia (tento spec) |
|---|---|---|
| Integrácia | volanie **Autogramu** na `localhost` | + **SOAP/WSDL na štátny register** (CEZZK/EZZK) |
| Registrácia | žiadna | **povinná registrácia** oprávnenej osoby na `iomo.sk` |
| Certifikát | kvalifikovaný podpis | **mandátny certifikát** s atribútom oprávnenia |
| Externé závislosti | Autogram | Autogram + **platená kvalifikovaná validačná služba** + štátny register |
| Právne postavenie | advokát podpisuje | advokát **vydáva verejnú listinu** ako oprávnená osoba |
| Rozsah | add-on na konci prípravy | **samostatný softvérový projekt** |

Podpisovanie je integrácia. Zaručená konverzia je **produkt**.

## Problém

Advokát je podľa § 35 zákona č. 305/2013 Z. z. **oprávnená osoba** na výkon zaručenej konverzie. Dnes to rieši mimo akéhokoľvek AI nástroja — v hotových riešeniach (D.Convert, OverSi, systémy komôr) alebo vôbec. Prepojenie na spis chýba.

## Čo je overené *(Slov-Lex, 2026-08-12)*

Detail v [rešerši](../research/pravny-ramec/2026-08-12-zarucena-konverzia-sk.md); tu len to, čo určuje rozsah:

- **§ 2 ods. 2 vyhl. 70/2021** — novovzniknutý elektronický dokument môže byť **výlučne `.pdf` alebo `.png`**.
- **§ 2 ods. 3** — osvedčovacia doložka ako samostatná časť dokumentu sa vyhotovuje **vo formáte `.xml` zahrnutom v `.pdf` ako príloha typu `EmbeddedFile`**. *(Rešerše si v tomto protirečili — jedna tvrdila ASiC kontajner. Vyhláška hovorí `EmbeddedFile`.)*
- **§ 3 ods. 3 písm. a)** — dokument a doložka musia byť **spoločne autorizované** KEP s **mandátnym certifikátom** + **kvalifikovanou časovou pečiatkou**.
- **§ 3 ods. 4** — podpis na pôvodnom dokumente sa **musí** skontrolovať **kvalifikovanou službou validácie** a jej výstup sa **uchováva v zázname**.
- **§ 3 ods. 1 písm. a)** — bezpečnostné prvky listiny kontroluje **vizuálne osoba vykonávajúca konverziu**.

## Prečo to nejde do V1 ani do V2

**1. Sú to tri softvérové domény naraz**, v ktorých tím nemá nikoho:

- kryptografia a PKI — PAdES/XAdES/CAdES, mandátne certifikáty, dlhodobá archívna platnosť, časové pečiatky,
- presná manipulácia s formátmi — PDF/A podľa ISO, `EmbeddedFile` v katalógu PDF, OCR s textovou vrstvou,
- vládne B2B rozhranie — SOAP/WSDL, IAM autentifikácia, synchrónny zápis do štátneho registra.

**2. Chyba má disciplinárne následky.** Advokát vydáva verejnú listinu. Technicky nedokonalá konverzia = nepravdivá verejná listina.

**3. Existujú hotové riešenia a rešerš sama odporúča ich používať.** Vlastná implementácia dáva zmysel len pri potrebe hlbokej integrácie, plnej kontroly nad dátami alebo špecializovaného workflow.

**4. Štátne špecifikácie sa menia.** Verzia 1.2 formulárov je *(podľa rešerše, neoverené)* odložená na **1. 1. 2027** a pripravuje sa **EZZK 2.0**. Stavať dnes na verzii, ktorá sa o rok mení, je práca navyše.

> [!IMPORTANT]
> **MČ si na zaručenú konverziu stavia samostatnú aplikáciu.** To je správne miesto pre túto funkcionalitu — mimo LAWOSS, s vlastným životným cyklom. Ak dozreje, LAWOSS ju môže volať rovnakým spôsobom ako Autogram: **ako externý proces, nie ako vendorovaný kód.**

## Navrhovaný postup — čo robiť namiesto stavania

| Krok | Čo | Kedy |
|---|---|---|
| 1 | **Nechať to mimo LAWOSS.** Žiadny konverzný kód v našom repe ani vo forku. | teraz |
| 2 | **Overiť neoverené** — sadzobník *(najmä podozrivý údaj „OCR 5 € za stranu")*, stav CEZZK API, odklad formulárov na 2027. | pred akýmkoľvek rozhodnutím |
| 3 | **Overiť, či slovenský advokátsky preukaz funguje ako mandátny certifikát** cez PKCS#11 — to je otvorená otázka aj v spec 0007. | pri testovaní podpisovania |
| 4 | **Ak MČ appka dozreje** — integrovať cez rozhranie samostatného procesu, ako Autogram. | neurčené |

## Bezpečnostné a licenčné hranice *(záväzné, ak by sa niekedy integrovalo)*

- **Žiadne vendorovanie** konverzného enginu do LAWOSS — rovnaké pravidlo ako pri Autograme.
- **Vizuálnu kontrolu bezpečnostných prvkov nesmie robiť agent** — zákon ju priraďuje osobe vykonávajúcej konverziu.
- **Mandátny certifikát a PIN nikdy neprechádzajú cez LAWOSS.**
- **Výstup sa zaraďuje do spisu podľa OKF** s auditnou stopou — to je jediná časť, ktorú by LAWOSS realisticky pridával.
- Údaje v zázname o konverzii podliehajú **mlčanlivosti a GDPR** — do štátneho registra ide len zákonom vyžadovaný rozsah.

## Otvorené otázky

- [ ] Funguje **slovenský advokátsky preukaz** ako mandátny certifikát cez PKCS#11? *(spoločné so spec 0007)*
- [ ] Aká je **reálna cena kvalifikovanej validačnej služby** za úkon? Určuje, či sa to vôbec ekonomicky oplatí.
- [ ] Platí sadzobník tak, ako ho uvádzajú rešerše? **Údaj o OCR treba overiť ako prvý.**
- [ ] Je odklad formulárov na 1. 1. 2027 skutočný, a týka sa záznamov aj doložiek?
- [ ] Rieši sa zaručená konverzia v ČR obdobne? **Tento spec je zatiaľ len SK** — dvojjurisdikčnosť projektu vyžaduje aj český pohľad.

---

<sub>Pripravil MČ s AI asistenciou, 2026-08-12. Ustanovenia vyhlášky 70/2021 overené cez Slov-Lex 2026-08-12 (znenie od 2024-04-01). Tvrdenia o CEZZK API, sadzobníku a odklade formulárov sú prevzaté z AI rešerší a **neoverené** — detail v [podklade](../research/pravny-ramec/2026-08-12-zarucena-konverzia-sk.md).</sub>
