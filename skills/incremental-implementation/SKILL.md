---
name: incremental-implementation
description: Ruthless Test-Driven Development with a Two-Stage Quality Gate. Code that fails standards is immediately deleted.
---

# Ruthless TDD Workflow

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
