---
name: skill-builder
description: Create or improve an agent skill when the user asks to define, package, revise, or evaluate repeatable task-specific instructions, workflows, references, or scripts.
---

# Skill Creator

Create skills that are small, testable, and easy to maintain.

A skill is a folder containing:
- `SKILL.md`: concise runtime instructions
- optional `references/`: longer explanations, examples, schemas, checklists
- optional `scripts/`: executable helpers for repeatable work
- optional `examples/`: sample inputs and outputs

## Core workflow

1. Clarify the task only when required.
   - Ask at most one question if the user’s goal, target environment, or success criteria are unclear.
   - Otherwise make reasonable assumptions and proceed.

2. Define the skill contract.
   - What user requests should trigger the skill?
   - What inputs does it need?
   - What output should it produce?
   - What tools or files may it use?
   - What should it refuse or avoid?

3. Draft a minimal `SKILL.md`.
   - Keep runtime instructions short.
   - Put background, long examples, schemas, and edge cases in `references/`.
   - Prefer decision rules over prose.
   - Prefer checklists over paragraphs.
   - Avoid repeating rules already covered by the surrounding system.

4. Add supporting files only when useful.
   - Use `references/` for material the model should consult only sometimes.
   - Use `scripts/` for deterministic or repeated operations.
   - Use `examples/` when examples materially improve behavior.
   - Do not add files just to look complete.

5. Create evaluation prompts.
   Include:
   - positive trigger cases
   - negative trigger cases
   - easy normal cases
   - hard edge cases
   - one case that should be refused or redirected, if relevant

6. Test and revise.
   - Compare behavior with and without the skill when possible.
   - Check whether the skill improves output quality without causing over-triggering.
   - Remove instructions that do not improve the evals.
   - Prefer deletion over adding compensating instructions.

## `SKILL.md` quality bar

A good `SKILL.md` is:
- actionable
- short enough to read quickly
- specific about when to activate
- explicit about success criteria
- clear about tool/file boundaries
- free of motivational prose
- free of duplicated instructions
- supported by evals for non-obvious rules

## Instruction hygiene

For every non-obvious instruction, know why it exists.

Use this standard:

| Instruction type | Keep only if |
|---|---|
| trigger rule | it improves activation precision or recall |
| process step | it prevents a demonstrated failure |
| formatting rule | the output format matters to the user or downstream tooling |
| safety rule | it blocks a realistic unsafe or unauthorized behavior |
| example | it improves behavior beyond the written rule |
| script | it saves repeated effort or improves reliability |

Delete instructions that are obsolete, redundant, vague, or only stylistic.

## Output format

When creating a new skill, provide:

```text
skill-name/
  SKILL.md
  references/
  scripts/
  examples/
  evals/
