---
name: planning-and-task-breakdown
description: Breaks down requirements into atomic tasks, estimates Story Points, and creates Jira tickets. Use when you have a spec and need implementable units.
---

# Task Breakdown & Jira Sync Workflow

## Process

1. **Analyze SPEC.md + DESIGN_SPEC.md**: Read the specifications, Acceptance Criteria, and design specifications.
2. **Atomic Breakdown**: Break the feature into vertical slices (max 2-4 hours of work each). Each task should reference relevant design sections.
3. **Estimate Points**: Assign Story Points (e.g., 1, 2, 3) to each atomic task.
4. **Draft ROADMAP.md**: Save the tasks locally to `.planning/ROADMAP.md`.
5. **Sync to Jira (Crucial Step)**: 
   - For EACH task generated, you MUST execute the bash command:
     ```bash
     python scripts/create_jira_ticket.py --title "[Task Title]" --desc "[AC details + design reference]" --points "[Points]"
     ```

## Verification

You succeed ONLY when `.planning/ROADMAP.md` is created AND the terminal confirms all tasks have been successfully pushed to Jira via the Python script. Each task should reference the relevant DESIGN_SPEC.md section for UI tasks.
