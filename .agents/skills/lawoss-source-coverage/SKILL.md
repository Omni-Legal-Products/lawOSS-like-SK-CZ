---
name: lawoss-source-coverage
description: Build or review LAWOSS legal-research workflows with explicit source coverage, provenance, fallback boundaries, and human gates. Use for LAWOSS specs, research ledgers, MCP routing, and source-verification workflows.
---

# LAWOSS source coverage

Use this skill together with the global `legal-source-routing` skill. Do not duplicate Gravity connector logic in this repository.

## Required workflow

1. Read the repository `AGENTS.md` and identify whether the work is a proposal, ADR, research note, or implementation handoff.
2. State the jurisdiction, relevant date, legal issue, and whether the output is exploratory or intended for a legal deliverable.
3. Start with official connectors. For Slovak law use Slov-Lex; for Slovak case law use the relevant NS SR, NSS SR, ÚS SR, and general-courts connectors; add EUR-Lex or HUDOC only when relevant.
4. Record a compact source-coverage manifest before drawing a conclusion.
5. Read promising full texts, verify the exact locator, and distinguish source-backed statements from inference and uncertainty.
6. Treat public-web fallback as an explicit opt-in secondary lead. Never present it as canonical authority.
7. Require a human gate before a deadline, matter fact, citation, status file, external action, or final legal output is written.

## Minimum coverage manifest

Every reusable research result should preserve:

- source family and provider;
- official/source URL and stable identifier;
- retrieved timestamp;
- effective date or decision date where relevant;
- availability: metadata, document, or full text;
- exact paragraph, page, section, spisová značka, ECLI, or CELEX locator;
- coverage limits and unresolved uncertainty;
- whether a fallback source was used.

## Safety rules

- Absence from an index means not found in the indexed corpus, not non-existence.
- Do not infer that a decision remains good law from an absent treatment relation.
- For date-sensitive issues, invoke law-drift checks and compare the text in force on the relevant date.
- Do not put client data, credentials, or bearer tokens into research notes or this repository.
