---
name: golang
description: Go development guidance. Use when editing or creating Go source, Go tests, go.mod/go.sum, package structure, interfaces, errors, concurrency, or reviewing Go code. Do not use for non-Go work or build/CI changes that do not touch Go code.
---

# Go Development

Use idiomatic, simple Go. Prefer small, explicit designs over frameworks or clever abstractions.

## First inspect

- Read nearby Go files before changing behavior; preserve local style unless it conflicts with correctness.
- Check `go.mod` for Go version and existing dependencies before adding imports.
- Prefer the standard library. Add third-party dependencies only when clearly justified by the project.

## Implementation principles

- Keep packages cohesive and avoid unnecessary exported API.
- Put constructors near the top; group methods by receiver type; keep public methods above private methods when practical.
- Wire dependencies in `main`, tests, or the composition root. Do not introduce DI frameworks.
- Prefer concrete types until an interface is needed by a caller or test seam.
- Prefer standard-library interfaces before custom ones; keep custom interfaces minimal.
- Inject a function instead of an interface when one function is sufficient.
- Pass `context.Context` as the first parameter after the receiver when cancellation, deadlines, or request scope are relevant; do not store contexts in structs.

## Errors

- Return errors rather than logging and continuing silently, except at process boundaries.
- Wrap errors with `%w` when callers may need to inspect the cause.
- Use sentinel errors for stable categories.
- Use custom error types only when callers need structured data.
- Test errors with `errors.Is` or `errors.As`; do not match error strings.

## Testing

- Prefer test-first work for bug fixes: add a failing regression test, make it pass, then refactor.
- Keep tests beside source files in `*_test.go`.
- Prefer black-box tests with `package foo_test` unless internal access is necessary.
- Use table-driven tests when cases mainly vary by input and expected output.
- Use descriptive `t.Run` names.
- Compare whole structs when possible; use field-by-field checks only for nondeterministic values.
- Prefer fakes over mocks; mock only at hard architectural boundaries and assert specific arguments.
- Prefer `stretchr/testify` assertions when already present; avoid adding it solely for one small test.
- Use `require.*` when continuing would invalidate the test.
- Low-level helpers should return errors; top-level assertion helpers should take `testing.TB`.
- Skip slow or external tests with `testing.Short()`.

## Validation

- Run `gofmt`/`go fmt` on changed Go files.
- Run the narrowest relevant `go test` first, then broader package tests when practical.
- If dependencies changed, run `go mod tidy` only when appropriate for the module and mention any resulting `go.mod`/`go.sum` changes.

## Output expectations

- State the files changed and tests run.
- If tests were not run, say why.
- Call out behavior changes, exported API changes, and any follow-up risks.
