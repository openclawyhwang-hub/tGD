---
**🛑 Pre-flight: Environment Check**
- [ ] `tGD/map/CONTEXT.md` exists (or `.codegraph/` is present).
- **If missing:** STOP. Tell user: "Project context not mapped. Please run `/tgd-map` first."


description: Start spec-driven development — write a structured specification before writing code
---

Run the `spec-driven-development` skill. Write a PRD (product requirements document) covering objectives, commands, structure, code style, testing strategy, and boundaries before any code is written.

This is the DEFINE phase. The full pipeline is:
1. **Feature Name Resolution** — Derive a kebab-case `<feature-name>` from the user's request (e.g., "User Login" → `user-login`). Create `tGD/<feature-name>/` if it doesn't exist.
2. `interview-me` — if the ask is underspecified, extract what the user actually wants
3. `idea-refine` — if the concept is vague, stress-test and expand options
4. `spec-driven-development` — write the structured spec

Use `interview-me` first if the ask is underspecified. Use `idea-refine` if you have a rough concept but it's not concrete yet.

After completing the spec, verify the outputs.

**Verification Gate:**
- [ ] `tGD/<feature-name>/` directory exists
- [ ] `tGD/<feature-name>/PRD.md` exists and is non-empty
- [ ] `tGD/<feature-name>/SPEC.md` exists and is non-empty

If verification passes, suggest the next step: `/tgd-plan` to decompose it into tasks.
