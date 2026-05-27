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

# 2. Extract CodeGraph (Offline)
echo "📦 Setting up CodeGraph..."
if [ -d "tools/codegraph-linux-x64" ]; then
    echo "   ✅ CodeGraph already extracted."
else
    if [ -f "tools/codegraph-linux-x64.tar.gz" ]; then
        tar -xzf tools/codegraph-linux-x64.tar.gz -C tools/
        echo "   ✅ CodeGraph extracted."
    else
        echo "   ⚠️  CodeGraph binary not found. Run 'codegraph init -i' manually later."
    fi
fi

# 3. Configure Agents
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

echo ""
echo "===================================="
echo "✅ Setup Complete!"
echo ""
echo "To start:"
echo "1. cd into your project"
echo "2. Run 'opencode', 'claude', or 'gemini'"
echo "3. Type '/tgd-map' to initialize."
echo ""