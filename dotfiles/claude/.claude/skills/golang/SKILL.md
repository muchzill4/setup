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

## TDD Additions

In Go, add a step after "write a failing test": make the compiler pass — let compiler errors guide what to build.

## Testing

### Testify Assertions

Prefer [stretchr/testify](https://github.com/stretchr/testify) assertions over basic Go if statements for clearer test failures.

```go
import (
    "testing"
    "github.com/stretchr/testify/assert"
)

func TestUserCreation(t *testing.T) {
    got := NewUser("Alice", 30)

    assert.Equal(t, "Alice", user.Name)
    assert.Equal(t, 30, user.Age)
    assert.NotNil(t, user.CreatedAt)
}
```

### Custom Assertion Helpers

For assertions testify doesn't cover, write small helpers. Accept `testing.TB` (not `*testing.T`) so they work in benchmarks too. Always call `t.Helper()` first.

```go
func assertValidToken(t testing.TB, token Token) {
    t.Helper()
    assert.NotEmpty(t, token.Value)
    assert.True(t, token.ExpiresAt.After(time.Now()))
}
```

### Struct Comparison Over Field-by-Field Checks

Compare entire structs in a single assertion rather than checking each field individually.

```go
func TestCreateUser(t *testing.T) {
    got := CreateUser("Bob", "bob@example.com")

    want := User{
        Name:  "Bob",
        Email: "bob@example.com",
        Role:  "user",
    }
    assert.Equal(t, want, got)
}

// For time fields or unpredictable values, use a hybrid approach
func TestCreateUserWithTimestamp(t *testing.T) {
    got := CreateUser("Bob", "bob@example.com")

    assert.Equal(t, "Bob", got.Name)
    assert.Equal(t, "bob@example.com", got.Email)
    assert.NotZero(t, got.CreatedAt)
}
```

### Test Organization with `t.Run()`

Use `t.Run()` with descriptive names. Avoid underscores in test function names.

```go
func TestUserService(t *testing.T) {
    t.Run("GetUser", func(t *testing.T) {
        t.Run("returns user when exists", func(t *testing.T) {
            svc := NewUserService()

            got, err := svc.GetUser(1)

            assert.NoError(t, err)
            assert.Equal(t, 1, got.ID)
        })

        t.Run("returns error when not found", func(t *testing.T) {
            svc := NewUserService()

            got, err := svc.GetUser(999)

            assert.Error(t, err)
            assert.Nil(t, got)
        })
    })
}

// Avoid
func TestUserService_GetUser(t *testing.T) { /* ... */ }
```

### Test File Placement

Tests for `foo.go` live in `foo_test.go`. Don't create separate test files for individual functions — keep tests as siblings of the source they exercise.

### Table-Driven Tests

Use tables when cases share identical setup and assertions, varying only inputs and expected outputs:

```go
func TestArea(t *testing.T) {
    tests := []struct {
        name  string
        shape Shape
        want  float64
    }{
        {name: "rectangle", shape: Rectangle{12, 6}, want: 72.0},
        {name: "circle", shape: Circle{10}, want: 314.1592653589793},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            assert.InDelta(t, tt.want, tt.shape.Area(), 0.001)
        })
    }
}
```

Do not overstuff table tests with boolean flags like `shouldErr` or `mockReturnValue`. If cases need different setup or different assertions, use separate `t.Run` blocks instead.

### Mock Expectations

Be specific about expected arguments when setting up testify mocks. Avoid `mock.AnythingOfType` and other wildcard matchers — they weaken the test.

```go
// Prefer
r.On("Welcome", "World").Return("Hello World")

// Avoid
r.On("Welcome", mock.AnythingOfType("string")).Return("Hello World")
```

### Acceptance Tests

- Black-box only: use `package foo_test` to enforce tests only touch the public API
- Skip slow tests with `testing.Short()`: `if testing.Short() { t.Skip() }`
- Place acceptance tests next to `main()` in `cmd/`

## Design

### Dependency Injection

No DI frameworks. Accept interfaces as parameters, wire concrete implementations in `main()`.

- Prefer stdlib interfaces (`io.Writer`, `io.Reader`, `fs.FS`, `http.Handler`) before defining custom ones
- Keep custom interfaces minimal (1-2 methods)
- Inject behavior as functions when a full interface is overkill:

```go
type Sleeper struct {
    duration time.Duration
    sleep    func(time.Duration)
}
```

### Error Handling

- Define sentinel errors as package-level vars: `var ErrNotFound = errors.New("not found")`
- Test errors with `errors.Is` / `errors.As` — never match on error message strings
- Use custom error types when callers need structured data
- Use `t.Fatal` (not `t.Error`) when an unexpected error would cause a nil-pointer panic later in the test

### Filesystem Testing

Accept `fs.FS` instead of real file paths. Test with `fstest.MapFS`:

```go
fs := fstest.MapFS{
    "config.yaml": {Data: []byte("key: value")},
}
```
