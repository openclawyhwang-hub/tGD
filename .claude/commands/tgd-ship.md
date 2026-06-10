---
description: Ship to production — faster is safer
---

**🛑 Pre-flight: Environment Check**
- [ ] `$TGD_DIR/CONTEXT.md` exists (or `.codegraph/` is present).
- **If missing:** STOP. Tell user: "Project context not mapped. Please run `/tgd-map` first."

**🔑 Step 0: Feature Name Resolution**
1. Scan `tGD/` for subdirectories (e.g., `tGD/user-login/`).
2. If none found: 🛑 STOP. "No features defined. Run `/tgd-define` first."
3. If exactly one found: Lock it as `<feature-name>`.
4. If multiple found: List them and ask user to specify.
5. **Verify**: `$TGD_DIR/<feature-name>/SPEC.md` exists (defines scope).

**🔒 Pre-flight: Artifact Check**
- [ ] Review passed (no critical issues).
- [ ] `$TGD_DIR/<feature>/REVIEW.md` exists.
- [ ] `tests/` exists and passes.
- **If missing:** STOP. Tell user: "Review or tests incomplete. Please run `/tgd-review` first."

Run the `shipping-and-launch` skill. This is the SHIP phase. The full pipeline is:

**Core flow:**
1. `git-workflow-and-versioning` — clean commit history, trunk-based development
2. `shipping-and-launch` — pre-launch checklist, staged rollouts, monitoring setup

**Conditional (apply when relevant):**
- CI/CD pipeline work? → `ci-cd-and-automation`
- Removing old systems? → `deprecation-and-migration`
- New architecture or API? → `documentation-and-adrs`

Faster is safer. Deploy in stages, confirm monitoring, and have a rollback plan.

After completing the ship process, verify the outputs.

**Verification Gate:**
- [ ] Git commit created with clean history
- [ ] CHANGELOG.md updated

If verification passes, confirm that monitoring is active and the rollback plan is documented.
