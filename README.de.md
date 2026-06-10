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

**Ihr KI-Agent hat 500 Zeilen Code geschrieben. Hat er die Tests ausgeführt? Ihre Codebase gelesen? Ein Spec geschrieben?**

**Wahrscheinlich nicht.**

tGD ist eine 7-Stufen-Pipeline, die Agenten zwingt, denselben Workflow zu befolgen wie Sie:
Map → Define → Plan → Develop → Verify → Review → Ship

Keine Abkürzungen. Kein "sollte funktionieren". Nur Beweise.

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
- 7-Stufen-Pipeline fängt Bugs ab bevor sie die Produktion erreichen

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
bash setup.sh
```
> Erkennt installierte CLIs automatisch. Webwright-Abhängigkeiten werden automatisch installiert.
>
> Dies installiert auch die `tgd` CLI in Ihren PATH für zukünftige Verwendung.

### Installationsoptionen

| Befehl | Beschreibung |
|--------|-------------|
| `bash setup.sh` | Erstinstallation (aus dem geklonten Repository ausführen) |
| `tgd` | tGD installieren oder aktualisieren (nach der Erstinstallation) |
| `tgd --version` (`-v`) | Aktuelle Version anzeigen (CalVer: YYYY.M.D) |
| `tgd --upgrade` (`-u`) | Erneuern: ungültige Symlinks bereinigen und alle Links/Hooks neu erstellen |
| `tgd --uninstall` | Alle tGD-Installation entfernen, ohne andere Dateien zu beeinträchtigen |

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

### Beispiel 1: Projekt mappen
```
Benutzer: /tgd-map

Agent: Neben dem aktuellen Repo, gibt es weitere Repositories zum Referenzieren? (local path oder git URL)
Benutzer: github.com/CopilotKit/CopilotKit

Agent: CopilotKit wird geklont...
→ /understand wird auf Hauptrepo ausgeführt...
→ /understand wird auf CopilotKit ausgeführt...
→ $TGD_DIR/CONTEXT.md erstellt
→ Dashboard: http://localhost:3838
→ Bereit für /tgd-define
```

### Beispiel 2: Feature definieren
```
Benutzer: /tgd-define Ich möchte JWT-Authentifizierung

Agent: Feature-Name — wählen Sie einen:
  1. jwt-auth
  2. token-authentication
  3. auth-jwt-middleware
Benutzer: 1

Agent: Welche Endpunkte brauchen Auth?
  1. Spezifische Routen (/api/profile, /api/settings)
  2. Alle Routen außer /api/login, /api/register
  3. Rollenbasiert (admin vs user)
Benutzer: 1

Agent: Erstelle PRD + SPEC...
→ $TGD_DIR/jwt-auth/PRD.md
→ $TGD_DIR/jwt-auth/SPEC.md

Agent: Hat dieses Feature eine UI-Komponente?
  1. Ja (Design generieren)
  2. Nein (nur Backend)
Benutzer: 1

Agent: Generiere 3 HTML-Prototypen...
→ $TGD_DIR/jwt-auth/prototype/variant-a.html
→ $TGD_DIR/jwt-auth/prototype/variant-b.html
→ $TGD_DIR/jwt-auth/prototype/variant-c.html

Agent: Wählen Sie eine Designrichtung:
  A. Minimal kartengestützt (sauber, fokussiert)
  B. Dichtes Dashboard (Power-User-orientiert)
  C. Geteilte Ansicht (kontextreich)
Benutzer: A

Agent: Schreibe DESIGN.md...
→ $TGD_DIR/jwt-auth/DESIGN.md
→ Bereit für /tgd-plan
```

### Beispiel 3: Verifizieren (strenger Ton)
```
Benutzer: /tgd-verify

Agent: Test-Suite wird ausgeführt...
→ 47 bestanden, 1 fehlgeschlagen
→ FEHLER: test_login_empty_password — ValidationError erwartet, aber 200 OK erhalten

Agent: Wird an /tgd-develop zur Behebung übergeben.

[... /tgd-develop behebt auth.py ...]

Benutzer: /tgd-verify

