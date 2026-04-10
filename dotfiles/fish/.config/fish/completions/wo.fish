complete -c wo -f -xa '(command git branch -a --format="%(refname:short)" 2>/dev/null)'
complete -c wo -f -s c -d "Create and switch to new branch/worktree"
complete -c wo -f -l clean -d "Remove stale worktrees or merged branches"
complete -c wo -f -s h -l help -d "Show help"
