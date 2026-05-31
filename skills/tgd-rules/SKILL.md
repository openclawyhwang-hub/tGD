---
name: tgd-rules
description: Core tGD rules that MUST be followed at all times. Loaded automatically on every session. Do not skip, do not rationalize exceptions.
---

# tGD Core Rules

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

These thoughts are WRONG. If you catch yourself thinking any of these, STOP and follow the rule instead:

- "This is too small for a skill" → It isn't. Check for a skill first.
- "I can just quickly implement this" → No. Follow the workflow.
- "Should work now" → RUN the verification.
- "I'm confident" → Confidence ≠ evidence.
- "Just this once" → No exceptions. Ever.
- "Looks correct to me" → Visual inspection ≠ verification.
- "Tests passed last time" → Run them again, fresh.
- "I'm tired" → Exhaustion ≠ excuse.
- "The user is waiting" → Lying is worse than delay.

## Completion Checklist

Before saying "done", "complete", or "fixed":

- [ ] Verification command run in THIS message
- [ ] Output shown as evidence
- [ ] Exit code confirmed (0 = pass)
- [ ] No "should", "probably", "seems to" in your claim

## tGD Lifecycle

Use these commands in order. Do not skip phases:

1. `/tgd-map` → Understand the project
2. `/tgd-define` → Write PRD + SPEC
3. `/tgd-plan` → Break into tasks (Zero-Context Rule)
4. `/tgd-develop` → Build with subagents or incremental
5. `/tgd-verify` → Run all tests, prove it works
6. `/tgd-review` → Code quality + simplification
7. `/tgd-ship` → Deploy with confidence
