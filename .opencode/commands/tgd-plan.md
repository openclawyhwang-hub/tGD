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
- [ ] `tGD/<feature-name>/PRD.md` exists and is non-empty.
- [ ] `tGD/<feature-name>/SPEC.md` exists and is non-empty.
- **If missing:** STOP. Tell user: "Specs are missing. Please run `/tgd-define` first."


description: Plan — decompose specs into small, verifiable tasks with acceptance criteria
---

Run the `planning-and-task-breakdown` skill. Decompose the specification into small, verifiable tasks with acceptance criteria and dependency ordering.

Each task should be implementable in isolation with clear success criteria. Order tasks by dependencies so they can be executed in the right sequence.

After completing the plan, verify the outputs.

**Verification Gate:**
- [ ] `tGD/<feature-name>/TASKS.md` exists and is non-empty
- [ ] TASKS.md contains at least one task with Acceptance Criteria

If verification passes, suggest the next step: `/tgd-develop` to start implementing the first slice.
