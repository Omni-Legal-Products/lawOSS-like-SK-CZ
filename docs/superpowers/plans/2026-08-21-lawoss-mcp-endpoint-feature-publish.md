# LAWOSS MCP Endpoint Feature Publish Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish the single-endpoint legal-source feature description and the existing LAWOSS sidecar hardening fix without mixing repositories or unrelated local changes.

**Architecture:** The product README describes the domain-level legal facade. Its implementation remains in Gravity; LAWOSS receives no copied Python orchestrator. The sidecar security fix is an independent LAWOSS branch and PR.

**Tech Stack:** Markdown, JavaScript/Node built-in tests, Git branches, GitHub pull requests.

**Spec:** `docs/superpowers/specs/2026-08-21-lawoss-mcp-endpoint-feature-publish.md`

## Global Constraints

- Never push directly to LAWOSS `dev`.
- Stage only the explicitly approved LAWOSS files.
- Do not stage or rewrite existing unrelated user changes.
- Do not publish the local Gravity `main` history or its uncommitted changes.
- Use the exact approved Slovak feature wording.

---

### Task 1: Publish the feature description

Start from LAWOSS `dev` on branch `docs/mcp-endpoint-feature`. Keep this branch separate from the sidecar security fix.

**Files:**
- Modify: `lawoss/README.md` in the `Čo staviame ako prvé` table.

**Interfaces:**
- Consumes: the approved feature title and description from the conversation.
- Produces: a product-facing feature entry that does not claim generic MCP proxying.

- [ ] **Step 1: Add the feature row**

Add:

```markdown
| 🔗 **Jeden MCP endpoint pre viacero právnych zdrojov** | Klient sa pripája iba raz; orchestrátor podľa otázky vyberie relevantné zdroje a vráti jednotný overený výsledok s citáciami, pokrytím a limitmi |
```

- [ ] **Step 2: Inspect the focused diff**

Run: `git diff -- lawoss/README.md`

Expected: one added table row and no other README changes.

- [ ] **Step 3: Commit the feature documentation**

Run from the LAWOSS checkout:

```bash
git add README.md
git commit -m "docs: pridať jednotný MCP endpoint do features"
```

### Task 2: Publish the sidecar hardening fix

Start from LAWOSS `dev` on branch `fix/orchestrator-no-shell`. The existing sidecar changes are the intended working-tree input for this branch.

**Files:**
- Modify: `lawoss/apps/desktop/scripts/prepare-sidecar.mjs:440`.
- Test: `lawoss/apps/desktop/scripts/prepare-sidecar-path.test.mjs`.

**Interfaces:**
- Consumes: the existing `spawnSync("bun", ...)` orchestrator build path.
- Produces: argument-array spawning without shell interpretation plus a regression test.

- [ ] **Step 1: Run the focused regression test**

Run: `node --test apps/desktop/scripts/prepare-sidecar-path.test.mjs`

Expected: PASS for the current working-tree fix.

- [ ] **Step 2: Inspect only the approved files**

Run: `git diff -- apps/desktop/scripts/prepare-sidecar.mjs` and `git status --short`.

Expected: the one-line `shell: true` removal and the new test are the only intended changes on the bugfix branch.

- [ ] **Step 3: Commit the fix and test**

Run from the LAWOSS checkout:

```bash
git add apps/desktop/scripts/prepare-sidecar.mjs apps/desktop/scripts/prepare-sidecar-path.test.mjs
git commit -m "fix: bezpečne spúšťať orchestrator sidecar"
```

### Task 3: Verify and publish

**Files:**
- No additional source files.

**Interfaces:**
- Consumes: the two focused LAWOSS commits.
- Produces: pushed short-lived branches and draft PRs when the GitHub transport is available.

- [ ] **Step 1: Run the focused test on the bugfix branch**

Run: `node --test apps/desktop/scripts/prepare-sidecar-path.test.mjs`

Expected: exit code 0.

- [ ] **Step 2: Verify staged/committed scope**

Run: `git show --stat --oneline HEAD` and `git status --short`.

Expected: only the feature README or only the sidecar fix/test appears on the respective branch; unrelated user changes remain untouched.

- [ ] **Step 3: Push and create draft PRs**

Run the branch-specific push commands only after verification:

```bash
git push -u origin docs/mcp-endpoint-feature
git push -u origin fix/orchestrator-no-shell
```

Expected: the branch is published; create a draft PR against `dev` with the relevant summary and test command. If network/authentication fails, retain the commits and report the exact failure.
