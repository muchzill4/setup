function checkout-pr -e "checkout selected pull request"
    gh api 'repos/:owner/:repo/pulls' |
    jq --raw-output '.[] | "#\(.number) \(.title)"' |
    fzf |
    sed -E 's/^#([0-9]+).*/\1/' |
    xargs gh pr checkout
end