Agent: Test-Suite wird ausgeführt...
→ 48 bestanden, 0 fehlgeschlagen
→ Exit code 0
→ Bereit für /tgd-review
```

---

## ⚙️ Pipeline

```mermaid
flowchart LR
    A["🔍 MAP\n/tgd-map"] --> B["📋 DEFINIEREN\n/tgd-define"]
    B --> C["📐 PLANEN\n/tgd-plan"]
    C --> D["⚡ ENTWICKELN\n/tgd-develop"]
    D --> E["🧪 VERIFIZIEREN\n/tgd-verify"]
    E --> F["🔎 REVIEW\n/tgd-review"]
    F --> G["🚀 LIEFERN\n/tgd-ship"]

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
| `bash setup.sh` | Erstinstallation (aus dem geklonten Repository ausführen) |
| `tgd` | tGD installieren oder aktualisieren (nach der Erstinstallation) |
| `tgd --version` (`-v`) | Version anzeigen (CalVer) |
| `tgd --upgrade` (`-u`) | Links und Hooks erneuern |
| `tgd --release` | GitHub-Release erstellt (liest .tgd-version) |
| `tgd --uninstall` | Alle tGD-Installationen entfernen |

### Slash Commands

8 Stufen von der Idee bis zur Produktion. Jede Stufe gatekept die nächste.

| 🎯 Was | ⌨️ Command | 💡 Prinzip | 🔧 Skills |
|---|---|---|---|
| Projekt verstehen | `/tgd-map` | Kontext vor Änderungen | `context-engineering` + `codegraph init` + `understand-dashboard` |
| Definition | `/tgd-define` | 3-Option-Naming + Produkt + Spezifikation | `interview-me` → `idea-refine` → `spec-driven-development` |
| Planung | `/tgd-plan` | CONTEXT + PRD + SPEC → Atomare Tasks | `planning-and-task-breakdown` → `jira-auto-sync` |
| Sandbox-Bau | `/tgd-develop` | **Pflicht-Worktree** + Intelligentes Routing | `source-driven-development` → (`subagent` OR `incremental`) → `test-driven-development` |
| Beweis erbringen | `/tgd-verify` | Tests sind der Beweis | `debugging-and-error-recovery` → `test-driven-development` |
| Review vor Merge | `/tgd-review` | Code-Qualität verbessern | `code-review-and-quality` → `code-simplification` |
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
A: Repository klonen und `bash setup.sh` ausführen. Erkennt Ihren CLI automatisch und installiert die `tgd` CLI mit.

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

So sieht Ihr Workspace nach dem tGD-Lebenszyklus aus:

```
workspace/
├── my-project/                         # Code-Repository
│   ├── .codegraph → tGD/.codegraph     # Symlink für CodeGraph CLI
│   ├── tGD/
│   │   ├── .codegraph/                 # Symbolindex (automatisch)
│   │   └── .understand-anything/       # Wissensgraph (automatisch)
│   ├── src/                            # Implementierungscode
│   └── tests/                          # Testdateien
│
├── my-project-frontend/                # Code-Repository (optional)
│   ├── .codegraph → tGD/.codegraph
│   ├── tGD/
│   └── src/
│
└── my-project-tGD/                     # ← $TGD_DIR (Geschwister-Repo)
    ├── CONTEXT.md                      # Produktkontext + Repo-Inventar
    ├── CHANGELOG.md                    # Einheitliches Versionsprotokoll
    ├── .scans/                         # Zentralisierte Scan-Daten
    │   ├── my-project/
    │   │   ├── .codegraph/
    │   │   └── .understand-anything/
    │   └── my-project-frontend/
    │       ├── .codegraph/
    │       └── .understand-anything/
    │
    └── <feature-name>/                 # Ein Ordner pro Feature
        ├── PRD.md                      # What & Why (10 Sektionen)
        ├── SPEC.md                     # How (Repo-getaggt)
        ├── DESIGN.md                   # UI-Design (falls zutreffend)
        ├── prototype/                  # HTML-Mockups (bei UI)
        │   ├── variant-a.html
        │   └── variant-b.html
        ├── TASKS.md                    # BDD-Aufgaben (Repo-getaggt)
        ├── REVIEW.md                   # Code-Review + Simplifikation
        └── decisions/                  # ADRs (beliebige Phase)
            └── ADR-001.md
```

#### Beispiel: Vollständiger Workspace mit mehreren Features

