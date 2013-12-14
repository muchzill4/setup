# No arguments: test everything
# With arguments: select what to test
function td {
	if [[ $# > 0 ]]; then
		testdrb -I test $@
	else
		testdrb -I test ./test/**/*_test.rb
	fi
}
