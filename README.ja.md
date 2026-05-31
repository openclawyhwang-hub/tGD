# tGD

<p align="center">
  <img src="https://img.shields.io/github/stars/openclawyhwang-hub/tGD?style=for-the-badge&logo=github&label=Stars&color=gold" alt="GitHub Stars">
  <img src="https://img.shields.io/github/license/openclawyhwang-hub/tGD?style=for-the-badge&color=blue" alt="License">
  <img src="https://img.shields.io/github/last-commit/openclawyhwang-hub/tGD?style=for-the-badge&logo=github&label=Last%20Commit&color=green" alt="Last Commit">
  <img src="https://img.shields.io/badge/platforms-Claude%20Code%20%7C%20Codex%20%7C%20Gemini%20%7C%20OpenCode%20%7C%20Pi-8A2BE2?style=for-the-badge" alt="Platforms">
</p>

<p align="center">
  <a href="README.md">English</a> | <a href="README.zh-TW.md">繁體中文</a> | <a href="README.ja.md">日本語</a> | <a href="README.de.md">Deutsch</a>
</p>

**tGD は、AI コーディングエージェントをシニアエンジニアのように動作させるスキルパックです。**

「コードを書いて」ではなく、規律あるワークフローを強制します：**Map → Define → Plan → Build → Verify → Review → Simplify → Ship**。

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
→ tGD/auth-feature/PRD.md
→ tGD/auth-feature/SPEC.md
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

## ⚙️ パイプライン

8つのステージでアイデアから本番環境まで。各ステージが次のステージをゲートキープします。

| 🎯 内容 | ⌨️ コマンド | 💡 原則 | 🔧 呼び出し |
|---|---|---|---|
| プロジェクト理解 | `/tgd-map` | 変更前にコンテキスト | `context-engineering` + `codegraph init` |
| 何を構築するか定義 | `/tgd-define` | コードの前に仕様 | `interview-me` → `idea-refine` → `spec-driven-development` |
| 構築方法を計画 | `/tgd-plan` | 小さくアトミックなタスク | `planning-and-task-breakdown` → **Jira同期** |
| 増分構築 | `/tgd-develop` | 一度に1スライス | `source-driven-development` → `incremental-implementation` → `test-driven-development` |
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

## ❓ よくある質問

**Q：エージェント以外にインストールが必要？**
A：`bash setup.sh` だけ。CLIを自動検出。

**Q：スラッシュコマンド非対応のエージェントは？**
A：「この機能を計画して」と自然言語で言うと自動マッピング。

**Q：ステージをスキップできる？**
A：各ステージにプレフライトチェック。スキップすると次のステージがブロック。

**Q：既存プロジェクトで使える？**
A：はい！`/tgd-map` が既存コードベースをスキャン。

**Q：Cursor/Copilotと何が違う？**
A：それらはコードを書く。tGDはワークフロー（仕様→計画→テスト→レビュー）を強制。

---

## 📦 全25スキル

<details>
<summary><b>🧭 Meta (1)</b></summary>

| スキル | 用途 |
|--------|------|
| using-agent-skills | 作業を適切なスキルにマッピング |
</details>

<details>
<summary><b>📋 Define (3)</b></summary>

| スキル | 用途 |
|--------|------|
| interview-me | Q&Aでユーザー意図を抽出 |
| idea-refine | 発散/収束思考 |
| spec-driven-development | PRD + SPEC を先に作成 |
</details>

<details>
<summary><b>📐 Plan (2)</b></summary>

| スキル | 用途 |
|--------|------|
| planning-and-task-breakdown | TASKS.md に分解 |
| jira-auto-sync | Jira issue 自動作成 |
</details>

<details>
<summary><b>⚡ Build (7)</b></summary>

| スキル | 用途 |
|--------|------|
| incremental-implementation | 縦に薄くスライスして実装 |
| test-driven-development | Red-Green-Refactor |
| context-engineering | 正確な情報をエージェントに供給 |
| source-driven-development | 公式ドキュメントに基づく判断 |
| doubt-driven-development | 対抗レビュー |
| frontend-ui-engineering | UIアーキテクチャ & デザインシステム |
| api-and-interface-design | コントラクトファーストAPI設計 |
</details>

<details>
<summary><b>🧪 Verify (3)</b></summary>

| スキル | 用途 |
|--------|------|
| browser-testing-with-devtools | ランタイムデータ & DOM検査 |
| webwright | E2Eブラウザ自動化 |
| debugging-and-error-recovery | トリアージ、修正、防御 |
</details>

<details>
<summary><b>🔎 Review (4)</b></summary>

| スキル | 用途 |
|--------|------|
| code-review-and-quality | 5軸レビュー |
| code-simplification | 複雑性削減 |
| security-and-hardening | OWASP & シークレット管理 |
| performance-optimization | パフォーマンス解析 & アンチパターン |
</details>

<details>
<summary><b>🚀 Ship (5)</b></summary>

| スキル | 用途 |
|--------|------|
| git-workflow-and-versioning | アトミックコミット & トランクベース開発 |
| ci-cd-and-automation | Shift Left & フィーチャーフラグ |
| deprecation-and-migration | マイグレーションパターン |
| documentation-and-adrs | ADR & APIドキュメント |
| shipping-and-launch | 段階的デプロイ & モニタリング |
</details>

---

## 📄 ライセンス

MIT - あなたのプロジェクト、チーム、ツールでこれらのスキルを使用してください。
