# remove greeting
set -g fish_greeting

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
set fish_color_command 7FC79B --bold
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
  abbr -a -g gro 'git fetch && git rebase --onto origin/master'
  abbr -a -g grm 'git fetch && git rebase origin/master'
  abbr -a -g gs 'git status'
  abbr -a -g gst 'git stash'
  abbr -a -g gsta 'git stash apply'
  abbr -a -g gstp 'git stash pop'
  abbr -a -g la 'ls -AF'
  abbr -a -g ll 'ls -alh'
  abbr -a -g md 'mkdir -p'
  abbr -a -g vp '.venv/bin/python'
  abbr -a -g va 'source .venv/bin/activate.fish'
  abbr -a -g vd 'deactivate'
  abbr -a -g cb 'checkout-branch'
  abbr -a -g db 'delete-branches'
  abbr -a -g cpr 'checkout-pr'
  alias ssh='kitty +kitten ssh'
end

# env
set -x EDITOR 'nvim'
set -x VISUAL $EDITOR

# ripgrep
set -x RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc

# fzf
set -x FZF_DEFAULT_COMMAND 'rg --files'
set -x FZF_DEFAULT_OPTS '--color query:regular,hl:3,hl+:bold:3,prompt:5,bg+:#561e57,gutter:-1 --bind ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'

# docker
set -x DOCKER_BUILDKIT 1
set -x COMPOSE_DOCKER_CLI_BUILD 1

# local venvs please
set -x PIPENV_VENV_IN_PROJECT 1

# bat
set -x BAT_THEME '1337'

function gpip
  PIP_REQUIRE_VIRTUALENV="" pip $argv
end

# path    # fzf                  # pipx           # dotfiles
set paths /usr/local/opt/fzf/bin $HOME/.local/bin $HOME/.bin
for path in $paths
  contains $path $PATH; or set -x PATH $path $PATH
end

# asdf
source (brew --prefix asdf)/libexec/asdf.fish

# gpg
set -x GPG_TTY (tty)
gpgconf --launch gpg-agent
