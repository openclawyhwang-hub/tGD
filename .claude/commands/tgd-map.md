---
description: Map — scan and understand the existing project context before making changes
---

Run the `context-engineering` skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.

This is the starting point for joining an existing project or before making significant changes.

**CodeGraph Setup (Zero-dependency, offline):**
1. Extract bundled binary: `tar -xzf tools/codegraph-linux-x64.tar.gz -C tools/`
2. Initialize the project graph: `./tools/codegraph-linux-x64/codegraph init -i`

After completing the mapping, suggest the next step: `/tgd-define` to start defining what to build.
