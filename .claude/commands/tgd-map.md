---
description: Map — scan and understand the existing project context before making changes
---

## Step 1: Context Discovery

Before analyzing anything, ask the user:

> "除了當前 repo，還有其他需要參考的 repo 嗎？（local path 或 git URL）"

- Accept **local paths** (e.g. `~/Projects/wayflow`) — resolve to absolute path
- Accept **git URLs** (e.g. `github.com/CopilotKit/CopilotKit`) — clone to `/tmp/tgd-context/<repo-name>`
- If user says "no" or provides nothing, proceed with primary repo only
- Store results for CONTEXT.md (see structure below)

## Step 2: Context Engineering

Run the `context-engineering` skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.

This is the starting point for joining an existing project or before making significant changes.

## Step 3: CodeGraph Setup

1. Ensure output directory exists: `mkdir -p tGD/map`
2. Create symlink so CodeGraph finds its DB at the expected root path:
   ```bash
   rm -rf .codegraph  # remove stale link if any
   ln -s tGD/map/.codegraph .codegraph
   ```
3. Initialize the project graph: `codegraph init -i`
   - *Requires CodeGraph installed. Setup handles this automatically.*

## Step 4: Understand-Anything (MANDATORY)

This step is **required**, not optional.

1. Create symlink so UA stores output in tGD/map:
   ```bash
   rm -rf .understand-anything  # remove stale link if any
   ln -s tGD/map/.understand-anything .understand-anything
   ```
2. Run `/understand` to build a full knowledge graph of the codebase
3. This produces `tGD/map/.understand-anything/knowledge-graph.json` — an interactive map of all components, dependencies, and relationships
4. After graph is built, run `/understand-dashboard` to launch an interactive web visualization (Vite dev server) for exploring the architecture visually
5. If unfamiliar with the project, also run `/understand-onboard` for a guided architecture tour

If additional repos were provided in Step 1, run `/understand` on each of them as well and capture their key insights.

## Step 5: Produce CONTEXT.md

**Outputs (all under `tGD/map/`):**
- `CONTEXT.md` — project structure analysis (MUST reference CodeGraph/UA data)
- `.codegraph/codegraph.db` — symbol index (via symlink)
- `.understand-anything/knowledge-graph.json` — full knowledge graph (via symlink)
- `.understand-anything/config.json` — UA configuration
- **Interactive dashboard** — launched via `/understand-dashboard` (reads knowledge-graph.json, serves on localhost)

**CONTEXT.md Structure:**
When writing `CONTEXT.md`, DO NOT rely solely on visual inspection of code.
Synthesize data from the tools:

```markdown
# CONTEXT.md

## 1. Primary Repository
**Path:** <absolute path>
**Name:** <repo name>

### Structure
<directory tree>

### Key Files
<important files and their roles>

### Summary
<tech stack, architecture, patterns — from UA knowledge graph>

### Code Entry Points
<from CodeGraph>

## 2. Additional Context Repositories
(For each additional repo provided in Step 1:)

### <repo-name> (<type: local_path | git_url>)
**Source:** <original input>
**Resolved to:** <absolute path or clone path>
**Summary:** <what this repo does>

**Key Insights:**
- <insight 1>
- <insight 2>

**Relevance:** <why this repo is relevant to the primary project>

## 3. Synthesis
### Integration Points
- <how repos relate to each other>

### Architecture Decisions
- <key decisions based on combined context>

### Open Questions
- <unresolved questions>

## See Also
- Interactive Dashboard: http://localhost:<port>
```

## Step 6: Verification Gate

- [ ] `tGD/map/CONTEXT.md` exists and is non-empty
- [ ] `tGD/map/.codegraph` symlink exists
- [ ] `tGD/map/.understand-anything` symlink exists
- [ ] `tGD/map/.understand-anything/knowledge-graph.json` exists
- [ ] If additional repos were provided, their summaries appear in CONTEXT.md

If verification passes, suggest the next step: `/tgd-define` to start defining what to build.
