---
description: Plan — decompose specs into small, verifiable tasks with acceptance criteria
---

Run the `planning-and-task-breakdown` skill. Decompose the specification into small, verifiable tasks with acceptance criteria and dependency ordering.

Each task should be implementable in isolation with clear success criteria. Order tasks by dependencies so they can be executed in the right sequence.

After completing the plan, verify the outputs.

**Verification Gate:**
- [ ] `tGD/<feature-name>/TASKS.md` exists and is non-empty
- [ ] TASKS.md contains at least one task with Acceptance Criteria

If verification passes, suggest the next step: `/tgd-develop` to start implementing the first slice.
