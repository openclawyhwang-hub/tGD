---
description: Review before merge — improve code health
---

**🛑 Pre-flight: Environment Check**
- [ ] `$TGD_DIR/CONTEXT.md` exists (or `.codegraph/` is present).
- **If missing:** STOP. Tell user: "Project context not mapped. Please run `/tgd-map` first."
- **$TGD_DIR:** Resolve via `tGD/` symlink in project root. If missing, check `$TGD_DIR` env var. If neither exists: STOP — run `/tgd-map` first.

**🔑 Step 0: Feature Name Resolution**
1. Scan `tGD/` for subdirectories (e.g., `tGD/user-login/`).
2. If none found: 🛑 STOP. "No features defined. Run `/tgd-define` first."
3. If exactly one found: Lock it as `<feature-name>`.
4. If multiple found: List them and ask user to specify.
5. **Verify**: `$TGD_DIR/<feature-name>/SPEC.md` exists (defines scope).

**🔒 Pre-flight: Artifact Check**
- [ ] Test files exist in `tests/`.
- **If missing:** STOP. Tell user: "Tests are missing. Please run `/tgd-verify` first."

Run the `code-review-and-quality` skill. This is the REVIEW phase. The full pipeline is:

**Core flow:**
1. `code-review-and-quality` — five-axis review with severity labels (Nit/Optional/FYI), ~100 lines per change
2. `code-simplification` — apply Chesterton's Fence, reduce complexity while preserving exact behavior

**Conditional (apply when relevant):**
- Security concerns? → `security-and-hardening`
- Performance concerns? → `performance-optimization`

Improve code health before merge. If the change is larger than ~100 lines, split it into smaller reviews.

After completing the review, create `$TGD_DIR/<feature-name>/REVIEW.md` with:
- Code review findings (severity: Nit/Optional/FYI/Critical)
- Security scan results
- Performance analysis
- Simplification suggestions applied
- QA + DEV Sign-off

**Verification Gate:**
- [ ] Code review feedback addressed
- [ ] No critical security or performance warnings remain
- [ ] `$TGD_DIR/<feature-name>/REVIEW.md` exists and is non-empty

If verification passes, suggest the next step: `/tgd-ship` to deploy.
