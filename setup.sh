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

# Install tGD rules as SEPARATE files (no pollution)
TGD_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "📋 Installing tGD rules (standalone files, no config pollution)..."
echo ""

# Claude Code: ~/.claude/rules/tgd.md (auto-loaded by Claude Code)
mkdir -p "$HOME/.claude/rules"
ln -sf "$TGD_DIR/skills/tgd-rules/SKILL.md" "$HOME/.claude/rules/tgd.md" 2>/dev/null && echo "   ✅ Claude Code: ~/.claude/rules/tgd.md → symlink"

# Codex CLI: ~/.codex/skills/tgd-rules (auto-discovered)
mkdir -p "$HOME/.codex/skills"
ln -sf "$TGD_DIR/skills/tgd-rules" "$HOME/.codex/skills/tgd-rules" 2>/dev/null && echo "   ✅ Codex CLI: ~/.codex/skills/tgd-rules → symlink"

# OpenCode: skill auto-discovered from workspace
echo "   ✅ OpenCode: auto-discovers skills/ in workspace"

# Gemini CLI: ~/.gemini/skills/tgd-rules
mkdir -p "$HOME/.gemini/skills"
ln -sf "$TGD_DIR/skills/tgd-rules" "$HOME/.gemini/skills/tgd-rules" 2>/dev/null && echo "   ✅ Gemini CLI: ~/.gemini/skills/tgd-rules → symlink"

# Pi: ~/.pi/agent/skills/tgd-rules
mkdir -p "$HOME/.pi/agent/skills"
ln -sf "$TGD_DIR/skills/tgd-rules" "$HOME/.pi/agent/skills/tgd-rules" 2>/dev/null && echo "   ✅ Pi: ~/.pi/agent/skills/tgd-rules → symlink"

echo ""
echo "===================================="
echo "✅ Setup Complete!"
echo ""
echo "tGD is now active in ALL projects."
echo "Just start your agent in any project:"
echo "  claude | codex | opencode | gemini | pi"
echo "Then type '/tgd-map' to initialize."
echo ""