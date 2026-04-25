import os
import requests
from requests.auth import HTTPBasicAuth

JIRA_URL = os.environ.get("JIRA_URL")
JIRA_USER = os.environ.get("JIRA_USER")
JIRA_API_TOKEN = os.environ.get("JIRA_API_TOKEN")
AI_ASSIGNEE_ID = os.environ.get("JIRA_AI_ACCOUNT_ID")

def fetch_ticket():
    jql = f'assignee="{AI_ASSIGNEE_ID}" AND status="To Do" ORDER BY priority DESC'
    url = f"{JIRA_URL}/rest/api/2/search?jql={jql}&maxResults=1"
    auth = HTTPBasicAuth(JIRA_USER, JIRA_API_TOKEN)
    
    response = requests.get(url, headers={"Accept": "application/json"}, auth=auth)
    if response.status_code == 200 and response.json().get("issues"):
        issue = response.json()["issues"][0]
        print(f"TICKET_ID={issue['key']}")
        print(f"TITLE={issue['fields']['summary']}")
        print(f"AC={issue['fields']['description']}")
    else:
        print("NO_TICKETS_FOUND")

if __name__ == "__main__":
    fetch_ticket()
