function delete-branches -e "delete selected branches"
  git branch |
  rg -v '\*' |
  cut -c 3- |
  fzf --prompt "Delete: " --multi |
  xargs git branch -D
end
