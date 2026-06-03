# /tgd-map

Map — scan and understand the existing project context before making changes

Run the context-engineering skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.

1. Ensure output directory exists: mkdir -p tGD/map
2. Create symlink: rm -rf .codegraph && ln -s tGD/map/.codegraph .codegraph
3. Initialize project graph: codegraph init -i

**Understand-Anything (deep knowledge graph + interactive dashboard):**
1. Create symlink: rm -rf .understand-anything && ln -s tGD/map/.understand-anything .understand-anything
2. Run `/understand` to build a full knowledge graph
3. Produces `tGD/map/.understand-anything/knowledge-graph.json`
4. Run `/understand-dashboard` to launch interactive web visualization (Vite dev server)
5. If unfamiliar, also run `/understand-onboard` for a guided tour

Outputs (all under tGD/map/):
- CONTEXT.md — project structure analysis
- .codegraph/codegraph.db — symbol index (via symlink)
- .understand-anything/knowledge-graph.json — knowledge graph (via symlink)
- .understand-anything/config.json — UA config
- Interactive dashboard — launched via /understand-dashboard (localhost)

Verification Gate:
- [ ] tGD/map/CONTEXT.md exists and is non-empty
- [ ] tGD/map/.codegraph symlink exists
- [ ] tGD/map/.understand-anything symlink exists (if /understand was run)
- [ ] tGD/map/.understand-anything/knowledge-graph.json exists

If verification passes, suggest: /tgd-define to start defining what to build.
