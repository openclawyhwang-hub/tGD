# Changelog

All notable changes to tGD will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/). Versions follow [CalVer](https://calver.org/) (YYYY.MM.DD).

---

## v2026.06.16

### Changed
- **`$TGD_DIR` symlink → env var + sibling fallback** — removed `tGD/` symlink, all commands now resolve via `$TGD_DIR` env var or `../<project>-tGD/` sibling (`1d78056`)
  - `tgd-map`: env var first → sibling fallback → first-time user confirmation → CI silent skip
  - 28 skills: all hardcoded `tGD/` paths replaced with `$TGD_DIR`
  - `.codegraph` / `.understand-anything` symlinks point directly to `$TGD_DIR/.scans/<repo>/`
- **Skill name syntax** — bare name `` `understand` `` instead of `/understand` (slash is Claude-only) across all 5 platforms + skills + READMEs (`e5ae16b`)
- **AC format** — BDD (Given/When/Then) mandatory for all tasks, ensuring consistency between TASKS.md and REGRESSION-CATALOG.md (`23a7d69`, reverted `de3e80d`)

### Fixed
- **Pre-flight stale references** — all lifecycle commands (define through ship) still referenced removed `tGD/` symlink for resolution and feature scanning (`1a7dd50`)
- **README + GitHub Pages** — 4-language READMEs, `index.html`, and `web/` dashboard updated to reflect direct symlink architecture (`c49d3c3`, `3d643d0`)

## v2026.06.15

### Added
- **REGRESSION-CATALOG mechanism** — cumulative cross-feature regression tracking across shipped features (`c0e2a63`)
  - `/tgd-plan`: `[R]` marks ensure a corresponding test is created during `/tgd-develop` (TDD)
  - `/tgd-ship`: writes `[R]` entries to `REGRESSION-CATALOG.md` (cumulative — every shipped feature preserved)
  - `/tgd-ship`: **Catalog Audit** — prunes stale/missing/deprecated entries on each ship, prevents zombie catalog
  - `/tgd-verify`: **Cross-Feature Regression Gate** — reads catalog, re-runs ALL entries before approve, hard fail on any regression

### Fixed
- **5-platform parity** — 19 files synced across Claude / OpenCode / Codex / Gemini / Pi (`c0e2a63`)
  - `tgd-map`: dashboard per repo, subagent allowance, Step 5 verification
  - `tgd-verify`: Cross-Feature Regression Gate + Catalog Audit
  - `tgd-ship`: Regression Catalog Update + Audit
  - Codex 4 commands: add Step 0 + Pre-flight + codegraph
  - OpenCode 3 commands: add codegraph + /understand-diff
  - Gemini verify: webwright → agent-browser
  - Pi verify: test pyramid + agent-browser gate

### Docs
- README (EN/zh-TW/JA/DE) — updated regression section + pipeline table to reflect REGRESSION-CATALOG
- docs/tGD-intro.html — verify slide adds Cross-Feature Regression Gate, ship slide adds Catalog Update + Audit
- docs/web/js/phases.js — verify + ship phase definitions updated
- docs/index.html — pipeline table + regression section updated
- docs/getting-started.md — pipeline table updated

---

## v2026.06.13

### Added
- **Multi-repo task tagging in `/tgd-define` and `/tgd-plan`** — agents now tag SPEC.md sections and TASKS.md tasks with `[repo-name]` for multi-repo projects (`6fef3d2`)
- **`$TGD_DIR` resolution in `/tgd-map`** — defines sibling-directory + symlink pattern, prevents agent guesswork (`ca38ed4`)
- **Centralized scan storage** — `.codegraph/` and `.understand-anything/` moved to `$TGD_DIR/.scans/<repo>/` with symlinks (`cc2fb1a`)
- **Decisions/ folder in `/tgd-review`** — creates ADRs when architectural decisions are made (`5bf47ff`)

### Changed
- **`understand-dashboard`** auto-opens browser on launch (`07a678f`)
- **3 understand skills** now explicitly tell agents they ARE the LLM — prevents accidental external API calls (`6b88f7f`)

### Fixed
- **HTML pages** — corrected artifact names (`VERIFY.md` → `TEST-REPORT.md`, `SHIP.md` → `CHANGELOG.md`), JA/DE command count (8→7), slide numbering, removed `glow-breathe` animation that broke GitLab Pages rendering (`37f6945`)
- **commands `verify`/`review`/`ship`** now explicitly create their required artifacts — TEST-REPORT.md, REVIEW.md, CHANGELOG.md, decisions/ (`6442a2f`)
- **Global rules pollution** — removed `~/.claude/rules/tgd.md` symlink, agents load rules per-project only (`5bf47ff`)
- **Map step symlinks** point to `.scans/<repo>/` not project root (`cc2fb1a`)

### Docs
- All 4 READMEs (EN/zh-TW/JA/DE) — added "Updating to Latest" one-liner in Quick Start, fixed command count, consistent terminology (`f6dc091`, `0f5e833`, `226d0fa`, `f3b2fec`)
- EN README — fixed `an 7-stage` typo, deduped CLI tables, `Who is this for` converted to bullet list (`226d0fa`, `f3b2fec`)
- All 4 READMEs — added comprehensive testing strategy (BDD, TDD, TEST-REPORT, regression, Ship gate) (`111e290`)

---

## v2026.06.12

### Added
- **Favicon redesign**: Blue "GD" on dark rounded square — unified across GitHub Pages and Intro page (`f039b46`, `8fe79a9`)

### Changed
- **Jira Integration Gate in `/tgd-plan`** — 3 iterations to get it right:
  - Made Jira gate mandatory (auto-sync if configured, block if not) (`c0460c2`)
  - Moved gate before verification to prevent agent from skipping (`8f427dd`, `be306b5`)
  - Final: conversational prompt after TASKS.md — asks "要同步到 Jira 嗡？(y/n)", saves credentials to `$TGD_DIR/.env` for future runs (`e25743c`)
  - Updated across all 5 platforms: Claude, OpenCode, Gemini, Codex, Pi

### Fixed
- **setup.sh registry safety**: Refuses `npm install -g pnpm` and `pnpm install` when registry is default `registry.npmjs.org` — prompts user to configure their own registry first (`aec19c8`)

## v2026.06.11

### ✨ Features
- feat(setup): link tGD skills to OpenCode/Gemini/Pi for faster skill discovery (`dadc955`)
- feat(dashboard): remove token gate — dashboard opens directly on localhost (`26ad0d3`)
- docs: add Sign-off + TEST-REPORT + regression markers to intro page outputs (`6161d6d`)
- docs: add Sign-off format example to zh-TW/JA/DE READMEs (`d9194aa`)

### 🐛 Bug Fixes
- fix(setup): 7 issues — cd bug, duplicate logic, symlink chain, prereq checks (`71c4214`)
- fix(setup): uninstall cleanup for ~/.agents/skills/ and case-sensitive tGD pattern (`dadc955`)
- fix(dashboard): remove unused crypto import and NO_AUTH references (`26ad0d3`)

### 🔧 Chores
- chore: bump version to v2026.06.11 (`5683984`)

---

## v2026.06.10

### ✨ Features
- feat: add Human Roles, Sign-off Protocol, and TEST-REPORT to lifecycle (`5fba481`)
- feat: add TEST-REPORT, regression markers, and Human Roles to all READMEs (`5093c0e`)
- refactor: Sign-off table→checkbox, coverage optional, test runner config, rejection flow (`ff25035`)

### 🐛 Bug Fixes
- fix: add padding-bottom to slides to prevent footer overlap (`0b3301a`)

### 🔧 Chores
- chore: bump version to v2026.06.10

---

## v2026.06.09

### ✨ Features
- feat: auto-categorized release notes with CHANGELOG.md|bfacd3e`)
- feat(cli): add --release command to tgd CLI|ed904ea`)
- feat: add GitHub Release and Tag automation|913c2ea`)
- feat(define): add sketch skill for HTML prototype generation|a801f27`)
- feat: add phase-specific Tone Guide to AGENTS.md|0331de7`)
- feat(define): improve Feature Name Resolution to analyze user intent first|cc6b9f4`)
- feat(map): add Context Discovery step and make Understand-Anything mandatory|dde3f3b`)
- feat: tGD Web Dashboard — 8-phase pipeline visualization with theme toggle|8bfc825`) *(historical — pipeline is now 7-phase)*
- feat: tGD Web Dashboard MVP — 8-phase pipeline visualization|86a4bdf`) *(historical — pipeline is now 7-phase)*
- feat: tgd CLI with CalVer versioning|0e344a7`)
- feat: sync Pi extension with all other platforms|887d733`)
- feat: enforce 'Selection Protocol' across all platforms|9a9d3c1`)
- feat: integrate CodeGraph/UA usage across all PDLC commands|8c79c10`)
- feat: synthesize CONTEXT.md from CodeGraph & UA data|5b9a812`)
- feat: add /understand-dashboard to tgd-map outputs|26f6258`)
- feat: symlink .understand-anything into $TGD_DIR/|e460aec`)
- feat: add UA output to /tgd-map across all platforms|aa5ff15`)
- feat: bind Understand-Anything into all 6 PDLC phases|6e7b6cb`)
- feat: auto-build Understand-Anything in setup.sh|ef24f74`)
- feat: bundle Understand-Anything directly instead of submodule|44ce665`)
- feat: bundle Understand-Anything as submodule|4b672f4`)
- feat: wire CodeGraph into 6 tGD lifecycle skills|eb012d8`)
- feat(rules): add CodeGraph usage hints to tgd-rules|d734d91`)
- feat: add 'tgd' CLI command|0df1724`)
- feat(setup): add --version flag|49eb2f9`)

### 🐛 Bug Fixes
- fix: comprehensive audit — 42 issues across AGENTS.md, README, platform commands, and docs|5e603c1`)
- fix: commit categorization — match scoped prefixes like feat(scope):|52e39df`)
- fix: resolve CI failures — shell pattern escaping + sketch skill validation|67089a6`)
- fix: unify version source — tgd -v reads .tgd-version, release.sh syncs both files|a41e1c6`)
- fix(release): handle --help flag in release script|15d3489`)
- fix: Pi extension tgd-verify references agent-browser|f65fd1e`)
- fix: replace all webwright/browser-testing-with-devtools references with agent-browser|692c3a1`)
- fix: update cross-references from browser-testing-with-devtools to agent-browser|7efe774`)
- fix: enforce mandatory UI Design Gate check in /tgd-define|35841d2`)

