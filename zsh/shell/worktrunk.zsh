alias wts="wt switch"

function wtc () {
  NAME=$(gum input --placeholder "Worktree name, e.g. the feature")
  wt switch --create "harry/$NAME"
}

function wtr () {
  wt remove
}
