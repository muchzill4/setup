---
name: brave-search
description: Web search and content extraction via Brave Search API. Use for searching documentation, facts, or public web content.
---

# Purpose

Retrieve and cite public web evidence without a browser.

## Workflow

1. Use local files, provided context, or already-read documentation when they answer the request; otherwise search the web.
2. Never include secrets, proprietary code, internal identifiers, or sensitive personal data in a query. Ask the user to redact needed context first.
3. Use `{baseDir}/content.js <url>` for a known page; otherwise use `{baseDir}/search.js "<query>" -n 5`. Use `--content`, `--freshness`, or `--country` only when needed. Run `--help` for all options.
4. Prefer primary and authoritative sources. Refine weak results with narrower terms, a domain, date constraints, or an alternate source.
5. Corroborate claims the user may act on when feasible.
6. Answer directly, summarize rather than dump command output, and cite each web-derived claim with its source link.
7. On failure, state the blocker and try an alternate query or accessible source when useful. If `BRAVE_API_KEY` is missing, say that Brave Search is not configured and offer:

   ```bash
   export BRAVE_API_KEY="your-api-key-here"
   cd {baseDir} && npm install
   ```

## Validation

- Distinguish verified facts from uncertainty and note recency when it matters.
- Keep citations close to the claims they support.
