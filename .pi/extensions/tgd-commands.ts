// tGD Pi Extension — Registers 8 lifecycle slash commands
// Each command triggers the corresponding tGD skill pipeline
// Install: place in .pi/extensions/ or ~/.pi/agent/extensions/

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

export default function tgdCommands(ctx: ExtensionContext, pi: ExtensionAPI) {
  const commands = [
    {
      name: "tgd-map",
      description: "Map — scan and understand the existing project context",
      prompt: `Run the context-engineering skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.

1. Ensure output directory exists: mkdir -p tGD/map
2. Create symlink: rm -rf .codegraph && ln -s tGD/map/.codegraph .codegraph
3. Initialize project graph: codegraph init -i

Outputs:
- tGD/map/CONTEXT.md
- tGD/map/.codegraph/codegraph.db

Verification: tGD/map/CONTEXT.md exists and is non-empty.

After completing, suggest: /tgd-define to start defining what to build.`,
    },
    {
      name: "tgd-define",
      description: "Define — write PRD + SPEC before any code",
      prompt: `Run the spec-driven-development skill. This is the DEFINE phase.

Pre-flight: Check tGD/map/CONTEXT.md exists. If missing, STOP and tell user to run /tgd-map first.

Pipeline:
1. Derive kebab-case <feature-name> from the user's request
2. Create tGD/<feature-name>/ directory
3. If on main/master, create branch: git checkout -b feature/<feature-name>
4. Run interview-me if the ask is underspecified
5. Run idea-refine if the concept is vague
6. Run spec-driven-development to write PRD.md + SPEC.md
7. If frontend: create DESIGN.md with Component Tree

Verification:
- tGD/<feature-name>/PRD.md exists
- tGD/<feature-name>/SPEC.md exists
- Working branch is feature/<feature-name>

After completing, suggest: /tgd-plan to decompose into tasks.`,
    },
    {
      name: "tgd-plan",
      description: "Plan — decompose specs into atomic tasks",
      prompt: `Run the planning-and-task-breakdown skill. This is the PLAN phase.

Pre-flight:
- Check tGD/map/CONTEXT.md exists. If missing, /tgd-map first.
- Scan tGD/ for feature subdirectories. If none, /tgd-define first.
- Check tGD/<feature>/PRD.md and SPEC.md exist. If missing, /tgd-define first.

1. Read PRD.md and SPEC.md
2. Decompose into small, verifiable tasks with acceptance criteria
3. Order by dependencies
4. Write tGD/<feature>/TASKS.md
5. If jira-auto-sync skill available, sync to Jira

Verification:
- tGD/<feature>/TASKS.md exists and is non-empty
- Each task has acceptance criteria

After completing, suggest: /tgd-develop to start building.`,
    },
    {
      name: "tgd-develop",
      description: "Build — implement one thin vertical slice at a time",
      prompt: `Run the incremental-implementation skill. This is the BUILD phase.

Pre-flight:
- Check tGD/map/CONTEXT.md exists. If missing, /tgd-map first.
- Check tGD/<feature>/TASKS.md exists. If missing, /tgd-plan first.

Core flow:
1. context-engineering — load right spec sections for current task
2. source-driven-development — ground decisions in official docs
3. incremental-implementation — build thin slices: implement → test → verify → commit
4. test-driven-development — Red-Green-Refactor for each slice

Conditional:
- Frontend? → frontend-ui-engineering
- API? → api-and-interface-design
- High stakes? → doubt-driven-development

One slice at a time. Never implement multiple tasks at once.

After completing, suggest: /tgd-verify to prove it works.`,
    },
    {
      name: "tgd-verify",
      description: "Verify — prove it works with tests and debugging",
      prompt: `Run the debugging-and-error-recovery skill. This is the VERIFY phase.

Pre-flight:
- Check source code exists in src/. If missing, /tgd-develop first.
- Check test files exist in tests/. If missing, /tgd-develop first.

Core flow:
1. debugging-and-error-recovery — five-step triage: reproduce → localize → reduce → fix → guard
2. test-driven-development — verify with test pyramid (80% unit, 15% integration, 5% E2E)

Conditional:
- Browser-based? → webwright or browser-testing-with-devtools

Tests are proof. "seems right" is never sufficient.

After completing, suggest: /tgd-review for code quality review.`,
    },
    {
      name: "tgd-review",
      description: "Review — improve code health before merge",
      prompt: `Run the code-review-and-quality skill. This is the REVIEW phase.

Pre-flight:
- Check test files exist in tests/. If missing, /tgd-verify first.

Core flow:
1. code-review-and-quality — five-axis review with severity labels (Nit/Optional/FYI)
2. code-simplification — Chesterton's Fence, reduce complexity

Conditional:
- Security concerns? → security-and-hardening
- Performance concerns? → performance-optimization

If change > ~100 lines, split into smaller reviews.

After completing, suggest: /tgd-simplify or /tgd-ship.`,
    },
    {
      name: "tgd-simplify",
      description: "Simplify — clarity over cleverness",
      prompt: `Run the code-simplification skill.

Pre-flight:
- Check source code exists in src/. If missing, /tgd-develop first.

Apply Chesterton's Fence and Rule of 500. Reduce complexity, eliminate dead code, improve readability while preserving exact behavior.

Verification:
- Code complexity reduced
- All existing tests still pass
- No behavior changes introduced

After completing, suggest: /tgd-review or /tgd-ship.`,
    },
    {
      name: "tgd-ship",
      description: "Ship — deploy with confidence",
      prompt: `Run the shipping-and-launch skill. This is the SHIP phase.

Pre-flight:
- Check review passed (no critical issues).
- Check tGD/<feature>/REVIEW.md exists.
- Check tests/ exists and passes.
If missing, /tgd-review first.

Core flow:
1. git-workflow-and-versioning — clean commit history, trunk-based development
2. shipping-and-launch — pre-launch checklist, staged rollouts, monitoring

Conditional:
- CI/CD pipeline? → ci-cd-and-automation
- Removing old systems? → deprecation-and-migration

Faster is safer.`,
    },
  ];

  for (const cmd of commands) {
    pi.registerCommand(cmd.name, {
      description: cmd.description,
      handler: async (input: string) => {
        // Send the command prompt as a user message to trigger the skill pipeline
        const fullPrompt = input
          ? `${cmd.prompt}\n\nUser request: ${input}`
          : cmd.prompt;
        await pi.sendUserMessage(fullPrompt);
      },
    });
  }
}
