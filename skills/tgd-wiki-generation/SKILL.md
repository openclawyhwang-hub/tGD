---
name: tgd-wiki-generation
description: Generate a browsable DeepWiki-like documentation site from CodeGraph + Understand-Anything analysis. Produces $TGD_DIR/wiki/*.md, mkdocs.yml, and a built static site. Called by tgd-map Step 6.
---

# tGD Wiki Generation

## Overview

Compile the outputs of CodeGraph (`.codegraph/codegraph.db`) and
Understand-Anything (`.understand-anything/knowledge-graph.json`) into a
browsable Markdown wiki plus an optional MkDocs Material static site.

This gives humans a real documentation site to read, while giving downstream
tGD stages (`/tgd-define`, `/tgd-plan`, `/tgd-develop`) a structured
`manifest.json` to reference.

## When to Use

- Called automatically by `/tgd-map` Step 6 after CodeGraph + UA analysis complete
- Called manually to regenerate the wiki after code changes
- Called via `/tgd-wiki` slash command (future addition)

## Inputs

Required:

- `$TGD_DIR` — resolved by `/tgd-map` Step 0
- `$TGD_DIR/.scans/<repo>/.understand-anything/knowledge-graph.json` for each repo
- Optional: `$TGD_DIR/.scans/<repo>/.codegraph/` (used if `codegraph` CLI is available)

The primary repo is the first entry in the scans directory unless `--repo` is
passed. Additional repos (added in Step 1 of `/tgd-map`) are treated as
context repositories and get their own module pages.

## Outputs

```
$TGD_DIR/
├── wiki/                       ← Markdown source (human-readable)
│   ├── index.md                ← Unified entry point (people)
│   ├── overview.md
│   ├── architecture.md
│   ├── onboarding.md
│   ├── modules/
│   │   └── <module>.md
│   ├── flows/
│   │   └── <flow>.md
│   ├── files/                  ← Optional: per-file summary pages
│   │   └── <file-slug>.md
│   ├── diagrams/
│   │   ├── architecture.mmd
│   │   ├── dependencies.mmd
│   │   └── index.md
│   ├── sources.md              ← Additional context repos
│   └── manifest.json           ← Machine-readable index (agents)
├── mkdocs.yml                  ← Site config (auto-generated)
└── site/                       ← Built static site (mkdocs build)
    └── index.html
```

Three coordinated entry points:

| Audience | Entry point | Purpose |
|---|---|---|
| Human | `$TGD_DIR/site/index.html` (or `wiki/index.md`) | Browse the wiki |
| Agent | `$TGD_DIR/wiki/manifest.json` | Machine-readable navigation |
| tGD stages | `$TGD_DIR/CONTEXT.md` | Top-level summary (unchanged) |

## Execution

```bash
python <SKILL_DIR>/scripts/generate-wiki.py "$TGD_DIR"
python <SKILL_DIR>/scripts/generate-mkdocs-config.py "$TGD_DIR"
bash   <SKILL_DIR>/scripts/build-site.sh "$TGD_DIR"
```

`<SKILL_DIR>` resolves to the directory containing this SKILL.md.

Each script fails soft:

- `generate-wiki.py` — hard failure aborts (wiki is required)
- `generate-mkdocs-config.py` — hard failure aborts
- `build-site.sh` — soft failure logs a warning and continues
  (the wiki is still readable as raw Markdown when `mkdocs` is missing)

## Dependencies

| Tool | Purpose | Required? | Install |
|---|---|---|---|
| Python 3.9+ | Run generation scripts | Required | System |
| Jinja2 | Template rendering | Required | `pip install jinja2` |
| PyYAML | mkdocs.yml generation | Required | `pip install pyyaml` |
| MkDocs | Static site build | Optional | `pip install mkdocs mkdocs-material mkdocs-mermaid2-plugin` |
| codegraph CLI | Symbol-level pages | Optional | See CodeGraph docs |

When optional deps are missing, the skill still produces `wiki/*.md` and
`manifest.json`. Only the static site build is skipped.

## Regeneration

Re-running the skill on the same `$TGD_DIR` overwrites `wiki/`, `mkdocs.yml`,
and `site/` in place. `manifest.json` is regenerated fresh — do not hand-edit
it; edits will be lost. If you need per-project overrides, add a
`$TGD_DIR/wiki-overrides/` directory (future extension).

## Related Skills

- `tgd-router` — Meta-skill entry point
- `tgd-context-engineering` — Uses wiki output to reload project context
- `tgd-planning-and-task-breakdown` — Reads `manifest.json` for task planning
- `understand` — Upstream: produces the knowledge graph consumed here

## Pitfalls

- ❌ **Do not write into the code repo.** All outputs go under `$TGD_DIR/`.
- ❌ **Do not hand-edit `manifest.json`** — regenerated on every run.
- ❌ **Skipping `generate-wiki.py` fallback logic** — non-code files (config, docs)
  must still appear as wiki pages so the manifest reflects the full graph.
- ❌ **Assuming `mkdocs` is installed** — the site build must degrade gracefully.
- ❌ **Building the site into the code repo's `docs/`** — always under `$TGD_DIR/site/`.
- ❌ **Broken `[[wikilinks]]`** — every link the script emits must correspond
  to a page that actually gets written; wrap link generation in a validator pass.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The dashboard already shows the graph — a wiki is redundant." | The dashboard is interactive but not readable end-to-end, not searchable across pages, and does not survive as an artifact. A Markdown wiki is grep-able, git-friendly, and readable without a running server. |
| "MkDocs is heavyweight — just concatenate the Markdown." | MkDocs Material gives full-text search, dark mode, mobile-friendly navigation, and Mermaid rendering for zero code. Rolling our own would take days and be worse. |
| "The manifest is optional — humans can just read `index.md`." | Downstream tGD stages (`/tgd-define`, `/tgd-plan`) need structured lookup by page id, entry points, and related nodes. Parsing Markdown for that is fragile; `manifest.json` is the contract. |
| "Skip Step 6 for small projects — the wiki adds no value." | Small projects benefit most: a 2-page wiki is still 2 more pages than they had, and the manifest still helps downstream stages. The cost is a few seconds. |

## Red Flags

- Emitting wiki pages that reference nodes not present in the knowledge graph
- Writing anywhere outside `$TGD_DIR/` (code repo, `$HOME`, `/tmp` beyond scratch)
- Hard-failing when `mkdocs` is missing instead of soft-failing on the site build
- Generating `manifest.json` without listing every page written to disk
- Leaving stale files behind on regeneration (old modules that no longer match the graph)
- Emitting Mermaid diagrams that mkdocs cannot parse (missing plugin, wrong fence)
- Silently swallowing template rendering errors — every failure must surface

## Verification

After running this skill:

- [ ] `$TGD_DIR/wiki/index.md` exists and is non-empty
- [ ] `$TGD_DIR/wiki/manifest.json` exists and lists every rendered page
- [ ] `$TGD_DIR/wiki/overview.md`, `architecture.md`, `onboarding.md` exist
- [ ] `$TGD_DIR/wiki/modules/` contains one page per architectural layer
- [ ] `$TGD_DIR/wiki/flows/` contains one page per tour step (or is empty if no tour)
- [ ] `$TGD_DIR/wiki/diagrams/architecture.mmd` and `dependencies.mmd` exist
- [ ] `$TGD_DIR/mkdocs.yml` exists and is valid YAML
- [ ] If `mkdocs` is available: `$TGD_DIR/site/index.html` exists and `mkdocs serve` starts without errors
- [ ] No files were written outside `$TGD_DIR/`
- [ ] Re-running the skill on the same input produces identical output (idempotent)
