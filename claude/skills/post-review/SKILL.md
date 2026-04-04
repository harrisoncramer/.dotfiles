---
name: post-review
description: "Phase 2: Post finalized review comments to a GitHub PR"
disable-model-invocation: true
allowed-tools: Bash(gh *) Read Glob
---

# Post Review (Phase 2 - Submit)

If an argument was provided, use it as the PR number. Otherwise detect it from the current branch:

```
gh pr view --json number --jq '.number'
```

Read the review file at `/tmp/reviews/<pr-number>.md`.

For each feedback point in the review file, post it as a separate review comment on the PR using `gh api`. Each comment should target the specific file and line from the feedback.

Use the GitHub API to post a PENDING review with line-level comments. Use `-f` for string fields and `-F` for numeric fields (like line numbers). Use `event=PENDING` so the review is NOT submitted:

```
gh api repos/{owner}/{repo}/pulls/<pr-number>/reviews \
  --method POST \
  -f event="PENDING" \
  -f body="<overall summary>" \
  -f 'comments[][path]=<file>' \
  -F 'comments[][line]=<line>' \
  -f 'comments[][body]=<feedback>'
```

The review MUST be created as PENDING so the user can review the comments in GitHub and submit manually.

After posting, print a summary of what was posted.
