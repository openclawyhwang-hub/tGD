import os
import argparse
import requests
from requests.auth import HTTPBasicAuth

JIRA_URL = os.environ.get("JIRA_URL")
JIRA_USER = os.environ.get("JIRA_USER")
JIRA_API_TOKEN = os.environ.get("JIRA_API_TOKEN")

def transition_ticket(ticket_id, transition_name):
    url = f"{JIRA_URL}/rest/api/2/issue/{ticket_id}/transitions"
    auth = HTTPBasicAuth(JIRA_USER, JIRA_API_TOKEN)
    
    res = requests.get(url, headers={"Accept": "application/json"}, auth=auth)
    transitions = res.json().get("transitions", [])
    t_id = next((t["id"] for t in transitions if t["name"].lower() == transition_name.lower()), None)
    
    if t_id:
        requests.post(url, json={"transition": {"id": t_id}}, auth=auth)
        print(f"✅ {ticket_id} 狀態已更新為 {transition_name}")
    else:
        print(f"❌ 找不到狀態: {transition_name}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ticket", required=True)
    parser.add_argument("--status", required=True)
    args = parser.parse_args()
    transition_ticket(args.ticket, args.status)
