---
name: skill-builder
description: Create, improve, evaluate, or refactor agent skills. Use when the user asks to make a new skill, update a SKILL.md, design skill routing, add progressive disclosure references/scripts, or review a skill for quality.
---

# Skill Builder

Build high-quality agent skills that are small, well-routed, reusable, and easy to iterate.

## Core rules

- Do **not** create or edit files until the user explicitly asks to create, implement, install, update, or modify a skill.
- Before designing or editing skills, identify the target agent/harness and try to read its skill construction, discovery, and validation documentation. If no harness-specific docs are available, fall back to the Agent Skills standard and clearly note assumptions.
- Skill names must be lowercase letters, numbers, and hyphens only; no leading/trailing hyphen; no consecutive hyphens; max 64 characters; the `name` frontmatter must match the parent directory.
- Descriptions are routing rules for the model. Make them specific about when to use the skill.
- Keep `SKILL.md` concise. Put long rubrics, examples, API notes, and templates in `references/` and instruct the agent when to load them.
- Prefer constraints and success criteria over brittle step-by-step micromanagement.
- Use scripts when facts must be deterministic or repeatable.
- Never include secrets or credentials in a skill.

## Workflow

### 1. Understand the desired skill

Work from the conversation context first. If important details are missing, ask concise questions before drafting.

Gather:

- Skill purpose and target users
- Trigger phrases / situations where the skill should load
- What the skill must produce or accomplish
- Required inputs and expected outputs
- Constraints, safety rules, and things to avoid
- Whether the skill needs scripts, references, templates, or examples
- Where it should be installed: global `~/.pi/agent/skills`, project `.pi/skills`, or another harness-specific path

### 2. Score confidence before implementation

Before creating files, estimate confidence from 0-100 using this rubric:

- Purpose clarity
- Routing / trigger clarity
- Output clarity
- Constraint clarity
- File location clarity
- Reference/script needs clarity

If confidence is below 90, ask targeted questions. If confidence is 90 or above and the user explicitly asked to create/implement, proceed.

### 3. Design the skill shape

For simple skills, create only:

```text
<skill-name>/
└── SKILL.md
```

For richer skills, use progressive disclosure:

```text
<skill-name>/
├── SKILL.md
├── references/
│   ├── rubric.md
│   └── examples.md
└── scripts/
    └── helper.py
```

Load detailed guidance only when relevant. Example: "If evaluating an existing skill, read `references/quality-rubric.md`."

### 4. Draft `SKILL.md`

A good `SKILL.md` includes:

- Frontmatter with `name` and `description`
- A short mission statement
- Routing or mode selection if the skill handles multiple tasks
- Inputs to inspect
- Workflow steps
- Constraints / safety rules
- Output format
- Pointers to references/scripts using relative paths

Read `references/templates.md` if you need starter templates.

### 5. Evaluate the draft

Before finalizing, check the skill against `references/quality-rubric.md`.

The minimum bar:

- The description clearly tells the model when to use the skill
- The workflow is actionable but not over-prescriptive
- The skill asks clarifying questions when needed
- Long context is moved to references
- Scripts are documented with exact usage if included
- File paths are correct for the target harness

### 6. Create or update files

When creating a new skill, you may use the scaffold script:

```bash
python3 <skill-dir>/scripts/scaffold.py <skill-name> --root ~/.pi/agent/skills --description "Use when ..."
```

Then edit the generated files with the finalized content.

When updating an existing skill, read the current `SKILL.md` and nearby references first. Preserve useful existing behavior unless the user asks to replace it.

### 7. Report back

Summarize:

- Files created or changed
- Why the description should route correctly
- How to invoke/test the skill, e.g. `/skill:<name>` or a natural-language trigger
- Any follow-up improvements or eval ideas
