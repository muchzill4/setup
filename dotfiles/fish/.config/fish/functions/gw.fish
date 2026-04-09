function gw
  if test (count $argv) -eq 0
    _gw_picker
  else if test "$argv[1]" = "--clean"
    _gw_clean
  else if test (count $argv) -eq 1
    _gw_create $argv[1]
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
    set -l default_branch (command git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | string replace "refs/remotes/" "")
    if test -z "$default_branch"
      set default_branch origin/main
    end
    command git worktree add -b "$branch" "$wt_path" "$default_branch"
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
        _gw_remove "$wt_dir/$name"
      end
    case '*'
      test -n "$selected"; or return 0
      cd "$wt_dir/$selected[1]"
  end
end

function _gw_remove -a wt_path
  set -l branch (command git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null)

  command git worktree remove "$wt_path" 2>/dev/null
  or command git worktree remove --force "$wt_path"
  or return 1

  if test -n "$branch"; and test "$branch" != HEAD
    command git branch -D "$branch" 2>/dev/null
  end
end

function _gw_clean
  set -l repo_root (command git rev-parse --show-toplevel 2>/dev/null)
  or begin
    echo "Not in a git repository"
    return 1
  end

  set -l wt_dir "$repo_root/.worktrees"
  test -d "$wt_dir"; or return 0

  set -l removed 0
  for wt_path in "$wt_dir"/*/
    set wt_path (string trim -r -c "/" "$wt_path")
    test -d "$wt_path"; or continue

    # Skip worktrees with uncommitted changes
    test -z (command git -C "$wt_path" status --porcelain 2>/dev/null); or continue

    # Skip worktrees with unpushed commits
    set -l branch (command git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null)
    if test -n "$branch"; and test "$branch" != HEAD
      set -l upstream (command git -C "$wt_path" rev-parse --abbrev-ref "$branch@{upstream}" 2>/dev/null)
      if test -n "$upstream"
        set -l unpushed (command git -C "$wt_path" log "$upstream..$branch" --oneline 2>/dev/null)
        test -z "$unpushed"; or continue
      else
        # No upstream means all commits are unpushed
        continue
      end
    end

    echo "Removing $(basename $wt_path)"
    _gw_remove "$wt_path"
    set removed (math $removed + 1)
  end

  if test $removed -eq 0
    echo "No stale worktrees found"
  end
end
