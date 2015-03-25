_add_local_completion() {
    local compfile="$(brew --prefix)/etc/bash_completion.d/$1"
    if [ -f $compfile ]; then
	source $compfile
    fi
}

_add_local_completion "git-completion.bash"
_add_local_completion "tmux"
_add_local_completion "brew_bash_completion.sh"

__git_complete g __git_main
