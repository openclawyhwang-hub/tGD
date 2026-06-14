#!/usr/bin/env python3
"""
merge-codex-hooks.py — Merge tGD hook sources into ~/.codex/hooks.json.

Reads from two sources (both optional):
  1. $TGD_DIR/hooks/hooks.json         (Claude-style SessionStart — priority:message)
  2. $TGD_DIR/hooks/codex/hooks.json  (Codex-style SessionStart — hookSpecificOutput)

Both are merged into $HOOKS_DST (= ~/.codex/hooks.json), deduping by command string.

Why two sources? Claude and Codex have different SessionStart hook contracts:
  - Claude: stdout JSON {priority, message}
  - Codex:  stdout JSON {hookSpecificOutput: {additionalContext: "..."}}
See: https://github.com/openai/codex/issues/16933

We keep both because some users run both Claude and Codex. The Codex one
takes effect on the Codex-side because its command emits the contract Codex
expects; the Claude one is essentially inert when Codex runs it (Codex
just sees invalid JSON and ignores it).
"""
import json
import os
import sys

TGD_ABS = os.environ.get('TGD_ABS', '')
HOOKS_DST = os.environ.get('HOOKS_DST', '')

if not TGD_ABS or not HOOKS_DST:
    print('   ⚠️  TGD_ABS and HOOKS_DST env vars required', file=sys.stderr)
    sys.exit(1)

SOURCES = [
    os.path.join(TGD_ABS, 'hooks/hooks.json'),
    os.path.join(TGD_ABS, 'hooks/codex/hooks.json'),
]


def resolve(obj) -> None:
    """Replace ${CLAUDE_PLUGIN_ROOT} and ${TGD_DIR} with TGD_ABS in any 'command' field."""
    if isinstance(obj, dict):
        for k, v in list(obj.items()):
            if k == 'command' and isinstance(v, str):
                if '${CLAUDE_PLUGIN_ROOT}' in v:
                    obj[k] = v.replace('${CLAUDE_PLUGIN_ROOT}', TGD_ABS)
                if '${TGD_DIR}' in v:
                    obj[k] = obj[k].replace('${TGD_DIR}', TGD_ABS)
            else:
                resolve(v)
    elif isinstance(obj, list):
        for item in obj:
            resolve(item)


def load_user_hooks() -> dict:
    if os.path.exists(HOOKS_DST):
        with open(HOOKS_DST) as f:
            return json.load(f)
    return {}


def merge_source(user: dict, tgd: dict) -> int:
    """Merge tgd's hooks into user, dedup by command string. Returns added count."""
    resolve(tgd)
    user_hooks = user.setdefault('hooks', {})
    added = 0
    for event, hook_list in tgd.get('hooks', {}).items():
        existing = user_hooks.get(event, [])
        existing_cmds = set()
        for h in existing:
            for sub in h.get('hooks', []):
                existing_cmds.add(sub.get('command', ''))
        for entry in hook_list:
            new_cmds = {sub.get('command', '') for sub in entry.get('hooks', [])}
            if new_cmds & existing_cmds:
                continue
            existing.append(entry)
            added += 1
        user_hooks[event] = existing
    return added


def main() -> int:
    user = load_user_hooks()
    total_added = 0
    for src in SOURCES:
        if not os.path.exists(src):
            continue
        with open(src) as f:
            tgd = json.load(f)
        total_added += merge_source(user, tgd)

    with open(HOOKS_DST, 'w') as f:
        json.dump(user, f, indent=2)
        f.write('\n')

    if os.path.exists(HOOKS_DST) and total_added > 0:
        print(f'   ✅ tGD hooks merged into ~/.codex/hooks.json ({total_added} new).')
    else:
        print('   ✅ tGD hooks installed to ~/.codex/hooks.json.')
    print('   ℹ️  Codex requires hook trust: run /hooks in Codex to trust new hooks.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
