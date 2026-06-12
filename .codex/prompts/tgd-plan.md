# /tgd-plan

Plan — decompose specs into atomic tasks with acceptance criteria

Run the planning-and-task-breakdown skill. This is the PLAN phase.

Pre-flight:
- Check $TGD_DIR/CONTEXT.md exists. If missing, /tgd-map first.
- Scan tGD/ for feature subdirectories. If none, /tgd-define first.
- Check $TGD_DIR/<feature-name>/PRD.md and SPEC.md exist. If missing, /tgd-define first.

Steps:
1. **Read `$TGD_DIR/CONTEXT.md`**: Understand existing project structure.
2. **Read `$TGD_DIR/<feature-name>/PRD.md`**: Understand business goals.
3. **Read `$TGD_DIR/<feature-name>/SPEC.md`**: Analyze technical requirements.
4. Decompose into small, verifiable tasks with acceptance criteria.
5. Order by dependencies.
6. Write `$TGD_DIR/<feature-name>/TASKS.md`.
7. **🔗 Jira Integration Gate** → IMMEDIATELY after TASKS.md is written (before verification):
   - Check env vars: `JIRA_URL`, `JIRA_PROJECT`, `JIRA_TOKEN`.
   - **If ALL configured:** Run `jira-auto-sync` **automatically**. Do NOT ask, do NOT skip.
     1. Discover Issue Types & Required Fields.
     2. Create issues via Jira REST API v2.
     3. Report created issue keys.
     4. Add issue keys to TASKS.md tasks as `[ENG-1234]`.
   - **If NOT configured:** 🛑 STOP. "Jira is not configured. Set `JIRA_URL`, `JIRA_PROJECT`, `JIRA_TOKEN` env vars, then re-run `/tgd-plan`."
     - **Do NOT proceed to verification until Jira is synced or user sets `TGD_SKIP_JIRA=1`**

Verification Gate:
- [ ] $TGD_DIR/<feature-name>/TASKS.md exists and is non-empty
- [ ] Each task has acceptance criteria

After completing, suggest: /tgd-develop to start building.
