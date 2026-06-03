#!/bin/bash
# tGD (tGD) One-Click Installer
# Usage: bash setup.sh [--upgrade|--uninstall|--version]
#
# --upgrade:  先掃描並清除舊版殘留的 stale symlink / hooks，再重新部署。
#             適合 tGD-clone git pull 後執行，確保乾淨無殘留。
# --uninstall: 徹底移除所有 tGD 部署（symlinks、hooks、版本標記）。
#             適合不想再用 tGD 或要乾淨重裝的使用者。

set -e

MODE="install"
if [[ "$1" == "--upgrade" || "$1" == "-u" ]]; then
    MODE="upgrade"
elif [[ "$1" == "--uninstall" || "$1" == "--remove" ]]; then
    MODE="uninstall"
elif [[ "$1" == "--version" || "$1" == "-v" ]]; then
    TGD_DIR="$(cd "$(dirname "$0")" && pwd)"
    VERSION=$(cd "$TGD_DIR" && git describe --tags --always 2>/dev/null || echo "unknown")
    echo "tGD $VERSION"
    exit 0
fi

TGD_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── Uninstall mode ──────────────────────────────────────────────────────────
if [[ "$MODE" == "uninstall" ]]; then
    echo "🗑️  tGD Uninstall — Removing all deployments..."
    echo "====================================="
    echo ""

    # Helper: remove tGD-prefixed symlinks/files from a directory
    remove_tgd_items() {
        local dir="$1"
        local label="$2"
        local pattern="${3:-tgd}"
        if [[ -d "$dir" ]]; then
            for item in "$dir"/*; do
                local base=$(basename "$item")
                if [[ "$base" == *"$pattern"* ]] && [[ -L "$item" || -f "$item" ]]; then
                    echo "   🗑️  Removing $label: $item"
                    rm -f "$item"
                fi
            done
        fi
    }

    # 1. Remove all tGD symlinks
    echo "🧹 Removing tGD symlinks..."
    remove_tgd_items "$HOME/.claude/skills" "Claude skill" "tgd"
    remove_tgd_items "$HOME/.claude/commands" "Claude command" "tgd"
    remove_tgd_items "$HOME/.gemini/commands" "Gemini command" "tgd"
    remove_tgd_items "$HOME/.config/opencode/commands" "OpenCode command" "tgd"
    remove_tgd_items "$HOME/.codex/prompts" "Codex prompt" "tgd"
    remove_tgd_items "$HOME/.codex/skills" "Codex skill" "tgd"
    remove_tgd_items "$HOME/.config/opencode/skills" "OpenCode skill" "tgd"
    remove_tgd_items "$HOME/.gemini/skills" "Gemini skill" "tgd"
    remove_tgd_items "$HOME/.pi/agent/skills" "Pi skill" "tgd"
    remove_tgd_items "$HOME/.pi/agent/extensions" "Pi extension" "tgd"
    remove_tgd_items "$HOME/.claude/rules" "Claude rule" "tgd"

    # Remove Codex top-level skills/tGD symlink
    if [[ -L "$HOME/.codex/skills/tGD" ]]; then
        echo "   🗑️  Removing Codex skills/tGD: $HOME/.codex/skills/tGD"
        rm -f "$HOME/.codex/skills/tGD"
    fi

    # Remove Pi instructions
    if [[ -L "$HOME/.pi/agent/instructions.md" ]]; then
        echo "   🗑️  Removing Pi instructions: $HOME/.pi/agent/instructions.md"
        rm -f "$HOME/.pi/agent/instructions.md"
    fi

    # 2. Remove tGD hooks from settings files
    echo ""
    echo "🧹 Removing tGD hooks from config files..."

    # Claude Code: ~/.claude/settings.json
    if [[ -f "$HOME/.claude/settings.json" ]]; then
        python3 << 'PYEOF'
import json, os

path = os.path.expanduser("~/.claude/settings.json")
with open(path) as f:
    data = json.load(f)

def is_tgd_hook(obj):
    """Check if a hook object is a tGD hook (contains /hooks/ or /tGD in command path)."""
    cmd = obj.get("command", "")
    return "/hooks/" in cmd or "/tGD" in cmd

def filter_hooks_deep(items):
    """Recursively filter hooks at any nesting depth. Returns (kept, removed_count)."""
    kept = []
    removed = 0
    for item in items:
        sub = item.get("hooks", [])
        if sub and all(isinstance(s, dict) and "command" in s for s in sub):
            # Flat hooks array (Claude format)
            non_tgd = [s for s in sub if not is_tgd_hook(s)]
            removed += len(sub) - len(non_tgd)
            if non_tgd:
                item["hooks"] = non_tgd
                kept.append(item)
        elif sub:
            # Nested hooks (Gemini format) - recurse
            kept_sub, r = filter_hooks_deep(sub)
            removed += r
            if kept_sub:
                item["hooks"] = kept_sub
                kept.append(item)
        else:
            # No hooks array, check this item itself
            if not is_tgd_hook(item):
                kept.append(item)
            else:
                removed += 1
    return kept, removed

hooks = data.get("hooks", {})
total_removed = 0

for event in list(hooks.keys()):
    entries = hooks[event]
    kept, r = filter_hooks_deep(entries)
    total_removed += r
    if kept:
        hooks[event] = kept
    else:
        hooks.pop(event, None)

with open(path, "w") as f:
    json.dump(data, f, indent=2)
print(f"   ✅ Removed {total_removed} tGD hooks from ~/.claude/settings.json (user hooks preserved)")
PYEOF
    fi

    # Codex CLI: ~/.codex/hooks.json (tGD owns this file entirely)
    if [[ -f "$HOME/.codex/hooks.json" ]]; then
        echo "   🗑️  Removing ~/.codex/hooks.json"
        rm -f "$HOME/.codex/hooks.json"
    fi

    # Gemini CLI: ~/.gemini/settings.json
    if [[ -f "$HOME/.gemini/settings.json" ]]; then
        python3 << 'PYEOF'
import json, os

path = os.path.expanduser("~/.gemini/settings.json")
with open(path) as f:
    data = json.load(f)

def is_tgd_hook(obj):
    cmd = obj.get("command", "")
    return "/hooks/" in cmd or "/tGD" in cmd

def filter_hooks_deep(items):
    kept = []
    removed = 0
    for item in items:
        sub = item.get("hooks", [])
        if sub and all(isinstance(s, dict) and "command" in s for s in sub):
            non_tgd = [s for s in sub if not is_tgd_hook(s)]
            removed += len(sub) - len(non_tgd)
            if non_tgd:
                item["hooks"] = non_tgd
                kept.append(item)
        elif sub:
            kept_sub, r = filter_hooks_deep(sub)
            removed += r
            if kept_sub:
                item["hooks"] = kept_sub
                kept.append(item)
        else:
            if not is_tgd_hook(item):
                kept.append(item)
            else:
                removed += 1
    return kept, removed

hooks = data.get("hooks", {})
total_removed = 0

for event in list(hooks.keys()):
    entries = hooks[event]
    kept, r = filter_hooks_deep(entries)
    total_removed += r
    if kept:
        hooks[event] = kept
    else:
        hooks.pop(event, None)

with open(path, "w") as f:
    json.dump(data, f, indent=2)
print(f"   ✅ Removed {total_removed} tGD hooks from ~/.gemini/settings.json (user hooks preserved)")
PYEOF
    fi

    # 3. Remove Understand-Anything links
    for dir in "$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.config/opencode/skills" "$HOME/.gemini/skills" "$HOME/.pi/agent/skills"; do
        if [[ -d "$dir" ]]; then
            for link in "$dir"/understand*; do
                if [[ -L "$link" ]] && readlink "$link" 2>/dev/null | grep -q "understand-anything"; then
                    echo "   🗑️  Removing UA link: $link"
                    rm -f "$link"
                fi
            done
        fi
    done

    # 4. Remove tgd CLI
    for bin_path in "/usr/local/bin/tgd" "$HOME/.local/bin/tgd"; do
        if [[ -L "$bin_path" ]] && readlink "$bin_path" 2>/dev/null | grep -q "tGD"; then
            echo "   🗑️  Removing tgd CLI: $bin_path"
            rm -f "$bin_path"
        fi
    done

    # 4. Remove version marker
    if [[ -f "$TGD_DIR/.tgd-version" ]]; then
        echo "   🗑️  Removing version marker: $TGD_DIR/.tgd-version"
        rm -f "$TGD_DIR/.tgd-version"
    fi

    echo ""
    echo "===================================="
    echo "✅ tGD Uninstalled!"
    echo ""
    echo "The following were removed:"
    echo "  • All tGD symlinks (skills, commands, prompts, rules, extensions)"
    echo "  • All tGD hooks from config files"
    echo "  • tgd CLI binary"
    echo "  • Version marker (.tgd-version)"
    echo ""
    echo "Your ~/.claude/skills/ (and other dirs) are untouched — only tGD items were removed."
    exit 0
fi

if [[ "$MODE" == "upgrade" ]]; then
    echo "🔄 tGD Upgrade — Cleaning stale deployments..."
    echo "====================================="
    echo ""
else
    echo "🚀 tGD (tGD) Setup"
    echo "===================================="
fi

# ─── Version marker ──────────────────────────────────────────────────────────
# Version is derived from git tags (semver). To bump: git tag v1.4.0
TGD_VERSION=$(cd "$TGD_DIR" && git describe --tags --always 2>/dev/null || echo "unknown")
VERSION_FILE="$TGD_DIR/.tgd-version"

if [[ "$MODE" == "install" ]] && [[ -f "$VERSION_FILE" ]]; then
    INSTALLED_VERSION=$(cat "$VERSION_FILE" 2>/dev/null || echo "unknown")
    if [[ "$INSTALLED_VERSION" == "$TGD_VERSION" ]]; then
        echo "ℹ️  tGD ${TGD_VERSION} already installed — refreshing..."
        MODE="upgrade"
    else
        echo "🔄 New version available: ${INSTALLED_VERSION} → ${TGD_VERSION}"
        MODE="upgrade"
    fi
fi

# Write current version marker
echo "$TGD_VERSION" > "$VERSION_FILE"

# ─── Upgrade mode: purge stale symlinks ──────────────────────────────────────
purge_stale_symlinks() {
    local dir="$1"
    local prefix="$2"
    echo "   🧹 Cleaning stale $prefix symlinks in $dir..."
    if [[ -d "$dir" ]]; then
        for link in "$dir"/*; do
            if [[ -L "$link" ]] && [[ ! -e "$link" ]]; then
                echo "      🗑️  Removing broken symlink: $link"
                rm -f "$link"
            fi
        done
    fi
}

purge_stale_skills() {
    local target_dir="$1"
    local label="$2"
    if [[ -d "$target_dir" ]]; then
        for link in "$target_dir"/*/; do
            link="${link%/}"
            if [[ -L "$link" ]]; then
                local resolved=$(readlink -f "$link" 2>/dev/null || echo "")
                if [[ -z "$resolved" ]] || [[ ! -e "$resolved" ]]; then
                    echo "      🗑️  Removing stale skill: $link → $resolved"
                    rm -f "$link"
                fi
            fi
        done
    fi
}

