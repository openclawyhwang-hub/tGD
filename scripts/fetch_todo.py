#!/usr/bin/env python3
"""
Fetch next 'To Do' ticket.

Usage:
    python fetch_todo.py [--assignee <account-id>]
"""

import argparse
from jira_client import JiraClient


def main():
    parser = argparse.ArgumentParser(description="Fetch To Do ticket")
    parser.add_argument("--assignee", default=None, help="AI agent assignee ID")
    args = parser.parse_args()

    client = JiraClient()
    client.fetch_todo_ticket(assignee_id=args.assignee)


if __name__ == "__main__":
    main()
