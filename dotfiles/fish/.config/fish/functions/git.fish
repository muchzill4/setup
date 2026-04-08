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
    set -l result (
      command git branch |
        rg -v '\*' |
        cut -c 3- |
        fzf --cycle --layout=reverse --multi --expect=alt-x \
          --header="enter: switch | alt-x: delete | tab: mark"
    )

    test -n "$result"; or return 0

    set -l key $result[1]
    set -l selected $result[2..]

    test -n "$selected"; or return 0

    switch "$key"
      case alt-x
        printf 'Delete branches:\n'
        printf '  %s\n' $selected
        read -l -P 'Confirm? [y/N] ' confirm
        test "$confirm" = "y"; or return 0

        for branch in $selected
          command git branch -D "$branch"
        end
      case '*'
        command git switch "$selected[1]"
    end
  else
    command git $argv
  end
end
