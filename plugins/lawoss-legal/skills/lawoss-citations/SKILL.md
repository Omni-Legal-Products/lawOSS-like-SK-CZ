---
name: lawoss-citations
description: Normalize and audit source-traceable legal and academic citations for Slovak, Czech, EU, and ECHR work, including exact locators, metadata defects, retrieval dates, and uncertainty. Use when preparing, checking, or repairing footnotes, bibliographies, quotations, or authority ledgers in a LAWOSS workflow.
---

# LAWOSS citation QA

Use this skill to make citations referenceable and auditable. Pair it with the global iso-690-sk-citations skill when Slovak ISO 690 formatting is required. This skill can format supplied metadata without a connector, but it must not invent missing authority data.

## Safety boundary

Use synthetic or fully anonymized examples only. Do not place client names, privileged facts, credentials, bearer tokens, unpublished case material, or matter-specific deadlines in citations or examples.

## Citation procedure

1. Classify each source: legislation, court decision, administrative decision, EU act, ECHR material, book, article, chapter, dataset, website, or other source.
2. Resolve the source identity from a primary or authoritative provider whenever available.
3. Verify the metadata needed for the requested citation style: author or institution, title, court or publisher, date, edition, identifier, URL, DOI, ECLI, CELEX, spisová značka, and access date as applicable.
4. Record the exact locator supporting the proposition: paragraph, page, section, article, recital, ECLI passage, or equivalent.
5. Distinguish a full-text source from a metadata-only result. A metadata hit cannot support a quotation or a proposition that was not read.
6. Normalize the citation using iso-690-sk-citations or the requested style. Preserve legally meaningful capitalization, numbering, and source identifiers.
7. Return unresolved fields explicitly as missing, not guessed. Do not fabricate DOI, ECLI, page, paragraph, date, or URL data.
8. Check that every quotation is faithful and every paraphrase is supported by the cited locator.
9. Mark whether the citation is verified, partially verified, or unverified, and state why.
10. Require human review before inserting citations into a final pleading, academic submission, filing, or external publication.

## Authority-specific checks

- For legislation, record the version in force on the relevant date when the proposition is date-sensitive.
- For case law, record court, date, case number, ECLI or provider identifier, full-text availability, and the exact passage.
- For EU law, record CELEX or another stable identifier and the relevant article or recital.
- For ECHR material, record application number, decision or judgment date, document type, and relevant paragraph.
- For academic sources, record edition or volume, issue, page range, DOI or stable URL, and access date where relevant.
- For online sources, record the publisher, page title, publication or update date if available, stable URL, and access date.

## Output contract

Return a citation audit with:

### Source identity

The normalized source identity and source type.

### Proposed citation

The citation in the requested style, or a clearly labelled partial citation if metadata is incomplete.

### Supporting locator

The exact passage or locator and whether full text was verified.

### Provenance

Provider, official or stable URL, identifier, retrieval or access date, and availability level.

### Defects and uncertainty

Missing metadata, conflicting records, index limitations, translation issues, or unresolved version questions.

### Human review gate

The checks required before publication or use in a legal work product.

A formatted citation is not proof that the underlying proposition is correct.
