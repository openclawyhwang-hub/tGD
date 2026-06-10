// tGD Pi Extension — Registers 8 lifecycle slash commands
// Compatible with pi-coding-agent 0.75.x

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const tgdPrompts: Record<string, string> = {
  "tgd-map":
    "## Step 1: Context Discovery\n\n" +
    "Before analyzing anything, ask the user:\n" +
    "> \"除了當前 repo，還有其他需要參考的 repo 嗎？（local path 或 git URL）\"\n\n" +
    "- Accept local paths (e.g. ~/Projects/wayflow) — resolve to absolute path\n" +
    "- Accept git URLs (e.g. github.com/CopilotKit/CopilotKit) — clone to /tmp/tgd-context/<repo-name>\n" +
    "- If user says \"no\" or provides nothing, proceed with primary repo only\n\n" +
    "## Step 2: Context Engineering\n\n" +
    "Run the context-engineering skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.\n\n" +
    "## Step 3: CodeGraph Setup\n\n" +
    "1. mkdir -p tGD/map\n" +
    "2. rm -rf .codegraph && ln -s $TGD_DIR/.codegraph .codegraph\n" +
    "3. codegraph init -i\n\n" +
    "## Step 4: Understand-Anything (MANDATORY)\n\n" +
    "This step is required, not optional.\n\n" +
    "1. rm -rf .understand-anything && ln -s $TGD_DIR/.understand-anything .understand-anything\n" +
    "2. Run /understand to build knowledge graph → produces $TGD_DIR/.understand-anything/knowledge-graph.json\n" +
    "3. Run /understand-dashboard to launch interactive visualization\n" +
    "4. If additional repos were provided in Step 1, run /understand on each of them as well\n\n" +
    "## Step 5: Produce CONTEXT.md\n\n" +
    "CONTEXT.md must include:\n" +
    "1. Primary Repository — path, name, structure, key files, summary, code entry points\n" +
    "2. Additional Context Repositories — for each: source, resolved path, summary, key insights, relevance\n" +
    "3. Synthesis — integration points, architecture decisions, open questions\n" +
    "4. See Also — dashboard URL\n\n" +
    "## Step 6: Verification Gate\n\n" +
    "- [ ] $TGD_DIR/CONTEXT.md exists and is non-empty\n" +
    "- [ ] $TGD_DIR/.codegraph symlink exists\n" +
    "- [ ] $TGD_DIR/.understand-anything symlink exists\n" +
    "- [ ] $TGD_DIR/.understand-anything/knowledge-graph.json exists\n" +
    "- [ ] If additional repos were provided, their summaries appear in CONTEXT.md\n\n" +
    "After completing, suggest: /tgd-define",

  "tgd-define":
    "Run the spec-driven-development skill. Write a PRD (product requirements document) covering objectives, commands, structure, code style, testing strategy, and boundaries before any code is written. DEFINE phase.\n\n" +
    "Pre-flight: Check $TGD_DIR/CONTEXT.md exists (or .codegraph/ is present). If missing, STOP and tell user to run /tgd-map first.\n\n" +
    "Pipeline:\n" +
    "1. Feature Name Resolution (Selection Protocol) — **Analyze the user's request first.** Extract core action + object (e.g., 'user login' → action: login, object: user). Propose 3 kebab-case names that **directly reflect intent**: (a) most literal/direct, (b) action-focused, (c) domain-specific. Wait for user to pick by number. Once locked, create $TGD_DIR/<feature-name>/.\n" +
    "2. Git Branch Setup — If on main/master, create and switch to feature/<feature-name> (git checkout -b feature/user-login).\n" +
    "3. interview-me — if the ask is underspecified, extract what the user actually wants\n" +
    "4. idea-refine — if the concept is vague, stress-test and expand options\n" +
    "5. spec-driven-development — write the structured spec (PRD + SPEC)\n\n" +
    "Phase 1.5: UI Design Gate (MANDATORY CHECK via Selection Protocol)\n" +
    "After writing SPEC.md, ask: 'Does this feature have a UI component requiring DESIGN.md? 1. Yes (Generate design) 2. No (Backend only)'\n" +
    "If YES → (1) Run sketch skill to generate 2-3 HTML prototype variants in $TGD_DIR/<feature-name>/prototype/, (2) Present comparison table → user picks one by letter (or requests iteration), (3) Write DESIGN.md documenting the chosen design decisions and component tree, (4) Wait for user confirmation before proceeding\n" +
    "If NO → skip DESIGN.md and prototype. You cannot skip this step without explicit user approval.\n\n" +
    "Use interview-me first if the ask is underspecified. Use idea-refine if you have a rough concept but it's not concrete yet.\n\n" +
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
    "Run the planning-and-task-breakdown skill. PLAN phase.\n\n" +
    "Pre-flight: Check $TGD_DIR/<feature>/SPEC.md exists. If missing, suggest /tgd-define first.\n\n" +
    "Pipeline:\n" +
    "1. Read the existing SPEC.md (and DESIGN.md if UI)\n" +
    "2. If .codegraph/ exists, run codegraph impact on core symbols to assess blast radius\n" +
    "3. Break into small, verifiable tasks\n" +
    "4. Create TASKS.md with ordered checklist\n" +
    "5. If Jira integration available, run jira-auto-sync\n\n" +
    "Verification: TASKS.md exists with acceptance criteria per task.\n" +
    "After completing, suggest: /tgd-develop",

  "tgd-develop":
    "Run the subagent-driven-development or incremental-implementation skill. BUILD phase.\n\n" +
    "Pre-flight: Check TASKS.md, PRD.md, SPEC.md exist. If missing, suggest /tgd-define or /tgd-plan first.\n\n" +
    "Pipeline:\n" +
    "1. context-engineering — before modifying, run codegraph callers <symbol> to ensure backward compatibility\n" +
    "2. source-driven-development\n" +
    "3. Execute tasks in worktree (subagent-driven if >= 3 tasks, incremental if < 3)\n" +
    "4. test-driven-development — Red-Green-Refactor\n" +
    "5. verification-before-completion\n\n" +
    "Conditional: If unfamiliar code → /understand for architectural guidance.\n" +
    "Verification: All tasks checked off, tests pass.\n" +
    "After completing, suggest: /tgd-verify",

  "tgd-verify":
    "Run the debugging-and-error-recovery skill. VERIFY phase.\n\n" +
    "Pipeline:\n" +
    "1. debugging-and-error-recovery if anything fails\n" +
    "2. test-driven-development — use codegraph affected <changed-files> to prioritize relevant tests\n" +
    "3. Conditional: browser-based? → agent-browser\n" +
    "4. Conditional: want visual impact? → /understand-diff\n\n" +
    "Verification: ALL tests pass, build succeeds.\n" +
    "After completing, suggest: /tgd-review",

  "tgd-review":
    "Run the code-review-and-quality skill. REVIEW phase.\n\n" +
    "Pipeline:\n" +
    "1. code-review-and-quality (5-axis review) — run codegraph callers + affected to verify impact coverage\n" +
    "2. code-simplification\n" +
    "3. Conditional: security concerns? → security-and-hardening\n" +
    "4. Conditional: performance concerns? → performance-optimization\n" +
    "5. Conditional: large/unfamiliar changes? → /understand-diff for blast radius visualization\n\n" +
    "Verification: Code review passes, no anti-patterns.\n" +
    "After completing, suggest: /tgd-ship",


  "tgd-ship":
    "Run the shipping-and-launch skill. SHIP phase.\n\n" +
    "Pipeline:\n" +
    "1. git-workflow-and-versioning\n" +
    "2. shipping-and-launch\n" +
    "3. If CI/CD exists: ci-cd-and-automation\n" +
    "4. If writing docs: documentation-and-adrs\n\n" +
    "Verification: Changes committed, tests pass, deployment successful.\n" +
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
    
    ["tgd-ship", "Ship — clean git history, deploy safely"],
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
