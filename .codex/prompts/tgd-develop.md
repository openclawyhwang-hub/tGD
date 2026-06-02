# /tgd-develop

Build — implement one thin vertical slice at a time

Run the incremental-implementation skill. This is the BUILD phase.

Pre-flight:
- Check tGD/map/CONTEXT.md exists. If missing, /tgd-map first.
- Check tGD/plan/<feature-name>/TASKS.md exists. If missing, /tgd-plan first.

Core flow:
1. context-engineering — load right spec sections for current task
2. source-driven-development — ground decisions in official docs
3. incremental-implementation — thin slices: implement -> test -> verify -> commit
4. test-driven-development — Red-Green-Refactor for each slice

Conditional:
- Frontend? -> frontend-ui-engineering
- API? -> api-and-interface-design
- High stakes? -> doubt-driven-development

One slice at a time. Never implement multiple tasks at once.

After completing, suggest: /tgd-verify to prove it works.
