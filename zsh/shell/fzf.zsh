# Fixes conflicts between fzf and zsh-vi-mode
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

# FZF
FZF_RELOAD='reload:rg --column --color=always --smart-case {q} || :'
FZF_OPENER='[ $FZF_SELECT_COUNT -eq 0 ] && /Users/harrisoncramer/.local/bin/nvim-macos/bin/nvim {1} +{2} || /Users/harrisoncramer/.local/bin/nvim-macos/bin/nvim +cw -q {+f}'
FZF_FILE_WRITER='printf "%s\n" {+} > /tmp/fzf-quickfix'
FZF_NEOVIM_QUICKFIX_OPENER='~/.local/bin/nvim-macos/bin/nvim -c "cfile /tmp/fzf-quickfix" -c "copen"'

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
      --bind "start:$FZF_RELOAD" --bind "change:$FZF_RELOAD" \
      --bind "enter:become:$FZF_OPENER" \
      --bind "ctrl-e:execute:$FZF_OPENER" \
      --bind "ctrl-q:select-all+execute($FZF_FILE_WRITER)+execute($FZF_NEOVIM_QUICKFIX_OPENER)+abort" \
      --bind 'ctrl-o:toggle-all,ctrl-/:toggle-preview' \
      --bind 'esc:abort' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
}

f() {
  find . -type f | fzf --preview 'bat --style=full --color=always --line-range :500 {}' \
       --bind "enter:become:$FZF_OPENER" \
       --bind "ctrl-e:execute:$FZF_OPENER" \
       --bind "ctrl-l:execute-silent(printf '%s\n' {+} > /tmp/fzf-selected-files)" \
       --preview-window '~4,+{2}+4/3,<80(up)' 
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
