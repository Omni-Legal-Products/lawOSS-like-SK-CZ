# LAWOSS MCP Endpoint Feature Publish

## Goal

Publish the product-facing feature claim for a single MCP endpoint over multiple legal sources, publish the already-prepared LAWOSS sidecar hardening fix through a reviewable branch, and avoid exposing the unrelated or tightly coupled local Gravity development history.

## Scope

- Add the approved feature wording to the LAWOSS README feature table.
- Preserve the accurate boundary: this is a domain-specific legal facade over source connectors, not a generic MCP multiplexer.
- Publish the existing `prepare-sidecar.mjs` shell-spawn hardening change and its regression test in a separate LAWOSS branch.
- Do not copy the Python `legal-orchestrator` tree into LAWOSS or push the local Gravity `main`; the local Gravity history is not a clean publish base and contains unrelated uncommitted work.

## Acceptance criteria

- The LAWOSS feature table contains the Slovak feature title and concise description agreed in chat.
- The security fix and regression test are committed only on a short-lived LAWOSS feature branch.
- No unrelated working-tree files are staged.
- Relevant tests pass before any push.
- If GitHub network or authentication is unavailable, local commits remain intact and the exact push blocker is reported.

## Repository boundary

LAWOSS remains the product repository. Gravity remains the canonical repository for the legal orchestrator and connectors. The product description may explain the capability without duplicating the implementation.
