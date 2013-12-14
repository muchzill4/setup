# No arguments: `git status`
# # With arguments: acts like `git`
function g {
	if [[ $# > 0 ]]; then
		git $@
	else
		git status
	fi
}

# Complete g like git
compdef g=git
