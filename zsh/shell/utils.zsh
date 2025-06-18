#!/bin/zsh
alias dkk="cd ~/Desktop"
alias mr="mise run"

uuid() {
  local uuid=$(uuidgen | tr '[:upper:]' '[:lower:]')
  echo -n $uuid | pbcopy
  echo "UUID (copied to clipboard): $uuid"
}

iso () {
  date -u +"%Y-%m-%dT%H:%M:%SZ" | tr -d '\n' | pbcopy
}

filter() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: filter <input_file> <patterns_file>"
    echo ""
    echo "Filters lines from <input_file>, removing those that contain any pattern in <patterns_file>."
    echo ""
    echo "Arguments:"
    echo "  input_file      File to be filtered"
    echo "  patterns_file   File containing patterns to exclude (one per line or substrings)"
    return 0
  fi

  if [[ $# -ne 2 ]]; then
    echo "Error: Exactly two arguments required." >&2
    echo "Run 'filter --help' for usage." >&2
    return 1
  fi

  local input_file="$1"
  local patterns_file="$2"

  if [[ ! -f "$input_file" ]]; then
    echo "Error: Input file '$input_file' does not exist or is not a file." >&2
    return 1
  fi

  if [[ ! -f "$patterns_file" ]]; then
    echo "Error: Patterns file '$patterns_file' does not exist or is not a file." >&2
    return 1
  fi

  grep -Fvf "$patterns_file" "$input_file"
}
