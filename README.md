# Agentic PDLC Workflow

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Skills](https://img.shields.io/badge/Skills-28-orange.svg)](#all-28-skills)
[![Commands](https://img.shields.io/badge/Commands-8-blue.svg)](#commands)
[![Status](https://img.shields.io/badge/Status-Active-brightgreen.svg)]()

**Production-grade engineering skills with Jira integration for AI coding agents.**

> 🚀 28 skills • 8 commands • 7 development phases • Multi-agent support

## Table of Contents

- [What This Is](#what-this-is)
- [Workflow Overview](#workflow-overview)
  - [Phase Flow](#phase-flow)
  - [Phase Details](#phase-details)
- [Commands](#commands)
- [Quick Start](#quick-start)
- [All 28 Skills](#all-28-skills)
- [Agent Personas](#agent-personas)
- [Reference Checklists](#reference-checklists)
- [Project Structure](#project-structure)
- [Why Agent Skills?](#why-agent-skills)
- [How Skills Work](#how-skills-work)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

## What This Is

A complete development workflow that guides AI agents through every phase — from understanding requirements to deploying to production. Each phase has clear inputs, outputs, and quality gates so agents don't skip critical steps.

---

## Workflow Overview

### Phase Flow

```
📍 CONTEXT ──▶ 🎯 DEFINE ──▶ 📋 PLAN ──▶ 🔨 BUILD ──▶ ✅ VERIFY ──▶ 🔍 REVIEW ──▶ 🚀 SHIP
   │              │              │            │            │              │              │
   ▼              ▼              ▼            ▼            ▼              ▼              ▼
Brownfield    Spec         Tasks        Code         Tests        PR           Deploy
Discovery     PRD+Design   Jira         Feature      Proof        Review       Release
```

### Phase Details

| Phase | Trigger | Who | Skills | Input | Output | Gate |
|-------|---------|-----|--------|-------|--------|------|
| **📍 CONTEXT**<br><small>Existing Projects Only</small> | `/map` | 👤 Human runs `/map` → 🤖 Agent analyzes | `context-mapping` | Existing codebase | `.planning/CONTEXT.md` — Architecture summary, key entities, constraints | Context file must exist before DEFINE |
| **🎯 DEFINE** | `/spec` | 👤 Human provides idea → 🤖 Agent writes spec | `idea-refine`, `spec-driven-development`, `rapid-prototyping` | Vague idea or feature request | `SPEC.md` — Product requirements, objectives, commands, structure, code style, testing, boundaries | 👤 Human reviews and approves. If UI needed → `design-system` triggers: Figma → Jira review → DESIGN_SPEC.md |
| **📋 PLAN** | `/plan` | 🤖 Agent breaks down → 👤 Human approves | `planning-and-task-breakdown`, `jira-auto-worker` | `SPEC.md` + `DESIGN_SPEC.md` (if UI) + `design-tokens.md` (if UI) + `.planning/CONTEXT.md` (if exists) | Jira tickets with acceptance criteria, dependency ordering, story points | 👤 Human approves task breakdown |
| **🔨 BUILD** | `/build` | 🤖 Agent implements (fully automated) | `incremental-implementation`, `test-driven-development`, `context-engineering`, `source-driven-development`, `frontend-ui-engineering`, `api-and-interface-design` | Jira ticket + context map | Feature branch with implementation, unit tests, and commit | Tests pass, code compiles, feature works |
| **✅ VERIFY** | `/test` | 🤖 Agent tests (fully automated) | `browser-testing-with-devtools`, `debugging-and-error-recovery` | Feature branch | Test results, browser runtime data, debugging logs | All tests pass, no runtime errors |
| **🔍 REVIEW** | `/review` | 🤖 CI auto-review → 🤖 AI five-axis review → 👤 Human approves | `code-review-and-quality`, `code-simplification`, `security-and-hardening`, `performance-optimization`, `ci-pr-reviewer` | Pull request | Review comments, security scan, performance analysis | Five-axis review passes → 👤 Human approves PR |
| **🚀 SHIP** | `/ship` | 🤖 Agent deploys → 👤 Human monitors | `git-workflow-and-versioning`, `ci-cd-and-automation`, `deprecation-and-migration`, `documentation-and-adrs`, `shipping-and-launch` | Approved PR | Production deployment, ADRs, monitoring setup, rollback plan | Pre-launch checklist complete, feature flags configured, 👤 Human confirms deployment |

---

## Commands

8 slash commands that map to the development lifecycle. Each one activates the right skills automatically.

| What you're doing | Command | Key principle |
|-------------------|---------|---------------|
| Map existing codebase | `/map` | Understand before acting |
| Define what to build | `/spec` | Spec before code (includes design if UI needed) |
| Plan how to build it | `/plan` | Small, atomic tasks |
| Build incrementally | `/build` | One slice at a time |
| Prove it works | `/test` | Tests are proof |
| Review before merge | `/review` | Improve code health |
| Simplify the code | `/code-simplify` | Clarity over cleverness |
| Ship to production | `/ship` | Faster is safer |

Skills also activate automatically based on what you're doing — designing an API triggers `api-and-interface-design`, building UI triggers `frontend-ui-engineering`, and so on.

---

## Quick Start

<details>
<summary><b>Claude Code (recommended)</b></summary>

**Local / development:**

```bash
git clone https://github.com/openclawyhwang-hub/Agentic-PDLC-Workflow.git
claude --plugin-dir /path/to/Agentic-PDLC-Workflow
```

</details>

<details>
<summary><b>Cursor</b></summary>
Copy any `SKILL.md` into `.cursor/rules/`, or reference the full `skills/` directory. See [docs/cursor-setup.md](docs/cursor-setup.md).
</details>

<details>
<summary><b>Gemini CLI</b></summary>
Install as native skills for auto-discovery, or add to `GEMINI.md` for persistent context. See [docs/gemini-cli-setup.md](docs/gemini-cli-setup.md).
</details>

<details>
<summary><b>Windsurf</b></summary>
Add skill contents to your Windsurf rules configuration. See [docs/windsurf-setup.md](docs/windsurf-setup.md).
</details>

<details>
<summary><b>OpenCode</b></summary>
Uses agent-driven skill execution via AGENTS.md and the `skill` tool. See [docs/opencode-setup.md](docs/opencode-setup.md).
</details>

<details>
<summary><b>GitHub Copilot</b></summary>
Use agent definitions from `agents/` as Copilot personas and skill content in `.github/copilot-instructions.md`. See [docs/copilot-setup.md](docs/copilot-setup.md).
</details>

<details>
  <summary><b>Kiro IDE & CLI</b></summary>
  Skills for Kiro reside under ".kiro/skills/" and can be stored under Project or Global level. Kiro also supports Agents.md. See Kiro docs at https://kiro.dev/docs/skills/
</details>

<details>
<summary><b>Codex / Other Agents</b></summary>
Skills are plain Markdown - they work with any agent that accepts system prompts or instruction files. See [docs/getting-started.md](docs/getting-started.md).
</details>

---

## All 26 Skills

The commands above are the entry points. Under the hood, they activate these 26 skills — each one a structured workflow with steps, verification gates, and anti-rationalization tables. You can also reference any skill directly.

### Define - Clarify what to build

| Skill | What It Does | Use When |
|-------|-------------|----------|
| [idea-refine](skills/idea-refine/SKILL.md) | Structured divergent/convergent thinking to turn vague ideas into concrete proposals | You have a rough concept that needs exploration |
| [spec-driven-development](skills/spec-driven-development/SKILL.md) | Write a PRD covering objectives, commands, structure, code style, testing, and boundaries before any code | Starting a new project, feature, or significant change |
| [rapid-prototyping](skills/rapid-prototyping/SKILL.md) | Generates throwaway HTML/JS prototypes to visualize concepts before writing the spec | Need to explore UI concepts before spec |

### Design - Visual designs before tasks

| Skill | What It Does | Use When |
|-------|-------------|----------|
| [design-system](skills/design-system/SKILL.md) | Generates UI designs from specs, manages human review workflow via Jira tickets | You have an approved spec and need visual designs before implementation |
| [figma-generate-design](skills/figma-generate-design/SKILL.md) | Build/update screens in Figma using design system components, variables, and styles | You have Figma MCP connected and need Figma designs |
| [figma-use](skills/figma-use/SKILL.md) | Core Figma MCP operations, component patterns, variable bindings | You need to write to Figma files (dependency for figma-generate-design) |

### Plan - Break it down

| Skill | What It Does | Use When |
|-------|-------------|----------|
| [planning-and-task-breakdown](skills/planning-and-task-breakdown/SKILL.md) | Decompose specs into small, verifiable tasks with acceptance criteria and dependency ordering | You have a spec + design spec and need implementable units |
| [jira-auto-worker](skills/jira-auto-worker/SKILL.md) | Background worker that fetches Jira tickets, works in isolated git worktree, pushes PR | Automating development workflow |
| [context-mapping](skills/context-mapping/SKILL.md) | Analyzes codebase to build context map, essential for Brownfield projects | Starting work on existing codebase |

### Build - Write the code

| Skill | What It Does | Use When |
|-------|-------------|----------|
| [incremental-implementation](skills/incremental-implementation/SKILL.md) | Thin vertical slices - implement, test, verify, commit. Feature flags, safe defaults, rollback-friendly changes | Any change touching more than one file |
| [test-driven-development](skills/test-driven-development/SKILL.md) | Red-Green-Refactor, test pyramid (80/15/5), test sizes, DAMP over DRY, Beyonce Rule, browser testing | Implementing logic, fixing bugs, or changing behavior |
| [context-engineering](skills/context-engineering/SKILL.md) | Feed agents the right information at the right time - rules files, context packing, MCP integrations | Starting a session, switching tasks, or when output quality drops |
| [source-driven-development](skills/source-driven-development/SKILL.md) | Ground every framework decision in official documentation - verify, cite sources, flag what's unverified | You want authoritative, source-cited code for any framework or library |
| [frontend-ui-engineering](skills/frontend-ui-engineering/SKILL.md) | Component architecture, design systems, state management, responsive design, WCAG 2.1 AA accessibility | Building or modifying user-facing interfaces |
| [api-and-interface-design](skills/api-and-interface-design/SKILL.md) | Contract-first design, Hyrum's Law, One-Version Rule, error semantics, boundary validation | Designing APIs, module boundaries, or public interfaces |

### Verify - Prove it works

| Skill | What It Does | Use When |
|-------|-------------|----------|
| [browser-testing-with-devtools](skills/browser-testing-with-devtools/SKILL.md) | Chrome DevTools MCP for live runtime data - DOM inspection, console logs, network traces, performance profiling | Building or debugging anything that runs in a browser |
| [debugging-and-error-recovery](skills/debugging-and-error-recovery/SKILL.md) | Five-step triage: reproduce, localize, reduce, fix, guard. Stop-the-line rule, safe fallbacks | Tests fail, builds break, or behavior is unexpected |

### Review - Quality gates before merge

| Skill | What It Does | Use When |
|-------|-------------|----------|
| [code-review-and-quality](skills/code-review-and-quality/SKILL.md) | Five-axis review, change sizing (~100 lines), severity labels (Nit/Optional/FYI), review speed norms, splitting strategies | Before merging any change |
| [code-simplification](skills/code-simplification/SKILL.md) | Chesterton's Fence, Rule of 500, reduce complexity while preserving exact behavior | Code works but is harder to read or maintain than it should be |
| [security-and-hardening](skills/security-and-hardening/SKILL.md) | OWASP Top 10 prevention, auth patterns, secrets management, dependency auditing, three-tier boundary system | Handling user input, auth, data storage, or external integrations |
| [performance-optimization](skills/performance-optimization/SKILL.md) | Measure-first approach - Core Web Vitals targets, profiling workflows, bundle analysis, anti-pattern detection | Performance requirements exist or you suspect regressions |
| [ci-pr-reviewer](skills/ci-pr-reviewer/SKILL.md) | Automated PR Auditor that posts comments on GitHub/GitLab PRs (read-only) | Setting up CI for automated code review |

### Ship - Deploy with confidence

| Skill | What It Does | Use When |
|-------|-------------|----------|
| [git-workflow-and-versioning](skills/git-workflow-and-versioning/SKILL.md) | Trunk-based development, atomic commits, change sizing (~100 lines), the commit-as-save-point pattern | Making any code change (always) |
| [ci-cd-and-automation](skills/ci-cd-and-automation/SKILL.md) | Shift Left, Faster is Safer, feature flags, quality gate pipelines, failure feedback loops | Setting up or modifying build and deploy pipelines |
| [deprecation-and-migration](skills/deprecation-and-migration/SKILL.md) | Code-as-liability mindset, compulsory vs advisory deprecation, migration patterns, zombie code removal | Removing old systems, migrating users, or sunsetting features |
| [documentation-and-adrs](skills/documentation-and-adrs/SKILL.md) | Architecture Decision Records, API docs, inline documentation standards - document the *why* | Making architectural decisions, changing APIs, or shipping features |
| [shipping-and-launch](skills/shipping-and-launch/SKILL.md) | Pre-launch checklists, feature flag lifecycle, staged rollouts, rollback procedures, monitoring setup | Preparing to deploy to production |

### Meta - How to use this pack

| Skill | What It Does | Use When |
|-------|-------------|----------|
| [using-agent-skills](skills/using-agent-skills/SKILL.md) | Discovers and invokes agent skills — the meta-skill that governs all other skills | Starting a session or when you need to discover which skill applies |

---

## Agent Personas

Pre-configured specialist personas for targeted reviews:

| Agent | Role | Perspective |
|-------|------|-------------|
| [code-reviewer](agents/code-reviewer.md) | Senior Staff Engineer | Five-axis code review with "would a staff engineer approve this?" standard |
| [test-engineer](agents/test-engineer.md) | QA Specialist | Test strategy, coverage analysis, and the Prove-It pattern |
| [security-auditor](agents/security-auditor.md) | Security Engineer | Vulnerability detection, threat modeling, OWASP assessment |

---

## Reference Checklists

Quick-reference material that skills pull in when needed:

| Reference | Covers |
|-----------|--------|
| [testing-patterns.md](references/testing-patterns.md) | Test structure, naming, mocking, React/API/E2E examples, anti-patterns |
| [security-checklist.md](references/security-checklist.md) | Pre-commit checks, auth, input validation, headers, CORS, OWASP Top 10 |
| [performance-checklist.md](references/performance-checklist.md) | Core Web Vitals targets, frontend/backend checklists, measurement commands |
| [accessibility-checklist.md](references/accessibility-checklist.md) | Keyboard nav, screen readers, visual design, ARIA, testing tools |
| [orchestration-patterns.md](references/orchestration-patterns.md) | Agent orchestration patterns, anti-patterns, persona invocation rules |

---

## How Skills Work

Every skill follows a consistent anatomy:

```
┌─────────────────────────────────────────────────┐
│  SKILL.md                                       │
│                                                 │
│  ┌─ Frontmatter ─────────────────────────────┐  │
│  │ name: lowercase-hyphen-name               │  │
│  │ description: Guides agents through [task].│  │
│  │              Use when…                    │  │
│  └───────────────────────────────────────────┘  │                                                                                                
│  Overview         → What this skill does        │
│  When to Use      → Triggering conditions       │
│  Process          → Step-by-step workflow       │
│  Rationalizations → Excuses + rebuttals         │
│  Red Flags        → Signs something's wrong     │
│  Verification     → Evidence requirements       │
└─────────────────────────────────────────────────┘
```

**Key design choices:**

- **Process, not prose.** Skills are workflows agents follow, not reference docs they read. Each has steps, checkpoints, and exit criteria.
- **Anti-rationalization.** Every skill includes a table of common excuses agents use to skip steps (e.g., "I'll add tests later") with documented counter-arguments.
- **Verification is non-negotiable.** Every skill ends with evidence requirements - tests passing, build output, runtime data. "Seems right" is never sufficient.
- **Progressive disclosure.** The `SKILL.md` is the entry point. Supporting references load only when needed, keeping token usage minimal.

---

## Project Structure

```
Agentic-PDLC-Workflow/
├── skills/                            # 28 skills (SKILL.md per directory)
│   ├── idea-refine/                   #   Define
│   ├── spec-driven-development/       #   Define
│   ├── rapid-prototyping/             #   Define - Quick prototyping
│   ├── design-system/                 #   Design - Figma/Stitch/HTML + human review
│   ├── figma-generate-design/         #   Design - Figma MCP screen generation
│   ├── figma-use/                     #   Design - Figma MCP core operations
│   ├── planning-and-task-breakdown/   #   Plan
│   ├── jira-auto-worker/              #   Plan - Background worker
│   ├── context-mapping/               #   Context - Brownfield analysis
│   ├── incremental-implementation/    #   Build
│   ├── context-engineering/           #   Build
│   ├── source-driven-development/     #   Build
│   ├── frontend-ui-engineering/       #   Build
│   ├── test-driven-development/       #   Build
│   ├── api-and-interface-design/      #   Build
│   ├── browser-testing-with-devtools/ #   Verify
│   ├── debugging-and-error-recovery/  #   Verify
│   ├── code-review-and-quality/       #   Review
│   ├── code-simplification/           #   Review
│   ├── security-and-hardening/        #   Review
│   ├── performance-optimization/      #   Review
│   ├── ci-pr-reviewer/                #   Review - Automated PR audit
│   ├── git-workflow-and-versioning/   #   Ship
│   ├── ci-cd-and-automation/          #   Ship
│   ├── deprecation-and-migration/     #   Ship
│   ├── documentation-and-adrs/        #   Ship
│   ├── shipping-and-launch/           #   Ship
│   └── using-agent-skills/            #   Meta: how to use this pack
├── scripts/                           # 6 Jira bridge scripts (Python)
│   ├── create_jira_ticket.py
│   ├── create_design_review_ticket.py
│   ├── create_pr.py
│   ├── fetch_todo_ticket.py
│   ├── transition_ticket.py
│   └── create_bug_ticket.py
├── agents/                            # 3 specialist personas
├── references/                        # 5 supplementary checklists
├── hooks/                             # Session lifecycle hooks
├── .claude/commands/                  # 8 slash commands
├── .github/workflows/                 # CI/CD workflows
│   └── ai-pr-review.yml               #   Automated PR review
├── docs/                              # Setup guides and team docs
│   ├── team-collaboration.md          #   Team sizes, conflict prevention, permissions
│   └── environment-variables.md       #   Complete env var reference
```

---

## Why Agent Skills?

AI coding agents default to the shortest path - which often means skipping specs, tests, security reviews, and the practices that make software reliable. Agent Skills gives agents structured workflows that enforce the same discipline senior engineers bring to production code.

Each skill encodes hard-won engineering judgment: *when* to write a spec, *what* to test, *how* to review, and *when* to ship. These aren't generic prompts - they're the kind of opinionated, process-driven workflows that separate production-quality work from prototype-quality work.

Skills bake in best practices from Google's engineering culture — including concepts from [Software Engineering at Google](https://abseil.io/resources/swe-book) and Google's [engineering practices guide](https://google.github.io/eng-practices/). You'll find Hyrum's Law in API design, the Beyonce Rule and test pyramid in testing, change sizing and review speed norms in code review, Chesterton's Fence in simplification, trunk-based development in git workflow, Shift Left and feature flags in CI/CD, and a dedicated deprecation skill treating code as a liability.

This repo adds **Jira integration** for automated workflow management — auto-fetching tickets, isolated worktree development, automated PR creation, and CI-powered code review. These aren't abstract principles — they're embedded directly into the step-by-step workflows agents follow.

---

## FAQ

### How do skills activate automatically?
When you run a slash command like `/build`, the system loads the relevant skills for that phase. You can also reference any skill directly by reading `skills/<name>/SKILL.md`.

### What happens after SPEC.md is written?
Run `/plan` to break the spec into atomic tasks and create Jira tickets. After human approval, use `/build` to start implementation.

### How do I configure Jira integration?
See the Python scripts in `scripts/` directory. Set these environment variables:
```bash
export JIRA_URL="https://your-domain.atlassian.net"
export JIRA_USER="your-email@domain.com"
export JIRA_API_TOKEN="your-api-token"
export JIRA_PROJECT_KEY="PROJ"
export JIRA_AI_ACCOUNT_ID="jira-ai-user-id"
```

### Can I use this without Jira?
Yes. `/plan` still generates task breakdowns and `.planning/ROADMAP.md`, just without Jira ticket sync.

### Can I use GitLab instead of GitHub?
Yes. PR/MR creation is configurable via `.git-provider.json` in your repo root:
```json
{
  "provider": "gitlab",
  "api_url": "https://gitlab.your-company.com/api/v4",
  "project_id": "12345",
  "token_env": "GITLAB_TOKEN"
}
```
The `jira-auto-worker` skill reads this config and uses the appropriate API. Falls back to `gh` CLI (GitHub) if no config file exists. CI examples are provided for both GitHub Actions and GitLab CI in the `ci-cd-and-automation` skill.

### What's the difference between `/map` and `/spec`?
`/map` is for existing projects — it analyzes the codebase and creates `.planning/CONTEXT.md`. `/spec` is for any project — it writes the product requirements document (`SPEC.md`).

### How do I configure my team to work together?
See [docs/team-collaboration.md](docs/team-collaboration.md) for team sizes, conflict prevention, permission matrix, and best practices.

### Where can I find all environment variables?
See [docs/environment-variables.md](docs/environment-variables.md) for the complete list of Jira, Git, CI/CD, and optional integrations.

### How do I add a new skill?
See [CONTRIBUTING.md](CONTRIBUTING.md) for the skill format specification. Each skill needs a `SKILL.md` file with Overview, When to Use, Process, Common Rationalizations, Red Flags, and Verification sections.

### How do I handle merge conflicts between multiple agents?
Each agent works in its own git worktree on a dedicated branch. If two PRs touch the same file, the second PR must rebase on main and resolve conflicts. See [docs/team-collaboration.md](docs/team-collaboration.md) for conflict prevention strategies.

### What team size is this workflow designed for?
The workflow scales from 1-person teams to 20+ person teams. See [docs/team-collaboration.md](docs/team-collaboration.md) for configuration recommendations by team size.

### How do I debug a skill that's not triggering?
1. Check that the skill file exists at `skills/<name>/SKILL.md`
2. Verify the skill name in the frontmatter matches the directory name
3. Check that the slash command in `.claude/commands/` references the correct skill
4. Run `/spec` or `/build` to see if the skill loads

### Can I customize the review policy?
Yes. The review policy is configurable per project. See your project's `workflow.yaml` for review policy settings (human, agent, or auto).

### How do I handle a task that fails 3 times?
The agent automatically creates a Bug ticket in Jira and marks the original ticket as "Blocked." A human must investigate and fix the root cause before the agent can resume.

### What's the recommended PR size?
Keep PRs under 100 lines for faster review. Smaller PRs are easier to review, test, and rollback if needed.

### How do I set up CI/CD?
See the `ci-cd-and-automation` skill for GitHub Actions and GitLab CI examples. The skill covers quality gate pipelines, feature flags, and failure feedback loops.

### Can I use this with other AI tools?
Yes. Skills are plain Markdown and work with any agent that accepts system prompts. See the setup guides for Cursor, Gemini CLI, Windsurf, OpenCode, Copilot, and Kiro.

---

## Contributing

Skills should be **specific** (actionable steps, not vague advice), **verifiable** (clear exit criteria with evidence requirements), **battle-tested** (based on real workflows), and **minimal** (only what's needed to guide the agent).

See [docs/skill-anatomy.md](docs/skill-anatomy.md) for the format specification and [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

MIT - use these skills in your projects, teams, and tools.