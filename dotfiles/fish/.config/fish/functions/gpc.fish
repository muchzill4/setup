function gpc -d "Checkout a PR into a worktree"
  set -l pr_number $argv[1]

  if test -z "$pr_number"
    set pr_number (
      gh pr list --json number,title,headRefName,author \
        --template '{{range .}}{{tablerow .number .title .headRefName .author.login}}{{end}}' |
      fzf --cycle --layout=reverse --prompt "PR: " |
      awk '{print $1}'
    )
    test -n "$pr_number"; or return 0
  end

  set -l branch (gh pr view "$pr_number" --json headRefName -q .headRefName)
  or return 1

  gw -c "$branch"
  or return 1

  gh pr checkout "$pr_number"
end
