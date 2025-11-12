# remove greeting
set -g fish_greeting

# colorscheme
set fish_color_search_match 191929 --background=E6A64C
set fish_color_param BB781B
set fish_color_quote D1AF9F

# hydro
set hydro_color_pwd blue
set hydro_color_prompt purple
set hydro_color_git black
set hydro_color_duration yellow
set hydro_multiline true

if status --is-interactive
  abbr -a -g brew-up 'brew update && brew upgrade && brew cleanup'
  abbr -a -g c 'clear'
  abbr -a -g d 'docker'
  abbr -a -g dc 'docker compose'
  abbr -a -g dce 'docker compose exec'
  abbr -a -g dr 'docker run --rm -it'
  abbr -a -g e 'nvim'
  abbr -a -g g 'git'
  abbr -a -g gl 'git log --graph --oneline --abbrev-commit'
  abbr -a -g gs 'git status'
  abbr -a -g gp 'git push'
  abbr -a -g gq 'git pull'
  abbr -a -g gc 'git commit'
  abbr -a -g gb 'git branch'
  abbr -a -g gsw 'git switch'
  abbr -a -g gr 'git restore'
  abbr -a -g gd 'git diff'
  abbr -a -g gds 'git diff --stat'
  abbr -a -g sb 'switch-branch'
  abbr -a -g db 'delete-branch'
  abbr -a -g cpr 'checkout-pr'
  abbr -a -g la 'ls -AF'
  abbr -a -g ll 'ls -alh'
  abbr -a -g md 'mkdir -p'
end

fish_add_path ~/.local/bin /opt/homebrew/bin /opt/homebrew/sbin

# brew
if test -e /opt/homebrew/bin/brew
  set -x HOMEBREW_PREFIX "/opt/homebrew";
  set -x HOMEBREW_CELLAR "/opt/homebrew/Cellar";
  set -x HOMEBREW_REPOSITORY "/opt/homebrew";
  if test -n "$MANPATH[1]"; set -x MANPATH '' $MANPATH; end;
  if not contains "/opt/homebrew/share/info" $INFOPATH; set -x INFOPATH "/opt/homebrew/share/info" $INFOPATH; end;
end

# env
set -x EDITOR 'nvim'
set -x VISUAL 'nvim'
set -x MANPAGER 'nvim +Man!'

# fzf
set -x FZF_DEFAULT_COMMAND 'rg --files'
set -x FZF_DEFAULT_OPTS '--color query:regular,hl:#E6A64C,hl+:bold:#E6A64C,prompt:#E0A8E1,bg+:#561E57,gutter:#191929,info:#565B8F,separator:#262840,scrollbar:#565B8F,border:#565B8F'
if status --is-interactive
  fzf --fish | source
end

# docker
set -x DOCKER_BUILDKIT 1
set -x COMPOSE_DOCKER_CLI_BUILD 1

# mise
set -x MISE_FISH_AUTO_ACTIVATE 0
if status --is-interactive
  mise activate fish | source
end

# zoxide
if status --is-interactive
  zoxide init fish | source
end

# lima
set -x SSH "kitten ssh"
