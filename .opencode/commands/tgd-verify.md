---
description: Verify — prove it works with debugging and test pyramid
---

Run the `debugging-and-error-recovery` skill. This is the VERIFY phase. The full pipeline is:

**Core flow:**
1. `debugging-and-error-recovery` — five-step triage: reproduce → localize → reduce → fix → guard
2. `test-driven-development` — verify with the test pyramid (80% unit, 15% integration, 5% E2E)

**Conditional (apply when relevant):**
- Browser-based? → `browser-testing-with-devtools`

Verify that the feature works correctly before proceeding to review. Tests are proof — "seems right" is never sufficient.

After completing verification, suggest the next step: `/tgd-review` to review the code quality.
