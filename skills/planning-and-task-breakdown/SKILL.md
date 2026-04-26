---
name: planning-and-task-breakdown
description: Breaks down requirements into atomic tasks, estimates Story Points, and creates Jira tickets. Use when you have a spec and need implementable units.
---

# Task Breakdown & Jira Sync Workflow

## Process

1. **Analyze SPEC.md + DESIGN_SPEC.md + design-tokens.md**: Read the specifications, Acceptance Criteria, design specifications, and design tokens.
2. **Atomic Breakdown**: Break the feature into vertical slices (max 2-4 hours of work each). Each UI task should reference the relevant design-tokens.md and DESIGN_SPEC.md sections.
3. **Estimate Points**: Assign Story Points (e.g., 1, 2, 3) to each atomic task.
4. **Draft ROADMAP.md**: Save the tasks locally to `.planning/ROADMAP.md`.
5. **Sync to Jira (Crucial Step)**: 
   - For EACH task generated, you MUST execute the bash command:
     ```bash
     python scripts/create_jira_ticket.py --title "[Task Title]" --desc "[AC details + design reference]" --points "[Points]"
     ```

## Verification

You succeed ONLY when `.planning/ROADMAP.md` is created AND the terminal confirms all tasks have been successfully pushed to Jira via the Python script. Each UI task should reference DESIGN_SPEC.md and design-tokens.md in its acceptance criteria.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Skip Jira sync, just write ROADMAP.md" | Without Jira tickets, agents can't fetch and execute tasks. ROADMAP.md alone is useless for automation. |
| "Make tasks too big (8+ hours)" | Large tasks are harder to review, test, and rollback. Keep them at 2-4 hours max. |
| "Skip design reference in UI tasks" | Without design references, developers won't know which tokens to use. Inconsistent UI results. |
| "Estimate all tasks as 1 SP" | Underestimating hides complexity. Be honest — if it's complex, give it 3 SP. |
| "Skip human approval of ROADMAP.md" | Without human approval, tasks might miss requirements or have wrong priorities. Always confirm. |
