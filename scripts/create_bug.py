#!/usr/bin/env python3
"""
Create a Bug ticket.

Usage:
    python create_bug.py --title "Test failed" --log "error log here"
"""

import argparse
from jira_client import JiraClient


def main():
    parser = argparse.ArgumentParser(description="Create Bug ticket")
    parser.add_argument("--title", required=True, help="Bug title")
    parser.add_argument("--log", required=True, help="Error log")
    args = parser.parse_args()

    client = JiraClient()
    description = f"自動化驗證失敗。\n\n*Error Log:*\n{{code}}\n{args.log}\n{{code}}"
    client.create_bug(title=args.title, description=description)


if __name__ == "__main__":
    main()
