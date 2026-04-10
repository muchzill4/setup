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
  else
    command git $argv
  end
end
