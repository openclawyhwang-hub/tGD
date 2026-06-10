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

**あなたのAIエージェントが500行のコードを書いた。でも、テストは走らせた？コードベースは読んだ？specは書いた？**

**たぶん、書いてない。**

tGDは8段階のパイプラインで、エージェントにあなたと同じワークフローを強制します：
Map → Define → Plan → Develop → Verify → Review → Ship

近道なし。「たぶん動く」なし。証拠だけ。

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
bash setup.sh
```
> インストール済みCLI（Claude、Codex、Gemini、OpenCode、Pi）を自動検出。Webwrightの依存関係も自動インストール。
>
> これにより `tgd` CLI もPATHにインストールされ、次回から簡単に使えます。

### インストールオプション

| コマンド | 説明 |
|--------|------|
| `bash setup.sh` | 初回インストール（クローンしたリポジトリから実行） |
| `tgd` | tGDのインストールまたは更新（初回インストール後に使用） |
| `tgd --version` (`-v`) | 現在のバージョンを表示（CalVer：YYYY.M.D） |
| `tgd --upgrade` (`-u`) | 強制更新：無効なシンボリックリンクをクリーンアップし、すべてのリンク/フックを再構築 |
| `tgd --uninstall` | すべてのtGD配備を削除（他のファイルには影響しない） |

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

### 例1：プロジェクトをマップ
```
ユーザー：/tgd-map

エージェント：現在のリポジトリ以外に、参照すべきリポジトリはありますか？（local path または git URL）
ユーザー：github.com/CopilotKit/CopilotKit

エージェント：CopilotKit をクローン中...
→ メインリポジトリで /understand を実行...
→ CopilotKit で /understand を実行...
→ $TGD_DIR/CONTEXT.md を作成
→ ダッシュボード：http://localhost:3838
→ /tgd-define の準備完了
```

### 例2：機能を定義
```
ユーザー：/tgd-define JWT認証を追加したい

エージェント：機能名を選んでください：
  1. jwt-auth
  2. token-authentication
  3. auth-jwt-middleware
ユーザー：1

エージェント：どのエンドポイントに認証が必要ですか？
  1. 特定のルート (/api/profile, /api/settings)
  2. /api/login, /api/register 以外のすべてのルート
  3. ロールベース (admin vs user)
ユーザー：1

エージェント：PRD + SPEC を作成中...
→ $TGD_DIR/jwt-auth/PRD.md
→ $TGD_DIR/jwt-auth/SPEC.md

エージェント：この機能にUIコンポーネントはありますか？
  1. はい（デザインを生成）
  2. いいえ（バックエンドのみ）
ユーザー：1

エージェント：3つのHTMLプロトタイプを生成中...
→ $TGD_DIR/jwt-auth/prototype/variant-a.html
→ $TGD_DIR/jwt-auth/prototype/variant-b.html
→ $TGD_DIR/jwt-auth/prototype/variant-c.html

エージェント：デザインの方向性を選んでください：
  A. ミニマルカードベース（クリーン、集中）
  B. ダンスダッシュボード（パワーユーザー向け）
  C. 分割ペイン（コンテキスト豊富）
ユーザー：A

エージェント：DESIGN.md を作成中...
→ $TGD_DIR/jwt-auth/DESIGN.md
→ /tgd-plan の準備完了
```

### 例3：検証（厳格なトーン）
```
ユーザー：/tgd-verify

エージェント：テストスイートを実行中...
→ 47件成功、1件失敗
→ 失敗：test_login_empty_password — ValidationError が必要なところ、200 OK を受信

エージェント：/tgd-develop に修正を依頼します。

[... /tgd-develop が auth.py を修正 ...]

ユーザー：/tgd-verify

エージェント：テストスイートを実行中...
→ 48件成功、0件失敗
→ Exit code 0
→ /tgd-review の準備完了
```

---

## ⚙️ パイプライン

```mermaid
flowchart LR
    A["🔍 マップ\n/tgd-map"] --> B["📋 定義\n/tgd-define"]
    B --> C["📐 計画\n/tgd-plan"]
    C --> D["⚡ 開発\n/tgd-develop"]
    D --> E["🧪 検証\n/tgd-verify"]
    E --> F["🔎 レビュー\n/tgd-review"]
    F --> G["🚀 出荷\n/tgd-ship"]

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
| `bash setup.sh` | 初回インストール（クローンしたリポジトリから実行） |
| `tgd` | tGD のインストールまたは更新（初回インストール後に使用） |
| `tgd --version` (`-v`) | バージョン表示（CalVer形式） |
| `tgd --upgrade` (`-u`) | リンクとフックの強制再構築 |
| `tgd --release` | GitHub リリースを作成（.tgd-version を読み取り） |
| `tgd --uninstall` | すべてのtGD配備を削除 |

