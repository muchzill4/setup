function t -d "attach or run a tmux session from ~/Dev/*"
  set -l path $HOME/Dev
  set -l selected_dir (
    find $path/* -maxdepth 1 -mindepth 1 -type d |
      sed "s~$path/~~" |
      fzf-tmux -p --cycle --prompt 't> ' |
      sed "s~^~$path/~"
  )

  if test -n "$selected_dir"
    set -l session_name (echo $selected_dir | sed "s~$path/~~" | sed "s/\./_/g")

    if test -n "$TMUX"
      tmux switch-client -t $session_name ||
        tmux new -c $selected_dir -d -s $session_name && tmux switch-client -t $session_name
    else
      tmux new -c $selected_dir -A -s $session_name
    end
  end
end
