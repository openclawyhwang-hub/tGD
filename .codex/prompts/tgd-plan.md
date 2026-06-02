# /tgd-plan

Plan — decompose specs into atomic tasks with acceptance criteria

Run the planning-and-task-breakdown skill. This is the PLAN phase.

Pre-flight:
- Check tGD/map/CONTEXT.md exists. If missing, /tgd-map first.
- Scan tGD/ for feature subdirectories. If none, /tgd-define first.
- Check tGD/define/<feature-name>/PRD.md and SPEC.md exist. If missing, /tgd-define first.

Steps:
1. **Read `tGD/map/CONTEXT.md`**: Understand existing project structure.
2. **Read `tGD/define/<feature-name>/PRD.md`**: Understand business goals.
3. **Read `tGD/define/<feature-name>/SPEC.md`**: Analyze technical requirements.
4. Decompose into small, verifiable tasks with acceptance criteria.
5. Order by dependencies.
6. Write `tGD/plan/<feature-name>/TASKS.md`.
5. **Jira Gate** → ALWAYS ask the user if they want to sync to Jira.
   If yes → run `jira-auto-sync`.
     1. Ask for JIRA_URL, JIRA_PROJECT, JIRA_TOKEN.
     2. Discover Issue Types & Required Fields.
     3. Create issues via Jira REST API v2.
     4. Report created issue keys.
   If no → skip and proceed to verification.

Verification Gate:
- [ ] tGD/plan/<feature-name>/TASKS.md exists and is non-empty
- [ ] Each task has acceptance criteria

After completing, suggest: /tgd-develop to start building.
