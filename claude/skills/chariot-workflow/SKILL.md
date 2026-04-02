---
name: chariot-workflow
description: Workflow for doing PR work in the Chariot monorepo. Use when starting new work, creating PRs, switching worktrees, building, testing, or merging branches. Covers worktree lifecycle, mise commands, and commit/PR conventions.
---

# Chariot Development Workflow

All feature work happens in isolated git worktrees managed by `wt` (worktrunk). Never commit directly to main or staging.

## Starting New Work

Create a worktree for the new branch:

```
wt switch --create <branch-name>
```

This automatically runs post-create hooks that:
- Trust mise in the new worktree
- Assign unique ports (so multiple worktrees can run in parallel)
- Symlink shared files (.env, .npmrc, go.work.sum, .claude)
- Build axle plugins and the linter

If you need to return to an existing worktree:

```
wt switch <branch-name>
```

To list all active worktrees:

```
wt list
```

## Setting Up the Environment

After creating a worktree, you may need to:

```bash
mise db:restore          # Restore database from backup (if starting fresh)
mise db:migrate          # Apply pending migrations
mise npm:install         # Install JS/TS dependencies
mise docker:up db        # Start just the database
mise docker:up           # Start all services
```

## Building

```bash
mise npm:build                    # Build all TS/JS packages (required after cross-package changes)
mise go:builder apps/axle         # Build a specific Go service
mise connect:gen                  # Regenerate ConnectRPC code from proto definitions
mise db:gen sqlc                  # Regenerate SQLC code after SQL query changes
mise db:gen sqlc --vet            # Validate SQL queries against the real database schema
```

## Testing

```bash
mise go:test                                      # All Go tests
mise go:test apps/payments                        # One module
mise go:test apps/payments -- -run TestFoo -v     # Specific test, verbose
mise npm:test                                     # All TS/JS tests
mise npm:lint                                     # Lint TS/JS
mise go:lint                                      # Lint Go
```

## Commits

Write clear, human-readable commit messages. Follow conventional commits:

```
feat(payments): add retry logic for outbound transfers
fix(axle): handle nil response from compliance check
refactor(connect): extract shared validation into middleware
```

Keep commits small and focused. Each commit should represent one logical change. Do not bundle unrelated changes.

## Creating Pull Requests

Always use the `gh` CLI. Never create PRs through other means.

```bash
gh pr create --title "feat(payments): add retry logic" --body "$(cat <<'EOF'
## Summary
- Added configurable retry with exponential backoff for outbound payment API calls
- Transient failures are now handled transparently before surfacing to callers

## Test plan
- [ ] Unit tests for retry policy
- [ ] Integration test with simulated transient failure

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

PR conventions:
- Title: short (under 70 chars), conventional commit style
- Body: brief summary bullets, then a test plan checklist
- Do not over-explain. The diff speaks for itself.

## Merging

When work is complete and the PR is approved, merge the worktree back:

```
wt merge main
```

This squashes commits, rebases onto main, fast-forward merges, cleans up docker/ports, and removes the worktree.

To preserve commit history instead of squashing:

```
wt merge --no-squash main
```

To keep the worktree around after merging:

```
wt merge --no-remove main
```

## Subagent Worktrees

When Claude Code spawns subagents in isolated worktrees (via `isolation: "worktree"`), the subagent works on a temporary copy of the repo. If the subagent produces changes:

1. The subagent's result includes the worktree path and branch name
2. From the main worktree, merge the subagent's branch:
   ```
   git merge <subagent-branch>
   ```
3. Or cherry-pick specific commits if you only want part of the work

## Key Mise Commands Reference

| Task | What it does |
|---|---|
| `mise npm:install` | Install all JS/TS dependencies |
| `mise npm:build` | Build all packages via Turbo |
| `mise npm:test` | Run TS/JS tests |
| `mise npm:lint` | Lint TS/JS code |
| `mise go:test [modules] [-- flags]` | Run Go tests |
| `mise go:lint [modules]` | Lint Go code |
| `mise go:builder [apps]` | Build Go binaries |
| `mise db:migrate` | Apply database migrations |
| `mise db:migrate --create` | Create a new migration |
| `mise db:restore` | Restore database from backup |
| `mise db:gen sqlc` | Generate Go code from SQL queries |
| `mise db:gen sqlc --vet` | Validate SQL queries against schema |
| `mise db:seed <type> <roles>` | Seed database (e.g., `mise db:seed river bank clerk`) |
| `mise connect:gen` | Generate ConnectRPC code from protos |
| `mise connect:lint` | Lint proto definitions |
| `mise docker:up [services]` | Start Docker services |
| `mise docker:down [services]` | Stop Docker services |
| `mise docker:restart [services]` | Restart services (`--hard` to rebuild) |
| `mise env:sync` | Sync secrets from 1Password |
| `mise axle:scaffold` | Scaffold new Axle endpoints |
