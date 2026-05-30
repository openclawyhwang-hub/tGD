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

After completing, suggest: /tgd-simplify or /tgd-ship.
