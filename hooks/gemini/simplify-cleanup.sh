#!/bin/bash
# Gemini CLI SessionEnd hook — restores files protected by simplify-ignore
export CLAUDE_PROJECT_DIR="${GEMINI_PROJECT_DIR:-$PWD}"
echo '{}' | exec bash "$(dirname "$0")/../simplify-ignore.sh"
