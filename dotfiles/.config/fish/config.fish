# clear default greeting
set fish_greeting

# include local fish config
set -l local_config "$HOME/.config/fish/local_config.fish"
test -e $local_config; and source $local_config
