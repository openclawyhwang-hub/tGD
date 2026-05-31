#!/bin/bash
# Gemini CLI AfterTool hook (Edit/Write) — simplify-ignore post-filter
export CLAUDE_PROJECT_DIR="${GEMINI_PROJECT_DIR:-$PWD}"
exec bash "$(dirname "$0")/../simplify-ignore.sh" "$@"
