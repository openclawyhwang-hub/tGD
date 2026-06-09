#!/bin/bash
# Create a GitHub release for tGD
# Usage: bash scripts/release.sh [version]
# If version not provided, reads from .tgd-version

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$REPO_ROOT"

# Check for help flag
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "Usage: $0 [version]"
    echo ""
    echo "Create a GitHub release for tGD."
    echo ""
    echo "If version is not provided, uses today's date (CalVer)."
    echo "Syncs both .tgd-version and setup.sh TGD_VERSION."
    echo ""
    echo "Examples:"
    echo "  $0          # Release as vYYYY.MM.DD (today)"
    echo "  $0 v2026.06.09   # Release for specific version"
    exit 0
fi

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is required but not installed."
    echo "   Install: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI."
    echo "   Run: gh auth login"
    exit 1
fi

# Get version — default to today's date (CalVer)
if [ -n "$1" ]; then
    VERSION="$1"
else
    VERSION="v$(date +%Y.%m.%d)"
fi

# Ensure version starts with 'v'
if [[ ! "$VERSION" =~ ^v ]]; then
    VERSION="v$VERSION"
fi

# Derive date format for setup.sh (e.g. v2026.06.09 → 2026-06-09)
SETUP_DATE=$(echo "$VERSION" | sed 's/^v//' | tr '.' '-')

# Sync .tgd-version
echo "$VERSION" > .tgd-version
echo "📝 Updated .tgd-version → $VERSION"

# Sync setup.sh TGD_VERSION
if grep -q '^TGD_VERSION=' setup.sh; then
    sed -i '' "s/^TGD_VERSION=\"[^\"]*\"/TGD_VERSION=\"$SETUP_DATE\"/" setup.sh
    echo "📝 Updated setup.sh TGD_VERSION → $SETUP_DATE"
fi

echo "🚀 Creating release for $VERSION"
echo ""

# Check if tag already exists
if git rev-parse "$VERSION" &> /dev/null; then
    echo "⚠️  Tag $VERSION already exists."
    read -p "   Delete and recreate? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git tag -d "$VERSION"
        git push origin ":refs/tags/$VERSION" 2>/dev/null || true
    else
        echo "   Aborted."
        exit 1
    fi
fi

# Generate changelog from git log
echo "📝 Generating changelog..."
PREV_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

if [ -n "$PREV_TAG" ]; then
    CHANGELOG=$(git log --pretty=format:"- %s (%h)" "$PREV_TAG"..HEAD)
    RANGE="$PREV_TAG..HEAD"
else
    CHANGELOG=$(git log --pretty=format:"- %s (%h)" -20)
    RANGE="last 20 commits"
fi

if [ -z "$CHANGELOG" ]; then
    CHANGELOG="- No changes recorded"
fi

# Create release notes file
RELEASE_NOTES=$(cat <<EOF
## tGD $VERSION

### Changes
$CHANGELOG

---
**Full Changelog**: https://github.com/openclawyhwang-hub/tGD/compare/${PREV_TAG:-$VERSION}...$VERSION
EOF
)

echo ""
echo "📋 Release notes:"
echo "---"
echo "$RELEASE_NOTES"
echo "---"
echo ""

# Confirm
read -p "Create tag and release? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Create and push tag
echo "🏷️  Creating tag $VERSION..."
git tag -a "$VERSION" -m "Release $VERSION" || git tag "$VERSION"
git push origin "$VERSION"

# Create GitHub release
echo "📦 Creating GitHub release..."
gh release create "$VERSION" \
    --title "tGD $VERSION" \
    --notes "$RELEASE_NOTES" \
    --latest

echo ""
echo "✅ Release $VERSION created successfully!"
echo "   View: https://github.com/openclawyhwang-hub/tGD/releases/tag/$VERSION"
