#!/usr/bin/env python3
"""
generate-wiki.py — Compile Understand-Anything + CodeGraph outputs into a
Markdown wiki under $TGD_DIR/wiki/.

Called by /tgd-map Step 6 (via the tgd-wiki-generation skill).

Usage:
    python generate-wiki.py <TGD_DIR> [--repo <slug>] [--quiet]

Inputs:
    $TGD_DIR/.scans/<repo>/.understand-anything/knowledge-graph.json  (required)
    $TGD_DIR/.scans/<repo>/.codegraph/                                (optional)

Outputs:
    $TGD_DIR/wiki/index.md
    $TGD_DIR/wiki/overview.md
    $TGD_DIR/wiki/architecture.md
    $TGD_DIR/wiki/onboarding.md
    $TGD_DIR/wiki/sources.md
    $TGD_DIR/wiki/modules/*.md
    $TGD_DIR/wiki/flows/*.md
    $TGD_DIR/wiki/diagrams/index.md
    $TGD_DIR/wiki/diagrams/architecture.mmd
    $TGD_DIR/wiki/diagrams/dependencies.mmd
    $TGD_DIR/wiki/manifest.json
    $TGD_DIR/wiki/README.md

Fails hard on unrecoverable errors (missing $TGD_DIR, no knowledge graph).
Degrades gracefully when optional data is missing (no tour, no layers, etc.).
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

try:
    from jinja2 import Environment, FileSystemLoader, StrictUndefined, Undefined
except ImportError:
    sys.stderr.write(
        "Error: Jinja2 is required. Install with: pip install jinja2\n"
    )
    sys.exit(2)


GENERATOR_VERSION = "0.1.0"
SCRIPT_DIR = Path(__file__).resolve().parent
TEMPLATE_DIR = SCRIPT_DIR.parent / "templates"


# ---------------------------------------------------------------------------
# Data structures
# ---------------------------------------------------------------------------


@dataclass
class WikiModel:
    """The full compiled model handed to templates."""

    project: Dict[str, Any]
    layers: List[Dict[str, Any]]
    tour: List[Dict[str, Any]]
    nodes: List[Dict[str, Any]]
    edges: List[Dict[str, Any]]
    modules: List[Dict[str, Any]] = field(default_factory=list)
    flows: List[Dict[str, Any]] = field(default_factory=list)
    entry_points: List[Dict[str, Any]] = field(default_factory=list)
    additional_repos: List[Dict[str, Any]] = field(default_factory=list)
    primary_repo_slug: str = ""
    primary_repo_path: str = ""
    dashboard_url: Optional[str] = None
    architecture_mermaid: str = ""
    dependency_mermaid: str = ""
    patterns: List[Dict[str, Any]] = field(default_factory=list)
    node_paths: Dict[str, str] = field(default_factory=dict)
    generated_at: str = ""


# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------


_SLUG_RX = re.compile(r"[^a-z0-9]+")


def slugify(text: str) -> str:
    slug = _SLUG_RX.sub("-", (text or "").lower()).strip("-")
    return slug or "unnamed"


def log(msg: str, *, quiet: bool = False) -> None:
    if not quiet:
        sys.stderr.write(f"[tgd-wiki] {msg}\n")


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def write_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def write_json(path: Path, obj: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, indent=2, ensure_ascii=False), encoding="utf-8")


# ---------------------------------------------------------------------------
# Scan discovery
# ---------------------------------------------------------------------------


def discover_repos(tgd_dir: Path) -> List[Tuple[str, Path]]:
    """Return [(slug, scan_dir)] for every repo under $TGD_DIR/.scans/."""
    scans = tgd_dir / ".scans"
    if not scans.is_dir():
        return []
    repos: List[Tuple[str, Path]] = []
    for entry in sorted(scans.iterdir()):
        if entry.is_dir() and (entry / ".understand-anything" / "knowledge-graph.json").is_file():
            repos.append((entry.name, entry))
    return repos


def pick_primary_repo(
    repos: List[Tuple[str, Path]], requested: Optional[str]
) -> Tuple[str, Path]:
    if not repos:
        raise SystemExit(
            "No repos with a knowledge-graph.json found under $TGD_DIR/.scans/. "
            "Run /tgd-map Step 4 first."
        )
    if requested:
        for slug, path in repos:
            if slug == requested:
                return slug, path
        raise SystemExit(
            f"Requested repo '{requested}' not found. Available: "
            + ", ".join(s for s, _ in repos)
        )
    return repos[0]


# ---------------------------------------------------------------------------
# Model building
# ---------------------------------------------------------------------------


FILE_LEVEL_TYPES = {
    "file",
    "config",
    "document",
    "service",
    "pipeline",
    "table",
    "schema",
    "resource",
    "endpoint",
}


def _node_map(nodes: List[Dict[str, Any]]) -> Dict[str, Dict[str, Any]]:
    return {n["id"]: n for n in nodes if "id" in n}


def _node_paths(nodes: List[Dict[str, Any]]) -> Dict[str, str]:
    result: Dict[str, str] = {}
    for n in nodes:
        nid = n.get("id")
        if not nid:
            continue
        result[nid] = n.get("filePath") or n.get("name") or nid
    return result


def build_modules(
    layers: List[Dict[str, Any]],
    node_map: Dict[str, Dict[str, Any]],
    edges: List[Dict[str, Any]],
) -> List[Dict[str, Any]]:
    """One module page per layer."""
    modules: List[Dict[str, Any]] = []
    for layer in layers:
        title = layer.get("name") or layer.get("id") or "unnamed"
        slug = slugify(title)
        node_ids = layer.get("nodeIds") or []
        files: List[Dict[str, Any]] = []
        symbols: List[Dict[str, Any]] = []
        for nid in node_ids:
            node = node_map.get(nid)
            if not node:
                continue
            ntype = node.get("type")
            entry = {
                "path": node.get("filePath") or node.get("name") or nid,
                "summary": node.get("summary") or "",
            }
            if ntype in FILE_LEVEL_TYPES:
                files.append(entry)
            elif ntype in {"function", "class"}:
                symbols.append(
                    {
                        "name": node.get("name") or nid,
                        "file": node.get("filePath") or "",
                        "summary": node.get("summary") or "",
                    }
                )
        # Cap symbol list — too many drowns the page.
        symbols_capped = sorted(symbols, key=lambda s: s["name"])[:40]
        module_ids = set(node_ids)
        dep_mermaid = _module_dependency_mermaid(module_ids, edges, node_map, title)
        modules.append(
            {
                "id": layer.get("id") or f"layer:{slug}",
                "title": title,
                "slug": slug,
                "summary": layer.get("description") or "",
                "files": files,
                "symbols": symbols_capped,
                "dependency_mermaid": dep_mermaid,
                "node_ids": sorted(module_ids),
                "related_modules": [],
                "related_flows": [],
            }
        )
    return modules


def _module_dependency_mermaid(
    module_ids: set,
    edges: List[Dict[str, Any]],
    node_map: Dict[str, Dict[str, Any]],
    label: str,
) -> str:
    """Small internal-dependency graph for a single module."""
    subset = [
        e
        for e in edges
        if e.get("source") in module_ids and e.get("target") in module_ids
    ]
    if not subset:
        return f"graph TD\n  A[No internal edges in {label}]"
    lines = ["graph TD"]
    # Cap edges to avoid an unreadable soup.
    for e in subset[:60]:
        s = node_map.get(e["source"], {}).get("name") or e["source"]
        t = node_map.get(e["target"], {}).get("name") or e["target"]
        etype = e.get("type") or "→"
        lines.append(f'  {_mm_id(s)}[{s}] -->|{etype}| {_mm_id(t)}[{t}]')
    if len(subset) > 60:
        lines.append(f"  %% Truncated: {len(subset) - 60} more edges omitted")
    return "\n".join(lines)


def _mm_id(name: str) -> str:
    """Turn an arbitrary name into a Mermaid-safe identifier."""
    return re.sub(r"[^A-Za-z0-9_]", "_", name)[:80] or "n"


def build_flows(
    tour: List[Dict[str, Any]], node_paths: Dict[str, str]
) -> List[Dict[str, Any]]:
    flows: List[Dict[str, Any]] = []
    for step in tour or []:
        title = step.get("title") or f"Step {step.get('order', '?')}"
        slug = slugify(title)
        files = [
            {"path": node_paths.get(nid, nid), "summary": ""}
            for nid in step.get("nodeIds") or []
        ]
        flows.append(
            {
                "title": title,
                "slug": slug,
                "description": step.get("description") or "",
                "mermaid": _flow_sequence_mermaid(title, files),
                "files": files,
                "steps": [],
                "order": step.get("order", 0),
            }
        )
    return flows


def _flow_sequence_mermaid(title: str, files: List[Dict[str, Any]]) -> str:
    if not files:
        return f"sequenceDiagram\n  Note over Flow: {title} (no files captured)"
    lines = ["sequenceDiagram"]
    prev: Optional[str] = None
    for f in files:
        actor = _mm_id(Path(f["path"]).stem or "step")
        lines.append(f"  participant {actor}")
    for i, f in enumerate(files):
        actor = _mm_id(Path(f["path"]).stem or "step")
        if prev is None:
            lines.append(f"  Note over {actor}: start")
        else:
            lines.append(f"  {prev}->>+{actor}: next")
        prev = actor
    return "\n".join(lines)


def build_architecture_mermaid(
    layers: List[Dict[str, Any]], edges: List[Dict[str, Any]], node_map: Dict[str, Dict[str, Any]]
) -> str:
    """Layer-level architecture diagram."""
    if not layers:
        return "graph TD\n  A[No layers detected]"
    # Map each node → its layer.
    node_to_layer: Dict[str, str] = {}
    for l in layers:
        for nid in l.get("nodeIds") or []:
            node_to_layer[nid] = l.get("id") or slugify(l.get("name") or "layer")
    layer_edges: Dict[Tuple[str, str], int] = {}
    for e in edges:
        src = e.get("source") or ""
        tgt = e.get("target") or ""
        s = node_to_layer.get(src)
        t = node_to_layer.get(tgt)
        if s and t and s != t:
            layer_edges[(s, t)] = layer_edges.get((s, t), 0) + 1
    lines = ["graph TD"]
    for l in layers:
        lid = l.get("id") or slugify(l.get("name") or "layer")
        lname = l.get("name") or lid
        lines.append(f'  {_mm_id(lid)}["{lname}"]')
    for (s, t), weight in sorted(layer_edges.items(), key=lambda kv: -kv[1])[:30]:
        lines.append(f"  {_mm_id(s)} -->|{weight}| {_mm_id(t)}")
    return "\n".join(lines)


def build_dependency_mermaid(
    edges: List[Dict[str, Any]], node_map: Dict[str, Dict[str, Any]]
) -> str:
    """Simplified file-level dependency graph (top-N by edge count)."""
    counts: Dict[str, int] = {}
    for e in edges:
        counts[e.get("source", "")] = counts.get(e.get("source", ""), 0) + 1
        counts[e.get("target", "")] = counts.get(e.get("target", ""), 0) + 1
    # Deterministic ordering: sort by (-count, id) so ties break by node id.
    top_list = [nid for nid, _ in sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[:25]]
    top = set(top_list)
    if not top_list:
        return "graph TD\n  A[No edges]"
    lines = ["graph LR"]
    for nid in top_list:  # iterate the ordered list, NOT the set
        n = node_map.get(nid, {})
        lbl = n.get("name") or nid
        lines.append(f'  {_mm_id(nid)}["{lbl}"]')
    seen = 0
    for e in edges:
        if e.get("source") in top and e.get("target") in top:
            lines.append(f"  {_mm_id(e['source'])} --> {_mm_id(e['target'])}")
            seen += 1
            if seen >= 80:
                lines.append(f"  %% Truncated after 80 edges")
                break
    return "\n".join(lines)


def detect_entry_points(nodes: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """Heuristic entry-point detection from node tags/paths."""
    hits: List[Dict[str, Any]] = []
    entry_patterns = (
        "main.py",
        "__main__.py",
        "manage.py",
        "index.ts",
        "index.js",
        "main.ts",
        "main.tsx",
        "app.py",
        "server.ts",
        "server.js",
        "cmd/",
        "src/main.rs",
        "cli.py",
        "wsgi.py",
        "asgi.py",
    )
    seen = set()
    for n in nodes:
        fp = n.get("filePath") or ""
        tags = n.get("tags") or []
        is_entry = any(fp.endswith(p) or f"/{p}" in f"/{fp}" for p in entry_patterns) or "entry" in tags
        if is_entry and fp and fp not in seen:
            seen.add(fp)
            hits.append({"path": fp, "kind": "entry"})
        if len(hits) >= 10:
            break
    return hits


# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------


class SilentUndefined(Undefined):
    """Missing template var → empty string, no exception."""

    def _fail_with_undefined_error(self, *args, **kwargs):  # type: ignore[override]
        return ""

    def __str__(self):
        return ""


def make_env() -> Environment:
    return Environment(
        loader=FileSystemLoader(str(TEMPLATE_DIR)),
        undefined=SilentUndefined,
        trim_blocks=True,
        lstrip_blocks=True,
        keep_trailing_newline=True,
    )


def render(env: Environment, template_name: str, ctx: Dict[str, Any]) -> str:
    return env.get_template(template_name).render(**ctx)


# ---------------------------------------------------------------------------
# Manifest
# ---------------------------------------------------------------------------


def build_manifest(model: WikiModel, wiki_dir: Path) -> Dict[str, Any]:
    pages: List[Dict[str, Any]] = []

    def add_page(page_id: str, rel_path: str, page_type: str, summary: str, related=None):
        pages.append(
            {
                "id": page_id,
                "path": str(rel_path),
                "type": page_type,
                "summary": summary,
                "relatedNodes": related or [],
            }
        )

    add_page("index", "wiki/index.md", "index", "Unified wiki entry point")
    add_page("overview", "wiki/overview.md", "overview", model.project.get("description") or "")
    add_page("architecture", "wiki/architecture.md", "architecture", "Layers and dependencies")
    add_page("onboarding", "wiki/onboarding.md", "onboarding", "Suggested reading path")
    for m in model.modules:
        add_page(
            f"modules/{m['slug']}",
            f"wiki/modules/{m['slug']}.md",
            "module",
            m["summary"],
            related=m.get("node_ids") or [],
        )
    for f in model.flows:
        add_page(f"flows/{f['slug']}", f"wiki/flows/{f['slug']}.md", "flow", f["description"])
    add_page("diagrams", "wiki/diagrams/index.md", "diagrams", "Architecture and dependency diagrams")
    if model.additional_repos:
        add_page("sources", "wiki/sources.md", "sources", "Additional context repositories")

    return {
        "generator": {
            "name": "tgd-wiki-generation",
            "version": GENERATOR_VERSION,
            "generatedAt": model.generated_at,
        },
        "project": {
            "name": model.project.get("name") or "unnamed",
            "description": model.project.get("description") or "",
            "primaryRepoSlug": model.primary_repo_slug,
            "primaryRepoPath": model.primary_repo_path,
            "languages": model.project.get("languages") or [],
            "frameworks": model.project.get("frameworks") or [],
        },
        "entryPoints": model.entry_points,
        "importantFlows": [f"wiki/flows/{f['slug']}.md" for f in model.flows],
        "pages": pages,
    }


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------


def compile_model(
    graph: Dict[str, Any],
    primary_slug: str,
    primary_repo_path: str,
    additional_repos: List[Dict[str, Any]],
    dashboard_url: Optional[str],
) -> WikiModel:
    project = graph.get("project") or {}
    layers = graph.get("layers") or []
    tour = graph.get("tour") or []
    nodes = graph.get("nodes") or []
    edges = graph.get("edges") or []

    node_map = _node_map(nodes)
    node_paths = _node_paths(nodes)
    modules = build_modules(layers, node_map, edges)
    flows = build_flows(tour, node_paths)
    entry_points = detect_entry_points(nodes)
    arch_mm = build_architecture_mermaid(layers, edges, node_map)
    dep_mm = build_dependency_mermaid(edges, node_map)

    return WikiModel(
        project=project,
        layers=layers,
        tour=tour,
        nodes=nodes,
        edges=edges,
        modules=modules,
        flows=flows,
        entry_points=entry_points,
        additional_repos=additional_repos,
        primary_repo_slug=primary_slug,
        primary_repo_path=primary_repo_path,
        dashboard_url=dashboard_url,
        architecture_mermaid=arch_mm,
        dependency_mermaid=dep_mm,
        patterns=[],
        node_paths=node_paths,
        generated_at=datetime.now(timezone.utc).isoformat(timespec="seconds"),
    )


def infer_primary_repo_path(scan_dir: Path, project: Dict[str, Any]) -> str:
    # Prefer project.rootPath from the graph if present; otherwise guess.
    root = project.get("rootPath") or project.get("primaryRepoPath")
    if root:
        return root
    home = Path.home()
    guess = home / scan_dir.name
    return str(guess if guess.is_dir() else scan_dir.name)


def gather_additional_repos(
    tgd_dir: Path, primary_slug: str
) -> List[Dict[str, Any]]:
    extras: List[Dict[str, Any]] = []
    for slug, scan in discover_repos(tgd_dir):
        if slug == primary_slug:
            continue
        graph_path = scan / ".understand-anything" / "knowledge-graph.json"
        try:
            g = load_json(graph_path)
        except Exception:
            continue
        proj = g.get("project") or {}
        extras.append(
            {
                "name": proj.get("name") or slug,
                "source": slug,
                "type": "scanned",
                "path": infer_primary_repo_path(scan, proj),
                "summary": proj.get("description") or "",
                "relevance": "",
                "dashboard_url": None,
            }
        )
    return extras


def render_all(model: WikiModel, wiki_dir: Path) -> None:
    env = make_env()
    ctx_common = {
        "generator_version": GENERATOR_VERSION,
        "generated_at": model.generated_at,
        "project": model.project,
        "primary_repo_slug": model.primary_repo_slug,
        "primary_repo_path": model.primary_repo_path,
        "additional_repos": model.additional_repos,
        "dashboard_url": model.dashboard_url,
        "modules": model.modules,
        "flows": model.flows,
    }

    # Top-level pages
    write_text(
        wiki_dir / "index.md",
        render(env, "index.md.jinja", ctx_common),
    )
    write_text(
        wiki_dir / "overview.md",
        render(
            env,
            "overview.md.jinja",
            {
                **ctx_common,
                "entry_points": model.entry_points,
                "layers": model.layers,
            },
        ),
    )
    write_text(
        wiki_dir / "architecture.md",
        render(
            env,
            "architecture.md.jinja",
            {
                **ctx_common,
                "layers": model.layers,
                "architecture_mermaid": model.architecture_mermaid,
                "dependency_mermaid": model.dependency_mermaid,
                "patterns": model.patterns,
            },
        ),
    )
    write_text(
        wiki_dir / "onboarding.md",
        render(
            env,
            "onboarding.md.jinja",
            {
                **ctx_common,
                "tour": model.tour,
                "node_paths": model.node_paths,
            },
        ),
    )
    write_text(
        wiki_dir / "sources.md",
        render(
            env,
            "sources.md.jinja",
            {**ctx_common, "repos": model.additional_repos},
        ),
    )
    write_text(
        wiki_dir / "README.md",
        render(
            env,
            "readme.md.jinja",
            {**ctx_common, "site_name": model.project.get("name") or "Project Wiki"},
        ),
    )

    # Modules
    for m in model.modules:
        write_text(
            wiki_dir / "modules" / f"{m['slug']}.md",
            render(env, "module.md.jinja", {**ctx_common, "module": m}),
        )

    # Flows
    for f in model.flows:
        write_text(
            wiki_dir / "flows" / f"{f['slug']}.md",
            render(env, "flow.md.jinja", {**ctx_common, "flow": f}),
        )

    # Diagrams
    write_text(
        wiki_dir / "diagrams" / "index.md",
        render(
            env,
            "diagrams-index.md.jinja",
            {
                **ctx_common,
                "architecture_mermaid": model.architecture_mermaid,
                "dependency_mermaid": model.dependency_mermaid,
                "extra_diagrams": [],
            },
        ),
    )
    write_text(wiki_dir / "diagrams" / "architecture.mmd", model.architecture_mermaid)
    write_text(wiki_dir / "diagrams" / "dependencies.mmd", model.dependency_mermaid)


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate tGD wiki from CodeGraph + UA")
    parser.add_argument("tgd_dir", help="$TGD_DIR path")
    parser.add_argument("--repo", help="Primary repo slug (defaults to first scan)")
    parser.add_argument("--dashboard-url", help="Optional dashboard URL to embed in the index")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()

    tgd_dir = Path(args.tgd_dir).expanduser().resolve()
    if not tgd_dir.is_dir():
        sys.stderr.write(f"Error: TGD_DIR does not exist: {tgd_dir}\n")
        return 2

    repos = discover_repos(tgd_dir)
    if not repos:
        sys.stderr.write(
            f"Error: no repos with knowledge-graph.json under {tgd_dir}/.scans/\n"
            f"Run /tgd-map Step 4 (Understand-Anything) first.\n"
        )
        return 2

    primary_slug, primary_scan = pick_primary_repo(repos, args.repo)
    log(f"Primary repo: {primary_slug}", quiet=args.quiet)
    log(f"Scan dir: {primary_scan}", quiet=args.quiet)

    graph_path = primary_scan / ".understand-anything" / "knowledge-graph.json"
    graph = load_json(graph_path)
    log(
        f"Loaded graph: {len(graph.get('nodes') or [])} nodes, "
        f"{len(graph.get('edges') or [])} edges, "
        f"{len(graph.get('layers') or [])} layers, "
        f"{len(graph.get('tour') or [])} tour steps",
        quiet=args.quiet,
    )

    additional = gather_additional_repos(tgd_dir, primary_slug)
    if additional:
        log(f"Additional context repos: {len(additional)}", quiet=args.quiet)

    model = compile_model(
        graph=graph,
        primary_slug=primary_slug,
        primary_repo_path=infer_primary_repo_path(primary_scan, graph.get("project") or {}),
        additional_repos=additional,
        dashboard_url=args.dashboard_url,
    )

    wiki_dir = tgd_dir / "wiki"
    log(f"Rendering to {wiki_dir}", quiet=args.quiet)
    render_all(model, wiki_dir)

    manifest = build_manifest(model, wiki_dir)
    write_json(wiki_dir / "manifest.json", manifest)

    log("Done.", quiet=args.quiet)
    log(f"  Index:    {wiki_dir}/index.md", quiet=args.quiet)
    log(f"  Manifest: {wiki_dir}/manifest.json", quiet=args.quiet)
    log(f"  Modules:  {len(model.modules)}", quiet=args.quiet)
    log(f"  Flows:    {len(model.flows)}", quiet=args.quiet)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
