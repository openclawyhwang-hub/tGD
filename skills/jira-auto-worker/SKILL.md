---
name: jira-auto-worker
description: Background worker that fetches a Jira ticket, works in an isolated git worktree, and pushes a PR. Use when automating development workflow with Jira integration.
---

# Isolated Jira Worker Workflow

## Process

1. **Fetch Task**: Execute `python scripts/fetch_todo_ticket.py`. Note the ID and AC. Stop if `NO_TICKETS_FOUND`.
   - **Verify ownership**: Check that the ticket is still assigned to the AI agent and status is "To Do". If changed, skip and fetch next.
2. **Context Check**: If `.planning/CONTEXT.md` exists, read it before implementing. Respect all constraints (backward compatibility, forbidden modifications, injection points). If context is missing or stale (>30 days), flag for refresh before proceeding.
3. **Worktree Isolation**:
   - `git fetch origin`
   - Check for conflicts: `git merge-base --is-ancestor origin/main HEAD` (if false, rebase first)
   - `git worktree add ../worker-[Ticket ID] -b feature/[Ticket ID] origin/main`
   - `cd ../worker-[Ticket ID]`
   - **Handle conflicts**: If `git push` fails due to conflicts, run `git rebase origin/main`, resolve, and force-push. If unresolvable, abort and flag for human review.
4. **Implementation**: Use `incremental-implementation` skill for Ruthless TDD.
   - *Self-Healing*: If tests fail 3 times:
     - Run `python ../[RepoName]/scripts/create_bug_ticket.py --title "[Ticket ID] Test failures after 3 retries" --log "$(cat test-output.log 2>/dev/null || echo 'No log available')"`
     - Run `python ../[RepoName]/scripts/transition_ticket.py --ticket [Ticket ID] --status "Blocked"`
     - Cleanup worktree and exit with non-zero code.
     - **Do not proceed to PR creation.**
5. **Self-Review & Commit**: 
   - `git commit -m "feat: [Ticket ID] implemented AC"`
   - `git push -u origin feature/[Ticket ID]`
   - **Create PR**: `gh pr create --title "feat: [Ticket ID] implemented AC" --body "Automated PR from jira-auto-worker.\n\nJira: [Ticket ID]\n\nCloses [Ticket ID]" --base main`
6. **Cleanup & Status**:
   - `cd` back to original repo.
   - `git worktree remove ../worker-[Ticket ID]`
   - `python scripts/transition_ticket.py --ticket [Ticket ID] --status "In Review"`
   - **Verify transition**: Check exit code; if non-zero, log error and alert.
7. **Notification** (Optional but recommended):
   - Send completion message via configured channel (Telegram/Discord/Slack).
   - Include: Ticket ID, PR URL, test results summary.

## Verification

Code is pushed to remote, worktree is deleted, and Jira status is updated.
