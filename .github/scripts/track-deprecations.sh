#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="${1:?usage: track-deprecations.sh <log-file> <system> <run-url>}"
SYSTEM="${2:?usage: track-deprecations.sh <log-file> <system> <run-url>}"
RUN_URL="${3:?usage: track-deprecations.sh <log-file> <system> <run-url>}"
REPO="${GITHUB_REPOSITORY:?GITHUB_REPOSITORY must be set}"

TODAY="$(date -u +%F)"
TMP="$(mktemp -d)"

grep -iE 'is deprecated|will be removed|deprecated, use .* instead' "$LOG_FILE" \
  >"$TMP/raw.txt" || true

{
  echo ""
  echo "## Deprecation warnings (\`$SYSTEM\`)"
} >>"$GITHUB_STEP_SUMMARY"

if [[ ! -s "$TMP/raw.txt" ]]; then
  echo "- none" >>"$GITHUB_STEP_SUMMARY"
  exit 0
fi

sed -E \
  -e 's#/nix/store/[0-9a-z]{32}-#/nix/store/<hash>-#g' \
  -e 's/(narHash *= *")[^"]+"/\1<hash>"/g' \
  -e 's/(rev *= *")[0-9a-f]{7,40}"/\1<rev>"/g' \
  -e 's/[0-9a-zA-Z+\/]{32,}=*/<hash>/g' \
  -e 's/^[[:space:]]+//; s/[[:space:]]+$//' \
  "$TMP/raw.txt" | sort -u >"$TMP/normalized.txt"

gh issue list --repo "$REPO" --label deprecation --state all \
  --json number,title,state --limit 200 >"$TMP/existing.json" ||
  echo '[]' >"$TMP/existing.json"

while IFS= read -r title; do
  [[ -z $title ]] && continue
  title="${title:0:250}"

  match="$(jq -c --arg t "$title" '[.[] | select(.title == $t)] | first // empty' "$TMP/existing.json")"

  if [[ -z $match ]]; then
    number="$(gh issue create --repo "$REPO" \
      --title "$title" \
      --label deprecation \
      --assignee alesauce \
      --body "First seen: $TODAY on \`$SYSTEM\`
Run: $RUN_URL" | grep -oE '[0-9]+$')"
    echo "- 🆕 [#$number] $title" >>"$GITHUB_STEP_SUMMARY"
  else
    number="$(jq -r '.number' <<<"$match")"
    state="$(jq -r '.state' <<<"$match")"
    if [[ $state == "CLOSED" ]]; then
      gh issue reopen "$number" --repo "$REPO"
      gh issue comment "$number" --repo "$REPO" \
        --body "Regressed — seen again $TODAY on \`$SYSTEM\`
Run: $RUN_URL"
      echo "- ♻️ [#$number] $title (reopened)" >>"$GITHUB_STEP_SUMMARY"
    else
      gh issue comment "$number" --repo "$REPO" \
        --body "Seen again $TODAY on \`$SYSTEM\`
Run: $RUN_URL"
      echo "- 🔁 [#$number] $title" >>"$GITHUB_STEP_SUMMARY"
    fi
  fi
done <"$TMP/normalized.txt"
