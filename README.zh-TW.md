# tGD

<p align="center">
  <img src="https://img.shields.io/github/stars/openclawyhwang-hub/tGD?style=for-the-badge&logo=github&label=Stars&color=gold" alt="GitHub Stars">
  <img src="https://img.shields.io/github/license/openclawyhwang-hub/tGD?style=for-the-badge&color=blue" alt="License">
  <img src="https://img.shields.io/github/last-commit/openclawyhwang-hub/tGD?style=for-the-badge&logo=github&label=Last%20Commit&color=green" alt="Last Commit">
  <img src="https://img.shields.io/badge/platforms-Claude%20Code%20%7C%20Codex%20%7C%20Gemini%20%7C%20OpenCode%20%7C%20Pi-8A2BE2?style=for-the-badge" alt="Platforms">
  <img src="https://img.shields.io/badge/version-CalVer-2ea44f?style=for-the-badge" alt="Version">
</p>

<p align="center">
  <a href="README.md">English</a> | <a href="README.zh-TW.md">繁體中文</a> | <a href="README.ja.md">日本語</a> | <a href="README.de.md">Deutsch</a>
</p>
<p align="center">
  <a href="https://openclawyhwang-hub.github.io/tGD/">🌐 GitHub Pages</a> &nbsp;|&nbsp; <a href="https://openclawyhwang-hub.github.io/tGD/tGD-intro.html">🎬 Intro</a>
</p>

**你的 AI agent 寫了 500 行 code。但它跑測試了嗎？讀過你的 codebase 嗎？寫了 spec 嗎？**

**大概沒有。**

tGD 是一個 7 階段 pipeline，強迫 agent 遵循你也會遵循的工作流程：
Map → Define → Plan → Develop → Verify → Review → Ship

沒有捷徑。沒有「應該可以」。只有證據。

支援 Claude Code、Codex CLI、Gemini CLI、OpenCode、Pi Coding Agent。

---

## 🤔 為什麼需要 tGD？

**問題不是 agent 不會寫 code，而是沒有人管得住它。**

**❌ 沒有 harness：**
- Agent 說「應該可以了」——測試根本沒跑
- 先寫 500 行才讀你的 codebase
- 跳過規格，出 broken PR，然後消失

**✅ 有了 tGD：**
- Agent 說「34/34 pass」——附上輸出
- 先讀 codebase，寫 50 行然後通過
- 規格 → 規劃 → 程式碼 → 驗證——沒有階段可以跳過

---

## 🎯 適合誰用？

| 你的角色 | tGD 怎麼幫你 |
|----------|-------------|
| **獨立開發者** | AI 輔助工作流，更快出貨 |
| **團隊 Lead** | 為 AI 產生的程式碼強制執行編碼標準 |
| **新創公司** | 快速迭代但不搞砸東西 |
| **大型企業** | 為 AI 開發維護品質關卡 |

---

## 🚀 快速開始

### 1. Clone & 安装
```bash
git clone https://github.com/openclawyhwang-hub/tGD.git && cd tGD
bash setup.sh
```
> 自動偵測已安裝的 CLI（Claude、Codex、Gemini、OpenCode、Pi）並完成設定。agent-browser 依賴自動安裝。
>
> 這也會將 `tgd` CLI 安裝到你的 PATH，方便後續使用。

### 安裝選項

| 指令 | 說明 |
|------|------|
| `bash setup.sh` | 首次安裝（從 clone 的 repo 執行） |
| `tgd` | 安裝或更新 tGD（首次安裝後使用） |
| `tgd --version` (`-v`) | 顯示當前版本（CalVer：YYYY.M.D） |
| `tgd --upgrade` (`-u`) | 強制重建：清除無效 symlink 並重新建立所有連結和 hooks |
| `tgd --uninstall` | 移除所有 tGD 部署，不影響其他設定 |
| `bash setup.sh` | 舊版備用方案 — 等同於 `tgd` |

