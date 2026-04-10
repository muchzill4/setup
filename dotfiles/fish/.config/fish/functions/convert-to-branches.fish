function convert-to-branches -d "Convert a bare + worktree layout back to a normal git repo"
  set -l common_dir (command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
  if test -z "$common_dir"
    echo "Not in a git repository"
    return 1
  end

  if not string match -q true (command git -C "$common_dir" rev-parse --is-bare-repository 2>/dev/null)
    echo "Not a bare repository"
    return 1
  end

  set -l root (dirname "$common_dir")
  set -l default_branch (command git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | string replace "refs/remotes/origin/" "")
  if test -z "$default_branch"
    set default_branch main
  end

  # Remove all worktrees
  for wt_path in "$root"/*/
    set wt_path (string trim -r -c "/" "$wt_path")
    test -d "$wt_path"; or continue
    test -f "$wt_path/.git"; or continue
    command git worktree remove --force "$wt_path" 2>/dev/null
  end

  # Convert bare repo back to normal
  rm "$root/.git"
  mv "$root/.bare" "$root/.git"
  command git -C "$root" config core.bare false

  cd "$root"
  command git checkout "$default_branch"
  echo "Converted to normal repository on branch '$default_branch'"
end
