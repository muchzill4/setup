# Source Control

## Commit Messages

Match the repo's existing commit style. Default to conventional commits (`<type>(<scope>): <subject>`) when there is no established convention.

Rules: imperative mood, present tense, lowercase, no period, max 50 chars. Describe *what* changed, not *how* you worked. Never reference methodology or process. Messages must be self-contained — don't reference concepts, branch names, or tooling that only exist elsewhere.

## Branch Naming

Prefix with type: `feat/user-auth`, `fix/login-bug`, `chore/update-deps`.

## Workflow

- Prefer rebase over merge to keep linear history
- Use `--ff-only` when merging — no merge commits
- Use `--force-with-lease` instead of `--force` on shared branches
- Commit as you go — after each meaningful step, not at the end. Split unrelated changes into separate commits
