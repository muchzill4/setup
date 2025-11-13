function switch-branch -d "Switch to selected branch"
  if test (count $argv) -gt 0
    git switch $argv[1]
    return $status
  end

  set -l branch (
    git branch |
    rg -v '\*' |
    cut -c 3- |
    fzf --prompt "Checkout: "
  )
  test -z "$branch"; and return 1
  git switch "$branch"
end
