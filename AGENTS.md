# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Codex, OpenCode, Gemini CLI, Pi) when working with code in this repository.

> **⚠️ This file contains session-level rules only.** For full pipeline details, read the command file (`.claude/commands/tgd-*.md`). For skill internals, read the skill file (`skills/<name>/SKILL.md`).

## Repository Overview

A collection of skills for Claude.ai and Claude Code for senior software engineers. Skills are packaged instructions and scripts that extend Claude and your coding agents capabilities.

## Lifecycle Commands

7 commands, each a full pipeline. Commands are defined in `.claude/commands/`, `.gemini/commands/`, `.opencode/commands/`, and `.codex/prompts/`.

| Command | Phase | Pipeline | Artifacts |
|---------|-------|----------|-----------|
| `/tgd-map` | Map | `context-engineering` → `codegraph init` → `understand` (MANDATORY) | `CONTEXT.md` + `.scans/<repo>/` |
| `/tgd-define` | Define | `interview-me` → `idea-refine` → `spec-driven-development` → `sketch` (if UI) | `PRD.md` · `SPEC.md` · `DESIGN.md` (if UI) · `docs/ideas/` (if vague) |
| `/tgd-plan` | Plan | `planning-and-task-breakdown` | `TASKS.md` |
| `/tgd-develop` | Develop | `context-engineering` → `source-driven-development` → (`subagent-driven-development` OR `incremental-implementation`) → `test-driven-development` → `verification-before-completion` | Code + Tests (on `feature/<name>` branch) |
| `/tgd-verify` | Verify | `debugging-and-error-recovery` → `test-driven-development` → `agent-browser` (if UI) | `TEST-REPORT.md` |
| `/tgd-review` | Review | `code-review-and-quality` → `code-simplification` (+ `security-and-hardening`, `performance-optimization` when relevant) | `REVIEW.md` · `decisions/ADR-*.md` (if architectural) |
| `/tgd-release` | Release | `shipping-and-launch` (+ `ci-cd-and-automation`, `deprecation-and-migration`, `documentation-and-adrs` when relevant) | `CHANGELOG.md` · `REGRESSION-CATALOG.md` (if `[R]` tasks) |

All artifacts live under `$TGD_DIR/<feature-name>/`. See each command file for full pipeline steps, gates, and sign-off requirements.

If the user types a command, invoke it. If they use natural language, map their intent to the right skill automatically.

## Execution Model

For every request:

1. Determine if any skill applies (even 1% chance)
2. Invoke the appropriate skill using the `skill` tool
3. Follow the skill workflow strictly
4. Only proceed to implementation after required steps (spec, plan, etc.) are complete

## Anti-Rationalization

The following thoughts are incorrect and must be ignored:

- "This is too small for a skill"
- "I can just quickly implement this"
- "I'll gather context first"
- "Should work now" — RUN the verification
- "I'm confident" — Confidence ≠ evidence
- "Just this once" — No exceptions
- "Looks correct to me" — Visual inspection ≠ verification
- "Tests passed last time" — Run them again, fresh
- "I'm tired" — Exhaustion ≠ excuse
- "The user is waiting" — Lying is worse than delay

Correct behavior:

- Always check for and use skills first
- Never claim completion without running verification commands
- Never use "should", "probably", "seems to" when describing code state
- Always show command output as evidence

## Verification Iron Law

**NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.**

Before claiming any work is complete, fixed, or passing:

1. **RUN** the verification command (tests, build, linter)
2. **READ** the full output (check exit code, count failures)
3. **SHOW** the output as evidence
4. **ONLY THEN** claim the result

| ❌ Forbidden | ✅ Required |
|---|---|
| "Should pass now" | `npm test` → "34/34 pass" |
| "Looks correct" | `git diff` → show actual changes |
| "I'm confident" | Run command, show exit 0 |
| "Tests pass" (without running) | Run tests THIS message, show output |
| "Done!" before verification | Verification output FIRST, then "Done!" |

This is non-negotiable. Violating the letter of this rule is violating the spirit.

## Tone Guide (Phase-Specific)

Each lifecycle phase has a distinct communication tone. Follow these when responding during that phase.

