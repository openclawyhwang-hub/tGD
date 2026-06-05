// tGD Pi Extension — Registers 8 lifecycle slash commands
// Compatible with pi-coding-agent 0.75.x

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const tgdPrompts: Record<string, string> = {
  "tgd-map":
    "Run the context-engineering skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.\n\n" +
    "1. mkdir -p tGD/map\n" +
    "2. rm -rf .codegraph && ln -s tGD/map/.codegraph .codegraph\n" +
    "3. codegraph init -i\n" +
    "4. rm -rf .understand-anything && ln -s tGD/map/.understand-anything .understand-anything\n" +
    "5. Run /understand to build knowledge graph → produces tGD/map/.understand-anything/knowledge-graph.json\n" +
    "6. Run /understand-dashboard to launch interactive visualization\n\n" +
    "Outputs: tGD/map/CONTEXT.md (must reference CodeGraph/UA data), .codegraph/codegraph.db, .understand-anything/knowledge-graph.json\n" +
    "Verification: tGD/map/CONTEXT.md exists and is non-empty, .codegraph and .understand-anything symlinks exist.\n" +
    "After completing, suggest: /tgd-define",

  "tgd-define":
    "Run the spec-driven-development skill. DEFINE phase.\n\n" +
    "Pre-flight: Check tGD/map/CONTEXT.md exists. If missing, STOP and tell user to run /tgd-map first.\n\n" +
    "Pipeline:\n" +
    "1. Feature Name Resolution (Selection Protocol) — propose 3 kebab-case names. Wait for user to pick by number.\n" +
    "2. Create tGD/define/<feature>/ directory\n" +
    "3. Run interview-me if underspecified\n" +
    "4. Run idea-refine if vague\n" +
    "5. Run spec-driven-development to write PRD.md + SPEC.md\n\n" +
    "Phase 1.5: UI Design Gate (MANDATORY via Selection Protocol)\n" +
    "After SPEC.md, ask: 'Does this feature have a UI component requiring DESIGN.md? 1. Yes 2. No'\n" +
    "If YES → generate 3 design variants → user picks by letter → write DESIGN.md → wait for confirmation\n" +
    "If NO → skip DESIGN.md (cannot skip without explicit user approval)\n\n" +
    "Verification: PRD.md and SPEC.md exist. If UI: DESIGN.md exists and user confirmed.\n" +
    "After completing, suggest: /tgd-plan",

  "tgd-plan":
    "Run the planning-and-task-breakdown skill. PLAN phase.\n\n" +
    "Pre-flight: Check tGD/define/<feature>/SPEC.md exists. If missing, suggest /tgd-define first.\n\n" +
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
    "After completing, suggest: /tgd-simplify or /tgd-ship",

  "tgd-simplify":
    "Run the code-simplification skill.\n\n" +
    "1. Before deleting code, run codegraph callers <symbol> to confirm nothing depends on it\n" +
    "2. Identify over-engineered abstractions\n" +
    "3. Reduce line count while preserving functionality\n" +
    "4. Remove dead code and unnecessary complexity\n\n" +
    "Conditional: Need to understand complex structure first? → /understand\n" +
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
