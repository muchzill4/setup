function delete-branch -d "Delete selected branches"
  set -l branches (
    git branch |
    rg -v '\*' |
    cut -c 3- |
    fzf --prompt "Delete: " --multi
  )
  test -z "$branches"; and return 1
  echo $branches | xargs git branch -D
end
