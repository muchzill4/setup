---
name: slice
description: Scope, delegate, or implement one reviewable behavior and deliberately stop. Use when the user wants the next bounded change, one todo at a time, or a task another agent can execute against agreed boundaries.
---

# Purpose

Deliver one change the user can meaningfully verify before more work accumulates.

## Workflow

1. Inspect code, tests, docs, and working-tree changes. Identify the requested behavior and applicable contracts; preserve unrelated work. Reuse settled decisions rather than requiring exploration or redesign for every task.
2. Define a compact slice: observable behavior, scope, behavior to preserve, exclusions, dependencies or shared contracts, and a few acceptance checks. Split broad todos until the change is independently reviewable; commit-sized alone is not sufficient.
3. If planning or delegating, present the slice and stop. For delegation, include relevant paths, owned changes, verification commands, and the same stop condition; identify shared-file coordination needs.
4. Implement only with explicit authorization for this scope. If the request already authorizes a sufficiently bounded change, proceed without asking again. Otherwise present the slice for approval.
5. Test the promised behavior, preferring a failing regression or acceptance test before implementation where practical. Follow project test conventions. Keep unrelated improvements outside the slice.
6. Pause if the work requires expanding scope or changing agreed contracts. Explain the conflict and propose the smallest revision; do not silently add abstractions or compensating patches.
7. Verify acceptance checks and preserved behavior. For UI work, exercise the visible interaction when possible; distinguish browser verification from unit or rendering tests. Report anything not verified.

## Stop

After verification, report the behavior delivered, changed files and review entry points, check results, and remaining limitations. Stop on blockers with the decision needed.

Do not begin another todo, fold in side quests, or create commits without explicit authorization. Suggesting a next step does not authorize taking it.
