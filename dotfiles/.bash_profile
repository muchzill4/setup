shopt -s autocd
shopt -s checkwinsize
shopt -s globstar
shopt -s histappend
shopt -s cmdhist
shopt -s no_empty_cmd_completion

export HISTCONTROL=ignoreboth:erasedups
HISTFILESIZE=1000000000
HISTSIZE=1000000

export CLICOLOR=1

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
GRAY="$(tput setaf 8)"
BOLD="$(tput bold)"
UNDERLINE="$(tput sgr 0 1)"
INVERT="$(tput sgr 1 0)"
NOCOLOR="$(tput sgr0)"

for file in ~/Setup/dotfiles/.bash/{aliases,prompt}.bash; do
    [ -r "$file" ] && source $file
done
unset file

export PATH="$HOME/.rbenv/bin:$PATH"
[[ `which rbenv` ]] && eval "$(rbenv init -)"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

[ -f ~/.bashlocal ] && source ~/.bashlocal
