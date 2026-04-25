---
name: design-system
description: Generates UI designs from specs and manages human review workflow. Use when you have an approved SPEC.md and need to create visual designs before breaking down implementation tasks. Use when designing UI screens, design tokens, responsive layouts, or when a design review by humans is needed.
---

# Design System

## Overview

Transform approved specifications into visual designs with a structured human review workflow. This skill bridges the gap between requirements (SPEC.md) and implementation (Jira tasks) by producing design artifacts that ensure visual consistency before any code is written.

## When to Use

- SPEC.md has been approved and you need visual designs before planning
- Designing new UI screens, components, or full-page layouts
- Establishing or updating design tokens (colors, typography, spacing)
- Creating responsive layouts (mobile, tablet, desktop)
- Human review of designs is required before implementation begins

**When NOT to use:**
- Backend-only features (APIs, databases, background jobs)
- Minor UI tweaks that don't require full design review
- Single-line CSS changes

## The Gated Workflow

```
SPEC APPROVED ──▶ GENERATE ──▶ REVIEW ──▶ APPROVED/REVISED
     │               │             │            │
     ▼               ▼             ▼            ▼
  Read SPEC     Create Figma    Human       Design Approved
  + CONTEXT    Screenshots     Review      → Extract DESIGN_SPEC
                                  ↓
                            Design Revision
                                → Modify
                                → Re-review
```

### Phase 1: Analyze & Extract

Before generating any designs, understand the full scope:

1. **Read SPEC.md** — Extract all user-facing features
2. **Read `.planning/CONTEXT.md`** — If exists, respect all constraints (existing patterns, forbidden modifications, injection points)
3. **Identify all screens** — List every unique view the user will see
4. **Identify shared components** — Buttons, cards, forms, navigation, modals
5. **Identify design tokens** — Colors, typography, spacing, border-radius

**Screen Inventory Template:**

```markdown
# Screen Inventory

## Pages
1. [Homepage] — Main dashboard with metrics overview
2. [Task List] — Filterable, paginated task table
3. [Task Detail] — Full task view with comments
4. [Settings] — User preferences and account management

## Shared Components
- Navigation bar (all pages)
- Task card (list + detail)
- Modal dialog (create/edit)
- Status badge (all pages)

## Design Tokens
- Primary: #3B82F6 (signal blue)
- Secondary: #10B981 (success green)
- Error: #EF4444
- Font: Inter (body), Manrope (display)
- Spacing scale: 4px base
```

### Phase 2: Generate Designs

Create visual designs for every screen identified in Phase 1.

#### Design Principles

- **Data-first hierarchy** — Most important information is visually dominant
- **Tonal sectioning** — Use background color shifts, not lines, to separate sections
- **Premium restraint** — No generic "AI aesthetic" (purple gradients, excessive rounded corners, stock card grids)
- **Responsive by default** — Mobile-first, then expand to tablet and desktop
- **Accessible** — WCAG 2.1 AA contrast, keyboard navigation, screen reader compatible

#### Output Format

For each screen, produce:

1. **Figma design** — The actual design file
2. **Screenshot** — PNG preview for Jira attachment
3. **Design notes** — Brief explanation of key decisions

**Screenshot naming convention:**
```
screenshots/
  homepage-mobile.png
  homepage-desktop.png
  task-list-mobile.png
  task-list-desktop.png
  task-detail-mobile.png
  task-detail-desktop.png
  settings-mobile.png
  settings-desktop.png
```

#### Avoiding the AI Aesthetic

| AI Default | Production Quality |
|---|---|
| Purple/indigo everything | Use the project's actual color palette from SPEC.md |
| Excessive gradients | Flat or subtle gradients matching the design system |
| Rounded everything (rounded-2xl) | Consistent border-radius from design tokens |
| Generic hero sections | Content-first layouts driven by SPEC requirements |
| Lorem ipsum | Realistic placeholder content |
| Oversized padding everywhere | Consistent spacing scale (4px base) |
| Stock card grids | Purpose-driven layouts based on information priority |
| Shadow-heavy design | Subtle or no shadows unless design system specifies |

### Phase 3: Human Review (Jira)

After all designs are generated, create a structured review ticket in Jira.

#### Step 1: Generate Screenshots

Capture PNG previews of each design for Jira attachment.

#### Step 2: Create Jira Design Review Ticket

Execute the Python script for **each screen** (or one consolidated ticket for small projects):

```bash
# Per-screen review
python scripts/create_design_review_ticket.py \
  --screen "Homepage" \
  --figma "https://figma.com/file/ABC123" \
  --screenshot "screenshots/homepage-desktop.png" \
  --tokens "design-tokens.md"

# Or consolidated review (all screens in one ticket)
python scripts/create_design_review_ticket.py \
  --consolidated \
  --figma "https://figma.com/file/ABC123" \
  --screenshots-dir "screenshots/" \
  --tokens "design-tokens.md"
```

#### Jira Ticket Content

