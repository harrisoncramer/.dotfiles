#!/bin/zsh

# FZF File and Text Search with Cursor Integration
# Dependencies: fd, bat, rg, fzf, cursor

export FZF_DEFAULT_OPTS='
  --bind=ctrl-n:down
  --bind=ctrl-p:up
  --bind=tab:toggle
  --bind=enter:accept
  --multi
'

zstyle ':fzf-tab:*' fzf-bindings ctrl-n:down ctrl-p:up tab:toggle enter:accept

zstyle ':fzf-tab:*' fzf-flags '--multi'
zstyle ':fzf-tab:*' continuous-trigger '/'

FZF_CURSOR_OPENER='cursor'
FZF_CURSOR_OPENER_LINE='cursor -g {1}:{2}'
FZF_CURSOR_OPENER_MULTI='echo {+} | tr " " "\n" | while IFS=: read -r file line _; do cursor -g "$file:$line"; done'

FZF_COPIER='pbcopy'
FZF_RELOAD='reload:rg --line-number --no-heading --color=always --smart-case {q} || true'

# File finder - opens files in Cursor
f() {
  fd --type f . \
    | fzf --multi \
          --preview 'bat --style=full --color=always --line-range :500 {}' \
          --bind "enter:become:$FZF_CURSOR_OPENER {}" \
          --bind "ctrl-e:become:$FZF_CURSOR_OPENER {}" \
          --bind "enter:execute-silent:$FZF_COPIER" \
          --preview-window '~4,+{2}+4/3,<80(up)'
}

# Text search - opens files at specific line numbers in Cursor
ff() {
  fzf --disabled --ansi --multi \
      --bind "start:$FZF_RELOAD" --bind "change:$FZF_RELOAD" \
      --bind "enter:execute-silent:$FZF_COPIER" \
      --bind "ctrl-e:become:$FZF_CURSOR_OPENER_LINE" \
      --bind 'esc:abort' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
}

autoload -Uz add-zsh-hook

bind_keys() {
  zle -N ff-widget ff
  bindkey -r '^F'
  bindkey '^F' ff-widget

  zle -N search_files f
  bindkey -r '^J'
  bindkey '^J' search_files

  zle -N recent-dirs-widget z
  bindkey -r '^Z'
  bindkey '^Z' recent-dirs-widget
}

add-zsh-hook -d precmd bind_keys
add-zsh-hook precmd bind_keys
