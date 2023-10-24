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

# colorscheme
set fish_color_command 7FC79B
set fish_color_error E25A6A
set fish_color_normal CDCFE4
set fish_color_operator 9C9FC9
set fish_color_param normal
set fish_color_quote D1AF9F
set fish_color_search_match --background=342413
set fish_color_valid_path normal --underline

# pure
set pure_shorten_prompt_current_directory_length 1
set pure_shorten_window_title_current_directory_length 1
set pure_show_jobs true

if status --is-interactive
  abbr -a -g brew-up 'brew update && brew upgrade && brew cleanup'
  abbr -a -g c 'clear'
  abbr -a -g d 'docker'
  abbr -a -g dc 'docker-compose'
  abbr -a -g dce 'docker-compose exec'
  abbr -a -g dr 'docker run --rm -it'
  abbr -a -g e 'nvim'
  abbr -a -g g 'git'
  abbr -a -g gl 'git l'
  abbr -a -g gs 'git s'
  abbr -a -g gp 'git p'
  abbr -a -g gq 'git q'
  abbr -a -g gc 'git c'
  abbr -a -g ga 'git a'
  abbr -a -g gd 'git d'
  abbr -a -g gds 'git ds'
  abbr -a -g gco 'git co'
  abbr -a -g gr 'git r'
  abbr -a -g cb 'checkout-branch'
  abbr -a -g db 'delete-branches'
  abbr -a -g cpr 'checkout-pr'
  abbr -a -g la 'ls -AF'
  abbr -a -g ll 'ls -alh'
  abbr -a -g md 'mkdir -p'
  abbr -a -g vp '.venv/bin/python'
  abbr -a -g va 'source .venv/bin/activate.fish'
  abbr -a -g vd 'deactivate'
  alias ssh='kitty +kitten ssh'
end

# brew
if test -e /opt/homebrew/bin/brew && test ! -n "$BREW_INITIALISED"
  set -x BREW_INITIALISED 'aye'
  eval (/opt/homebrew/bin/brew shellenv)
end

# env
set -x EDITOR 'nvim'
set -x VISUAL $EDITOR

# ripgrep
set -x RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc

# fzf
set -x FZF_DEFAULT_COMMAND 'rg --files'
set -x FZF_DEFAULT_OPTS '--color query:regular,hl:#E6A64C,hl+:bold:#E6A64C,prompt:#E0A8E1,bg+:#561E57,gutter:-1,info:#565B8F,separator:#262840,scrollbar:#565B8F'

# docker
set -x DOCKER_BUILDKIT 1
set -x COMPOSE_DOCKER_CLI_BUILD 1

# local venvs please
set -x PIPENV_VENV_IN_PROJECT 1

function gpip
  PIP_REQUIRE_VIRTUALENV="" pip $argv
end

# path    # dotfiles
set paths $HOME/.bin
for path in $paths
  contains $path $PATH; or set -x PATH $path $PATH
end

# rtx
rtx activate fish | source
