#!/bin/zsh

# Copilot autocompletion in the shell
eval "$(gh completion -s zsh)"
alias explain="gh copilot explain"

# act
alias act="act --container-architecture linux/amd64"

# AI/LLM
alias claude="claude --dangerously-skip-permissions"
function answer() {
  echo -n "$@" | claude --dangerously-skip-permissions -p --model claude-haiku-4-5-20251001
}
