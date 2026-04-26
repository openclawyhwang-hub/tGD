---
name: design-system
description: Generates UI designs from specs with context-aware design system adherence. Use when SPEC.md includes user-facing UI and you need to create visual designs before implementation. Automatically collects existing design tokens, generates consistent designs, and manages human review via Jira.
---

# Design System

## Overview

Transform approved specifications into visual designs that respect existing company design systems. This skill ensures new UI designs are visually consistent with established brand guidelines, design tokens, and design libraries — not generic "AI aesthetic" output.

**Supports multiple design tools:** Figma MCP, Stitch MCP, or HTML/CSS fallback.

## When to Use

- SPEC.md has been approved and includes user-facing UI
- Designing new screens, components, or full-page layouts
- Extending an existing design system with new patterns
- Human review of designs is required before implementation begins

**When NOT to use:**
- Backend-only features (APIs, databases, background jobs)
- Minor UI tweaks that don't require full design review
- Single-line CSS changes

## The Gated Workflow

```
CONTEXT ──▶ GENERATE ──▶ REVIEW ──▶ APPROVED/REVISED
   │           │             │            │
   ▼           ▼             ▼            ▼
Collect    Create Figma   Human       Design Approved
tokens     Screenshots    Review      → Extract DESIGN_SPEC
                      ↓
                Design Revision
                    → Modify
                    → Re-review
```

### Phase 0: Collect Existing Design Context

**Before generating any designs, understand what already exists.** This prevents visual inconsistency and ensures new screens match established patterns.

#### Step 1: Check for Existing Assets

```
Checklist:
├── Does design-tokens.md exist in project root? → Read it
├── Are there CSS custom properties in the codebase? → Extract them
├── Is there an existing Figma design system file? → Reference it
├── Does .planning/CONTEXT.md mention design constraints? → Read it
└── Are there existing UI screenshots or brand guidelines? → Collect them
```

**Extract from codebase if no design-tokens.md:**

```bash
# Find CSS custom properties
grep -r '\-\-' src/ --include="*.css" --include="*.scss" | head -50

# Find Tailwind config
cat tailwind.config.js

# Find theme files
find src/ -name "theme*" -o -name "tokens*" -o -name "variables*"
```

#### Step 2: Ask the Human for Missing Context

If design tokens or Figma files are not found, ask the human directly:

```
DESIGN CONTEXT CHECK:

I couldn't find existing design tokens in the codebase. Please provide:

1. Company design system (if any):
   - Figma file link: ?
   - Design token file: ?
   - Brand guidelines: ?

2. If no existing design system:
   - Any brand colors I should use?
   - Preferred font family?
   - Reference sites you like the look of?

→ Please provide what you have, and I'll work from there.
```

#### Step 3: Create or Update design-tokens.md

If tokens were found in the codebase, create `design-tokens.md`:

```markdown
# Design Tokens

> Extracted from existing codebase on 2026-04-26
> Source: src/styles/variables.css, tailwind.config.js

## Colors

| Token | Value | Usage |
|-------|-------|-------|
| primary | #3B82F6 | CTAs, links, active states |
| primary-hover | #2563EB | Hover states |
| secondary | #10B981 | Success states |
| error | #EF4444 | Error messages |
| warning | #F59E0B | Warning states |
| surface | #F8FAFC | Page background |
| card | #FFFFFF | Card backgrounds |
| text-primary | #0F172A | Body text |
| text-secondary | #64748B | Helper text |
| border | #E2E8F0 | Borders, dividers |

## Typography

| Level | Font | Size | Weight | Line Height | Usage |
|-------|------|------|--------|-------------|-------|
| display-lg | Manrope | 56px | 700 | 1.1 | Page titles |
| h1 | Manrope | 40px | 700 | 1.2 | Section titles |
| h2 | Manrope | 32px | 600 | 1.3 | Subsection titles |
| body-lg | Inter | 18px | 400 | 1.6 | Lead text |
| body-md | Inter | 16px | 400 | 1.5 | Body text |
| body-sm | Inter | 14px | 400 | 1.4 | Small text |
| label-md | Inter | 12px | 500 | 1.0 | Form labels |

## Spacing

Base unit: 4px

| Token | Value | Usage |
|-------|-------|-------|
| space-xs | 4px | Tight gaps |
| space-sm | 8px | Component internals |
| space-md | 16px | Standard gap |
| space-lg | 24px | Section gaps |
| space-xl | 32px | Page sections |
| space-2xl | 48px | Major sections |

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| radius-sm | 4px | Buttons, inputs, badges |
| radius-md | 8px | Cards, dropdowns |
| radius-lg | 12px | Modals, sheets |

## Shadows

| Token | Value | Usage |
|-------|-------|-------|
| shadow-sm | 0 1px 2px rgba(0,0,0,0.05) | Subtle elevation |
| shadow-md | 0 4px 8px rgba(0,0,0,0.08) | Cards |
| shadow-lg | 0 8px 32px rgba(0,0,0,0.12) | Modals, dropdowns |

## Existing Figma Files

- Main Design System: https://figma.com/file/ABC123
- Component Library: https://figma.com/file/DEF456

## Notes

- Dark mode tokens are NOT yet defined — will need to be created for new screens
- Component library was last updated 2026-03-15
```

