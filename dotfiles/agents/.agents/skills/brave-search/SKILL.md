---
name: brave-search
description: Web search and content extraction via Brave Search API. Use for searching documentation, facts, or any web content. Lightweight, no browser required.
---

# Brave Search

General-purpose web retrieval using Brave Search API and readable page extraction. No browser required.

## When to Use

Use this skill when the user needs web information, including:
- current facts, news, prices, releases, or availability
- documentation, API references, articles, pages, or public web content
- content extraction from a specific URL
- corroboration from external sources

Do not use web search when local project files, provided context, or already-read docs are sufficient.

Do not put secrets, private tokens, proprietary code, internal identifiers, or sensitive personal data into web search queries. If such context is needed, ask before searching and redact it first.

## Retrieval Workflow

1. Choose the smallest useful action:
   - known URL → use `content.js`
   - unknown source → start with `search.js "query" -n 5`
   - current/recent info → add `--freshness`
   - source text needed → add `--content` or extract selected URLs with `content.js`
2. Prefer authoritative sources: official docs, primary sources, standards, vendor pages, reputable publications.
3. Iterate if results are weak: refine query terms, add site/domain terms, adjust freshness/country, or search for specific error messages.
4. For factual answers, corroborate important claims when possible.
5. Always include source links/citations in the final answer.
6. Summarize findings; do not dump raw command output unless the user asks.
7. If search or extraction fails, state the failure briefly and try an alternate query/source when useful.

## Search

```bash
{baseDir}/search.js "query"                         # Basic search (5 results)
{baseDir}/search.js "query" -n 10                   # More results (max 20)
{baseDir}/search.js "query" --content               # Include page content as markdown
{baseDir}/search.js "query" --freshness pw          # Results from last week
{baseDir}/search.js "query" --freshness 2024-01-01to2024-06-30  # Date range
{baseDir}/search.js "query" --country DE            # Results from Germany
{baseDir}/search.js "query" -n 3 --content          # Combined options
```

### Options

- `-n <num>` - Number of results (default: 5, max: 20)
- `--content` - Fetch and include page content as markdown
- `--country <code>` - Two-letter country code (default: US)
- `--freshness <period>` - Filter by time:
  - `pd` - Past day (24 hours)
  - `pw` - Past week
  - `pm` - Past month
  - `py` - Past year
  - `YYYY-MM-DDtoYYYY-MM-DD` - Custom date range

## Extract Page Content

```bash
{baseDir}/content.js https://example.com/article
```

Fetches a URL and extracts readable content as markdown.

## Failure Handling

- Missing `BRAVE_API_KEY`: tell the user Brave Search is not configured and include the setup command below.
- API quota/rate limit/error: report the HTTP error and, if possible, proceed from existing context.
- Extraction failure: use the search snippet, try another source, or explain that the page could not be extracted.
- JS-heavy/paywalled pages may not extract cleanly; prefer accessible alternatives.

Setup if needed:

```bash
export BRAVE_API_KEY="your-api-key-here"
cd {baseDir}
npm install
```

## Output Format

```
--- Result 1 ---
Title: Page Title
Link: https://example.com/page
Age: 2 days ago
Snippet: Description from search results
Content: (if --content flag used)
  Markdown content extracted from the page...

--- Result 2 ---
...
```

## Final Response Requirements

- Answer the user's question directly.
- Include source links for all web-derived answers.
- Distinguish verified facts from uncertainty.
- Mention recency when it matters.
- Keep citations close to the claims they support.
