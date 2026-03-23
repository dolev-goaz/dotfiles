#!/bin/bash

# NOTE: needs to be sourced for the final cd to work.

function error_exit {
    echo "$1"
    (return 0 2>/dev/null) && return 1 || exit 1
}

if [ "$#" -ne 1 ]; then
    error_exit "Usage: $0 <branch_name>"
fi

branch_name="$1"

if ! git rev-parse --verify "$branch_name" >/dev/null 2>&1; then
    error_exit "Error: Branch '$branch_name' does not exist."
fi

if ! git worktree list | grep -q "$branch_name"; then
    error_exit "Error: Branch '$branch_name' is not a worktree."
fi

# Get worktree path
worktree_path=$(git worktree list | grep "$branch_name" | awk '{print $1}')

# Get main repository root
common_dir=$(git rev-parse --path-format=absolute --git-common-dir)
if [[ "$common_dir" == *"/.git" ]]; then
    main_repo_root=$(dirname "$common_dir")
else
    main_repo_root="$common_dir"
fi

# If current directory is inside the worktree, change to the main repository root
current_dir=$(pwd)
if [[ "$current_dir" == "$worktree_path"* ]]; then
    cd "$main_repo_root"
fi

echo "Removing worktree for branch '$branch_name' at path '$worktree_path'..."
git worktree remove "$worktree_path" --force
git branch -D "$branch_name"
echo "Worktree for branch '$branch_name' removed successfully."

