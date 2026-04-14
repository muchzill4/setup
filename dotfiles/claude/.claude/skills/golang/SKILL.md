---
name: golang
description: Go development conventions and testing best practices
allowed-tools:
  - Bash
  - Read
paths:
  - "**/*.go"
  - "**/go.mod"
---

# Go development

## File Organization

1. Constructor (`NewFoo`)
2. Public methods — grouped by struct
3. Private methods — grouped by struct, at the bottom

Methods of the same struct stay together. Don't interleave methods from different types.

## TDD Additions

In Go, add a step after "write a failing test": make the compiler pass — let compiler errors guide what to build.

## Testing

- Prefer `stretchr/testify` assertions over bare `if` statements
- Custom assertion helpers take `testing.TB` (not `*testing.T`) and call `t.Helper()` first
- Compare entire structs over field-by-field checks. Use field-by-field only for unpredictable values (time, IDs)
- `t.Run` names are descriptive, no underscores in test function names. Each `t.Run` is an isolated, independent case — never sequential dependent steps
- Tests for `foo.go` live in `foo_test.go` — keep tests as siblings of source
- Use table-driven tests when cases share setup/assertions, varying only inputs and expected outputs. Don't overstuff tables with flags like `shouldErr` — use separate `t.Run` blocks instead
- Use raw string literals (backticks) over escaped strings in tests
- Low-level helpers return errors, not accept `*testing.T`. Only top-level assertion helpers take `testing.TB`
- Use `t.Fatal` (not `t.Error`) when failure would cause nil-pointer panic later

### Prefer Fakes Over Mocks

Use fake implementations instead of testify mocks — simpler, no call-order coupling.

```go
type FakeRunner struct {
    Output string
    Err    error
}

func (f FakeRunner) Run(cmd string) (string, error) {
    return f.Output, f.Err
}
```

Reserve mocks for hard architectural boundaries. When mocks are necessary, be specific about expected arguments — avoid `mock.AnythingOfType` and wildcard matchers.

### Acceptance Tests

- Black-box only: `package foo_test`
- Skip slow tests with `testing.Short()`
- Place acceptance tests next to `main()` in `cmd/`

## Design

### Dependency Injection

No DI frameworks. Accept interfaces as parameters, wire in `main()`.

- Prefer stdlib interfaces (`io.Writer`, `io.Reader`, `fs.FS`, `http.Handler`) before custom ones
- Keep custom interfaces minimal (1-2 methods)
- Inject behavior as functions when a full interface is overkill

### Error Handling

- Sentinel errors as package-level vars: `var ErrNotFound = errors.New("not found")`
- Test errors with `errors.Is` / `errors.As` — never match on strings
- Custom error types when callers need structured data

### Filesystem Testing

Accept `fs.FS` instead of real paths. Test with `fstest.MapFS`.