### 2. 啟動你的 Agent
```bash
# Claude Code
claude

# Codex CLI
codex

# OpenCode
opencode

# Gemini CLI
gemini

# Pi Coding Agent
pi
```

### 3. 初始化專案
```
/tgd-map
```
> Agent 掃描你的程式碼庫，建立 `CONTEXT.md` 專案總覽。

### 4. 建造你的第一個功能
```
/tgd-define 我想加上使用者認證
```
> Agent 訪談你，建立 PRD + SPEC，然後就可以開始建造了。

---

## 💡 實際範例

### 範例 1：映射專案
```
使用者：/tgd-map

Agent：除了當前 repo，還有其他需要參考的 repo 嗎？（local path 或 git URL）
使用者：github.com/CopilotKit/CopilotKit

Agent：複製 CopilotKit...
→ 對主專案執行 /understand...
→ 對 CopilotKit 執行 /understand...
→ $TGD_DIR/CONTEXT.md 已建立
→ Dashboard: http://localhost:3838
→ 準備執行 /tgd-define
```

### 範例 2：定義功能
```
使用者：/tgd-define 我想加上 JWT 認證

Agent：功能名稱 — 選一個：
  1. jwt-auth
  2. token-authentication
  3. auth-jwt-middleware
使用者：1

Agent：哪些端點需要認證？
  1. 特定路由 (/api/profile, /api/settings)
  2. 除了 /api/login, /api/register 之外的所有路由
  3. 角色導向 (admin vs user)
使用者：1

Agent：建立 PRD + SPEC...
→ $TGD_DIR/jwt-auth/PRD.md
→ $TGD_DIR/jwt-auth/SPEC.md

Agent：這個功能有 UI 元件嗎？
  1. 是（產生設計）
  2. 否（純後端）
使用者：1

Agent：產生 3 個 HTML 原型...
→ $TGD_DIR/jwt-auth/prototype/variant-a.html
→ $TGD_DIR/jwt-auth/prototype/variant-b.html
→ $TGD_DIR/jwt-auth/prototype/variant-c.html

Agent：選擇設計方向：
  A. 極簡卡片式（乾淨、專注）
  B. 密集儀表板（進階用戶導向）
  C. 分割面板（上下文豐富）
使用者：A

Agent：撰寫 DESIGN.md...
→ $TGD_DIR/jwt-auth/DESIGN.md
→ 準備執行 /tgd-plan
```

### 範例 3：驗證（嚴格語氣）
```
使用者：/tgd-verify

Agent：執行測試套件...
→ 47 通過，1 失敗
→ 失敗：test_login_empty_password — 預期 ValidationError，卻得到 200 OK

Agent：移交給 /tgd-develop 修復。

[... /tgd-develop 修復 auth.py ...]

使用者：/tgd-verify

Agent：執行測試套件...
→ 48 通過，0 失敗
→ Exit code 0
→ 準備執行 /tgd-review
```

### 範例 4：安心出貨
```
使用者：/tgd-ship

Agent：執行最終檢查...
→ 程式碼審查：✅ 通過（五軸審查）
→ 安全性審計：✅ 無漏洞
→ 測試覆蓋率：✅ 87%
→ 準備合併
```

---

## ⚙️ Pipeline

```mermaid
flowchart LR
    A["🔍 MAP\n/tgd-map"] --> B["📋 DEFINE\n/tgd-define"]
    B --> C["📐 PLAN\n/tgd-plan"]
    C --> D["⚡ DEVELOP\n/tgd-develop"]
    D --> E["🧪 VERIFY\n/tgd-verify"]
    E --> F["🔎 REVIEW\n/tgd-review"]
    F --> G["🚀 SHIP\n/tgd-ship"]

    classDef cyan fill:#0e7490,color:#ecfeff,stroke:#22d3ee
    classDef green fill:#059669,color:#ecfdf5,stroke:#34d399
    classDef blue fill:#2563eb,color:#eff6ff,stroke:#60a5fa
    classDef purple fill:#7c3aed,color:#f5f3ff,stroke:#a78bfa
    classDef amber fill:#d97706,color:#fffbeb,stroke:#fbbf24
    classDef rose fill:#e11d48,color:#fff1f2,stroke:#fb7185
    classDef teal fill:#0d9488,color:#f0fdfa,stroke:#5eead4
    classDef indigo fill:#4f46e5,color:#eef2ff,stroke:#818cf8

    class A cyan
    class B green
    class C blue
    class D purple
    class E amber
    class F rose
    class G indigo
```

