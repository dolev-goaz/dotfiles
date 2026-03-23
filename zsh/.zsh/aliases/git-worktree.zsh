# 1. Ensure completion system is loaded
autoload -Uz compinit && compinit

# 2. Define the completion logic
_git_worktree_branches() {
    # Get all worktrees
    local branches=()
    while IFS= read -r line; do
        current_branch=$(echo "$line" | awk '{print $3}')
        # returned: [branch_name]
        current_branch="${current_branch#\[}"
        current_branch="${current_branch%\]}"
        branches+=("$current_branch") # Extract branch name
    done < <(git worktree list)

    if (( $#branches > 0 )); then
        _describe 'branches' branches
    fi
}

setopt COMPLETE_ALIASES

# 3. Define your aliases
alias gwa="~/scripts/git-worktree-add.sh"
alias gwr=". ~/scripts/git-worktree-remove.sh"
alias gwcd=". ~/scripts/git-worktree-cd.sh"
alias gwls="git worktree list"
alias gwp="git worktree prune"

# 4. Explicitly bind the function to the aliases
compdef _git_worktree_branches gwr gwcd
