---
description: Start spec-driven development — write a structured specification before writing code
---

**🛑 Pre-flight: Environment Check**
- [ ] `$TGD_DIR/CONTEXT.md` exists (or `.codegraph/` is present).
- **If missing:** STOP. Tell user: "Project context not mapped. Please run `/tgd-map` first."
- **$TGD_DIR:** Resolve via `tGD/` symlink in project root. If missing, check `$TGD_DIR` env var. If neither exists: STOP — run `/tgd-map` first.

Run the `spec-driven-development` skill. Write a PRD (product requirements document) covering objectives, commands, structure, code style, testing strategy, and boundaries before any code is written.

This is the DEFINE phase. The full pipeline is:
1. **Feature Name Resolution** (Selection Protocol) — **Analyze the user's request first.** Extract the core action + object (e.g., "user login" → action: login, object: user). Then propose 3 distinct kebab-case `<feature-name>` options that **directly reflect the user's intent**:
   - Option 1: Most literal/direct (e.g., `user-login`)
   - Option 2: Action-focused (e.g., `authenticate-user`)
   - Option 3: Domain-specific if applicable (e.g., `auth-flow`)
   
   **Wait for the user to select one by number or provide their own before proceeding.** Once locked, create `$TGD_DIR/<feature-name>/`.
2. **🌿 Git Branch Setup** — If on `main`/`master`, create and switch to `feature/<feature-name>` (`git checkout -b feature/user-login`).
3. `interview-me` — if the ask is underspecified, extract what the user actually wants
4. `idea-refine` — if the concept is vague, stress-test and expand options
5. `spec-driven-development` — write the structured spec (PRD + SPEC)

**Phase 1.5: UI Design Gate (MANDATORY CHECK via Selection Protocol)**
After writing SPEC.md, you MUST ask the user: "Does this feature have a UI component requiring DESIGN.md?"
**Format:** "1. Yes (Generate design) 2. No (Backend only)"
- If YES: 
  1. Run the `sketch` skill to generate 2-3 HTML prototype variants in `$TGD_DIR/<feature-name>/prototype/`
  2. Present comparison table → user picks one by letter (or requests iteration)
  3. Write DESIGN.md documenting the chosen design decisions and component tree
  4. Wait for user confirmation before proceeding.
- If NO: skip DESIGN.md and prototype. **You cannot skip this step without explicit user approval.**

Use `interview-me` first if the ask is underspecified. Use `idea-refine` if you have a rough concept but it's not concrete yet.

After completing the spec, verify the outputs.

**Verification Gate:**
- [ ] `$TGD_DIR/` directory exists
- [ ] `$TGD_DIR/<feature-name>/PRD.md` exists and is non-empty
- [ ] `$TGD_DIR/<feature-name>/SPEC.md` exists and is non-empty
- [ ] Working branch is `feature/<feature-name>`
- [ ] If UI feature: `$TGD_DIR/<feature-name>/DESIGN.md` exists with Component Tree
- [ ] If UI feature: `$TGD_DIR/<feature-name>/prototype/` contains at least 2 HTML variants

If verification passes, suggest the next step: `/tgd-plan` to decompose it into tasks.
