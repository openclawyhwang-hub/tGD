---
description: Develop — implement one thin vertical slice at a time
---

**🛑 Pre-flight: Environment Check**
- [ ] `tGD/map/CONTEXT.md` exists (or `.codegraph/` is present).
- **If missing:** STOP. Tell user: "Project context not mapped. Please run `/tgd-map` first."

**🔑 Step 0: Feature Name Resolution**
1. Scan `tGD/` for subdirectories (e.g., `tGD/user-login/`).
2. If none found: 🛑 STOP. "No features defined. Run `/tgd-define` first."
3. If exactly one found: Lock it as `<feature-name>`.
4. If multiple found: List them and ask user to specify.
5. **Verify**: Ensure all work targets `tGD/<feature-name>/`.

**🔒 Pre-flight: Artifact Check**
- [ ] `tGD/<feature-name>/TASKS.md` exists and is non-empty.
- [ ] `tGD/<feature-name>/PRD.md` exists and is non-empty.
- [ ] `tGD/<feature-name>/SPEC.md` exists and is non-empty.
- **If missing:** STOP. Tell user: "Specs are missing. Please run `/tgd-define` first."

Run the `incremental-implementation` skill. This is the BUILD phase. The full pipeline is:

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

After completing the implementation, verify the outputs.

**Verification Gate:**
- [ ] Source code files created/modified in `src/`
- [ ] Tests written AND passing for new logic in `tests/`

If verification passes, suggest the next step: `/tgd-verify` to prove it works.
