# Helper Scripts

This directory contains small helpers that standardize PR creation and documentation onboarding across Bitiq repositories.

## Prerequisites

- Bash shell (tested on macOS/Linux)
- GitHub CLI (`gh`) installed and authenticated for PR creation

## Scripts

### scripts/create-pr.sh

Create a pull request for the current branch using the repo’s PR template and safe newlines.

- Uses: `gh pr create --body-file .github/PULL_REQUEST_TEMPLATE.md`
- Env: `BASE_BRANCH` (defaults to `main`)

```bash
./scripts/create-pr.sh
BASE_BRANCH=release ./scripts/create-pr.sh
```

### scripts/bootstrap-docs.sh

Bootstrap standard docs into a target repository.

```bash
./scripts/bootstrap-docs.sh --dest ../my-service --readme full   # or lite
```

Copies (non-destructively):
- `SPEC.md`, `TODO.md`, `docs/adr/0001-example-decision.md`
- `README.md` (full/lite) and `AGENTS.md`

### scripts/check-required-docs.sh

Verify that a repository contains the required docs.

```bash
./scripts/check-required-docs.sh .
```

Checks for: `README.md`, `AGENTS.md`, `SPEC.md`, `TODO.md`

