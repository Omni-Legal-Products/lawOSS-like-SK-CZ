---
name: lawoss-workflow-router
description: Route an anonymized Slovak, Czech, EU, or ECHR legal-research request to an appropriate reusable workflow with explicit intake, source coverage, dates, outputs, and human review. Use when selecting, planning, or auditing a LAWOSS legal workflow before research or drafting.
---

# LAWOSS workflow router

Use this skill to select and explain a reusable legal workflow before substantive research or drafting. It is a planning and routing layer. It does not replace legal-source-routing, legal-research, a document skill, or human legal judgment.

## Safety boundary

Work only with synthetic or fully anonymized inputs. Remove client names, identifiers, privileged facts, credentials, bearer tokens, unpublished case material, and matter-specific deadlines. If safe redaction is not possible, stop and request a private, human-controlled workflow.

Do not duplicate Gravity connector logic. Use the global legal-source-routing skill and the configured official connectors. When the Gravity CLI is available, use its registered workflow catalogue through legal-cli workflow; do not invent a separate legalflow executable or connector.

## Intake

Record these fields before choosing a workflow:

- legal question and intended decision;
- jurisdiction and source hierarchy;
- relevant legal date, decision date, or time interval;
- procedural or work-product context;
- expected output and citation requirement;
- whether the task is exploratory, internal, or intended for a legal deliverable;
- known source identifiers, documents, or exact locators;
- privacy classification: synthetic | anonymized | confidential.

If a field is unknown, mark it unknown and identify the smallest clarification needed. Do not silently assume that current law, a current decision, or an available full text applies.

## Routing map

Choose the narrowest workflow that fits the stated objective:

- legal-research-memo: source-routed research with extraction, synthesis, citation QA, and finalization;
- contract-review: issue spotting and review of an existing agreement;
- contract-drafting: preparation of a contract or amendment from instructions and a controlling model;
- court-submission: source-backed preparation or audit of a court filing;
- judgment-analysis: structured analysis of a judgment, order, or administrative decision;
- case-law-extraction: extraction of holdings, reasoning, facts, and locators from decisions;
- document-summarization: bounded summary of a supplied document;
- matter-context-pack: creation of a reusable, redacted matter context pack;
- research-digest: recurring or comparative digest of identified research sources.

If no registered workflow fits, return a proposed workflow specification instead of pretending that a workflow exists. If more than one fits, choose a primary workflow and list secondary phases or handoffs.

## Routing procedure

1. Classify the task by objective, jurisdiction, relevant date, output, and authority level.
2. Select the workflow ID and explain why it is the narrowest fit.
3. Identify required phases and the source families needed in each phase.
4. Hand source selection to legal-source-routing. Prefer official connectors and record metadata, document, or full-text availability.
5. Add law-drift analysis when the question depends on wording in force on a past date or on a change between versions.
6. Add citation QA when the output contains authorities, quotations, footnotes, or a bibliography.
7. Add a document or template skill only when a rendered artifact is explicitly requested.
8. Define the output fields, uncertainty disclosure, and mandatory human gate.
9. State what the workflow must not do, including external writes, filing, messaging, or treating missing index results as proof of non-existence.

## Output contract

Return:

1. selected workflow ID;
2. routing rationale;
3. intake fields and missing information;
4. phase-by-phase source-routing plan;
5. dependencies on existing skills or connectors;
6. expected output and citation/provenance fields;
7. uncertainty and fallback boundaries;
8. human review gate and non-goals;
9. escalation or handoff recommendation.

A routed workflow is a plan, not a legal conclusion.