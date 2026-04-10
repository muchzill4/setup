function convert-to-worktrees -d "Convert a normal git repo to bare + worktree layout"
  set -l root (command git rev-parse --show-toplevel 2>/dev/null)
  if test -z "$root"
    echo "Not in a git repository"
    return 1
  end

  if command git rev-parse --is-bare-repository 2>/dev/null | string match -q true
    echo "Already a bare repository"
    return 1
  end

  if test -n "$(command git -C "$root" status --porcelain 2>/dev/null)"
    echo "Working tree is dirty, commit or stash first"
    return 1
  end

  set -l branch (command git -C "$root" rev-parse --abbrev-ref HEAD)
  set -l dir_name (string replace -a "/" "-" "$branch")

  # Convert .git directory to bare repo
  mv "$root/.git" "$root/.bare"
  echo "gitdir: .bare" > "$root/.git"
  command git -C "$root/.bare" config core.bare true

  # Remove working files (recreated by worktree add)
  for item in "$root"/*
    set -l name (basename "$item")
    test "$name" = .bare; and continue
    rm -rf "$item"
  end
  for item in "$root"/.*
    set -l name (basename "$item")
    test "$name" = .; or test "$name" = ..; or test "$name" = .bare; or test "$name" = .git; and continue
    rm -rf "$item"
  end

  command git worktree add "$root/$dir_name" "$branch"
  or return 1

  cd "$root/$dir_name"
  echo "Converted to worktree layout: $root/{$dir_name}"
end