if [[ "$MODE" == "upgrade" ]]; then
    echo "🧹 Purging stale symlinks from previous version..."
    purge_stale_symlinks "$HOME/.claude/skills" "Claude Code skills"
    purge_stale_symlinks "$HOME/.claude/commands" "Claude Code commands"
    purge_stale_symlinks "$HOME/.gemini/commands" "Gemini CLI commands"
    purge_stale_symlinks "$HOME/.config/opencode/commands" "OpenCode commands"
    purge_stale_symlinks "$HOME/.codex/prompts" "Codex CLI prompts"
    purge_stale_symlinks "$HOME/.codex/skills" "Codex CLI skills"
    purge_stale_symlinks "$HOME/.config/opencode/skills" "OpenCode skills"
    purge_stale_symlinks "$HOME/.gemini/skills" "Gemini CLI skills"
    purge_stale_symlinks "$HOME/.pi/agent/skills" "Pi skills"
    purge_stale_symlinks "$HOME/.pi/agent/extensions" "Pi extensions"
    purge_stale_skills "$HOME/.claude/rules" "Claude Code rules"
    echo ""
fi

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
    for cmd in "$TGD_DIR"/.opencode/commands/*.md; do
        cmd_name=$(basename "$cmd")
        ln -sf "$cmd" ~/.config/opencode/commands/$cmd_name 2>/dev/null || true
    done
    echo "   ✅ Commands linked (8 tgd-* commands)."
    # Install plugins (hooks)
    if [ -d "$TGD_DIR/.opencode/plugins" ]; then
        mkdir -p ~/.config/opencode/plugins
        ln -sf "$TGD_DIR/.opencode/plugins"/* ~/.config/opencode/plugins/ 2>/dev/null || true
        echo "   ✅ Plugins installed (session-start)."
    fi
fi

# Claude Code
if command -v claude &> /dev/null; then
    echo "   📂 Claude Code detected."
    if [ -d "$TGD_DIR/.claude" ]; then
        # Link skills
        mkdir -p ~/.claude/skills
        for skill in "$TGD_DIR"/skills/*/; do
            skill_name=$(basename "$skill")
            # Remove real directories (from old copy-installs) before re-linking
            if [ -d "$HOME/.claude/skills/$skill_name" ] && [ ! -L "$HOME/.claude/skills/$skill_name" ]; then
                rm -rf "$HOME/.claude/skills/$skill_name"
            fi
            ln -sf "$skill" ~/.claude/skills/$skill_name 2>/dev/null || true
        done
        echo "   ✅ Skills linked."

        # Link commands (slash commands: /tgd-map, /tgd-develop, etc.)
        if [ -d "$TGD_DIR/.claude/commands" ]; then
            mkdir -p ~/.claude/commands
            ln -sf "$TGD_DIR/.claude/commands"/* ~/.claude/commands/ 2>/dev/null || true
            echo "   ✅ Commands linked (8 tgd-* slash commands)."
        fi

        # Install hooks into settings.json (resolve paths to absolute)
        if [ -d "$TGD_DIR/hooks" ] && [ -f "$TGD_DIR/hooks/hooks.json" ]; then
            mkdir -p ~/.claude
            TGD_ABS="$TGD_DIR"
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
    if [ -d "$TGD_DIR/.gemini" ]; then
        mkdir -p ~/.gemini/commands
        ln -sf "$TGD_DIR/.gemini/commands"/* ~/.gemini/commands/ 2>/dev/null || true
        echo "   ✅ Commands linked."
    fi
    # Install hooks (Gemini uses flat format, different from Claude Code/Codex nested format)
    if [ -f "$TGD_DIR/.gemini/settings.json" ]; then
        mkdir -p ~/.gemini
        TGD_ABS="$TGD_DIR"
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
# Resolve relative paths, ensure type: 'command',
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
            {'matcher': m, 'hooks': hooks}
            for m, hooks in by_matcher.items()
        ]
    else:
        # Lifecycle events (SessionStart, SessionEnd) also need nested format
        # Source may already be nested (has 'hooks' key in items) or flat
        for h in hook_list:
            if 'hooks' in h and isinstance(h['hooks'], list):
                # Already nested — resolve paths in sub-hooks
                for sub in h['hooks']:
                    if 'type' not in sub:
                        sub['type'] = 'command'
                    cmd = sub.get('command', '')
                    if cmd.startswith('bash hooks/'):
                        sub['command'] = cmd.replace('bash hooks/', 'bash ' + TGD_ABS + '/hooks/', 1)
            else:
                # Flat format — wrap and resolve
                if 'type' not in h:
                    h['type'] = 'command'
                cmd = h.get('command', '')
                if cmd.startswith('bash hooks/'):
                    h['command'] = cmd.replace('bash hooks/', 'bash ' + TGD_ABS + '/hooks/', 1)
                h = {'matcher': '*', 'hooks': [h]}
        # Normalize: ensure top-level is list of {matcher, hooks} objects
        normalized = []
        for h in hook_list:
            if 'hooks' in h and isinstance(h['hooks'], list):
                normalized.append(h)
            else:
                normalized.append({'matcher': '*', 'hooks': [h]})
        tgd['hooks'][event] = normalized
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
" 2>&1 || echo "   ⚠️  Merge failed — please manually merge hooks from .gemini/settings.json"
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
    if [ -d "$TGD_DIR/skills" ]; then
        # Remove real directory (from old copy-installs) before re-linking
        if [ -d "$HOME/.codex/skills/tGD" ] && [ ! -L "$HOME/.codex/skills/tGD" ]; then
            rm -rf "$HOME/.codex/skills/tGD"
        fi
        ln -sf "$TGD_DIR/skills" ~/.codex/skills/tGD 2>/dev/null || true
        echo "   ✅ Skills linked for auto-detection."
    fi
    if [ -d "$TGD_DIR/.codex/prompts" ]; then
        mkdir -p ~/.codex/prompts
        ln -sf "$TGD_DIR/.codex/prompts"/* ~/.codex/prompts/ 2>/dev/null || true
        echo "   ✅ Prompts linked (8 tgd-* commands)."
    fi
    # Install hooks (Codex only reads ~/.codex/hooks.json — plugin-local hooks don't work)
    if [ -f "$TGD_DIR/hooks/hooks.json" ]; then
        HOOKS_DST="$HOME/.codex/hooks.json"
        TGD_ABS="$TGD_DIR"
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
    if [ -f "$TGD_DIR/.pi/extensions/tgd-commands.ts" ]; then
        ln -sf "$TGD_DIR/.pi/extensions/tgd-commands.ts" "$HOME/.pi/agent/extensions/tgd-commands.ts" 2>/dev/null || true
        echo "   ✅ Extension installed to ~/.pi/agent/extensions/tgd-commands.ts"
    fi
    if [ -f "$TGD_DIR/.pi/instructions.md" ]; then
        ln -sf "$TGD_DIR/.pi/instructions.md" "$HOME/.pi/agent/instructions.md" 2>/dev/null || true
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
    if command -v npm &> /dev/null; then
        echo "   📥 Installing CodeGraph via npm..."
        npm install -g @colbymchenry/codegraph 2>/dev/null && echo "   ✅ CodeGraph installed." || echo "   ⚠️  Install manually: npm install -g @colbymchenry/codegraph"
    else
        echo "   ⚠️  npm not found. Install CodeGraph manually:"
        echo "      npm install -g @colbymchenry/codegraph"
    fi
fi

# Understand-Anything (bundled as submodule)
echo "🧠 Checking Understand-Anything..."
UA_SKILLS_DIR="$TGD_DIR/vendor/understand-anything/understand-anything-plugin/skills"
if [ -d "$UA_SKILLS_DIR" ]; then
    echo "   ✅ Understand-Anything submodule ready."
else
    echo "   📥 Initializing Understand-Anything submodule..."
    cd "$TGD_DIR" && git submodule update --init vendor/understand-anything 2>/dev/null && echo "   ✅ Submodule initialized." || echo "   ⚠️  Run: git submodule update --init vendor/understand-anything"
fi

# Link Understand-Anything skills to each platform
if [ -d "$UA_SKILLS_DIR" ]; then
    # Claude Code: per-skill symlinks in ~/.claude/skills/
    if [ -d "$HOME/.claude" ] || [ -L "$HOME/.claude" ]; then
        for skill in "$UA_SKILLS_DIR"/*/; do
            skill_name=$(basename "$skill")
            ln -sf "$skill" "$HOME/.claude/skills/understand-$skill_name" 2>/dev/null || true
        done
        echo "   ✅ Claude: Understand-Anything skills linked."
    fi
    # Codex: folder symlink in ~/.codex/skills/
    if [ -d "$HOME/.codex" ] || [ -L "$HOME/.codex" ]; then
        mkdir -p "$HOME/.codex/skills"
        if [ -d "$HOME/.codex/skills/understand-anything" ] && [ ! -L "$HOME/.codex/skills/understand-anything" ]; then
            rm -rf "$HOME/.codex/skills/understand-anything"
        fi
        ln -sf "$UA_SKILLS_DIR" "$HOME/.codex/skills/understand-anything" 2>/dev/null && echo "   ✅ Codex: Understand-Anything skills linked."
    fi
    # OpenCode: folder symlink in ~/.config/opencode/skills/
    if [ -d "$HOME/.config/opencode" ] || [ -L "$HOME/.config/opencode" ]; then
        mkdir -p "$HOME/.config/opencode/skills"
        if [ -d "$HOME/.config/opencode/skills/understand-anything" ] && [ ! -L "$HOME/.config/opencode/skills/understand-anything" ]; then
            rm -rf "$HOME/.config/opencode/skills/understand-anything"
        fi
        ln -sf "$UA_SKILLS_DIR" "$HOME/.config/opencode/skills/understand-anything" 2>/dev/null && echo "   ✅ OpenCode: Understand-Anything skills linked."
    fi
    # Gemini: folder symlink in ~/.gemini/skills/
    if [ -d "$HOME/.gemini" ] || [ -L "$HOME/.gemini" ]; then
        mkdir -p "$HOME/.gemini/skills"
        if [ -d "$HOME/.gemini/skills/understand-anything" ] && [ ! -L "$HOME/.gemini/skills/understand-anything" ]; then
            rm -rf "$HOME/.gemini/skills/understand-anything"
        fi
        ln -sf "$UA_SKILLS_DIR" "$HOME/.gemini/skills/understand-anything" 2>/dev/null && echo "   ✅ Gemini: Understand-Anything skills linked."
    fi
    # Pi: folder symlink in ~/.pi/agent/skills/
    if [ -d "$HOME/.pi" ] || [ -L "$HOME/.pi" ]; then
        mkdir -p "$HOME/.pi/agent/skills"
        if [ -d "$HOME/.pi/agent/skills/understand-anything" ] && [ ! -L "$HOME/.pi/agent/skills/understand-anything" ]; then
            rm -rf "$HOME/.pi/agent/skills/understand-anything"
        fi
        ln -sf "$UA_SKILLS_DIR" "$HOME/.pi/agent/skills/understand-anything" 2>/dev/null && echo "   ✅ Pi: Understand-Anything skills linked."
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
echo "📋 Installing tGD rules (standalone files, no config pollution)..."
echo ""

