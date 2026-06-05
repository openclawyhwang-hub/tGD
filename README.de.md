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

Ihre KI-Agenten können Code schreiben. tGD lässt sie liefern.

8-Stufen-Pipeline, die jede Agentenentscheidung einschränkt, leitet und verifiziert — von der Spezifikation bis zur Produktion, keine Abkürzungen.

Funktioniert mit Claude Code, Codex CLI, Gemini CLI, OpenCode und Pi Coding Agent.

---

## 🤔 Warum tGD?

**❌ Ohne tGD:**
- KI-Agent schreibt 500 Zeilen Code, Tests schlagen fehl, Sie wissen nicht warum
- "Auf meinem Rechner funktioniert es" → Produktion bricht
- Keine Spezifikation, kein Plan, nur Gefühl

**✅ Mit tGD:**
- Agent schreibt 50 Zeilen, Tests bestehen, weiter zum nächsten Task
- Jedes Feature hat PRD + SPEC + DESIGN bevor Code geliefert wird
- 8-Stufen-Pipeline fängt Bugs ab bevor sie die Produktion erreichen

---

## 🎯 Für wen?

| Ihre Rolle | Wie tGD hilft |
|------------|---------------|
| **Solo-Entwickler** | Schneller liefern mit KI-Workflow |
| **Team-Lead** | Coding-Standards für KI-generierten Code durchsetzen |
| **Startup** | Schnell bewegen ohne etwas zu zerstören |
| **Enterprise** | Qualitätsgates für KI-Entwicklung aufrechterhalten |

---

## 🚀 Schnellstart

### 1. Clone & Setup
```bash
git clone https://github.com/openclawyhwang-hub/tGD.git && cd tGD
tgd
```
> Erkennt installierte CLIs automatisch. Webwright-Abhängigkeiten werden automatisch installiert.
>
> **Alternative:** Wenn `tgd` noch nicht installiert ist, führen Sie `bash setup.sh` direkt aus.

### Installationsoptionen

| Befehl | Beschreibung |
|--------|-------------|
| `tgd` | Neuinstallation (oder Upgrade auf eine neue Version) |
| `tgd --version` (`-v`) | Aktuelle Version anzeigen (CalVer: YYYY.M.D) |
| `tgd --upgrade` (`-u`) | Erneuern: ungültige Symlinks bereinigen und alle Links/Hooks neu erstellen |
| `tgd --uninstall` | Alle tGD-Installation entfernen, ohne andere Dateien zu beeinträchtigen |
| `bash setup.sh` | Legacy-Fallback — entspricht `tgd` |

### 2. Agent starten
```bash
claude   # Claude Code
codex    # Codex CLI
opencode # OpenCode
gemini   # Gemini CLI
pi       # Pi Coding Agent
```

### 3. Projekt initialisieren
```
/tgd-map
```
> Agent scannt die Codebasis und erstellt `CONTEXT.md`.

### 4. Erstes Feature bauen
```
/tgd-define Ich möchte Benutzer-Authentifizierung hinzufügen
```
> Agent interviewt Sie, erstellt PRD + SPEC.

---

## 💡 Praxisbeispiele

### Beispiel 1: Authentifizierung hinzufügen
```
Benutzer: /tgd-define Ich möchte JWT-Authentifizierung

Agent: Welche Endpunkte brauchen Auth?
Benutzer: /api/profile und /api/settings

Agent: Erstelle PRD + SPEC...
→ tGD/define/auth-feature/PRD.md
→ tGD/define/auth-feature/SPEC.md
→ Bereit für /tgd-plan
```

### Beispiel 2: Bug beheben
```
Benutzer: /tgd-verify

Agent: Alle Tests ausführen...
→ 47 bestanden, 1 fehlgeschlagen
→ test_login_empty_password: Erwarteter Fehler, aber Erfolg

Agent: Behebung...
→ Validierung in auth.py hinzugefügt
→ Alle 48 Tests bestanden
→ Bereit für /tgd-review
```

### Beispiel 3: Sicher deployen
```
Benutzer: /tgd-ship

Agent: Finale Prüfungen...
→ Code-Review: ✅ Bestanden (5-Achsen)
→ Security-Audit: ✅ Keine Schwachstellen
→ Testabdeckung: ✅ 87%
→ Bereit zum Merge
```

---

## 🔑 Hauptfunktionen

