---
name: confluence-search
description: Find internal Confluence pages using the local REST/CQL search helper. Use when the user asks to search Confluence or locate internal docs, runbooks, ADRs, decisions, designs, or operational knowledge.
---

# Confluence Search

Use the bundled `search.py` helper to search internal Confluence. Do not answer from memory when the user asks to find internal Confluence content.

## Use for

- Finding Confluence pages, runbooks, ADRs, design docs, meeting notes, or operational docs.
- Searching by keywords, space, content type, labels, recency, title, or other Confluence CQL fields.
- Fetching short excerpts with `--content` to judge relevance or summarize a small set of likely matches.

Do not use for public web search, Jira, or unrelated internal systems.

## Requirements

The operator environment must have Confluence network access, usually VPN, and credentials in environment variables:

```bash
CONFLUENCE_BASE_URL
CONFLUENCE_PAT
# or CONFLUENCE_USERNAME + CONFLUENCE_PASSWORD
```

Never ask the user to paste credentials into chat.

## Workflow

1. Convert the request into explicit Confluence CQL. Pass the CQL as the required positional argument.
2. Start broad with `text ~ "..."`, then narrow with `space`, `type`, `title`, `label`, or `lastmodified` when results are noisy.
3. Prefer `ORDER BY lastmodified DESC` unless another ordering is clearly better.
4. Use `--content` only for a few likely matches when excerpts are needed for relevance or summary.
5. If results are poor, try synonyms, title search, label search, broader/narrower spaces, higher `-n`, or recency filters.
6. Report concise findings: title, space, link, last modified, relevance, CQL used when helpful, and caveats.
7. Do not dump large internal excerpts. Prefer links plus brief relevance notes.
8. In case of failure, state the blocker and required setup, such as VPN/network access, missing environment variables, or authorization errors.

## CQL recipes

```text
text ~ "incident runbook" ORDER BY lastmodified DESC
title ~ "deployment" AND type = page ORDER BY lastmodified DESC
text ~ "architecture decision" AND label = "adr" AND type = page ORDER BY lastmodified DESC
text ~ "release" AND space = "ENG" ORDER BY lastmodified DESC
text ~ "postmortem" AND lastmodified >= "2025-01-01" ORDER BY lastmodified DESC
```

## Commands

```bash
{baseDir}/scripts/search.py 'text ~ "incident runbook" ORDER BY lastmodified DESC' -n 10
{baseDir}/scripts/search.py 'text ~ "deployment" AND space = "ENG" ORDER BY lastmodified DESC'
{baseDir}/scripts/search.py 'text ~ "architecture decision" AND type = page ORDER BY lastmodified DESC' --content
{baseDir}/scripts/search.py 'label = "adr" AND type = page ORDER BY lastmodified DESC'
```

Run `{baseDir}/scripts/search.py --help` for all options.
