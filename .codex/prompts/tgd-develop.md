# /tgd-develop

Build — implement with isolated worktree and task-based execution mode.

**🛑 Pre-flight: Environment Check**
- [ ] `$TGD_DIR/CONTEXT.md` exists (or `.codegraph/` is present).
- **If missing:** STOP. Tell user: "Project context not mapped. Please run `/tgd-map` first."
- **$TGD_DIR:** Resolve via `tGD/` symlink in project root. If missing, check `$TGD_DIR` env var. If neither exists: STOP — run `/tgd-map` first.

Run the subagent-driven-development or incremental-implementation skill. This is the BUILD phase.

**🌳 Step 1: Worktree Isolation (Mandatory)**
1. Create: `git worktree add ../project-<feature-name> feature/<feature-name>`
2. Action: All coding/testing MUST happen inside `../project-<feature-name>/`.

**⚡ Step 2: Execution Mode Routing**
- **< 3 tasks**: `incremental-implementation` (Main agent implements directly in worktree).
- **≥ 3 tasks**: `subagent-driven-development` (Subagents implement and review in worktree).

Core flow:
1. `context-engineering` — load spec/context
2. `source-driven-development` — ground decisions in docs
3. Implement tasks in worktree
4. `test-driven-development` — write tests
5. `verification-before-completion` — run tests, show output

**🧹 Step 3: Cleanup**
1. Return to main project directory.
2. Merge `feature/<feature-name>` to `main`.
3. Remove worktree: `git worktree remove ../project-<feature-name>`.

Conditional:
- Frontend? -> frontend-ui-engineering
- API? -> api-and-interface-design
- High stakes? -> doubt-driven-development

One slice at a time. Never implement multiple tasks at once.

After completing, suggest: /tgd-verify to prove it works.
