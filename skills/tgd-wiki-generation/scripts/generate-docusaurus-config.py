#!/usr/bin/env python3
"""
generate-docusaurus-config.py — Emit multi-repo Docusaurus config.

Reads $TGD_DIR/wiki/docs/manifest.json (top-level manifest with a repos
array — one entry per scanned repo, each with its own modules/flows list),
and emits:

    $TGD_DIR/wiki/docusaurus.config.ts   ← navbar w/ Repos dropdown
    $TGD_DIR/wiki/sidebars.ts            ← one category per repo
    $TGD_DIR/wiki/package.json           ← pinned Docusaurus 3
    $TGD_DIR/wiki/.gitignore

Called by /tgd-map Step 6 after generate-wiki.py.

Usage:
    python generate-docusaurus-config.py <TGD_DIR>
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

try:
    from jinja2 import Environment, FileSystemLoader, Undefined
except ImportError:
    sys.stderr.write("Error: Jinja2 is required. Install with: pip install jinja2\n")
    sys.exit(2)


SCRIPT_DIR = Path(__file__).resolve().parent
SKILL_DIR = SCRIPT_DIR.parent
TEMPLATE_DIR = SKILL_DIR / "templates" / "config"


class SilentUndefined(Undefined):
    def _fail_with_undefined_error(self, *args, **kwargs):  # type: ignore[override]
        return ""

    def __str__(self):
        return ""


def npm_safe_name(raw: str) -> str:
    lo = (raw or "").lower()
    lo = re.sub(r"[^a-z0-9._~-]+", "-", lo)
    lo = re.sub(r"-+", "-", lo).strip("-")
    return (lo or "tgd-wiki")[:214]


def make_env() -> Environment:
    env = Environment(
        loader=FileSystemLoader(str(TEMPLATE_DIR)),
        undefined=SilentUndefined,
        trim_blocks=True,
        lstrip_blocks=True,
        keep_trailing_newline=True,
    )
    env.filters["tojson"] = lambda v: json.dumps(v, ensure_ascii=False)
    return env


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate multi-repo Docusaurus config")
    parser.add_argument("tgd_dir", help="$TGD_DIR path")
    args = parser.parse_args()

    tgd_dir = Path(args.tgd_dir).expanduser().resolve()
    if not tgd_dir.is_dir():
        sys.stderr.write(f"Error: TGD_DIR does not exist: {tgd_dir}\n")
        return 2

    manifest_path = tgd_dir / "wiki" / "docs" / "manifest.json"
    if not manifest_path.is_file():
        sys.stderr.write(
            f"Error: manifest.json not found at {manifest_path}. "
            f"Run generate-wiki.py first.\n"
        )
        return 2

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    repos = manifest.get("repos") or []
    primary_slug = manifest.get("primaryRepoSlug") or (repos[0]["slug"] if repos else "primary")

    if not repos:
        sys.stderr.write("Error: manifest.json has no 'repos' array.\n")
        return 2

    # Derive a title for the whole site — use primary repo name, fallback to slug.
    primary = next((r for r in repos if r["slug"] == primary_slug), repos[0])
    project_name = primary.get("name") or primary_slug
    project_desc = primary.get("description") or ""

    env = make_env()
    wiki_dir = tgd_dir / "wiki"
    wiki_dir.mkdir(parents=True, exist_ok=True)

    # docusaurus.config.ts
    (wiki_dir / "docusaurus.config.ts").write_text(
        env.get_template("docusaurus.config.ts.jinja").render(
            site_title=f"{project_name} Wiki" if len(repos) == 1 else "tGD Wiki",
            site_tagline=project_desc if len(repos) == 1
                          else f"{len(repos)} repositories — DeepWiki-style knowledge base",
            navbar_title=f"{project_name} Wiki" if len(repos) == 1 else "tGD Wiki",
            project_name=project_name,
            repos=repos,
            primary_slug=primary_slug,
            multi_repo=len(repos) > 1,
        ),
        encoding="utf-8",
    )
    sys.stderr.write(f"[tgd-wiki] Wrote {wiki_dir}/docusaurus.config.ts\n")

    # sidebars.ts
    (wiki_dir / "sidebars.ts").write_text(
        env.get_template("sidebars.ts.jinja").render(
            repos=repos,
            primary_slug=primary_slug,
        ),
        encoding="utf-8",
    )
    sys.stderr.write(f"[tgd-wiki] Wrote {wiki_dir}/sidebars.ts\n")

    # package.json
    (wiki_dir / "package.json").write_text(
        env.get_template("package.json.jinja").render(pkg_name=npm_safe_name(project_name)),
        encoding="utf-8",
    )
    sys.stderr.write(f"[tgd-wiki] Wrote {wiki_dir}/package.json\n")

    # .gitignore
    (wiki_dir / ".gitignore").write_text(
        env.get_template("gitignore.jinja").render(),
        encoding="utf-8",
    )
    sys.stderr.write(f"[tgd-wiki] Wrote {wiki_dir}/.gitignore\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
