# Source Control

## Commit Messages

Match the repo's existing commit style. Default to conventional commits when there is no established convention.

### Conventional Commits

Format: `<type>(<scope>): <subject>` (scope is optional)

| Type | Use |
|------|-----|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `style` | Formatting |
| `refactor` | Code restructure |
| `perf` | Performance |
| `test` | Tests |
| `chore` | Maintenance |
| `ci` | CI/CD |
| `build` | Build system |
| `revert` | Revert commit |

Rules: imperative mood, present tense, lowercase, no period, max 50 chars.

```
feat(auth): add JWT validation
fix: resolve race condition in worker pool
refactor: extract payment processing to separate module
```

## Branch Naming

Prefix branches with type: `feat/user-auth`, `fix/login-bug`, `chore/update-deps`.

## Workflow

- Prefer rebase over merge to keep linear history
- Use `--ff-only` when merging branches — no merge commits
- Use `--force-with-lease` instead of `--force` on shared branches