```markdown
# Design Review: [Screen Name]

## Design File
🔗 Figma: https://figma.com/file/ABC123

## Screenshot
📎 [attached screenshot]

## Design Notes
- Layout: Mobile-first responsive (320px → 1440px)
- Color system: Signal blue primary, tonal sectioning
- Typography: Manrope display, Inter body
- Spacing: 4px base scale
- Accessibility: WCAG 2.1 AA contrast ratios

## Review Checklist
- [ ] Colors match design tokens
- [ ] Typography hierarchy correct (h1 → h2 → h3 → body)
- [ ] Responsive breakpoints work (320px, 768px, 1024px, 1440px)
- [ ] Shared components consistent across screens
- [ ] Loading, error, and empty states included
- [ ] Keyboard navigation paths clear
- [ ] No "AI aesthetic" patterns (purple gradients, excessive rounding)

## Design Decisions
1. **Why tonal sectioning over dividers?** — Reduces visual noise, cleaner scan paths
2. **Why Manrope for display?** — Higher x-height improves data readability
3. **Why 4px spacing base?** — More granular control for dense data layouts
```

#### Ticket Properties

| Field | Value |
|-------|-------|
| **Type** | Design Review |
| **Status** | Design Review |
| **Assignee** | Human reviewer |
| **Priority** | Medium |
| **Labels** | design, review, ui |

### Phase 4: Review Outcome

#### ✅ Design Approved

When human sets status to "Design Approved":

1. **Extract DESIGN_SPEC.md** — Convert Figma designs into implementation-ready specifications
2. **Include in DESIGN_SPEC.md:**
   - Screen-by-screen layout descriptions
   - Component hierarchy (parent → children)
   - Design tokens (colors, fonts, spacing, border-radius)
   - Responsive breakpoints
   - State specifications (loading, error, empty, hover, focus)
   - Accessibility requirements per screen

**DESIGN_SPEC.md Template:**

```markdown
# Design Spec: [Project Name]

## Design Tokens

### Colors
| Token | Value | Usage |
|-------|-------|-------|
| primary | #3B82F6 | CTAs, links, active states |
| secondary | #10B981 | Success states |
| error | #EF4444 | Error messages, destructive actions |
| surface | #F8FAFC | Page background |
| card | #FFFFFF | Card backgrounds |

### Typography
| Level | Font | Size | Weight | Usage |
|-------|------|------|--------|-------|
| display-lg | Manrope | 56px | 700 | Page titles |
| body-md | Inter | 16px | 400 | Body text |
| label-md | Inter | 12px | 500 | Form labels |

### Spacing
Base: 4px → 4, 8, 12, 16, 24, 32, 48, 64

### Border Radius
- Small: 4px (buttons, inputs)
- Medium: 8px (cards)
- Large: 12px (modals)

## Screen Specifications

### Homepage
- **Layout:** Dashboard grid, 3-column on desktop, 1-column on mobile
- **Components:** MetricCard × 4, ChartArea × 2, RecentActivity × 1
- **States:** Loading skeleton, empty state, error boundary
- **Responsive:** Collapses to single column at 768px

### Task List
- **Layout:** Full-width table with filters above
- **Components:** FilterBar, DataTable, Pagination, StatusBadge
- **States:** Loading, empty (no tasks), error, zero results (filtered)
- **Responsive:** Table → card list at 768px
```

3. **Save DESIGN_SPEC.md** to project root
4. **Transition Jira** to "Design Approved"
5. **Proceed to PLAN phase** — tasks will reference DESIGN_SPEC.md

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
- CONTEXT.md (constraints, if brownfield)

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Skip design, just build it" | Building without design leads to inconsistent UI and multiple rework cycles |
| "Design can wait until after implementation" | Retrofitting design is 3x harder than designing first |
| "The developer will figure out the UI" | Developers optimize for functionality, not visual consistency. Design first prevents UI debt |
| "One screen is enough, the rest will be similar" | Every screen has unique layout needs. Design all screens to catch inconsistencies early |
| "Figma is too slow, just describe it in text" | Visual designs catch issues text descriptions miss (spacing, hierarchy, responsive behavior) |

## Red Flags

- Starting implementation without design approval
- Only designing the "happy path" screen (missing loading, error, empty states)
- Using Lorem ipsum instead of realistic content
- No responsive variants (desktop-only or mobile-only)
- Design tokens not defined (colors/fonts hardcoded per screen)
- Screenshots not attached to Jira review ticket
- DESIGN_SPEC.md missing after design approval
- Design review ticket assigned to agent instead of human

## Verification

After completing the design phase:

- [ ] All screens from SPEC.md have Figma designs
- [ ] Screenshots exist for every screen (mobile + desktop)
- [ ] Jira Design Review ticket(s) created with screenshots attached
- [ ] Review checklist included in ticket description
- [ ] Design tokens defined and consistent across all screens
- [ ] Loading, error, and empty states designed for each screen
- [ ] Human has reviewed and set status to "Design Approved"
- [ ] DESIGN_SPEC.md extracted and saved to project root
- [ ] DESIGN_SPEC.md includes: tokens, screen specs, component hierarchy, responsive breakpoints
- [ ] PLAN phase can proceed with both SPEC.md and DESIGN_SPEC.md
