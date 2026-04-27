"""
Config loader for Agentic PDLC Workflow.

Usage:
    from load_config import load_service_config

    config = load_service_config("jira")
    print(config["jira"]["url"])
"""

import os
import yaml

from detect_env import detect_environment


def load_service_config(service: str) -> dict:
    """
    Load config for a service based on current environment.

    Args:
        service: Service name (jira, wiki, github, gitlab)

    Returns:
        Config dict (empty if not found)
    """
    env = detect_environment()
    config_path = f"{env}/{service}/config.yaml"

    try:
        with open(config_path, "r") as f:
            config = yaml.safe_load(f) or {}
            return config
    except FileNotFoundError:
        print(f"Warning: Config not found at {config_path}")
        return {}


def get_service_url(service: str) -> Optional[str]:
    """Get the URL for a service."""
    config = load_service_config(service)
    return config.get(service, {}).get("url")


def get_service_token(service: str) -> Optional[str]:
    """Get the token for a service (from config or env var)."""
    config = load_service_config(service)
    token = config.get(service, {}).get("token") or config.get(service, {}).get("api_token")

    # Fallback to environment variable
    if not token:
        env_var = f"{service.upper()}_TOKEN"
        token = os.getenv(env_var)

    return token
