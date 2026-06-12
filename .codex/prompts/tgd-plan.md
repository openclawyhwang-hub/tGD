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
7. **🔗 Jira Integration Gate** → IMMEDIATELY after TASKS.md is written. Do NOT skip.
   - Check env vars: `JIRA_URL`, `JIRA_PROJECT`, `JIRA_TOKEN`.
   - **If ALL configured:** Run `jira-auto-sync` automatically. Parse TASKS.md, create issues, report keys, add `[ENG-1234]` to TASKS.md.
   - **If NOT configured:** Ask conversationally:
     ```
     📋 TASKS.md 已完成（N 個任務）。
     🔗 要同步到 Jira 嗡？(y/n)
     ```
     - Yes → ask for JIRA_URL, JIRA_PROJECT, JIRA_TOKEN one at a time. Save to `$TGD_DIR/.env`. Then run `jira-auto-sync`.
     - No → skip, proceed to verification.

Verification Gate:
- [ ] $TGD_DIR/<feature-name>/TASKS.md exists and is non-empty
- [ ] Each task has acceptance criteria

After completing, suggest: /tgd-develop to start building.