- **🏖️ Pflicht-Worktree-Isolierung**: Alle Code-Implementierungen laufen in einer isolierten Git-Worktree-Sandbox. `tGD/`-Planungsdateien bleiben unberührt.
- **🚦 Intelligentes Routing**: `/tgd-develop` routet je nach Task-Anzahl (<3 Tasks: Haupt-Agent, ≥3 Tasks: Subagent + Zwei-Stufen-Review).
- **🧠 Drei-Quellen-Planung**: `/tgd-plan` integriert `CONTEXT.md` + `PRD.md` + `SPEC.md` bevor Tasks erstellt werden.
- **🎯 3-Option Feature-Naming**: `/tgd-define` schlägt 3 Namen vor und wartet auf die Auswahl.
- **🔄 Smarte Jira-Integration**: Erforderliche Felder werden automatisch erkannt. Issues werden mit strukturierter "As a... I want..." Formatierung erstellt.

---

## ⚙️ Pipeline

### CLI (`tgd`)

Die `tgd` CLI verwaltet Installation, Updates und Diagnose:

| Befehl | Beschreibung |
|--------|-------------|
| `tgd` | tGD installieren oder aktualisieren |
| `tgd --version` (`-v`) | Version anzeigen (CalVer) |
| `tgd --upgrade` (`-u`) | Links und Hooks erneuern |
| `tgd --uninstall` | Alle tGD-Installationen entfernen |
| `bash setup.sh` | Legacy-Fallback — entspricht `tgd` |

### Slash Commands

8 Stufen von der Idee bis zur Produktion. Jede Stufe gatekept die nächste.

| 🎯 Was | ⌨️ Command | 💡 Prinzip | 🔧 Skills |
|---|---|---|---|
| Projekt verstehen | `/tgd-map` | Kontext vor Änderungen | `context-engineering` + `codegraph init` |
| Definition | `/tgd-define` | 3-Option-Naming + Produkt + Spezifikation | `interview-me` → `idea-refine` → `spec-driven-development` |
| Planung | `/tgd-plan` | CONTEXT + PRD + SPEC → Atomare Tasks | `planning-and-task-breakdown` → `jira-auto-sync` |
| Sandbox-Bau | `/tgd-develop` | **Pflicht-Worktree** + Intelligentes Routing | `source-driven-development` → (`subagent` OR `incremental`) → `test-driven-development` |
| Beweis erbringen | `/tgd-verify` | Tests sind der Beweis | `debugging-and-error-recovery` → `test-driven-development` |
| Review vor Merge | `/tgd-review` | Code-Qualität verbessern | `code-review-and-quality` → `code-simplification` |
| Code vereinfachen | `/tgd-simplify` | Klarheit vor Cleverness | `code-simplification` |
| Produktion | `/tgd-ship` | Schneller ist sicherer | `git-workflow-and-versioning` → `shipping-and-launch` |

---

## 🧪 Test-Strategie

Testing in tGD ist eine progressive Disziplin über drei Stufen:

| Stufe | Rolle | Zweck | Testtyp |
|-------|-------|-------|---------|
| **`/tgd-develop`** | 🔨 Builder | **Tests schreiben** neben Code | Unit-Tests (TDD) |
| **`/tgd-verify`** | 🔍 Inspector | **Alle Tests ausführen** und Fehler beheben | Integration + E2E |
| **`/tgd-review`** | 🕵️ Auditor | **Test-Qualität** prüfen | Coverage + Strategie |

### 🔺 Test-Pyramide
```
          ╱╲
         ╱  ╲         E2E (~5%)      ← Verify-Stufe
        ╱    ╲
       ╱──────╲
      ╱        ╲      Integration (~15%)  ← Verify-Stufe
     ╱          ╲
    ╱────────────╲
   ╱              ╲   Unit-Tests (~80%)  ← Develop-Stufe
  ╱                ╲
 ╱──────────────────╲
```

---

## 🔗 Integrationen

### Jira Data Center
Wenn `/tgd-plan` eine `TASKS.md` generiert, kann der **`jira-auto-sync`** Skill automatisch Jira-Issues erstellen:
```
/tgd-plan → generiert TASKS.md → Benutzer bestätigt → erstellt Jira-Issues
```

---

## 🤖 Agent Personas

| Agent | Rolle | Perspektive |
|-------|-------|-------------|
| [code-reviewer](agents/code-reviewer.md) | Senior Staff Engineer | "Würde ein Staff Engineer das genehmigen?" |
| [test-engineer](agents/test-engineer.md) | QA-Spezialist | Test-Strategie & Prove-It-Muster |
| [security-auditor](agents/security-auditor.md) | Security Engineer | Schwachstellenerkennung |

