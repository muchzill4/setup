---
name: youtube-transcriber
description: Fetches a transcript for a YouTube video URL or ID and prints timestamped text, plain text, or JSON. Use when the user wants subtitles, captions, transcripts, or raw text from a YouTube video.
---

# Purpose

Retrieve a YouTube transcript in the requested format.

## Workflow

1. Run `python3 scripts/transcribe.py "<youtube-url-or-id>"` from this skill directory.
2. Use timestamped output by default. Use `--text-only` or `--json` only when requested, and `--language <code>` for a requested language; run `--help` for all options.
3. Return transcript output only. Do not summarize or analyze it unless the user asks.
4. On failure, state the cause briefly, such as unavailable captions, video restrictions, or a missing requested language. For a missing dependency, provide:

   ```bash
   python3 -m pip install --user youtube-transcript-api
   ```

## Validation

- Preserve the retrieved transcript content and timestamps.
- Do not claim that unavailable transcript content was retrieved.
