# Zaručená konverzia (SR) — právny rámec a integračné požiadavky

- **Dátum:** 2026-08-12
- **Zadal:** MČ · rešerš spracovaná tromi AI nástrojmi *(Gemini-štýl analýza, druhý report, Grok report)*
- **Spracoval:** MČ s AI asistenciou
- **Súvisí:** [spec 0010](../../specs/0010-zarucena-konverzia.md) · [spec 0007 podpisovanie](../../specs/0007-podpisovanie-a-zarucena-konverzia.md) · [návrh #26](../../specs/navrhy.md)

> [!IMPORTANT]
> **Zdroje sú AI rešerše, nie primárne pramene.** Preto je nižšie **oddelené to, čo som overil priamo v Slov-Lexe, od toho, čo z rešerší len preberáme.** Neoverené tvrdenia sú takto označené a **pred akoukoľvek implementáciou sa musia overiť**.

---

## ✅ Overené v primárnom zdroji *(Slov-Lex, 2026-08-12)*

### Vyhláška MIRRI č. 70/2021 Z. z. v znení novely 63/2024, § 2 — formáty

- **Novovzniknutý elektronický dokument** *(pri konverzii L→E a E→E)* môže byť **výlučne**:
  - textový súbor **`.pdf`**, alebo
  - grafický súbor **`.png`**.
- **Osvedčovacia doložka**, ak je vyhotovená ako samostatná časť novovzniknutého dokumentu podľa § 37 ods. 4 zákona, sa vyhotovuje **vo formáte `.xml`, zahrnutého v `.pdf` ako príloha typu `EmbeddedFile`**.

> [!WARNING]
> **Rešerše si v tomto bode protirečili.** Jedna tvrdila `EmbeddedFile` v PDF, druhá „jeden podpisový kontajner ASiC". **Znenie § 2 ods. 3 hovorí `EmbeddedFile` v PDF** — ASiC vyhláška v tomto ustanovení nespomína. *(Poznámka: odsek sa výslovne týka doložky ako **samostatnej časti** novovzniknutého dokumentu; iné konfigurácie, najmä výstup do PNG, tu upravené nie sú — odtiaľ zrejme pochádza zmätok v rešeršiach.)*

### Vyhláška 70/2021, § 3 — posudzovanie úrovne záruk

- **§ 3 ods. 3 písm. a)** — novovzniknutý elektronický dokument a osvedčovacia doložka musia byť **spoločne autorizované** osobou vykonávajúcou konverziu, a to buď:
  1. **kvalifikovaným elektronickým podpisom s použitím mandátneho certifikátu** + **kvalifikovanou elektronickou časovou pečiatkou** zahŕňajúcou objekt podpisu, alebo
  2. **kvalifikovanou elektronickou pečaťou** + kvalifikovanou časovou pečiatkou.
- **§ 3 ods. 4** — kvalifikovaný podpis alebo pečať na pôvodnom dokumente **musí byť skontrolovaný kvalifikovanou službou validácie** kvalifikovaných elektronických podpisov a pečatí, a **výstup z tejto kvalifikovanej dôveryhodnej služby sa uchováva v zázname o konverzii**.
- **§ 3 ods. 1 písm. a)** — pri listinnom origináli sa bezpečnostné prvky kontrolujú **vizuálne osobou vykonávajúcou konverziu** *(vodoznak, reliéfna tlač, embosovanie, pečať, ochranný vzor, optický variabilný prvok, ochranná fólia, nálepka…)*.

**Tri dôsledky, ktoré z overeného textu plynú priamo:**

