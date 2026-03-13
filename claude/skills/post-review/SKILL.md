---
name: post-review
description: "Phase 2: Post finalized review comments to a GitHub PR"
disable-model-invocation: true
allowed-tools: Bash(gh *)
---

# Post Review (Phase 2 - Submit)

Read the review file. The argument is the PR number.

!`cat /tmp/reviews/$ARGUMENTS.md`

For each feedback point in the review file, post it as a separate review comment on the PR using `gh api`. Each comment should target the specific file and line from the feedback.

Use the GitHub API to post line-level review comments:

```
gh api repos/{owner}/{repo}/pulls/<pr-number>/reviews \
  --method POST \
  -f event="COMMENT" \
  -f body="<overall summary>" \
  -f 'comments[][path]=<file>' \
  -f 'comments[][line]=<line>' \
  -f 'comments[][body]=<feedback>'
```

Do NOT submit/approve the review. Post comments only.

After posting, print a summary of what was posted.
