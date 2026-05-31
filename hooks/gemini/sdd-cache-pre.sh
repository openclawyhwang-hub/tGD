#!/bin/bash
# Gemini CLI BeforeTool hook (WebFetch) — sdd-cache pre-check
export CLAUDE_PROJECT_DIR="${GEMINI_PROJECT_DIR:-$PWD}"
exec bash "$(dirname "$0")/../sdd-cache-pre.sh" "$@"
