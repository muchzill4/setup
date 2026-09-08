---
name: confluence-search
description: Find internal Confluence pages using the local REST/CQL search helper. Use when the user asks to search Confluence or locate internal docs, runbooks, ADRs, decisions, designs, or operational knowledge.
---

# Purpose

Find and summarize relevant internal Confluence content with the bundled search helper.

## Workflow

1. Use this skill only for Confluence content; do not answer a request to find Confluence material from memory.
2. Never ask the user to paste credentials. The environment needs Confluence network access plus `CONFLUENCE_BASE_URL` and either `CONFLUENCE_PAT` or `CONFLUENCE_USERNAME` and `CONFLUENCE_PASSWORD`.
3. Convert the request to CQL. Start broad with `text ~ "..."`, then narrow with `space`, `type`, `title`, `label`, or `lastmodified`; prefer `ORDER BY lastmodified DESC` unless another ordering fits better.
4. Run `{baseDir}/scripts/search.py '<cql>' -n 10`. Use `--content` only for a few likely matches; run `--help` for options.
5. If results are weak, try synonyms, title or label search, different spaces, a larger result limit, or recency filters.
6. Report each useful result with its title, space, link, last-modified date, and brief relevance. Include CQL when helpful; link rather than quote large internal excerpts.
7. On failure, state the blocker and required setup, such as VPN access, missing environment variables, or authorization.

## CQL examples

```text
text ~ "incident runbook" ORDER BY lastmodified DESC
title ~ "deployment" AND type = page ORDER BY lastmodified DESC
text ~ "architecture decision" AND label = "adr" ORDER BY lastmodified DESC
```

## Validation

- Use only retrieved Confluence content for findings.
- Keep internal excerpts to the minimum needed to establish relevance.
