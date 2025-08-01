#!/usr/bin/env bash
set -euo pipefail

# merge_vscode_recs.sh
# --------------------
# Merges a newline-delimited list of VSCode extension IDs into the
# "recommendations" array of an existing .vscode/extensions.json,
# preserving order and avoiding duplicates.
#
# Usage:
#   ./merge_vscode_recs.sh <new-list.txt> <extensions.json>

fail() {
  echo "❌ $1" >&2
  exit 1
}

[[ $# -eq 2 ]] || fail "Usage: $0 <new-list.txt> <extensions.json>"

NEW_LIST="$1"
JSON_FILE="$2"

[[ -f "$NEW_LIST" ]]  || fail "List file not found: $NEW_LIST"
[[ -f "$JSON_FILE" ]] || fail "JSON file not found: $JSON_FILE"

# Read new extensions into Bash array (skip blank lines)
mapfile -t new_exts < <(grep -v '^[[:space:]]*$' "$NEW_LIST")

if (( ${#new_exts[@]} == 0 )); then
  echo "ℹ️  No entries in '$NEW_LIST'. Nothing to merge."
  exit 0
fi

# Build a JSON array from new_exts
new_json=$(printf '%s\n' "${new_exts[@]}" | jq -R . | jq -s .)

# Merge into .recommendations preserving original order, no duplicates
tmp="$(mktemp)"
jq --argjson new "$new_json" '
  .recommendations = (
    # get existing array or empty
    (.recommendations // []) as $orig
    |
    # append only those in $new not already in $orig
    ($orig + ($new | map(select(. as $item | $orig | index($item) | not))))
  )
' "$JSON_FILE" > "$tmp" && mv "$tmp" "$JSON_FILE"

echo "✅ Merged ${#new_exts[@]} extension(s) into '$JSON_FILE'."
echo "🔗 Updated recommendations:"
jq '.recommendations' "$JSON_FILE"