**If no existing design system exists**, create a proposed `design-tokens.md` based on SPEC.md and ask the human to confirm:

```markdown
# Design Tokens (Proposed)

> Proposed based on SPEC.md requirements. Please confirm or modify.
```

### Phase 1: Analyze & Plan Designs

After design context is collected, understand the full scope:

1. **Read SPEC.md** — Extract all user-facing features
2. **Read design-tokens.md** — Use these tokens for ALL designs
3. **Read `.planning/CONTEXT.md`** — If exists, respect all constraints
4. **Identify all screens** — List every unique view the user will see
5. **Identify shared components** — Buttons, cards, forms, navigation, modals
6. **Identify gaps** — What components/patterns are NOT in the existing design system?

**Screen Inventory Template:**

```markdown
# Screen Inventory

## Pages
1. [Homepage] — Main dashboard with metrics overview
2. [Task List] — Filterable, paginated task table
3. [Task Detail] — Full task view with comments
4. [Settings] — User preferences and account management

## Shared Components
- Navigation bar (all pages) — ✅ exists in design system
- Task card (list + detail) — ✅ exists in design system
- Modal dialog (create/edit) — ✅ exists in design system
- Status badge (all pages) — 🆕 NEW: needs to be added to design system

## Design Gaps
- No dark mode tokens defined → propose dark variant
- No status badge component → propose new component
```

### Phase 2: Generate Designs

Create visual designs for every screen identified in Phase 1.

**Choose one design tool based on your setup:**

| Tool | When to Use | Required | Output |
|------|-------------|----------|--------|
| **Figma MCP** (推薦) | 團隊專案、已有 Figma | `FIGMA_ACCESS_TOKEN` | Figma file + screenshots |
| **Stitch** | 快速原型、個人開發 | `STITCH_API_KEY` | Stitch screens + screenshots |
| **HTML/CSS** | 無設計工具 | 無 | HTML prototype + screenshots |

#### Option A: Figma MCP (推薦)

1. Read `skills/figma-generate-design/SKILL.md` for full workflow
2. Follow Figma skill's required workflow:
   - Step 1: Understand the deliverable
   - Step 2: Collect component keys, variables, and styles
   - Step 3: Create wrapper frame
   - Step 4: Build each section incrementally
   - Step 5: Validate with screenshots
3. Use `design-tokens.md` for all color, spacing, and typography values
4. Export screenshots for each screen (mobile + desktop)

**Screenshot naming convention:**
```
screenshots/
  homepage-mobile.png
  homepage-desktop.png
  task-list-mobile.png
  task-list-desktop.png
```

#### Option B: Stitch MCP

1. Use Stitch MCP tool to generate screens from spec
2. Reference `design-tokens.md` for all design values
3. Generate both mobile and desktop variants
4. Export screenshots for Jira attachment

#### Option C: HTML/CSS Fallback

1. Generate HTML/CSS prototype for each screen
2. Use `design-tokens.md` for all colors, fonts, spacing
3. Save as `screenshots/{screen-name}.html`
4. Take screenshots for Jira attachment

