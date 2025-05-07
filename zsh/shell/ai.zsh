# Copilot autocompletion in the shell
eval "$(gh completion -s zsh)"
alias explain="gh copilot explain"

# act
alias act="act --container-architecture linux/amd64"

# AI/LLM
alias chat="sgpt --repl temp"
function answer() {
  echo -n "$@" | sgpt
}

