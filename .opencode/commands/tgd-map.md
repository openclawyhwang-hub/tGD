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
   - *Requires CodeGraph installed (`pip install codegraph-cli`). Setup handles this automatically.*

**Outputs:**
- `CONTEXT.md` — saved to `tGD/map/CONTEXT.md`
- `.codegraph/codegraph.db` — stored at `tGD/map/.codegraph/codegraph.db` (via symlink)

After completing the mapping, verify the outputs.

**Verification Gate:**
- [ ] `tGD/map/CONTEXT.md` exists and is non-empty
- [ ] `tGD/map/.codegraph` symlink exists

If verification passes, suggest the next step: `/tgd-define` to start defining what to build.
