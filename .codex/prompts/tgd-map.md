# /tgd-map

Map — scan and understand the existing project context before making changes

Run the context-engineering skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.

1. Ensure output directory exists: mkdir -p tGD/map
2. Create symlink: rm -rf .codegraph && ln -s tGD/map/.codegraph .codegraph
3. Initialize project graph: codegraph init -i

Outputs:
- tGD/map/CONTEXT.md
- tGD/map/.codegraph/codegraph.db

Verification Gate:
- [ ] tGD/map/CONTEXT.md exists and is non-empty
- [ ] tGD/map/.codegraph symlink exists

If verification passes, suggest: /tgd-define to start defining what to build.
