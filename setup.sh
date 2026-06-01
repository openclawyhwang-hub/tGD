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
    # Create global commands link (individual files, not subdirectory)
    mkdir -p ~/.config/opencode/commands
    for cmd in .opencode/commands/*.md; do
        cmd_name=$(basename "$cmd")
        ln -sf "$(pwd)/$cmd" ~/.config/opencode/commands/$cmd_name 2>/dev/null || true
    done
    echo "   ✅ Commands linked (8 tgd-* commands)."
    # Install plugins (hooks)
    if [ -d ".opencode/plugins" ]; then
        mkdir -p ~/.config/opencode/plugins
        ln -sf "$(pwd)/.opencode/plugins"/* ~/.config/opencode/plugins/ 2>/dev/null || true
        echo "   ✅ Plugins installed (session-start, simplify-ignore, sdd-cache)."
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

        # Link commands (slash commands: /tgd-map, /tgd-develop, etc.)
        if [ -d .claude/commands ]; then
            mkdir -p ~/.claude/commands
            ln -sf "$(pwd)/.claude/commands"/* ~/.claude/commands/ 2>/dev/null || true
            echo "   ✅ Commands linked (8 tgd-* slash commands)."
        fi

        # Install hooks into settings.json (resolve paths to absolute)
        if [ -d hooks ] && [ -f hooks/hooks.json ]; then
            mkdir -p ~/.claude
            TGD_ABS="$(pwd)"
            SETTINGS="$HOME/.claude/settings.json"
            # Create default settings.json if it doesn't exist
            if [ ! -f "$SETTINGS" ]; then
                echo '{}' > "$SETTINGS"
            fi
            python3 -c "
import json
TGD_ABS = '$TGD_ABS'
SETTINGS = '$SETTINGS'
# Load existing user settings
with open(SETTINGS) as f:
    user = json.load(f)
# Load tGD hooks
with open('hooks/hooks.json') as f:
    tgd = json.load(f)
# Resolve ${CLAUDE_PLUGIN_ROOT} to absolute path
def resolve(obj, key='command'):
    if isinstance(obj, dict):
        for k, v in list(obj.items()):
            if k == key and isinstance(v, str) and '$' + '{CLAUDE_PLUGIN_ROOT}' in v:
                obj[k] = v.replace('$' + '{CLAUDE_PLUGIN_ROOT}', TGD_ABS)
            else:
                resolve(v, key)
    elif isinstance(obj, list):
        for item in obj:
            resolve(item, key)
resolve(tgd)
# Merge hooks by event name (deduplicate by command string)
user_hooks = user.setdefault('hooks', {})
for event, hook_list in tgd.get('hooks', {}).items():
    existing = user_hooks.get(event, [])
    existing_cmds = set()
    for h in existing:
        for sub in h.get('hooks', []):
            existing_cmds.add(sub.get('command', ''))
    for entry in hook_list:
        for sub in entry.get('hooks', []):
            if sub.get('command', '') not in existing_cmds:
                existing.append(entry)
                break
    user_hooks[event] = existing
with open(SETTINGS, 'w') as f:
    json.dump(user, f, indent=2)
print('   ✅ Hooks merged into ~/.claude/settings.json.')
" 2>/dev/null || echo "   ⚠️  Hooks install failed (python3 required)."
        fi
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
    # Install hooks (Gemini uses flat format, different from Claude Code/Codex nested format)
    if [ -f .gemini/settings.json ]; then
        mkdir -p ~/.gemini
        TGD_ABS="$(pwd)"
        # Resolve relative paths in .gemini/settings.json to absolute
        if [ -f ~/.gemini/settings.json ]; then
            echo "   ⚠️  ~/.gemini/settings.json exists. Merging tGD hooks..."
            python3 -c "
import json
TGD_ABS = '$TGD_ABS'
with open('$HOME/.gemini/settings.json') as f:
    user = json.load(f)
with open('.gemini/settings.json') as f:
    tgd = json.load(f)
# Resolve relative paths, ensure type: "command",
# and convert ALL hooks to nested format (matcher + hooks array)
for event, hook_list in tgd.get('hooks', {}).items():
    if event in ('BeforeTool', 'AfterTool'):
        by_matcher = {}
        for h in hook_list:
            if 'type' not in h:
                h['type'] = 'command'
            cmd = h.get('command', '')
            if cmd.startswith('bash hooks/'):
                h['command'] = cmd.replace('bash hooks/', 'bash ' + TGD_ABS + '/hooks/', 1)
            matcher = h.get('matcher', '*')
            if matcher not in by_matcher:
                by_matcher[matcher] = []
            h.pop('matcher', None)
            by_matcher[matcher].append(h)
        tgd['hooks'][event] = [
            {"matcher": m, "hooks": hooks}
            for m, hooks in by_matcher.items()
        ]
    else:
        # Lifecycle events (SessionStart, SessionEnd) also need nested format
        for h in hook_list:
            if 'type' not in h:
                h['type'] = 'command'
            cmd = h.get('command', '')
            if cmd.startswith('bash hooks/'):
                h['command'] = cmd.replace('bash hooks/', 'bash ' + TGD_ABS + '/hooks/', 1)
        tgd['hooks'][event] = [
            {"matcher": "*", "hooks": hook_list}
        ]
user_hooks = user.setdefault('hooks', {})
for event, hook_list in tgd.get('hooks', {}).items():
    existing = user_hooks.get(event, [])
    # All events use nested format: [{matcher, hooks: [...]}]
    existing_by_matcher = {}
    for i, entry in enumerate(existing):
        m = entry.get('matcher', '*')
        existing_by_matcher[m] = i
    for entry in hook_list:
        matcher = entry.get('matcher', '*')
        if matcher in existing_by_matcher:
            # Replace existing entry
            existing[existing_by_matcher[matcher]] = entry
        else:
            existing.append(entry)
    user_hooks[event] = existing
with open('$HOME/.gemini/settings.json', 'w') as f:
    json.dump(user, f, indent=2)
print('   ✅ tGD hooks merged into ~/.gemini/settings.json.')
" 2>/dev/null || echo "   ⚠️  Merge failed — please manually merge hooks from .gemini/settings.json"
        else
            python3 -c "
import json
TGD_ABS = '$TGD_ABS'
with open('.gemini/settings.json') as f:
    cfg = json.load(f)
for event, hook_list in cfg.get('hooks', {}).items():
    for h in hook_list:
        cmd = h.get('command', '')
        if cmd.startswith('bash hooks/'):
            h['command'] = cmd.replace('bash hooks/', f'bash {TGD_ABS}/hooks/', 1)
with open('$HOME/.gemini/settings.json', 'w') as f:
    json.dump(cfg, f, indent=2)
print('   ✅ Hooks installed to ~/.gemini/settings.json.')
" 2>/dev/null || echo "   ⚠️  Hooks install failed (python3 required)."
        fi
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
    # Install hooks (Codex only reads ~/.codex/hooks.json — plugin-local hooks don't work)
    # NOTE: Only SessionStart hook is cross-platform. simplify-ignore and sdd-cache
    # scripts rely on CLAUDE_PROJECT_DIR env var, which Codex does not set.
    if [ -f hooks/hooks.json ]; then
        HOOKS_DST="$HOME/.codex/hooks.json"
        TGD_ABS="$(pwd)"
        if [ -f "$HOOKS_DST" ]; then
            echo "   ⚠️  ~/.codex/hooks.json exists. Merging tGD hooks..."
            python3 -c "
import json
TGD_ABS = '$TGD_ABS'
HOOKS_DST = '$HOOKS_DST'
with open(HOOKS_DST) as f:
    user = json.load(f)
with open('hooks/hooks.json') as f:
    tgd = json.load(f)
def resolve(obj, key='command'):
    if isinstance(obj, dict):
        for k, v in list(obj.items()):
            if k == key and isinstance(v, str) and '$' + '{CLAUDE_PLUGIN_ROOT}' in v:
                obj[k] = v.replace('$' + '{CLAUDE_PLUGIN_ROOT}', TGD_ABS)
            else:
                resolve(v, key)
    elif isinstance(obj, list):
        for item in obj:
            resolve(item, key)
resolve(tgd)
user_hooks = user.setdefault('hooks', {})
for event, hook_list in tgd.get('hooks', {}).items():
    existing = user_hooks.get(event, [])
    existing_cmds = set()
    for h in existing:
        for sub in h.get('hooks', []):
            existing_cmds.add(sub.get('command', ''))
    for entry in hook_list:
        for sub in entry.get('hooks', []):
            if sub.get('command', '') not in existing_cmds:
                existing.append(entry)
                break
    user_hooks[event] = existing
with open(HOOKS_DST, 'w') as f:
    json.dump(user, f, indent=2)
print('   ✅ tGD hooks merged into ~/.codex/hooks.json.')
print('   ℹ️  Codex requires hook trust: run /hooks in Codex to trust new hooks.')
" 2>/dev/null || echo "   ⚠️  Hooks merge failed (python3 required)."
        else
            python3 -c "
import json
TGD_ABS = '$TGD_ABS'
with open('hooks/hooks.json') as f:
    cfg = json.load(f)
def resolve(obj, key='command'):
    if isinstance(obj, dict):
        for k, v in list(obj.items()):
            if k == key and isinstance(v, str) and '$' + '{CLAUDE_PLUGIN_ROOT}' in v:
                obj[k] = v.replace('$' + '{CLAUDE_PLUGIN_ROOT}', TGD_ABS)
            else:
                resolve(v, key)
    elif isinstance(obj, list):
        for item in obj:
            resolve(item, key)
resolve(cfg)
with open('$HOOKS_DST', 'w') as f:
    json.dump(cfg, f, indent=2)
print('   ✅ Hooks installed to ~/.codex/hooks.json.')
print('   ℹ️  Codex requires hook trust: run /hooks in Codex to trust new hooks.')
" 2>/dev/null || echo "   ⚠️  Hooks install failed (python3 required)."
        fi
    fi
fi

# Pi Coding Agent
if command -v pi &> /dev/null; then
    echo "   📂 Pi Coding Agent detected."
    # Install extension and instructions to ~/.pi/agent/
    mkdir -p "$HOME/.pi/agent/extensions"
    if [ -f ".pi/extensions/tgd-commands.ts" ]; then
        ln -sf "$(pwd)/.pi/extensions/tgd-commands.ts" "$HOME/.pi/agent/extensions/tgd-commands.ts" 2>/dev/null || true
        echo "   ✅ Extension installed to ~/.pi/agent/extensions/tgd-commands.ts"
    fi
    if [ -f ".pi/instructions.md" ]; then
        ln -sf "$(pwd)/.pi/instructions.md" "$HOME/.pi/agent/instructions.md" 2>/dev/null || true
        echo "   ✅ Instructions installed to ~/.pi/agent/instructions.md"
    fi
else
    echo "   ℹ️  Pi Coding Agent not detected — skip extension install."
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

mkdir -p "$HOME/.config/opencode/skills"
ln -sf "$TGD_DIR/skills/tgd-rules" "$HOME/.config/opencode/skills/tgd-rules" 2>/dev/null && echo "   ✅ OpenCode: ~/.config/opencode/skills/tgd-rules → symlink"

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