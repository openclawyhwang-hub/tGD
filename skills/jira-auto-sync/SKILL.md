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
curl -x "" -s -H "Authorization: Bearer *** "$JIRA_URL/rest/api/2/myself" | python3 -m json.tool
```
If it returns user info, auth works. If 401/403, check credentials or proxy settings.

**Priority Mapping:**
Map TASKS.md priority to Jira priority names (check your instance via `curl -x "" $JIRA_URL/rest/api/2/priority`):
- High → "High" (or "Highest", "Critical")
- Medium → "Medium" (or "Normal")
- Low → "Low" (or "Lowest")

## Proxy / Firewall Handling

Company networks often intercept HTTPS. If curl fails with SSL errors or timeouts:

```bash
# Option 1: Set proxy (if Jira is external or proxy is required to reach it)
export HTTPS_PROXY=http://proxy.company.com:8080

# Option 2: Bypass proxy for internal Jira Data Center (if proxy is globally set but Jira is on intranet)
# Use curl -x "" to bypass the proxy
curl -x "" -s -H "Authorization: Bearer $JIRA_TOKEN" ...

# Option 3: Skip cert verification (last resort, NOT recommended for production)
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

Read `tGD/plan/<feature-name>/TASKS.md` and extract each task block:
- Task number/ID
- Title (summary)
- Description
- Acceptance Criteria (as checklist)
- Files Likely Touched
- Estimate (if present)

### Step 2: Discover Issue Types and Custom Fields

Data Center instances vary widely. You MUST query metadata first and let the user choose.

**1. Fetch Project Metadata**
```bash
curl -x "" -s \
  "$JIRA_URL/rest/api/2/issue/createmeta?projectKeys=$JIRA_PROJECT&expand=projects.issuetypes.fields" \
  -H "Authorization: Bearer $JIRA_TOKEN" \
  -H "Content-Type: application/json" > /tmp/jira_meta.json
```

**2. Show Issue Types**
Run this to extract available types and ask the user to pick one:
```bash
python3 -c "
import json, sys
d = json.load(open('/tmp/jira_meta.json'))
for p in d.get('projects', []):
    for t in p.get('issuetypes', []):
        print(f\"  [{t['id']}] {t['name']}\")"
```
> 🛑 **Action:** Present the list to the user. Default to **Story** if present. Store their choice as `ISSUE_TYPE_ID`.

**3. Find Project & IssueType-specific Required Fields**
Jira projects have different mandatory fields. To prevent API errors (400 Bad Request), run this script to filter out exactly which fields are marked `"required": true` for your selected Project Key and Issue Type ID:

```bash
python3 -c "
import json, sys
meta = json.load(open('/tmp/jira_meta.json'))
proj_key = '$JIRA_PROJECT'
issue_type_id = '$ISSUE_TYPE_ID'

project = next((p for p in meta.get('projects', []) if p['key'] == proj_key), None)
if not project:
    print(f'Project {proj_key} not found in metadata.')
    sys.exit(1)
    
issuetype = next((it for it in project.get('issuetypes', []) if it['id'] == issue_type_id), None)
if not issuetype:
    print(f'Issue type {issue_type_id} not found.')
    sys.exit(1)

fields = issuetype.get('fields', {})
print('\n🚨 MANDATORY CUSTOM FIELDS DETECTED:')
required_count = 0
for fid, fval in fields.items():
    if fid in ['project', 'summary', 'issuetype', 'description', 'reporter', 'priority']:
        continue
    if fval.get('required'):
        required_count += 1
        print(f\"  * {fid} ({fval.get('name')}): Type [{fval.get('schema', {}).get('type')}] (Required!)\")

if required_count == 0:
    print('  None (only standard fields are required).')
"
```
> 🛑 **Action:** For any detected mandatory field:
> 1. Proactively present it to the user.
> 2. Ask the user for the value or configuration mapping.
> 3. Inject it into the payload in Step 3 (e.g., `"customfield_10100": { "value": "UserProvidedValue" }`). Do NOT try to guess or ignore required fields.

### Step 3: Create Issues

For each parsed task, create a Jira issue:

