function delete-branches -d "Delete selected branches"
  git branch |
  rg -v '\*' |
  cut -c 3- |
  fzf --prompt "Delete: " --multi |
  xargs git branch -D
end
