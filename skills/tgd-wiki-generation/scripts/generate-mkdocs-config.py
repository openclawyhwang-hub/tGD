#!/usr/bin/env python3
"""
generate-mkdocs-config.py — Emit $TGD_DIR/mkdocs.yml from $TGD_DIR/wiki/manifest.json.

Usage:
    python generate-mkdocs-config.py <TGD_DIR>
"""

from __future__ import annotations

import argparse
import json
import sys
from collections import defaultdict
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.stderr.write("Error: PyYAML is required. Install with: pip install pyyaml\n")
    sys.exit(2)


DEFAULT_THEME = {
    "name": "material",
    "features": [
        "navigation.instant",
        "navigation.tracking",
        "navigation.tabs",
        "navigation.sections",
        "navigation.top",
        "search.suggest",
        "search.highlight",
        "content.code.copy",
    ],
    "palette": [
        {
            "media": "(prefers-color-scheme: light)",
            "scheme": "default",
            "toggle": {"icon": "material/brightness-7", "name": "Switch to dark mode"},
        },
        {
            "media": "(prefers-color-scheme: dark)",
            "scheme": "slate",
            "toggle": {"icon": "material/brightness-4", "name": "Switch to light mode"},
        },
    ],
}

MARKDOWN_EXTENSIONS = [
    "admonition",
    "toc",
    "pymdownx.details",
    "pymdownx.tabbed",
    {
        "pymdownx.superfences": {
            "custom_fences": [
                {
                    "name": "mermaid",
                    "class": "mermaid",
                    # Placeholder — rewritten to `!!python/name:...` after YAML dump.
                    "format": "__MERMAID_FORMAT_PLACEHOLDER__",
                }
            ]
        }
    },
]

# We prefer mkdocs-mermaid2-plugin when it's installed; if not, we fall back
# to plain search-only config. The presence check happens at build time.
PLUGINS_WITH_MERMAID = ["search", "mermaid2"]
PLUGINS_WITHOUT_MERMAID = ["search"]


def has_mermaid_plugin() -> bool:
    try:
        import mermaid2  # type: ignore  # noqa: F401
        return True
    except Exception:
        pass
    # Also detect via mkdocs plugin entry points.
    try:
        import importlib.metadata as md
        for ep in md.entry_points():
            name = getattr(ep, "name", "")
            if name == "mermaid2":
                return True
    except Exception:
        pass
    return False


def build_nav(manifest: dict) -> list:
    pages = manifest.get("pages") or []

    top: list = []
    modules_by_id: dict = {}
    flows_by_id: dict = {}

    for p in pages:
        page_id = p.get("id") or ""
        path = p.get("path") or ""
        # mkdocs nav paths are relative to docs_dir (wiki/), so strip the wiki/ prefix.
        rel = path[len("wiki/"):] if path.startswith("wiki/") else path
        if page_id == "index":
            top.append({"Home": rel})
        elif page_id == "overview":
            top.append({"Overview": rel})
        elif page_id == "architecture":
            top.append({"Architecture": rel})
        elif page_id == "onboarding":
            top.append({"Onboarding": rel})
        elif page_id == "diagrams":
            top.append({"Diagrams": rel})
        elif page_id == "sources":
            top.append({"Sources": rel})
        elif page_id.startswith("modules/"):
            modules_by_id[page_id] = (p.get("summary") or page_id.split("/", 1)[1], rel)
        elif page_id.startswith("flows/"):
            flows_by_id[page_id] = (p.get("summary") or page_id.split("/", 1)[1], rel)

    if modules_by_id:
        modules_nav = []
        for _, (title, rel) in sorted(modules_by_id.items()):
            # Title comes from summary; fall back to filename stem.
            name = title if title else Path(rel).stem.title()
            modules_nav.append({name: rel})
        top.append({"Modules": modules_nav})

    if flows_by_id:
        flows_nav = []
        for _, (title, rel) in sorted(flows_by_id.items()):
            name = title if title else Path(rel).stem.title()
            flows_nav.append({name: rel})
        top.append({"Flows": flows_nav})

    return top


def build_config(manifest: dict) -> dict:
    project = manifest.get("project") or {}
    site_name = project.get("name") or "Project Wiki"
    site_description = project.get("description") or ""

    plugins = PLUGINS_WITH_MERMAID if has_mermaid_plugin() else PLUGINS_WITHOUT_MERMAID

    return {
        "site_name": f"{site_name} Wiki",
        "site_description": site_description,
        "docs_dir": "wiki",
        "site_dir": "site",
        "use_directory_urls": True,
        "theme": DEFAULT_THEME,
        "markdown_extensions": MARKDOWN_EXTENSIONS,
        "plugins": plugins,
        "nav": build_nav(manifest),
    }


def dump_yaml(cfg: dict) -> str:
    """Dump config to YAML, then post-process the mermaid format placeholder
    into the unquoted `!!python/name:...` tag that mkdocs expects."""
    text = yaml.safe_dump(cfg, sort_keys=False, allow_unicode=True)
    # Replace the quoted placeholder with the bare tag reference.
    text = text.replace(
        "format: __MERMAID_FORMAT_PLACEHOLDER__",
        "format: !!python/name:pymdownx.superfences.fence_code_format",
    )
    return text


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate mkdocs.yml from manifest.json")
    parser.add_argument("tgd_dir", help="$TGD_DIR path")
    args = parser.parse_args()

    tgd_dir = Path(args.tgd_dir).expanduser().resolve()
    if not tgd_dir.is_dir():
        sys.stderr.write(f"Error: TGD_DIR does not exist: {tgd_dir}\n")
        return 2

    manifest_path = tgd_dir / "wiki" / "manifest.json"
    if not manifest_path.is_file():
        sys.stderr.write(
            f"Error: manifest.json not found at {manifest_path}. "
            f"Run generate-wiki.py first.\n"
        )
        return 2

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    cfg = build_config(manifest)

    out = tgd_dir / "mkdocs.yml"
    out.write_text(dump_yaml(cfg), encoding="utf-8")
    sys.stderr.write(f"[tgd-wiki] Wrote {out}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
