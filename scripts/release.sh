#!/bin/bash
# Create a GitHub release for tGD
# Usage: bash scripts/release.sh [version]
# If version not provided, reads from .tgd-version

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$REPO_ROOT"

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

# Get version
if [ -n "$1" ]; then
    VERSION="$1"
else
    if [ -f ".tgd-version" ]; then
        VERSION=$(cat .tgd-version)
    else
        echo "❌ No version specified and .tgd-version not found."
        echo "   Usage: $0 <version>"
        exit 1
    fi
fi

# Ensure version starts with 'v'
if [[ ! "$VERSION" =~ ^v ]]; then
    VERSION="v$VERSION"
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
