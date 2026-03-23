#!/bin/bash

# NOTE: needs to be sourced for the final cd to work.
#
function error_exit {
    echo "$1"
    (return 0 2>/dev/null) && return 1 || exit 1
}

if [ "$#" -ne 1 ]; then
    error_exit "Usage: $0 <branch_name>"
fi
branch_name="$1"

worktree_path=$(git worktree list | grep "$branch_name" | awk '{print $1}')
cd "$worktree_path"

