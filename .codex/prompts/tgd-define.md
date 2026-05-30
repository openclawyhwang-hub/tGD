# /tgd-define

Define — write PRD + SPEC before any code

Run the spec-driven-development skill. This is the DEFINE phase.

Pre-flight: Check tGD/map/CONTEXT.md exists. If missing, STOP and tell user to run /tgd-map first.

Pipeline:
1. Derive kebab-case <feature-name> from user request
2. Create tGD/<feature-name>/ directory
3. If on main/master, create branch: git checkout -b feature/<feature-name>
4. interview-me — if ask is underspecified
5. idea-refine — if concept is vague
6. spec-driven-development — write PRD.md + SPEC.md
7. UI Design Gate — if frontend: create DESIGN.md

Verification Gate:
- [ ] tGD/<feature-name>/PRD.md exists
- [ ] tGD/<feature-name>/SPEC.md exists
- [ ] Working branch is feature/<feature-name>

After completing, suggest: /tgd-plan to decompose into tasks.
