# Bitiq Automation Workflow

## Introduction

This document outlines the automation tools and processes recommended for Bitiq projects to streamline development, minimize redundancy, and ensure consistent documentation. By following these automation practices, teams can focus on development while maintaining high-quality documentation with minimal manual effort.

## Task and Commit Automation

### Pre-Commit Hook

Set up a pre-commit hook to validate that commit messages match a task in TODO.md:

```bash
#!/bin/bash
# File: .git/hooks/pre-commit

COMMIT_MSG=$(cat "$1")
TODO_FILE="TODO.md"

if ! grep -q "$COMMIT_MSG" "$TODO_FILE"; then
  echo "Error: Commit message doesn't match any task in TODO.md"
  echo "Please use a message directly from TODO.md or add the task first."
  exit 1
fi

exit 0
```

### Post-Commit Hook

Create a post-commit hook to automatically remove the committed task from TODO.md:

```bash
#!/bin/bash
# File: .git/hooks/post-commit

COMMIT_MSG=$(git log -1 --pretty=%B)
TODO_FILE="TODO.md"

# Escape any special characters in the commit message for sed
ESCAPED_MSG=$(echo "$COMMIT_MSG" | sed 's/[\/&]/\\&/g')

# Remove the line containing the commit message from TODO.md
sed -i "/^$ESCAPED_MSG$/d" "$TODO_FILE"

echo "Task automatically removed from TODO.md"
exit 0
```

### Release Automation

Set up a release script to:
1. Determine the next version based on commit types since last release
2. Generate CHANGELOG.md entries from commit history
3. Create a git tag for the release

## Recommended Tools

### 1. git-cliff

[git-cliff](https://github.com/orhun/git-cliff) is a highly configurable changelog generator that works with Conventional Commits.

Installation:
```bash
cargo install git-cliff
```

Sample configuration in `cliff.toml`:
```toml
[changelog]
# Template for the changelog header
header = """
# Changelog

All notable changes to this project will be documented in this file.
"""
# Template for each commit
body = """
{% if version %}\
## [{{ version }}] - {{ timestamp | date(format="%Y-%m-%d") }}
{% else %}\
## [Unreleased]
{% endif %}\
{% for group, commits in commits | group_by(attribute="group") %}
### {{ group | upper_first }}
{% for commit in commits %}
- {{ commit.message }} ({{ commit.id | truncate(length=7, end="") }}){% if commit.breaking %} [BREAKING]{% endif %}
{% endfor %}
{% endfor %}\n
"""

[git]
# Use Conventional Commits parser
conventional_commits = true
# Commit filters
filter_commits = false
# Generate links to commits
commit_parsers = [
  { message = "^feat", group = "Features" },
  { message = "^fix", group = "Bug Fixes" },
  { message = "^docs", group = "Documentation" },
  { message = "^perf", group = "Performance" },
  { message = "^refactor", group = "Refactor" },
  { message = "^style", group = "Styling" },
  { message = "^test", group = "Testing" },
  { message = "^build", group = "Build" },
  { message = "^ci", group = "CI" },
  { message = "^chore", group = "Chore" },
]
```

Usage:
```bash
git-cliff --output CHANGELOG.md
```

### 2. conventional-changelog-cli

[conventional-changelog-cli](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-cli) is a command-line tool for generating changelogs based on Conventional Commits.

Installation:
```bash
npm install -g conventional-changelog-cli
```

Usage:
```bash
# Generate CHANGELOG.md from git metadata
conventional-changelog -p angular -i CHANGELOG.md -s -r 0
```

### 3. commitizen

[commitizen](https://github.com/commitizen/cz-cli) helps developers write Conventional Commits correctly.

Installation:
```bash
npm install -g commitizen
npm install -g cz-conventional-changelog
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```

Usage:
```bash
# Use instead of git commit
git cz
```

## Integration with CI/CD

### GitHub Actions Example

```yaml
name: Release

on:
  push:
    branches: [ main ]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Determine next version
        id: semver
        uses: ietf-tools/semver-action@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          branch: main
      
      - name: Generate changelog
        uses: orhun/git-cliff-action@v1
        with:
          config: cliff.toml
          args: --current --output CHANGELOG.md
      
      - name: Create release
        uses: softprops/action-gh-release@v1
        with:
          tag_name: v${{ steps.semver.outputs.next }}
          body_path: CHANGELOG.md
          token: ${{ secrets.GITHUB_TOKEN }}
```

### Tekton Pipeline Example

```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: release-pipeline
spec:
  params:
    - name: git-url
      type: string
    - name: git-revision
      type: string
  workspaces:
    - name: shared-workspace
  tasks:
    - name: fetch-repository
      taskRef:
        name: git-clone
      params:
        - name: url
          value: $(params.git-url)
        - name: revision
          value: $(params.git-revision)
      workspaces:
        - name: output
          workspace: shared-workspace
    
    - name: generate-changelog
      taskRef:
        name: git-cliff
      runAfter:
        - fetch-repository
      workspaces:
        - name: source
          workspace: shared-workspace
    
    - name: create-tag
      taskRef:
        name: git-tag
      runAfter:
        - generate-changelog
      workspaces:
        - name: source
          workspace: shared-workspace
```

## Best Practices

1. **Keep TODO.md in Sync**: Ensure any new task is added to TODO.md before implementation
2. **Enforce Conventional Commits**: Use tools and hooks to ensure all commits follow the standard
3. **Automate CHANGELOG Generation**: Never edit CHANGELOG.md manually
4. **Version Incrementing**: Use commit types to determine next version number
5. **Documentation Generation**: Use code comments that can be processed by tools like godoc
6. **Code Generation**: Use tools to generate boilerplate from specifications (OpenAPI, protobuf)

## Conclusion

By embracing automation, the Bitiq development workflow minimizes manual effort, ensures consistency, and maintains high-quality documentation. This approach allows developers to focus on writing code while automatically maintaining project documentation and history.