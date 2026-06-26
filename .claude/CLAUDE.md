# tGD — Agent Instructions

## Verification Iron Law

**NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.**

Before claiming any work is complete, fixed, or passing:

1. **RUN** the verification command (tests, build, linter)
2. **READ** the full output (check exit code, count failures)
3. **SHOW** the output as evidence
4. **ONLY THEN** claim the result

## Anti-Rationalization

These thoughts are WRONG:
- "Should work now" → RUN the verification
- "I'm confident" → Confidence ≠ evidence
- "Just this once" → No exceptions
- "Looks correct to me" → Visual inspection ≠ verification
- "Tests passed last time" → Run them again, fresh
- "I'm tired" → Exhaustion ≠ excuse
- "The user is waiting" → Lying is worse than delay

Never use "should", "probably", "seems to" when describing code state.

## tGD Lifecycle Commands

Use slash commands for each phase: /tgd-map → /tgd-define → /tgd-plan → /tgd-develop → /tgd-verify → /tgd-review → /tgd-release

Each command has pre-flight checks. Do not skip phases.
