#!/usr/bin/env bash
set -euo pipefail

# Check for presence of standard documentation files in a repository.
# Usage: scripts/check-required-docs.sh [path]

TARGET=${1:-.}

missing=()
for f in README.md AGENTS.md SPEC.md TODO.md; do
  if [[ ! -f "$TARGET/$f" ]]; then
    missing+=("$f")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Missing required docs: ${missing[*]}" >&2
  exit 1
fi

echo "All required docs present in $TARGET"