Ein realistischer Workspace für eine SaaS-Anwendung mit Express-Backend + React-Frontend und zwei Features in unterschiedlichen Phasen:

```
workspace/
├── acme-api/                           # Backend-Repo (Express + Prisma)
│   ├── .codegraph → tGD/.codegraph
│   ├── tGD/
│   │   ├── .codegraph/
│   │   └── .understand-anything/
│   ├── src/
│   │   ├── routes/
│   │   │   ├── auth.ts                 # ← user-auth Feature
│   │   │   ├── payment.ts              # ← payment-flow Feature
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
├── acme-web/                           # Frontend-Repo (React + Vite)
│   ├── .codegraph → tGD/.codegraph
│   ├── tGD/
│   │   ├── .codegraph/
│   │   └── .understand-anything/
│   ├── src/
│   │   ├── components/
│   │   │   ├── LoginForm.tsx           # ← user-auth Feature
│   │   │   ├── PaymentForm.tsx         # ← payment-flow Feature
│   │   │   └── Dashboard.tsx
│   │   └── pages/
│   │       ├── login.tsx
│   │       └── checkout.tsx
│   └── tests/
│       ├── LoginForm.test.tsx
│       └── PaymentForm.test.tsx
│
└── acme-tGD/                           # ← $TGD_DIR (Geschwister-Repo)
    ├── CONTEXT.md                      # Repo-Inventar: acme-api, acme-web
    ├── CHANGELOG.md
    │   # v1.0.0 - user-auth shipped
    │   # v1.1.0 - payment-flow shipped
    │
    ├── .scans/
    │   ├── acme-api/
    │   │   ├── .codegraph/
    │   │   └── .understand-anything/
    │   └── acme-web/
    │       ├── .codegraph/
    │       └── .understand-anything/
    │
    ├── user-auth/                      # Feature 1: ausgeliefert ✅
    │   ├── PRD.md                      # "Benutzer müssen sich anmelden"
    │   ├── SPEC.md                     # Backend: JWT + bcrypt / Frontend: LoginForm
    │   ├── DESIGN.md                   # Login-Seitenentwurf
    │   ├── prototype/
    │   │   ├── variant-a.html          # Minimales Login-Formular
    │   │   └── variant-b.html          # Mit Social-Login-Buttons
    │   ├── TASKS.md                    # 5 Aufgaben, alle erledigt
    │   ├── REVIEW.md                   # Bestanden: 87% Coverage
    │   └── decisions/
    │       └── ADR-001-use-jwt.md      # Warum JWT statt Sessions
    │
    └── payment-flow/                   # Feature 2: in Planung 🚧
        ├── PRD.md                      # "Benutzer müssen bezahlen"
        ├── SPEC.md                     # Backend: Stripe API / Frontend: PaymentForm
        ├── DESIGN.md                   # Checkout-Seitenentwurf
        ├── prototype/
        │   ├── variant-a.html          # Einzelseiten-Checkout
        │   └── variant-b.html          # Mehrstufiger Checkout
        └── TASKS.md                    # 8 Aufgaben, noch nicht begonnen
```

**Was Sie sehen:**
- **2 Code-Repositories** (acme-api, acme-web) + **1 tGD-Repository** (acme-tGD) als Geschwister
- **2 Features** im tGD-Repo: `user-auth` (ausgeliefert) und `payment-flow` (Planung)
- **Jedes Feature** hat eigene PRD, SPEC, DESIGN, prototype, TASKS, REVIEW und decisions
- **SPEC.md** und **TASKS.md** taggen Einträge nach Repo-Name (z.B. `[acme-api]`, `[acme-web]`)
- **Code-Repositories** sind sauber — nur `tGD/` Symlink-Ordner + `src/` + `tests/`
- **CHANGELOG.md** protokolliert die einheitliche Versionshistorie über alle Features

