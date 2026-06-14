#!/bin/bash
# Codex SessionStart hook — injects using-tGD meta-skill
# Codex SessionStart expects hookSpecificOutput.additionalContext JSON,
# NOT Claude's {priority, message} format.
# See: https://developers.openai.com/codex/hooks
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Script lives at hooks/codex/session-start.sh, so skills/ is two levels up.
SKILLS_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)/skills"
META_SKILL="$SKILLS_DIR/using-tgd/SKILL.md"

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

if [ -f "$META_SKILL" ]; then
  CONTENT=$(cat "$META_SKILL")
  # Codex SessionStart contract: wrap in hookSpecificOutput.additionalContext
  # Reference: https://github.com/openai/codex/issues/16933
  jq -cn \
    --arg ctx "tGD loaded. Use the skill discovery flowchart to find the right skill for your task.

$CONTENT" \
    '{hookSpecificOutput: {additionalContext: $ctx}}'
else
  exit 0
fi
