# clear default greeting
set fish_greeting

# colors
set fish_color_normal white
set fish_color_valid_path normal --underline
set fish_color_param normal
set fish_color_command green
set fish_color_search_match --background=black

# only cwd if process is fish
function fish_title
    if [ $_ = 'fish' ]
        echo (prompt_pwd)
    else
        echo $_
    end
end

# aliases
alias la 'ls -AF'
alias ll 'ls -al'
alias c 'clear'
alias md 'mkdir -p'
alias g 'git'
alias brew-up 'brew update; and brew upgrade; and brew cleanup; and brew prune'
alias serve 'ruby -run -e httpd . -p 8000'
alias t 'tmux attach; or tmux -u new'

# include local fish config
set -l local_config "$HOME/.config/fish/local_config.fish"
test -e $local_config; and . $local_config
