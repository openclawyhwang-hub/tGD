# /tgd-review

Review — improve code health before merge

Run the code-review-and-quality skill. This is the REVIEW phase.

Pre-flight:
- Check test files exist in tests/. If missing, /tgd-verify first.

Core flow:
1. code-review-and-quality — five-axis review with severity labels (Nit/Optional/FYI)
2. code-simplification — Chesterton's Fence, reduce complexity

Conditional:
- Security concerns? -> security-and-hardening
- Performance concerns? -> performance-optimization

If change > ~100 lines, split into smaller reviews.

After completing, create `$TGD_DIR/<feature-name>/REVIEW.md` with:
- Code review findings (severity: Nit/Optional/FYI/Critical)
- Security scan results
- Performance analysis
- Simplification suggestions applied
- QA + DEV Sign-off

If any architectural decisions were made during the review, create `$TGD_DIR/<feature-name>/decisions/` with ADR files:
- `ADR-NNN-<decision>.md` — one file per decision
- Format: Context, Decision, Consequences

Verification Gate:
- [ ] Code review feedback addressed
- [ ] No critical security or performance warnings remain
- [ ] `$TGD_DIR/<feature-name>/REVIEW.md` exists and is non-empty

After completing, suggest: /tgd-ship.
