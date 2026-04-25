import os
import argparse
import requests
from requests.auth import HTTPBasicAuth
from pathlib import Path

JIRA_URL = os.environ.get("JIRA_URL", "https://your-domain.atlassian.net")
JIRA_USER = os.environ.get("JIRA_USER")
JIRA_API_TOKEN = os.environ.get("JIRA_API_TOKEN")
PROJECT_KEY = os.environ.get("JIRA_PROJECT_KEY", "PROJ")
AI_ASSIGNEE_ID = os.environ.get("JIRA_AI_ACCOUNT_ID")
HUMAN_REVIEWER_ID = os.environ.get("JIRA_HUMAN_REVIEWER_ID")


def upload_attachment(issue_key, file_path):
    """Upload a file as attachment to a Jira issue."""
    url = f"{JIRA_URL}/rest/api/2/issue/{issue_key}/attachments"
    auth = HTTPBasicAuth(JIRA_USER, JIRA_API_TOKEN)
    headers = {"X-Atlassian-Token": "no-check"}

    with open(file_path, "rb") as f:
        files = {"file": (os.path.basename(file_path), f)}
        response = requests.post(url, headers=headers, auth=auth, files=files)

    if response.status_code == 201:
        print(f"  📎 Attached: {os.path.basename(file_path)}")
    else:
        print(f"  ⚠️  Attachment failed: {response.text}")


def create_design_review_ticket(screen_name, figma_url, screenshots, tokens_content, consolidated=False):
    """Create a Jira ticket for design review."""
    url = f"{JIRA_URL}/rest/api/2/issue"
    auth = HTTPBasicAuth(JIRA_USER, JIRA_API_TOKEN)
    headers = {"Accept": "application/json", "Content-Type": "application/json"}

    # Build description
    screenshot_list = "\n".join([f"- 📎 `{os.path.basename(s)}`" for s in screenshots])

    description = f"""h2. Design Review: {screen_name}

h3. Design File
🔗 Figma: {figma_url}

h3. Screenshots
{chr(10).join([f"📎 {os.path.basename(s)}" for s in screenshots])}

h3. Design Tokens
{tokens_content if tokens_content else "_See design file for token definitions_"}

h3. Review Checklist
- [ ] Colors match design tokens
- [ ] Typography hierarchy correct (h1 → h2 → h3 → body)
- [ ] Responsive breakpoints work (320px, 768px, 1024px, 1440px)
- [ ] Shared components consistent across screens
- [ ] Loading, error, and empty states included
- [ ] Keyboard navigation paths clear
- [ ] No "AI aesthetic" patterns (purple gradients, excessive rounding)

h3. Design Decisions
_To be filled by the design agent_
1. **Layout approach:** _explain rationale_
2. **Color system:** _explain rationale_
3. **Typography choices:** _explain rationale_"""

    title = f"Design Review: {screen_name}" if not consolidated else f"Design Review: All Screens"

    payload = {
        "fields": {
            "project": {"key": PROJECT_KEY},
            "summary": title,
            "description": description,
            "issuetype": {"name": "Task"},
            "labels": ["design", "review", "ui"],
            "assignee": {"id": HUMAN_REVIEWER_ID} if HUMAN_REVIEWER_ID else {"id": AI_ASSIGNEE_ID}
        }
    }

    response = requests.post(url, json=payload, headers=headers, auth=auth)
    if response.status_code == 201:
        issue_key = response.json().get("key")
        print(f"✅ Design Review ticket created: {issue_key}")

        # Upload screenshots as attachments
        for screenshot in screenshots:
            if os.path.exists(screenshot):
                upload_attachment(issue_key, screenshot)
            else:
                print(f"  ⚠️  Screenshot not found: {screenshot}")

        return issue_key
    else:
        print(f"❌ Ticket creation failed: {response.text}")
        return None


def main():
    parser = argparse.ArgumentParser(description="Create Jira Design Review ticket")
    parser.add_argument("--screen", help="Screen name (e.g., 'Homepage')")
    parser.add_argument("--figma", required=True, help="Figma file URL")
    parser.add_argument("--screenshot", help="Single screenshot path")
    parser.add_argument("--screenshots-dir", help="Directory containing screenshots")
    parser.add_argument("--tokens", help="Path to design-tokens.md")
    parser.add_argument("--consolidated", action="store_true", help="Create one ticket for all screens")

    args = parser.parse_args()

    # Gather screenshots
    screenshots = []
    if args.screenshot:
        screenshots.append(args.screenshot)
    if args.screenshots_dir:
        dir_path = Path(args.screenshots_dir)
        if dir_path.exists():
            screenshots.extend([str(f) for f in sorted(dir_path.glob("*.png"))])

    # Read tokens content
    tokens_content = None
    if args.tokens and os.path.exists(args.tokens):
        with open(args.tokens) as f:
            tokens_content = f.read()

    # Screen name
    screen_name = args.screen if args.screen else ("All Screens" if args.consolidated else "UI Design")

    # Create ticket
    create_design_review_ticket(
        screen_name=screen_name,
        figma_url=args.figma,
        screenshots=screenshots,
        tokens_content=tokens_content,
        consolidated=args.consolidated
    )


if __name__ == "__main__":
    main()
