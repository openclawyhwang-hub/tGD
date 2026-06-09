# Changelog

All notable changes to tGD will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/). Versions follow [CalVer](https://calver.org/) (YYYY.MM.DD).

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
- feat: tGD Web Dashboard — 8-phase pipeline visualization with theme toggle|8bfc825`)
- feat: tGD Web Dashboard MVP — 8-phase pipeline visualization|86a4bdf`)
- feat: tgd CLI with CalVer versioning|0e344a7`)
- feat: sync Pi extension with all other platforms|887d733`)
- feat: enforce 'Selection Protocol' across all platforms|9a9d3c1`)
- feat: integrate CodeGraph/UA usage across all PDLC commands|8c79c10`)
- feat: synthesize CONTEXT.md from CodeGraph & UA data|5b9a812`)
- feat: add /understand-dashboard to tgd-map outputs|26f6258`)
- feat: symlink .understand-anything into tGD/map/|e460aec`)
- feat: add UA output to /tgd-map across all platforms|aa5ff15`)
- feat: bind Understand-Anything into all 6 PDLC phases|6e7b6cb`)
- feat: auto-build Understand-Anything in setup.sh|ef24f74`)
- feat: bundle Understand-Anything directly instead of submodule|44ce665`)

### 🐛 Bug Fixes
- fix: commit categorization — match scoped prefixes like feat(scope):|52e39df`)
- fix: resolve CI failures — shell pattern escaping + sketch skill validation|67089a6`)
- fix: unify version source — tgd -v reads .tgd-version, release.sh syncs both files|a41e1c6`)
- fix(release): handle --help flag in release script|15d3489`)
- fix: Pi extension tgd-verify references agent-browser|f65fd1e`)
- fix: replace all webwright/browser-testing-with-devtools references with agent-browser|692c3a1`)
- fix: update cross-references from browser-testing-with-devtools to agent-browser|7efe774`)
- fix: enforce mandatory UI Design Gate check in /tgd-define|35841d2`)

### 📝 Documentation
- docs: update README examples to show prototype generation|bcf7019`)
- docs: update README examples and runtime output|aef6ee5`)
- docs: rewrite README intro with pain-point hook|e3046a7`)
- docs: update Quick Start to assume first-time install|e23e7d0`)
- docs: add Understand-Anything to README and docs + cleanup uninstall|0b115e5`)
- docs: use --recursive for git clone|b3741aa`)

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
