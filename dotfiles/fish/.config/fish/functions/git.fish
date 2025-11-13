function git
  if test "$argv[1]" = "checkout"
    set_color red
    echo "🚫 checkout is banned! Use modern Git commands:"
    set_color normal
    echo "💡 git switch <branch>"
    echo "💡 git switch -c <new-branch>"
    echo "💡 git switch --detach <sha>"
    echo "💡 git restore <file>"
    return 1
  else if test "$argv[1]" = "switch"; and test (count $argv) -eq 1
    command git branch |
      rg -v '\*' |
      cut -c 3- |
      fzf --prompt "Checkout: " |
      xargs -r git switch
  else if test "$argv[1]" = "branch"; and test (count $argv) -eq 2; and test "$argv[2]" = "-D"
    command git branch |
      rg -v '\*' |
      cut -c 3- |
      fzf --multi --prompt "Delete branches: " |
      xargs -r git branch -D
  else
    command git $argv
  end
end
