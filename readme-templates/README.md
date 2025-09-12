# Bitiq README Templates

This directory contains standardized README templates for Bitiq projects.

## When To Use Which

- Use `README.bitiq-template.md` for services and larger apps.
  - Includes architecture, observability, deployment, and API sections.
- Use `README.bitiq-lite.md` for libraries/CLIs.
  - Focuses on install, quick start, API reference, and development basics.

## How To Use

1. Copy the appropriate template to your repo root as `README.md`.
2. Replace placeholders (project name, links, env vars) and remove unused sections.
3. Keep “Release & Changelog” and “Contributing” sections aligned with ecosystem standards.
4. Add a repo‑specific `AGENTS.md` (copy from the ecosystem `AGENTS.template.md`).

Quick copy (from a new repo directory):

```bash
# Full service README
cp /path/to/ecosystem/readme-templates/README.bitiq-template.md README.md

# Lite README (libs/CLIs)
cp /path/to/ecosystem/readme-templates/README.bitiq-lite.md README.md

# Agents guide
cp /path/to/ecosystem/AGENTS.template.md AGENTS.md
```

## Related Standards

- Project lifecycle and required docs: `project-management/project-lifecycle.md`
- Spec template: `project-management/spec-template.md`
- TODO template: `project-management/todo-template.md`
- ADR template: `project-management/adr-template.md`

## Tips

- Keep the top sections concise and scannable.
- Include only what your audience needs; link out for deep dives.
- Use code blocks and examples to reduce ambiguity.

