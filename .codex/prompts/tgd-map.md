# /tgd-map

Map — scan and understand the existing project context before making changes

Run the context-engineering skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.

1. Ensure output directory exists: mkdir -p tGD/map
2. Create symlink: rm -rf .codegraph && ln -s tGD/map/.codegraph .codegraph
3. Initialize project graph: codegraph init -i

**Understand-Anything (deep knowledge graph):**
1. Run `/understand` to build a full knowledge graph of the codebase
2. Produces `.understand-anything/knowledge-graph.json` — interactive map of all components and dependencies
3. If unfamiliar, also run `/understand-onboard` for a guided tour

Outputs:
- tGD/map/CONTEXT.md
- tGD/map/.codegraph/codegraph.db
- .understand-anything/knowledge-graph.json (knowledge graph)
- .understand-anything/config.json (UA config)

Verification Gate:
- [ ] tGD/map/CONTEXT.md exists and is non-empty
- [ ] tGD/map/.codegraph symlink exists
- [ ] .understand-anything/knowledge-graph.json exists (if /understand was run)

If verification passes, suggest: /tgd-define to start defining what to build.
