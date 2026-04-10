function wo -d "Work on a branch (detects worktree vs branch repos)"
  if not command git rev-parse --git-dir &>/dev/null
    echo "Not in a git repository"
    return 1
  end

  if test (count $argv) -eq 0
    _wo_picker
  else if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
    _wo_help
  else if test "$argv[1]" = "--clean"
    _wo_clean
  else if test "$argv[1]" = "-c"; and test (count $argv) -eq 2
    _wo_create $argv[2]
  else if test (count $argv) -eq 1
    _wo_switch $argv[1]
  else
    _wo_help
    return 1
  end
end

function _wo_help
  echo "Usage: wo [options] [branch]"
  echo ""
  echo "  wo              Interactive picker (fzf)"
  echo "  wo <branch>     Switch to existing branch/worktree"
  echo "  wo -c <branch>  Create and switch to new branch/worktree"
  echo "  wo --clean      Remove stale worktrees or merged branches"
  echo "  wo --help       Show this help"
end

function _wo_is_bare
  set -l common_dir (command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
  test -n "$common_dir"; or return 1
  string match -q true (command git -C "$common_dir" rev-parse --is-bare-repository 2>/dev/null)
end

function _wo_project_root
  set -l common_dir (command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
  if test -z "$common_dir"
    echo "Not in a git repository"
    return 1
  end
  dirname "$common_dir"
end

function _wo_default_branch
  set -l ref (command git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null)
  if test -n "$ref"
    string replace "refs/remotes/origin/" "" "$ref"
  else
    echo main
  end
end

function _wo_dir_name -a branch
  string replace -a "/" "-" "$branch"
end

# --- Dispatch ---

function _wo_switch -a branch
  if _wo_is_bare
    _wo_wt_switch $branch
  else
    _wo_br_switch $branch
  end
end

function _wo_create -a branch
  if _wo_is_bare
    _wo_wt_create $branch
  else
    _wo_br_create $branch
  end
end

function _wo_picker
  if _wo_is_bare
    _wo_wt_picker
  else
    _wo_br_picker
  end
end

function _wo_clean
  if _wo_is_bare
    _wo_wt_clean
  else
    _wo_br_clean
  end
end

# --- Worktree mode (bare repos) ---

function _wo_wt_switch -a branch
  set -l root (_wo_project_root)
  or return 1

  set -l dir_name (_wo_dir_name "$branch")
  set -l wt_path "$root/$dir_name"

  if test -d "$wt_path"
    cd "$wt_path"
    return 0
  end

  echo "Worktree '$branch' does not exist. Use wo -c $branch to create it."
  return 1
end

function _wo_wt_create -a branch
  set -l root (_wo_project_root)
  or return 1

  set -l dir_name (_wo_dir_name "$branch")
  set -l wt_path "$root/$dir_name"

  if test -d "$wt_path"
    cd "$wt_path"
    return 0
  end

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

function _wo_wt_picker
  set -l root (_wo_project_root)
  or return 1

  set -l dirs
  for d in "$root"/*/
    set -l name (basename "$d")
    test -f "$d.git"; or continue
    set -a dirs "$name"
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
      _wo_wt_create "$query"
    case alt-x
      test -n "$selected"; or return 0
      printf 'Delete worktrees:\n'
      printf '  %s\n' $selected
      read -l -P 'Confirm? [y/N] ' confirm
      test "$confirm" = y; or return 0

      for name in $selected
        _wo_wt_remove "$root/$name"
      end
    case '*'
      test -n "$selected"; or return 0
      cd "$root/$selected[1]"
  end
end

function _wo_wt_remove -a wt_path
  set -l branch (command git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null)

  command git worktree remove "$wt_path" 2>/dev/null
  or command git worktree remove --force "$wt_path"
  or return 1

  if test -n "$branch"; and test "$branch" != HEAD
    command git branch -D "$branch" 2>/dev/null
  end
end

function _wo_wt_clean
  set -l root (_wo_project_root)
  or return 1

  set -l removed 0
  for wt_path in "$root"/*/
    set wt_path (string trim -r -c "/" "$wt_path")
    test -d "$wt_path"; or continue
    test -f "$wt_path/.git"; or continue

    test -z (command git -C "$wt_path" status --porcelain 2>/dev/null); or continue

    set -l branch (command git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null)
    if test -n "$branch"; and test "$branch" != HEAD
      set -l upstream (command git -C "$wt_path" rev-parse --abbrev-ref "$branch@{upstream}" 2>/dev/null)
      if test -n "$upstream"
        set -l unpushed (command git -C "$wt_path" log "$upstream..$branch" --oneline 2>/dev/null)
        test -z "$unpushed"; or continue
      else
        continue
      end
    end

    echo "Removing $(basename $wt_path)"
    _wo_wt_remove "$wt_path"
    set removed (math $removed + 1)
  end

  if test $removed -eq 0
    echo "No stale worktrees found"
  end
end

# --- Branch mode (normal repos) ---

function _wo_br_switch -a branch
  if command git show-ref --verify --quiet "refs/heads/$branch"
    command git switch "$branch"
  else if command git show-ref --verify --quiet "refs/remotes/origin/$branch"
    command git switch "$branch"
  else
    echo "Branch '$branch' does not exist. Use wo -c $branch to create it."
    return 1
  end
end

function _wo_br_create -a branch
  if command git show-ref --verify --quiet "refs/heads/$branch"
    command git switch "$branch"
  else if command git show-ref --verify --quiet "refs/remotes/origin/$branch"
    command git switch "$branch"
  else
    command git switch -c "$branch"
  end
end

function _wo_br_picker
  set -l result (
    command git branch --format='%(refname:short)' |
    fzf --cycle --layout=reverse --multi --print-query --expect=alt-n,alt-x \
      --header="enter: switch | alt-n: new | alt-x: delete | tab: mark"
  )

  test -n "$result"; or return 0

  set -l query $result[1]
  set -l key $result[2]
  set -l selected $result[3..]

  switch "$key"
    case alt-n
      test -n "$query"; or return 0
      command git switch -c "$query"
    case alt-x
      test -n "$selected"; or return 0
      printf 'Delete branches:\n'
      printf '  %s\n' $selected
      read -l -P 'Confirm? [y/N] ' confirm
      test "$confirm" = y; or return 0

      for branch in $selected
        command git branch -D "$branch"
      end
    case '*'
      test -n "$selected"; or return 0
      command git switch "$selected[1]"
  end
end

function _wo_br_clean
  set -l default_branch (_wo_default_branch)

  set -l removed 0
  for branch in (command git branch --merged "$default_branch" --format='%(refname:short)' 2>/dev/null)
    test "$branch" = "$default_branch"; and continue
    echo "Removing $branch"
    command git branch -d "$branch"
    set removed (math $removed + 1)
  end

  if test $removed -eq 0
    echo "No merged branches found"
  end
end
