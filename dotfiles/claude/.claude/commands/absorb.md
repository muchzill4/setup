---
description: Review this conversation and update ~/.claude/CLAUDE.md and skill files with learned preferences
allowed-tools: [Read, Edit, Write, Glob]
---

Review our conversation and update `~/.claude/CLAUDE.md` and relevant skill files with any preferences, conventions, or guidance that should persist across future sessions.

## What to look for

- Naming conventions or code style preferences the user expressed or confirmed
- Commit message style or workflow preferences
- Things the user corrected or pushed back on (patterns to avoid)
- Things the user explicitly approved or asked you to keep doing
- Language-specific conventions for any language we worked with
- Tool usage preferences (e.g. specific CLI flags, libraries, frameworks)

## What NOT to add

- Anything already present in CLAUDE.md or an existing skill file
- Project-specific context that doesn't generalize (save that to the project's memory instead)
- Temporary or one-off decisions
- Implementation details that belong in code comments

## Where preferences belong

- **General preferences** (cross-language, workflow, style) → `~/.claude/CLAUDE.md`
- **Language/tool-specific preferences** → the matching skill file under `~/.claude/skills/<name>/SKILL.md`

## Instructions

1. Read the current `~/.claude/CLAUDE.md`
2. List all existing skill files with `Glob` for `~/.claude/skills/*/SKILL.md`
3. Read any skill files that may be relevant to the conversation
4. Identify 1–5 concrete, generalizable things from our session worth persisting
5. For each preference, decide where it belongs (see above)
6. Propose all changes to the user before applying them — show what you'd add or edit and in which file. This includes content changes, frontmatter updates (e.g. broadening `description` or `paths`), and new skill files
7. Wait for user confirmation, then apply the approved changes
