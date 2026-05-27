---
description: Ship — pre-launch checklists, staged rollouts, rollback procedures
---

Run the `shipping-and-launch` skill. This is the SHIP phase — the full pipeline is:

**Core flow:**
1. `git-workflow-and-versioning` — clean commit history, trunk-based development
2. `shipping-and-launch` — pre-launch checklist, staged rollouts, monitoring setup

**Conditional (apply when relevant):**
- CI/CD pipeline? → `ci-cd-and-automation`
- Removing old systems? → `deprecation-and-migration`
- New architecture or API? → `documentation-and-adrs`

Faster is safer. Deploy in stages, confirm monitoring, and have a rollback plan.