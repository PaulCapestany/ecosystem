# Docs Check Composite Action

Reusable composite action to verify the presence of required documentation files.

## Usage

```yaml
name: Docs Check
on:
  pull_request:
    branches: [ main ]

jobs:
  docs-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: PaulCapestany/ecosystem/.github/actions/docs-check@main
        with:
          path: .
          files: README.md,AGENTS.md,SPEC.md,TODO.md
```

Inputs:
- `path` (default `.`): directory to check
- `files` (default `README.md,AGENTS.md,SPEC.md,TODO.md`): comma-separated list

