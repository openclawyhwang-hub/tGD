# /tgd-ship

Ship — deploy with confidence

Run the shipping-and-launch skill. This is the SHIP phase.

Pre-flight:
- Check review passed (no critical issues)
- Check tGD/review/REVIEW.md exists
- Check tests/ exists and passes
If missing, /tgd-review first.

Core flow:
1. git-workflow-and-versioning — clean commit history, trunk-based development
2. shipping-and-launch — pre-launch checklist, staged rollouts, monitoring

Conditional:
- CI/CD pipeline? -> ci-cd-and-automation
- Removing old systems? -> deprecation-and-migration

Faster is safer.
