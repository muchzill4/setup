function gw
  if test (count $argv) -eq 0
    _gw_picker
  else if test "$argv[1]" = "-c"; and test (count $argv) -eq 2
    _gw_create $argv[2]
  else
    command git worktree $argv
  end
end

function _gw_create -a branch
  set -l repo_root (command git rev-parse --show-toplevel 2>/dev/null)
  or begin
    echo "Not in a git repository"
    return 1
  end

  set -l wt_dir "$repo_root/.worktrees"
  set -l dir_name (string replace -a "/" "-" "$branch")
  set -l wt_path "$wt_dir/$dir_name"

  if test -d "$wt_path"
    cd "$wt_path"
    return 0
  end

  mkdir -p "$wt_dir"

  if command git show-ref --verify --quiet "refs/heads/$branch"
    command git worktree add "$wt_path" "$branch"
  else if command git show-ref --verify --quiet "refs/remotes/origin/$branch"
    command git worktree add "$wt_path" "$branch"
  else
    command git worktree add -b "$branch" "$wt_path"
  end
  or return 1

  cd "$wt_path"
end

function _gw_picker
  set -l repo_root (command git rev-parse --show-toplevel 2>/dev/null)
  or begin
    echo "Not in a git repository"
    return 1
  end

  set -l wt_dir "$repo_root/.worktrees"

  set -l dirs
  if test -d "$wt_dir"
    set dirs (find "$wt_dir" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
  end

  set -l result (
    printf '%s\n' $dirs |
    fzf --cycle --layout=reverse --multi --print-query --expect=alt-n,alt-x \
      --header="enter: open | alt-n: new | alt-x: delete | tab: mark"
  )

  test -n "$result"; or return 0

  set -l query $result[1]
  set -l key $result[2]
  set -l selected $result[3..]

  switch "$key"
    case alt-n
      test -n "$query"; or return 0
      _gw_create "$query"
    case alt-x
      test -n "$selected"; or return 0
      printf 'Delete worktrees:\n'
      printf '  %s\n' $selected
      read -l -P 'Confirm? [y/N] ' confirm
      test "$confirm" = "y"; or return 0

      for name in $selected
        command git worktree remove "$wt_dir/$name" 2>/dev/null
        or command git worktree remove --force "$wt_dir/$name"
      end
    case '*'
      test -n "$selected"; or return 0
      cd "$wt_dir/$selected[1]"
  end
end
