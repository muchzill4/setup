---
name: tdd
description: Test-driven development for features and fixes using a small red-green-refactor loop. Use when the user asks for TDD, test-first work, bug fixes with regression tests, integration tests, or implementing tasks via tests.
---

# Test-Driven Development

Use TDD to change behaviour safely: write or update one failing test, make it pass with the smallest useful change, then refactor if needed.

## Defaults

- Do not change code unless the user explicitly asked to implement, fix, build, or modify.
- Inspect relevant files before editing.
- Prefer behaviour tests through public interfaces.
- Mock external systems and nondeterminism, not internal collaborators.
- Keep test diffs minimal; do not rewrite unrelated passing tests.
- Do not mix refactoring with behaviour changes unless asked.
- Use the smallest useful verification command after each change.

## Workflow

1. **Understand the behaviour**
   - Read any task/spec/bug report the user provided.
   - Find existing test conventions, commands, and similar tests.
   - Identify the public interface or user-visible behaviour to exercise.

2. **Plan briefly**
   - State the first behaviour to test.
   - State the test entry point and likely command.
   - Mention likely implementation areas and anything intentionally out of scope.
   - Ask one focused question if the expected behaviour or interface is unclear.

3. **Red**
   - Add or update one test for one observable behaviour.
   - Run the narrowest test command.
   - Let the failure guide you: it may be a compile/type error first.
   - Confirm it fails for the expected reason.

4. **Green**
   - Make the smallest change to get back to green.
   - Hard-coded or simple code is fine if it proves the path.
   - Do not add speculative behaviour for future tests.
   - Run the same narrow test command.

5. **Repeat**
   - Add the next behaviour only after the previous test is green.
   - Do not write all tests first and all code later.

6. **Refactor**
   - Refactor only while green.
   - Keep behaviour unchanged.
   - Run tests after refactoring.

7. **Verify and report**
   - Run relevant tests, plus lint/typecheck/build when appropriate and available.
   - Summarize behaviour changed, tests added/updated, commands run, and any follow-ups.

## Design and test quality

- Test what the system does, not how it is implemented.
- Verify behaviour through public interfaces.
- Prefer fakes or real test dependencies over mocks when practical.
- Mock external systems and nondeterminism, not internal collaborators.
- Pass hard-boundary dependencies in; do not construct them deep inside business logic.
- Design boundary interfaces around domain operations.
- Prefer returning values/results over hidden side effects when designing new code.
- Treat tests as the first user of the API; awkward tests may signal awkward design.
- Assertions should compare meaningful results, preferably whole values when stable.
- During refactor, look for duplication, long functions, shallow modules, and misplaced logic.
