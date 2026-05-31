#!/bin/bash
# Gemini CLI BeforeTool hook (Read) — simplify-ignore pre-filter
# Adapts environment and delegates to the main simplify-ignore.sh
export CLAUDE_PROJECT_DIR="${GEMINI_PROJECT_DIR:-$PWD}"
exec bash "$(dirname "$0")/../simplify-ignore.sh" "$@"
