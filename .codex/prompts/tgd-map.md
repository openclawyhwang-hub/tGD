# /tgd-map

Map — scan and understand the existing project context before making changes

## Step 1: Context Discovery

Before analyzing anything, ask the user:

> "除了當前 repo，還有其他需要參考的 repo 嗎？（local path 或 git URL）"

- Accept local paths (e.g. ~/Projects/wayflow) — resolve to absolute path
- Accept git URLs (e.g. github.com/CopilotKit/CopilotKit) — clone to /tmp/tgd-context/<repo-name>
- If user says "no" or provides nothing, proceed with primary repo only
- Store results for CONTEXT.md (see structure below)

## Step 2: Context Engineering

Run the context-engineering skill. Analyze the current project: tech stack, architecture, dependencies, code organization, and existing patterns.

## Step 3: CodeGraph Setup

For each repo to map (primary + all additional repos from Step 1):

1. Ensure output dir exists: mkdir -p $TGD_DIR/.scans/<repo-name>
2. Create symlink: rm -rf <repo-path>/.codegraph && ln -s $TGD_DIR/.scans/<repo-name>/.codegraph <repo-path>/.codegraph
3. cd into the repo and run: codegraph init -i

## Step 4: Understand-Anything (MANDATORY)

This step is required, not optional.

For each repo to map (primary + all additional repos from Step 1):

1. Create symlink: rm -rf <repo-path>/.understand-anything && ln -s $TGD_DIR/.scans/<repo-name>/.understand-anything <repo-path>/.understand-anything
2. cd into the repo and run /understand to build a full knowledge graph
3. Produces $TGD_DIR/.scans/<repo-name>/.understand-anything/knowledge-graph.json
4. After ALL repos are mapped, run /understand-dashboard from the primary repo to launch the interactive visualization
5. If unfamiliar with any repo, run /understand-onboard for a guided tour

Dashboard is launched only once from the primary repo — it reads the primary's knowledge graph. To inspect additional repos visually, run /understand-dashboard from each repo path separately.

## Step 5: Produce CONTEXT.md

Outputs (all under $TGD_DIR/):
- CONTEXT.md — project structure analysis (MUST reference CodeGraph/UA data)
- .codegraph/codegraph.db — symbol index (via symlink)
- .understand-anything/knowledge-graph.json — knowledge graph (via symlink)
- .understand-anything/config.json — UA config
- Interactive dashboard — launched via /understand-dashboard (localhost)

CONTEXT.md Structure:
When writing CONTEXT.md, DO NOT rely solely on visual inspection of code.
Synthesize data from the tools:

  # CONTEXT.md

  ## 1. Primary Repository
  Path: <absolute path>
  Name: <repo name>

  ### Structure
  <directory tree>

  ### Key Files
  <important files and their roles>

  ### Summary
  <tech stack, architecture, patterns — from UA knowledge graph>

  ### Code Entry Points
  <from CodeGraph>

  ## 2. Additional Context Repositories
  (For each additional repo provided in Step 1:)

  ### <repo-name> (<type: local_path | git_url>)
  Source: <original input>
  Resolved to: <absolute path or clone path>
  Summary: <what this repo does>

  Key Insights:
  - <insight 1>
  - <insight 2>

  Relevance: <why this repo is relevant to the primary project>

  ## 3. Synthesis
  ### Integration Points
  - <how repos relate to each other>

  ### Architecture Decisions
  - <key decisions based on combined context>

  ### Open Questions
  - <unresolved questions>

  ## See Also
  - Interactive Dashboard: http://localhost:<port>

## Step 6: Verification Gate

- [ ] $TGD_DIR/CONTEXT.md exists and is non-empty
- [ ] $TGD_DIR/.scans/<repo>/.codegraph symlink exists
- [ ] $TGD_DIR/.scans/<repo>/.understand-anything symlink exists
- [ ] $TGD_DIR/.scans/<repo>/.understand-anything/knowledge-graph.json exists
- [ ] If additional repos were provided, their summaries appear in CONTEXT.md

If verification passes, suggest: /tgd-define to start defining what to build.
