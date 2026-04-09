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
    _git_switch_picker
  else
    command git $argv
  end
end

function _git_switch_picker
  set -l result (
    command git branch |
      rg -v '\*' |
      cut -c 3- |
      fzf --cycle --layout=reverse --multi --print-query --expect=alt-n,alt-x \
        --header="enter: switch | alt-n: new | alt-x: delete | tab: mark"
  )

  test -n "$result"; or return 0

  set -l query $result[1]
  set -l key $result[2]
  set -l selected $result[3..]

  switch "$key"
    case alt-n
      test -n "$query"; or return 0
      command git switch -c "$query"
    case alt-x
      test -n "$selected"; or return 0
      printf 'Delete branches:\n'
      printf '  %s\n' $selected
      read -l -P 'Confirm? [y/N] ' confirm
      test "$confirm" = "y"; or return 0

      for branch in $selected
        command git branch -D "$branch"
      end
    case '*'
      test -n "$selected"; or return 0
      command git switch "$selected[1]"
  end
end