---

## 🔑 核心特色

### 🏖️ 強制 Worktree 隔離
執行 `/tgd-develop` 時，tGD **自動建立 Git Worktree 沙盒**（`../project-<feature>/`）才開始寫 code。這確保：
- `tGD/` 規劃檔案（PRD, SPEC, TASKS）保持乾淨不受程式碼污染。
- 實驗失敗直接移除 worktree——規劃檔安然無恙。
- 驗證通過後沙盒自動合併並清理。

### 🚦 智能執行路由
`/tgd-develop` 依任務數量智能路由：
| 任務數 | 模式 | 行為 |
|---|---|---|
| **< 3 個** | ⚡ 快速模式 | 主 Agent 直接在 worktree 實作。省 token、省時間。 |
| **≥ 3 個** | 🔀 高品質模式 | 派發 Subagent 並執行雙重審查（規格合規 → 程式碼品質）。最高品質。 |

### 🧠 三源規劃
`/tgd-plan` 在拆解任務前會讀取**三份文件**：
1. **`CONTEXT.md`** — 現有專案結構、技術堆疊、專案慣例。
2. **`PRD.md`** — 商業目標、使用者痛點、範圍邊界。
3. **`SPEC.md`** — 技術需求、API 合約、資料庫結構。

確保產出的 `TASKS.md` 反映真實限制，不是紙上談兵。

### 🎯 3 選 1 功能命名
執行 `/tgd-define` 時，Agent 會提出 **3 個 kebab-case 名稱候選**，等老大挑選或自訂。不盲猜，名稱從第一天就由你掌控。

### 🔄 智能 Jira 整合
同步 Jira 時，tGD 不會無腦開單。它會：
- **自動掃描** 你專案的必填欄位（`createmeta` API）。
- **讓你選擇** Issue Type（Story, Task, Bug...）。
- **統一格式** 每張單據都是 `As a...` 摘要 + `Given/When/Then` 驗收標準。
- **自動繞過 Proxy** 加上 `curl -x ""`。

---

## ⌨️ 指令

### CLI（`tgd`）

`tgd` CLI 管理安裝、更新和診斷：

| 指令 | 說明 |
|------|------|
| `bash setup.sh` | 首次安裝（從 clone 的 repo 執行） |
| `tgd` | 安裝或更新 tGD（首次安裝後使用） |
| `tgd --version` (`-v`) | 顯示版本（CalVer 格式） |
| `tgd --upgrade` (`-u`) | 強制重建連結和 hooks |
| `tgd --release` | 建立 GitHub release（讀取 .tgd-version） |
| `tgd --uninstall` | 移除所有 tGD 部署 |

### Slash 指令

7 個 slash command 對應開發生命週期。每個指令自動串聯相關的 skills。

