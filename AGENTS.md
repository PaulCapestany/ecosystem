# AGENTS.md — Bitiq Ecosystem Repository

Purpose: Enable AI/dev assistants to work productively and safely in this repository, which serves as the single source of truth for Bitiq standards, templates, and guides.

This repo primarily contains documentation and templates (not runtime services). Edits here affect every downstream project that references these docs.

## Golden Rules

- Keep standards and templates consistent, minimal, and broadly applicable.
- Make changes surgically; avoid breaking existing links and anchors.
- Use Conventional Commits (primarily `docs`, `feat(templates)`, `chore`, `refactor(docs)`).
- Prefer additive changes; discuss/remediations before removing or renaming canonical files/paths.
- Maintain a `TODO.md` using the standardized format aligned with Conventional Commits. See `project-management/todo-template.md`.
- Update cross-references when files move or new templates are added.
- Do not add secrets or environment-specific values to docs or examples.

## Repo Map (Key Paths)

- `README.md` — Overview and entry points to all standards
- `CONTRIBUTING.md` — Contribution and workflow guidelines
- `CLAUDE.md` — Helpful build/lint/test conventions used across Bitiq services
- `guides/` — Authoritative guides (e.g., `golang-microservices.md`, `automation-workflow.md`)
- `project-management/` — Lifecycle and templates:
  - `project-lifecycle.md` — Canonical lifecycle; references templates
  - `spec-template.md`, `todo-template.md`, `adr-template.md`
- `readme-templates/` — Canonical README templates:
  - `README.bitiq-template.md` (Full), `README.bitiq-lite.md` (Lite)
- `docs/checklists/` — Lightweight checklists (e.g., `readme-review.md`)

## Typical Changes & Golden Paths

1) Template updates (`readme-templates/`)
- Keep section names stable to minimize downstream churn; add new sections conservatively.
- After edits, update references in:
  - `README.md` (Documentation Templates section)
  - `project-management/project-lifecycle.md` (Appendix + README format)
  - `docs/checklists/readme-review.md` if criteria changed

2) Lifecycle/guides updates
- Maintain heading stability; if you rename a heading, update inbound anchors.
- If the lifecycle materially changes, refresh the header metadata (Last Updated) and summarize changes.
- For contentious or sweeping changes, propose an ADR under `docs/adr/` (create directory if absent) or record a “Change History” entry within the doc.

3) Cross-link hygiene
- Prefer relative links that render correctly in the GitHub UI.
- When moving files, update all references (use `rg -n "filename"`).

## Commit & Branching Conventions

- Branch names: `docs/...`, `feat/templates-...`, `chore/...`, `refactor/docs-...`
- Commits: Conventional Commits
  - Examples:
    - `docs(lifecycle): clarify README format section`
    - `feat(templates): add lite README for CLIs`
    - `chore(checklist): add README review checklist`

## Validation Checklist (before PR)

- Links render in GitHub; anchors are correct
- Updated all references to added/moved files
- Examples and commands are copy/pasteable (where applicable)
- No secrets or environment-specific values leaked
- Wording is concise and consistent with tone in existing docs

## PR Expectations

- Describe the rationale, scope of change, and downstream impact
- Call out any breaking renames or section changes
- If adding a new standard or template, point to where it is referenced in `README.md` and lifecycle docs

### Creating PRs via GitHub CLI

- Prefer `gh pr create --fill` to prefill title/body from commit and apply the repo’s PR template.
- If supplying a custom body, use `--body-file <file>` to avoid literal `\\n` in the PR description.
- Example:
  ```bash
  gh pr create \
    --base main \
    --head $(git branch --show-current) \
    --title "$(git log -1 --pretty=%s)" \
    --body-file .github/PULL_REQUEST_TEMPLATE.md
  ```

## When to Use an ADR

Create an ADR (`docs/adr/NNNN-title.md`) when you introduce or change:
- Canonical structure (e.g., required sections in service READMEs)
- Core processes (e.g., lifecycle phases, automation requirements)
- Organization-wide conventions (e.g., logging/OTEL baselines)

Template outline:

```
# ADR-NNNN: Title
## Status
Proposed | Accepted | Superseded by ADR-XXXX
## Context
## Decision
## Consequences
## Alternatives Considered
## References
```

## Notes on Automation

- This repo does not maintain a `CHANGELOG.md` by default. If you add one, use Conventional Commits and an automated generator (e.g., `git-cliff`, `conventional-changelog`). Do not edit changelogs manually.
- There is no `Makefile` here; use standard git workflows and verify Markdown renders cleanly in GitHub.

## Out of Scope (require maintainer approval)

- Renaming or moving canonical files/paths without bulk link updates
- Introducing language-specific tooling or runtime code in this repo
- Large-scale restructuring of guides or lifecycle without prior discussion

---

This AGENTS.md is specific to the ecosystem repository. For service repositories, copy and adapt `AGENTS.template.md` to match the codebase and tooling of that repo.
