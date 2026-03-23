#!/bin/bash

set -eu # Exit on error and treat unset variables as errors

# Parse arguments
create=false
branch_name=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --create)
            create=true
            shift
            ;;
        *)
            branch_name="$1"
            shift
            ;;
    esac
done

if [ -z "$branch_name" ]; then
    echo "Usage: $0 [--create] <branch-name>"
    exit 1
fi

repo_root=$(git rev-parse --show-toplevel)
if [ -z "$repo_root" ]; then
    echo "Not inside a git repository."
    exit 1
fi
repo_parent=$(dirname "$repo_root")
worktree_path="$repo_parent/$branch_name"

if [ "$create" = true ]; then
    git worktree add -b "$branch_name" "$worktree_path"
else
    git worktree add "$worktree_path" "$branch_name"
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