```bash
curl -x "" -s -X POST \
  "$JIRA_URL/rest/api/2/issue" \
  -H "Authorization: Bearer $JIRA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
  "fields": {
    "project":   { "key": "'"$JIRA_PROJECT"'" },
    "summary":   "'"$SUMMARY"'",
    "issuetype": { "id": "'"$ISSUE_TYPE_ID"'" },
    "priority":  { "name": "'"$PRIORITY"'" },
    "labels":    ["tgd", "'"$FEATURE_NAME"'"],
    "description": "'"$DESCRIPTION"'"
  }
}' | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('key','ERROR: '+d.get('errorMessages',str(d))[0]))"
```

#### 📝 Description Construction Guide

The Agent MUST construct the `DESCRIPTION` variable using this Wiki Markup structure. Do NOT deviate from this format.

**Template:**
```
h3. Background
{noformat}
<Why is this needed? What is the current pain point? Context from PRD/SPEC.>
{noformat}

h3. Goal
{noformat}
<What exactly are we building? What is the desired measurable outcome?>
{noformat}

h3. Acceptance Criteria
{noformat}
AC-1:
Given <initial context>
When <action occurs>
Then <expected result>

AC-2:
Given <edge case or error condition>
When <action occurs>
Then <error handling / expected failure>
{noformat}

h3. Technical Notes
{noformat}
Files:
- <path/to/file1>
- <path/to/file2>
{noformat}
```

#### 💉 Custom Field Injection Reference

Mandatory fields vary by company and project. When a field is required, inject it into the JSON payload using the correct data type:

```json
// Dropdown / Select List (Single Choice)
"customfield_10100": { "value": "High" },

// Component/s (Multi-select)
"components": [{ "name": "Backend" }, { "name": "Database" }],

// Fix Version/s (Multi-select)
"fixVersions": [{ "name": "v1.2.0" }],

// Epic Link / Parent (String)
"customfield_10011": "PROJ-1001",

// Sprint (Integer - Sprint ID)
"customfield_10020": 1234,

// User Picker (Single User)
"customfield_10300": { "name": "elon.wang" },

// Text / Text Area (String)
"customfield_10400": "Some internal notes here.",

// Labels
"labels": ["tgd", "jwt-auth", "urgent"]
```
> ⚠️ **Warning:** The `schema.type` returned by `createmeta` determines the structure. 
> *   `option` → `{ "value": "..." }`
> *   `array` → `[{ "name": "..." }]`
> *   `string` → `"..."` directly.

#### 🏆 Golden Example

**Scenario:** `feature-name` = `jwt-auth`, Task = "Implement Login API"

```json
{
  "fields": {
    "project": { "key": "ENG" },
    "summary": "[jwt-auth] As a user, I want to login via email and password to access my dashboard",
    "issuetype": { "id": "10000" },
    "priority": { "name": "High" },
    "labels": ["tgd", "jwt-auth"],
    "description": "h3. Background\n{noformat}\nCurrently, the system has no authentication. All endpoints are public, causing data leakage risks.\n{noformat}\n\nh3. Goal\n{noformat}\nImplement a secure POST /login endpoint that validates credentials and returns a JWT token valid for 24 hours.\n{noformat}\n\nh3. Acceptance Criteria\n{noformat}\nAC-1:\nGiven a registered user with valid credentials\nWhen they POST to /api/login\nThen they receive a 200 OK with a JWT token in the body\n\nAC-2:\nGiven an unregistered user or wrong password\nWhen they POST to /api/login\nThen they receive 401 Unauthorized and no token\n{noformat}\n\nh3. Technical Notes\n{noformat}\nFiles:\n- src/auth/login.py\n- tests/test_login.py\n- config/settings.py (JWT_SECRET)\n{noformat}"
  }
}
```

> ⚠️ **Critical:** The `summary` must always start with `[<feature-name>]` and follow the "As a... I want... So that..." format where possible. Keep it under 255 characters.

**Output:** Print each created issue key (e.g. `ENG-1234`).

### Step 4: Error Handling

If an issue creation fails, the script should:
- **401/403**: Token expired or invalid → Stop and ask user to re-provide `JIRA_TOKEN`
- **400 (summary too long)**: Jira limit is 255 chars. Shorten the summary and retry.
- **400 (missing field)**: Print the error, identify missing required field via `createmeta`, ask user for value.
- **400 (invalid priority)**: Fetch valid priorities via `$JIRA_URL/rest/api/2/priority` and retry.
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
  2. Parse tGD/plan/<feature-name>/TASKS.md
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