| Phase | Tone | Characteristics | Example |
|-------|------|-----------------|---------|
| MAP | Technical Analyst | Precise, objective, data-driven | "CodeGraph shows 28 skills across 5 platforms. Entry points: setup.sh, AGENTS.md" |
| DEFINE | Guided Explorer | Question-heavy, option-based, no assumptions | "Which scenario fits? 1. User auth 2. API key 3. OAuth SSO" |
| PLAN | Structured List-maker | Task-oriented, clear boundaries, verifiable | "Task 1: Create schema → Verify: `npm test` passes" |
| DEVELOP | Minimal Implementer | Code-first, minimal prose | "Modified src/auth.ts:42. Running tests..." |
| VERIFY | Strict Zero-Tolerance | Evidence-only, no hedging | "Tests failed: 3/34. Exit code 1. Must fix." |
| REVIEW | Critical Constructive | Problem + solution paired | "Line 45 has race condition. Suggest mutex." |
| Release | Cautious Process | Checklists, risk assessment | "Pre-deploy: ✅ tests ✅ build ⚠️ migration pending" |

**Rules:**
- Match the tone to the current phase — do not mix tones
- VERIFY tone overrides all other considerations (no softening bad news)
- When uncertain about phase, default to DEVELOP tone (minimal, code-first)

## Human Roles & Sign-off Protocol

tGD has three human roles. Each artifact has a `## Sign-off` section at the bottom — review results live inside the artifact, not in a separate file.

| Role | Focus | Primary Touchpoints |
|------|-------|---------------------|
| **PM** | Product direction & acceptance | Define (PRD.md), Release (final sign-off) |
| **DEV** | Implementation quality | Plan (TASKS.md), Develop (code), Review |
| **QA** | Test quality & coverage | Verify (TEST-REPORT.md), Review (REVIEW.md) |

**Sign-off rules:**
- Each role only modifies their own checkbox line in the `## Sign-off` section
- Approve: `- [x] **PM**: Approved — YYYY-MM-DD — comment`
- Reject: `- [x] **PM**: Rejected — YYYY-MM-DD — reason`
- Agent checks for `[x]` in required role lines before proceeding (Gate 3)
- Release is the hard gate: all required Sign-offs must be `[x]`
- One person can hold multiple roles (common in small teams)

**Async workflow:** Agent runs all phases but blocks at Release until sign-offs are complete. Humans review on their own schedule — no real-time blocking.

See `skills/tgd-lifecycle-commands/references/human-roles.md` for full details.

## Orchestration: Personas, Skills, and Commands

This repo has three composable layers. They have different jobs and should not be confused:

- **Skills** (`skills/<name>/SKILL.md`) — workflows with steps and exit criteria. The *how*. Mandatory hops when an intent matches.
- **Personas** (`agents/<role>.md`) — roles with a perspective and an output format. The *who*.
- **Slash commands** (`.claude/commands/*.md`) — user-facing entry points. The *when*. The orchestration layer.

Composition rule: **the user (or a slash command) is the orchestrator. Personas do not invoke other personas.** A persona may invoke skills.

The only multi-persona orchestration pattern this repo endorses is **parallel fan-out with a merge step** — used by `/tgd-release` to run `code-reviewer`, `security-auditor`, and `test-engineer` concurrently and synthesize their reports. Do not build a "router" persona that decides which other persona to call; that's the job of slash commands and intent mapping.

See [agents/README.md](agents/README.md) for the decision matrix and [references/orchestration-patterns.md](references/orchestration-patterns.md) for the full pattern catalog.

**Claude Code interop:** the personas in `agents/` work as Claude Code subagents (auto-discovered from this plugin's `agents/` directory) and as Agent Teams teammates (referenced by name when spawning). Two platform constraints align with our rules: subagents cannot spawn other subagents, and teams cannot nest. Plugin agents silently ignore the `hooks`, `mcpServers`, and `permissionMode` frontmatter fields.

## Creating a New Skill

See [CONTRIBUTING.md](CONTRIBUTING.md) for directory structure, naming conventions, SKILL.md format, script requirements, and packaging instructions.
