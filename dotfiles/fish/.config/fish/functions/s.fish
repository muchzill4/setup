function s -d "switch to a tmux session"
  set -l selected (
    tmux list-sessions |
      cut -d : -f 1 |
      fzf-tmux -p --cycle --prompt 's> '
  )

  if test -n "$selected"
    if test -n "$TMUX"
      tmux switch-client -t $selected
    else
      tmux attach -t $selected
    end
  end
end
