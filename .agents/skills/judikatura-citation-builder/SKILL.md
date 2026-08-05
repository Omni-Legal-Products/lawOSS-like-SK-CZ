---
name: judikatura-citation-builder
description: Build source-traceable Slovak judiciary citations for LAWOSS research and legal drafts. Use when a decision, ECLI, spisová značka, treatment status, or quoted proposition must be verified before citation.
---

# Judiciary citation builder

This is a workflow skill, not a new connector. Use the existing Gravity connectors and the unified judiciary MCP only as an optional source adapter.

## Workflow

1. Resolve the decision identity using ECLI, normalized spisová značka, court, date, or provider identifier.
2. Fetch the full decision text or an authoritative document. Do not cite a metadata-only hit as if it contained the proposition.
3. Record the exact locator and a short quotation or faithful paraphrase.
4. Check treatment and case-chain information, treating an absent relation as an index limitation.
5. For NS SR or NSS SR authority, run the targeted ÚS SR status check required by `legal-source-routing`.
6. If the proposition depends on legislation, compare the wording in force on the relevant date through Slov-Lex.
7. Format the citation using `iso-690-sk-citations` when a formal bibliography or footnote is required.
8. Return the citation together with source URL, retrieval date, verification status, and remaining uncertainty.

## Prohibited shortcuts

- Do not use a web fallback as the only authority.
- Do not treat a citation mention as proof of appellate review.
- Do not call a decision current without checking the relevant date and constitutional status.
- Do not hide an unavailable full text or incomplete index behind confident prose.
- Do not write the citation into a final pleading without the required human review.
