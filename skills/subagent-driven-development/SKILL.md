---
name: subagent-driven-development
description: Execute implementation plans by dispatching fresh subagents per task with two-stage review. Use when executing a multi-task implementation plan, when context is getting too long for quality output, or when you want maximum isolation between tasks.
---

# Subagent-Driven Development

## Overview

Execute implementation plans by dispatching **fresh subagents per task** with two-stage review: **spec compliance first, then code quality**.

**Core Principle:** Fresh subagent per task + two-stage review = high quality, fast iteration

**Why Subagents:**
- Each task gets a clean context window — no pollution from prior tasks
- Subagents receive precisely crafted instructions — focus and success
- Your main context is preserved for coordination — you stay in control
- Quality doesn't degrade as context grows — every task starts fresh

## When to Use

- Executing a multi-task implementation plan (TASKS.md)
- Context is getting long and output quality is degrading
- Tasks are mostly independent (can be executed sequentially)
- You want the highest quality output per task

**When NOT to use:**
- Single, small changes (use `incremental-implementation` instead)
- Tasks that are tightly coupled and need constant cross-reference
- Exploration/prototyping where you don't have a plan yet

## The Process

```
Read TASKS.md
    │
    ▼
┌─ For each task ──────────────────────────────────────┐
│                                                       │
│  1. Dispatch implementer subagent                     │
│     - Provide: task spec, relevant files, context     │
│     - Subagent implements, tests, commits             │
│                                                       │
│  2. Dispatch spec reviewer subagent                   │
│     - Provide: task spec + subagent's output          │
│     - Checks: does code match the spec?               │
│     - If NO → implementer fixes spec gaps             │
│                                                       │
│  3. Dispatch code quality reviewer subagent           │
│     - Provide: code diff + quality checklist           │
│     - Checks: readability, patterns, test quality     │
│     - If NO → implementer fixes quality issues        │
│                                                       │
│  4. Mark task complete                                │
│                                                       │
└───────────────────────────────────────────────────────┘
    │
    ▼
Final review of entire implementation
```

## Continuous Execution

**Do not pause to check in between tasks.** Execute all tasks from the plan without stopping.

**Only reasons to stop:**
- BLOCKED status you cannot resolve
- Ambiguity that genuinely prevents progress
- All tasks complete

**Never:** Use "Should I continue?" prompts or progress summaries — waste the user's time.

## Subagent Prompts

### Implementer Prompt Template

```
You are implementing a single task from an implementation plan.

TASK:
{task_description}

RELEVANT FILES:
{file_list}

CONTEXT:
{relevant_context}

RULES:
1. Implement exactly what the task specifies — nothing more, nothing less
2. Write tests before code (TDD Red-Green-Refactor)
3. Commit when the task is complete with a clear commit message
4. Do NOT modify files outside your task scope
5. If you encounter ambiguity, state it clearly and stop

EXPECTED OUTPUT:
- Code changes committed
- Tests written and passing
- Brief summary of what was done
```

### Spec Reviewer Prompt Template

```
You are reviewing code for spec compliance.

TASK SPEC:
{task_description}

CODE CHANGES:
{diff_or_file_list}

CHECK:
1. Does the code implement everything the spec requires?
2. Are there any spec requirements that were missed?
3. Does the code do anything NOT in the spec? (scope creep)
4. Are edge cases from the spec handled?

OUTPUT:
- PASS: Code matches spec
- FAIL: List specific gaps between spec and implementation
```

### Code Quality Reviewer Prompt Template

```
You are reviewing code for quality.

CODE CHANGES:
{diff_or_file_list}

CHECK:
1. Readability: Is the code clear and well-structured?
2. Patterns: Does it follow existing codebase conventions?
3. Test quality: Are tests meaningful (not just for coverage)?
4. Error handling: Are failure cases handled?
5. Performance: Any obvious performance issues?
6. Security: Any obvious security issues?

OUTPUT:
- PASS: Code meets quality standards
- FAIL: List specific issues with severity (critical/important/nit)
```

## Integration with tGD

This skill is invoked by `/tgd-develop` when executing a task plan. It replaces the default single-session execution with subagent-based execution for higher quality.

**Trigger conditions:**
- TASKS.md exists with multiple tasks
- Tasks are mostly independent
- User wants maximum quality (not maximum speed)

**Fallback:** If subagent delegation is not available, fall back to `incremental-implementation`.
