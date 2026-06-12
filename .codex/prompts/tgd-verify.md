# /tgd-verify

Verify — prove it works with debugging and test pyramid

Run the debugging-and-error-recovery skill. This is the VERIFY phase.

Pre-flight:
- Check source code exists in src/. If missing, /tgd-develop first.
- Check test files exist in tests/. If missing, /tgd-develop first.

Core flow:
1. debugging-and-error-recovery — five-step triage: reproduce -> localize -> reduce -> fix -> guard
2. test-driven-development — verify with test pyramid (80% unit, 15% integration, 5% E2E)

**Conditional (Frontend Mandatory):**
- **Frontend/UI/DOM?** → **MUST run `agent-browser`**. Unit tests are NOT sufficient for UI verification.
- **Verification Gate Failure**: If the feature touches frontend code but `agent-browser` did not run, the verification is FAILED.

Tests are proof. "seems right" is never sufficient.

After completing, create `$TGD_DIR/<feature-name>/TEST-REPORT.md` with:
- Test results summary (pass/fail counts)
- Coverage report (if available)
- Regression test status
- Any failures and their root causes

Verification Gate:
- [ ] Tests pass for the implemented feature
- [ ] `$TGD_DIR/<feature-name>/TEST-REPORT.md` exists and is non-empty

After completing, suggest: /tgd-review for code quality review.
