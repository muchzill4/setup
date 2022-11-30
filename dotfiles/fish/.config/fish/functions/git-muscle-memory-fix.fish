function git-muscle-memory-fix -d "Alias main branch to master branch"
  set -l main (git branch --list main)

  if test -n "$main"
    git symbolic-ref refs/remotes/origin/master refs/remotes/origin/main &&
    git symbolic-ref refs/heads/master refs/heads/main
  end
end
