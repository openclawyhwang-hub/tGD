# /tgd-verify

Verify — prove it works with debugging and test pyramid

Run the debugging-and-error-recovery skill. This is the VERIFY phase.

Pre-flight:
- Check source code exists in src/. If missing, /tgd-develop first.
- Check test files exist in tests/. If missing, /tgd-develop first.

Core flow:
1. debugging-and-error-recovery — five-step triage: reproduce -> localize -> reduce -> fix -> guard
2. test-driven-development — verify with test pyramid (80% unit, 15% integration, 5% E2E)

Conditional:
- Browser-based? -> webwright or browser-testing-with-devtools

Tests are proof. "seems right" is never sufficient.

After completing, suggest: /tgd-review for code quality review.
