# LAWOSS Agent Plugin

LAWOSS provides a read-only Codex plugin with source-coverage, specification-review, and judiciary-citation workflows.

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

In the Codex desktop app, restart the app after adding or changing a local/repository marketplace, open Plugins, select **LAWOSS Plugins**, and install **LAWOSS Legal**.

## Scope

The plugin contains skills only. It does not write to matters, send messages, submit filings, use eID, or perform external actions.

The skills require:

- official connectors first where available;
- explicit source coverage and provenance;
- exact locators and retrieval dates;
- visible uncertainty and index limitations;
- human review before a legal conclusion or final pleading.

## Experimental lab

Use **LAWOSS Legal Lab** for new workflow and research-method suggestions. It is intentionally separate from the stable plugin.

The recommended promotion flow is:

1. Capture the idea in the lab.
2. Redact all client and matter information.
3. Identify the jurisdiction, relevant date, source families, and exact locators.
4. Test the workflow on a synthetic example, including an uncertainty or failure path.
5. Submit the proposal for LAWOSS review.
6. Promote it into **LAWOSS Legal** only after review and acceptance.

The lab must not contain confidential client information, privileged material, credentials, bearer tokens, unpublished case material, or matter-specific deadlines. The capture skill does not open GitHub issues, modify repositories, or create legal conclusions automatically.

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
