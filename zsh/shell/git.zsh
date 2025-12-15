#!/bin/zsh

alias mono="cd $MONO_DIR"
alias proto="cd $PROTO_DIR"
alias g="git"
alias pr="gh pr view --web"
alias gs="git status"
alias gc='git commit -m '
alias gd='git diff'
alias gp='git push'

unalias gf 2>/dev/null || true
gf () {
  git fetch origin staging:staging
}

# Creates a new blank Github Repository and Switches into it
project () {
  privateOrPublic="--private"
  if [ "$2" = "--public" ]; then 
    privateOrPublic="--public"
  fi

  mkdir "$1"
  cd "$1"
  git init
  touch README.md
  echo "# ${1}" >> README.md
  mkdir .sessions
  gh repo create "${1}" $privateOrPublic --source=. --remote=origin
  git branch -M main
  git add .
  git commit -m 'Initial commit'
  git push -u origin main
  echo "Success! Repository created."
}

stash () {
  if [ "$1" = "pop" ]; then
    git stash pop
  else
    git stash --include-untracked
  fi
}

squash () {
  while IFS= read -r file; do
    ffmpeg -i "$file" -vf "scale=1500:-1" "${file%.*}_squashed.jpg"
  done
}
