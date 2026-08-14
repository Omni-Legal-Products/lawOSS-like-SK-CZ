# Zdrojové rešerše — zaručená konverzia

> [!CAUTION]
> **Toto sú surové, NEOVERENÉ výstupy AI nástrojov. Necituj z nich a nerozhoduj podľa nich.**
> Preverená destilácia je o úroveň vyššie: **[2026-08-12-zarucena-konverzia-sk.md](../2026-08-12-zarucena-konverzia-sk.md)**. Tam je oddelené to, čo bolo overené v Slov-Lexe, od toho, čo z týchto dokumentov len preberáme.

- **Zadal:** MČ · august 2026
- **Uložené do repa:** 2026-08-12
- **Spracované do:** [rešerš](../2026-08-12-zarucena-konverzia-sk.md) → [spec 0010](../../../specs/0010-zarucena-konverzia.md)

## Čo tu je

| Súbor | Nástroj | Charakter |
|---|---|---|
| [Analýza zaručenej konverzie](2026-08-12-analyza-zarucenej-konverzie.md) | AI rešerš s citáciami | najpodrobnejšia; architektonický pohľad, päť funkčných blokov, sadzobník |
| [Report SR](2026-08-12-zarucena-konverzia-SR-report.md) | AI rešerš s citáciami | právny rámec, dátové prvky, EZZK 2.0 |
| [Grok report](2026-08-12-grok-report-integracia-ZK.pdf) | Grok | najkonkrétnejší k integrácii — SOAP metódy, endpointy, chybové kódy, checklist |

## Prečo sú tu, keď sú neoverené

Aby sa dalo spätne dohľadať, **odkiaľ ktoré tvrdenie prišlo**, a aby nikto nemusel rešerš zadávať znova. Sú to podklady, nie pramene.

## Známe problémy v týchto dokumentoch

1. **Protirečia si.** Analýza tvrdí, že XML doložka ide do PDF ako `EmbeddedFile`; report tvrdí „jeden podpisový kontajner ASiC". **Vyhláška 70/2021 § 2 ods. 3 hovorí `EmbeddedFile`** *(overené v Slov-Lexe 2026-08-12)* — report je v tomto bode nepresný.
2. **Sadzobník je podozrivý.** Údaj „OCR 5,00 € za stranu A4" je o dva rády mimo ostatných položiek *(strana skenu 0,10 €)*. Pred akýmkoľvek použitím overiť v prílohe vyhlášky.
3. **Odkazy neboli preverené.** Časť citovaných URL sa nedala overiť; niektoré vedú na dokumenty, ktoré medzitým mohli byť nahradené.
4. **Dátumy účinnosti preberajú rešerše navzájom nekonzistentne** *(odklad formulárov 1. 1. 2027, zmeny od 1. 10. 2025)* — neoverené.

<sub>Uložené bez úprav, tak ako ich dodal MČ. Repo je verejné — dokumenty neobsahujú klientske údaje ani tajomstvá.</sub>
