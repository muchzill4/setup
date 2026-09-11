---
name: explore
description: Explore a new product idea, an uncertain change, or a confusing implementation through concrete examples before choosing an approach. Use when the user wants to explore alternatives, clarify behavior, or reconsider a design—not implement it.
---

# Purpose

Resolve the uncertainty that matters most to the next step, not every future design question.

## Workflow

1. Inspect relevant code and docs. Establish the desired outcome and, for an existing product, what should change and what should remain.
2. Identify the uncertainty most likely to change the approach. Investigate facts available from code or docs rather than asking the user.
3. Make the uncertainty concrete with a user journey, sample data, mockup sketch, or short end-to-end code sketch. Show the simplest plausible approach; add an alternative only when it exposes a meaningful tradeoff.
4. Challenge consequential assumptions with a counterexample or experiment. Ask at most three blocking questions per round; defer questions unrelated to the next decision.
5. Separate user decisions, recommendations, and unresolved assumptions. Revise the example after answers rather than expanding into an exhaustive questionnaire.

## Stop

Stop once the user can choose an approach or the next experiment. Summarize the recommendation, key tradeoff, and decision needed; do not advance automatically to implementation.

Remain read-only unless the user explicitly authorizes a bounded prototype or experiment. If authorized, agree on its scope and stop condition before building it; do not silently promote it into production code.
