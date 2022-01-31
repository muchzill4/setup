function checkout-branch -e "checkout selected branch"
  git branch |
  rg -v '\*' |
  cut -c 3- |
  fzf |
  xargs git checkout
end
