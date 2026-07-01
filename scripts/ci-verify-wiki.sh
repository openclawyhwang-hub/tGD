#!/bin/bash
# ci-verify-wiki.sh — CI step: build a wiki from a synthetic fixture and verify
# the layout/brand contract. Exits non-zero on any violation.
#
# Usage: bash scripts/ci-verify-wiki.sh
#
# Workflow:
#   1. Generate a synthetic UA knowledge-graph.json (deterministic fixture)
#   2. Run generate-wiki.py on the fixture
#   3. Run generate-docusaurus-config.py
#   4. Skip the actual docusaurus build (~30s) but run npm install only if fast
#   5. Run verify-wiki.py — catches layout drift, missing components, etc.
#
# This is the canonical guarantee that "every project gets the same layout".

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

FIXTURE_DIR="$(mktemp -d -t tgd-wiki-fixture.XXXXXX)"
SKILL_DIR="$REPO_ROOT/skills/tgd-wiki-generation"
trap 'rm -rf "$FIXTURE_DIR"' EXIT

echo "🔍 CI: tGD Wiki layout contract"
echo "   fixture: $FIXTURE_DIR"
echo

echo "1/4 Generating fixture..."
node "$SCRIPT_DIR/generate-wiki-fixture.js" "$FIXTURE_DIR"
echo

echo "2/4 Running generate-wiki.py..."
python3 "$SKILL_DIR/scripts/generate-wiki.py" "$FIXTURE_DIR" --quiet
echo

echo "3/4 Running generate-docusaurus-config.py..."
python3 "$SKILL_DIR/scripts/generate-docusaurus-config.py" "$FIXTURE_DIR"
echo

echo "4/4 Verifying layout/brand contract..."
python3 "$SKILL_DIR/scripts/verify-wiki.py" "$FIXTURE_DIR"
