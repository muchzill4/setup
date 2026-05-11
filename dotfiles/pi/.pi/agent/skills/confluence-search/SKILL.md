---
name: confluence-search
description: Find internal Confluence pages using the local REST/CQL search helper. Use when the user asks to search Confluence or locate internal docs, runbooks, ADRs, decisions, designs, or operational knowledge.
---

# Confluence Search

Use the bundled `search.py` helper to search internal Confluence. Do not answer from memory when the user asks to find internal Confluence content.

## Use for

- Finding Confluence pages, runbooks, ADRs, design docs, meeting notes, or operational docs.
- Searching by keywords, space, content type, labels, recency, or raw CQL.
- Fetching short excerpts with `--content` to judge relevance.

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

1. Infer useful search terms and constraints from the user request.
2. Start broad, then narrow by space/type/CQL if results are noisy.
3. Use `--content` only when excerpts are needed for relevance or summary.
4. If results are poor, try synonyms, more results, title/label searches, or recency filters.
5. Report concise findings: title, space, link, relevance, and caveats.
6. In case of failure, state the blocker and required setup.

## Commands

```bash
{baseDir}/scripts/search.py "incident runbook" -n 10
{baseDir}/scripts/search.py "deployment" --space ENG
{baseDir}/scripts/search.py "architecture decision" --type page --content
{baseDir}/scripts/search.py --cql 'label = "adr" AND type = page ORDER BY lastmodified DESC'
```

Run `{baseDir}/scripts/search.py --help` for all options.
