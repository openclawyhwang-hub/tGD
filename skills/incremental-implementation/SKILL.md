---
name: incremental-implementation
description: Ruthless Test-Driven Development with a Two-Stage Quality Gate. Code that fails standards is immediately deleted. Use when implementing any change that touches more than one file.
---

# Incremental Implementation

## Process

1. **Test First (RED)**: Write a test for the Acceptance Criteria (AC). Run it. It MUST fail.
2. **Implementation (GREEN)**: Write the minimal code to pass the test. Run it. Show success.
3. **Two-Stage Quality Gate (Crucial Step)**:
   - **Gate 1 (AC Compliance)**: Does this fulfill the Jira AC exactly?
   - **Gate 2 (DRY/YAGNI)**: Is the code DRY and YAGNI? Are there hardcoded values?
   - **EXECUTION**: If EITHER gate fails, you MUST delete the implementation using `git restore` or `rm`, and restart from Step 1.
4. **Refactor**: Clean up and run tests again.

## Verification

You succeed when terminal logs prove the test failed first, then passed, and code survives the Quality Gates.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Skip the failing test, I know the code works" | Without a failing test first, you can't prove the test actually validates the feature. |
| "Skip Gate 2 (DRY/YAGNI), it's just a small feature" | Small features compound. Technical debt from skipping DRY/YAGNI checks multiplies across the codebase. |
| "The test passes, no need to refactor" | Refactoring after green ensures the code is clean and maintainable, not just functional. |
| "Gate failed, but I'll just patch it instead of deleting" | Patching a failed gate creates fragile code. Delete and restart — it's faster than debugging bad architecture. |
| "I'll add tests later" | Tests written after implementation are always incomplete and biased toward the happy path. Write first. |
