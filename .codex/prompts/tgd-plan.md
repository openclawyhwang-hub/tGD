# /tgd-plan

Plan — decompose specs into atomic tasks with acceptance criteria

Run the planning-and-task-breakdown skill. This is the PLAN phase.

Pre-flight:
- Check tGD/map/CONTEXT.md exists. If missing, /tgd-map first.
- Scan tGD/ for feature subdirectories. If none, /tgd-define first.
- Check tGD/<feature>/PRD.md and SPEC.md exist. If missing, /tgd-define first.

Steps:
1. Read PRD.md and SPEC.md
2. Decompose into small, verifiable tasks with acceptance criteria
3. Order by dependencies
4. Write tGD/<feature>/TASKS.md
5. If jira-auto-sync available, sync to Jira

Verification Gate:
- [ ] tGD/<feature>/TASKS.md exists and is non-empty
- [ ] Each task has acceptance criteria

After completing, suggest: /tgd-develop to start building.
