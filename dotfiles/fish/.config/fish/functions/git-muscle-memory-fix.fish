function git-muscle-memory-fix -e "alias main branch"
  set -l main (git branch --list main)

  if test -n "$main"
    git symbolic-ref refs/remotes/origin/master refs/remotes/origin/main &&
    git symbolic-ref refs/heads/master refs/heads/main
  end
end
