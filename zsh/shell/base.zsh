#!/bin/zsh

# These commands run AFTER ZSH finishes
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

# Writing
alias todo="v /Users/harrisoncramer/Library/Mobile\ Documents/iCloud\~ee\~xero\~Paper/Documents/todo.md"

# Activate mise
eval "$(mise activate zsh)"

# Re-source config
alias so="source ~/.zshrc"

# Theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Plugins for oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(fzf-tab fast-syntax-highlighting zsh-autosuggestions git git-open fzf zsh-vi-mode)
source ~/.oh-my-zsh/oh-my-zsh.sh
export ZVM_VI_EDITOR="nvim"

export MANPAGER='~/.local/bin/nvim-macos/bin/nvim +Man!'

# Autosuggest accept (instead of right arrow key)
bindkey '^ ' autosuggest-accept

# Autoexpand aliases with tab
zstyle ':completion:*' completer _expand_alias _complete _ignored

# ZSH vim mode use system clipboaard
function zvm_vi_yank() {
	zvm_yank
	echo -n ${CUTBUFFER} | tr -d '\n' | pbcopy
	zvm_exit_visual_mode
}

export GPG_TTY=$(tty)
