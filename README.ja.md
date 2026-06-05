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

**tGD — The Agentic PDLC Harness.**

AIエージェントはコードを書ける。tGDはそれを確実にデリバリーする。

8段階のパイプラインが意思決定を制約・指導・検証——仕様から本番まで、近道なし。

Claude Code、Codex CLI、Gemini CLI、OpenCode、Pi Coding Agent に対応。

---

## 🤔 なぜ tGD なのか？

**❌ tGD なし：**
- AIエージェントが500行のコードを書き、テストが失敗する。原因不明
- 「私のマシンでは動くのに」→ 本番環境で障害
- 仕様も計画もない、ただの感覚頼り

**✅ tGD あり：**
- エージェントが50行書き、テストが通り、次のタスクへ
- すべての機能に出荷前に PRD + SPEC + DESIGN がある
- 8段階のパイプラインがバグを本番到達前に検出

---

## 🎯 誰のため？

| あなたの役割 | tGD の活用法 |
|--------------|-------------|
| **個人開発者** | AI支援ワークフローでより速く出荷 |
| **チームリード** | AI生成コードにコーディング標準を強制 |
| **スタートアップ** | 壊さずに速く動く |
| **エンタープライズ** | AI開発の品質ゲートを維持 |

---

## 🚀 クイックスタート

### 1. Clone & セットアップ
```bash
git clone https://github.com/openclawyhwang-hub/tGD.git && cd tGD
tgd
```
> インストール済みCLI（Claude、Codex、Gemini、OpenCode、Pi）を自動検出。Webwrightの依存関係も自動インストール。
>
> **代替手段：** `tgd` がまだインストールされていない場合は、`bash setup.sh` を直接実行してください。

### インストールオプション

| コマンド | 説明 |
|--------|------|
| `tgd` | 新規インストール（または新バージョンへの自動アップグレード） |
| `tgd --version` (`-v`) | 現在のバージョンを表示（CalVer：YYYY.M.D） |
| `tgd --upgrade` (`-u`) | 強制更新：無効なシンボリックリンクをクリーンアップし、すべてのリンク/フックを再構築 |
| `tgd --uninstall` | すべてのtGD配備を削除（他のファイルには影響しない） |
| `bash setup.sh` | レガシー代替 — `tgd` と同等 |

### 2. エージェントを起動
```bash
claude   # Claude Code
codex    # Codex CLI
opencode # OpenCode
gemini   # Gemini CLI
pi       # Pi Coding Agent
```

### 3. プロジェクトを初期化
```
/tgd-map
```
> エージェントがコードベースをスキャンし、`CONTEXT.md` を作成。

### 4. 最初の機能を構築
```
/tgd-define ユーザー認証を追加したい
```
> エージェントがインタビューし、PRD + SPEC を作成。

---

## 💡 実例

### 例1：ユーザー認証の追加
```
ユーザー：/tgd-define JWT認証を追加したい

エージェント：どのエンドポイントに認証が必要ですか？
ユーザー：/api/profile と /api/settings

エージェント：PRD + SPEC を作成中...
→ tGD/define/auth-feature/PRD.md
→ tGD/define/auth-feature/SPEC.md
→ /tgd-plan の準備完了
```

### 例2：バグ修正
```
ユーザー：/tgd-verify

エージェント：全テスト実行中...
→ 47件成功、1件失敗
→ test_login_empty_password：エラーが発生すべきなのに成功

エージェント：修正中...
→ auth.py にバリデーション追加
→ 全48テスト成功
→ /tgd-review の準備完了
```

### 例3：安心してデプロイ
```
ユーザー：/tgd-ship

エージェント：最終チェック実行中...
→ コードレビュー：✅ 合格（5軸レビュー）
→ セキュリティ監査：✅ 脆弱性なし
→ テストカバレッジ：✅ 87%
→ マージ準備完了
```

---

## 🔑 主な機能

