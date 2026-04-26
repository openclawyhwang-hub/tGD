# Team Collaboration Guide

This guide explains how multiple developers and AI agents can work together using the Agentic-PDLC-Workflow.

## Core Principles

1. **Single Source of Truth** — All context lives in the Git repo (SPEC.md, DESIGN_SPEC.md, CONTEXT.md)
2. **Isolated Work** — Each agent works in its own git worktree on a dedicated branch
3. **Jira as Task Router** — Jira tickets are assigned to specific agents; no two agents work on the same ticket
4. **Human Gatekeeper** — Humans approve specs, designs, PRs, and deployments

## Team Sizes and Configurations

### Small Team (1-5 people)

| Role | Count | Responsibilities |
|------|-------|-----------------|
| Product Owner | 1 | Approve SPEC.md, DESIGN_SPEC.md |
| Developer | 1-3 | Review PRs, handle edge cases |
| AI Agent | 1-2 | Write code, tests, docs |

**Configuration:**
- 1 Jira project
- 1 Git repo
- Each developer gets 1 AI agent
- Daily standup: review Jira board

### Medium Team (5-20 people)

| Role | Count | Responsibilities |
|------|-------|-----------------|
| Product Owner | 1-2 | Approve specs, prioritize backlog |
| Tech Lead | 1 | Architecture decisions, code review |
| Developers | 3-10 | Review PRs, handle complex tasks |
| AI Agents | 3-10 | Write code, tests, docs |

**Configuration:**
- 1 Jira project with epics for features
- 1 Git repo (or monorepo)
- Each developer gets 1 AI agent
- Weekly architecture review

### Large Team (20+ people)

| Role | Count | Responsibilities |
|------|-------|-----------------|
| Product Owners | 2-3 | Roadmap, stakeholder management |
| Tech Leads | 2-4 | Architecture, cross-team coordination |
| Developers | 10-20 | Review PRs, mentor juniors |
| AI Agents | 10-20 | Write code, tests, docs |

**Configuration:**
- Multiple Jira projects (one per team/subsystem)
- Monorepo or polyrepo
- Daily cross-team sync
- Bi-weekly architecture review

## Conflict Prevention

### Ticket Ownership

Each Jira ticket has exactly one assignee (human or AI agent). The `jira-auto-worker` skill enforces this:

```python
# fetch_todo_ticket.py checks:
if ticket.assignee != AI_AGENT_ID:
    skip  # Not your ticket
if ticket.status != "To Do":
    skip  # Already being worked on
```

**Rule:** Never pick up a ticket assigned to someone else. If you need to take over, reassign in Jira first.

### Worktree Isolation

Each agent works in a separate git worktree:

```
main-repo/
worker-TICKET-123/    # Agent A works here (branch: feature/TICKET-123)
worker-TICKET-456/    # Agent B works here (branch: feature/TICKET-456)
```

**Rule:** Each worktree has its own branch. No two agents share a branch.

### Merge Conflicts

When two PRs touch the same file, GitHub/GitLab will show a merge conflict:

1. **Prevention:** Use small, atomic PRs (~100 lines) to minimize overlap
2. **Resolution:** The second PR to be merged must rebase on main and resolve conflicts
3. **Agent behavior:** If an agent encounters unresolvable conflicts, it creates a Bug ticket and stops

## Permission Matrix

| Action | Who Can Do It |
|--------|--------------|
| Write/Update SPEC.md | Product Owner + AI Agent |
| Approve SPEC.md | Product Owner (human) |
| Write/Update DESIGN_SPEC.md | AI Agent (design-system skill) |
| Approve Design | Product Owner or Designer (human) |
| Create Jira Tickets | AI Agent (planning-and-task-breakdown) |
| Write Code | AI Agent (jira-auto-worker) |
| Review PR | AI Agent (code-review-and-quality) + Human |
| Approve PR | Human (Tech Lead or assigned reviewer) |
| Deploy to Staging | AI Agent (shipping-and-launch) |
| Deploy to Production | Human (with AI assistance) |
| Rollback | Anyone (preferably Tech Lead) |

## Workflow for Multiple Agents

### Scenario: 3 Agents Building a Feature

```
Agent A (TICKET-123: User Model)          Agent B (TICKET-456: Auth API)
        │                                          │
        ▼                                          ▼
  git worktree add                          git worktree add
  ../worker-123                             ../worker-456
  -b feature/TICKET-123                     -b feature/TICKET-456
  origin/main                               origin/main
        │                                          │
        ▼                                          ▼
  TDD: write test                         TDD: write test
  → write code                            → write code
  → commit                                → commit
  → push                                  → push
        │                                          │
        ▼                                          ▼
  PR #1 (feature/TICKET-123)              PR #2 (feature/TICKET-456)
        │                                          │
        └──────────────┬──────────────────────────┘
                       ▼
              Human reviews both PRs
                       │
                       ▼
              Merge PR #1 first (no conflict)
                       │
                       ▼
              Rebase PR #2 on main
              (resolve any conflicts)
                       │
                       ▼
              Merge PR #2
```

### Scenario: Agent Fails 3 Times

```
Agent working on TICKET-789
        │
        ▼
  Test fails → retry
  Test fails → retry
  Test fails → retry
        │
        ▼
  Create Bug ticket (TICKET-999)
  with error log attached
        │
        ▼
  TICKET-789 → Status: "Blocked"
  Agent cleans up worktree
        │
        ▼
  Human investigates Bug ticket
  Fixes root cause
  Unblocks TICKET-789
  Agent resumes work
```

## Communication Patterns

### Jira Comments

Use Jira comments for:
- Task status updates
- Blocker notifications
- Design questions
- Implementation notes

### Git PR Comments

Use PR comments for:
- Code review feedback
- Architecture discussions
- Test results

### External Channels (Optional)

Configure notifications for:
- **Telegram/Discord/Slack:** PR created, PR approved, deployment complete
- **Email:** Bug tickets, blocked tasks

## Best Practices

1. **Small PRs** — Keep PRs under 100 lines for faster review
2. **Atomic Commits** — One logical change per commit
3. **Descriptive Branch Names** — `feature/TICKET-123-user-model` not `feature/branch1`
4. **Regular Rebasing** — Rebase on main at least once per day
5. **Update Jira** — Keep ticket status in sync with actual progress
6. **Document Decisions** — Use ADRs for architectural choices
7. **Test Coverage** — Maintain >80% coverage; agents write tests first (TDD)

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Two agents picked same ticket | Check Jira assignee; reassign one agent |
| Merge conflict in PR | Rebase on main, resolve, force-push |
| Agent stuck in loop | Check Bug ticket; fix root cause |
| PR review taking too long | Escalate to human reviewer |
| Context不一致 | Pull latest SPEC.md/DESIGN_SPEC.md from main |