#### Design Principles (All Options)

- **Follow existing design tokens** — Every color, font, spacing value must come from design-tokens.md
- **Data-first hierarchy** — Most important information is visually dominant
- **Tonal sectioning** — Use background color shifts, not lines, to separate sections
- **Premium restraint** — No generic "AI aesthetic" (purple gradients, excessive rounded corners, stock card grids)
- **Responsive by default** — Mobile-first, then expand to tablet and desktop
- **Accessible** — WCAG 2.1 AA contrast, keyboard navigation, screen reader compatible

#### Avoiding the AI Aesthetic

| AI Default | Production Quality |
|---|---|
| Purple/indigo everything | Use tokens from design-tokens.md |
| Excessive gradients | Flat or subtle gradients matching the design system |
| Rounded everything (rounded-2xl) | Consistent border-radius from design tokens |
| Generic hero sections | Content-first layouts driven by SPEC requirements |
| Lorem ipsum | Realistic placeholder content |
| Oversized padding everywhere | Consistent spacing scale from design tokens |
| Stock card grids | Purpose-driven layouts based on information priority |
| Shadow-heavy design | Subtle shadows from design tokens only |

### Phase 3: Human Review (Jira)

After all designs are generated, create a structured review ticket in Jira.

#### Step 1: Generate Screenshots

Capture PNG previews of each design for Jira attachment.

#### Step 2: Create Jira Design Review Ticket

Execute the Python script:

```bash
python scripts/create_design_review_ticket.py \
  --consolidated \
  --design-tool "figma" \  # or "stitch" or "html"
  --design-url "https://figma.com/file/ABC123" \  # or Stitch project URL or HTML path
  --screenshots-dir "screenshots/" \
  --tokens "design-tokens.md"
```

#### Jira Ticket Content

```markdown
# Design Review: All Screens

## Design File
🔗 Design Tool: Figma / Stitch / HTML
🔗 Link: https://figma.com/file/ABC123 (or appropriate URL)

## Screenshots
📎 homepage-desktop.png
📎 homepage-mobile.png
📎 task-list-desktop.png
📎 task-list-mobile.png

## Design Consistency
- ✅ Colors: Follow existing design tokens (design-tokens.md)
- ✅ Typography: Inter body, Manrope display (existing)
- 🆕 New: Status badge component (not in existing design system)
- ✅ Spacing: 4px base scale (existing)
- ✅ Shadows: shadow-sm, shadow-md (existing)

## Review Checklist
- [ ] Colors match design tokens
- [ ] Typography hierarchy correct (h1 → h2 → h3 → body)
- [ ] Responsive breakpoints work (320px, 768px, 1024px, 1440px)
- [ ] Shared components consistent across screens
- [ ] Loading, error, and empty states included
- [ ] Keyboard navigation paths clear
- [ ] New components fit with existing design system

## Design Decisions
1. **Status badge:** New component proposed — follows existing color tokens
2. **Dark mode:** Not included in this round — will be a separate ticket
3. **Layout:** Tonal sectioning (no dividers) per existing pattern
```

#### Ticket Properties

| Field | Value |
|-------|-------|
| **Type** | Task |
| **Labels** | design, review, ui |
| **Status** | Design Review |
| **Assignee** | Human reviewer |

### Phase 4: Review Outcome

#### ✅ Design Approved

When human sets status to "Design Approved":

1. **Extract DESIGN_SPEC.md** — Convert designs into implementation-ready specifications
   - For Figma: Use `figma-implement-design` skill to extract component specs
   - For Stitch: Export screen specs from Stitch project
   - For HTML: Extract component structure from HTML prototype
2. **Include in DESIGN_SPEC.md:**
   - Screen-by-screen layout descriptions
   - Component hierarchy (parent → children)
   - Design tokens used (reference design-tokens.md)
   - New components (if any) with specs
   - Responsive breakpoints
   - State specifications (loading, error, empty, hover, focus)
   - Accessibility requirements per screen

**DESIGN_SPEC.md Template:**

