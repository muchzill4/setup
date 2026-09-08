---
name: pr-description
description: Generate a ready-to-paste pull request title and description from git branch changes. Use when the user asks for a PR/MR title, description, body, summary, or pull request text for the current branch or a specified branch.
---

# Purpose

Produce a concise, paste-ready PR title and description grounded in the branch diff.

## Workflow

1. Determine the repository and base branch; default to the current directory and infer the base when possible. Ask one concise question if it cannot be inferred.
2. Gather read-only evidence: branch and status, merge-base, commit summary, changed files, and diff statistics. Exclude uncommitted changes unless the user asks to include them.
3. Read a repository PR/MR template if present. Inspect targeted diffs only when the summary evidence is insufficient.
4. Write the title and body from that evidence. Do not invent tests, tickets, reviewers, deployment notes, screenshots, or risk claims.
5. Do not create, push, or update a PR unless separately asked.

## Output

Return only:

```text
Title: <single-line PR title>

Description:
<ready-to-paste PR body>
```

If no template exists, use `## Summary` and `## Changes` headings in the body.

## Validation

- Reflect the requested branch diff and repository template.
- Include no preamble, commentary, or code fences outside the required body content.
