---
description: Analyze codebase and generate context map for existing projects
---

Invoke the agent-skills:context-mapping skill.

Scan the repository structure, dependencies, and architecture. Then:

1. Run `tree -L 3` and read package.json/pyproject.toml/go.mod
2. Map key entities and module boundaries
3. Identify constraints and injection points
4. Generate `.planning/CONTEXT.md`

Save the context map to `.planning/CONTEXT.md`.