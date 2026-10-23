#!/usr/bin/env bash
# claude-token-saver installer
# Usage:  curl -fsSL https://raw.githubusercontent.com/yaldizemre/claude-token-saver/main/install.sh | bash
#         bash install.sh [--force] [--dry-run] [--dir HEDEF_KLASOR]
set -euo pipefail

REPO="${CT_REPO:-yaldizemre/claude-token-saver}"
BRANCH="${CT_BRANCH:-main}"
TARGET="$PWD"; FORCE=0; DRY=0

while [ $# -gt 0 ]; do
  case "$1" in
    --force) FORCE=1 ;;
    --dry-run) DRY=1 ;;
    --dir) shift; TARGET="${1:?--dir needs a path}" ;;
    -h|--help) sed -n '2,4p' "$0" 2>/dev/null || true; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

SRC=""; TMP=""
cleanup() { [ -n "$TMP" ] && rm -rf "$TMP"; }
trap cleanup EXIT

# Local clone? use it. Otherwise download the repo tarball.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "$HERE" ] && [ -d "$HERE/template" ]; then
  SRC="$HERE/template"
else
  command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }
  command -v tar  >/dev/null || { echo "tar is required"  >&2; exit 1; }
  TMP="$(mktemp -d)"
  curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$BRANCH" | tar -xz -C "$TMP"
  SRC="$(find "$TMP" -maxdepth 2 -type d -name template | head -n1)"
  [ -d "$SRC" ] || { echo "template/ not found in $REPO@$BRANCH" >&2; exit 1; }
fi

[ -d "$TARGET" ] || { echo "Target not found: $TARGET" >&2; exit 1; }
echo "Installing into: $TARGET"

installed=0; skipped=0; backed=0
while IFS= read -r -d '' f; do
  rel="${f#"$SRC"/}"
  dest="$TARGET/$rel"
  if [ -e "$dest" ]; then
    if cmp -s "$f" "$dest"; then continue; fi
    if [ "$FORCE" -eq 1 ]; then
      echo "  overwrite  $rel  (backup: $rel.bak)"
      [ "$DRY" -eq 1 ] || cp -p "$dest" "$dest.bak"
      backed=$((backed+1))
    else
      echo "  skip       $rel  (exists; use --force)"
      skipped=$((skipped+1)); continue
    fi
  else
    echo "  create     $rel"
  fi
  if [ "$DRY" -eq 0 ]; then mkdir -p "$(dirname "$dest")"; cp "$f" "$dest"; fi
  installed=$((installed+1))
done < <(find "$SRC" -type f -print0)

echo "Done: $installed written, $skipped skipped, $backed backed up.$([ "$DRY" -eq 1 ] && echo ' (dry run)')"
echo "Next: edit .claude/docs/architecture.md (stack), then run 'claude' in this folder."