### 📝 Documentation
- docs: sync GitHub Pages hero text with README intro (all 4 languages)|0d28633`)
- docs: update GitHub Pages license from MIT to Apache 2.0|51dfad9`)
- docs: regenerate CHANGELOG.md with proper categorization|b1bdd23`)
- docs: update README examples to show prototype generation|bcf7019`)
- docs: update README examples and runtime output|aef6ee5`)
- docs: rewrite README intro with pain-point hook|e3046a7`)
- docs: update Quick Start to assume first-time install|e23e7d0`)
- docs: add Understand-Anything to README and docs + cleanup uninstall|0b115e5`)
- docs: use --recursive for git clone|b3741aa`)
- docs: sync READMEs and GitHub Pages with new 'tgd' CLI|f4a6ed3`)

### ♻️ Refactoring
- refactor: optimize UA/CodeGraph usage (Active/Passive split)|3ad52fc`)

### 🔧 Chores
- chore: bump version to v2026.06.09|ab433ea`)

### 📦 Other Changes
- license: switch from MIT to Apache 2.0|c1248f5`)
- restore: setup.sh from 0c1615a|3dbfb80`)
- restore: agent-browser/SKILL.md from 0c1615a|81bf581`)
- Revert "restore: 26 skill symlinks from 0c1615a"|4916360`)
- restore: 26 skill symlinks from 0c1615a|db74c56`)
- remove: browser-testing-with-devtools and webwright (replaced by agent-browser)|6d4d8bd`)
- restore: jira-auto-sync/SKILL.md from 0c1615a|03526ea`)
- restore: .gitignore from 0c1615a|4f4efb0`)
- restore: README multilingual and AGENTS.md from 0c1615a|5798616`)
- restore: commands/ from 0c1615a — tgd-verify.md updates|dae7ca9`)
- Revert "restore: skills/ from 0c1615a — agent-browser, jira-auto-sync, webwright removal"|2bb70d6`)
- restore: skills/ from 0c1615a — agent-browser, jira-auto-sync, webwright removal|af69f6c`)
- restore: docs/ presentation files and landing page from 0c1615a|c813ece`)

---
**Full Changelog**: https://github.com/openclawyhwang-hub/tGD/commits/v2026.06.09
