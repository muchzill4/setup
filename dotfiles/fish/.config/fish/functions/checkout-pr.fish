function checkout-pr -d "Checkout selected pull request"
  set -l pr_number (
    gh api 'repos/:owner/:repo/pulls' |
    jq --raw-output '.[] |
    "#\(.number) \(.title)"' |
    fzf --prompt "Checkout PR: " |
    sed -E 's/^#([0-9]+).*/\1/'
  )
  test -z "$pr_number"; and return 1
  gh pr checkout "$pr_number"
end
