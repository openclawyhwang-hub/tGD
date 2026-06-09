# /tgd-define

Define — write PRD + SPEC before any code

Run the spec-driven-development skill. This is the DEFINE phase.

Pre-flight: Check tGD/map/CONTEXT.md exists. If missing, STOP and tell user to run /tgd-map first.

This is the DEFINE phase. The full pipeline is:
1. **Feature Name Resolution** (Selection Protocol) — **Analyze the user's request first.** Extract the core action + object (e.g., "user login" → action: login, object: user). Then propose 3 distinct kebab-case `<feature-name>` options that **directly reflect the user's intent**:
   - Option 1: Most literal/direct (e.g., `user-login`)
   - Option 2: Action-focused (e.g., `authenticate-user`)
   - Option 3: Domain-specific if applicable (e.g., `auth-flow`)
   
   **Wait for the user to select one by number or provide their own before proceeding.** Once locked, create `tGD/define/<feature-name>/`.
2. **Git Branch Setup** — If on `main`/`master`, create and switch to `feature/<feature-name>` (`git checkout -b feature/user-login`).
4. interview-me — if ask is underspecified
5. idea-refine — if concept is vague
6. spec-driven-development — write PRD.md + SPEC.md

**Phase 1.5: UI Design Gate (MANDATORY CHECK via Selection Protocol)**
After writing SPEC.md, you MUST ask the user: "Does this feature have a UI component requiring DESIGN.md?"
**Format:** "1. Yes (Generate design) 2. No (Backend only)"
- If YES: 
  1. Run the `sketch` skill to generate 2-3 HTML prototype variants in `tGD/define/<feature-name>/prototype/`
  2. Present comparison table → user picks one by letter (or requests iteration)
  3. Write DESIGN.md documenting the chosen design decisions and component tree
  4. Wait for user confirmation before proceeding.
- If NO: skip DESIGN.md and prototype. You cannot skip this step without explicit user approval.

Verification Gate:
- [ ] tGD/define/<feature-name>/PRD.md exists
- [ ] tGD/define/<feature-name>/SPEC.md exists
- [ ] Working branch is feature/<feature-name>
- [ ] If UI feature: tGD/define/<feature-name>/DESIGN.md exists
- [ ] If UI feature: tGD/define/<feature-name>/prototype/ contains at least 2 HTML variants

After completing, suggest: /tgd-plan to decompose into tasks.
