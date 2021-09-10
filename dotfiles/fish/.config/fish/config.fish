# make completion fast again
# https://github.com/fish-shell/fish-shell/issues/5825
function __fish_describe_command
  return
end

# fisher
set -g fisher_path $HOME/.local/share/fish/fisher
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]
for file in $fisher_path/conf.d/*.fish
  builtin source $file 2> /dev/null
end
if status is-interactive && ! functions --query fisher
  curl --silent --location https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

# fish
set fish_color_command 7FC79B
set fish_color_error E25A6A
set fish_color_normal CDCFE4
set fish_color_operator ACAFD2
set fish_color_param normal
set fish_color_quote D1AF9F
set fish_color_search_match --background=50340B
set fish_color_valid_path normal --underline

# pure
set pure_show_jobs true

if status --is-interactive
  abbr -a -g brew-up 'brew update && brew upgrade && brew cleanup'
  abbr -a -g c 'clear'
  abbr -a -g d 'docker'
  abbr -a -g dc 'docker-compose'
  abbr -a -g dce 'docker-compose exec'
  abbr -a -g dr 'docker run --rm -it'
  abbr -a -g e 'edit'
  abbr -a -g g 'git'
  abbr -a -g ga 'git add'
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
  alias ssh='kitty +kitten ssh'
end

# env
set -x EDITOR 'nvim'
set -x VISUAL $EDITOR

# ripgrep
set -x RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc

# fzf
set -x FZF_DEFAULT_COMMAND 'rg --files'
set -x FZF_DEFAULT_OPTS '--color query:regular,fg+:regular,hl:3,hl+:3:regular,prompt:5,bg+:#3c3862,gutter:-1'

# docker
set -x DOCKER_BUILDKIT 1
set -x COMPOSE_DOCKER_CLI_BUILD 1

# local venvs please
set -x PIPENV_VENV_IN_PROJECT 1

# make pip explode if attempting to install packages globally
set -x PIP_REQUIRE_VIRTUALENV 1

function gpip
  PIP_REQUIRE_VIRTUALENV="" pip $argv
end

# path    # fzf                  # pipx           # dotfiles
set paths /usr/local/opt/fzf/bin $HOME/.local/bin $HOME/.bin
for path in $paths
  contains $path $PATH; or set -x PATH $path $PATH
end

# asdf
source /usr/local/opt/asdf/asdf.fish

# direnv
direnv hook fish | source
