# clear default greeting
set fish_greeting

# colors
set fish_color_normal white
set fish_color_valid_path normal --underline
set fish_color_param normal
set fish_color_search_match --background=6d5d2b

# include local fish config
set -l local_config "$HOME/.config/fish/local_config.fish"
test -e $local_config; and source $local_config