| 🎯 做什麼 | ⌨️ 指令 | 💡 核心原則 | 🔧 呼叫的 Skills |
|---|---|---|---|
| 了解專案 | `/tgd-map` | 先有 context 再動手 | `context-engineering` + `codegraph init` + `understand-dashboard` |
| 定義要做什麼 | `/tgd-define` | 3 選 1 命名 + 產品 + 規格 | `interview-me` → `idea-refine` → `spec-driven-development` |
| 規劃怎麼做 | `/tgd-plan` | 讀 CONTEXT + PRD + SPEC → 原子任務 | `planning-and-task-breakdown` → `jira-auto-sync` |
| 沙盒建造 | `/tgd-develop` | **強制 Worktree** + 智能路由 | `source-driven-development` → (`subagent` OR `incremental`) → `test-driven-development` |
| 證明它能跑 | `/tgd-verify` | 測試就是證明 | `debugging-and-error-recovery` → `test-driven-development` |
| 合併前審查 | `/tgd-review` | 改善程式碼健康 | `code-review-and-quality` → `code-simplification` |
| 部署到生產 | `/tgd-ship` | 快就是安全 | `git-workflow-and-versioning` → `shipping-and-launch` |

---

## 🧪 測試策略

tGD 的測試不是單一階段——它是跨三個階段的漸進紀律，每個階段有不同的目的和角色：

### 🎭 三個測試角色

| 階段 | 角色 | 目的 | 測試類型 | Agent 做什麼 |
|------|------|------|----------|-------------|
| **`/tgd-develop`** | 🔨 建造者 | **寫測試** alongside code | 單元測試 (TDD) | Red-Green-Refactor 循環：寫失敗測試 → 實作 → 通過 |
| **`/tgd-verify`** | 🔍 檢查員 | **跑所有測試** 修復失敗 | 整合 + E2E | 除錯流程：重現 → 定位 → 修復 → 防護 |
| **`/tgd-review`** | 🕵️ 審計員 | **檢查測試品質** 覆蓋率 | 覆蓋率 + 策略 | 審查測試金字塔：80% 單元、15% 整合、5% E2E |

### 🔐 為什麼分三個階段？

**分離防止「懶 agent」行為。** 如果測試是單一階段，agent 會跑完單元測試就說「完成了」，然後跳過更難的整合/E2E 測試。分離階段：

- **Develop** 強制 agent 建立證明（寫測試）
- **Verify** 強制 agent 驗證證明（跑測試 + 除錯）
- **Review** 強制 agent 挑戰證明（審計測試品質）

### 🔺 測試金字塔

tGD 強制執行測試金字塔比例：
```
          ╱╲
         ╱  ╲         E2E 測試 (~5%)      ← Verify 階段 (agent-browser)
        ╱    ╲        完整使用者流程，真實瀏覽器
       ╱──────╲
      ╱        ╲      整合測試 (~15%)      ← Verify 階段
     ╱          ╲     元件互動、API 邊界
    ╱────────────╲
   ╱              ╲   單元測試 (~80%)      ← Develop 階段
  ╱                ╲  純邏輯、隔離、每個毫秒級
 ╱──────────────────╲
```

**E2E 測試工具：**
- **`agent-browser`** (強制關卡)：透過 CDP 協議的高速 Rust CLI。透過截圖與無障礙樹驗證 UI。

### 範例：建造登入功能

| 階段 | Agent 動作 | 測試類型 | 發現的問題 |
|------|-----------|----------|-----------|
| **Develop** | 寫 `verify_password()` 函式 + 測試 | 單元測試 | 密碼雜湊邏輯反了 → 立即修復 |
| **Verify** | 啟動伺服器、跑所有測試、自動點擊瀏覽器 | 整合/E2E | 資料庫連線失敗（環境變數遺漏）、登入按鈕被 cookie 橫幅遮住 |
| **Review** | 檢查測試檔案覆蓋率 | 覆蓋率審計 | 缺少邊界案例測試：空密碼、1000 字元密碼 |

### 📊 TEST-REPORT.md

Verify 階段自動產出 `TEST-REPORT.md`，格式與語言無關：

| 區塊 | 內容 |
|------|------|
| Summary | Total / Passed / Failed / Coverage / Regression 數量 |
| All Test Cases | 從 test runner 輸出自動產生 |
| Failures | 錯誤詳情 + 位置 |
| Sign-off | QA 簽核 |

### 🏷️ Regression 標記

