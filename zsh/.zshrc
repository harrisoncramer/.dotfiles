# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Raspberry Pi Utilities
alias pibuild='GOOS=linux GOARCH=arm GOARM=5 go build'
picopy () {
  scp $1 pi@raspberrypi-1.local:/home/pi
}

# oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(zsh-syntax-highlighting zsh-autosuggestions git git-open)
source ~/.oh-my-zsh/oh-my-zsh.sh

# Autosuggest accept (instead of right arrow key)
bindkey '^ ' autosuggest-accept

# the-fuck
eval $(thefuck --alias)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

unreleased () {
  git fetch
  git --no-pager log origin/master..origin/develop --first-parent --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --date=relative --date-order
}

######################
## PERSONAL CONFIGS ##
######################

if [[ $OSTYPE == 'linux-gnu' ]] then

  # Remap caps lock to escape, except on hold is CTRL
  # setxkbmap -option caps:ctrl_modifier -option grp:shifts_toggle
  # killall xcape
  # xcape  -e 'Caps_Lock=Escape'

  # Node version manager
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  source ~/.zshrc-work

else
  source ~/.zshrc-personal
fi

# Get NVIM path from Other ZSHRC File
export EDITOR="$NVIM"

# Aliases
# Autoexpand aliases with tab
zstyle ':completion:*' completer _expand_alias _complete _ignored

# Git aliases
alias gs="git status"
alias gc='git commit -m '
alias gd='git diff'
alias gp='git pull'

alias dkk='cd ~/Desktop'
alias dotfiles='cd ~/.dotfiles'

# See: https://github.com/venantius/ultra/issues/103
alias lein='LEIN_USE_BOOTCLASSPATH=no lein'

