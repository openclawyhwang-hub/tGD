---
description: Develop — implement with fresh subagents per task and two-stage review
---

**🛑 Pre-flight: Environment Check**
- [ ] `tGD/map/CONTEXT.md` exists (or `.codegraph/` is present).
- **If missing:** STOP. Tell user: "Project context not mapped. Please run `/tgd-map` first."

**🔑 Step 0: Feature Name Resolution**
1. Scan `tGD/` for subdirectories (e.g., `tGD/user-login/`).
2. If none found: 🛑 STOP. "No features defined. Run `/tgd-define` first."
3. If exactly one found: Lock it as `<feature-name>`.
4. If multiple found: List them and ask user to specify.
5. **Verify**: `tGD/define/<feature-name>/SPEC.md` exists (defines scope).

**🔒 Pre-flight: Artifact Check**
- [ ] `tGD/plan/<feature-name>/TASKS.md` exists and is non-empty.
- [ ] `tGD/define/<feature-name>/PRD.md` exists and is non-empty.
- [ ] `tGD/define/<feature-name>/SPEC.md` exists and is non-empty.
- **If missing:** STOP. Tell user: "Specs are missing. Please run `/tgd-define` first."

This is the BUILD phase. The pipeline operates in an isolated environment.

**🌳 Step 1: Worktree Isolation (Mandatory)**
Before writing any code, create an isolated workspace. This keeps `tGD/` artifacts safe and prevents code mess from polluting the planning directory.
1. **Create**: `git worktree add ../project-<feature-name> feature/<feature-name>`
2. **Action**: All coding, testing, and commits MUST happen inside `../project-<feature-name>/`.

**⚡ Step 2: Execution Mode Routing**
Check the number of tasks in `TASKS.md`:
- **< 3 tasks** (Simple/Fast): `incremental-implementation`. The main agent switches to the worktree directory and implements directly.
- **≥ 3 tasks** (Complex/Quality): `subagent-driven-development`. Dispatch subagents to implement and review within the worktree directory.

**Core flow (both modes):**
1. `context-engineering` — load the right spec sections and source files for the current task
2. `source-driven-development` — ground framework decisions in official docs, verify and cite
3. `subagent-driven-development` OR `incremental-implementation` — execute tasks in worktree
4. `test-driven-development` — Red-Green-Refactor, write tests alongside each task
5. `verification-before-completion` — evidence before claims, no exceptions

**🧹 Step 3: Cleanup**
After all tasks pass verification:
1. Return to the main project directory.
2. Merge `feature/<feature-name>` back to `main`.
3. Remove the worktree: `git worktree remove ../project-<feature-name>`.

**Conditional (apply when relevant):**
- Touching UI? → `frontend-ui-engineering`
- Designing APIs? → `api-and-interface-design`
- High-stakes decision? → `doubt-driven-development`

Use feature flags for incomplete features, safe defaults, and rollback-friendly changes.

**Do not pause between tasks.** Execute all tasks from the plan without stopping unless BLOCKED.

After completing the implementation, verify the outputs.

**Verification Gate:**
- [ ] Source code files created/modified in `src/`
- [ ] Tests written AND passing for new logic in `tests/`
- [ ] Verification commands run and output confirmed (no "should work")

If verification passes, suggest the next step: `/tgd-verify` to prove it works.
