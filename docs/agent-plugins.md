# LAWOSS Agent Plugin

LAWOSS provides a read-only Codex plugin with source-coverage, specification-review, workflow-routing, law-drift, citation, and judiciary-citation workflows.

## Install from GitHub

After the repository marketplace is available, add it to Codex and pin the ref you want to use:

```bash
codex plugin marketplace add originalmagneto/lawOSS-like-SK-CZ --ref main
codex plugin marketplace list
codex plugin list
codex plugin add lawoss-legal --marketplace <marketplace-name>
codex plugin add lawoss-legal-lab --marketplace <marketplace-name>
```

For testing a branch, replace `main` with the branch name. For reproducible legal workflows, prefer a reviewed tag or commit SHA over an unpinned moving branch.

In the Codex desktop app, restart the app after adding or changing a local/repository marketplace, open Plugins, select **LAWOSS Plugins**, and install **LAWOSS Legal**. Install **LAWOSS Legal Lab** only when you are testing an anonymized proposal.

## Scope

The plugin contains skills only. It does not write to matters, send messages, submit filings, use eID, or perform external actions.

The skills require:

- official connectors first where available;
- explicit source coverage and provenance;
- exact locators and retrieval dates;
- visible uncertainty and index limitations;
- human review before a legal conclusion or final pleading.

## Reusable workflows

The stable **LAWOSS Legal** plugin now includes:

- **lawoss-workflow-router**: maps the request to the narrowest registered legal workflow and defines its inputs, phases, source plan, output, and human gate;
- **lawoss-law-drift**: compares law or authority across relevant dates and preserves version identity, effective intervals, locators, and uncertainty;
- **lawoss-citations**: audits and normalizes legal and academic citations without inventing missing metadata;
- **lawoss-source-coverage**: records source availability, provenance, fallback boundaries, and human review;
- **lawoss-spec-review**: checks proposals and specifications for scope, evidence, safety, and testability;
- **judikatura-citation-builder**: builds source-traceable judiciary citations.

The router follows the registered Gravity workflow catalogue. When the canonical Gravity tooling is available, use `legal-cli workflow list` and `legal-cli workflow init`; the repository does not bundle connector logic and does not assume a separate `legalflow` executable.

Keep `legal-research`, `legal-source-routing`, and the canonical connectors in Gravity. LAWOSS skills describe the workflow contract and hand source selection to those global tools.

## Experimental lab

Use **LAWOSS Legal Lab** for new workflow and research-method suggestions. It is intentionally separate from the stable plugin.

The recommended promotion flow is:

1. Capture the idea in the lab.
2. Redact all client and matter information.
3. Identify the jurisdiction, relevant date, source families, and exact locators.
4. Test the workflow on a synthetic example, including an uncertainty or failure path.
5. Submit the proposal for LAWOSS review.
6. Promote it into **LAWOSS Legal** only after review and acceptance.

The lab must not contain confidential client information, privileged material, credentials, bearer tokens, unpublished case material, or matter-specific deadlines. Lab skills do not open GitHub issues, modify repositories, or create legal conclusions automatically.

Legal-methodology proposals belong in LAWOSS review. Agent Plugins upstream is appropriate for portable-format, interoperability, or cross-client concerns.

## Judiciary MCP

The plugin does not bundle the remote `judikaty-mcp` endpoint by default. Keep that MCP server separately configured and read-only until its deployment uses bearer authentication and its tools are explicitly allowlisted. Never place tokens in this public repository or in plugin metadata.

For the current connector status, see the [judikaty-mcp repository](https://github.com/originalmagneto/judikaty-mcp).

## Updating

Update the configured Git marketplace, review the changed plugin files, and reinstall or refresh the plugin:

```bash
codex plugin marketplace upgrade <marketplace-name>
codex plugin list
```
