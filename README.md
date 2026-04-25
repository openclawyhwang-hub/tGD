# Agentic PDLC Workflow

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Skills](https://img.shields.io/badge/Skills-25-orange.svg)](#all-25-skills)
[![Commands](https://img.shields.io/badge/Commands-8-blue.svg)](#commands)
[![Status](https://img.shields.io/badge/Status-Active-brightgreen.svg)]()

**Production-grade engineering skills with Jira integration for AI coding agents.**

> 🚀 25 skills • 8 commands • 7 development phases • Multi-agent support

## Table of Contents

- [What This Is](#what-this-is)
- [Human vs Agent Roles](#human-vs-agent-roles)
- [Commands](#commands)
- [Quick Start](#quick-start)
- [Workflow Overview](#workflow-overview)
  - [Phase Flow](#phase-flow)
  - [Phase Details](#phase-details)
- [All 25 Skills](#all-25-skills)
- [Agent Personas](#agent-personas)
- [Reference Checklists](#reference-checklists)
- [How Skills Work](#how-skills-work)
- [Project Structure](#project-structure)
- [Why Agent Skills?](#why-agent-skills)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

## What This Is

A complete development workflow that guides AI agents through every phase — from understanding requirements to deploying to production. Each phase has clear inputs, outputs, and quality gates so agents don't skip critical steps.

### Human vs Agent Roles

| Phase | Who Does What | How It Works |
|-------|---------------|---------------|
| **CONTEXT** | 👤 Human triggers → 🤖 Agent executes | Human runs `/map` for existing projects, Agent analyzes codebase |
| **DEFINE** | 👤 Human provides idea → 🤖 Agent writes spec | Human describes what to build, Agent writes SPEC.md |
| **PLAN** | 🤖 Agent breaks down → 👤 Human approves | Agent creates tasks + Jira tickets, Human reviews |
| **BUILD** | 🤖 Agent implements | Agent fetches tickets, writes code in isolated worktree |
| **VERIFY** | 🤖 Agent tests | Agent runs tests, checks browser, debugs failures |
| **REVIEW** | 🤖 Agent + CI review → 👤 Human approves | Automated review + Human final decision |
| **SHIP** | 🤖 Agent deploys → 👤 Human monitors | Agent deploys with checklist, Human watches for issues |

---

## Commands

8 slash commands that map to the development lifecycle. Each one activates the right skills automatically.

| What you're doing | Command | Key principle |
|-------------------|---------|---------------|
| Map existing codebase | `/map` | Understand before acting |
| Define what to build | `/spec` | Spec before code |
| Plan how to build it | `/plan` | Small, atomic tasks |
| Build incrementally | `/build` | One slice at a time |
| Prove it works | `/test` | Tests are proof |
| Review before merge | `/review` | Improve code health |
| Simplify the code | `/code-simplify` | Clarity over cleverness |
| Ship to production | `/ship` | Faster is safer |

Skills also activate automatically based on what you're doing — designing an API triggers `api-and-interface-design`, building UI triggers `frontend-ui-engineering`, and so on.

---

## Quick Start

### 5-Minute Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/openclawyhwang-hub/Agentic-PDLC-Workflow.git

# 2. Install in Claude Code
/plugin marketplace add addyosmani/agent-skills
/plugin install agent-skills@addy-agent-skills

# 3. Start your first workflow
> /spec "I want to build a user login feature"
> /plan
> /build
```

> **SSH errors?** The marketplace clones repos via SSH. If you don't have SSH keys set up on GitHub, either [add your SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) or switch to HTTPS for fetches only:
> ```bash
> git config --global url."https://github.com/".insteadOf "git@github.com:"
> ```

<details>
<summary><b>Claude Code (recommended)</b></summary>

**Marketplace install:**

```
/plugin marketplace add addyosmani/agent-skills
/plugin install agent-skills@addy-agent-skills
```

> **SSH errors?** The marketplace clones repos via SSH. If you don't have SSH keys set up on GitHub, either [add your SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) or switch to HTTPS for fetches only:
> ```bash
> git config --global url."https://github.com/".insteadOf "git@github.com:"
> ```

**Local / development:**

```bash
git clone https://github.com/openclawyhwang-hub/Agentic-PDLC-Workflow.git
claude --plugin-dir /path/to/agent-skills
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

## Workflow Overview

### Phase Flow

```
[CONTEXT] ──▶ DEFINE ──▶ PLAN ──▶ BUILD ──▶ VERIFY ──▶ REVIEW ──▶ SHIP
   │            │          │        │         │          │         │
   ▼            ▼          ▼        ▼         ▼          ▼         ▼
 Brownfield   Spec      Tasks    Code      Tests     PR       Deploy
 Discovery    PRD       Jira     Feature   Proof     Review   Release
```

### Phase Details

#### 📍 CONTEXT (Existing Projects Only)
| Item | Details |
|------|--------|
| **Trigger** | `/map` — Only for existing projects |
| **Skills** | `context-mapping` |
| **Input** | Existing codebase |
| **Output** | `.planning/CONTEXT.md` — Architecture summary, key entities, constraints |
| **Gate** | Context file must exist before DEFINE |

#### 🎯 DEFINE
| Item | Details |
|------|--------|
| **Trigger** | `/spec` |
| **Skills** | `idea-refine`, `spec-driven-development`, `rapid-prototyping` |
| **Input** | Vague idea or feature request |
| **Output** | `SPEC.md` — Product requirements, objectives, commands, structure, code style, testing, boundaries |
| **Gate** | 👤 Human reviews and approves the spec |

#### 📋 PLAN
| Item | Details |
|------|--------|
| **Trigger** | `/plan` |
| **Skills** | `planning-and-task-breakdown`, `jira-auto-worker` |
| **Input** | `SPEC.md` + `.planning/CONTEXT.md` (if exists) |
| **Output** | Jira tickets with acceptance criteria, dependency ordering, story points |
| **Gate** | 👤 Human approves task breakdown |

#### 🔨 BUILD
| Item | Details |
|------|--------|
| **Trigger** | `/build` |
| **Skills** | `incremental-implementation`, `test-driven-development`, `context-engineering`, `source-driven-development`, `frontend-ui-engineering`, `api-and-interface-design` |
| **Input** | Jira ticket + context map |
| **Output** | Feature branch with implementation, unit tests, and commit |
| **Gate** | Tests pass, code compiles, feature works |

#### ✅ VERIFY
| Item | Details |
|------|--------|
| **Trigger** | `/test` |
| **Skills** | `browser-testing-with-devtools`, `debugging-and-error-recovery` |
| **Input** | Feature branch |
| **Output** | Test results, browser runtime data, debugging logs |
| **Gate** | All tests pass, no runtime errors |

#### 🔍 REVIEW
| Item | Details |
|------|--------|
| **Trigger** | `/review` |
| **Skills** | `code-review-and-quality`, `code-simplification`, `security-and-hardening`, `performance-optimization`, `ci-pr-reviewer` |
| **Input** | Pull request |
| **Output** | Review comments, security scan, performance analysis |
| **Gate** | Five-axis review passes → 👤 Human approves PR |

#### 🚀 SHIP
| Item | Details |
|------|--------|
| **Trigger** | `/ship` |
| **Skills** | `git-workflow-and-versioning`, `ci-cd-and-automation`, `deprecation-and-migration`, `documentation-and-adrs`, `shipping-and-launch` |
| **Input** | Approved PR |
| **Output** | Production deployment, ADRs, monitoring setup, rollback plan |
| **Gate** | Pre-launch checklist complete, feature flags configured, 👤 Human confirms deployment |

---

## All 25 Skills

The commands above are the entry points. Under the hood, they activate these 25 skills — each one a structured workflow with steps, verification gates, and anti-rationalization tables. You can also reference any skill directly.

### Define - Clarify what to build

| Skill | What It Does | Use When |
|-------|-------------|----------|
| [idea-refine](skills/idea-refine/SKILL.md) | Structured divergent/convergent thinking to turn vague ideas into concrete proposals | You have a rough concept that needs exploration |
| [spec-driven-development](skills/spec-driven-development/SKILL.md) | Write a PRD covering objectives, commands, structure, code style, testing, and boundaries before any code | Starting a new project, feature, or significant change |
| [rapid-prototyping](skills/rapid-prototyping/SKILL.md) | Generates throwaway HTML/JS prototypes to visualize concepts before writing the spec | Need to explore UI concepts before spec |

### Plan - Break it down

| Skill | What It Does | Use When |
|-------|-------------|----------|
| [planning-and-task-breakdown](skills/planning-and-task-breakdown/SKILL.md) | Decompose specs into small, verifiable tasks with acceptance criteria and dependency ordering | You have a spec and need implementable units |
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
├── skills/                            # 25 skills (SKILL.md per directory)
│   ├── idea-refine/                   #   Define
│   ├── spec-driven-development/       #   Define
│   ├── rapid-prototyping/             #   Define - Quick prototyping
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
│   ├── code-simplification/          #   Review
│   ├── security-and-hardening/        #   Review
│   ├── performance-optimization/      #   Review
│   ├── ci-pr-reviewer/                #   Review - Automated PR audit
│   ├── git-workflow-and-versioning/   #   Ship
│   ├── ci-cd-and-automation/          #   Ship
│   ├── deprecation-and-migration/     #   Ship
│   ├── documentation-and-adrs/        #   Ship
│   ├── shipping-and-launch/           #   Ship
│   └── using-agent-skills/            #   Meta: how to use this pack
├── scripts/                           # 4 Jira bridge scripts (Python)
│   ├── create_jira_ticket.py
│   ├── fetch_todo_ticket.py
│   ├── transition_ticket.py
│   └── create_bug_ticket.py
├── agents/                            # 3 specialist personas
├── references/                        # 5 supplementary checklists
├── hooks/                             # Session lifecycle hooks
├── .claude/commands/                  # 8 slash commands
├── .github/workflows/                 # CI/CD workflows
│   └── ai-pr-review.yml               #   Automated PR review
└── docs/                              # Setup guides per tool
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

### What's the difference between `/map` and `/spec`?
`/map` is for existing projects — it analyzes the codebase and creates `.planning/CONTEXT.md`. `/spec` is for any project — it writes the product requirements document (`SPEC.md`).

---

## Contributing

Skills should be **specific** (actionable steps, not vague advice), **verifiable** (clear exit criteria with evidence requirements), **battle-tested** (based on real workflows), and **minimal** (only what's needed to guide the agent).

See [docs/skill-anatomy.md](docs/skill-anatomy.md) for the format specification and [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

MIT - use these skills in your projects, teams, and tools.