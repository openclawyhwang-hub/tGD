import os
import argparse
import requests
from requests.auth import HTTPBasicAuth

JIRA_URL = os.environ.get("JIRA_URL")
JIRA_USER = os.environ.get("JIRA_USER")
JIRA_API_TOKEN = os.environ.get("JIRA_API_TOKEN")
PROJECT_KEY = os.environ.get("JIRA_PROJECT_KEY", "PROJ")

def create_bug(title, log_output):
    url = f"{JIRA_URL}/rest/api/2/issue"
    auth = HTTPBasicAuth(JIRA_USER, JIRA_API_TOKEN)
    description = f"自動化驗證失敗。\n\n*Error Log:*\n{{code}}\n{log_output}\n{{code}}"
    
    payload = {
        "fields": {
            "project": {"key": PROJECT_KEY},
            "summary": f"[Auto-Bug] {title}",
            "description": description,
            "issuetype": {"name": "Bug"}
        }
    }
    requests.post(url, json=payload, headers={"Content-Type": "application/json"}, auth=auth)
    print("🐞 Bug 單已建立，防卡死機制啟動。")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--title", required=True)
    parser.add_argument("--log", required=True)
    args = parser.parse_args()
    create_bug(args.title, args.log)
