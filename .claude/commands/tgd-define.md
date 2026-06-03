---
description: Start spec-driven development — write a structured specification before writing code
---

**🛑 Pre-flight: Environment Check**
- [ ] `tGD/map/CONTEXT.md` exists (or `.codegraph/` is present).
- **If missing:** STOP. Tell user: "Project context not mapped. Please run `/tgd-map` first."

Run the `spec-driven-development` skill. Write a PRD (product requirements document) covering objectives, commands, structure, code style, testing strategy, and boundaries before any code is written.

This is the DEFINE phase. The full pipeline is:
1. **Feature Name Resolution** — Based on the user's request, propose 3 distinct kebab-case `<feature-name>` options with brief descriptions. **Wait for the user to select one or provide their own before proceeding.** Once locked, create `tGD/define/<feature-name>/`.
2. **🌿 Git Branch Setup** — If on `main`/`master`, create and switch to `feature/<feature-name>` (`git checkout -b feature/user-login`).
3. `interview-me` — if the ask is underspecified, extract what the user actually wants
4. `idea-refine` — if the concept is vague, stress-test and expand options
5. `spec-driven-development` — write the structured spec (PRD + SPEC)

**Phase 1.5: UI Design Gate (MANDATORY CHECK)**
After writing SPEC.md, you MUST ask the user: "Does this feature have a UI component requiring DESIGN.md?"
- If YES: generate 3 visual variants → user picks one → write DESIGN.md → wait for user confirmation.
- If NO: skip DESIGN.md. **You cannot skip this step without explicit user approval.**

Use `interview-me` first if the ask is underspecified. Use `idea-refine` if you have a rough concept but it's not concrete yet.

After completing the spec, verify the outputs.

**Verification Gate:**
- [ ] `tGD/define/` directory exists
- [ ] `tGD/define/<feature-name>/PRD.md` exists and is non-empty
- [ ] `tGD/define/<feature-name>/SPEC.md` exists and is non-empty
- [ ] Working branch is `feature/<feature-name>`
- [ ] If UI feature: `tGD/define/<feature-name>/DESIGN.md` exists with Component Tree

If verification passes, suggest the next step: `/tgd-plan` to decompose it into tasks.
