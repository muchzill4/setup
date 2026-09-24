---
name: slice
description: Scope, delegate, or implement one reviewable behavior and deliberately stop. Use for requests such as "next step", "implement step N", "one todo at a time", "small atomic commits", "self-contained changes", or "stop after each step so I can review", and for bounded tasks delegated to another agent. Apply even when the user does not name this skill.
---

# Purpose

Deliver one change the user can meaningfully verify before more work accumulates.

## Workflow

1. Identify the next behavior and applicable contracts from existing code and plans. Reuse settled decisions rather than requiring exploration or redesign for every task.
2. Define a compact slice: observable behavior, scope, behavior to preserve, exclusions, dependencies or shared contracts, and a few acceptance checks. Split broad todos until the change is independently reviewable; commit-sized alone is not sufficient.
3. If planning or delegating, present the slice and stop. For delegation, include relevant paths, owned changes, verification commands, and the same stop condition; identify shared-file coordination needs.
4. Implement only with explicit authorization for this scope. If the request already authorizes a sufficiently bounded change, proceed without asking again. Otherwise present the slice for approval.
5. For implementation, follow the `programming` skill. Pause if delivery requires expanding scope or changing agreed contracts; propose the smallest revision for approval.
6. Verify acceptance checks and preserved behavior. State what each form of verification actually proves: plumbing tests do not establish model quality, and component tests do not establish end-to-end integration. For UI work, exercise the visible interaction when possible; distinguish browser verification from unit or rendering tests. Explicitly report missing production wiring and real-system validation; do not claim the promised behavior is complete without evidence.

## Stop

After verification, report the behavior delivered, changed files and review entry points, check results, and remaining limitations. Stop on blockers with the decision needed.

Do not begin another todo without explicit authorization. Suggesting a next step does not authorize taking it.
