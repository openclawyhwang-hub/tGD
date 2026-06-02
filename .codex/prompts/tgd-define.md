# /tgd-define

Define — write PRD + SPEC before any code

Run the spec-driven-development skill. This is the DEFINE phase.

Pre-flight: Check tGD/map/CONTEXT.md exists. If missing, STOP and tell user to run /tgd-map first.

Pipeline:
1. **Feature Name Resolution** — Based on the user's request, propose 3 distinct kebab-case `<feature-name>` options with brief descriptions. **Wait for the user to select one or provide their own before proceeding.** Once locked, create `tGD/define/<feature-name>/`.
2. **Git Branch Setup** — If on `main`/`master`, create and switch to `feature/<feature-name>` (`git checkout -b feature/user-login`).
4. interview-me — if ask is underspecified
5. idea-refine — if concept is vague
6. spec-driven-development — write PRD.md + SPEC.md
7. UI Design Gate — if frontend: create DESIGN.md

Verification Gate:
- [ ] tGD/define/<feature-name>/PRD.md exists
- [ ] tGD/define/<feature-name>/SPEC.md exists
- [ ] Working branch is feature/<feature-name>

After completing, suggest: /tgd-plan to decompose into tasks.
