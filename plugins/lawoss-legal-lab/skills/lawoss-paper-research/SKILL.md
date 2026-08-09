---
name: lawoss-paper-research
description: Turn an anonymized legal-science research question into a source-mapped paper proposal with research questions, method, legal authorities, academic literature, citation handoff, uncertainty, and a synthetic test. Use in the LAWOSS Legal Lab for legal scholarship or interdisciplinary research before stable-plugin promotion.
---

# LAWOSS paper research lab

This is an experimental research-method skill. It structures legal-science research proposals; it does not approve a methodology, provide legal advice, or replace legal-research, legal-source-routing, law-drift-analysis, or iso-690-sk-citations.

## Safety boundary

Use only synthetic or fully anonymized examples. Remove client names, identifiers, privileged facts, credentials, bearer tokens, unpublished case material, and matter-specific deadlines. If a question cannot be safely anonymized, stop and move it to a private human-controlled workflow.

## Research procedure

1. Define the research problem, jurisdiction, relevant legal period, target audience, and intended contribution.
2. Formulate a primary research question, secondary questions, and falsifiable or auditable sub-claims.
3. Choose a method: doctrinal, comparative, historical, empirical, interdisciplinary, or mixed. Explain the fit and limits of the method.
4. Route Slovak, Czech, EU, and ECHR authorities through legal-source-routing and legal-research. Use law-drift-analysis for historical or version-sensitive questions.
5. Search academic literature through an appropriate scholarly index when available. Consensus may be used as an optional literature-discovery source; it is not a substitute for primary legal authority or full-text verification.
6. Build a source map that separates primary law, case law, official explanatory material, peer-reviewed literature, and secondary commentary.
7. Verify stable identifiers, exact locators, dates, availability level, and access limitations. Record what was not found.
8. Synthesize source-backed findings, methodological choices, inferences, counterarguments, and open questions separately.
9. Hand citations to iso-690-sk-citations when Slovak ISO 690 footnotes or bibliography are required.
10. Define a synthetic test case and acceptance criteria before recommending promotion from the lab.
11. Require human review before publication, submission, legal advice, or conversion into a stable LAWOSS skill.

## Required output

Return:

### Research brief

Problem, contribution, jurisdiction, relevant period, audience, non-goals, and privacy classification.

### Research questions and method

Primary and secondary questions, method choice, assumptions, competing explanations, and methodological limits.

### Source map

For every source, record type, provider, stable identifier or URL, date, exact locator, availability level, retrieval timestamp, relevance, and coverage limitation.

### Evidence and synthesis

Separate verified propositions from inferences, methodological judgments, counterarguments, and unresolved interpretation.

### Citation handoff

List the sources needing formal citation normalization and identify missing metadata. Do not invent citations.

### Paper outline

Propose a concise title, abstract thesis, section structure, and argument map. Mark every claim that still needs authority or literature support.

### Synthetic test and acceptance criteria

Provide a non-client test scenario, expected source coverage, expected output fields, at least one failure or uncertainty path, and observable promotion checks.

### Lab disposition

Recommend keep in lab, revise, submit to LAWOSS review, or promote after review. Never describe an experimental proposal as approved policy or legal advice.

## Promotion rules

- New or untested methods remain in LAWOSS Legal Lab.
- Promotion requires a documented review, source-coverage completeness, explicit uncertainty, a passing synthetic test, and a human approval gate.
- Legal-methodology proposals belong in LAWOSS repository review.
- Portable-format, interoperability, or cross-client proposals may be considered separately for Agent Plugins upstream.
- Do not store client material, credentials, or matter-specific content in this public plugin.
