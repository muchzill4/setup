# Global defaults

## Communication
- Be concise by default.
- State what changed and why; do not claim improvement without concrete justification.
- If requirements are ambiguous, ask a focused clarifying question instead of guessing.

## Change discipline
- Do not mix refactoring with behavior changes unless the user asks for both.
- Prefer small, targeted edits over broad rewrites.
- Before changing code, inspect the relevant files first.

## Programming
- Prefer a functional core and imperative shell: put logic in pure functions, keep I/O and orchestration thin.
- Use early returns to reduce nesting.
- Delete unused code aggressively.
- Comments should explain why, not what.

## Design
- Avoid speculative abstractions and unnecessary dependencies.
- Prefer simple, reversible choices unless the decision is hard to undo.
- Keep levels of abstraction separate within a function.

## Testing
- For bug fixes and features, prefer writing or updating a failing test first.
- Mock only at hard boundaries such as network, database, filesystem, or time.
- Keep test diffs minimal; do not rewrite unrelated passing tests.

## Validation
- After changes, propose or run the smallest useful verification step.
- Match the repo’s existing commit and workflow conventions before suggesting commits.