---

## 🧩 So funktionieren Skills

Jeder Skill folgt einer konsistenten Anatomie:
1. **Frontmatter**: Name, Beschreibung, Trigger
2. **Workflow**: Schritt-für-Schritt-Anweisungen
3. **Verifikation**: Gates die bestanden werden müssen
4. **Anti-Rationalisierung**: Gegen "faule Agent"-Ausreden

**Progressive Disclosure** – Agent lädt Details nur bei Bedarf.

---

## 📊 Leistung

| Metrik | Wert |
|--------|------|
| **Geladene Skills** | 28 (On-Demand, nicht alle gleichzeitig) |
| **Kontextnutzung** | ~5% pro Skill (Progressive Disclosure) |
| **Setup-Zeit** | < 30 Sekunden |
| **Erstes Feature** | ~15 Minuten (von `/tgd-define` bis `/tgd-ship`) |

---

## ❓ FAQ

**Q: Muss ich etwas außer dem Agent installieren?**
A: Nur `tgd` ausführen. Erkennt Ihren CLI automatisch.

**Q: Was wenn mein Agent keine Slash Commands unterstützt?**
A: Sagen Sie "Plane dieses Feature" – tGD mappt Intent automatisch.

**Q: Kann ich Stufen überspringen?**
A: Jede Stufe hat Pre-flight-Checks. Überspringen blockiert die nächste Stufe.

**Q: Funktioniert es mit bestehenden Projekten?**
A: Ja! `/tgd-map` scannt zuerst die bestehende Codebasis.

**Q: Wie unterscheidet es sich von Cursor/Copilot?**
A: Diese Tools schreiben Code. tGD erzwingt einen Workflow – Spezifikation, Plan, Tests, Reviews – bevor Code geliefert wird.

---

## 📁 Projektstruktur

### Laufzeitausgabe (wird während der Entwicklung generiert)
```
<your-project>/
├── tGD/
│   ├── map/
│   │   └── CONTEXT.md              ← Projektkontext (/tgd-map)
│   ├── define/                     ← PRD + SPEC + DESIGN pro Feature
│   │   └── <feature-name>/         ← z.B. auth-feature, user-profile
│   │       ├── PRD.md
│   │       ├── SPEC.md
│   │       └── DESIGN.md
│   └── plan/                       ← Aufgabenzerlegung pro Feature
│       └── <feature-name>/
│           └── TASKS.md
```

### Repository-Inhalt
```
tGD/
├── skills/                     # 28 Skills
├── agents/                     # 3 Spezialisten-Personas
├── references/                 # Checklisten (Sicherheit, Tests, etc.)
├── .claude/commands/           # Claude Code Slash Commands
├── .gemini/commands/           # Gemini CLI Commands
├── .opencode/commands/         # OpenCode Commands
├── .codex/prompts/             # Codex CLI Prompts
├── scripts/                    # Setup & Validierung
└── docs/                       # Plattformspezifische Guides
```

---

## 📦 Alle 28 Skills

<details>
<summary><b>🧭 Meta (1)</b></summary>

| Skill | Zweck |
|-------|-------|
| [using-tGD](skills/using-tGD/SKILL.md) | Arbeit dem richtigen Skill zuordnen |
</details>

<details>
<summary><b>📋 Define (3)</b></summary>

| Skill | Zweck |
|-------|-------|
| [interview-me](skills/interview-me/SKILL.md) | Benutzer-Intent durch Q&A extrahieren |
| [idea-refine](skills/idea-refine/SKILL.md) | Divergentes/konvergentes Denken |
| [spec-driven-development](skills/spec-driven-development/SKILL.md) | PRD + SPEC vor Code |
</details>

<details>
<summary><b>📐 Plan (2)</b></summary>

| Skill | Zweck |
|-------|-------|
| [planning-and-task-breakdown](skills/planning-and-task-breakdown/SKILL.md) | In TASKS.md zerlegen |
| [jira-auto-sync](skills/jira-auto-sync/SKILL.md) | Jira-Issues automatisch erstellen |
</details>

<details>
<summary><b>⚡ Build (9)</b></summary>

