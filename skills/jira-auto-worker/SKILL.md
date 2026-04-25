---
name: jira-auto-worker
description: Background worker that fetches a Jira ticket, works in an isolated git worktree, and pushes a PR.
---

# Isolated Jira Worker Workflow

## Process

1. **Fetch Task**: Execute `python scripts/fetch_todo_ticket.py`. Note the ID and AC. Stop if `NO_TICKETS_FOUND`.
2. **Worktree Isolation**:
   - `git fetch origin`
   - `git worktree add ../worker-[Ticket ID] -b feature/[Ticket ID] origin/main`
   - `cd ../worker-[Ticket ID]`
3. **Implementation**: Use `incremental-implementation` skill for Ruthless TDD.
   - *Self-Healing*: If tests fail 3 times, run `python ../[RepoName]/scripts/create_bug_ticket.py`, cleanup, and exit.
4. **Self-Review & Commit**: 
   - `git commit -m "feat: [Ticket ID] implemented AC"`
   - `git push -u origin feature/[Ticket ID]`
5. **Cleanup & Status**:
   - `cd` back to original repo.
   - `git worktree remove ../worker-[Ticket ID]`
   - `python scripts/transition_ticket.py --ticket [Ticket ID] --status "In Review"`

## Verification

Code is pushed to remote, worktree is deleted, and Jira status is updated.
