function t -d "attach or run a tmux session from ~/Dev/*"
  set -l path $HOME/Dev
  set -l selected (
    find $path/* -maxdepth 1 -mindepth 1 -type d |
      string replace "$HOME" "~" |
      fzf-tmux -p
  )

  if test -n "$selected"
    set -l dirname (basename $selected)

    tmux switch-client -t $dirname 2> /dev/null
    if test $status -ne 0
      tmux new -c $selected -d -s $dirname && tmux switch-client -t $dirname ||
        tmux new -c $selected -A -s $dirname
    end
  end
end
