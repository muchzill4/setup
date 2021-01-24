set pure_color_mute white

# fisher
set -g fisher_path $HOME/.local/share/fish/fisher
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]
for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# colors
set fish_color_command green
set fish_color_error red
set fish_color_normal white
set fish_color_operator magenta
set fish_color_param normal
set fish_color_quote cyan
set fish_color_search_match --background=brblack
set fish_color_valid_path normal --underline

# env
set -x PATH $PATH $HOME/.bin
set -x PATH $PATH $HOME/.local/bin # pipx
set -x EDITOR 'nvim'
set -x VISUAL $EDITOR
set -x FZF_DEFAULT_COMMAND 'rg --files'
set -x FZF_DEFAULT_OPTS '--color hl:3,hl+:3,prompt:5'

if status --is-interactive
    abbr -a -g brew-up 'brew update && brew upgrade && brew cleanup'
    abbr -a -g c 'clear'
    abbr -a -g d 'docker'
    abbr -a -g da 'direnv allow'
    abbr -a -g dc 'docker-compose'
    abbr -a -g dce 'docker-compose exec'
    abbr -a -g dr 'docker run --rm -it'
    abbr -a -g e $EDITOR
    abbr -a -g g 'git'
    abbr -a -g ga 'git add'
    abbr -a -g gbc 'git checkout master && git branch | rg -v master | xargs git branch -D'
    abbr -a -g gc 'git commit'
    abbr -a -g gca 'git commit --amend'
    abbr -a -g gco 'git checkout'
    abbr -a -g gd 'git diff'
    abbr -a -g gf 'git fetch'
    abbr -a -g gl 'git log --graph --pretty=oneline --abbrev-commit'
    abbr -a -g gll 'git log -p'
    abbr -a -g gp 'git push'
    abbr -a -g gq 'git pull'
    abbr -a -g gr 'git rebase'
    abbr -a -g grm 'git fetch && git rebase origin/master'
    abbr -a -g gs 'git status'
    abbr -a -g gst 'git stash'
    abbr -a -g gsta 'git stash apply'
    abbr -a -g gstp 'git stash pop'
    abbr -a -g la 'ls -AF'
    abbr -a -g ll 'ls -alh'
    abbr -a -g md 'mkdir -p'
    abbr -a -g t 'tmux attach || tmux new'
end

# asdf
source ~/.asdf/asdf.fish

# direnv
direnv hook fish | source

# docker
set -x DOCKER_BUILDKIT 1
set -x COMPOSE_DOCKER_CLI_BUILD 1

# make completion fast again
# https://github.com/fish-shell/fish-shell/issues/5825
function __fish_describe_command
  return
end
