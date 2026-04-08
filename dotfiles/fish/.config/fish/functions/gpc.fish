function gpc -d "Checkout a PR into a worktree"
  set -l projects_path "$HOME/Dev"
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

  set -l repo_root (git rev-parse --show-toplevel 2>/dev/null)
  or begin
    echo "Not in a git repository"
    return 1
  end

  if string match -q "*/.worktrees/*" "$repo_root"
    echo "Already in a worktree. Run from the main worktree."
    return 1
  end

  set -l branch (gh pr view "$pr_number" --json headRefName -q .headRefName)
  or return 1

  set -l dir_name (string replace -a "/" "-" "$branch")
  set -l wt_dir "$repo_root/.worktrees"
  set -l wt_path "$wt_dir/$dir_name"

  if test -d "$wt_path"
    echo "Worktree already exists at $wt_path"
    return 1
  end

  mkdir -p "$wt_dir"

  git worktree add --detach "$wt_path"
  or return 1

  fish -c "cd $wt_path && gh pr checkout $pr_number"
  or begin
    git worktree remove --force "$wt_path"
    return 1
  end

  set -l project_name (string replace "$projects_path/" "" "$repo_root")
  set -l session_name "$project_name @ $dir_name"
  kitty @ launch --type=os-window --os-window-name="$session_name" --cwd="$wt_path"
end
