#!/bin/bash
# build-site.sh — Install deps and build the Docusaurus static site under
# $TGD_DIR/wiki/.
#
# Usage:
#   bash build-site.sh <TGD_DIR> [--skip-install]
#
# Soft-fails when npm is missing or npm install fails — the MDX content is
# still readable as raw files under $TGD_DIR/wiki/docs/. Exit 0 in that case
# so /tgd-map Step 6 does not block on optional infrastructure.

set -u

TGD_DIR="${1:-}"
if [ -z "$TGD_DIR" ] || [ ! -d "$TGD_DIR" ]; then
  echo "Error: TGD_DIR argument required (got: '$TGD_DIR')" >&2
  exit 2
fi
shift

SKIP_INSTALL=false
for arg in "$@"; do
  case "$arg" in
    --skip-install) SKIP_INSTALL=true ;;
  esac
done

WIKI_DIR="$TGD_DIR/wiki"

if [ ! -f "$WIKI_DIR/package.json" ] || [ ! -f "$WIKI_DIR/docusaurus.config.ts" ]; then
  echo "Error: $WIKI_DIR is not a Docusaurus project (missing package.json or docusaurus.config.ts)." >&2
  echo "       Run generate-docusaurus-config.py first." >&2
  exit 2
fi

if ! command -v node >/dev/null 2>&1; then
  cat >&2 <<EOF
[tgd-wiki] node is not installed — skipping Docusaurus build.
[tgd-wiki] Install Node.js 18+ (recommend 22) to enable the browsable site.
[tgd-wiki] The wiki is still readable as raw MDX at $WIKI_DIR/docs/.
EOF
  exit 0
fi

if ! command -v npm >/dev/null 2>&1; then
  cat >&2 <<EOF
[tgd-wiki] npm is not installed — skipping Docusaurus build.
[tgd-wiki] The wiki is still readable as raw MDX at $WIKI_DIR/docs/.
EOF
  exit 0
fi

cd "$WIKI_DIR" || exit 1

if [ "$SKIP_INSTALL" != "true" ]; then
  if [ ! -d node_modules ] || [ package.json -nt node_modules/.package-lock.json ] 2>/dev/null; then
    echo "[tgd-wiki] Running npm install (first run ~2 min, then cached)..." >&2
    if ! npm install --no-audit --no-fund --loglevel=error; then
      cat >&2 <<EOF
[tgd-wiki] npm install failed.
[tgd-wiki] The wiki is still readable as raw MDX at $WIKI_DIR/docs/.
[tgd-wiki] Retry manually with: cd $WIKI_DIR && npm install
EOF
      exit 0
    fi
  else
    echo "[tgd-wiki] node_modules present — skipping npm install." >&2
  fi
fi

echo "[tgd-wiki] Building Docusaurus site..." >&2
if ! npx --no-install docusaurus build --out-dir build 2>&1; then
  cat >&2 <<EOF
[tgd-wiki] docusaurus build failed.
[tgd-wiki] The wiki is still readable as raw MDX at $WIKI_DIR/docs/.
[tgd-wiki] Retry manually with: cd $WIKI_DIR && npm run build
EOF
  exit 0
fi

echo "[tgd-wiki] Site built: $WIKI_DIR/build/index.html" >&2
echo "[tgd-wiki] To serve locally: cd $WIKI_DIR && npm run serve" >&2
echo "[tgd-wiki] Or dev mode:      cd $WIKI_DIR && npm run start" >&2

# Layout/brand contract check — runs after every build so /tgd-map
# notices if the user (or a stale npm install) drifted the wiki away
# from the skill's source of truth.
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
if [ -f "$SKILL_DIR/scripts/verify-wiki.py" ]; then
  echo "[tgd-wiki] Verifying layout/brand contract..." >&2
  if ! python3 "$SKILL_DIR/scripts/verify-wiki.py" "$TGD_DIR" 2>&1; then
    echo "[tgd-wiki] ⚠️  Layout/brand contract failed — wiki still built but visuals may have drifted." >&2
    echo "[tgd-wiki]      See verify-wiki.py output above for remediation hints." >&2
  fi
fi

exit 0
