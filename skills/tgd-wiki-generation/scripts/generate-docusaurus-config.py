#!/usr/bin/env python3
"""
generate-docusaurus-config.py — Emit $TGD_DIR/docusaurus.config.ts,
sidebars.ts, package.json, and .gitignore from $TGD_DIR/docs/manifest.json.

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
    """Turn any project name into a valid npm package name."""
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


def module_and_flow_lists(manifest: dict) -> tuple[list, list]:
    pages = manifest.get("pages") or []
    modules = []
    flows = []
    for p in pages:
        page_id = p.get("id") or ""
        if page_id.startswith("modules/"):
            slug = page_id.split("/", 1)[1]
            modules.append({"slug": slug, "title": p.get("summary") or slug})
        elif page_id.startswith("flows/"):
            slug = page_id.split("/", 1)[1]
            flows.append({"slug": slug, "title": p.get("summary") or slug})
    return modules, flows


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate Docusaurus config files")
    parser.add_argument("tgd_dir", help="$TGD_DIR path")
    args = parser.parse_args()

    tgd_dir = Path(args.tgd_dir).expanduser().resolve()
    if not tgd_dir.is_dir():
        sys.stderr.write(f"Error: TGD_DIR does not exist: {tgd_dir}\n")
        return 2

    manifest_path = tgd_dir / "docs" / "manifest.json"
    if not manifest_path.is_file():
        sys.stderr.write(
            f"Error: manifest.json not found at {manifest_path}. "
            f"Run generate-wiki.py first.\n"
        )
        return 2

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    project = manifest.get("project") or {}
    project_name = project.get("name") or "tgd-wiki"
    project_desc = project.get("description") or ""

    modules, flows = module_and_flow_lists(manifest)
    additional_repos = [p for p in (manifest.get("pages") or []) if p.get("id") == "sources"]

    env = make_env()

    # docusaurus.config.ts
    (tgd_dir / "docusaurus.config.ts").write_text(
        env.get_template("docusaurus.config.ts.jinja").render(
            site_title=f"{project_name} Wiki",
            site_tagline=project_desc,
            navbar_title=f"{project_name} Wiki",
            project_name=project_name,
        ),
        encoding="utf-8",
    )
    sys.stderr.write(f"[tgd-wiki] Wrote {tgd_dir}/docusaurus.config.ts\n")

    # sidebars.ts
    (tgd_dir / "sidebars.ts").write_text(
        env.get_template("sidebars.ts.jinja").render(
            modules=modules,
            flows=flows,
            additional_repos=additional_repos,
        ),
        encoding="utf-8",
    )
    sys.stderr.write(f"[tgd-wiki] Wrote {tgd_dir}/sidebars.ts\n")

    # package.json
    (tgd_dir / "package.json").write_text(
        env.get_template("package.json.jinja").render(pkg_name=npm_safe_name(project_name)),
        encoding="utf-8",
    )
    sys.stderr.write(f"[tgd-wiki] Wrote {tgd_dir}/package.json\n")

    # .gitignore
    (tgd_dir / ".gitignore").write_text(
        env.get_template("gitignore.jinja").render(),
        encoding="utf-8",
    )
    sys.stderr.write(f"[tgd-wiki] Wrote {tgd_dir}/.gitignore\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
