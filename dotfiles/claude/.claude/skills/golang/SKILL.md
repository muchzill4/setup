---
name: golang
description: Go development conventions, testing practices, and design guidance. Use when editing or creating `.go` files, modifying `go.mod` or `go.sum`, writing or reviewing Go tests, designing Go interfaces or error types, or working on Go package structure. Do not use for non-Go code or generic build or CI work that does not touch Go source.
allowed-tools:
  - Bash
  - Read
paths:
  - "**/*.go"
  - "**/go.mod"
---

# Go development

## Code organization
- Group methods by type.
- Prefer constructors near the top.
- Keep public methods above private methods when practical.
- Do not interleave methods from different types.

## Design
- No DI frameworks.
- Wire dependencies in `main()` or the composition root.
- Prefer standard library interfaces before custom ones.
- Keep custom interfaces minimal.
- Inject a function instead of an interface when that is sufficient.

## Error handling
- Use sentinel errors for stable categories.
- Test errors with `errors.Is` and `errors.As`, never string matching.
- Use custom error types only when callers need structured data.

## Testing
- After writing a failing test, make the compiler pass before completing the implementation.
- Prefer `stretchr/testify` assertions over repetitive manual checks.
- Compare whole structs when possible; use field-by-field checks only for unpredictable values.
- Use descriptive `t.Run` names.
- Keep tests beside source files in `*_test.go`.
- Use table-driven tests when cases mainly vary by input and expected output.
- Prefer raw string literals in tests when they improve readability.
- Low-level helpers should return errors; top-level assertion helpers should take `testing.TB`.
- Use `require.*` when continuing would make the test invalid.

## Fakes over mocks
- Prefer fake implementations over mocks.
- Mock only at hard architectural boundaries.
- When mocks are unavoidable, be specific about expected arguments.

## Acceptance tests
- Prefer black-box tests with `package foo_test`.
- Skip slow tests with `testing.Short()`.