```markdown
# Design Spec: [Project Name]

> Based on design-tokens.md (extracted from existing codebase)

## Tokens Used

All colors, fonts, spacing, and shadows come from `design-tokens.md`.
See that file for the full token list.

## New Components

| Component | Status | Spec |
|-----------|--------|------|
| StatusBadge | 🆕 NEW | See component spec below |

### StatusBadge
- **Purpose:** Display task status with color coding
- **Variants:** pending (warning), in_progress (primary), completed (secondary), cancelled (text-secondary)
- **Size:** 20px height, padding 0-8px
- **Font:** label-md (12px, 500 weight)
- **Border radius:** radius-sm (4px)

## Screen Specifications

### Homepage
- **Layout:** Dashboard grid, 3-column on desktop, 1-column on mobile
- **Components:** MetricCard × 4, ChartArea × 2, RecentActivity × 1
- **Tokens used:** surface, card, shadow-md, h1, body-md
- **States:** Loading skeleton, empty state, error boundary
- **Responsive:** Collapses to single column at 768px

### Task List
- **Layout:** Full-width table with filters above
- **Components:** FilterBar, DataTable, Pagination, StatusBadge
- **Tokens used:** card, border, body-md, label-md
- **States:** Loading, empty (no tasks), error, zero results (filtered)
- **Responsive:** Table → card list at 768px
```

3. **Save DESIGN_SPEC.md** to project root
4. **Transition Jira** to "Design Approved"
5. **Proceed to PLAN phase** — tasks will reference both SPEC.md and DESIGN_SPEC.md

#### 📝 Design Revision

When human sets status to "Design Revision":

1. **Read revision comments** from Jira ticket
2. **Update Figma designs** based on feedback
3. **Regenerate screenshots**
4. **Update Jira ticket** with new screenshots and notes
5. **Transition back to "Design Review"**
6. **Wait for re-review**

Repeat until approved.

### Phase 5: Handoff to PLAN

After design approval:

1. **Confirm DESIGN_SPEC.md exists** and is complete
2. **Run `/plan`** — task breakdown will use both SPEC.md and DESIGN_SPEC.md
3. **Each task references design** — AC includes design spec section

**PLAN phase receives:**
- SPEC.md (what to build)
- DESIGN_SPEC.md (how it should look)
- design-tokens.md (exact token values)
- CONTEXT.md (constraints, if brownfield)

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Skip design, just build it" | Building without design leads to inconsistent UI and multiple rework cycles |
| "Design can wait until after implementation" | Retrofitting design is 3x harder than designing first |
| "The developer will figure out the UI" | Developers optimize for functionality, not visual consistency. Design first prevents UI debt |
| "One screen is enough, the rest will be similar" | Every screen has unique layout needs. Design all screens to catch inconsistencies early |
| "I'll use my own colors, the design system is boring" | Inconsistent colors break the user's sense of a unified product |
| "Figma is too slow, just describe it in text" | Visual designs catch issues text descriptions miss (spacing, hierarchy, responsive behavior) |

## Red Flags

- Starting implementation without design approval
- Only designing the "happy path" screen (missing loading, error, empty states)
- Using Lorem ipsum instead of realistic content
- No responsive variants (desktop-only or mobile-only)
- Design tokens not defined (colors/fonts hardcoded per screen)
- Screenshots not attached to Jira review ticket
- DESIGN_SPEC.md missing after design approval
- New components that don't fit with existing design system
- Using colors or fonts not in design-tokens.md without human approval
- Design review ticket assigned to agent instead of human

## Verification

After completing the design phase:

- [ ] Existing design tokens collected (from codebase or human-provided)
- [ ] design-tokens.md exists and is referenced by all designs
- [ ] All screens from SPEC.md have Figma designs
- [ ] Screenshots exist for every screen (mobile + desktop)
- [ ] Jira Design Review ticket created with screenshots attached
- [ ] Design consistency report included (what's existing vs new)
- [ ] Review checklist included in ticket description
- [ ] Human has reviewed and set status to "Design Approved"
- [ ] DESIGN_SPEC.md extracted and saved to project root
- [ ] DESIGN_SPEC.md references design-tokens.md for all token values
- [ ] PLAN phase can proceed with SPEC.md + DESIGN_SPEC.md + design-tokens.md
