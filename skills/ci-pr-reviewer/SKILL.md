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

| Rationalization | Reality |
|---|---|
| "I will fix the typo" | NO. You are an auditor in CI. Post a comment, do NOT edit files. |
| "Skip the review, the code looks fine" | Every PR needs review, even if it looks fine. Subtle bugs hide in plain sight. |
| "Post feedback in Slack instead of PR" | PR comments are traceable and linked to the code. Slack messages get lost. |

## Verification

After completing a PR review:

- [ ] Git diff was analyzed
- [ ] Feedback posted as PR comments (not Slack/email)
- [ ] Each comment cites filename and line number
- [ ] OWASP vulnerabilities checked
- [ ] Test coverage cheating checked
- [ ] If perfect, "LGTM" output recorded
