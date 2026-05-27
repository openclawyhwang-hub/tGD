---
description: Map — scan and understand the existing project context before making changes
---

Run the `context-engineering` skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.

This is the starting point for joining an existing project or before making significant changes. Do not start defining or building until you understand the current context.

**GitNexus Setup (Required for code intelligence):**
1. Install GitNexus from bundled tarball: `npm install -g ./tools/gitnexus-*.tgz`
   - Note: Dependencies (like `onnxruntime-node`, `express`, etc.) must be resolvable via your local npm cache or company nexus.
2. Initialize the project graph: `gitnexus analyze`
   - This indexes the codebase into a local knowledge graph.
   - Creates `.gitnexus/` directory (auto-synced, gitignored).

After completing the mapping, suggest the next step: `/tgd-define` to start defining what to build.
