function kt -d "Kitty tab from ~/Dev/*"
  set -l path $HOME/Dev
  set -l selected_dir (
    find $path/* -maxdepth 1 -mindepth 1 -type d |
      sed "s~$path/~~" |
      fzf --cycle --layout=reverse |
      sed "s~^~$path/~"
  )

  if test -n "$selected_dir"
    set -l tab_name (echo $selected_dir | sed "s~$path/~~")
    kitty @ focus-tab --match title:$tab_name 2>/dev/null || kitty @ launch --type=tab --tab-title $tab_name --cwd $selected_dir
  end
end