# Claude Code: ~/.claude/rules/tgd.md (auto-loaded by Claude Code)
mkdir -p "$HOME/.claude/rules"
ln -sf "$TGD_DIR/skills/tgd-rules/SKILL.md" "$HOME/.claude/rules/tgd.md" 2>/dev/null && echo "   ✅ Claude Code: ~/.claude/rules/tgd.md → symlink"

# Codex CLI: ~/.codex/skills/tgd-rules (auto-discovered)
mkdir -p "$HOME/.codex/skills"
if [ -d "$HOME/.codex/skills/tgd-rules" ] && [ ! -L "$HOME/.codex/skills/tgd-rules" ]; then
    rm -rf "$HOME/.codex/skills/tgd-rules"
fi
ln -sf "$TGD_DIR/skills/tgd-rules" "$HOME/.codex/skills/tgd-rules" 2>/dev/null && echo "   ✅ Codex CLI: ~/.codex/skills/tgd-rules → symlink"

mkdir -p "$HOME/.config/opencode/skills"
if [ -d "$HOME/.config/opencode/skills/tgd-rules" ] && [ ! -L "$HOME/.config/opencode/skills/tgd-rules" ]; then
    rm -rf "$HOME/.config/opencode/skills/tgd-rules"
fi
ln -sf "$TGD_DIR/skills/tgd-rules" "$HOME/.config/opencode/skills/tgd-rules" 2>/dev/null && echo "   ✅ OpenCode: ~/.config/opencode/skills/tgd-rules → symlink"

