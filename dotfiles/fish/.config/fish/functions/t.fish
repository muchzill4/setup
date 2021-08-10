function t -d "attach or run a tmux session from ~/Dev/*"
  set -l path $HOME/Dev
  set -l selected (
    find $path/* -maxdepth 1 -mindepth 1 -type d |
      sed "s~$path/~~" |
      fzf-tmux -p --cycle |
      sed "s~^~$path/~"
  )

  if test -n "$selected"
    set -l dirname (basename $selected)

    if test -n "$TMUX"
      tmux switch-client -t $dirname ||
        tmux new -c $selected -d -s $dirname && tmux switch-client -t $dirname
    else
      tmux new -c $selected -A -s $dirname
    end
  end
end
