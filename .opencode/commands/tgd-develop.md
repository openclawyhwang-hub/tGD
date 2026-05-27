---
description: Develop — implement one thin vertical slice at a time with feature flags
---

Run the `incremental-implementation` skill. This is the BUILD phase — the full pipeline is:

**Core flow:**
1. `context-engineering` — load the right spec sections and source files for the current task
2. `source-driven-development` — ground framework decisions in official docs, verify and cite
3. `incremental-implementation` — build thin vertical slices: implement → test → verify → commit
4. `test-driven-development` — Red-Green-Refactor, write tests alongside each slice

**Conditional (apply when relevant):**
- Touching UI? → `frontend-ui-engineering`
- Designing APIs? → `api-and-interface-design`
- High-stakes decision? → `doubt-driven-development`

Use feature flags for incomplete features, safe defaults, and rollback-friendly changes.