# README Review Checklist

Use this checklist to validate a repository README before release.

- Overview: Clear 1–2 paragraph summary and Bitiq context
- Status & Links: Version, build, SPEC.md, TODO.md, ADRs, CHANGELOG
- Features: 3–6 concise, benefit‑oriented bullets
- Architecture: brief component list; link ADRs/diagrams
- Getting Started: 3–5 copy/paste commands work on a clean machine
- Configuration: env vars, flags, config files with defaults/examples
- API: link to OpenAPI/gRPC; include a minimal request example
- Development: make targets, lint/format/test commands, commit/branch rules
- Testing: commands to run unit/integration; coverage or notes
- Observability: logging levels, metrics/tracing envs (OTEL)
- Security: reporting channel, secrets handling statement
- Deployment: image name, environments, GitOps or manifests link
- Release & Changelog: SemVer + automation note (no manual edits)
- Contributing: link to CONTRIBUTING, labels for newcomers
- License & Maintainers: clear license and maintainer contacts
- AI Assistants: link to AGENTS.md, present and tailored

Sign‑off:

- [ ] Verified commands work locally
- [ ] Links resolve in GitHub UI
- [ ] Sections trimmed to repo scope (no boilerplate leftovers)
- [ ] Sensitive info removed; secrets not included

