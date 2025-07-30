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
set fish_color_search_match 191929 --background=E6A64C
set fish_color_param BB781B
set fish_color_quote D1AF9F

# pure
set pure_shorten_prompt_current_directory_length 1
set pure_shorten_window_title_current_directory_length 1
set pure_show_subsecond_command_duration true
set pure_show_jobs true
set -g async_prompt_functions _pure_prompt_git

if status --is-interactive
  abbr -a -g brew-up 'brew update && brew upgrade && brew cleanup'
  abbr -a -g c 'clear'
  abbr -a -g d 'docker'
  abbr -a -g dc 'docker compose'
  abbr -a -g dce 'docker compose exec'
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
end

# brew
if test -e /opt/homebrew/bin/brew && test ! -n "$BREW_INITIALISED"
  set -x BREW_INITIALISED 'aye'
  eval (/opt/homebrew/bin/brew shellenv)
end

# env
set -x EDITOR 'nvim'
set -x VISUAL 'nvim'
set -x MANPAGER 'nvim +Man!'

# fzf
set -x FZF_DEFAULT_COMMAND 'rg --files'
set -x FZF_DEFAULT_OPTS '--color query:regular,hl:#E6A64C,hl+:bold:#E6A64C,prompt:#E0A8E1,bg+:#561E57,gutter:-1,info:#565B8F,separator:#262840,scrollbar:#565B8F,border:#565B8F'
fzf --fish | source

# docker
set -x DOCKER_BUILDKIT 1
set -x COMPOSE_DOCKER_CLI_BUILD 1
