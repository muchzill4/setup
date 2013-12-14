# completion
autoload -U compinit && compinit
autoload -U promptinit && promptinit

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# add some readline keys back
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^B" backward-word
bindkey "^F" forward-word

# use incremental search
bindkey "^R" history-incremental-search-backward

# automatically enter dirs without cd
setopt auto_cd

# colorize ls
export CLICOLOR=1

# history
if [ -z $HISTFILE ]; then
	HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=10000
SAVEHIST=10000
setopt histignoredups
setopt share_history

# automatically pushd
setopt auto_pushd
export dirstacksize=5

# syntax highlighting
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# prompt
setopt promptsubst
source ~/.zsh/plugins/pure/pure.zsh

# load our own completion functions
fpath=(~/.zsh/completion $fpath)

for function in ~/.zsh/functions/*; do
	source $function
done

# aliases
[[ -e ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh

# local overrides
[[ -e ~/.zshrc.local ]] && source ~/.zshrc.local
