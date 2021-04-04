function checkout-pr -e "checkout selected pull request"
    cat pulls.json |
    jq --raw-output '.[] | "#\(.number) \(.title)"' |
    fzf |
    sed -E 's/^#([0-9]+).*/\1/' |
    xargs gh pr checkout
end
