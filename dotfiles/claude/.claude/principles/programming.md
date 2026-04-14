# General Programming Principles

## Architecture: Functional Core, Imperative Shell

Split code into two layers:
- **Core:** pure functions that take values and return values. No I/O, no side effects, no dependencies to inject. Contains all decisions and business logic.
- **Shell:** thin orchestration layer that does I/O, holds mutable state, and wires values through the core. Almost no logic — if you want to test shell logic, that logic belongs in the core.

Values cross the boundary, not objects. The shell passes plain data to the core and acts on the returned values. This eliminates the need for mocking — there is nothing to mock.

## Testing

### TDD Workflow

The test is the first deliverable, not an afterthought.

1. Write a failing test
2. Run the test, see it fail, check the failure message reads well — fix the test before fixing the code
3. Write the minimum code to make the test pass
4. Refactor while green

For larger features, start with a failing acceptance test as a "north star", then drill into unit tests. The acceptance test stays red while building internals.

### Mocks are a design signal

If you need mocks to test something, the architecture is wrong. Restructure the code so the logic under test is pure and takes plain values. Mock only at hard architectural boundaries (network, database, filesystem, time).

Never mock internal collaborators or domain objects. Never verify that specific internal methods were called — that couples tests to implementation and breaks during refactoring.

### What to test where

- **Unit tests (the core):** fast, no I/O, plain values in, values out. This is where the bulk of tests live.
- **Integration tests (the shell):** verify wiring works against real external systems. Test very little business logic here — just that the pieces connect.
- **Avoid the middle layer:** tests that mock collaborators to test logic are the worst of both worlds. They are slow to write, brittle to maintain, and miss real integration bugs.

### Slow tests are a design issue

Slow tests mean poor separation of logic from effects. Fix the structure, not the parallelism.

### Minimal test diffs

When adding a test for a fix, add a new test case or function. Don't touch existing passing tests unrelated to the change.

## Refactoring

### Two Hats

You are either adding functionality or refactoring — never both at once. When refactoring, add no new behavior. When adding features, resist restructuring. Swap hats frequently, but always know which you are wearing.

### Make the change easy, then make the easy change

Before implementing a feature, restructure existing code so the feature becomes trivial to add.

### Tolerate duplication over the wrong abstraction

Prefer duplicated code over a premature shared module. The wrong abstraction is more expensive to undo than duplication is to merge later.

### Mixed abstraction levels are the real smell

A method at one level of abstraction is fine regardless of length. A short method mixing policy and mechanism is worse. Refactor to separate abstraction levels, not to hit a line count.

## Code Style

- Use early returns to reduce nesting
- Delete unused code aggressively — it is a liability, not an asset
- Comments explain *why*, never *what* or *how*. If code needs a *what* comment, rewrite the code instead

## Design

### YAGNI applies to features, not quality

Don't build features on speculation, but always invest in clean structure and good naming. Don't pre-create empty directories or add dependencies speculatively.

### Reversibility as heuristic

Easy-to-reverse decisions: make the simplest choice now. Hard-to-reverse decisions (public APIs, data formats): invest more thought upfront.

### Indirection has a cost

Every layer of abstraction costs comprehension. Only add indirection when it enables a change you need now. Speculative generality — one implementation behind an interface, hooks never overridden — is a smell to be removed.

## UI Development

### Functionality before aesthetics

Build the interaction loop with raw, unstyled HTML first. Add styling as a separate pass
once the behavior is correct. When styling IS the task, match the reference exactly.

### Prefer server-side over client-side

Minimize client-side JavaScript. Prefer server-rendered HTML and server-side validation.
Use hypermedia approaches (htmx) over JS frameworks when possible.

## Plans and TODOs

Tick off plan items and TODOs as each is completed, not in batches at the end.

## Assertions and Invariants

Assert preconditions, postconditions, and invariants — not just in tests, but in production code. Assertions convert silent corruption into loud, debuggable failures.

- Assert both what you expect and what you do not expect
- Split compound assertions: `assert(a); assert(b)` not `assert(a && b)`
- Every branch should be accounted for: an unhandled else is a bug waiting to happen

## Control Flow

- Push branching up and loops down. Parent functions handle control flow; leaf functions are branch-free and pure.
- State conditions positively: `if index < length` not `if !(index >= length)`
- Put hard upper bounds on loops and queues. Unbounded iteration is a latent bug.

## Error Handling

- Assertions are for programmer errors. The correct response to corrupt internal state is to crash, not to recover gracefully.
- Simplify return types: prefer returning nothing over a bool, a bool over an error, a concrete value over an optional. Complex return types propagate virally.
