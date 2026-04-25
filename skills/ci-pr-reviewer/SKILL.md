---
name: ci-pr-reviewer
description: Automated PR Auditor that posts comments on GitHub/GitLab PRs. Does NOT modify code.
---

# CI PR Reviewer Workflow

## Process

1. **Analyze Changes**: Read the Git diff for the target PR.
2. **Multi-Axis Review (Read-Only)**:
   - Syntax & Bugs / Unhandled exceptions.
   - Test Coverage cheating.
   - OWASP Security vulnerabilities.
3. **Draft Feedback**:
   - Post actionable feedback explicitly citing filename and line number as PR comments using Git CLI (`gh pr review`).
   - If perfect, output "LGTM".

## Rationalization

- "I will fix the typo." -> Rebuttal: NO. You are an auditor in CI. Post a comment, do NOT edit files.
