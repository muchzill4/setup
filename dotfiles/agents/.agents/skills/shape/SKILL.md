---
name: shape
description: Propose reviewable implementation boundaries for an understood behavior. Use when the user wants to agree domain types, component responsibilities, state ownership, or shared interfaces before implementation or parallel delegation.
---

# Purpose

Agree on consequential boundaries while leaving local implementation choices open.

## Workflow

1. Inspect relevant code, tests, and docs. Identify the behavior being enabled and existing conventions to preserve. For an existing product, describe the structural delta rather than redesigning unaffected parts.
2. Show the minimum relevant domain types and component or package responsibilities. Name who owns state and its transitions.
3. Trace one concrete end-to-end call path through those components. Justify each new abstraction by a current responsibility; omit pass-through layers and speculative extension points.
4. Specify exact shared signatures where the next implementation or parallel tasks must agree. Leave internal choices open. Identify compatibility or migration implications when relevant.
5. Present one compact proposal: types, ownership, call path, shared contracts, explicit exclusions, and unresolved decisions. Omit sections that do not affect the change; use code sketches where clearer than prose.
6. For parallel work, identify independent components and shared-change ownership. Require proposed contract revisions to return for agreement rather than being made independently by each agent.

## Stop

Present the shape for approval and stop. Approval of a design alone is not authorization to implement or write documentation.

If the behavior itself is unsettled, identify the blocking question and return to exploration. If existing boundaries already suffice, say so; do not invent a redesign or require another approval ceremony.
