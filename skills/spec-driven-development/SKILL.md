---
name: spec-driven-development
description: Creates specs before coding. Use when starting a new project, feature, or significant change and no specification exists yet. Use when requirements are unclear, ambiguous, or only exist as a vague idea.
---

# Spec-Driven Development

## Overview

Write a structured specification before writing any code. The spec is the shared source of truth between you and the human engineer — it defines what we're building, why, and how we'll know it's done. Code without a spec is guessing.

## When to Use

- Starting a new project or feature
- Requirements are ambiguous or incomplete
- The change touches multiple files or modules
- You're about to make an architectural decision
- The task would take more than 30 minutes to implement

**When NOT to use:** Single-line fixes, typo corrections, or changes where requirements are unambiguous and self-contained.

## The Gated Workflow

Spec-driven development has four phases. Do not advance to the next phase until the current one is validated.

**Step 0: Feature Name Resolution**
Before writing any content, determine the `<feature-name>`:
1. Derive a kebab-case slug from the user's request (e.g., "User Login" → `user-login`, "Add Dashboard" → `add-dashboard`).
2. **Create directory**: `mkdir -p tGD/<feature-name>/`.
3. **Verify**: If `tGD/<feature-name>/` already exists, use it. If not, the previous step must have created it.
4. **Lock**: Use this exact `<feature-name>` for all subsequent files (PRD.md, SPEC.md, TASKS.md, etc.).

**🌿 Step 0.5: Git Branch Setup**
1. Check current branch: `git branch --show-current`.
2. If on `main` or `master`: **Create feature branch** → `git checkout -b feature/<feature-name>`.
3. If already on a `feature/` branch: Verify it matches `<feature-name>`.
4. **Rule:** All tGD artifacts and code for this feature MUST be committed to `feature/<feature-name>`.

```
SPECIFY ──→ PLAN ──→ TASKS ──→ IMPLEMENT
   │          │        │          │
   ▼          ▼        ▼          ▼
 Human      Human    Human      Human
 reviews    reviews  reviews    reviews
```

### Phase 1: Specify

Start with a high-level vision. Ask the human clarifying questions until requirements are concrete.

**Surface assumptions immediately.** Before writing any spec content, list what you're assuming:

```
ASSUMPTIONS I'M MAKING:
1. This is a web application (not native mobile)
2. Authentication uses session-based cookies (not JWT)
3. The database is PostgreSQL (based on existing Prisma schema)
4. We're targeting modern browsers only (no IE11)
→ Correct me now or I'll proceed with these.
```

Don't silently fill in ambiguous requirements. The spec's entire purpose is to surface misunderstandings *before* code gets written — assumptions are the most dangerous form of misunderstanding.

**Write a PRD document covering these product areas:**

1. **Objective** — What are we building and why? Who is the user? What does success look like?
2. **User Stories** — "As a [user], I want [goal], so that [benefit]."
3. **Success Criteria** — Measurable metrics for completion.

**PRD.md template (save to `tGD/<feature-name>/PRD.md`):**

```markdown
# PRD: [Feature Name]

| Metadata       | Details                           |
|----------------|-----------------------------------|
| **Status**     | Draft / Ready for Dev             |
| **Author**     | Product Manager                   |
| **Date**       | YYYY-MM-DD                        |

## 1. Executive Summary
[Why are we doing this? Business value? Expected impact?]

## 2. Problem Statement
- **Current state:** [What is happening now?]
- **Pain point:** [What is the problem?]
- **Impact:** [How does this affect users/business?]

## 3. Target Audience
- **Primary:** [Who is this for?]
- **Secondary:** [Who else benefits?]
- **User scale:** [Expected MAU/DAU]

## 4. User Stories
| ID | Story | Priority | Acceptance Criteria |
|----|-------|----------|---------------------|
| US-01 | As a [role], I want [goal], so [benefit] | P0 | [Specific criteria] |

## 5. Success Metrics (KPIs)
| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| [Metric 1] | [Target] | [How to measure] |

## 6. Scope
- **Phase 1:** [Must haves]
- **Phase 2:** [Nice to haves]
- **Phase 3:** [Future]
- **Out of Scope:** [Explicitly not doing]

## 7. Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk] | High/Med/Low | [Strategy] |

## 8. Competitive Analysis (if applicable)
| Feature | Our Product | Competitor A | Competitor B |
|---------|-------------|--------------|--------------|
| [Feature] | ✅/❌/Phase N | ✅/❌ | ✅/❌ |

## 9. Stakeholder Alignment
- **PM:** [Sign-off on scope]
- **Design:** [Sign-off on UX flow]
- **Engineering:** [Sign-off on feasibility]
- **Security:** [Sign-off on security requirements]

## 10. Timeline
| Phase | Duration | Milestone |
|-------|----------|-----------|
| Phase 1 | [X weeks] | [Milestone] |
```

**SPEC.md template (save to `tGD/<feature-name>/SPEC.md`):**

```markdown
# SPEC: [Feature Name]

## Feature Type
- [ ] **Backend** (API / CLI / Service)
- [ ] **Frontend** (UI / Web / Mobile)
- [ ] **Full-stack** (Both)

### UI Requirements (if Frontend or Full-stack)
- **Design稿來源**: [Figma URL / 截圖 / None]
- **Pages/Screens**: [List of screens needed]
- **Key Components**: [Component names]
- **Responsive**: [Mobile-first / Desktop-first / Both]

## Tech Stack
[Framework, language, key dependencies with versions]

## Architecture / Data Models
[Data models, endpoints, key algorithms, schema definitions]

## Project Structure
[Directory layout with descriptions]

## API Contract
[Input/Output definitions for key endpoints]

## Testing Strategy
[Framework, test locations, coverage requirements]

## Boundaries
- Always: [...]
- Ask first: [...]
- Never: [...]
```