- **🏖️ 必須 Worktree 隔離**: 全てのコード実装は隔離された Git Worktree サンドボックスで実行。`tGD/` 計画ファイルがコードで汚染されることはありません。
- **🚦 スマートルーティング**: `/tgd-develop` はタスク数に応じてルーティング（<3 タスク: メイン Agent、≥3 タスク: Subagent + 二段階レビュー）。
- **🧠 三源計画**: `/tgd-plan` は `CONTEXT.md` + `PRD.md` + `SPEC.md` の3つのドキュメントを統合してからタスクを作成します。
- **🎯 3択機能名**: `/tgd-define` は3つの候補名を提案し、ユーザーが選択するまで待ちます。
- **🔄 スマート Jira 統合**: 必須フィールドを自動検出し、構造化された「As a... I want...」形式で課題を作成。

---

## ⚙️ パイプライン

### CLI（`tgd`）

`tgd` CLI はインストール、更新、診断を管理します：

| コマンド | 説明 |
|--------|------|
| `tgd` | tGD のインストールまたは更新 |
| `tgd --version` (`-v`) | バージョン表示（CalVer形式） |
| `tgd --upgrade` (`-u`) | リンクとフックの強制再構築 |
| `tgd --uninstall` | すべてのtGD配備を削除 |
| `bash setup.sh` | レガシー代替 — `tgd` と同等 |

### スラッシュコマンド

8つのステージでアイデアから本番環境まで。各ステージが次のステージをゲートキープします。

| 🎯 内容 | ⌨️ コマンド | 💡 原則 | 🔧 呼び出し |
|---|---|---|---|
| プロジェクト理解 | `/tgd-map` | 変更前にコンテキスト | `context-engineering` + `codegraph init` |
| 何を構築するか定義 | `/tgd-define` | 3択命名 + 製品 + 仕様 | `interview-me` → `idea-refine` → `spec-driven-development` |
| 構築方法を計画 | `/tgd-plan` | CONTEXT + PRD + SPEC → アトミックタスク | `planning-and-task-breakdown` → `jira-auto-sync` |
| サンドボックス構築 | `/tgd-develop` | **必須 Worktree** + スマートルーティング | `source-driven-development` → (`subagent` OR `incremental`) → `test-driven-development` |
| 動作を証明 | `/tgd-verify` | テストが証拠 | `debugging-and-error-recovery` → `test-driven-development` |
| マージ前レビュー | `/tgd-review` | コードの健康改善 | `code-review-and-quality` → `code-simplification` |
| コード簡素化 | `/tgd-simplify` | 賢さより明瞭さ | `code-simplification` |
| 本番デプロイ | `/tgd-ship` | 速い方が安全 | `git-workflow-and-versioning` → `shipping-and-launch` |

---

## 🧪 テスト戦略

tGDのテストは単一フェーズではなく、3段階にわたる段階的な規律です：

| ステージ | 役割 | 目的 | テスト種別 |
|----------|------|------|-----------|
| **`/tgd-develop`** | 🔨 ビルダー | コードとともに**テストを書く** | 単体テスト (TDD) |
| **`/tgd-verify`** | 🔍 インスペクター | **全テストを実行**し失敗を修正 | 結合 + E2E |
| **`/tgd-review`** | 🕵️ 監査人 | **テスト品質**とカバレッジを確認 | カバレッジ + 戦略 |

### 🔺 テストピラミッド
```
          ╱╲
         ╱  ╲         E2E (~5%)      ← Verify段階
        ╱    ╲
       ╱──────╲
      ╱        ╲      結合テスト (~15%)  ← Verify段階
     ╱          ╲
    ╱────────────╲
   ╱              ╲   単体テスト (~80%)  ← Develop段階
  ╱                ╲
 ╱──────────────────╲
```

---

## 🔗 統合

### Jira Data Center
`/tgd-plan` が `TASKS.md` を生成した際、**`jira-auto-sync`** スキルが自動で Jira 課題を作成できます：
```
/tgd-plan → TASKS.md 生成 → ユーザー確認 → Jira 課題作成
```

---

## 🤖 Agent Personas

| Agent | 役割 | 視点 |
|-------|------|------|
| [code-reviewer](agents/code-reviewer.md) | シニアスタッフエンジニア | 「スタッフエンジニアなら承認するか？」 |
| [test-engineer](agents/test-engineer.md) | QA スペシャリスト | テスト戦略 & Prove-Itパターン |
| [security-auditor](agents/security-auditor.md) | セキュリティエンジニア | 脆弱性検出 |

