---
name: context-mapping
description: Analyzes the codebase to build a context map. Essential for Brownfield projects. Use when starting work on an existing codebase, or when `.planning/CONTEXT.md` is missing.
---

# Context Mapping Workflow

## Trigger

Run via `/map` command, or auto-trigger when:
- `.planning/CONTEXT.md` does not exist
- CONTEXT.md is older than 30 days (flag for refresh)
- User explicitly requests context refresh

## Process

1. **Repository Scanning**: Use `tree -L 3`, `cat package.json`, or view database schemas.
2. **Dependency Mapping**: Find seams in the architecture where new features inject safely.
3. **Draft Context.md**: Create `.planning/CONTEXT.md`.
   - Must include: Architecture Summary, Key Entities, and Strict Constraints (Backward compatibility rules).

## Verification

`.planning/CONTEXT.md` is populated with accurate, project-specific boundaries.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Skip context mapping, I'll just read the code" | Reading code without a map misses architectural constraints that only emerge from a holistic scan. |
| "CONTEXT.md is too old, but I'll ignore it" | Stale context hides breaking changes. Refresh if older than 30 days or after major refactors. |
| "I know this codebase, no need to scan" | Even familiar codebases evolve. A fresh scan catches recent changes you might have missed. |
| "Just implement the feature, skip the map" | Implementing without context risks violating backward compatibility rules and injection point constraints. |
