#!/usr/bin/env python3
"""Create a Pull Request / Merge Request across GitHub, GitLab, or Bitbucket.

Reads provider config from `.git-provider.json` in the repo root.
Falls back to `gh` CLI (GitHub) if no config file exists.

Usage:
    python scripts/create_pr.py \
      --title "feat: PROJ-123 implemented AC" \
      --body "Automated PR from jira-auto-worker." \
      --base main \
      --head feature/PROJ-123
"""

import os
import sys
import json
import subprocess
import argparse
import urllib.request
import urllib.error


def load_provider_config(repo_root: str) -> dict:
    """Load .git-provider.json from repo root, or return GitHub default."""
    config_path = os.path.join(repo_root, ".git-provider.json")
    if os.path.exists(config_path):
        with open(config_path, "r") as f:
            return json.load(f)
    return {"provider": "github"}  # default fallback


def get_token(env_name: str) -> str:
    token = os.environ.get(env_name)
    if not token:
        print(f"❌ 缺少環境變數: {env_name}", file=sys.stderr)
        sys.exit(1)
    return token


def create_github_pr(title: str, body: str, base: str, head: str, repo_root: str):
    """Create PR via `gh` CLI (GitHub)."""
    cmd = [
        "gh", "pr", "create",
        "--title", title,
        "--body", body,
        "--base", base,
        "--head", head,
    ]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True, cwd=repo_root)
        url = result.stdout.strip()
        print(f"✅ GitHub PR 已建立: {url}")
        return url
    except subprocess.CalledProcessError as e:
        print(f"❌ gh CLI 失敗: {e.stderr.strip()}", file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print("❌ 找不到 gh CLI。請安裝 GitHub CLI 或改用 API 模式。", file=sys.stderr)
        sys.exit(1)


def create_gitlab_mr(title: str, body: str, base: str, head: str, config: dict, repo_root: str):
    """Create MR via GitLab REST API."""
    api_url = config["api_url"].rstrip("/")
    project_id = config["project_id"]
    token = get_token(config.get("token_env", "GITLAB_TOKEN"))

    url = f"{api_url}/projects/{project_id}/merge_requests"
    payload = {
        "source_branch": head,
        "target_branch": base,
        "title": title,
        "description": body,
        "remove_source_branch": True,
    }
    headers = {
        "PRIVATE-TOKEN": token,
        "Content-Type": "application/json",
    }

    req = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=headers, method="POST")
    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode())
            web_url = data.get("web_url", "")
            print(f"✅ GitLab MR 已建立: {web_url}")
            return web_url
    except urllib.error.HTTPError as e:
        error_body = e.read().decode() if e.fp else ""
        print(f"❌ GitLab API 失敗 ({e.code}): {error_body}", file=sys.stderr)
        sys.exit(1)


def create_bitbucket_pr(title: str, body: str, base: str, head: str, config: dict, repo_root: str):
    """Create PR via Bitbucket REST API."""
    api_url = config["api_url"].rstrip("/")
    workspace = config["workspace"]
    repo_slug = config["repo_slug"]
    token = get_token(config.get("token_env", "BITBUCKET_TOKEN"))

    url = f"{api_url}/repositories/{workspace}/{repo_slug}/pullrequests"
    payload = {
        "title": title,
        "description": body,
        "source": {"branch": {"name": head}},
        "destination": {"branch": {"name": base}},
    }
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }

    req = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=headers, method="POST")
    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode())
            links = data.get("links", {}).get("html", {})
            web_url = links.get("href", "") if isinstance(links, dict) else ""
            print(f"✅ Bitbucket PR 已建立: {web_url}")
            return web_url
    except urllib.error.HTTPError as e:
        error_body = e.read().decode() if e.fp else ""
        print(f"❌ Bitbucket API 失敗 ({e.code}): {error_body}", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="Create a PR/MR across GitHub, GitLab, or Bitbucket.")
    parser.add_argument("--title", required=True, help="PR/MR title")
    parser.add_argument("--body", required=True, help="PR/MR description")
    parser.add_argument("--base", required=True, help="Target branch (e.g. main)")
    parser.add_argument("--head", required=True, help="Source branch (e.g. feature/PROJ-123)")
    args = parser.parse_args()

    # Determine repo root (parent of scripts/)
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    config = load_provider_config(repo_root)
    provider = config.get("provider", "github").lower()

    if provider == "github":
        create_github_pr(args.title, args.body, args.base, args.head, repo_root)
    elif provider == "gitlab":
        create_gitlab_mr(args.title, args.body, args.base, args.head, config, repo_root)
    elif provider == "bitbucket":
        create_bitbucket_pr(args.title, args.body, args.base, args.head, config, repo_root)
    else:
        print(f"❌ 不支援的 provider: {provider}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
