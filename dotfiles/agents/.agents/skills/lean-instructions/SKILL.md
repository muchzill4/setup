---
name: lean-instructions
description: Write or revise concise instructions for AI agents. Use when creating or editing skills, AGENTS.md, CLAUDE.md, runbooks, or agent-facing reference docs.
---

# Lean Instructions

Write agent guidance that changes behavior with the fewest necessary words.

## Workflow

1. Identify the agent’s task, trigger, inputs, output, and completion condition.
2. Keep universal behavior in the harness or environment; document only local, non-obvious rules.
3. Write ordered, imperative steps. Use concrete paths, commands, and observable outcomes.
4. Put information where it is needed:
   - inline: required for every invocation;
   - referenced file: conditional, detailed, or bulky material.
5. Give each rule one authoritative home. Link rather than repeat.
6. Prune every line: remove it unless its absence would likely change agent behavior.
7. Review the result for ambiguity, stale facts, duplicated rules, and missing completion criteria.

## Structure

Prefer this shape:

```markdown
# Purpose

One-sentence outcome.

## Workflow

1. ...
2. ...

## Validation

- ...
```

Use examples only to resolve a real ambiguity. Keep references focused and state exactly when to read them.

## Principles

- Make trigger descriptions specific: say what the document enables and when it applies.
- Prefer positive instructions: state the desired action.
- Split by conditional branches, not merely length.
- Treat repository files, configuration, and command help as the source of truth; do not copy them unless lookup is genuinely costly.
- Favor a short, complete path over an exhaustive explanation.

## Final check

- Is every instruction actionable and task-specific?
- Is the completion condition observable?
- Can any line, heading, example, or duplicate be removed?
- Are referenced files necessary and reachable?