### Phase 1.5: UI Design Gate (if Frontend or Full-stack)

After writing SPEC.md, check the **Feature Type** field.

**If Frontend or Full-stack is checked:**

1. **Check design稿來源** in SPEC.md:
   - If `[Figma URL]` → Use `web_extract` to fetch design稿截圖 + 元件結構
   - If `[截圖/PDF]` → Use `vision_analyze` to extract UI elements, colors, layout
   - If `[None]` → **STOP. Ask user:** "有現成設計稿嗎？沒有我先產 wireframe。"

2. **If no design exists → Generate wireframe:**
   - Use `excalidraw` skill to create hand-drawn style wireframe
   - Or use `sketch` skill to create HTML mockup
   - Save to `tGD/<feature-name>/design/` directory

3. **Extract from design:**
   - **Component Tree**: List of UI components and their hierarchy
   - **Design Tokens**: Colors, fonts, spacing, border-radius
   - **Responsive Breakpoints**: Mobile / Tablet / Desktop layouts
   - **Interaction Patterns**: Click handlers, state transitions, animations

4. **Save design reference** to `tGD/<feature-name>/DESIGN.md`:
   ```markdown
   # DESIGN: [Feature Name]
   
   ## Source
   - **Type**: [Figma / Wireframe / Mockup]
   - **URL/Path**: [link or file path]
   
   ## Component Tree
   - Page
     - Header
     - LoginForm
       - InputField × 2
       - SubmitButton
     - Footer
   
   ## Design Tokens
   | Token | Value |
   |-------|-------|
   | primary-color | #1a73e8 |
   | border-radius | 8px |
   | font-family | Inter |
   
   ## Responsive
   | Breakpoint | Layout |
   |------------|--------|
   | mobile (<768px) | Stack vertically |
   | desktop (≥768px) | Side by side |
   
   ## Interactions
   - Submit button: idle → loading → success/error
   - Error: show toast notification
   ```

**If Backend only:** Skip this step.

**Reframe instructions as success criteria.** When receiving vague requirements, translate them into concrete conditions:

```
REQUIREMENT: "Make the dashboard faster"

REFRAMED SUCCESS CRITERIA:
- Dashboard LCP < 2.5s on 4G connection
- Initial data load completes in < 500ms
- No layout shift during load (CLS < 0.1)
→ Are these the right targets?
```

This lets you loop, retry, and problem-solve toward a clear goal rather than guessing what "faster" means.

### Phase 2: Plan

With the validated spec, generate a technical implementation plan:

1. Identify the major components and their dependencies
2. Determine the implementation order (what must be built first)
3. Note risks and mitigation strategies
4. Identify what can be built in parallel vs. what must be sequential
5. Define verification checkpoints between phases

The plan should be reviewable: the human should be able to read it and say "yes, that's the right approach" or "no, change X."

### Phase 3: Tasks

Break the plan into discrete, implementable tasks:

- Each task should be completable in a single focused session
- Each task has explicit acceptance criteria
- Each task includes a verification step (test, build, manual check)
- Tasks are ordered by dependency, not by perceived importance
- No task should require changing more than ~5 files

**Task template:**
```markdown
- [ ] Task: [Description]
  - Acceptance: [What must be true when done]
  - Verify: [How to confirm — test command, build, manual check]
  - Files: [Which files will be touched]
```

### Phase 4: Implement

Execute tasks one at a time following `skills/incremental-implementation/SKILL.md` (`incremental-implementation`) and `skills/test-driven-development/SKILL.md` (`test-driven-development`). Use `skills/context-engineering/SKILL.md` (`context-engineering`) to load the right spec sections and source files at each step rather than flooding the agent with the entire spec.

## Keeping the Spec Alive

The spec is a living document, not a one-time artifact:

- **Update when decisions change** — If you discover the data model needs to change, update the spec first, then implement.
- **Update when scope changes** — Features added or cut should be reflected in the spec.
- **Commit the spec** — The spec belongs in version control alongside the code.
- **Reference the spec in PRs** — Link back to the spec section that each PR implements.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "This is simple, I don't need a spec" | Simple tasks don't need *long* specs, but they still need acceptance criteria. A two-line spec is fine. |
| "I'll write the spec after I code it" | That's documentation, not specification. The spec's value is in forcing clarity *before* code. |
| "The spec will slow us down" | A 15-minute spec prevents hours of rework. Waterfall in 15 minutes beats debugging in 15 hours. |
| "Requirements will change anyway" | That's why the spec is a living document. An outdated spec is still better than no spec. |
| "The user knows what they want" | Even clear requests have implicit assumptions. The spec surfaces those assumptions. |

## Red Flags

- Starting to write code without any written requirements
- Asking "should I just start building?" before clarifying what "done" means
- Implementing features not mentioned in any spec or task list
- Making architectural decisions without documenting them
- Skipping the spec because "it's obvious what to build"

## Verification

Before proceeding to implementation, confirm:

- [ ] The spec covers all six core areas
- [ ] The human has reviewed and approved the spec
- [ ] Success criteria are specific and testable
- [ ] Boundaries (Always/Ask First/Never) are defined
- [ ] The spec is saved to `tGD/<feature-name>/SPEC.md`
- [ ] Working branch is `feature/<feature-name>` (not `main`/`master`)
- [ ] If UI feature: `tGD/<feature-name>/DESIGN.md` exists with Component Tree