驗收等級的測試用 stack 適當的慣例標記為 regression：

| Stack | 標記方式 |
|-------|----------|
| Python | `@pytest.mark.regression` |
| TypeScript/JS | `*.regression.test.ts` 命名或 tag |
| Go | `//go:build regression` 或 `TestXxxRegression` 命名 |
| Java | `@Tag("regression")` |

Ship 門檻：regression suite 必須 100% pass。

---

## 👥 人類角色與簽核

tGD 有三個角色。每個 artifact 底部都有 `## Sign-off` 區塊：

| 角色 | 職責 | 審查項目 | 簽核對象 |
|------|------|----------|----------|
| **PM** | 產品方向 | PRD（做什麼、為什麼） | PRD.md、Ship |
| **DEV** | 實作品質 | TASKS、程式碼 | TASKS.md、程式碼、REVIEW.md |
| **QA** | 測試品質與覆蓋率 | TEST-REPORT、測試品質 | TEST-REPORT.md、REVIEW.md |

**運作方式：**
- Agent 產出 artifact → 人類在自己的電腦上審查 → 編輯 artifact 裡的 `## Sign-off` → commit & push
- Agent 在進入下一階段前檢查 Sign-off checkbox（Gate 3）
- Ship 是硬門檻：所有必要 Sign-offs 必須為 `[x]`
- 一人可兼多角（小團隊常見）
- 不需要額外工具 — git 就是協調機制

---

## 🔗 整合

### Jira Data Center
當 `/tgd-plan` 產生 `TASKS.md` 時，**`jira-auto-sync`** skill 可以自動建立 Jira issue：
```
/tgd-plan → 產生 TASKS.md → 使用者確認 → 建立 Jira issues
```

---

## 🤖 Agent Personas

| Agent | 角色 | 視角 |
|-------|------|------|
| [code-reviewer](agents/code-reviewer.md) | 資深 Staff 工程師 | 「Staff 工程師會批准這個嗎？」 |
| [test-engineer](agents/test-engineer.md) | QA 專家 | 測試策略 & Prove-It 模式 |
| [security-auditor](agents/security-auditor.md) | 安全工程師 | 漏洞偵測 |

Personas 不會呼叫其他 personas——使用者（或 slash command）才是 orchestrator。

---

## 🧩 Skills 如何運作

每個 skill 都遵循一致的結構：
1. **Frontmatter**：名稱、描述、觸發條件
2. **工作流**：逐步指令
3. **驗證**：通過才能繼續的關卡
4. **反合理化**：對抗常見的「懶 agent」藉口

Skills 使用**漸進式揭露**——agent 只在需要時載入細節，保持 context 使用量低。

---

## 📊 效能指標

| 指標 | 數值 |
|------|------|
| **載入的 Skills** | 28（按需載入，非一次全部） |
| **Context 使用量** | 每個 skill ~5%（漸進式揭露） |
| **安裝時間** | < 30 秒 |
| **第一個功能** | ~15 分鐘（從 `/tgd-define` 到 `/tgd-ship`） |

---

## ❓ 常見問題

**Q：除了 agent 之外還需要裝什麼嗎？**
A：Clone repo 後執行 `bash setup.sh`。它自動偵測你的 CLI 並完成設定。`tgd` CLI 也會自動安裝。

**Q：我的 agent 不支援 slash command 怎麼辦？**
A：用自然語言說「規劃這個功能」——tGD 自動將意圖映射到對應的 skill。

**Q：可以跳過階段嗎？**
A：每個階段都有 pre-flight 檢查。跳過的話，下一個階段會擋住你。

**Q：可以用在現有專案嗎？**
A：可以！`/tgd-map` 會先掃描你現有的程式碼庫。

**Q：跟 Cursor/Copilot 有什麼不同？**
A：那些工具寫 code。tGD 強制執行工作流——規格、計畫、測試、審查——在 code 出貨之前。

