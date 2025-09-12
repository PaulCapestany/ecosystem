#!/usr/bin/env bash
set -euo pipefail

# Helper: Create a PR using GitHub CLI with safe defaults.
# - Uses current branch as head
# - Prefills title from latest commit subject
# - Uses repo PR template for body to avoid literal \n issues

BASE_BRANCH=${BASE_BRANCH:-main}
HEAD_BRANCH=$(git branch --show-current)
TITLE=$(git log -1 --pretty=%s)

if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: GitHub CLI (gh) is required. See https://cli.github.com" >&2
  exit 1
fi

gh pr create \
  --base "$BASE_BRANCH" \
  --head "$HEAD_BRANCH" \
  --title "$TITLE" \
  --body-file .github/PULL_REQUEST_TEMPLATE.md

echo "PR created for $HEAD_BRANCH against $BASE_BRANCH"

