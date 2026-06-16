
**🛑 Pre-flight: Environment Check**
- [ ] `$TGD_DIR/CONTEXT.md` exists (or `.codegraph/` is present).
- **If missing:** STOP. Tell user: "Project context not mapped. Please run `/tgd-map` first."
- **$TGD_DIR:** Check env var `$TGD_DIR` first. If not set, check sibling `../<project-name>-tGD/`. If neither exists: STOP — run `/tgd-map` first.

**🔑 Step 0: Feature Name Resolution**
1. Scan `$TGD_DIR/` for subdirectories (e.g., `$TGD_DIR/user-login/`).
2. If none found: 🛑 STOP. "No features defined. Run `/tgd-define` first."
3. If exactly one found: Lock it as `<feature-name>`.
4. If multiple found: List them and ask user to specify.
5. **Verify**: `$TGD_DIR/<feature-name>/SPEC.md` exists (defines scope).

**🔒 Pre-flight: Artifact Check**
- [ ] Source code files exist in `src/`.
- [ ] Test files exist in `tests/`.
- **If missing:** STOP. Tell user: "No source code or tests found. Please run `/tgd-develop` first."

Run the `debugging-and-error-recovery` skill. This is the VERIFY phase. The full pipeline is:

**Core flow:**
1. `debugging-and-error-recovery` — five-step triage: reproduce → localize → reduce → fix → guard
2. `test-driven-development` — verify with the test pyramid (80% unit, 15% integration, 5% E2E)
   - Use `codegraph affected <changed-files>` to identify which tests to prioritize based on actual dependency paths.

**Conditional (Frontend Mandatory):**
- **Frontend/UI/DOM?** → **MUST run `agent-browser`**. Unit tests are NOT sufficient for UI verification.
  - Use `agent-browser` (preferred) to open the browser, perform the user action, and verify the DOM state.
  - **Verification Gate Failure**: If the feature touches frontend code but `agent-browser` did not run, the verification is FAILED.

Verify that the feature works correctly before proceeding to review. Tests are proof — "seems right" is never sufficient.

After completing the verification, create `$TGD_DIR/<feature-name>/TEST-REPORT.md` using this template:
 
```markdown
# TEST-REPORT: [Feature Name]
 
> **Date**: YYYY-MM-DD
 
## 1. Test Summary
| Suite | Passed | Failed | Skipped |
|-------|--------|--------|---------|
| Unit | | | |
| Integration | | | |
| E2E | | | |
 
Exit code: `0` (PASS) / `1` (FAIL)
 
## 2. Coverage
| Metric | Value |
|--------|-------|
| Lines | |
| Branches | |
| Functions | |
 
## 3. Failures & Root Causes
| Test | Error | Root Cause | Fix Applied |
|------|-------|------------|-------------|
 
## 4. Regression Status
- [ ] All entries in `$TGD_DIR/REGRESSION-CATALOG.md` pass (if catalog exists)
- [ ] No cross-feature regressions introduced
 
## Sign-off
- [ ] **QA**: (pending)
```

**🛡️ Cross-Feature Regression Gate (MANDATORY if `$TGD_DIR/REGRESSION-CATALOG.md` exists)**
1. Read `$TGD_DIR/REGRESSION-CATALOG.md`.
2. For EACH entry: locate the test file, run it, confirm it passes.
3. If ANY regression test fails: 🛑 STOP. Report which prior feature's regression test broke. Do NOT proceed to review.
- **Verification Gate Failure**: A broken regression test means your feature broke a previously shipped critical path. This is a hard fail — no exceptions.

**Verification Gate:**
- [ ] Tests pass for the implemented feature
- [ ] `$TGD_DIR/<feature-name>/TEST-REPORT.md` exists and is non-empty
- [ ] All regression tests in `$TGD_DIR/REGRESSION-CATALOG.md` still pass (if catalog exists)

If verification passes, suggest the next step: `/tgd-review` to review the code quality.
