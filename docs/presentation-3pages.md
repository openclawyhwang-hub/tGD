# Agentic-PDLC-Workflow

## 讓 AI Agent 遵守工程紀律的開發流程

---

## 問題

AI 寫代碼很快，但會走捷徑：

- ❌ 跳過 spec → 需求不清 → 重做
- ❌ 跳過測試 → 上線當機
- ❌ 跳過 review → 安全漏洞

**核心問題：Agent 會自我合理化偷懶**

---

## 解決方案

**結構化流程 + 反合理化機制**

```
CONTEXT → DEFINE → PLAN → BUILD → VERIFY → REVIEW → SHIP
```

| 機制 | 作用 |
|------|------|
| 26 Skills | 每個階段強制執行 |
| Anti-Rationalization | 防止 Agent 找藉口跳過 |
| Jira 整合 | 每個 change 可追溯 |

---

## 實際效益

| 指標 | 改善 |
|------|------|
| 程式品質 | Spec → Test → Review 強制執行 |
| 團隊協作 | 孤立開發，減少衝突 |
| 可追溯性 | 每個 PR 都有 Jira ticket |
| 技術債 | 反合理化防止偷懶 |

**26 Skills • 8 Commands • 7 階段 • 多 Agent 支援**

[github.com/openclawyhwang-hub/Agentic-PDLC-Workflow](https://github.com/openclawyhwang-hub/Agentic-PDLC-Workflow)
