---
name: handoff
description: Condense the current session into a handoff document so a fresh session can continue the work. Use when the user asks for a handoff, to compact or summarize the session for later, to start over in a new session, or to move between phases such as shaping and implementation.
---

# Purpose

Let a new session continue the work from one document without the current conversation.

## Workflow

1. Write to the path the user names. Otherwise propose a path in the working repository and confirm it before writing.
2. Include only what the next session needs:
   - goal and success check;
   - decisions made, with brief reasons; link ADRs or plans rather than repeating them;
   - agreed shape: types, signatures, file placement, proving tests;
   - progress: completed slices, current slice status, and verification results;
   - open questions, known risks, and rejected approaches worth not retrying;
   - key files and review entry points;
   - the next step and its stop condition.
3. Base every item on the session or the repository. Mark assumptions as assumptions.
4. Prefer references to files and line ranges over pasted code. Omit discussion history.

## Validation

- A reader with only this document and the repository can state the next step and what is already settled.
- Writing a handoff does not authorize starting the next step.
