---
name: reflect
description: Persist durable user preferences from Pi conversations into global or local AGENTS.md files or skill files. Use when the user asks to reflect, absorb, remember lessons/preferences, review conversations from a date/window, or update agent guidance.
---

# Reflect

Turn conversation evidence into durable, reusable agent guidance in the right instruction file.

## Input model

- No date/window/filter: use the current visible conversation by default.
- Date, date range, or relative window (`today`, `yesterday`, `2026-05-14`, `last week`, `7 days`, `2 hours`): inspect matching past Pi sessions.
- Topic/project/filter text: narrow evidence to relevant sessions or messages when possible.

Ask a brief clarifying question only when the requested scope is ambiguous enough that it could cause wrong edits or deletion.

## What to persist

Persist only durable behavior guidance:

- user preferences about collaboration, tone, planning, implementation, testing, or tool use
- repeated corrections or confirmed workflows
- project/repository conventions that future agents should follow
- language/tool/domain-specific agent behavior that belongs in an existing skill

Do not persist one-off task facts, secrets, credentials, transient project state, or guesses.

When evidence is weak, conflicting, or only implied, ask a focused follow-up or skip it.

## Placement

- General workflow, collaboration, tone, and tool preferences → `~/.pi/agent/AGENTS.md`.
- Project/repository-specific conventions, commands, or constraints → nearest relevant local/project `AGENTS.md`.
- Language/tool/domain-specific workflow → matching `~/.pi/agent/skills/<name>/SKILL.md`.
- New skills → only when clearly warranted and user-approved.

Prefer updating existing guidance over adding duplicates.

## Workflow

1. Determine scope from the user's free-form request.
2. Gather evidence:
   - current-context reflection: use the visible conversation;
   - past-date/window reflection: inspect Pi session logs under `~/.pi/agent/sessions/` using available shell tools. Session filenames begin with timestamps; directories encode working directories.
3. Extract only high-confidence candidates. Each candidate must have explicit evidence.
4. Discard or list uncertain candidates instead of persisting them.
5. Choose the narrowest correct destination; prefer existing guidance over duplicates.
6. Propose edits with destination, rationale, and a small diff/snippet.
7. Apply edits only after explicit approval of the proposed change.
8. Report files changed, why each destination was chosen, and skipped candidates with reasons.

## Proposal format

````markdown
### [Add/Update]: <file path>

**What:** <durable preference or rule>
**Why:** <how future agents should use it>
**Evidence:** "<short quote>" (<session/project if available>)

```diff
+ <line(s) to add>
```
````
