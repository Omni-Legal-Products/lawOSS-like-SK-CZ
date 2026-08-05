---
name: lawoss-spec-review
description: Review LAWOSS specifications, ADRs, backlogs, and roadmap changes for scope, authorship, evidence, safety, and testable acceptance criteria. Use before opening or reviewing a substantial LAWOSS documentation PR.
---

# LAWOSS specification review

Use the existing repository `AGENTS.md` as the source of truth. This skill adds review checks; it does not replace or duplicate those instructions.

## Review checklist

- The document clearly says whether it is an idea, proposal, approved decision, deferred item, or rejected item.
- The author, date, jurisdictional scope, and verification method are recorded.
- Slovak and Czech implications are separated where they differ.
- The problem, non-goals, alternatives, dependencies, risks, and human gates are explicit.
- Claims about legal sources, providers, licenses, model terms, or product status have a date and source.
- The design has an observable acceptance criterion or a concrete next research step.
- The document does not promise product behavior that is not implemented.
- A new proposal is recorded in `specs/navrhy.md` when the repository rules require it.
- README AUTO sections are never edited manually.

## Output

Return findings under four labels:

1. Must fix before merge.
2. Should clarify.
3. Evidence to add.
4. Explicitly unresolved decision.

Do not silently rewrite authorship, convert a proposal into a decision, or mark a source as verified without checking it.
