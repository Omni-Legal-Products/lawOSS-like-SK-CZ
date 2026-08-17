---
name: lawoss-workflow-capture
description: Turn an anonymized legal-workflow idea or research-method suggestion into a source-traceable LAWOSS proposal for testing and human review. Use when capturing, refining, comparing, or preparing a workflow proposal for the LAWOSS legal plugin.
---

# LAWOSS workflow capture

This is an experimental proposal skill. It records and structures ideas; it does not approve a legal method, create a final legal conclusion, open a GitHub issue, change a repository, or write to a client matter.

## Safety boundary

Before continuing, remove or replace client names, identifiers, confidential facts, privileged content, credentials, bearer tokens, unpublished case material, and matter-specific deadlines. Use a synthetic or fully anonymized example. If safe redaction is not possible, stop and request a human-controlled private workflow.

Do not duplicate Gravity connector logic. Refer to the existing legal-source-routing skill and the configured official connectors instead.

## Capture workflow

1. Classify the item as an idea, proposal, approved decision, deferred item, or rejected item. Never silently upgrade its status.
2. Record the author, date, jurisdiction, relevant legal date, and intended audience.
3. State the problem and the proposed workflow in operational terms: input, source-routing steps, verification steps, output, and human gate.
4. Identify the official source families and connectors that would be used. State whether each source provides metadata, a document, or full text.
5. Record stable identifiers, exact locators, retrieval timestamps, coverage limits, fallback sources, and unresolved uncertainty.
6. Separate source-backed facts, methodological choices, inferences, and open questions.
7. Define a synthetic test case and observable acceptance criteria before recommending promotion.
8. Recommend one disposition: keep in lab, revise, submit to LAWOSS for review, or promote to the stable plugin after acceptance.

## Proposal template

Return a Markdown proposal with these headings and complete every field:

### Title and status

- Title:
- Status: idea | proposal | approved | deferred | rejected
- Author:
- Created or revised:
- Intended audience:

### Scope

- Jurisdiction:
- Relevant legal date:
- Legal-workflow problem:
- Non-goals:
- Privacy classification: synthetic | anonymized | confidential — confidential items must not continue here

### Proposed workflow

Describe the inputs, routing sequence, source verification, output format, and mandatory human review gate. Identify which existing skills or connectors are called and why.

### Source-coverage manifest

For every source family, record:

- provider and source family;
- official URL or stable identifier;
- retrieved timestamp;
- availability: metadata | document | full text;
- exact locator: paragraph, page, section, ECLI, CELEX, spisová značka, or equivalent;
- coverage limits;
- fallback source, if any;
- verification status.

### Evidence and uncertainty

Separate verified source statements from inferences and methodological choices. State what was not found and whether the limitation is an index limitation, unavailable full text, date uncertainty, or unresolved interpretation.

### Synthetic test case

Provide a non-client example with expected inputs, expected source coverage, expected output fields, and at least one failure or uncertainty path.

### Acceptance criteria

List observable checks, including provenance completeness, date-sensitive source handling, explicit uncertainty, human-gate placement, and the prohibition on confidential data.

### Review handoff

Return:

1. proposal Markdown;
2. source-coverage manifest;
3. synthetic test scenario;
4. open questions and risks;
5. promotion recommendation: keep in lab, revise, submit to LAWOSS review, or promote after acceptance.

## Promotion rules

- Keep experimental or untested methods in the lab.
- Promote to the stable LAWOSS plugin only after a documented review and passing synthetic test.
- Send proposals to LAWOSS repository review when they concern legal methodology or workflow behavior.
- Reserve Agent Plugins upstream proposals for portable-format, interoperability, or cross-client concerns.
- Never present a lab proposal as an approved LAWOSS policy or as legal advice.
