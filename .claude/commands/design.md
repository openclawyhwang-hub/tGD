---
description: Generate UI designs from spec — create Figma screens, capture screenshots, and submit for human review
---

Invoke the agent-skills:design-system skill.

**Pre-flight check:** Verify that SPEC.md exists and has been approved. If missing, run `/spec` first.

## Phase A — Analyze & Generate

1. Read SPEC.md and extract all user-facing features
2. Read `.planning/CONTEXT.md` if it exists (respect constraints)
3. Create a screen inventory (list every page and shared component)
4. Generate Figma designs for every screen:
   - Mobile variant (320px)
   - Desktop variant (1440px)
   - Include loading, error, and empty states
5. Capture PNG screenshots of each design
6. Define design tokens (colors, typography, spacing, border-radius)

## Phase B — Human Review

1. Run the design review script to create Jira tickets:
   ```bash
   python scripts/create_design_review_ticket.py \
     --consolidated \
     --figma "https://figma.com/file/ABC123" \
     --screenshots-dir "screenshots/" \
     --tokens "design-tokens.md"
   ```
2. Attach screenshots to the Jira ticket
3. Set status to "Design Review"
4. Assign to human reviewer
5. **Wait** for human review outcome

## Phase C — Outcome

**If Design Approved:**
1. Extract DESIGN_SPEC.md from Figma designs
2. Include: tokens, screen specs, component hierarchy, responsive breakpoints
3. Save DESIGN_SPEC.md to project root
4. Transition Jira to "Design Approved"
5. Run `/plan` — tasks will reference both SPEC.md and DESIGN_SPEC.md

**If Design Revision:**
1. Read revision comments from Jira
2. Update Figma designs
3. Regenerate screenshots
4. Update Jira ticket with new screenshots
5. Transition back to "Design Review"
6. Wait for re-review

## Rules

1. Design ALL screens — not just the happy path
2. Include loading, error, and empty states for every screen
3. Use realistic placeholder content — no Lorem ipsum
4. Avoid the "AI aesthetic" (purple gradients, excessive rounding, stock card grids)
5. Mobile-first responsive — design mobile first, then expand
6. Design tokens must be consistent across all screens
7. Screenshots MUST be attached to Jira review ticket
8. Do not proceed to `/plan` until DESIGN_SPEC.md exists