---

## 🧩 スキルの仕組み

各スキルは4部構成：
1. **フロントマター**：名前、説明、トリガー
2. **ワークフロー**：ステップバイステップの手順
3. **検証**：次へ進むためのゲート
4. **合理化防止**：「怠けエージェント」の言い訳に対抗

**プログレッシブディスクロージャ** — エージェントは必要な時だけ詳細をロード。

---

## 📊 パフォーマンス

| 指標 | 値 |
|------|-----|
| **ロードされたスキル** | 28（オンデマンド、全同時ではありません） |
| **コンテキスト使用量** | スキルあたり約5%（プログレッシブディスクロージャ） |
| **セットアップ時間** | 30秒未満 |
| **最初の機能** | 約15分（`/tgd-define` から `/tgd-ship` まで） |

---

## ❓ よくある質問

**Q：エージェント以外にインストールが必要？**
A：`tgd` だけで OK。CLI を自動検出。

**Q：スラッシュコマンド非対応のエージェントは？**
A：「この機能を計画して」と自然言語で言うと自動マッピング。

**Q：ステージをスキップできる？**
A：各ステージにプレフライトチェック。スキップすると次のステージがブロック。

**Q：既存プロジェクトで使える？**
A：はい！`/tgd-map` が既存コードベースをスキャン。

**Q：Cursor/Copilotと何が違う？**
A：それらはコードを書く。tGDはワークフロー（仕様→計画→テスト→レビュー）を強制。

---

## 📁 プロジェクト構造

### ランタイム出力（開発中に生成）
```
<your-project>/
├── tGD/
│   ├── map/
│   │   └── CONTEXT.md              ← プロジェクトコンテキスト (/tgd-map)
│   ├── define/                     ← 機能ごとの PRD + SPEC + DESIGN
│   │   └── <feature-name>/         ← 例: auth-feature, user-profile
│   │       ├── PRD.md
│   │       ├── SPEC.md
│   │       └── DESIGN.md
│   └── plan/                       ← 機能ごとのタスク分解
│       └── <feature-name>/
│           └── TASKS.md
```

### リポジトリ内容
```
tGD/
├── skills/                     # 28 スキル
├── agents/                     # 3 スペシャリストペルソナ
├── references/                 # チェックリスト（セキュリティ、テスト等）
├── .claude/commands/           # Claude Code スラッシュコマンド
├── .gemini/commands/           # Gemini CLI コマンド
├── .opencode/commands/         # OpenCode コマンド
├── .codex/prompts/             # Codex CLI プロンプト
├── scripts/                    # セットアップ & 検証
└── docs/                       # プラットフォーム別ガイド
```

---

## 📦 全28スキル

<details>
<summary><b>🧭 Meta (1)</b></summary>

| スキル | 用途 |
|--------|------|
| [using-tGD](skills/using-tGD/SKILL.md) | 作業を適切なスキルにマッピング |
</details>

<details>
<summary><b>📋 Define (3)</b></summary>

| スキル | 用途 |
|--------|------|
| [interview-me](skills/interview-me/SKILL.md) | Q&Aでユーザー意図を抽出 |
| [idea-refine](skills/idea-refine/SKILL.md) | 発散/収束思考 |
| [spec-driven-development](skills/spec-driven-development/SKILL.md) | PRD + SPEC を先に作成 |
</details>

<details>
<summary><b>📐 Plan (2)</b></summary>

| スキル | 用途 |
|--------|------|
| [planning-and-task-breakdown](skills/planning-and-task-breakdown/SKILL.md) | TASKS.md に分解 |
| [jira-auto-sync](skills/jira-auto-sync/SKILL.md) | Jira issue 自動作成 |
</details>

<details>
<summary><b>⚡ Build (9)</b></summary>

