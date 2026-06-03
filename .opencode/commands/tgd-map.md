---
description: Map — scan and understand the existing project context before making changes
---

Run the `context-engineering` skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.

This is the starting point for joining an existing project or before making significant changes. Do not start defining or building until you understand the current context.

**CodeGraph Setup (Zero-dependency, offline):**
1. Ensure output directory exists: `mkdir -p tGD/map`
2. Create symlink so CodeGraph finds its DB at the expected root path:
   ```bash
   rm -rf .codegraph  # remove stale link if any
   ln -s tGD/map/.codegraph .codegraph
   ```
3. Initialize the project graph:
   `codegraph init -i`
   - *Requires CodeGraph installed. Setup handles this automatically.*

**Understand-Anything (deep knowledge graph + interactive dashboard):**
1. Create symlink so UA stores output in tGD/map:
   ```bash
   rm -rf .understand-anything  # remove stale link if any
   ln -s tGD/map/.understand-anything .understand-anything
   ```
2. Run `/understand` to build a full knowledge graph of the codebase
3. This produces `tGD/map/.understand-anything/knowledge-graph.json` — an interactive map of all components, dependencies, and relationships
4. After graph is built, run `/understand-dashboard` to launch an interactive web visualization (Vite dev server) for exploring the architecture visually
5. If unfamiliar with the project, also run `/understand-onboard` for a guided architecture tour

**Outputs (all under `tGD/map/`):**
- `CONTEXT.md` — project structure analysis (MUST reference CodeGraph/UA data)
- `.codegraph/codegraph.db` — symbol index (via symlink)
- `.understand-anything/knowledge-graph.json` — full knowledge graph (via symlink)
- `.understand-anything/config.json` — UA configuration
- **Interactive dashboard** — launched via `/understand-dashboard` (reads knowledge-graph.json, serves on localhost)

**CONTEXT.md Structure:**
When writing `CONTEXT.md`, DO NOT rely solely on visual inspection of code. 
Synthesize data from the tools:
- **Project Map:** Use UA's knowledge graph to list core modules, layers, and dependencies accurately.
- **Code Entry Points:** Reference CodeGraph entry points for main execution paths.
- **Business Logic:** If `/understand-domain` was run, include a summary of business-to-code mappings.
- **Interactive Links:** At the end of `CONTEXT.md`, add a "See Also" section linking to the local Dashboard URL.

After completing the mapping, verify the outputs.

**Verification Gate:**
- [ ] `tGD/map/CONTEXT.md` exists and is non-empty
- [ ] `tGD/map/.codegraph` symlink exists
- [ ] `tGD/map/.understand-anything` symlink exists (if `/understand` was run)
- [ ] `tGD/map/.understand-anything/knowledge-graph.json` exists

If verification passes, suggest the next step: `/tgd-define` to start defining what to build.
