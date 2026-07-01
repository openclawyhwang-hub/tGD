#!/bin/bash
# build-site.sh — Build the MkDocs static site for $TGD_DIR/wiki/.
#
# Usage:
#   bash build-site.sh <TGD_DIR>
#
# Soft-fails when mkdocs is not installed — the wiki is still readable as raw
# Markdown, so we just warn and exit 0.

set -u

TGD_DIR="${1:-}"
if [ -z "$TGD_DIR" ] || [ ! -d "$TGD_DIR" ]; then
  echo "Error: TGD_DIR argument required (got: '$TGD_DIR')" >&2
  exit 2
fi

if [ ! -f "$TGD_DIR/mkdocs.yml" ]; then
  echo "Error: $TGD_DIR/mkdocs.yml not found. Run generate-mkdocs-config.py first." >&2
  exit 2
fi

if ! command -v mkdocs >/dev/null 2>&1; then
  cat >&2 <<EOF
[tgd-wiki] mkdocs is not installed — skipping static site build.
[tgd-wiki] Install to enable the browsable site:
[tgd-wiki]   pip install mkdocs mkdocs-material mkdocs-mermaid2-plugin
[tgd-wiki] The wiki is still readable as raw Markdown at $TGD_DIR/wiki/.
EOF
  exit 0
fi

echo "[tgd-wiki] Building MkDocs site..." >&2
cd "$TGD_DIR" || exit 1

if ! mkdocs build --quiet; then
  echo "[tgd-wiki] mkdocs build failed — the wiki is still readable as raw Markdown." >&2
  exit 0
fi

echo "[tgd-wiki] Site built: $TGD_DIR/site/index.html" >&2
echo "[tgd-wiki] To serve: cd $TGD_DIR && mkdocs serve" >&2
exit 0
