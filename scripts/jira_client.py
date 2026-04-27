"""
Jira client for Agentic PDLC Workflow.

Uses Bearer Token authentication. Works with both Jira Cloud and Jira Server.

Usage:
    from jira_client import JiraClient

    client = JiraClient()
    client.create_ticket(title="My Task", description="Do something", points=3)
"""

import os
import sys
import requests
from typing import Optional

# Add parent directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from detect_env import detect_environment, load_config


class JiraClient:
    """Jira client with Bearer Token authentication."""

    def __init__(self, config: Optional[dict] = None):
        """
        Initialize Jira client.

        Args:
            config: Optional config dict. If None, auto-detects environment.
        """
        if config is None:
            config = load_config("jira")

        self.url = config.get("jira", {}).get("url", "")
        self.token = config.get("jira", {}).get("token", "")
        self.project_key = config.get("jira", {}).get("project_key", "")

        # Fallback to environment variables
        self.url = os.getenv("JIRA_URL", self.url)
        self.token = os.getenv("JIRA_TOKEN", self.token)
        self.project_key = os.getenv("JIRA_PROJECT_KEY", self.project_key)

        if not self.url:
            raise ValueError("Jira URL not configured. Set JIRA_URL env var or fill config.yaml")
        if not self.token:
            raise ValueError("Jira token not configured. Set JIRA_TOKEN env var or fill config.yaml")

    def _headers(self) -> dict:
        """Return headers with Bearer Token."""
        return {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.token}",
        }

    def create_ticket(self, title: str, description: str, story_points: Optional[float] = None) -> dict:
        """
        Create a Jira ticket.

        Args:
            title: Ticket summary
            description: Ticket description
            story_points: Optional story points

        Returns:
            Created issue dict
        """
        url = f"{self.url}/rest/api/2/issue"

        payload = {
            "fields": {
                "project": {"key": self.project_key},
                "summary": title,
                "description": description,
                "issuetype": {"name": "Task"},
            }
        }

        if story_points is not None:
            # Adjust customfield_10016 to match your Jira instance
            payload["fields"]["customfield_10016"] = story_points

        response = requests.post(url, json=payload, headers=self._headers())

        if response.status_code == 201:
            key = response.json().get("key", "UNKNOWN")
            print(f"✅ 成功建立工單: {key}")
            return response.json()
        else:
            print(f"❌ 開單失敗: {response.text}")
            response.raise_for_status()

    def create_bug(self, title: str, description: str) -> dict:
        """
        Create a Bug ticket.

        Args:
            title: Bug title
            description: Bug description

        Returns:
            Created issue dict
        """
        url = f"{self.url}/rest/api/2/issue"

        payload = {
            "fields": {
                "project": {"key": self.project_key},
                "summary": f"[Auto-Bug] {title}",
                "description": description,
                "issuetype": {"name": "Bug"},
            }
        }

        response = requests.post(url, json=payload, headers=self._headers())

        if response.status_code == 201:
            key = response.json().get("key", "UNKNOWN")
            print(f"🐞 Bug 單已建立: {key}")
            return response.json()
        else:
            print(f"❌ Bug 單建立失敗: {response.text}")
            response.raise_for_status()

    def fetch_todo_ticket(self, assignee_id: Optional[str] = None) -> Optional[dict]:
        """
        Fetch next 'To Do' ticket assigned to AI agent.

        Args:
            assignee_id: Optional assignee account ID

        Returns:
            Issue dict or None
        """
        jql = 'status="To Do" ORDER BY priority DESC'
        if assignee_id:
            jql = f'assignee="{assignee_id}" AND status="To Do" ORDER BY priority DESC'

        url = f"{self.url}/rest/api/2/search?jql={jql}&maxResults=1"
        response = requests.get(url, headers=self._headers())

        if response.status_code == 200 and response.json().get("issues"):
            issue = response.json()["issues"][0]
            print(f"TICKET_ID={issue['key']}")
            print(f"TITLE={issue['fields']['summary']}")
            print(f"AC={issue['fields']['description']}")
            return issue
        else:
            print("NO_TICKETS_FOUND")
            return None

    def transition_ticket(self, ticket_id: str, transition_name: str) -> bool:
        """
        Transition a ticket to a new status.

        Args:
            ticket_id: Issue key (e.g., PROJ-123)
            transition_name: Target status name (e.g., "In Progress")

        Returns:
            True if successful
        """
        url = f"{self.url}/rest/api/2/issue/{ticket_id}/transitions"

        # Get available transitions
        res = requests.get(url, headers=self._headers())
        transitions = res.json().get("transitions", [])

        # Find matching transition
        t_id = next(
            (t["id"] for t in transitions if t["name"].lower() == transition_name.lower()),
            None,
        )

        if t_id:
            requests.post(url, json={"transition": {"id": t_id}}, headers=self._headers())
            print(f"✅ {ticket_id} 狀態已更新為 {transition_name}")
            return True
        else:
            available = ", ".join(t["name"] for t in transitions)
            print(f"❌ 找不到狀態: {transition_name}. 可用: {available}")
            return False

    def get_ticket(self, ticket_id: str) -> Optional[dict]:
        """
        Get ticket details.

        Args:
            ticket_id: Issue key

        Returns:
            Issue dict or None
        """
        url = f"{self.url}/rest/api/2/issue/{ticket_id}"
        response = requests.get(url, headers=self._headers())

        if response.status_code == 200:
            return response.json()
        else:
            print(f"❌ 取得工單失敗: {response.text}")
            return None


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Jira CLI")
    parser.add_argument("--env", action="store_true", help="Show detected environment")
    args = parser.parse_args()

    if args.env:
        env = detect_environment()
        print(f"Detected environment: {env}")

    client = JiraClient()
    print(f"Jira URL: {client.url}")
    print(f"Project: {client.project_key}")
