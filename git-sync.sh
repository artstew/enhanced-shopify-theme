#!/bin/bash

# Safe git sync script
echo "🔄 Starting git sync..."

# Check if there are any changes
if [[ -z $(git status --porcelain) ]]; then
    echo "✅ No changes to commit"
    exit 0
fi

# Stage all changes
echo "📝 Staging changes..."
git add .

# Check if there's anything staged
if [[ -z $(git diff --cached --name-only) ]]; then
    echo "✅ No changes to commit"
    exit 0
fi

# Commit with timestamp
COMMIT_MSG="Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"
if [ "$1" != "" ]; then
    COMMIT_MSG="$1"
fi

echo "💾 Committing: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

# Sync with remote
echo "�� Syncing with GitHub..."
git pull --rebase origin main

if [ $? -ne 0 ]; then
    echo "❌ Rebase failed. Trying merge strategy..."
    git rebase --abort
    git pull origin main
    
    if [ $? -ne 0 ]; then
        echo "❌ Merge failed. Manual intervention needed."
        exit 1
    fi
fi

# Push changes
echo "⬆️ Pushing to GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ Successfully synced with GitHub!"
else
    echo "❌ Push failed. Check for conflicts."
    exit 1
fi
