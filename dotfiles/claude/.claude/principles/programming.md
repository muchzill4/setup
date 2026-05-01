# General Programming Principles

## Architecture: Functional Core, Imperative Shell

Split code into two layers:
- **Core:** pure functions that take values and return values. No I/O, no side effects, no dependencies to inject. Contains all decisions and business logic.
- **Shell:** thin orchestration layer that does I/O, holds mutable state, and wires values through the core. Almost no logic — if you want to test shell logic, that logic belongs in the core.

Values cross the boundary, not objects. The shell passes plain data to the core and acts on the returned values.

## Code Style

- Use early returns to reduce nesting
- Delete unused code aggressively — it is a liability, not an asset
- Comments explain *why*, never *what* or *how*. If code needs a *what* comment, rewrite the code instead

## Design

### Resist speculation

YAGNI applies to features, but not to quality — always invest in clean structure and good naming. Don't pre-create empty directories or add dependencies you don't yet need.

Every layer of indirection costs comprehension. Add it only when it enables a change you need now. One implementation behind an interface, hooks never overridden, premature shared modules — all are smells. Tolerate duplication over the wrong abstraction; duplication is cheaper to merge later than a bad abstraction is to undo.

### Reversibility as heuristic

Easy-to-reverse decisions: make the simplest choice now. Hard-to-reverse decisions (public APIs, data formats): invest more thought upfront.

## UI Development

### Functionality before aesthetics

Build the interaction loop with raw, unstyled HTML first. Add styling as a separate pass
once the behavior is correct. When styling IS the task, match the reference exactly.

### Prefer server-side over client-side

Minimize client-side JavaScript. Prefer server-rendered HTML and server-side validation.
Use hypermedia approaches (htmx) over JS frameworks when possible.

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