**Q：可以自訂 pipeline 嗎？**
A：可以！編輯 `skills/` 目錄下的 skill 檔案來配合你團隊的工作流。

---

## 📁 專案結構

### 執行時期輸出（開發過程中產生）

範例：SaaS 應用（Express 後端 + React 前端），兩個功能在不同階段：

```
workspace/
├── my-project-backend/                           # Backend repo (Express + Prisma)
│   ├── .codegraph → tGD/.codegraph     # symlink for CodeGraph CLI
│   ├── tGD/
│   │   ├── .codegraph/                 # Symbol index (auto-generated)
│   │   └── .understand-anything/       # Knowledge graph (auto-generated)
│   ├── src/
│   │   ├── routes/
│   │   │   ├── auth.ts                 # ← user-auth feature
│   │   │   ├── payment.ts              # ← payment-flow feature
│   │   │   └── health.ts
│   │   ├── models/
│   │   │   ├── user.ts
│   │   │   └── payment.ts
│   │   └── middleware/
│   │       └── jwt.ts
│   └── tests/
│       ├── auth.test.ts
│       └── payment.test.ts
│
├── my-project-frontend/                           # Frontend repo (React + Vite)
│   ├── .codegraph → tGD/.codegraph
│   ├── tGD/
│   ├── src/
│   │   ├── components/
│   │   │   ├── LoginForm.tsx           # ← user-auth feature
│   │   │   ├── PaymentForm.tsx         # ← payment-flow feature
│   │   │   └── Dashboard.tsx
│   │   └── pages/
│   │       ├── login.tsx
│   │       └── checkout.tsx
│   └── tests/
│       ├── LoginForm.test.tsx
│       └── PaymentForm.test.tsx
│
└── my-project-tGD/                           # ← $TGD_DIR (sibling, not inside)
    ├── CONTEXT.md                      # Repo inventory: my-project-backend, my-project-frontend
    ├── CHANGELOG.md
    │   # v1.0.0 - user-auth shipped
    │   # v1.1.0 - payment-flow shipped
    │
    ├── .scans/                         # Centralized scan data
    │   ├── my-project-backend/
    │   │   ├── .codegraph/
    │   │   └── .understand-anything/
    │   └── my-project-frontend/
    │       ├── .codegraph/
    │       └── .understand-anything/
    │
    ├── user-auth/                      # Feature 1: shipped ✅
    │   ├── PRD.md                      # "Users need to log in"
    │   ├── SPEC.md                     # Backend: JWT + bcrypt / Frontend: LoginForm
    │   ├── DESIGN.md                   # Login page mockup
    │   ├── prototype/
    │   │   ├── variant-a.html          # Minimal login form
    │   │   └── variant-b.html          # Login with social buttons
    │   ├── TASKS.md                    # 5 tasks, all done
    │   ├── REVIEW.md                   # Passed: 87% coverage
    │   └── decisions/
    │       └── ADR-001-use-jwt.md      # Why JWT over sessions
    │
    └── payment-flow/                   # Feature 2: in planning 🚧
        ├── PRD.md                      # "Users need to pay"
        ├── SPEC.md                     # Backend: Stripe API / Frontend: PaymentForm
        ├── DESIGN.md                   # Checkout page mockup
        ├── prototype/
        │   ├── variant-a.html          # Single-page checkout
        │   └── variant-b.html          # Multi-step checkout
        └── TASKS.md                    # 8 tasks, not started
```

**重點：**
- **同層級**：`my-project-backend/`、`my-project-frontend/`、`my-project-tGD/` 在同一層 — tGD 不在 code repo 裡面
- **Feature-first**：每個功能（`user-auth/`、`payment-flow/`）有自己的資料夾，包含所有產出
- **多 Repo 標記**：SPEC.md 和 TASKS.md 用 repo 名稱標記（如 `[my-project-backend]`、`[my-project-frontend]`）
- **Code repo 保持乾淨**：根目錄只有 `tGD/` symlink 資料夾 + `src/` + `tests/`
- **統一版本記錄**：CHANGELOG.md 在 tGD root，記錄跨所有 feature 的版本歷史

