function fork-setup --description "Configure current repo as a fork tracking upstream"
    if test (count $argv) -ne 1
        echo "Usage: fork-setup <upstream-url>"
        return 1
    end

    set upstream_url $argv[1]

    if git remote | grep -q "^upstream\$"
        echo "Remote 'upstream' already exists, updating URL"
        git remote set-url upstream $upstream_url
    else
        git remote add upstream $upstream_url
    end

    git fetch upstream

    set default_branch (git remote show upstream | grep 'HEAD branch' | awk '{print $NF}')
    echo "Upstream default branch: $default_branch"

    git switch $default_branch
    git branch --set-upstream-to=upstream/$default_branch $default_branch
    git reset --hard upstream/$default_branch

    echo "Done. $default_branch now tracks upstream/$default_branch"
    echo "Pushes still go to origin (your fork)"
end
