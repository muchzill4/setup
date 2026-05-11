---
name: reflect
description: Persist durable user preferences from Pi conversations into ~/.pi/agent/AGENTS.md or skill files. Use when the user asks to reflect, absorb, remember lessons/preferences, review recent sessions, update agent guidance from conversation history, or explicitly prune old Pi session logs.
---

# Reflect

Review conversations for reusable guidance and update the agent's persistent instructions only with durable, evidence-backed preferences.

## Modes

- **Absorb mode**: no argument, or wording like "absorb this" / "remember from this chat". Review the current conversation only.
- **Reflect mode**: a time window like `7 days`, `2 hours`, or `30 minutes`. Scan recent session logs across projects.
- **Cleanup mode**: only when the user explicitly asks to delete or prune old session logs.

## Core rules

- Persist behavior guidance, not project facts.
- Prefer small, concrete rules the agent can apply in future sessions.
- Do not add secrets, credentials, private operational details, or one-off task context.
- Do not duplicate guidance that already exists in `~/.pi/agent/AGENTS.md` or relevant skill files.
- Propose edits before applying unless the user explicitly requested direct edits.
- Require explicit confirmation before deleting any session files.
- If evidence is ambiguous, present it as a skipped candidate or ask one clarifying question instead of writing a rule.

## What counts as durable guidance

Keep candidates that are at least one of:

- An explicit preference: "always...", "prefer...", "don't...", "use X instead of Y".
- A correction or pushback that should change future behavior.
- A confirmed workflow, style, or tool choice that is likely reusable.
- A repeated pattern across sessions.

Discard:

- One-off implementation instructions.
- Codebase-specific facts that belong in project docs.
- Troubleshooting details, temporary decisions, or resolved bugs.
- Vague praise without a specific repeatable behavior.

## Placement

- Cross-language workflow, collaboration, tone, and general tool preferences → `~/.pi/agent/AGENTS.md`.
- Language/tool/domain-specific guidance → the matching `~/.pi/agent/skills/<name>/SKILL.md`.
- New skill files → only if the preference clearly needs a distinct reusable workflow and the user approves creating it.

## Script paths

Helper scripts live in `scripts/` relative to this `SKILL.md`. Resolve these paths from the skill directory when running them.

## Absorb mode workflow

1. Use the visible conversation as evidence.
2. Read `~/.pi/agent/AGENTS.md`.
3. List `~/.pi/agent/skills/` and read only skill files relevant to the candidate guidance.
4. Identify up to 5 high-confidence durable updates; if none, say so and stop.
5. Propose changes with evidence and destination files.
6. After approval, apply the accepted edits.

## Reflect mode workflow

1. Extract recent user messages:

   ```bash
   python3 scripts/extract-messages.py "<time window>"
   ```

   Pass the user's window exactly, e.g. `"7 days"`.

2. Read current guidance:
   - `~/.pi/agent/AGENTS.md`
   - relevant skill files from `~/.pi/agent/skills/`
   - use search/listing first; avoid reading unrelated large files unless needed to check duplicates.

3. Extract durable candidates using the rules above.
4. Group similar evidence across sessions before proposing an edit.
5. Propose changes in this format:

   ````markdown
   ### [Add/Update]: <file path>

   **What:** <durable preference or rule>
   **Why:** <how future agents should use it>
   **Evidence:** "<short quote>" (<session/project if available>)

   ```diff
   + <line(s) to add>
   ```
   ````

6. Wait for user confirmation, then apply only the approved changes.

## Cleanup mode

Use only when the user explicitly asks to prune or delete old session files.

Preview first:

```bash
python3 scripts/delete-sessions.py --dry-run "<time window>"
```

If files are listed, ask for explicit confirmation. Only then run:

```bash
python3 scripts/delete-sessions.py "<time window>"
```

## Reporting

End with:

- Files changed, or "No durable updates found".
- A short reason each change belongs where it was placed.
- Any candidate guidance intentionally skipped because it was one-off, duplicate, or too ambiguous.