**Symlink 鏈結**（掃描資料如何串接）：
```
my-project-backend/.codegraph → my-project-backend/tGD/.codegraph → my-project-tGD/.scans/my-project-backend/.codegraph
```

**階段 → 產出對應：**

| 階段 | 指令 | 產出 | 位置 |
|------|------|------|------|
| Map | `/tgd-map` | CONTEXT.md | `$TGD_DIR/CONTEXT.md` |
| Define | `/tgd-define` | PRD.md, SPEC.md, DESIGN.md, prototype/ | `$TGD_DIR/<feature>/` |
| Plan | `/tgd-plan` | TASKS.md | `$TGD_DIR/<feature>/TASKS.md` |
| Develop | `/tgd-develop` | src/ | Code repo |
| Verify | `/tgd-verify` | tests/ | Code repo |
| Review | `/tgd-review` | REVIEW.md | `$TGD_DIR/<feature>/REVIEW.md` |
| Ship | `/tgd-ship` | CHANGELOG.md, git tag | `$TGD_DIR/CHANGELOG.md` |

### Repo 內容
### Repo 內容
```
tGD/
├── skills/                            # 28 個 skills
├── agents/                            # 3 個專家 personas
├── references/                        # 檢查清單（安全、測試等）
├── .claude/commands/                  # Claude Code 指令
├── .gemini/commands/                  # Gemini CLI 指令
├── .opencode/commands/                # OpenCode 指令
├── .codex/prompts/                    # Codex CLI prompts
├── .pi/extensions/                    # Pi Coding Agent 指令
├── scripts/                           # 安裝 & 驗證
└── docs/                              # 平台指南
```

---

## 📦 全部 28 個 Skills

上面的指令是入口點。這個 pack 包含 28 個 skills——26 個生命週期 skill 加上 `using-tGD` 元 skill 和 `tgd-rules` 核心規則。

### 🧭 Meta
| Skill | 用途 |
|---|---|
| [using-tGD](skills/using-tGD/SKILL.md) | 將工作映射到正確的 skill |

### 📋 Define
| Skill | 用途 |
|---|---|
| [interview-me](skills/interview-me/SKILL.md) | 透過 Q&A 提取使用者意圖 |
| [idea-refine](skills/idea-refine/SKILL.md) | 發散/收斂思考 |
| [spec-driven-development](skills/spec-driven-development/SKILL.md) | 寫 code 前先寫 PRD + SPEC + DESIGN.md（UI: claude-design 3 變體 + 用戶確認關卡） |

### 📐 Plan
| Skill | 用途 |
|---|---|
| [planning-and-task-breakdown](skills/planning-and-task-breakdown/SKILL.md) | 將規格拆解為 TASKS.md |
| [jira-auto-sync](skills/jira-auto-sync/SKILL.md) | 從 TASKS.md 自動建立 Jira issue |

### ⚡ Develop
| Skill | 用途 |
|---|---|
| [subagent-driven-development](skills/subagent-driven-development/SKILL.md) | 透過新子代理並行處理任務 |
| [incremental-implementation](skills/incremental-implementation/SKILL.md) | 薄的垂直切片 |
| [verification-before-completion](skills/verification-before-completion/SKILL.md) | 聲明完成前必須有證據 |
| [test-driven-development](skills/test-driven-development/SKILL.md) | Red-Green-Refactor |
| [context-engineering](skills/context-engineering/SKILL.md) | 餵給 agent 正確的資訊 |
| [source-driven-development](skills/source-driven-development/SKILL.md) | 以官方文件為依據 |
| [doubt-driven-development](skills/doubt-driven-development/SKILL.md) | 對抗式審查 |
| [frontend-ui-engineering](skills/frontend-ui-engineering/SKILL.md) | UI 架構 & 設計系統 |
| [api-and-interface-design](skills/api-and-interface-design/SKILL.md) | 合約優先的 API 設計 |

