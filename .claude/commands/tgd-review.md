---
description: Review — five-axis code review before merging any change
---

Run the `code-review-and-quality` skill. This is the REVIEW phase. The full pipeline is:

**Core flow:**
1. `code-review-and-quality` — five-axis review with severity labels (Nit/Optional/FYI), ~100 lines per change
2. `code-simplification` — apply Chesterton's Fence, reduce complexity while preserving exact behavior

**Conditional (apply when relevant):**
- Security concerns? → `security-and-hardening`
- Performance concerns? → `performance-optimization`

Improve code health before merge. If the change is larger than ~100 lines, split it into smaller reviews.

After completing the review, suggest the next step: `/tgd-ship` to deploy.
