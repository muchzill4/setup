function checkout-branch -d "Checkout selected branch"
  git branch |
  rg -v '\*' |
  cut -c 3- |
  fzf --prompt "Checkout: " |
  xargs git checkout
end
