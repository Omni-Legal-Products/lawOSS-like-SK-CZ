---
name: lawoss-law-drift
description: Compare legal wording and authority across dates for Slovak, Czech, EU, or ECHR research, with explicit version identity, exact locators, source coverage, and uncertainty. Use when a legal answer depends on historical law, amendments, transitional provisions, or whether a decision applied the text in force on a relevant date.
---

# LAWOSS law-drift analysis

Use this skill for date-sensitive legal questions. Pair it with the global law-drift-analysis and legal-source-routing skills when they are available. This skill specifies the analysis contract; it does not bundle or duplicate Gravity connectors.

## Safety boundary

Use only synthetic or fully anonymized matter descriptions. Do not include client identities, privileged facts, credentials, bearer tokens, unpublished case material, or live deadlines. Do not write a result into a pleading, matter file, status file, or external system without human review.

## Required intake

Record:

- jurisdiction and instrument;
- statute, regulation, treaty, or decision identifier;
- paragraph, article, section, or other target provision;
- date on which the relevant legal effect occurred;
- comparison date or current date;
- legal question the comparison is meant to answer;
- known amendment, transitional, or repeal event;
- required output and citation style.

If the relevant date or exact provision is missing, flag it before research. “Current text” is not a substitute for the text in force on the relevant date.

## Analysis procedure

1. Resolve the identity of the instrument and target provision using an official source.
2. Determine the legally relevant interval, including commencement, amendment, repeal, transitional, and delayed-effect rules where relevant.
3. Retrieve the wording in force at each comparison point. Record whether the result is metadata, a document, or full text.
4. Preserve exact locators and retrieval timestamps for every version.
5. Compare the versions at the smallest meaningful unit: wording, scope, defined term, exception, sanction, procedural consequence, or temporal rule.
6. Separate textual change from interpretive change, case-law development, and uncertainty caused by incomplete source coverage.
7. Explain the possible legal significance only to the extent supported by the identified sources. Do not infer retroactivity, validity, or continuing effect without authority.
8. State what could not be verified, including unavailable historical text, index limitations, or unresolved effective-date questions.
9. Require human review before using the result as a legal conclusion or in a final work product.

## Output contract

Return these headings:

### Question and dates

State the issue, jurisdiction, target provision, relevant date, comparison date, and assumptions.

### Version identity and coverage

For every version, provide provider, official URL or stable identifier, effective interval, availability, exact locator, retrieval timestamp, and coverage limits.

### Textual comparison

Show the material differences in a compact table or faithful side-by-side excerpt. Do not quote beyond what is necessary.

### Legal significance

Separate source-backed propositions, interpretive inferences, and open questions. Address transitional or temporal rules explicitly.

### Uncertainty and fallback

State missing versions, unavailable full text, index limitations, and any secondary fallback source used.

### Human review gate

List the checks a lawyer must complete before relying on the result.

## Non-negotiable rules

- Never answer a historical-law question from an undated current text alone.
- Never treat an absent search result as proof that a version, decision, or amendment does not exist.
- Never cite a comparison without identifying both compared versions.
- Never hide an effective-date uncertainty behind confident prose.
- Never replace the official source-routing workflow with an invented connector or web-only shortcut.