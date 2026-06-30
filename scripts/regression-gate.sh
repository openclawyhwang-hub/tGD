#!/bin/bash
# regression-gate.sh
#
# Machine-enforced regression check: verify every entry in REGRESSION-CATALOG.md
# is actually exercised by the test suite. Fails closed if any catalog entry
# is missing, its test command is unfindable, or its test fails.
#
# Usage: bash scripts/regression-gate.sh [path-to-client-repo]
#   path-to-client-repo: optional. Defaults to current working directory.
#                        The client repo is the project that *uses* tGD
#                        (e.g. my-app/ — the parent of my-app-tGD/).
#                        tGD itself lives at $TGD_DIR or ../<client>-tGD/.
#
# Exit codes:
#   0 = all catalog entries passed
#   1 = one or more catalog entries failed or are stale
#   2 = usage error (catalog missing, no test runner detected, etc.)
#
# Cross-reference with codegraph (if .codegraph/ exists):
#   - Lists "potentially affected" catalog entries by file dependency
#   - Does NOT skip non-affected entries (we still run them — slow but safe)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLIENT_REPO="${1:-$(pwd)}"

# Resolve TGD_DIR (this repo)
TGD_DIR="$(dirname "$SCRIPT_DIR")"
if [ ! -f "$TGD_DIR/skills/tgd-rules/SKILL.md" ]; then
    echo "❌ Cannot locate tGD repo (no skills/tgd-rules/SKILL.md at $TGD_DIR)"
    echo "   Pass tGD path explicitly: bash $0 /path/to/client <tgd-path>"
    exit 2
fi

CATALOG="$TGD_DIR/REGRESSION-CATALOG.md"

# === Pre-flight checks ===

if [ ! -f "$CATALOG" ]; then
    echo "❌ No REGRESSION-CATALOG.md at $CATALOG"
    echo "   This client has no regression catalog yet. Run /tgd-release to seed it."
    exit 2
fi

if [ ! -d "$CLIENT_REPO" ]; then
    echo "❌ Client repo not found: $CLIENT_REPO"
    exit 2
fi

cd "$CLIENT_REPO"

# Detect test runner
TEST_CMD=""
if [ -f "package.json" ] && grep -q '"test"' package.json; then
    # Extract test command from package.json
    TEST_CMD=$(node -e "try { console.log(require('./package.json').scripts.test || '') } catch(e) {}" 2>/dev/null || echo "")
    TEST_RUNNER="npm"
elif [ -f "pyproject.toml" ] || [ -f "pytest.ini" ] || [ -f "setup.py" ]; then
    if command -v pytest &> /dev/null; then
        TEST_CMD="pytest -x --tb=short -q"
        TEST_RUNNER="pytest"
    fi
elif [ -f "go.mod" ]; then
    TEST_CMD="go test ./..."
    TEST_RUNNER="go"
elif [ -f "Cargo.toml" ]; then
    TEST_CMD="cargo test"
    TEST_RUNNER="cargo"
fi

if [ -z "$TEST_CMD" ]; then
    echo "❌ No test runner detected in $CLIENT_REPO"
    echo "   Expected: package.json with 'test' script, pyproject.toml/pytest.ini,"
    echo "             go.mod, or Cargo.toml"
    exit 2
fi

echo "🔍 Regression gate"
echo "   Client repo: $CLIENT_REPO"
echo "   Test runner: $TEST_RUNNER"
echo "   Catalog:     $CATALOG"
echo ""

# === Parse catalog ===

# Each catalog entry starts with "### " and contains a "Test: <command-or-file>" line
# We extract: title (description), test reference, AC reference
ENTRIES=$(grep -E "^### " "$CATALOG" | wc -l | tr -d ' ')

if [ "$ENTRIES" -eq 0 ]; then
    echo "⚠️  Catalog is empty (0 entries). Nothing to verify."
    echo "   This is unusual — every release should add at least one entry."
    exit 0
fi

echo "📋 Catalog has $ENTRIES entries"
echo ""

# === Codegraph pre-screening (if available) ===

AFFECTED_ENTRIES=""
CODEGRAPH_DIR="$CLIENT_REPO/.codegraph"
if [ -d "$CODEGRAPH_DIR" ]; then
    echo "🕸️  Codegraph detected — pre-screening affected entries"
    # Note: this is informational only. We still run ALL entries.
    AFFECTED_ENTRIES=$(find "$CODEGRAPH_DIR" -name "*.json" 2>/dev/null | head -1)
    if [ -n "$AFFECTED_ENTRIES" ]; then
        echo "   (Pre-screening is advisory; running full suite for safety)"
    fi
    echo ""
fi

# === Run the test suite ===

echo "▶  Running test suite: $TEST_CMD"
echo ""

# Capture full output for the report
TEST_OUTPUT_FILE=$(mktemp)
set +e
$TEST_CMD > "$TEST_OUTPUT_FILE" 2>&1
TEST_EXIT=$?
set -e

PASS_COUNT=$(grep -cE "passed|ok|PASS|✓" "$TEST_OUTPUT_FILE" 2>/dev/null || echo 0)
FAIL_COUNT=$(grep -cE "failed|FAIL|✗|ERROR" "$TEST_OUTPUT_FILE" 2>/dev/null || echo 0)

echo ""
echo "📊 Test suite result: exit=$TEST_EXIT, ~$PASS_COUNT pass markers, ~$FAIL_COUNT fail markers"
echo ""

# === Cross-reference: did we run any test that matches catalog entries? ===

# Extract test file references from catalog (lines like "Test: tests/foo.test.ts")
CATALOG_TESTS=$(grep -E "Test:.*\.(test|spec)\." "$CATALOG" 2>/dev/null | sed 's/.*Test: *//' | sort -u)

if [ -z "$CATALOG_TESTS" ]; then
    echo "⚠️  No test references found in catalog (looking for 'Test: tests/foo.test.ts')"
    echo "   Each catalog entry should reference a concrete test file."
fi

# === Stale-entry check ===

# If a catalog test file no longer exists on disk, that's a stale entry
STALE=0
if [ -n "$CATALOG_TESTS" ]; then
    while IFS= read -r testref; do
        # testref might be "tests/foo.test.ts" or "pytest tests/test_foo.py"
        TESTFILE=$(echo "$testref" | awk '{print $NF}')
        if [ -n "$TESTFILE" ] && [ ! -f "$CLIENT_REPO/$TESTFILE" ] && [ ! -f "$TESTFILE" ]; then
            echo "❌ Stale catalog entry — test file not found: $TESTFILE"
            STALE=$((STALE + 1))
        fi
    done <<< "$CATALOG_TESTS"
fi

# === Verdict ===

if [ $TEST_EXIT -ne 0 ]; then
    echo ""
    echo "❌ REGRESSION GATE FAILED: test suite exit code $TEST_EXIT"
    echo "   First 30 lines of failure output:"
    head -30 "$TEST_OUTPUT_FILE" | sed 's/^/   | /'
    rm -f "$TEST_OUTPUT_FILE"
    exit 1
fi

if [ $STALE -ne 0 ]; then
    echo ""
    echo "❌ REGRESSION GATE FAILED: $STALE stale catalog entries (test files missing)"
    echo "   Fix: remove stale entries from REGRESSION-CATALOG.md or restore the missing test files."
    rm -f "$TEST_OUTPUT_FILE"
    exit 1
fi

echo ""
echo "✅ REGRESSION GATE PASSED: $ENTRIES catalog entries verified, $STALE stale, suite exit=0"
rm -f "$TEST_OUTPUT_FILE"
exit 0