# Gemini CLI: ~/.gemini/skills/tgd-rules
mkdir -p "$HOME/.gemini/skills"
if [ -d "$HOME/.gemini/skills/tgd-rules" ] && [ ! -L "$HOME/.gemini/skills/tgd-rules" ]; then
    rm -rf "$HOME/.gemini/skills/tgd-rules"
fi
ln -sf "$TGD_DIR/skills/tgd-rules" "$HOME/.gemini/skills/tgd-rules" 2>/dev/null && echo "   ✅ Gemini CLI: ~/.gemini/skills/tgd-rules → symlink"

# Pi: ~/.pi/agent/skills/tgd-rules
mkdir -p "$HOME/.pi/agent/skills"
if [ -d "$HOME/.pi/agent/skills/tgd-rules" ] && [ ! -L "$HOME/.pi/agent/skills/tgd-rules" ]; then
    rm -rf "$HOME/.pi/agent/skills/tgd-rules"
fi
ln -sf "$TGD_DIR/skills/tgd-rules" "$HOME/.pi/agent/skills/tgd-rules" 2>/dev/null && echo "   ✅ Pi: ~/.pi/agent/skills/tgd-rules → symlink"

echo ""
echo "===================================="

# ─── Install tgd CLI ────────────────────────────────────────────────────────
TGD_BIN="$TGD_DIR/bin/tgd"
chmod +x "$TGD_BIN"

# Try /usr/local/bin first, fall back to ~/.local/bin
if [[ -w "/usr/local/bin" ]] 2>/dev/null; then
    ln -sf "$TGD_BIN" "/usr/local/bin/tgd" 2>/dev/null && echo "   🔧 tgd CLI → /usr/local/bin/tgd"
else
    mkdir -p "$HOME/.local/bin"
    ln -sf "$TGD_BIN" "$HOME/.local/bin/tgd" && echo "   🔧 tgd CLI → ~/.local/bin/tgd"
    # Ensure ~/.local/bin is in PATH hint
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo "   ⚠️  Add ~/.local/bin to PATH: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
fi

echo "✅ Setup Complete!"
echo ""
echo "tGD is now active in ALL projects."
echo "Just start your agent in any project:"
echo "  claude | codex | opencode | gemini | pi"
echo "Then type '/tgd-map' to initialize."
echo ""