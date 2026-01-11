#!/bin/zsh

wt() {
  eval "$(mise run wt "$@")"
}

# Worktree management
#
# Choose worktree: "wt"
# Switch into root of repo: "wt ."
# Switch into specific worktree: "wt review"
# When on worktree, pull and merge in base: "wt --ff"
#
# This automatically symlinks possible shared files into the new worktree.

# shared_files=(.env .npmrc go.work.sum db_queries .cursor .claude local .crush .qf)

# wt() {
#   setopt localoptions pipefail
#   local git_common_dir
#   git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null)
#   if [ $? -ne 0 ] || [ -z "$git_common_dir" ]; then
#     echo "Not in a git repository" >&2
#     return 1
#   fi
#
#   local repo_root="${git_common_dir:h}"
#
#   if [ "$1" = "--ff" ]; then
#     local current_dir=$(pwd)
#     if [[ "$current_dir" != "$repo_root/.worktrees/"* ]]; then
#       echo "Not in a worktree, nothing to update" >&2
#       return 1
#     fi
#
#     cd "$repo_root" || return 1
#     local base_branch=$(git rev-parse --abbrev-ref HEAD)
#     cd "$current_dir" || return 1
#
#     if [ -z "$base_branch" ]; then
#       echo "Could not determine base branch from main repository" >&2
#       return 1
#     fi
#
#     local upstream_branch
#     upstream_branch=$(cd "$repo_root" && git rev-parse --abbrev-ref --symbolic-full-name ${base_branch}@{upstream} 2>/dev/null)
#
#     if [ $? -ne 0 ] || [ -z "$upstream_branch" ]; then
#       echo "Base branch '$base_branch' has no upstream configured" >&2
#       return 1
#     fi
#
#     local remote_name="${upstream_branch%%/*}"
#     local branch_name="${upstream_branch#*/}"
#
#     echo "Fetching $upstream_branch..."
#     git fetch "$remote_name" "$branch_name" || return 1
#
#     echo "Merging $upstream_branch into current branch..."
#     git merge "$upstream_branch" || return 1
#
#     return 0
#   fi
#
#   if [ $# -eq 0 ]; then
#     local worktree
#     local exit_code
#     worktree=$(git worktree list --porcelain 2>/dev/null | grep -E '^worktree ' | sed 's/^worktree //' | fzf --height=40% --border --prompt="Select worktree: ")
#     exit_code=$?
#
#     if [ $exit_code -ne 0 ] || [ -z "$worktree" ]; then
#       return 0
#     fi
#
#     cd "$worktree" || return 1
#   else
#     local worktree_name="$1"
#
#     if [ "$worktree_name" = "." ]; then
#       cd "$repo_root" || return 1
#     else
#       local worktree_path="$repo_root/.worktrees/$worktree_name"
#
#       if [ -d "$worktree_path" ]; then
#         cd "$worktree_path" || return 1
#       else
#         echo "Worktree '$worktree_name' not found at $worktree_path" >&2
#         return 1
#       fi
#     fi
#   fi
# }
