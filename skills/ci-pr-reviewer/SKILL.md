---
name: ci-pr-reviewer
description: Automated PR Auditor that posts comments on PRs (GitHub/GitLab/Bitbucket). Does NOT modify code. Use when setting up CI for automated code review on every pull request.
---

# CI PR Reviewer Workflow

## Process

1. **Analyze Changes**: Read the Git diff for the target PR.
2. **Multi-Axis Review (Read-Only)**:
   - Syntax & Bugs / Unhandled exceptions.
   - Test Coverage cheating.
   - OWASP Security vulnerabilities.
3. **Draft Feedback**:
   - Post actionable feedback explicitly citing filename and line number as PR comments.
   - Use the appropriate CLI for your provider:
     - GitHub: `gh pr review --comment --body "..."`
     - GitLab: `glab mr note --body "..."` or GitLab API
     - Bitbucket: Bitbucket API
   - If perfect, output "LGTM".

## Common Rationalizations

- "I will fix the typo." -> Rebuttal: NO. You are an auditor in CI. Post a comment, do NOT edit files.