| Skill | Zweck |
|-------|-------|
| [subagent-driven-development](skills/subagent-driven-development/SKILL.md) | Parallele Tasks durch frische Subagenten |
| [incremental-implementation](skills/incremental-implementation/SKILL.md) | Schrittweise inkrementell |
| [test-driven-development](skills/test-driven-development/SKILL.md) | Red-Green-Refactor |
| [verification-before-completion](skills/verification-before-completion/SKILL.md) | Beweis vor Behauptungen |
| [context-engineering](skills/context-engineering/SKILL.md) | Richtige Infos an Agent liefern |
| [source-driven-development](skills/source-driven-development/SKILL.md) | Entscheidungen auf offizielle Docs stützen |
| [doubt-driven-development](skills/doubt-driven-development/SKILL.md) | Gegnerische Überprüfung |
| [frontend-ui-engineering](skills/frontend-ui-engineering/SKILL.md) | UI-Architektur & Design-Systeme |
| [api-and-interface-design](skills/api-and-interface-design/SKILL.md) | Contract-First-API-Design |
</details>

<details>
<summary><b>🧪 Verify (3)</b></summary>

| Skill | Zweck |
|-------|-------|
| [agent-browser](skills/agent-browser/SKILL.md) | E2E-Browser-Automatisierung, CDP-basiertes CLI |
| [debugging-and-error-recovery](skills/debugging-and-error-recovery/SKILL.md) | Triage, Fix, Guard |
</details>

<details>
<summary><b>🔎 Review (4)</b></summary>

| Skill | Zweck |
|-------|-------|
| [code-review-and-quality](skills/code-review-and-quality/SKILL.md) | 5-Achsen-Review |
| [code-simplification](skills/code-simplification/SKILL.md) | Komplexität reduzieren |
| [security-and-hardening](skills/security-and-hardening/SKILL.md) | OWASP & Secrets-Management |
| [performance-optimization](skills/performance-optimization/SKILL.md) | Profiling & Anti-Patterns |
</details>

<details>
<summary><b>🚀 Ship (5)</b></summary>

| Skill | Zweck |
|-------|-------|
| [git-workflow-and-versioning](skills/git-workflow-and-versioning/SKILL.md) | Atomische Commits & Trunk-basiert |
| [ci-cd-and-automation](skills/ci-cd-and-automation/SKILL.md) | Shift Left & Feature-Flags |
| [deprecation-and-migration](skills/deprecation-and-migration/SKILL.md) | Migrations-Pattern |
| [documentation-and-adrs](skills/documentation-and-adrs/SKILL.md) | ADRs & API-Dokumentation |
| [shipping-and-launch](skills/shipping-and-launch/SKILL.md) | Stufen-Rollouts & Monitoring |
</details>

---

## 🗺️ Was kommt als nächstes?

Nachdem Sie Ihr erstes Feature gebaut haben:

1. 📖 Lesen Sie die [Test-Strategie](#test-strategie) um die 3-Stufen-Tests zu verstehen
2. 🔧 Entdecken Sie [alle 28 Skills](#alle-28-skills) um zu sehen was verfügbar ist
3. 🤖 Probieren Sie [Agent Personas](#agent-personas) für spezialisierte Reviews
4. 🔗 Richten Sie die [Jira-Integration](#integrationen) für Task-Tracking ein
5. 🌐 Aktivieren Sie [Agent Browser](skills/agent-browser/SKILL.md) für E2E-Browser-Tests

---

## 🤝 Beitragen

Möchten Sie einen Skill hinzufügen oder tGD verbessern? Siehe [CONTRIBUTING.md](CONTRIBUTING.md).

### ⚡ Kurz-Anleitung:
1. Repository forken
2. Skill in `skills/your-skill/` erstellen
3. `bash scripts/validate-skills.js` ausführen
4. PR einreichen

---

## 📄 Lizenz

MIT – Nutzen Sie diese Skills in Ihren Projekten, Teams und Tools.

---

## 📎 Anhang: Manuelle Konfiguration

> **Hinweis:** Nur nötig wenn `tgd` fehlschlägt oder Sie manuelles Linking bevorzugen.

### Claude Code
```bash
claude skills install . --path skills
```

### Gemini CLI
```bash
gemini skills install . --path skills
```

### Codex CLI
Codex verlässt sich auf **Skill-Autoerkennung** statt auf Slash Commands.
```bash
ln -s $(pwd)/skills ~/.codex/skills/tGD
```
*Auslöser:* Sagen Sie „Plane dieses Feature" – Codex wird den Skill automatisch aufrufen.

### OpenCode
OpenCode erkennt den `skills/` Ordner im Workspace automatisch.

### Pi Coding Agent
Pi unterstützt `/tgd-plan` nativ über eine **TypeScript Extension** (`.pi/extensions/`).
```bash
pi
/tgd-plan
```
