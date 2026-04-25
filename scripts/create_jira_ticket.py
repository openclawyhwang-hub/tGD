import os
import argparse
import requests
from requests.auth import HTTPBasicAuth

JIRA_URL = os.environ.get("JIRA_URL", "https://your-domain.atlassian.net")
JIRA_USER = os.environ.get("JIRA_USER")
JIRA_API_TOKEN = os.environ.get("JIRA_API_TOKEN")
PROJECT_KEY = os.environ.get("JIRA_PROJECT_KEY", "PROJ")

def create_ticket(title, desc, points):
    url = f"{JIRA_URL}/rest/api/2/issue"
    auth = HTTPBasicAuth(JIRA_USER, JIRA_API_TOKEN)
    headers = {"Accept": "application/json", "Content-Type": "application/json"}
    
    payload = {
        "fields": {
            "project": {"key": PROJECT_KEY},
            "summary": title,
            "description": desc,
            "issuetype": {"name": "Task"},
            "customfield_10016": float(points)  # 根據實際 Jira Story Points 欄位 ID 調整
        }
    }
    
    response = requests.post(url, json=payload, headers=headers, auth=auth)
    if response.status_code == 201:
        print(f"✅ 成功建立工單: {response.json().get('key')}")
    else:
        print(f"❌ 開單失敗: {response.text}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--title", required=True)
    parser.add_argument("--desc", required=True)
    parser.add_argument("--points", required=True)
    args = parser.parse_args()
    create_ticket(args.title, args.desc, args.points)
