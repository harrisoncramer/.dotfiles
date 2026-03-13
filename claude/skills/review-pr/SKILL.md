---
name: review-pr
description: "Phase 1: Generate a PR review file for iteration"
disable-model-invocation: true
allowed-tools: Bash(*)
---

# Review a Pull Request (Phase 1 - Generate)

Run the setup script to create a worktree, pull the PR, and get the diff against the base branch. The first argument is the PR number and the second (optional) argument is the base branch (defaults to staging).

!`bash ~/.claude/skills/review-pr/setup.sh $ARGUMENTS`

Review the diff output above. You are a senior software engineer giving feedback to another engineer. Check for:

- Potential bugs or issues
- Performance considerations
- Maintainability and readability

Do not give feedback for things that already work or are well designed. Your job is specifically to find errors and code smells.

Be precise with your feedback, referencing specific file paths and line numbers. Do not mention theoreticals or potential problems, be grounded in actual problems.

Write feedback in a casual, human tone. Use softeners like "hmm", "I think", "looks like", "not sure but", "might be worth", etc. Avoid sounding robotic or authoritative. You are a colleague, not a linter.

At the top of your review give a summary paragraph of the changes, e.g. "The point of these changes is to refactor the payments service to do X Y and Z. This is achieved by refactoring the service X to do Y. Most of the complexity..."

After completing the review, write a summary file to `/tmp/reviews/<pr-number>.md` explaining what the PR does in broad strokes. It should include a section for all of the above feedback that you have.

Here is an example of a good review file:

```markdown
# PR #482 - Add retry logic to payment processor

## Summary

These changes add retry logic to the payment processing pipeline. The core change is a new `RetryPolicy` struct in the payments service that wraps outbound API calls with exponential backoff. 

Most of the complexity is in `services/payments/retry.go` where the backoff intervals and jitter are calculated. 

The PR also updates the webhook handler to surface retry metadata in responses.

## Feedback

### 1. Unbounded retry loop
File: services/payments/retry.go, line 47

Hmm, I think the for loop retries indefinitely when `maxRetries` is zero. Since that's the default value for an int field, any caller that forgets to set it gets infinite retries. Might be worth validating that `maxRetries > 0` at construction time, or treating zero as "no retries."

### 2. Race condition on shared counter
File: services/payments/retry.go, line 82

Looks like `attemptCount` is incremented without synchronization but `RetryPolicy` is documented as safe for concurrent use. I think multiple goroutines calling `Execute` will race on this field. Probably needs a mutex or atomic increment.

### 3. Error from `ParseDuration` is silently dropped
File: services/payments/config.go, line 31

Not sure if this is intentional, but `ParseDuration` can return an error for malformed config values and the error is assigned to `_`. I think a typo in config would silently fall back to the zero duration, which would collapse all backoff intervals to zero and hammer the downstream API with no delay.
```

Stop here. The user will review the file, iterate with you on feedback points, and then run `/post-review` when ready.