### 🧪 Verify
| Skill | 用途 |
|---|---|
| [agent-browser](skills/agent-browser/SKILL.md) | E2E 瀏覽器自動化、CDP 指令工具 |
| [debugging-and-error-recovery](skills/debugging-and-error-recovery/SKILL.md) | 分診、修復、防護 |

### 🔎 Review
| Skill | 用途 |
|---|---|
| [code-review-and-quality](skills/code-review-and-quality/SKILL.md) | 五軸審查 |
| [code-simplification](skills/code-simplification/SKILL.md) | 降低複雜度 |
| [security-and-hardening](skills/security-and-hardening/SKILL.md) | OWASP & 密鑰管理 |
| [performance-optimization](skills/performance-optimization/SKILL.md) | 效能分析 & 反模式 |

### 🚀 Ship
| Skill | 用途 |
|---|---|
| [git-workflow-and-versioning](skills/git-workflow-and-versioning/SKILL.md) | 原子提交 & 主幹開發 |
| [ci-cd-and-automation](skills/ci-cd-and-automation/SKILL.md) | Shift Left & 功能旗標 |
| [deprecation-and-migration](skills/deprecation-and-migration/SKILL.md) | 遷移模式 |
| [documentation-and-adrs](skills/documentation-and-adrs/SKILL.md) | ADR & API 文件 |
| [shipping-and-launch](skills/shipping-and-launch/SKILL.md) | 漸進式部署 & 監控 |

---

## 🗺️ 下一步？

建造完第一個功能之後：

1. 📖 閱讀[測試策略](#測試策略)了解三階段測試
2. 🔧 探索[全部 28 個 Skills](#全部-28-個-skills)看有什麼可用
3. 🤖 試試 [Agent Personas](#agent-personas) 專門化審查
4. 🔗 設定 [Jira 整合](#jira-data-center) 任務追蹤
5. 🌐 啟用 [Agent Browser](skills/agent-browser/SKILL.md) E2E 瀏覽器測試

---

## 🤝 貢獻

想加入 skill 或改善 tGD？請看 [CONTRIBUTING.md](CONTRIBUTING.md)。

### ⚡ 快速貢獻指南：
1. Fork repo
2. 在 `skills/your-skill/` 建立 skill
3. 執行 `bash scripts/validate-skills.js`
4. 提交 PR

---

## 📄 授權

Apache 2.0 - 在你的專案、團隊和工具中使用這些 skills。

---

## 📎 附錄：手動設定

> **注意：** 只在 `tgd` 失敗或你偏好手動連結時才需要。

### Claude Code
```bash
claude skills install . --path skills
```

### Gemini CLI
```bash
gemini skills install . --path skills
```

### Codex CLI
Codex 依賴 **Skill 自動偵測**而非 slash command。
```bash
ln -s $(pwd)/skills ~/.codex/skills/tGD
```
*觸發方式：* 說「規劃這個功能」或「開始 tgd plan」——Codex 會自動呼叫 skill。

### OpenCode
OpenCode 自動偵測工作區中的 `skills/` 資料夾。

### Pi Coding Agent
Pi 透過 **TypeScript Extension**（`.pi/extensions/`）原生支援 `/tgd-plan`。
```bash
pi
/tgd-plan
```

### 其他平台
<details>
<summary><b>Cursor / Windsurf / Kiro</b></summary>

- **Cursor：** 複製 `skills/` 到 `.cursor/rules/`
- **Windsurf：** 將 skill 內容加入 rules 設定
- **Kiro：** 放 skills 到 `.kiro/skills/`

</details>

<details>
<summary><b>GitHub Copilot</b></summary>

使用 `AGENTS.md` 和 `.github/copilot-instructions.md` 載入這些工作流。

</details>
