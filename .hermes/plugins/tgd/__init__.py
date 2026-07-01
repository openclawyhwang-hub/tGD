"""
tGD Plugin for Hermes Agent.

Registers 7 lifecycle slash commands (/tgd-map ... /tgd-release) and an
on_session_start hook that injects the tgd-router meta-skill.

Command prompts are sourced from ~/tGD/.claude/commands/*.md — single source
of truth, shared with Claude Code / Codex / OpenCode.
"""

import os
import logging
from pathlib import Path
from typing import Optional

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Path resolution — find the tGD repo root
# ---------------------------------------------------------------------------

def _find_tgd_dir() -> Optional[Path]:
    """Resolve $TGD_DIR or fall back to common locations."""
    # 1. Environment variable
    env = os.environ.get("TGD_DIR")
    if env and Path(env).is_dir():
        return Path(env)

    # 2. Common clone locations
    candidates = [
        Path.home() / "tGD",
        Path.home() / "Projects" / "tGD",
        Path(__file__).resolve().parent.parent.parent.parent,  # .hermes/plugins/tgd/ → repo root (when installed from tGD repo itself)
    ]
    for c in candidates:
        if (c / "skills" / "tgd-router" / "SKILL.md").exists():
            return c

    return None


TGD_DIR = _find_tgd_dir()


def _read_command_prompt(name: str) -> str:
    """Read a command prompt from .claude/commands/<name>.md.

    Falls back to a minimal message if the file is not found.
    """
    if TGD_DIR is None:
        return f"tGD: Cannot locate tGD installation. Set $TGD_DIR or clone to ~/tGD. Command /{name} unavailable."

    # Strip YAML frontmatter (--- ... ---) and return the body
    path = TGD_DIR / ".claude" / "commands" / f"{name}.md"
    if not path.exists():
        return f"tGD: Command file not found: {path}"

    text = path.read_text(encoding="utf-8")
    # Remove YAML frontmatter if present
    if text.startswith("---"):
        end = text.find("---", 3)
        if end != -1:
            text = text[end + 3:].lstrip("\n")

    return text


# ---------------------------------------------------------------------------
# Command handlers
# ---------------------------------------------------------------------------

def _make_handler(cmd_name: str):
    """Create a slash-command handler that returns the prompt text."""
    def handler(raw_args: str = "", **kwargs) -> str:
        del kwargs
        prompt = _read_command_prompt(cmd_name)
        # If user passed args (e.g. "/tgd-develop add login page"), append them
        if raw_args and raw_args.strip():
            prompt += f"\n\n## Additional Context\n\n{raw_args.strip()}"
        return prompt
    handler.__name__ = f"handle_{cmd_name.replace('-', '_')}"
    return handler


# ---------------------------------------------------------------------------
# Session-start hook — inject tgd-router meta-skill
# ---------------------------------------------------------------------------

def _on_session_start(session_id: str = "", **kwargs):
    """Inject tgd-router meta-skill content at session start.

    Equivalent to Claude Code's SessionStart hook (hooks/session-start.sh).
    Uses pre_llm_call-style context injection: returns a string that gets
    appended to the first user message.
    """
    del kwargs  # model, platform, etc.

    if TGD_DIR is None:
        logger.debug("tGD: TGD_DIR not found, skipping session-start injection")
        return None

    meta_skill_path = TGD_DIR / "skills" / "tgd-router" / "SKILL.md"
    if not meta_skill_path.exists():
        logger.debug("tGD: tgd-router SKILL.md not found at %s", meta_skill_path)
        return None

    content = meta_skill_path.read_text(encoding="utf-8")
    return {
        "context": (
            "tGD loaded. Use the skill discovery flowchart to find the right "
            "skill for your task.\n\n" + content
        )
    }


# ---------------------------------------------------------------------------
# Plugin registration
# ---------------------------------------------------------------------------

_TGD_COMMANDS = [
    "tgd-map",
    "tgd-define",
    "tgd-plan",
    "tgd-develop",
    "tgd-verify",
    "tgd-review",
    "tgd-release",
]

_COMMAND_DESCRIPTIONS = {
    "tgd-map":     "Map — scan and understand the existing project context",
    "tgd-define":  "Define — create spec, PRD, and acceptance criteria",
    "tgd-plan":    "Plan — break the spec into ordered implementation tasks",
    "tgd-develop": "Develop — implement tasks incrementally with TDD",
    "tgd-verify":  "Verify — run tests and validate completion claims",
    "tgd-review":  "Review — multi-axis code review before merge",
    "tgd-release": "Release — create version tag and changelog",
}


def register(ctx):
    """Register all tGD commands and hooks with Hermes."""
    # Register slash commands
    for cmd in _TGD_COMMANDS:
        ctx.register_command(
            name=cmd,
            handler=_make_handler(cmd),
            description=_COMMAND_DESCRIPTIONS.get(cmd, f"tGD {cmd} command"),
        )
        logger.debug("tGD: registered command /%s", cmd)

    # Register session-start hook for meta-skill injection
    ctx.register_hook("on_session_start", _on_session_start)
    logger.debug("tGD: registered on_session_start hook")

    logger.info("tGD plugin registered: %d commands + session-start hook", len(_TGD_COMMANDS))
