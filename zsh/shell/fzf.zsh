#!/bin/zsh

export FZF_DEFAULT_OPTS='
  --bind=ctrl-n:down
  --bind=ctrl-p:up
  --bind=tab:toggle
  --bind=enter:accept
  --multi
'

zstyle ':fzf-tab:*' fzf-flags '--multi'
zstyle ':fzf-tab:*' fzf-bindings ctrl-n:down ctrl-p:up tab:toggle enter:accept
zstyle ':fzf-tab:*' continuous-trigger '/'

# FZF
NVIM="$HOME/.local/bin/nvim-macos/bin/nvim"
FZF_RELOAD='reload:rg --vimgrep --color=always --smart-case {q} || :'
FZF_RELOAD_ALL='reload:rg --vimgrep --color=always --smart-case --no-ignore --hidden {q} || :'
FZF_OPENER="[ \$FZF_SELECT_COUNT -eq 0 ] && $NVIM {1} +{2} || $NVIM +cw -q {+f}"
FZF_COPIER='echo {} | pbcopy'
FZF_FILE_WRITER='printf "%s\n" {+} > /tmp/fzf-quickfix'
FZF_NEOVIM_QUICKFIX_OPENER="$NVIM -c \"cfile /tmp/fzf-quickfix\" -c \"copen\""
FZF_FILE_WRITER_FILES="printf '%s\n' {+} | sed 's|$|:1:from_fzf|' > /tmp/fzf-quickfix-files"
FZF_NEOVIM_QUICKFIX_OPENER_FILES="$NVIM -c \"cfile /tmp/fzf-quickfix-files\" -c \"copen\""

# Recent directories: https://junegunn.github.io/fzf/examples/directory-navigation/
. /opt/homebrew/etc/profile.d/z.sh
unalias z 2> /dev/null
z() {
  local dir=$(
    _z 2>&1 |
    fzf --height 40% --layout reverse --info inline \
        --nth 2.. --tac --no-sort --query "$*" \
        --bind 'enter:become:echo {2..}'
  )
  if [ -n "$dir" ]; then
    BUFFER="cd \"$dir\""  # Store command in BUFFER
    zle accept-line       # Execute the command
  fi
  zle reset-prompt
}

# ripgrep->fzf->vim [QUERY]
ff() {
  fzf --disabled --ansi --multi \
      --layout reverse \
      --bind "start:$FZF_RELOAD" --bind "change:$FZF_RELOAD" \
      --bind "enter:execute-silent:$FZF_COPIER" \
      --bind "ctrl-e:become:$FZF_OPENER" \
      --bind "ctrl-q:select-all+execute($FZF_FILE_WRITER)+execute($FZF_NEOVIM_QUICKFIX_OPENER)+abort" \
      --bind 'ctrl-o:toggle-all,ctrl-/:toggle-preview' \
      --bind 'esc:abort' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window 'up,~4,+{2}+4/3,<80(down)' \
      --query "$*"
}

f() {
  fd --type f . \
    | fzf --multi \
          --layout reverse \
          --preview 'bat --style=full --color=always --line-range :500 {}' \
          --bind "enter:become:$FZF_OPENER" \
          --bind "ctrl-e:become:$FZF_OPENER" \
          --bind "enter:execute-silent:$FZF_COPIER" \
          --bind "ctrl-q:select-all+execute($FZF_FILE_WRITER_FILES)+execute($FZF_NEOVIM_QUICKFIX_OPENER_FILES)+abort" \
          --bind 'ctrl-o:toggle-all,ctrl-/:toggle-preview' \
          --preview-window 'up,~4,+{2}+4/3,<80(down)'
}

autoload -Uz add-zsh-hook

ch-widget() {
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
    done < <(find "$HOME/.claude/projects" -name "*.jsonl" | sort) \
    | sort -t$'\t' -k2 -r \
    | fzf \
        --delimiter $'\t' \
        --with-nth '2,3' \
        --preview '~/.dotfiles/zsh/shell/claude-preview {4}' \
        --preview-window 'up:60%,wrap' \
        --layout reverse \
        --bind 'ctrl-/:toggle-preview' \
    | cut -f1
  )
  if [[ -n "$session_id" ]]; then
    BUFFER="claude --resume $session_id"
    zle accept-line
  fi
  zle reset-prompt
}

FZF_RELOAD_ALL='reload:rg --vimgrep --color=always --smart-case --no-ignore --hidden {q} || :'

ffa() {
  fzf --disabled --ansi --multi \
      --layout reverse \
      --bind "start:$FZF_RELOAD_ALL" --bind "change:$FZF_RELOAD_ALL" \
      --bind "enter:execute-silent:$FZF_COPIER" \
      --bind "ctrl-e:become:$FZF_OPENER" \
      --bind "ctrl-q:select-all+execute($FZF_FILE_WRITER)+execute($FZF_NEOVIM_QUICKFIX_OPENER)+abort" \
      --bind 'ctrl-o:toggle-all,ctrl-/:toggle-preview' \
      --bind 'esc:abort' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window 'up,~4,+{2}+4/3,<80(down)' \
      --query "$*"
}

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

  zle -N ch-widget
  bindkey -r '^H'
  bindkey '^H' ch-widget

  zle -N ffa-widget ffa
  bindkey -r '^G'
  bindkey '^G' ffa-widget
}

add-zsh-hook -d precmd bind_keys
add-zsh-hook precmd bind_keys
