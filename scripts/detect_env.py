"""
Environment detection for Agentic PDLC Workflow.

Detects whether running in external (GitHub) or internal (GitLab) environment.

Priority:
1. AGENTIC_ENV environment variable (explicit override)
2. Internal service reachability (auto-detect)
3. Default to 'external'
"""

import os
import socket
from typing import Optional


# Internal services to probe (host, port)
# Customize these for your company network
INTERNAL_SERVICES = [
    ("jira.company.com", 443),
    ("gitlab.company.com", 443),
    ("wiki.company.com", 443),
]

CONNECT_TIMEOUT = 2  # seconds


def detect_environment() -> str:
    """
    Detect current environment.

    Returns:
        'internal' or 'external'
    """
    # Priority 1: Environment variable
    env = os.getenv("AGENTIC_ENV")
    if env in ("internal", "external"):
        return env

    # Priority 2: Probe internal services
    for host, port in INTERNAL_SERVICES:
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(CONNECT_TIMEOUT)
            result = sock.connect_ex((host, port))
            sock.close()
            if result == 0:
                return "internal"
        except Exception:
            continue

    # Priority 3: Default
    return "external"


def get_config_dir() -> str:
    """Return the config directory for current environment."""
    env = detect_environment()
    return f"{env}"


def load_config(service: str) -> dict:
    """
    Load config for a service from the appropriate directory.

    Args:
        service: Service name (jira, wiki, github, gitlab)

    Returns:
        Config dict (empty if not found)
    """
    import yaml

    env = detect_environment()
    config_path = f"{env}/{service}/config.yaml"

    try:
        with open(config_path, "r") as f:
            return yaml.safe_load(f) or {}
    except FileNotFoundError:
        return {}


if __name__ == "__main__":
    env = detect_environment()
    print(f"Detected environment: {env}")
