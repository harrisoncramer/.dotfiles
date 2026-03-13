#!/bin/bash
set -euo pipefail

PR_NUMBER="${1:?Usage: setup.sh <pr-number>}"
BASE_BRANCH="${2:-staging}"

gh pr view "$PR_NUMBER" --json headRefName,title,body --jq '
  "PR #'"$PR_NUMBER"'\nTitle: " + .title + "\nDescription:\n" + .body + "\nBranch: " + .headRefName
'

HEAD_BRANCH=$(gh pr view "$PR_NUMBER" --json headRefName --jq '.headRefName')

wt switch --create "review-pr-${PR_NUMBER}"

git fetch origin "$BASE_BRANCH" "$HEAD_BRANCH"
git reset --hard "origin/$HEAD_BRANCH"

git fetch origin "$BASE_BRANCH"
MERGE_BASE=$(git merge-base "origin/$BASE_BRANCH" HEAD)

echo ""
echo "=== DIFF ==="
git diff --diff-filter=ADM "$MERGE_BASE"..HEAD -- \
  ':(exclude)*go.mod' \
  ':(exclude)*go.sum' \
  ':(exclude)**/db/models/**' \
  ':(exclude)**/jet/**' \
  ':(exclude)**/*_grpc.pb.go' \
  ':(exclude)**/*_grpc.go' \
  ':(exclude)**/*.sql.go' \
  ':(exclude)**/*.pb.go' \
  ':(exclude)**/*_test.go' \
  ':(exclude)**/*.connect.go' \
  ':(exclude)*yarn.lock'
