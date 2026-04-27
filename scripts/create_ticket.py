#!/usr/bin/env python3
"""
Create a Jira ticket.

Usage:
    python create_ticket.py --title "My Task" --desc "Do something" --points 3
"""

import argparse
from jira_client import JiraClient


def main():
    parser = argparse.ArgumentParser(description="Create Jira ticket")
    parser.add_argument("--title", required=True, help="Ticket title")
    parser.add_argument("--desc", required=True, help="Ticket description")
    parser.add_argument("--points", type=float, default=None, help="Story points")
    args = parser.parse_args()

    client = JiraClient()
    client.create_ticket(title=args.title, description=args.desc, story_points=args.points)


if __name__ == "__main__":
    main()
