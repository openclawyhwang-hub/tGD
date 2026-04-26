---
name: rapid-prototyping
description: Generates throwaway HTML/JS prototypes to visualize concepts. Use when you need to explore UI concepts before writing the spec.
---

# Rapid Prototyping Workflow

## Process

1. **Understand Intent**: Clarify user interaction needs.
2. **Generate Variations**: Create 2-3 visual approaches in HTML/JS (use Tailwind CDN) in `temp_prototypes/`.
3. **Present**: Ask user to open the HTML files and select a direction.
4. **Handoff**: Advise user to run `/spec` to formalize the chosen prototype into a PRD.

## Verification

2-3 HTML prototype files exist in `temp_prototypes/`, user has reviewed them, and the chosen direction is confirmed before moving to `/spec`.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Skip prototypes, just write the spec" | Prototypes reveal UX issues that text specs miss. A 10-minute prototype saves hours of spec rewrites. |
| "Make production-quality code, not throwaway" | Prototypes are meant to be throwaway. Production code at this stage is premature optimization. |
| "Only create 1 variation" | One variation gives no choice. 2-3 approaches let the user compare and choose. |
| "Skip handoff to /spec" | Without formalizing into a spec, the prototype becomes the spec — and it shouldn't. |
| "Use complex frameworks instead of HTML/Tailwind" | Prototypes should be simple and fast. HTML + Tailwind CDN is enough. No build step needed. |
