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

# Search Claude history with fzf, resume selected session
# Columns: session_id \t timestamp \t first_user_message \t file_path
ch() {
  local history_dir="$HOME/.claude/projects"
  local session_id
  session_id=$(
    while IFS= read -r f; do
      jq -r --arg f "$f" --arg s "$(basename "$f" .jsonl)" '
        select(.type == "user") |
        [ $s,
          (.timestamp // ""),
          (.message.content | if type == "array" then map(select(.type=="text") | .text) | join(" ") else . end),
          $f
        ] | @tsv
      ' "$f" 2>/dev/null
    done < <(find "$history_dir" -name "*.jsonl" | sort) \
    | sort -t$'\t' -k2 -r \
    | fzf \
        --delimiter $'\t' \
        --with-nth '2,3' \
        --preview '~/.dotfiles/zsh/shell/claude-preview.zsh {4}' \
        --preview-window 'up:60%,wrap' \
        --layout reverse \
        --bind 'ctrl-/:toggle-preview' \
        --query "$*" \
    | cut -f1
  )
  [[ -n "$session_id" ]] && claude --resume "$session_id"
}