### スラッシュコマンド

8つのステージでアイデアから本番環境まで。各ステージが次のステージをゲートキープします。

| 🎯 内容 | ⌨️ コマンド | 💡 原則 | 🔧 呼び出し |
|---|---|---|---|
| プロジェクト理解 | `/tgd-map` | 変更前にコンテキスト | `context-engineering` + `codegraph init` + `understand-dashboard` |
| 何を構築するか定義 | `/tgd-define` | 3択命名 + 製品 + 仕様 | `interview-me` → `idea-refine` → `spec-driven-development` |
| 構築方法を計画 | `/tgd-plan` | CONTEXT + PRD + SPEC → アトミックタスク | `planning-and-task-breakdown` → `jira-auto-sync` |
| サンドボックス構築 | `/tgd-develop` | **必須 Worktree** + スマートルーティング | `source-driven-development` → (`subagent` OR `incremental`) → `test-driven-development` |
| 動作を証明 | `/tgd-verify` | テストが証拠 | `debugging-and-error-recovery` → `test-driven-development` |
| マージ前レビュー | `/tgd-review` | コードの健康改善 | `code-review-and-quality` → `code-simplification` |
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
A：リポジトリをクローンして `bash setup.sh` を実行するだけ。CLI を自動検出し、`tgd` CLI も自動インストールされます。

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
workspace/
├── my-project/                         # コードリポジトリ
│   ├── .codegraph → tGD/.codegraph     # シンボリックリンク（CodeGraph）
│   ├── tGD/
│   │   ├── .codegraph/                 # シンボルインデックス
│   │   └── .understand-anything/       # ナレッジグラフ
│   └── src/
│
├── my-project-frontend/                # コードリポジトリ（オプション）
│
└── my-project-tGD/                     # ← $TGD_DIR（兄弟ディレクトリ）
    ├── CONTEXT.md                      # 製品レベルのコンテキスト + リポジトリ一覧
    ├── CHANGELOG.md                    # 統一バージョンログ
    ├── .scans/                         # 集約されたスキャンデータ
    │   └── <repo>/
    │       ├── .codegraph/
    │       └── .understand-anything/
    │
    └── <feature-name>/                 # フィーチャー単位の構造
        ├── PRD.md                      # 製品要件
        ├── SPEC.md                     # 技術仕様（リポジトリ別タグ）
        ├── DESIGN.md                   # UIデザイン（該当する場合）
        ├── prototype/                  # HTMLモックアップ（UIの場合）
        │   ├── variant-a.html
        │   └── variant-b.html
        ├── TASKS.md                    # BDDタスク（リポジトリ別タグ）
        ├── REVIEW.md                   # コードレビュー報告書
        └── decisions/                  # ADR（任意のフェーズ）
            └── ADR-001.md
```

**注釈：**
- `$TGD_DIR` — tGDフォルダを指す環境変数
- フィーチャーブランチ：tGDリポジトリとコードリポジトリの両方で `feature/<name>` を作成
- SPEC.md / TASKS.md はリポジトリ名でタグ付けし、マルチリポジトリに対応

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

## 🏷️ リリース

### 自動（推奨）
`.tgd-version` を更新して `main` にプッシュすると、GitHub Actions が自動的にタグとリリースを作成します。

**新しいバージョンをリリースするには：**
1. `.tgd-version` を新しいバージョンに更新（例：`v2026.06.09`）
2. `setup.sh` の `TGD_VERSION` を更新（CalVer形式、例：`2026-06-09`）
3. コミットして `main` にプッシュ
4. GitHub Actions が自動的にリリースを作成

### 手動
```bash
# リリーススクリプトを使用
bash scripts/release.sh          # .tgd-version からバージョンを読み取り
bash scripts/release.sh v2026.06.09   # またはバージョンを指定

# または手動で
git tag v2026.06.09
git push origin v2026.06.09
gh release create v2026.06.09 --title "tGD v2026.06.09" --notes "リリースノート..."
```

---

## 📄 ライセンス

Apache 2.0 - あなたのプロジェクト、チーム、ツールでこれらのスキルを使用してください。

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

### その他のプラットフォーム
<details>
<summary><b>Cursor / Windsurf / Kiro</b></summary>

- **Cursor：** `skills/` を `.cursor/rules/` にコピー
- **Windsurf：** スキルの内容を rules 設定に追加
- **Kiro：** skills を `.kiro/skills/` に配置

</details>

<details>
<summary><b>GitHub Copilot</b></summary>

`AGENTS.md` と `.github/copilot-instructions.md` を使用してワークフローを読み込みます。

</details>
