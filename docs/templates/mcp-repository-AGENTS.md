# AGENTS.md for a LAWOSS MCP Repository

> This template is the shared minimum. Replace every angle-bracket field with verified repository-specific information before copying it into an MCP repository. The finished repository file must not contain unresolved template fields.

## Project

- **Name:** `<repository name>`
- **Purpose:** `<one accurate sentence describing this MCP server>`
- **Jurisdiction:** `<Slovakia, Czechia, or European Union>`
- **Primary data source:** `<official source or API>`
- **Personal upstream:** `https://github.com/originalmagneto/<repository>`
- **Team copy:** `https://github.com/Omni-Legal-Products/<repository>`

The personal repository is the source of truth. A change created in the team copy must be offered back to the personal upstream before the team copy is synchronized.

## Read Before Editing

1. Read this file completely.
2. Inspect `README.md`, `package.json`, tests, and Docker configuration relevant to the request.
3. Confirm the current branch and working tree before editing.
4. Keep the diff focused. Ask before refactoring unrelated code.
5. Treat facts about external legal sources as time-sensitive and verify them.

## Code Conventions

- Use TypeScript and Node.js conventions already established by the repository.
- Use npm and the committed lockfile.
- Keep strict typing enabled.
- Prefer small functional helpers over unnecessary classes.
- Keep comments in English.
- Preserve existing public MCP tool names and input and output schemas unless the user explicitly approves a breaking change.
- Do not introduce dependencies or deployment changes without explaining why they are needed.

## Repository-Specific Commands

Install dependencies:

```bash
npm ci
```

Typecheck:

```bash
<verified typecheck command, or state that package.json has no separate typecheck command>
```

Offline tests:

```bash
<verified offline test command>
```

Build:

```bash
<verified build command>
```

Optional live or smoke checks:

```bash
<verified live or smoke command, or state that none is defined>
```

Live, HTTP, integration, scraping, indexing, backfill, email, maintenance, and production commands are not part of the default verification. Run them only when the user explicitly requests them and after checking their required environment variables and external effects.

## Verification Rules

- Run the repository-specific offline minimum before pushing.
- Run targeted tests first when changing a parser, client, provider, or MCP tool.
- Run the build after TypeScript or deployment-related changes.
- Record a pre-existing baseline failure instead of claiming that the change caused or fixed it.
- A passing typecheck or test proves technical behavior only. It does not prove that a legal interpretation, statutory text, register result, or court decision is substantively correct.
- For legal and registry data, distinguish source retrieval, parsing correctness, and legal or domain correctness in the report.

## Security and Data Rules

- Never commit secrets, API keys, bearer tokens, OAuth credentials, private keys, production `.env` files, or Dokploy environment values.
- Never commit client data, privileged material, personal case files, or production logs containing personal data.
- Example configuration must use unmistakable placeholders.
- Do not expose private repository contents in public issues, logs, or artifacts.
- Do not weaken authentication, authorization, rate limiting, or transport security without explicit approval.

## Deployment Boundary

- Do not deploy, redeploy, restart, stop, or reconfigure Dokploy without the user's explicit instruction for that exact action.
- Do not change production domains, environment variables, volumes, databases, or secrets as part of ordinary code work.
- When deployment is explicitly requested, identify the personal upstream commit or tag first.
- A team fork or mirror is not automatically a production source.
- Never use force push to synchronize a production branch.

## Git and Collaboration

- Use short branches and conventional commits.
- Use a Pull Request for feature, schema, dependency, deployment, or structural changes.
- Pull current changes before pushing.
- Do not overwrite another contributor's work or authorship.
- If the organizational copy diverges, resolve the functional change in the personal upstream first.
- Keep changes to MCP tool contracts backward compatible unless a versioned migration is explicitly approved.

## AGENTS.md and CLAUDE.md Mirror Rule

`AGENTS.md` is the single source of truth. Root `CLAUDE.md` must be byte-for-byte identical to it and must be updated in the same commit.

Verify before finishing:

```bash
cmp -s AGENTS.md CLAUDE.md
shasum -a 256 AGENTS.md CLAUDE.md
```

## Completion Checklist

- [ ] Scope matches the user's request.
- [ ] No unrelated refactor is included.
- [ ] No secret, client data, or production credential is present.
- [ ] MCP tool compatibility is preserved or an approved migration is documented.
- [ ] Repository-specific offline checks passed, or the exact blocker is reported.
- [ ] Legal and domain correctness is not inferred from technical tests.
- [ ] No production action was taken without explicit approval.
- [ ] `AGENTS.md` and `CLAUDE.md` are byte-for-byte identical.
