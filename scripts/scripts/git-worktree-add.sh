#!/bin/bash

# Parse arguments
create=false
checkout=false
branch_name=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --create)
            create=true
            shift
            ;;
        --checkout)
            checkout=true
            shift
            ;;
        *)
            branch_name="$1"
            shift
            ;;
    esac
done

function error_exit {
    echo "$1"
    (return 0 2>/dev/null) && return 1 || exit 1
}

if [ -z "$branch_name" ]; then
    error_exit "Usage: $0 <branch-name> [--create] [--checkout]"
fi

repo_root=$(git rev-parse --show-toplevel)
if [ -z "$repo_root" ]; then
    error_exit "Error: Not inside a git repository."
fi
repo_parent=$(dirname "$repo_root")
worktree_path="$repo_parent/$branch_name"

if [ "$create" = true ]; then
    git worktree add --quiet -b "$branch_name" "$worktree_path"
else
    git worktree add --quiet "$worktree_path" "$branch_name"
fi

# Copy .env files to the new worktree
find "$repo_root" -name "node_modules" -prune -o -name ".env" -print | while read -r env_file; do
    relative_path="${env_file#$repo_root/}"
    target_path="$worktree_path/$relative_path"
    mkdir -p "$(dirname "$target_path")"
    cp "$env_file" "$target_path"
done

# Copy node_modules to the new worktree(if any)
find "$repo_root" -name "node_modules" -type d | while read -r node_modules_dir; do
    relative_path="${node_modules_dir#$repo_root/}"
    target_path="$worktree_path/$relative_path"
    mkdir -p "$(dirname "$target_path")"
    cp -r "$node_modules_dir" "$target_path"
done

# Copy dist to the new worktree(if any)
find "$repo_root" -name "dist" -prune -o -name "dist" -type d | while read -r dist_dir; do
    relative_path="${dist_dir#$repo_root/}"
    target_path="$worktree_path/$relative_path"
    mkdir -p "$(dirname "$target_path")"
    cp -r "$dist_dir" "$target_path"
done

if [ "$checkout" = true ]; then
    cd "$worktree_path"
    echo "Checked out to '$branch_name' in worktree at '$worktree_path'."
else
    echo "Worktree for branch '$branch_name' created at '$worktree_path'."
fi

