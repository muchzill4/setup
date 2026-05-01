# Testing

## TDD Workflow

The test is the first deliverable, not an afterthought.

1. Write a failing test
2. Run the test, see it fail, check the failure message reads well — fix the test before fixing the code
3. Write the minimum code to make the test pass
4. Refactor while green

For larger features, start with a failing acceptance test as a "north star", then drill into unit tests. The acceptance test stays red while building internals.

## Mocks are a design signal

If you need mocks to test something, the architecture is wrong. Restructure the code so the logic under test is pure and takes plain values. Mock only at hard architectural boundaries (network, database, filesystem, time).

Never mock internal collaborators or domain objects. Never verify that specific internal methods were called — that couples tests to implementation and breaks during refactoring.

## What to test where

- **Unit tests (the core):** fast, no I/O, plain values in, values out. This is where the bulk of tests live.
- **Integration tests (the shell):** verify wiring works against real external systems. Test very little business logic here — just that the pieces connect.
- **Avoid the middle layer:** tests that mock collaborators to test logic are the worst of both worlds. They are slow to write, brittle to maintain, and miss real integration bugs.

## Slow tests are a design issue

Slow tests mean poor separation of logic from effects. Fix the structure, not the parallelism.

## Minimal test diffs

When adding a test for a fix, add a new test case or function. Don't touch existing passing tests unrelated to the change.
