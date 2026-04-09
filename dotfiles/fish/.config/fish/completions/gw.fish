complete -c gw -n '__fish_contains_opt -s c' -xa '(command git branch -a --format="%(refname:short)" 2>/dev/null)'
