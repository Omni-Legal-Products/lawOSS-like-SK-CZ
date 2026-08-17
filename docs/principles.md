# Princípy

Tieto princípy rozvíjajú [základnú produktovú doktrínu](../decisions/0009-zakladna-produktova-doktrina.md), ktorá je k 2026-08-12 navrhnutá a čaká na potvrdenie tímom. Po potvrdení sú záväzným filtrom pre významné produktové rozhodnutia.

1. **Otvorené a upraviteľné jadro.** LAWOSS je open-source a bezplatný základ, ktorému právnik rozumie a ktorý môže upraviť. Bezpečné predvolené nastavenia nesmú zakryť podstatné rozhodnutia systému.
2. **Model podľa úlohy.** Používateľ volí model podľa kvality, ceny, rýchlosti, súkromia a povahy úlohy. Žiadny model ani dodávateľ nesmie byť povinnou jedinou cestou.
3. **Prenositeľné skilly, MCP a workflowy.** Skilly, MCP servery, prompty, automatizácie a pracovné postupy musia byť zrozumiteľné, upraviteľné a prenositeľné medzi konfiguráciami, kde to umožňujú ich závislosti a licencie.
4. **Kontrola dát a pamäte.** Právnik riadi dáta, právne know-how, pamäť aj miesto spracovania a uloženia. Otvorenosť neznamená zverejňovanie klientskych dát ani interného know-how.
5. **Audit a provenance.** Pri podstatnom výstupe musí byť možné zistiť použitý model, nástroj, zdroj a pravidlo, aby právnik vedel výstup preveriť a obhájiť.
6. **Agent-first architektúra s human approval.** Agenti pripravujú, organizujú, kontrolujú a vyhľadávajú. Právnik stanovuje cieľ, riadi riziko a ako supervízor schvaľuje výsledok; intenzita human approval je primeraná riziku úlohy.
7. **Zákaz povinného vendor lock-in.** Používateľ musí mať možnosť systém pochopiť, upraviť, vymeniť jeho časti alebo opustiť. Predvolená konfigurácia je pomoc, nie uzamknutie.
8. **Platformová špecializácia bez nútenej parity.** Každá podporená platforma môže využívať svoje vlastné silné stránky. Funkčná parita nie je povinná, ak by bránila lepšiemu, bezpečnejšiemu alebo prirodzenejšiemu workflowu.
9. **Overovanie tvrdení o konkurencii.** Verejné tvrdenia o cenách, modeloch, promptoch alebo funkciách konkurencie vyžadujú aktuálne a doložené overenie. LAWOSS sa opisuje vlastnými vlastnosťami, nie neoverenými porovnaniami.
10. **Výnimky iba cez ADR.** Výnimka, ktorá obmedzí kontrolu, individualizáciu alebo audit, vyžaduje samostatný ADR s výslovným odôvodnením, mitigáciou a časovým obmedzením.

## Rozhodovací test

Pred významným feature, ADR alebo partnerstvom si overíme, či návrh:

1. zvyšuje kontrolu právnika nad modelmi, dátami, nástrojmi a know-how,
2. zachováva možnosť systém pochopiť, upraviť, vymeniť alebo opustiť,
3. posilňuje schopnosť právnika bezpečne riadiť agentov,
4. zachováva audit, provenance a primerané human approval,
5. nevytvára povinný black box ani vendor lock-in,
6. umožňuje platformám a kanceláriám využiť vlastné výhody bez nútenej uniformity.

Ak návrh zlyhá v ktoromkoľvek bode, bez samostatného ADR sa výnimka neprijíma.