| Phase | Befehl | Artefakte | Ort |
|-------|--------|-----------|-----|
| Map | `/tgd-map` | CONTEXT.md | `$TGD_DIR/CONTEXT.md` |
| Define | `/tgd-define` | PRD.md, SPEC.md, DESIGN.md, prototype/ | `$TGD_DIR/<feature>/` |
| Plan | `/tgd-plan` | TASKS.md | `$TGD_DIR/<feature>/TASKS.md` |
| Develop | `/tgd-develop` | src/ | Code-Repository |
| Verify | `/tgd-verify` | tests/ | Code-Repository |
| Review | `/tgd-review` | REVIEW.md | `$TGD_DIR/<feature>/REVIEW.md` |
| Ship | `/tgd-ship` | CHANGELOG.md, git tag | `$TGD_DIR/CHANGELOG.md` |

#### Multi-Repo-Tagging

Wenn Ihr Projekt mehrere Repositories umfasst, taggen SPEC.md und TASKS.md Einträge nach Repo:

**SPEC.md:**
```markdown
## Backend (my-project)
- POST /api/auth/login
- JWT token generation
- Password hashing with bcrypt

## Frontend (my-project-frontend)
- LoginForm component
- Token storage in httpOnly cookie
- Redirect after login
```

**TASKS.md:**
```markdown
## Task 1: Auth endpoint
- [my-project] POST /api/auth/login
- Acceptance: returns JWT on valid credentials
- Files: src/routes/auth.ts
- Tests: tests/auth.test.ts

## Task 2: LoginForm
- [my-project-frontend] LoginForm component
- Acceptance: submits credentials, stores token
- Files: src/components/LoginForm.tsx
- Tests: tests/LoginForm.test.tsx
```

#### Scan-Daten (`.scans/`)

CodeGraph- und Understand-Anything-Ausgaben werden in `$TGD_DIR/.scans/<repo>/` zentralisiert. Jedes Code-Repository hat Symlinks, damit die Tools ohne Kenntnis des zentralen Speichers funktionieren:

```
my-project/.codegraph        → tGD/.codegraph        → $TGD_DIR/.scans/my-project/.codegraph
my-project/.understand-anything → tGD/.understand-anything → $TGD_DIR/.scans/my-project/.understand-anything
```

So bleiben Code-Repositories sauber — an der Wurzel nur `tGD/` (Symlink-Ordner) und `src/`.

#### Wichtige Konventionen

| Konvention | Beschreibung |
|------------|--------------|
| `$TGD_DIR` | Umgebungsvariable zum tGD-Ordner |
| Feature-Branches | Sowohl tGD- als auch Code-Repo erstellen `feature/<name>` |
| Branch-Benennung | Gleicher Name über alle Repos (Traceability) |
| CONTEXT.md | Eins pro Produkt, enthält Repo-Inventartabelle |
| CHANGELOG.md | Eins pro Produkt, iteratives Versionsprotokoll |
| decisions/ | ADRs aus jeder Phase, nicht an Define gebunden |

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

## 🏷️ Release

### Automatisiert (empfohlen)
Wenn `.tgd-version` aktualisiert und auf `main` gepusht wird, erstellt GitHub Actions automatisch einen Tag und Release mit Changelog.

**So erstellen Sie ein neues Release:**
1. `.tgd-version` mit der neuen Version aktualisieren (z.B. `v2026.06.09`)
2. `TGD_VERSION` in `setup.sh` aktualisieren (CalVer-Format, z.B. `2026-06-09`)
3. Committen und auf `main` pushen
4. GitHub Actions erstellt das Release automatisch

### Manuell
```bash
# Mit dem Release-Script
bash scripts/release.sh          # liest Version aus .tgd-version
bash scripts/release.sh v2026.06.09   # oder Version angeben

# Oder manuell
git tag v2026.06.09
git push origin v2026.06.09
gh release create v2026.06.09 --title "tGD v2026.06.09" --notes "Release-Notizen..."
```

---

## 📄 Lizenz

Apache 2.0 – Nutzen Sie diese Skills in Ihren Projekten, Teams und Tools.

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

### Andere Plattformen
<details>
<summary><b>Cursor / Windsurf / Kiro</b></summary>

- **Cursor:** `skills/` nach `.cursor/rules/` kopieren
- **Windsurf:** Skill-Inhalte zur Rules-Konfiguration hinzufügen
- **Kiro:** Skills in `.kiro/skills/` ablegen

</details>

<details>
<summary><b>GitHub Copilot</b></summary>

Verwenden Sie `AGENTS.md` und `.github/copilot-instructions.md` um diese Workflows zu laden.

</details>
