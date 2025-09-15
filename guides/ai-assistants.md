# AI Assistants: Multi‑Agent Pattern for Bitiq

This guide describes how to use AI/dev assistants effectively across the Bitiq ecosystem using a role‑scoped, in‑repo source‑of‑truth. It complements the standards in `AGENTS.md` and the Project Lifecycle.

See also:
- Project Lifecycle: `project-management/project-lifecycle.md`
- Golang Microservices Guide: `guides/golang-microservices.md`
- Automation Workflow: `guides/automation-workflow.md`

## 1) Put role instructions in the repo (source of truth)

- Maintain a root `AGENTS.md` with global guardrails (Conventional Commits/SemVer, OpenTelemetry requirements, test commands, security notes). Assistants should read and honor it.
- For finer scoping, add `agents/<ROLE>.md` per repository (e.g., `agents/tester.md`). In tasks, you can direct the assistant to “treat agents/<ROLE>.md as AGENTS.md for this task.”

## 2) Choose the right execution mode

- IDE/local: use an agent mode that can edit/run within the working directory for implementation; use chat/planning modes for design; only elevate access when required. Tune reasoning effort to task complexity.
- CLI: similar approval modes exist; switch models/reasoning for harder tasks as needed.

## 3) Use cloud runners for parallel background work and PRs

- From VS Code or the web, “run in the cloud” to provision a sandboxed container with your repo. The assistant can work in parallel, run tests/linters, and propose a PR.
- Configure cloud environments once (languages, tools, setup/maintenance scripts, limited/full internet). Assistants will attempt to run the lint/test commands defined in `AGENTS.md`.

---

## Roles assistants can take across the SDLC

Below are roles we recommend for Bitiq, with strengths, needed guardrails, and where to stay human‑led.

1) Requirements & Planning
- Strong: turn a high‑level issue into acceptance criteria, draft RFC outline, decompose into small testable tasks.
- Guardrails: keep scope to one repo/service; include verification steps and commands.
- Human‑led: prioritization and product trade‑offs.

2) Architecture & API Design (gRPC/OpenAPI)
- Strong: propose service boundaries, proto/OpenAPI skeletons, request‑flow diagrams.
- Guardrails: generate contract tests and docstrings; humans approve breaking changes.
- Human‑led: irreversible schema decisions, cross‑org impacts.

3) Feature Implementation (Go microservices)
- Strong: write features with tests, logging, configs; follow project conventions.
- Guardrails: run locally with compile+tests; require `go vet`, `govulncheck`, and project test targets from `AGENTS.md` to pass.
- Human‑led: merging significant design shifts.

4) Debugging & Bug‑Fix
- Strong: take stack traces/logs and repro steps to produce minimal patches (especially effective in cloud with rapid test loops).

5) Test Engineering (unit/integration/e2e)
- Strong: generate missing unit tests, table‑driven tests in Go, and author integration tests.
- Guardrails: provide exact commands and coverage goals; require failing tests first, then fix.

6) Security Review
- Good with guardrails: run SAST/linters (Semgrep, `govulncheck`), spot obvious injection/crypto/ACL issues.
- Guardrails: define allowed tools in the environment; produce a report and patch PR; humans validate threat modeling.

7) Performance & Observability
- Good with guardrails: add OTEL spans/metrics, set up collectors/exporters, create perf harnesses.
- Guardrails: require reproducible benches/traces attached to PRs; humans interpret results.

8) Data/Indexing & Migrations (Couchbase)
- Good with guardrails: author SQL++ queries, FTS/vector index definitions, migration scripts; write synthetic data/checks.
- Guardrails: run in cloud with a seeded test DB; require rollback steps in PR.

9) DevEx/Repo Hygiene
- Strong: enforce Conventional Commits/branch naming, scaffold Makefiles/Taskfiles, renovate configs, and fix docs.
- Guardrails: pin tool versions in the environment; require all linters to pass.

10) CI/CD & Infra (Tekton, Argo CD, Helm, OpenShift)
- Good with guardrails: write/modify Tekton pipelines, ArgoCD ApplicationSets, Helm charts, Kustomize overlays.
- Guardrails: use a dedicated infra repo/task with minimal privileges; PRs only—no direct cluster access.

11) Code Review
- Strong: review PRs with actionable comments; can spawn follow‑up tasks.

12) Documentation
- Strong: generate/update README.md, AGENTS.md, TODO.md, and API docs from code comments; keep examples in sync.

---

## Role‑scoped setup that works well in practice

Repository conventions (checked into git):
- `AGENTS.md` (root): build/test commands, linting, security checks, Definition of Done (e.g., unit tests + OTEL spans + docs updated + Conventional Commit). Cloud runs should honor these.
- `agents/` folder: `planner.md`, `architect.md`, `implementer-go.md`, `tester.md`, `security.md`, `infra-tekton.md`, `infra-argocd.md`. In each task, specify which file to treat as `AGENTS.md`.

IDE usage (fast, interactive):
- Switch between plan → edit/run. Elevate access sparingly. Use higher reasoning for design or multi‑file changes.

Cloud usage (parallel, PR‑ready):
- Configure environments with required toolchains (Go, buf/protoc, Helm, Tekton CLI), plus setup/maintenance scripts. Use restricted internet unless needed. Then “run in the cloud” for long tasks.

---

## Verification and Definition of Done (DoD)

Assistants should adhere to the repository’s DoD in `AGENTS.md` and the ecosystem guides:
- Lint/tests pass locally and/or in cloud (`make test`, `golangci-lint`, `govulncheck` as applicable)
- No secrets or environment‑specific values in docs/examples
- Cross‑links updated; anchors valid in GitHub UI
- Docs updated where directly impacted (README, SPEC, ADRs)
- Commits use Conventional Commits and reference TODO/Issues where relevant

For deeper guidance, see:
- `guides/golang-microservices.md` for Go services
- `guides/automation-workflow.md` for hooks and release automation

---

## Templates for role files

Seed templates are available under `project-management/agents-templates/`. Copy the relevant template(s) into your repo’s `agents/` folder and adapt:
- `planner.md`, `architect.md`, `implementer-go.md`, `tester.md`, `security.md`, `infra-tekton.md`, `infra-argocd.md`

Each template includes: scope, inputs, required commands, definition of done, and risks/notes.
