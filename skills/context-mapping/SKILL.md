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
