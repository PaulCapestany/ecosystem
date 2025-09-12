#!/usr/bin/env bash
set -euo pipefail

# Bootstrap standard Bitiq docs into a target repository.
# Usage: scripts/bootstrap-docs.sh --dest <path> [--readme full|lite]

usage() {
  echo "Usage: $0 --dest <path> [--readme full|lite]" >&2
  exit 1
}

DEST=""
README_KIND="full"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)
      DEST=${2:-}; shift 2 ;;
    --readme)
      README_KIND=${2:-}; shift 2 ;;
    -h|--help)
      usage ;;
    *)
      echo "Unknown arg: $1" >&2; usage ;;
  esac
done

[[ -z "$DEST" ]] && usage

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)

mkdir -p "$DEST"

# Copy core docs
cp -n "$ROOT_DIR/project-management/spec-template.md" "$DEST/SPEC.md" || true
cp -n "$ROOT_DIR/project-management/todo-template.md" "$DEST/TODO.md" || true

# ADRs
mkdir -p "$DEST/docs/adr"
cp -n "$ROOT_DIR/project-management/adr-template.md" "$DEST/docs/adr/0001-example-decision.md" || true

# README
case "$README_KIND" in
  full)
    cp -n "$ROOT_DIR/readme-templates/README.bitiq-template.md" "$DEST/README.md" || true ;;
  lite)
    cp -n "$ROOT_DIR/readme-templates/README.bitiq-lite.md" "$DEST/README.md" || true ;;
  *)
    echo "Invalid --readme value: $README_KIND (expected full|lite)" >&2; exit 2 ;;
esac

# Agents guide
cp -n "$ROOT_DIR/AGENTS.template.md" "$DEST/AGENTS.md" || true

cat <<EOF
Bootstrapped docs into: $DEST
- SPEC.md, TODO.md
- docs/adr/0001-example-decision.md
- README.md ($README_KIND)
- AGENTS.md

Next steps:
- Replace placeholders in README.md and AGENTS.md
- Add repo-specific ADRs as needed under docs/adr/
- Keep TODO.md in Conventional Commits format
EOF

