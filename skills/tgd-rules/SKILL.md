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

**MANDATORY SELECTION PROTOCOL (All Platforms)**
When you need the user to pick an option (Feature Name, Design Variant, etc.), DO NOT use open-ended questions. 
**ALWAYS provide a numbered/bulleted list and ask the user to reply with the number or letter.**

| Context | Bad Question | Good (Selection Protocol) |
|---|---|---|
| Naming | "What should we name this feature?" | "Pick a name: 1. `user-login` 2. `auth-flow` 3. `sign-in-module` (or type your own)" |
| Design | "Which design do you like?" | "Pick a direction: A (Conservative), B (Strong-fit), C (Divergent)" |
| UI Gate | "Is this a UI feature?" | "Does this feature have a UI component? 1. Yes (Generate design) 2. No (Backend only)" |

This ensures the user can reply with a simple "1" or "B" instead of typing a paragraph.

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

## Understand-Anything (if the understand skill is available)

For deeper architectural understanding, especially on unfamiliar codebases:

| PDLC Phase | Situation | Command | Why |
|---|---|---|---|
| 🗺️ Map | First time exploring a project | understand skill | Build full knowledge graph + dashboard |
| 📐 Define | Need business domain mapping | understand-domain skill | Map code to business processes |
| 📋 Plan | Planning a large refactor | understand-diff skill | Visualize impact of proposed changes |
| 🔨 Develop | Working on unfamiliar code | understand skill | Understand before you modify |
| 🔍 Verify | Confirming change impact | understand-diff skill | Verify no missed dependencies |
| 👀 Review | Reviewing large changes | understand-diff skill | Full blast radius before approval |
| 🗺️ Map | Onboarding a new team member | understand-onboard skill | Guided tour of the architecture |

Use CodeGraph for fast symbol queries, Understand-Anything for deep comprehension. They complement each other.
