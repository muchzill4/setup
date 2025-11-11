function checkout-branch -d "Checkout selected branch"
  set -l branch (
    git branch |
    rg -v '\*' |
    cut -c 3- |
    fzf --prompt "Checkout: "
  )
  test -z "$branch"; and return 1
  git checkout "$branch"
end
