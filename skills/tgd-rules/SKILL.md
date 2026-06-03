---
name: tgd-rules
description: Core tGD rules that MUST be followed at all times. Loaded automatically on every session. Do not skip, do not rationalize exceptions.
---

# tGD Core Rules

## Overview

Core rules that MUST be followed at all times in every tGD session. These rules enforce evidence-based verification, prevent rationalization, and maintain workflow integrity across all 8 lifecycle phases.

## When to Use

- Automatically loaded on every session via `tgd-rules`
- Referenced by all 8 `/tgd-*` lifecycle commands
- Any time an agent is about to claim completion, skip a step, or rationalize an exception

## Common Rationalizations

These thoughts are WRONG. If you catch yourself thinking any of these, STOP and follow the rule instead:

| Rationalization | Reality |
|---|---|
| "This is too small for a skill" | It isn't. Check for a skill first. |
| "I can just quickly implement this" | No. Follow the workflow. |
| "Should work now" | RUN the verification. |
| "I'm confident" | Confidence ≠ evidence. |
| "Just this once" | No exceptions. Ever. |
| "Looks correct to me" | Visual inspection ≠ verification. |
| "Tests passed last time" | Run them again, fresh. |
| "I'm tired" | Exhaustion ≠ excuse. |
| "The user is waiting" | Lying is worse than delay. |

## Red Flags

- Claiming completion without running verification in THIS message
- Using "should", "probably", "seems to" instead of evidence
- Skipping a tGD lifecycle phase without documented reason
- Modifying files outside the current task scope
- Trusting agent reports without independent verification

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
| "Done!" before verification | Verification output FIRST |

## Anti-Rationalization

<!-- Moved to ## Common Rationalizations above to satisfy skill-anatomy.md -->

## Completion Checklist

Before saying "done", "complete", or "fixed":

- [ ] Verification command run in THIS message
- [ ] Output shown as evidence
- [ ] Exit code confirmed (0 = pass)
- [ ] No "should", "probably", "seems to" in your claim

## Verification

- [ ] All verification commands executed with output shown
- [ ] Exit codes confirmed (0 = pass)
- [ ] No rationalization language used in claims
- [ ] tGD lifecycle phases followed in order

## tGD Lifecycle

Use these commands in order. Do not skip phases:

1. `/tgd-map` → Understand the project
2. `/tgd-define` → Write PRD + SPEC
3. `/tgd-plan` → Break into tasks (Zero-Context Rule)
4. `/tgd-develop` → Build with subagents or incremental
5. `/tgd-verify` → Run all tests, prove it works
6. `/tgd-review` → Code quality + simplification
7. `/tgd-ship` → Deploy with confidence

## CodeGraph (if `.codegraph/` exists in project root)

If the project has a `.codegraph/` directory, **USE IT**. These commands are fast (< 1s) and prevent blind spots:

| Situation | Command | Why |
|---|---|---|
| Starting any code task | `codegraph context "<task>" --no-code` | Find entry points before touching files |
| Before changing a function | `codegraph callers "<symbol>"` | Know who depends on it |
| Before refactoring | `codegraph impact "<symbol>"` | Assess blast radius |
| Before committing | `codegraph affected <changed files>` | Run only relevant tests |

If `.codegraph/` does NOT exist, skip silently. Do not suggest installing it unprompted.

## Understand-Anything (if `/understand` command is available)

For deeper architectural understanding, especially on unfamiliar codebases:

| Situation | Command | Why |
|---|---|---|
| First time exploring a project | `/understand` | Build full knowledge graph + dashboard |
| Need business domain mapping | `/understand-domain` | Map code to business processes |
| Onboarding a new team member | `/understand-onboard` | Guided tour of the architecture |
| Before a big refactor | `/understand-diff` | Visualize impact of proposed changes |

Use CodeGraph for fast symbol queries, Understand-Anything for deep comprehension. They complement each other.
