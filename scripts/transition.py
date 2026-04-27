#!/usr/bin/env python3
"""
Transition a ticket to a new status.

Usage:
    python transition.py --ticket PROJ-123 --status "In Progress"
"""

import argparse
from jira_client import JiraClient


def main():
    parser = argparse.ArgumentParser(description="Transition ticket")
    parser.add_argument("--ticket", required=True, help="Ticket key (e.g., PROJ-123)")
    parser.add_argument("--status", required=True, help="Target status")
    args = parser.parse_args()

    client = JiraClient()
    client.transition_ticket(ticket_id=args.ticket, transition_name=args.status)


if __name__ == "__main__":
    main()
