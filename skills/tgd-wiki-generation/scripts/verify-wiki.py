#!/usr/bin/env python3
"""
verify-wiki.py — Layout / brand uniformity contract for tGD Wiki.

Enforces the "every project gets the same DeepWiki-style layout" guarantee
that is the core design promise of tgd-wiki-generation. Catches regressions
where someone:

- hand-edits wiki/src/ (overwritten on next run, so any edit is wrong)
- bumps a Docusaurus dependency outside the pinned range
- removes a brand color from custom.css
- drops a required component
- changes manifest.json shape (breaks downstream tGD stages)

Exits 0 when all checks pass. Exits 1 on the first contract violation,
printing a clear remediation hint per failure.

Usage:
    python verify-wiki.py <TGD_DIR>
    python verify-wiki.py --skill-dir <DIR> <TGD_DIR>   # for CI
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path
from typing import List, Tuple

# ---------------------------------------------------------------------------
# Contract: these are the things that MUST NOT drift.
# ---------------------------------------------------------------------------

# Pinned to ^3.7.0. CI catches accidental major bumps; this catch is the
# safety net for hand-edits in the user's $TGD_DIR/wiki/package.json.
REQUIRED_NPM_PACKAGES = {
    "@docusaurus/core":              r"\^?3\.",
    "@docusaurus/preset-classic":     r"\^?3\.",
    "@docusaurus/theme-mermaid":      r"\^?3\.",
    "@docusaurus/module-type-aliases": r"\^?3\.",
    "@docusaurus/tsconfig":          r"\^?3\.",
    "@docusaurus/types":             r"\^?3\.",
    "@mdx-js/react":                 r"\^?3\.",
    "react":                         r"\^?18\.",
    "react-dom":                     r"\^?18\.",
    "typescript":                    r"~?5\.",
}

# React components shipped inside the skill. User $TGD_DIR must contain
# every one of them at the same path (copy is part of generate-wiki.py).
REQUIRED_COMPONENTS = [
    "ModuleCard.tsx",
    "KPIGrid.tsx",
    "LayerBadge.tsx",
    "Hero.tsx",
]

# Brand tokens. These CSS variables must exist in custom.css. Catches
# anyone deleting a brand color "because it looks redundant".
REQUIRED_BRAND_TOKENS = [
    # Primary
    "--ifm-color-primary:",
    # Per-layer accent bars
    "--tgd-accent-ui:",
    "--tgd-accent-api:",
    "--tgd-accent-domain:",
    "--tgd-accent-persistence:",
    "--tgd-accent-infra:",
    # Component class hooks
    ".tgd-hero",
    ".tgd-module-card",
    ".tgd-kpi-grid",
    ".tgd-layer-badge",
]

# Per-project invariants — every $TGD_DIR/wiki/ must have these.
REQUIRED_WIKI_PATHS = [
    "wiki/docs/index.mdx",
    "wiki/docs/overview.mdx",
    "wiki/docs/architecture.mdx",
    "wiki/docs/onboarding.mdx",
    "wiki/docs/manifest.json",
    "wiki/docusaurus.config.ts",
    "wiki/sidebars.ts",
    "wiki/package.json",
    "wiki/.gitignore",
    "wiki/src/css/custom.css",
]

# manifest.json required fields — downstream tGD stages depend on these.
REQUIRED_MANIFEST_FIELDS = [
    "generator.name",
    "generator.version",
    "generator.engine",
    "project.name",
    "project.primaryRepoSlug",
    "project.languages",
    "pages",
    "importantFlows",
    "entryPoints",
]


# ---------------------------------------------------------------------------
# Check helpers
# ---------------------------------------------------------------------------


def _ok(label: str) -> str:
    return f"  ✅ {label}"


def _fail(label: str, hint: str) -> str:
    return f"  ❌ {label}\n       💡 {hint}"


def check_required_paths(tgd_dir: Path) -> Tuple[bool, List[str]]:
    """Every wiki-owned artefact must exist under $TGD_DIR/wiki/."""
    lines: List[str] = []
    ok = True
    for rel in REQUIRED_WIKI_PATHS:
        p = tgd_dir / rel
        if p.is_file() or p.is_dir():
            lines.append(_ok(rel))
        else:
            ok = False
            lines.append(_fail(
                f"Missing {rel}",
                f"Re-run generate-wiki.py / generate-docusaurus-config.py to (re)generate it.",
            ))
    return ok, lines


def check_npm_pin(tgd_dir: Path) -> Tuple[bool, List[str]]:
    """Pinned Docusaurus range must not drift."""
    pkg = tgd_dir / "wiki" / "package.json"
    lines: List[str] = []
    ok = True
    if not pkg.is_file():
        return False, [_fail("wiki/package.json not found", "Re-run generate-docusaurus-config.py")]
    try:
        data = json.loads(pkg.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        return False, [_fail(f"wiki/package.json invalid JSON: {e}", "Regenerate it.")]

    deps = {**data.get("dependencies", {}), **data.get("devDependencies", {})}
    for name, pattern in REQUIRED_NPM_PACKAGES.items():
        actual = deps.get(name)
        if not actual:
            ok = False
            lines.append(_fail(
                f"package.json missing dependency {name}",
                "Re-run generate-docusaurus-config.py.",
            ))
            continue
        if not re.search(pattern, actual):
            ok = False
            lines.append(_fail(
                f"package.json {name}={actual!r} drifts from expected {pattern}",
                f"Pin to {pattern} (matches templates/config/package.json.jinja).",
            ))
        else:
            lines.append(_ok(f"{name}={actual}"))
    return ok, lines


def check_brand_assets(tgd_dir: Path) -> Tuple[bool, List[str]]:
    """Every required React component + every required brand token must exist."""
    lines: List[str] = []
    ok = True

    components_dir = tgd_dir / "wiki" / "src" / "components"
    for name in REQUIRED_COMPONENTS:
        if (components_dir / name).is_file():
            lines.append(_ok(f"components/{name}"))
        else:
            ok = False
            lines.append(_fail(
                f"components/{name} missing",
                "Re-run generate-wiki.py — it copies the component from skill assets/.",
            ))

    css = tgd_dir / "wiki" / "src" / "css" / "custom.css"
    if not css.is_file():
        return False, lines + [_fail("src/css/custom.css missing", "Re-run generate-wiki.py.")]
    content = css.read_text(encoding="utf-8")
    for token in REQUIRED_BRAND_TOKENS:
        if token in content:
            lines.append(_ok(f"brand token {token}"))
        else:
            ok = False
            lines.append(_fail(
                f"custom.css missing brand token {token!r}",
                "Patch skills/tgd-wiki-generation/assets/css/custom.css to restore it.",
            ))
    return ok, lines


def check_manifest_shape(tgd_dir: Path) -> Tuple[bool, List[str]]:
    """manifest.json must have all downstream-required fields."""
    m = tgd_dir / "wiki" / "docs" / "manifest.json"
    lines: List[str] = []
    ok = True
    if not m.is_file():
        return False, [_fail("manifest.json missing", "Re-run generate-wiki.py.")]
    try:
        data = json.loads(m.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        return False, [_fail(f"manifest.json invalid JSON: {e}", "Regenerate it.")]

    for dotted in REQUIRED_MANIFEST_FIELDS:
        cur: object = data
        found = True
        for part in dotted.split("."):
            if isinstance(cur, dict) and part in cur:
                cur = cur[part]
            else:
                found = False
                break
        if found:
            lines.append(_ok(f"manifest.{dotted}"))
        else:
            ok = False
            lines.append(_fail(
                f"manifest.json missing field '{dotted}'",
                "Re-run generate-wiki.py — the schema is fixed.",
            ))

    pages = data.get("pages") or []
    if not isinstance(pages, list) or not pages:
        ok = False
        lines.append(_fail("manifest.pages is empty", "Re-run generate-wiki.py."))
    else:
        lines.append(_ok(f"manifest.pages ({len(pages)} entries)"))
    return ok, lines


def check_assets_match_skill(tgd_dir: Path, skill_dir: Path) -> Tuple[bool, List[str]]:
    """User $TGD_DIR/wiki/src/ must be a byte-identical copy of skill assets/.

    This is the cardinal guarantee: if the user can diverge from the skill,
    uniformity dies. We hash both sides and compare.
    """
    lines: List[str] = []
    ok = True
    skill_components = skill_dir / "assets" / "components"
    user_components = tgd_dir / "wiki" / "src" / "components"
    skill_css = skill_dir / "assets" / "css" / "custom.css"
    user_css = tgd_dir / "wiki" / "src" / "css" / "custom.css"

    def sha(p: Path) -> str:
        return hashlib.sha256(p.read_bytes()).hexdigest()[:16]

    for name in REQUIRED_COMPONENTS:
        s = skill_components / name
        u = user_components / name
        if not s.is_file():
            ok = False
            lines.append(_fail(f"skill asset {s} missing", "Skill file lost — re-check the repo."))
            continue
        if not u.is_file():
            ok = False
            lines.append(_fail(f"user copy {u} missing", "Re-run generate-wiki.py."))
            continue
        if sha(s) != sha(u):
            ok = False
            lines.append(_fail(
                f"components/{name} drifted from skill ({sha(s)} vs {sha(u)})",
                "DO NOT hand-edit wiki/src/. Re-run generate-wiki.py to restore.",
            ))
        else:
            lines.append(_ok(f"components/{name} matches skill"))

    if skill_css.is_file() and user_css.is_file():
        if sha(skill_css) != sha(user_css):
            ok = False
            lines.append(_fail(
                f"custom.css drifted from skill ({sha(skill_css)} vs {sha(user_css)})",
                "DO NOT hand-edit wiki/src/css/. Re-run generate-wiki.py to restore.",
            ))
        else:
            lines.append(_ok("custom.css matches skill"))
    return ok, lines


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify tGD Wiki layout/brand contract")
    parser.add_argument("tgd_dir", help="$TGD_DIR path to verify")
    parser.add_argument("--skill-dir", help="Override skill dir (default: <script>/..)")
    args = parser.parse_args()

    tgd_dir = Path(args.tgd_dir).expanduser().resolve()
    if not tgd_dir.is_dir():
        print(f"Error: TGD_DIR does not exist: {tgd_dir}", file=sys.stderr)
        return 2

    skill_dir = (
        Path(args.skill_dir).expanduser().resolve()
        if args.skill_dir
        else Path(__file__).resolve().parent.parent
    )
    if not (skill_dir / "assets" / "components").is_dir():
        print(f"Error: skill-dir invalid (no assets/components): {skill_dir}", file=sys.stderr)
        return 2

    print(f"🔍 Verifying tGD Wiki contract for {tgd_dir}")
    print(f"   skill: {skill_dir}")
    print()

    sections: List[Tuple[str, bool, List[str]]] = []

    sections.append(("Required paths", *check_required_paths(tgd_dir)))
    print(f"📂 {sections[-1][0]}:")
    for ln in sections[-1][2]:
        print(ln)
    print()

    sections.append(("npm package pinning", *check_npm_pin(tgd_dir)))
    print(f"📦 {sections[-1][0]}:")
    for ln in sections[-1][2]:
        print(ln)
    print()

    sections.append(("Brand assets", *check_brand_assets(tgd_dir)))
    print(f"🎨 {sections[-1][0]}:")
    for ln in sections[-1][2]:
        print(ln)
    print()

    sections.append(("Manifest shape", *check_manifest_shape(tgd_dir)))
    print(f"📋 {sections[-1][0]}:")
    for ln in sections[-1][2]:
        print(ln)
    print()

    sections.append(("Skill assets vs user copy", *check_assets_match_skill(tgd_dir, skill_dir)))
    print(f"🪞 {sections[-1][0]}:")
    for ln in sections[-1][2]:
        print(ln)
    print()

    all_ok = all(ok for _, ok, _ in sections)
    if all_ok:
        print("✅ tGD Wiki contract: PASSED")
        return 0
    else:
        failed = [name for name, ok, _ in sections if not ok]
        print(f"❌ tGD Wiki contract: FAILED ({', '.join(failed)})")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
