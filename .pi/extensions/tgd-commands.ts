// tGD Pi Extension — Registers 7 lifecycle slash commands
// Compatible with pi-coding-agent 0.75.x

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const tgdPrompts: Record<string, string> = {
  "tgd-map":
    "## Step 0: $TGD_DIR Resolution\n\n" +
    "$TGD_DIR is where ALL tGD artifacts live. It is a sibling directory outside your code repo.\n\n" +
    "**Step 0a: Resolve candidate path** (in order):\n" +
    "1. If env var $TGD_DIR is set → candidate = $TGD_DIR\n" +
    "2. Otherwise → candidate = ../<project-name>-tGD/\n\n" +
    "**Step 0b: Confirm $TGD_DIR with user:**\n\n" +
    "- $TGD_DIR already set (env var) → Inform: Using $TGD_DIR: $TGD_DIR. Proceed.\n" +
    "- First-time setup (no env var) → MUST ask:\n" +
    "> 📂 tGD artifacts will be stored at: <candidate path>\n" +
    ">\n" +
    "> 1. Use this path (Enter)\n" +
    "> 2. Use a different path (enter an absolute path)\n" +
    ">\n" +
    "> Choose one (default 1):\n\n" +
    "- Choice 1 (or Enter) → mkdir -p $TGD_DIR && export TGD_DIR=$TGD_DIR\n" +
    "- Choice 2 → user-provided path: TGD_DIR=<path>, mkdir -p $TGD_DIR, export TGD_DIR=$TGD_DIR\n\n" +
    "- Non-interactive mode (CI, subagent, no TTY) → Skip confirmation, proceed with candidate. Log: Using $TGD_DIR: <candidate path> (non-interactive)\n\n" +
    "## Step 1: Context Discovery\n\n" +
    "Before analyzing anything, ask the user:\n" +
    "> \"除了當前 repo，還有其他需要參考的 repo 嗎？（local path 或 git URL）\"\n\n" +
    "- Accept local paths (e.g. ~/Projects/wayflow) — resolve to absolute path\n" +
    "- Accept git URLs (e.g. github.com/CopilotKit/CopilotKit) — clone to /tmp/tgd-context/<repo-name>\n" +
    "- If user says \"no\" or provides nothing, proceed with primary repo only\n\n" +
    "## Step 2: Context Engineering\n\n" +
    "Run the `tgd-context-engineering` skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.\n\n" +
    "⚠️ This is only Step 2. You MUST continue to Step 3 (CodeGraph) and Step 4 (Understand-Anything) before producing CONTEXT.md.\n\n" +
    "## Step 3: CodeGraph Setup\n\n" +
    "For each repo to map (primary + all additional repos from Step 1):\n\n" +
    "1. mkdir -p $TGD_DIR/.scans/<repo-name>\n" +
    "2. rm -rf <repo-path>/.codegraph && ln -s $TGD_DIR/.scans/<repo-name>/.codegraph <repo-path>/.codegraph\n" +
    "3. cd into the repo and run `codegraph init -i`\n\n" +
    "## Step 4: Understand-Anything (MANDATORY)\n\n" +
    "This step is required, not optional.\n\n" +
    "You MAY use subagent delegation to execute this step. If context is getting long, spawn a fresh subagent to run the `understand` skill on each repo.\n\n" +
    "For each repo to map (primary + all additional repos from Step 1):\n\n" +
    "1. rm -rf <repo-path>/.understand-anything && ln -s $TGD_DIR/.scans/<repo-name>/.understand-anything <repo-path>/.understand-anything\n" +
    "2. load and execute the `understand` skill to build a full knowledge graph\n" +
    "3. Produces $TGD_DIR/.scans/<repo-name>/.understand-anything/knowledge-graph.json\n" +
    "4. After ALL repos are mapped, load the `understand-dashboard` skill from EACH repo to launch the interactive visualization\n" +
    "5. If unfamiliar with any repo, load the `understand-onboard` skill for a guided tour\n\n" +
    "⚠️ Do NOT skip the dashboard. It is a required deliverable of tgd-map for EVERY repo.\n\n" +
    "## Step 5: Produce CONTEXT.md\n\n" +
    "CONTEXT.md must include:\n" +
    "1. Primary Repository — path, name, structure, key files, summary, code entry points\n" +
    "2. Additional Context Repositories — for each: source, resolved path, summary, key insights, relevance\n" +
    "3. Synthesis — integration points, architecture decisions, open questions\n" +
    "4. See Also — dashboard URL\n\n" +
    "## Step 6: Verification Gate\n\n" +
    "- [ ] $TGD_DIR/CONTEXT.md exists and is non-empty\n" +
    "- [ ] $TGD_DIR/.scans/<repo>/.codegraph symlink exists\n" +
    "- [ ] $TGD_DIR/.scans/<repo>/.understand-anything symlink exists\n" +
    "- [ ] $TGD_DIR/.scans/<repo>/.understand-anything/knowledge-graph.json exists\n" +
    "- [ ] Dashboard is running for EVERY repo (localhost URLs confirmed)\n" +
    "- [ ] If additional repos were provided, their summaries appear in CONTEXT.md\n\n" +
    "After completing, suggest: /tgd-define",

  "tgd-define":
    "Run the `tgd-spec-driven-development` skill. Write a PRD (product requirements document) covering objectives, commands, structure, code style, testing strategy, and boundaries before any code is written. DEFINE phase.\n\n" +
    "Pre-flight: Check $TGD_DIR/CONTEXT.md exists (or .codegraph/ is present). If missing, STOP and tell user to run /tgd-map first. $TGD_DIR: Check env var $TGD_DIR first. If not set, check sibling ../<project-name>-tGD/\n\n" +
    "Pipeline:\n" +
    "1. `tgd-interview-me` — if the ask is underspecified, extract what the user actually wants\n" +
    "2. `tgd-idea-refine` — if the concept is vague, stress-test and expand options\n" +
    "3. Feature Name Resolution (Selection Protocol) — After the feature is discussed and the direction is clear, analyze the request and extract core action + object (e.g., 'user login' → action: login, object: user). Propose 3 kebab-case names that **directly reflect intent**: (a) most literal/direct, (b) action-focused, (c) domain-specific. Wait for user to pick by number. Once locked, create $TGD_DIR/<feature-name>/.\n" +
    "4. 🌿 Git Branch Setup — If on main/master, create and switch to feature/<feature-name> (git checkout -b feature/user-login).\n" +
    "5. `tgd-spec-driven-development` — write the structured spec (PRD + SPEC)\n\n" +
    "Multi-Repo Tagging: If CONTEXT.md lists multiple repos, SPEC.md MUST be tagged by repo. Use ## <repo-name> as section headers (e.g., ## Backend (my-project-backend), ## Frontend (my-project-frontend)).\n\n" +
    "Phase 1.5: UI Design Gate (MANDATORY CHECK via Selection Protocol)\n" +
    "After writing SPEC.md, ask: 'Does this feature have a UI component requiring DESIGN.md? 1. Yes (Generate design) 2. No (Backend only)'\n" +
    "If YES → (1) Run `tgd-sketch` skill to generate 2-3 HTML prototype variants in $TGD_DIR/<feature-name>/prototype/, (2) Present comparison table → user picks one by letter (or requests iteration), (3) Write DESIGN.md documenting the chosen design decisions and component tree, (4) Wait for user confirmation before proceeding\n" +
    "If NO → skip DESIGN.md and prototype. You cannot skip this step without explicit user approval.\n\n" +
    "Use `tgd-interview-me` first if the ask is underspecified. Use `tgd-idea-refine` if you have a rough concept but it's not concrete yet.\n\n" +
    "After completing the spec, verify the outputs.\n\n" +
    "Verification Gate:\n" +
    "- [ ] $TGD_DIR/ directory exists\n" +
    "- [ ] $TGD_DIR/<feature-name>/PRD.md exists and is non-empty\n" +
    "- [ ] $TGD_DIR/<feature-name>/SPEC.md exists and is non-empty\n" +
    "- [ ] Working branch is feature/<feature-name>\n" +
    "- [ ] If UI feature: $TGD_DIR/<feature-name>/DESIGN.md exists with Component Tree\n" +
    "- [ ] If UI feature: $TGD_DIR/<feature-name>/prototype/ contains at least 2 HTML variants\n\n" +
    "After completing, suggest: /tgd-plan",

  "tgd-plan":
    "Run the `tgd-planning-and-task-breakdown` skill. PLAN phase.\n\n" +
    "Pre-flight: Check $TGD_DIR/<feature>/SPEC.md exists. If missing, suggest /tgd-define first. $TGD_DIR: Check env var $TGD_DIR first. If not set, check sibling ../<project-name>-tGD/\n\n" +
    "Feature Name Resolution: Scan $TGD_DIR/ for subdirectories. If none: STOP, run /tgd-define. If one: lock as <feature-name>. If multiple: ask user to pick.\n\n" +
    "Pipeline:\n" +
    "1. Read the existing SPEC.md (and DESIGN.md if UI)\n" +
    "2. If .codegraph/ exists, run `codegraph impact` on core symbols to assess blast radius\n" +
    "3. Break into small, verifiable tasks\n" +
    "4. Create TASKS.md with ordered checklist\n" +
    "   Multi-Repo Tagging: If CONTEXT.md lists multiple repos, prefix each task with [repo-name] (e.g., [my-project-backend] Create auth endpoint).\n" +
    "5. 🔗 Jira Integration Gate (IMMEDIATELY after TASKS.md, do NOT skip):\n" +
    "   - Check JIRA_URL, JIRA_PROJECT, JIRA_TOKEN.\n" +
    "   - If ALL set → run `tgd-jira-auto-sync` automatically. Report keys, add to TASKS.md.\n" +
    "   - If NOT set → ask: \"📋 TASKS.md 已完成。🔗 要同步到 Jira 嗡？(y/n)\"\n" +
    "     - Yes → ask for JIRA_URL, JIRA_PROJECT, JIRA_TOKEN one at a time. Save to $TGD_DIR/.env. Then run `tgd-jira-auto-sync`.\n" +
    "     - No → skip.\n\n" +
    "Verification: TASKS.md exists with acceptance criteria per task.\n" +
    "After completing, suggest: /tgd-develop",

  "tgd-develop":
    "Run the `tgd-subagent-driven-development` or `tgd-incremental-implementation` skill. BUILD phase.\n\n" +
    "Pre-flight: Check TASKS.md, PRD.md, SPEC.md exist. If missing, suggest /tgd-define or /tgd-plan first. $TGD_DIR: Check env var $TGD_DIR first. If not set, check sibling ../<project-name>-tGD/\n\n" +
    "Feature Name Resolution: Scan $TGD_DIR/ for subdirectories. If none: STOP, run /tgd-define. If one: lock as <feature-name>. If multiple: ask user to pick.\n\n" +
    "Pipeline:\n" +
    "1. `tgd-context-engineering` — before modifying, run `codegraph callers` <symbol> to ensure backward compatibility\n" +
    "2. `tgd-source-driven-development`\n" +
    "3. Execute tasks in worktree (`tgd-subagent-driven-development` if >= 3 tasks, `tgd-incremental-implementation` if < 3)\n" +
    "4. `tgd-test-driven-development` — Red-Green-Refactor\n" +
    "5. `tgd-verification-before-completion`\n\n" +
    "Conditional: If unfamiliar code → the `understand` skill for architectural guidance.\n" +
    "Conditional: Touching UI? → `tgd-frontend-ui-engineering`\n" +
    "Conditional: Designing APIs? → `tgd-api-and-interface-design`\n" +
    "Conditional: High-stakes decision? → `tgd-doubt-driven-development`\n\n" +
    "Verification Gate:\n" +
    "- [ ] Source code files created/modified in src/\n" +
    "- [ ] Tests written AND passing for new logic in tests/\n" +
    "- [ ] Verification commands run and output confirmed\n" +
    "After completing, suggest: /tgd-verify",

  "tgd-verify":
    "Run the `tgd-debugging-and-error-recovery` skill. VERIFY phase.\n\n" +
    "Pre-flight: Check $TGD_DIR/CONTEXT.md exists (or .codegraph/ is present). If missing, STOP and tell user to run /tgd-map first. Source code files must exist in src/ and test files in tests/. If missing, suggest /tgd-develop first. $TGD_DIR: Check env var $TGD_DIR first. If not set, check sibling ../<project-name>-tGD/\n\n" +
    "Feature Name Resolution: Scan $TGD_DIR/ for subdirectories. If none: STOP, run /tgd-define. If one: lock as <feature-name>. If multiple: ask user to pick.\n\n" +
    "Pipeline:\n" +
    "1. `tgd-debugging-and-error-recovery` — reproduce → localize → reduce → fix → guard\n" +
    "2. `tgd-test-driven-development` — verify with the test pyramid (80% unit, 15% integration, 5% E2E)\n" +
    "   - Use `codegraph affected` <changed-files> to identify which tests to prioritize based on actual dependency paths.\n" +
    "3. Conditional: Frontend/UI/DOM? → MUST run `tgd-agent-browser`. Use `tgd-agent-browser` (preferred) to open the browser, perform the user action, and verify the DOM state.\n" +
    "   - Verification Gate Failure: If the feature touches frontend code but `tgd-agent-browser` did not run, the verification is FAILED.\n" +
    "4. Conditional: want visual impact? → the `understand-diff` skill\n\n" +
    "Verify that the feature works correctly before proceeding to review. Tests are proof — 'seems right' is never sufficient.\n" +
    "Verification: ALL tests pass, build succeeds.\n" +
    "Run the test-output capture first — raw evidence that backs the report:\n" +
    "Run from client repo root: bash \"$TGD_DIR/scripts/capture-test-output.sh\" \"$TGD_DIR/<feature-name>/TEST-REPORT.md\"\n" +
    "Exit 0 = tests passed, raw output captured. Use real numbers from the meta-comment in the Summary table — do NOT invent counts.\n" +
    "Exit 1 = tests failed, raw output still captured. Fix and re-run.\n" +
    "After capturing raw output, create $TGD_DIR/<feature-name>/TEST-REPORT.md using this template:\n" +
    "# TEST-REPORT: [Feature Name]\n" +
    "> Date: YYYY-MM-DD\n" +
    "## 1. Test Summary — table: Suite/Passed/Failed/Skipped, exit code\n" +
    "## 2. Coverage — table: Lines/Branches/Functions\n" +
    "## 3. Failures & Root Causes — table: Test/Error/Root Cause/Fix Applied\n" +
    "## 4. Regression Status — checkboxes: regression-gate.sh exits 0, no regressions\n" +
    "## Sign-off — QA (pending)\n" +
    "Cross-Feature Regression Gate (MANDATORY if $TGD_DIR/REGRESSION-CATALOG.md exists):\n" +
    "Run the machine gate — do NOT manually walk the catalog.\n" +
    "Run from client repo root: bash \"$TGD_DIR/scripts/regression-gate.sh\"\n" +
    "Exit 0 = all catalog entries verified, proceed.\n" +
    "Exit 1 = test suite failed OR catalog entry test file missing. STOP. Report which prior feature's regression test broke.\n" +
    "Exit 2 = no catalog yet (first release) OR no test runner detected.\n" +
    "Why machine-gated: Manually walking the catalog is the exact failure mode this gate prevents — agents skip entries, run the wrong file, or trust stale references. The script enforces 'all entries run' and 'no stale references' without exception.\n" +
    "A broken regression test means your feature broke a previously shipped critical path. Hard fail.\n" +
    "Verification Gate: Tests pass, TEST-REPORT.md exists, regression-gate.sh exit 0.\n" +
    "After completing, suggest: /tgd-review",

  "tgd-review":
    "Run the `tgd-code-review-and-quality` skill. REVIEW phase.\n\n" +
    "Pre-flight: Check $TGD_DIR/CONTEXT.md exists (or .codegraph/ is present). If missing, STOP and tell user to run /tgd-map first. Test files must exist in tests/. If missing, suggest /tgd-verify first. $TGD_DIR: Check env var $TGD_DIR first. If not set, check sibling ../<project-name>-tGD/\n\n" +
    "Feature Name Resolution: Scan $TGD_DIR/ for subdirectories. If none: STOP, run /tgd-define. If one: lock as <feature-name>. If multiple: ask user to pick.\n\n" +
    "Pipeline:\n" +
    "1. `tgd-code-review-and-quality` (5-axis review) — run `codegraph callers` + `codegraph affected` to verify impact coverage\n" +
    "2. `tgd-code-simplification` — apply Chesterton's Fence, reduce complexity while preserving exact behavior\n" +
    "3. Conditional: security concerns? → `tgd-security-and-hardening`\n" +
    "4. Conditional: performance concerns? → `tgd-performance-optimization`\n" +
    "5. Conditional: large/unfamiliar changes? → the `understand-diff` skill for blast radius visualization\n\n" +
    "Verification: Code review passes, no anti-patterns.\n" +
    "REVIEW.md template (save to $TGD_DIR/<feature-name>/REVIEW.md):\n" +
    "# REVIEW: [Feature Name]\n" +
    "> Date: YYYY-MM-DD\n" +
    "## 1. Code Review Findings — table: #/Severity/File:Line/Issue/Recommendation (🔴 Critical · 🟡 Optional · 🟢 Nit)\n" +
    "## 2. Security Scan — tool, findings, status (Pass/Warnings/Fail)\n" +
    "## 3. Performance Analysis — concerns, status\n" +
    "## 4. Simplification — applied, lines reduced\n" +
    "## Sign-off — QA (pending), DEV (pending)\n" +
    "If architectural decisions: create $TGD_DIR/<feature-name>/decisions/ADR-NNN-<decision>.md — sections: Date, Status, Context, Decision, Consequences (Positive/Negative/Risks).\n" +
    "Verification Gate: Code review feedback addressed, no critical warnings, REVIEW.md exists.\n" +
    "After completing, suggest: /tgd-release",

  "tgd-release":
    "Run the `tgd-shipping-and-launch` skill. SHIP phase.\n\n" +
    "Pre-flight: Check $TGD_DIR/CONTEXT.md exists (or .codegraph/ is present). If missing, STOP and tell user to run /tgd-map first. Review passed (no critical issues) and $TGD_DIR/<feature>/REVIEW.md exists. If missing, suggest /tgd-review first. $TGD_DIR: Check env var $TGD_DIR first. If not set, check sibling ../<project-name>-tGD/\n\n" +
    "Feature Name Resolution: Scan $TGD_DIR/ for subdirectories. If none: STOP, run /tgd-define. If one: lock as <feature-name>. If multiple: ask user to pick.\n\n" +
    "Pipeline:\n" +
    "1. `tgd-git-workflow-and-versioning`\n" +
    "2. `tgd-shipping-and-launch`\n" +
    "3. If CI/CD exists: `tgd-ci-cd-and-automation`\n" +
    "4. If writing docs: `tgd-documentation-and-adrs`\n\n" +
    "Verification: Changes committed, tests pass, deployment successful.\n" +
    "After shipping, update $TGD_DIR/CHANGELOG.md (create if it doesn't exist) with: version (CalVer), feature name, date shipped, key changes.\n" +
    "Regression Catalog Update: After shipping, scan $TGD_DIR/<feature-name>/TASKS.md for [R] marked Acceptance Criteria.\n" +
    "For EACH [R] criterion: extract the BDD criterion (Given/When/Then), identify the actual test file from tests/,\n" +
    "append to $TGD_DIR/REGRESSION-CATALOG.md (create if needed).\n" +
    "If creating fresh, add header: # Regression Catalog — cumulative [R] tests, every entry must point to existing passing test, last audited date.\n" +
    "Each entry: ### [<feature-name>] Short description — Criterion: Given X, When Y, Then Z — Test: tests/path/to/test.ts — Shipped: vYYYY.MM.DD\n" +
    "This catalog is cumulative. Future features will re-run ALL entries during /tgd-verify.\n" +
    "Regression Catalog Audit (MANDATORY if REGRESSION-CATALOG.md exists): Before finalizing ship, audit for staleness.\n" +
    "1. Read every entry. 2. Check: test file exists? Run it, passes? Feature deprecated? 3. If broken path: remove entry, log in CHANGELOG.md Catalog Cleanup section.\n" +
    "4. If test fails: STOP (regression). 5. If feature deprecated this cycle: remove entries. After audit, catalog contains ONLY passing, existing entries.\n" +
    "Verification Gate: Git commit created, CHANGELOG.md updated, REGRESSION-CATALOG.md updated with [R] entries (if any), Catalog Audit completed (all entries exist and pass).\n" +
    "After completing, suggest: /tgd-map for the next feature",
};

export default function (pi: ExtensionAPI) {
  // Inject tGD rules at session start
  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.notify("tGD workflow loaded. Use /tgd-map to begin.", "info");
  });

  // Register 7 lifecycle slash commands
  for (const [name, description] of [
    ["tgd-map", "Map — scan and understand the existing project context"],
    ["tgd-define", "Define — write PRD + SPEC before any code"],
    ["tgd-plan", "Plan — break spec into small verifiable tasks"],
    ["tgd-develop", "Build — implement thin vertical slices with tests"],
    ["tgd-verify", "Verify — debug, test, and prove it works"],
    ["tgd-review", "Review — code review, quality gates, simplification"],
    ["tgd-release", "Release — clean git history, deploy safely"],
  ] as [string, string][]) {
    pi.registerCommand(name, {
      description,
      handler: async (_args, ctx) => {
        const prompt = tgdPrompts[name];
        if (prompt) {
          ctx.ui.notify(`Running ${name}...`, "info");
          pi.sendUserMessage(prompt);
        }
      },
    });
  }
}
