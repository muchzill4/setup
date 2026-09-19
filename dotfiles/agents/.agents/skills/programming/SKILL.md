---
name: programming
description: Read before creating or modifying code.
---

# Programming conventions

- Keep code understandable. If a change adds special cases to tangled or overly coupled code, flag the maintainability risk and propose a bounded refactoring. Do not refactor without approval.
- Keep changes easy to review. Prefer small, cohesive modules with clear boundaries. Call out logic that becomes difficult to follow.
- Make only the smallest coherent change within the requested scope. Do not add incidental refactors, formatting, cleanup, or speculative follow-up work.
- Prefer direct code over pass-through helpers, wrapper types, and speculative extension points. Introduce abstractions or defensive machinery for a concrete responsibility or failure mode, not hypothetical future use.

# Commit conventions

- Do not create or amend commits unless the user explicitly asks.
- When suggesting a commit message, inspect the staged diff first; if nothing is staged, state which diff you are describing. Use an uppercase sentence-style subject without a semantic prefix or trailing period.
- Before committing, summarize the files and commit message.
- Create only the requested commit. Never force-push or rewrite existing commits unless explicitly asked.

# Go conventions

- Place tests in the source file's corresponding `_test.go` file. Tests exercising an API defined in `health.go` belong in `health_test.go`, regardless of the feature being described or whether the test package uses the `_test` suffix.
- For functions, use `TestFunctionName`, with `t.Run()` for scenarios.
- For methods, use `TestTypeName`, then `t.Run("MethodName")`, then scenario subtests. Do not put method scenarios directly under `TestTypeName`.
- Use Arrange Act Assert ordering, separated by blank lines. Do not add `// Arrange`, `// Act`, or `// Assert` comments:
    ```go
    func TestNormalizeName(t *testing.T) {
        name := "  ada lovelace  "

        got := NormalizeName(name)

        want := "Ada Lovelace"
        assert.Equal(t, want, got)
    }
    ```
- Prefer small, focused tests. Keep distinct behaviors separate rather than combining them into a large table or test with extensive setup.
- Test observable behavior, not constructor wiring or static membership unless that wiring is itself a contract. Avoid re-testing guarantees owned by another component.
- Prefer complete literal `want :=` over reconstructing expected output using the implementation's algorithm.
- Keep unit tests independent of real commands, network access, and host configuration; use fakes.

