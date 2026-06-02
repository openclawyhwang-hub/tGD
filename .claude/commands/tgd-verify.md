---
description: Verify — prove it works with debugging and test pyramid
---

**🛑 Pre-flight: Environment Check**
- [ ] `tGD/map/CONTEXT.md` exists (or `.codegraph/` is present).
- **If missing:** STOP. Tell user: "Project context not mapped. Please run `/tgd-map` first."

**🔑 Step 0: Feature Name Resolution**
1. Scan `tGD/` for subdirectories (e.g., `tGD/user-login/`).
2. If none found: 🛑 STOP. "No features defined. Run `/tgd-define` first."
3. If exactly one found: Lock it as `<feature-name>`.
4. If multiple found: List them and ask user to specify.
5. **Verify**: `tGD/define/SPEC.md` exists (defines scope).

**🔒 Pre-flight: Artifact Check**
- [ ] Source code files exist in `src/`.
- [ ] Test files exist in `tests/`.
- **If missing:** STOP. Tell user: "No source code or tests found. Please run `/tgd-develop` first."

Run the `debugging-and-error-recovery` skill. This is the VERIFY phase. The full pipeline is:

**Core flow:**
1. `debugging-and-error-recovery` — five-step triage: reproduce → localize → reduce → fix → guard
2. `test-driven-development` — verify with the test pyramid (80% unit, 15% integration, 5% E2E)

**Conditional (apply when relevant):**
- Browser-based? → `webwright` (preferred for E2E) or `browser-testing-with-devtools` (for debugging)

Verify that the feature works correctly before proceeding to review. Tests are proof — "seems right" is never sufficient.

After completing the verification, verify the outputs.

**Verification Gate:**
- [ ] Tests pass for the implemented feature

If verification passes, suggest the next step: `/tgd-review` to review the code quality.
