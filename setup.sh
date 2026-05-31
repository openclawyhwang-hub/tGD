#!/bin/bash
# tGD (Agentic PDLC Workflow) One-Click Installer
# Usage: bash setup.sh

set -e

echo "🚀 tGD (Agentic PDLC Workflow) Setup"
echo "===================================="

# 1. Verify Environment
if [[ "$OSTYPE" != "linux-gnu"* && "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Warning: This installer supports Linux and macOS only."
fi

# 2. Configure Agents
echo "🤖 Configuring Agents..."

# OpenCode
if command -v opencode &> /dev/null; then
    echo "   📂 OpenCode detected."
    # Create global commands link
    mkdir -p ~/.config/opencode/commands
    if [ ! -d ~/.config/opencode/commands/tgd ]; then
        ln -sf "$(pwd)/.opencode/commands" ~/.config/opencode/commands/tgd 2>/dev/null || true
        echo "   ✅ Commands symlinked to global config."
    fi
fi

# Claude Code
if command -v claude &> /dev/null; then
    echo "   📂 Claude Code detected."
    if [ -d .claude ]; then
        # Link skills
        mkdir -p ~/.claude/skills
        for skill in skills/*/; do
            skill_name=$(basename "$skill")
            ln -sf "$(pwd)/$skill" ~/.claude/skills/$skill_name 2>/dev/null || true
        done
        echo "   ✅ Skills linked."
    fi
fi

# Gemini CLI
if command -v gemini &> /dev/null; then
    echo "   📂 Gemini CLI detected."
    if [ -d .gemini ]; then
        mkdir -p ~/.gemini/commands
        ln -sf "$(pwd)/.gemini/commands"/* ~/.gemini/commands/ 2>/dev/null || true
        echo "   ✅ Commands linked."
    fi
fi

# Codex CLI
if command -v codex &> /dev/null; then
    echo "   📂 Codex CLI detected."
    mkdir -p ~/.codex
    if [ -d "skills" ]; then
        ln -sf "$(pwd)/skills" ~/.codex/skills/tGD 2>/dev/null || true
        echo "   ✅ Skills linked for auto-detection."
    fi
    if [ -d ".codex/prompts" ]; then
        mkdir -p ~/.codex/prompts
        ln -sf "$(pwd)/.codex/prompts"/* ~/.codex/prompts/ 2>/dev/null || true
        echo "   ✅ Prompts linked (8 tgd-* commands)."
    fi
fi

# Pi Coding Agent
if command -v pi &> /dev/null; then
    echo "   📂 Pi Coding Agent detected."
    mkdir -p .pi/extensions
    if [ -f ".pi/extensions/tgd-commands.ts" ]; then
        echo "   ✅ Pi extension ready (8 tgd-* commands)."
        echo "   ℹ️  Commands available via /tgd-map, /tgd-define, etc."
    fi
fi

# CodeGraph (required for /tgd-map)
echo "📊 Checking CodeGraph..."
if command -v codegraph &> /dev/null; then
    echo "   ✅ CodeGraph already installed."
else
    if command -v pip3 &> /dev/null || command -v pip &> /dev/null; then
        PIP_CMD=$(command -v pip3 || command -v pip)
        echo "   📥 Installing CodeGraph..."
        $PIP_CMD install codegraph-cli 2>/dev/null && echo "   ✅ CodeGraph installed." || echo "   ⚠️  Install manually: pip install codegraph-cli"
    else
        echo "   ⚠️  pip not found. Install Python first, then: pip install codegraph-cli"
    fi
fi

# 3. Install Optional Dependencies (Webwright)
echo "📦 Checking optional dependencies..."

# Webwright (E2E browser testing)
if [ -d "skills/webwright" ]; then
    echo "   🌐 Webwright skill detected."
    if command -v pip3 &> /dev/null || command -v pip &> /dev/null; then
        PIP_CMD=$(command -v pip3 || command -v pip)
        
        # Check if webwright is already installed
        if ! python3 -c "import playwright" 2>/dev/null; then
            echo "   📥 Installing Webwright dependencies..."
            $PIP_CMD install playwright httpx pydantic pyyaml rich typer python-dotenv platformdirs jinja2 2>/dev/null || echo "   ⚠️  pip install failed (network issue?). Install manually: pip install playwright"
            
            # Install browser (Firefox is preferred for Webwright)
            if command -v playwright &> /dev/null; then
                echo "   📥 Installing Playwright Firefox browser..."
                playwright install firefox 2>/dev/null || echo "   ⚠️  Browser install failed. Run manually: playwright install firefox"
                echo "   ✅ Webwright ready!"
            else
                echo "   ⚠️  playwright command not found. Run: pip install playwright && playwright install firefox"
            fi
        else
            echo "   ✅ Webwright already installed."
        fi
    else
        echo "   ⚠️  pip not found. Install Python first."
    fi
fi

# Chrome DevTools MCP (alternative browser testing)
if [ -d "skills/browser-testing-with-devtools" ]; then
    echo "   🔍 Browser Testing skill detected."
    if command -v npx &> /dev/null; then
        echo "   ℹ️  To enable: npx @anthropic/chrome-devtools-mcp@latest"
    fi
fi

echo ""
echo "===================================="
echo "✅ Setup Complete!"
echo ""

# Inject tGD rules into GLOBAL agent config (all projects)
TGD_DIR="$(cd "$(dirname "$0")" && pwd)"
RULES_HEADER="<!-- tGD rules — https://github.com/openclawyhwang-hub/tGD -->"

inject_global() {
    local target="$1"
    local source="$2"
    local platform="$3"
    mkdir -p "$(dirname "$target")"
    if [ -f "$target" ] && grep -q "tGD rules" "$target" 2>/dev/null; then
        echo "   ⏭️  $platform: already configured"
    else
        echo "" >> "$target"
        echo "$RULES_HEADER" >> "$target"
        cat "$source" >> "$target"
        echo "   ✅ $platform: rules injected globally"
    fi
}

echo "📋 Injecting tGD rules into global agent config..."
echo ""

# Claude Code: ~/.claude/CLAUDE.md
inject_global "$HOME/.claude/CLAUDE.md" "$TGD_DIR/.claude/CLAUDE.md" "Claude Code"

# Codex CLI: ~/.codex/AGENTS.md
inject_global "$HOME/.codex/AGENTS.md" "$TGD_DIR/AGENTS.md" "Codex CLI"

# OpenCode: ~/.config/opencode/AGENTS.md
inject_global "$HOME/.config/opencode/AGENTS.md" "$TGD_DIR/AGENTS.md" "OpenCode"

# Gemini CLI: ~/.gemini/GEMINI.md
inject_global "$HOME/.gemini/GEMINI.md" "$TGD_DIR/.gemini/GEMINI.md" "Gemini CLI"

# Pi: ~/.pi/agent/instructions.md
inject_global "$HOME/.pi/agent/instructions.md" "$TGD_DIR/.pi/instructions.md" "Pi"

echo ""
echo "===================================="
echo "✅ Setup Complete!"
echo ""
echo "tGD is now active in ALL projects."
echo "Just start your agent in any project:"
echo "  claude | codex | opencode | gemini | pi"
echo "Then type '/tgd-map' to initialize."
echo ""