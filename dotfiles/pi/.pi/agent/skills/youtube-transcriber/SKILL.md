---
name: youtube-transcriber
description: Fetches a transcript for a YouTube video URL or ID and prints timestamped text, plain text, or JSON. Use when the user wants subtitles, captions, transcripts, or raw text from a YouTube video.
---

# YouTube Transcriber

Fetch transcripts from YouTube videos.

## Setup

```bash
python3 -m pip install --user youtube-transcript-api
```

## Usage

Run relative to this skill directory:

```bash
python3 scripts/transcribe.py "<youtube-url-or-id>"
```

Flags:

```bash
--text-only
--json
--language en --language de
```

## Notes

- Prefer timestamped output unless the user asks for plain text or JSON.
- Produce transcript output only; do not summarize or analyze unless explicitly asked.
- If retrieval fails, briefly explain why: disabled captions, unavailable video, restricted video, or missing requested language.
