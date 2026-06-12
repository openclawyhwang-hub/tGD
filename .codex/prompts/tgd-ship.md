# /tgd-ship

Ship — deploy with confidence

Run the shipping-and-launch skill. This is the SHIP phase.

Pre-flight:
- Check review passed (no critical issues)
- Check $TGD_DIR/<feature>/REVIEW.md exists
- **$TGD_DIR:** Resolve via `tGD/` symlink in project root. If missing, check `$TGD_DIR` env var. If neither exists: STOP — run `/tgd-map` first.
- Check tests/ exists and passes
If missing, /tgd-review first.

Core flow:
1. git-workflow-and-versioning — clean commit history, trunk-based development
2. shipping-and-launch — pre-launch checklist, staged rollouts, monitoring

Conditional:
- CI/CD pipeline? -> ci-cd-and-automation
- Removing old systems? -> deprecation-and-migration

Faster is safer.

After shipping, update `$TGD_DIR/CHANGELOG.md` (create if it doesn't exist) with:
- Version (CalVer: `vYYYY.MM.DD`)
- Feature name and summary
- Date shipped
- Key changes

Verification Gate:
- [ ] Git commit created with clean history
- [ ] `$TGD_DIR/CHANGELOG.md` exists and is updated
