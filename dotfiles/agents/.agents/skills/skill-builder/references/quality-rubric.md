# Skill Quality Rubric

Use this rubric when reviewing, improving, or finalizing a skill.

## 1. Routing quality

A strong description answers:

- What task does this skill perform?
- When should the model use it?
- What user wording or situation should trigger it?

Good:

```yaml
description: Create architecture decision records from codebase context and team discussion notes. Use when the user asks to document an ADR, capture an architectural decision, or summarize tradeoffs into an ADR format.
```

Weak:

```yaml
description: Helps with docs.
```

## 2. Scope control

A strong skill has a clear boundary.

Check:

- Does it say what is in scope?
- Does it say what is out of scope or dangerous?
- Does it avoid taking over unrelated tasks?

## 3. Workflow usefulness

The workflow should be actionable without being brittle.

Prefer:

- Short phases
- Clear decision points
- Explicit output formats
- Constraints and verification steps

Avoid:

- Huge generic checklists
- Repeating obvious agent behavior
- Overriding project/user instructions
- Long background essays in `SKILL.md`

## 4. Progressive disclosure

Use references when content is long or conditional.

Move these to `references/`:

- Long examples
- Rubrics
- API docs
- Style guides
- Migration guides
- Domain background

`SKILL.md` should tell the agent when to read each reference.

## 5. Determinism and scripts

Use scripts when the skill needs repeatable facts or transformations.

Good script uses:

- Searching files with fixed rules
- Extracting git history
- Parsing structured documents
- Validating generated output
- Calling a stable API wrapper

For every script, document:

- When to run it
- Exact command
- Expected inputs
- Expected output
- Failure handling

## 6. Interaction quality

A strong skill asks questions only when needed.

Check:

- Does it define what information is required?
- Does it use confidence scoring or a decision gate for ambiguous tasks?
- Does it proceed when enough context exists?
- Does it avoid interrogation for simple tasks?

## 7. Safety and maintenance

Check:

- No secrets or credentials are embedded
- Destructive commands require explicit confirmation
- File paths are relative where possible
- Harness-specific assumptions are stated
- The skill can evolve without becoming a dumping ground

## Final score

Score each category 0-2:

1. Routing quality
2. Scope control
3. Workflow usefulness
4. Progressive disclosure
5. Determinism/scripts
6. Interaction quality
7. Safety/maintenance

Interpretation:

- 12-14: Ship it
- 9-11: Usable, but improve the weak areas
- 6-8: Needs revision before regular use
- 0-5: Redesign the skill