| スキル | 用途 |
|--------|------|
| [subagent-driven-development](skills/subagent-driven-development/SKILL.md) | 新しいサブエージェントによる並列タスク |
| [incremental-implementation](skills/incremental-implementation/SKILL.md) | 縦に薄くスライスして実装 |
| [test-driven-development](skills/test-driven-development/SKILL.md) | Red-Green-Refactor |
| [verification-before-completion](skills/verification-before-completion/SKILL.md) | 主張の前に証拠を |
| [context-engineering](skills/context-engineering/SKILL.md) | 正確な情報をエージェントに供給 |
| [source-driven-development](skills/source-driven-development/SKILL.md) | 公式ドキュメントに基づく判断 |
| [doubt-driven-development](skills/doubt-driven-development/SKILL.md) | 対抗レビュー |
| [frontend-ui-engineering](skills/frontend-ui-engineering/SKILL.md) | UIアーキテクチャ & デザインシステム |
| [api-and-interface-design](skills/api-and-interface-design/SKILL.md) | コントラクトファーストAPI設計 |
</details>

<details>
<summary><b>🧪 Verify (3)</b></summary>

| スキル | 用途 |
|--------|------|
| [agent-browser](skills/agent-browser/SKILL.md) | E2Eブラウザ自動化、CDPベースCLI |
| [debugging-and-error-recovery](skills/debugging-and-error-recovery/SKILL.md) | トリアージ、修正、防御 |
</details>

<details>
<summary><b>🔎 Review (4)</b></summary>

| スキル | 用途 |
|--------|------|
| [code-review-and-quality](skills/code-review-and-quality/SKILL.md) | 5軸レビュー |
| [code-simplification](skills/code-simplification/SKILL.md) | 複雑性削減 |
| [security-and-hardening](skills/security-and-hardening/SKILL.md) | OWASP & シークレット管理 |
| [performance-optimization](skills/performance-optimization/SKILL.md) | パフォーマンス解析 & アンチパターン |
</details>

<details>
<summary><b>🚀 Ship (5)</b></summary>

| スキル | 用途 |
|--------|------|
| [git-workflow-and-versioning](skills/git-workflow-and-versioning/SKILL.md) | アトミックコミット & トランクベース開発 |
| [ci-cd-and-automation](skills/ci-cd-and-automation/SKILL.md) | Shift Left & フィーチャーフラグ |
| [deprecation-and-migration](skills/deprecation-and-migration/SKILL.md) | マイグレーションパターン |
| [documentation-and-adrs](skills/documentation-and-adrs/SKILL.md) | ADR & APIドキュメント |
| [shipping-and-launch](skills/shipping-and-launch/SKILL.md) | 段階的デプロイ & モニタリング |
</details>

---

## 🗺️ 次のステップ？

最初の機能を構築した後：

1. 📖 [テスト戦略](#テスト戦略)を読んで3段階テストを理解
2. 🔧 [全28スキル](#全28スキル)を探索して利用可能なものを見る
3. 🤖 [Agent Personas](#agent-personas)で専門的なレビューを試す
4. 🔗 [Jira 統合](#統合)でタスクトラッキングを設定
5. 🌐 [Agent Browser](skills/agent-browser/SKILL.md)でE2Eブラウザテストを有効化

---

## 🤝 コントリビュート

スキルを追加したりtGDを改善したいですか？[CONTRIBUTING.md](CONTRIBUTING.md)をご覧ください。

### ⚡ クイックコントリビュートガイド：
1. リポジトリをフォーク
2. `skills/your-skill/` にスキルを作成
3. `bash scripts/validate-skills.js` を実行
4. PRを送信

---

## 📄 ライセンス

MIT - あなたのプロジェクト、チーム、ツールでこれらのスキルを使用してください。

---

## 📎 付録：手動設定

> **注意：** `tgd` が失敗した場合、または手動リンクを希望する場合のみ必要です。

### Claude Code
```bash
claude skills install . --path skills
```

### Gemini CLI
```bash
gemini skills install . --path skills
```

### Codex CLI
Codexはスラッシュコマンドではなく**スキル自動検出**に依存します。
```bash
ln -s $(pwd)/skills ~/.codex/skills/tGD
```
*トリガー：*「この機能を計画して」と言うと、Codexが自動的にスキルを呼び出します。

### OpenCode
OpenCodeはワークスペース内の `skills/` フォルダを自動検出します。

### Pi Coding Agent
Piは**TypeScript Extension**（`.pi/extensions/`）で `/tgd-plan` をネイティブサポートしています。
```bash
pi
/tgd-plan
```
