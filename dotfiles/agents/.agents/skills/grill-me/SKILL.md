---
name: grill-me
description: Stress-test the user's plan, design, or idea. Use when the user asks to be grilled, challenged, interrogated, pressure-tested, or walked through hard design questions against code or docs.
---

# Purpose

Reach shared understanding by testing every material design decision.

## Workflow

1. Model the decisions as a design tree. The frontier is the questions whose prerequisites are settled.
2. Research facts the agent can determine; do not ask the user for knowable information. Do not delay a round for pending research, but defer questions that depend on it.
3. Ask the complete frontier in each round, numbered, with a recommended answer:

   ```markdown
   **Q1: <title>**
   <question>

   **Recommended:** <answer>

   ---
   ```

4. After the user's answers, update the tree and ask the newly unblocked frontier. Defer dependent questions until their prerequisites are settled.
5. Let the user make decisions; do not act on the plan while grilling.

## Completion

Stop only when the frontier is empty, every branch was considered, and no material decision remains assumed. Act only after the user confirms shared understanding.