| Dôsledok | Prečo je to zásadné |
|---|---|
| **Mandátny certifikát je povinný** | Nestačí bežný KEP na eID — potrebný je certifikát s atribútom oprávnenia (advokát). |
| **Kvalifikovaná validačná služba je povinná a platená** | Nejde o knižnicu, ktorú si nasadíme. Je to **externá dôveryhodná služba tretej strany** a jej výstup sa archivuje. |
| **Vizuálnu kontrolu robí človek** | Zákon ju priraďuje *osobe vykonávajúcej konverziu*. **Toto nie je delegovateľné na agenta** — sedí to presne na hranicu z [ADR 0007](../../decisions/0007-agent-first-architektura.md) *(zatiaľ len v [PR #19](https://github.com/originalmagneto/lawOSS-like-SK-CZ/pull/19))*. |

---

## 📋 Prebraté z rešerší — **NEOVERENÉ**, na overenie pred implementáciou

> Nasledujúce pochádza z AI rešerší a **nebolo overené v primárnom zdroji.** Uvádzame preto, že sa to zhodovalo naprieč viacerými nezávislými rešeršami, čo zvyšuje pravdepodobnosť správnosti, ale **nenahrádza overenie**.

### Povinná integrácia na centrálnu evidenciu (CEZZK / IS EZZK)

Od 1. 12. 2019 má byť každý výkon zaručenej konverzie zapísaný do centrálnej evidencie. Podľa rešerší:

- registrácia oprávnenej osoby na **`iomo.sk/ezzkregistracia`**, formulár sa podpisuje mandátnym certifikátom,
- testovacie prostredie **`ezzk-test.iomo.sk`**, verejné overenie **`ezzk.iomo.sk`**,
- komunikácia cez **SOAP/WSDL**, Integračný manuál EZZK v1.4,
- **evidenčné číslo sa vyžiada PRED konverziou** a vkladá sa do doložky v tvare URI `https://data.gov.sk/id/egov/conversion-record/{ID}`,
- **záznam sa odosiela do 24 hodín** od vytvorenia.

Uvádzané metódy API: `GetConversionRecordEvidenceNumber` · `ConsumeConversionRecordEvidenceNumber` · `ReceiveConversionRecord` · `GetConversionRecord` · `getConversionRecordInformationPurpose`.

### Elektronické formuláre (eForm)

Datasety pre záznamy aj doložky, tri smery konverzie *(E→L, L→E, E→E)*, napr. `50349287.ConversionCertificateOfPaperToElectronicDocument`. Podľa rešerší sú **účinné verzie 1.0–1.4**, pričom **verzia 1.2 formulárov záznamov je odložená na 1. 1. 2027**, a pripravuje sa projekt **EZZK 2.0**.

### Sadzobník úhrad — **osobitne neoverené, jedno číslo vyzerá podozrivo**

| Úkon | Uvádzaná suma |
|---|---|
| Vytvorenie osvedčovacej doložky | 1,00 € |
| L→E, za každú aj začatú stranu A4 | 0,10 € |
| L→E, A3 | 0,20 € |
| E→L, za každú aj začatú stranu A4 | 0,20 € |
| E→L, A3 | 0,40 € |
| E→E *(paušál)* | 0,33 € |
| **Príplatok za OCR, za stranu A4** | **5,00 €** ⚠️ |

> [!CAUTION]
> **Údaj „OCR 5,00 € za stranu" považujem za pravdepodobne chybný.** Je o dva rády mimo ostatných položiek *(strana skenu 0,10 €)* a bol by ekonomicky absurdný. **Pred akýmkoľvek použitím overiť v prílohe vyhlášky.** Ostatné sumy sú tiež neoverené.

### Ďalšie technické tvrdenia z rešerší

- výstupom má byť **PDF/A-1a alebo PDF/A-2a s textovou vrstvou** (OCR), nie iba obrázok v PDF,
- systém musí vedieť parsovať aj **historické slovenské formáty podpisov** (ZEP, `.xzep`, `.zepx`),
- odporúčaná knižnica: **CEF eSignature DSS** od Európskej komisie,
- smeruje sa k **zrušeniu lokálnej evidencie** v prospech výlučne centrálnej *(uvádzané zmeny od 1. 10. 2025)*.

---

## 🎯 Záver, na ktorom sa všetky tri rešerše zhodli

**Zaručená konverzia nie je „podpísané XML". Je to prienik troch samostatných softvérových domén:**

1. **kryptografia a PKI** — PAdES/XAdES/CAdES, mandátne certifikáty, dlhodobá archívna platnosť (LTV), kvalifikované časové pečiatky,
2. **presná manipulácia s formátmi** — PDF/A podľa ISO, `EmbeddedFile` v katalógu PDF, OCR s textovou vrstvou,
3. **vládne B2B rozhranie** — SOAP/WSDL, IAM autentifikácia, synchrónny zápis do štátneho registra.

Tretia rešerš *(Grok)* to hovorí najpriamejšie a stojí za doslovné zopakovanie:

> Väčšina advokátov a notárov používa v produkcii hotové riešenia (**D.Convert**, **OverSi**, systémy komôr). Vlastná implementácia dáva zmysel len vtedy, ak potrebuješ hlbokú integráciu do existujúcich nástrojov, plnú kontrolu nad dátami a auditom, alebo plánuješ špecializované workflow.

**To potvrdzuje rozhodnutie MČ zo 7. 8. 2026** — zaručená konverzia nejde do V1 ani do V2. → [spec 0010](../../specs/0010-zarucena-konverzia.md)

---

## Zdrojové dokumenty

Tri AI rešerše zadané MČ *(august 2026)*. **Uložené sú v [`zdroje-zarucena-konverzia/`](zdroje-zarucena-konverzia/)** — ako podklady, nie ako pramene. Sú to surové výstupy AI nástrojov s neoverenými tvrdeniami; časť odkazov sa nedala preveriť a v jednom bode si navzájom protirečia. **Tento súbor je ich preverená destilácia — cituj z neho, nie z nich.**

**Primárne pramene, ktoré stoja za overenie čohokoľvek ďalšieho:**

- [Zákon č. 305/2013 Z. z. o e-Governmente](https://www.slov-lex.sk/ezbierky/pravne-predpisy/SK/ZZ/2013/305/), §§ 35–39
- [Vyhláška MIRRI č. 70/2021 Z. z. o zaručenej konverzii](https://www.slov-lex.sk/ezbierky/pravne-predpisy/SK/ZZ/2021/70/20240401) v znení [novely č. 63/2024 Z. z.](https://www.slov-lex.sk/ezbierky-fe/pravne-predpisy/SK/ZZ/2024/63/)
- [Nariadenie eIDAS (EÚ) č. 910/2014](https://eur-lex.europa.eu/legal-content/SK/TXT/?uri=CELEX%3A32014R0910) a zákon č. 272/2016 Z. z. o dôveryhodných službách
- [MIRRI — Zaručená konverzia](https://mirri.gov.sk/sekcie/informatizacia/dokumenty/zakon-o-e-governmente/zarucena-konverzia/) a [CEZZK](https://mirri.gov.sk/sekcie/informatizacia/dokumenty/zakon-o-e-governmente/centralna-evidencia-zaznamov-o-vykonanej-zarucenej-konverzii/)

<sub>Overenie § 2 a § 3 vyhlášky 70/2021 vykonané cez Slov-Lex 2026-08-12 (znenie účinné od 2024-04-01). Všetko ostatné je prevzaté z AI rešerší a označené ako neoverené.</sub>
