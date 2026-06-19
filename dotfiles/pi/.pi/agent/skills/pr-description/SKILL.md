---
name: pr-description
description: Generate a ready-to-paste pull request title and description from git branch changes. Use when the user asks for a PR/MR title, description, body, summary, or pull request text for the current branch or a specified branch.
---

# PR Description Writer

## Goal

Produce a succinct PR title and body that reflect the branch diff and, when present, follow the repository's pull request template.

## Workflow

1. Determine the target repository and base branch; default to the current working directory and infer the base when not supplied.
2. Gather read-only git evidence for the committed branch changes:
   - current branch and status
   - merge-base against the base branch
   - commit summary
   - changed files and diff stats
3. Look for a repository PR/MR template and follow it if present.
4. Inspect targeted diffs only when the summary evidence is insufficient. Avoid dumping raw diffs.
5. Produce a concise, paste-ready title and body grounded only in the evidence.
6. If no template is found, use this compact body:

   ```markdown
   ## Summary

   <one or two concise paragraphs summarizing the change>

   ## Changes

   - ...
   ```

## Constraints

- Ground the title and body in git evidence; do not invent tests, tickets, reviewers, deployment notes, screenshots, or risk claims.
- Exclude uncommitted changes unless the user explicitly asks to include them.
- Ask one concise clarifying question if no base branch can be inferred.
- Do not create, push, or update a PR unless separately asked.

## Output format

Return only:

```text
Title: <single-line PR title>

Description:
<ready-to-paste PR body>
```

No code fences, preamble, commentary, or explanation.
