# Getting Started for Teams

This guide walks your team through setting up the Agentic-PDLC-Workflow from scratch.

## Prerequisites

- [ ] Git installed
- [ ] Jira account (or skip Jira integration)
- [ ] GitHub/GitLab/Bitbucket account
- [ ] AI coding agent (Claude Code, Cursor, etc.)

## Day 1: Setup (30 minutes)

### Step 1: Clone the Workflow

```bash
git clone https://github.com/openclawyhwang-hub/Agentic-PDLC-Workflow.git
cd Agentic-PDLC-Workflow
```

### Step 2: Install in Your AI Tool

**Claude Code:**
```
/plugin marketplace add addyosmani/agent-skills
/plugin install agent-skills@addy-agent-skills
```

**Cursor:** Copy `skills/` to `.cursor/rules/`

**Other tools:** See setup guides in `docs/`

### Step 3: Configure Environment Variables

Create a `.env` file:

```bash
# Jira (required for task automation)
JIRA_URL=https://your-domain.atlassian.net
JIRA_USER=you@company.com
JIRA_API_TOKEN=your-token
JIRA_PROJECT_KEY=PROJ
JIRA_AI_ACCOUNT_ID=your-ai-account-id

# Git Provider (required for PR creation)
GITHUB_TOKEN=ghp_your-token
# OR for GitLab:
# GITLAB_TOKEN=glpat_your-token
```

### Step 4: Test the Setup

```bash
# Test Jira connection
python scripts/fetch_todo_ticket.py

# Test Git connection
gh auth status
```

## Day 2: First Project (2 hours)

### Step 1: Define Your First Feature

```bash
/spec "Build a user login feature"
```

The agent will:
1. Ask clarifying questions
2. Write `SPEC.md`
3. Ask you to review and approve

### Step 2: Plan the Tasks

```bash
/plan
```

The agent will:
1. Read `SPEC.md`
2. Break it into atomic tasks
3. Create Jira tickets
4. Save `.planning/ROADMAP.md`

### Step 3: Build

```bash
/build
```

The agent will:
1. Fetch the first Jira ticket
2. Create a git worktree
3. Write tests (TDD)
4. Write code
5. Create a PR

### Step 4: Review

```bash
/review
```

The agent will:
1. Run code review (5-axis)
2. Run security audit
3. Run performance check
4. Post review comments on the PR

### Step 5: Ship

```bash
/ship
```

The agent will:
1. Run pre-launch checklist
2. Deploy to staging
3. Deploy to production (with your confirmation)

## Week 1: Team Onboarding

### Day 3-4: Add Team Members

1. Each team member installs the workflow in their AI tool
2. Each team member configures their environment variables
3. Test that each agent can fetch Jira tickets independently

### Day 5: First Multi-Agent Session

1. Assign 2-3 Jira tickets to different agents
2. Let each agent work in parallel
3. Review all PRs together
4. Merge and deploy

## Month 1: Scaling Up

### Week 2-3: Add Advanced Features

- [ ] Set up CI/CD pipeline (see `ci-cd-and-automation` skill)
- [ ] Configure notification channels (Telegram/Discord/Slack)
- [ ] Set up design system (see `design-system` skill)
- [ ] Create team-specific prompts

### Week 4: Review and Optimize

1. Review what worked and what didn't
2. Update team collaboration guidelines
3. Adjust team size configuration if needed
4. Document lessons learned

## Team Configuration Templates

### Solo Developer (1 person)

```yaml
team:
  size: 1
  roles:
    - name: Developer
      count: 1
  agents:
    count: 1
  jira:
    project: 1
    board: 1
```

### Small Team (2-5 people)

```yaml
team:
  size: 3
  roles:
    - name: Product Owner
      count: 1
    - name: Developer
      count: 2
  agents:
    count: 2
  jira:
    project: 1
    board: 1
  meetings:
    daily_standup: true
    weekly_review: true
```

### Medium Team (5-20 people)

```yaml
team:
  size: 10
  roles:
    - name: Product Owner
      count: 2
    - name: Tech Lead
      count: 1
    - name: Developer
      count: 7
  agents:
    count: 7
  jira:
    project: 1
    epics: true
  meetings:
    daily_standup: true
    weekly_architecture: true
    biweekly_retro: true
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Agent can't fetch Jira tickets | Check `JIRA_AI_ACCOUNT_ID` and ticket assignee |
| PR creation fails | Check `GITHUB_TOKEN` or `GITLAB_TOKEN` |
| Merge conflicts | Rebase on main, resolve, force-push |
| Agent stuck in loop | Check Bug ticket, fix root cause |
| Context inconsistent | Pull latest SPEC.md from main |

## Next Steps

- [Read Team Collaboration Guide](team-collaboration.md)
- [Read Environment Variables Reference](environment-variables.md)
- [Read Skill Anatomy Specification](skill-anatomy.md)
- [Read Contributing Guidelines](../CONTRIBUTING.md)
