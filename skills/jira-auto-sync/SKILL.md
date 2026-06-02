---
name: jira-auto-sync
description: "Parse TASKS.md and auto-create Jira Data Center issues in a single Sprint. Use as conditional skill in /tgd-plan phase after TASKS.md is generated."
trigger: "After /tgd-plan generates TASKS.md, when user wants Jira tickets created"
---

# Jira Auto-Sync (TASKS.md → Jira Sprint)

## Overview

Parses the `TASKS.md` produced by `/tgd-plan` and creates Jira issues in the company's **Jira Data Center** instance, all assigned to a single Sprint. Uses `curl` + Jira REST API v2 — no external CLI binary needed, works behind company proxies.

## Prerequisites

The user MUST provide these before the skill runs:

```
JIRA_URL      = https://jira.company.com          (Data Center base URL)
JIRA_TOKEN=*** token (PAT)
JIRA_PROJECT   = Project key (e.g. ENG, FE, BE) — 必填
```

**Sprint 分配：**自動跳過 Sprint 指派步驟。如需將 issue 放入特定 Sprint，使用者可手動在 Jira UI 批次操作，或在 `/tgd-plan` 後另行處理。

**Setup (one-time):**
```bash
# Test connection (Bearer auth)
curl -s -H "Authorization: Bearer *** "$JIRA_URL/rest/api/2/myself" | python3 -m json.tool
```
If it returns user info, auth works. If 401/403, check credentials or proxy settings.

## Proxy / Firewall Handling

Company networks often intercept HTTPS. If curl fails with SSL errors:

```bash
# Option 1: Set proxy
export HTTPS_PROXY=http://proxy.company.com:8080

# Option 2: Skip cert verification (last resort, NOT recommended for production)
# Add -k flag to curl calls
```

## TASKS.md Format

The skill expects `TASKS.md` in the standard tGD format:

```markdown
# TASKS: [Feature Name]

## Task 1: [Task Title]
- **Description**: [What to do]
- **Acceptance Criteria**:
  - Given [context], When [action], Then [expected result]
- **Files Likely Touched**: `src/foo.py`, `tests/test_foo.py`
- **Estimate**: 3

## Task 2: [Task Title]
...
```

## Execution Steps

### Step 1: Parse TASKS.md

Read `tGD/<feature-name>/plan/TASKS.md` and extract each task block:
- Task number/ID
- Title (summary)
- Description
- Acceptance Criteria (as checklist)
- Files Likely Touched
- Estimate (if present)

### Step 2: Get Issue Type ID

Data Center may have custom issue types. Fetch available types:

```bash
curl -s \
  "$JIRA_URL/rest/api/2/issue/createmeta?projectKeys=$JIRA_PROJECT&expand=projects.issuetypes" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" | python3 -m json.tool
```

Pick the issue type ID (typically "Task" = `10001` or `3`, "Story" = `10000` or `7`). Store as `ISSUE_TYPE_ID`.

### Step 3: Create Issues

For each parsed task, create a Jira issue:

```bash
curl -s -X POST \
  "$JIRA_URL/rest/api/2/issue" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{
  "fields": {
    "project": { "key": "'"$JIRA_PROJECT"'" },
    "summary": "[<feature-name>] <Task Title>",
    "description": "<Task Description>\n\nh3. Acceptance Criteria\n{noformat}\n<AC lines>\n{noformat}\n\nh3. Files to Touch\n{noformat}\n<Files list>\n{noformat}",
    "issuetype": { "id": "'"$ISSUE_TYPE_ID"'" },
    "labels": ["tgd", "<feature-name>"]
  }
}' | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('key','ERROR: '+d.get('errorMessages',str(d))[0]))"
```

**Output:** Print each created issue key (e.g. `ENG-1234`).

### Step 4: Error Handling

If an issue creation fails, the script should:
- **401/403**: Token expired or invalid → Stop and ask user to re-provide `JIRA_TOKEN`
- **400 (missing field)**: Print the error, identify missing required field via `createmeta`, skip this task
- **500**: Retry once with `sleep 1`, if still fails skip and continue
- Continue processing remaining tasks even if one fails

### Step 5: Report

Output a summary table:

```
| TASKS.md Task | Jira Key | Status |
|---------------|----------|--------|
| Task 1: xxx   | ENG-1234 | ✅ Created |
| Task 2: yyy   | ENG-1235 | ✅ Created |
| Task 3: zzz   | -        | ❌ Failed: ... |
```

## Automation Pattern (for /tgd-plan conditional)

In `/tgd-plan`, add as a conditional skill:

```markdown
**Conditional (apply when relevant):**
- User wants Jira tickets? → `jira-auto-sync`
  1. Ask for JIRA_URL, JIRA_PROJECT (必填), JIRA_TOKEN (first time only)
  2. Parse tGD/<feature-name>/plan/TASKS.md
  3. Create issues via REST API v2
  4. Report created issue keys
```

## Pitfalls

### Data Center API Versions

- **REST API v2** (`/rest/api/2/`) — works on all Data Center versions
- **REST API v3** (`/rest/api/3/`) — DC 8.0+, uses Atlassian Document Format (ADF) for description fields. If v3, description must be ADF JSON, not wiki markup
- **Recommendation:** Use v2 with wiki markup (`h3.`, `{noformat}`) — simpler and universally compatible

### Custom Fields

If the company Jira has **required custom fields** (e.g., Component, Fix Version, Severity), the create payload must include them:

```json
"customfield_10100": {"value": "High"},
"components": [{"name": "Backend"}]
```

**How to discover:** Run `createmeta` (Step 2) and check which fields have `"required": true`. Add them to the payload.

### Sprint Assignment Without Agile Plugin

If `/rest/agile/1.0/` is unavailable:

```bash
# Find the custom field ID for Sprint
curl -s \
  "$JIRA_URL/rest/api/2/field" \
  -H "Authorization: Bearer *** | python3 -c "
import sys, json
fields = json.load(sys.stdin)
for f in fields:
  if f['name'] == 'Sprint':
    print(f['id'], f['custom'])
"

# Then set it via issue update:
curl -s -X PUT \
  "$JIRA_URL/rest/api/2/issue/$ISSUE_KEY" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{"update": {"customfield_XXXXX": [{"set": 142}]}}'
```

### SSL / Proxy Interception

Company MITM proxies cause `SSL certificate problem`. Solutions:
1. Set `REQUESTS_CA_BUNDLE` or `CURL_CA_BUNDLE` to company CA cert path
2. Use `export NODE_TLS_REJECT_UNAUTHORIZED=0` (not recommended)
3. Add `-k` to curl as last resort

### Rate Limiting

Data Center may throttle bulk creation. If creating 20+ issues:
- Add `sleep 0.5` between API calls
- Or batch via `/rest/batch/1.0/issue` (if available on DC 9.0+)

## When to Use

- When `/tgd-plan` generates `TASKS.md`
- When user wants to sync tasks to Jira Data Center
- When planning sprint backlog from task breakdown

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll sync to Jira later" | Later never comes. Sync immediately after plan. |
| "Manual Jira entry is fine" | Manual entry loses the link between TASKS.md and Jira. |

## Red Flags

- Tasks created in Jira without corresponding TASKS.md entries
- Jira issues missing acceptance criteria from TASKS.md
- Sync run without user confirmation

## Verification Gate

After execution, verify:
- [ ] All tasks from TASKS.md have corresponding Jira keys
- [ ] No creation errors in the report
- [ ] Created issues are viewable in Jira UI
