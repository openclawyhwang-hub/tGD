// tGD Pi Extension — Registers 8 lifecycle slash commands
// Compatible with pi-coding-agent 0.75.x

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const tgdPrompts: Record<string, string> = {
  "tgd-map":
    "Run the context-engineering skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.\n\n" +
    "1. mkdir -p tGD/map\n" +
    "2. rm -rf .codegraph && ln -s tGD/map/.codegraph .codegraph\n" +
    "3. codegraph init -i\n\n" +
    "Outputs: tGD/map/CONTEXT.md, tGD/map/.codegraph/codegraph.db\n" +
    "Verification: tGD/map/CONTEXT.md exists and is non-empty.\n" +
    "After completing, suggest: /tgd-define",

  "tgd-define":
    "Run the spec-driven-development skill. DEFINE phase.\n\n" +
    "Pre-flight: Check tGD/map/CONTEXT.md exists. If missing, STOP and tell user to run /tgd-map first.\n\n" +
    "Pipeline:\n" +
    "1. Derive kebab-case feature name\n" +
    "2. Create tGD/<feature>/ directory\n" +
    "3. Run interview-me if underspecified\n" +
    "4. Run idea-refine if vague\n" +
    "5. Run spec-driven-development to write PRD.md + SPEC.md\n\n" +
    "Verification: tGD/<feature>/PRD.md and SPEC.md exist.\n" +
    "After completing, suggest: /tgd-plan",

  "tgd-plan":
    "Run the planning-and-task-breakdown skill. PLAN phase.\n\n" +
    "Pre-flight: Check tGD/<feature>/SPEC.md exists. If missing, suggest /tgd-define first.\n\n" +
    "Pipeline:\n" +
    "1. Read the existing SPEC.md\n" +
    "2. Break into small, verifiable tasks\n" +
    "3. Create TASKS.md with ordered checklist\n" +
    "4. If Jira integration available, run jira-auto-sync\n\n" +
    "Verification: TASKS.md exists with acceptance criteria per task.\n" +
    "After completing, suggest: /tgd-develop",

  "tgd-develop":
    "Run the incremental-implementation skill. BUILD phase.\n\n" +
    "Pre-flight: Check TASKS.md exists. If missing, suggest /tgd-plan first.\n\n" +
    "Pipeline:\n" +
    "1. context-engineering\n" +
    "2. source-driven-development\n" +
    "3. incremental-implementation — thin vertical slices\n" +
    "4. test-driven-development\n" +
    "5. If touching UI: frontend-ui-engineering\n" +
    "6. If designing APIs: api-and-interface-design\n\n" +
    "Verification: All tasks in TASKS.md checked off.\n" +
    "After completing, suggest: /tgd-verify",

  "tgd-verify":
    "Run the debugging-and-error-recovery skill. VERIFY phase.\n\n" +
    "Pipeline:\n" +
    "1. debugging-and-error-recovery if anything fails\n" +
    "2. test-driven-development to prove all tests pass\n" +
    "3. If browser-based: browser-testing-with-devtools\n\n" +
    "Verification: ALL tests pass, build succeeds.\n" +
    "After completing, suggest: /tgd-review",

  "tgd-review":
    "Run the code-review-and-quality skill. REVIEW phase.\n\n" +
    "Pipeline:\n" +
    "1. code-review-and-quality (5-axis review)\n" +
    "2. code-simplification\n" +
    "3. If security concerns: security-and-hardening\n" +
    "4. If performance concerns: performance-optimization\n\n" +
    "Verification: Code review passes, no anti-patterns.\n" +
    "After completing, suggest: /tgd-simplify or /tgd-ship",

  "tgd-simplify":
    "Run the code-simplification skill.\n\n" +
    "1. Identify over-engineered abstractions\n" +
    "2. Reduce line count while preserving functionality\n" +
    "3. Remove dead code and unnecessary complexity\n\n" +
    "Verification: Fewer lines, same behavior, tests pass.\n" +
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

  // Register 8 lifecycle slash commands
  for (const [name, description] of [
    ["tgd-map", "Map — scan and understand the existing project context"],
    ["tgd-define", "Define — write PRD + SPEC before any code"],
    ["tgd-plan", "Plan — break spec into small verifiable tasks"],
    ["tgd-develop", "Build — implement thin vertical slices with tests"],
    ["tgd-verify", "Verify — debug, test, and prove it works"],
    ["tgd-review", "Review — code review, quality gates, simplification"],
    ["tgd-simplify", "Simplify — remove complexity, reduce line count"],
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
