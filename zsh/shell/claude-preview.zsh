#!/bin/zsh

# Preview a Claude session JSONL file as readable markdown for fzf
jq -r '
  select(.type == "user" or .type == "assistant") |
  (.message.content |
    if type == "array" then
      (map(
        if .type == "text" then .text
        elif .type == "tool_use" then "*[tool: " + .name + "]*"
        else "" end
      ) | join(""))
    elif type == "string" then .
    else "" end
  ) as $body |
  select($body != "") |
  "## " + (.type | ascii_upcase) + "\n" + $body + "\n"
' "$1" 2>/dev/null | bat --language=markdown --color=always --style=plain
