---
name: youtube-summary
description: Summarize YouTube videos from transcripts. Use when the user provides a YouTube URL and asks for a summary, notes, takeaways, timestamps, action items, or a focused explanation of the video.
---

# Purpose

Create a transcript-grounded summary of a YouTube video.

## Workflow

1. Obtain the transcript with the `youtube-transcriber` skill. If its instructions are not loaded, read `../youtube-transcriber/SKILL.md` first.
2. Ensure the retrieved transcript is complete enough for the request. If output points to a truncated temp file, read the full file in chunks. Do not summarize unretrieved portions.
3. Apply the user's requested focus and format. Otherwise provide a short overview, five key takeaways, notable timestamps, and action items or next steps.
4. Base claims and timestamps on the transcript. State when it is incomplete.
5. If retrieval fails, state the reason briefly and suggest a manual transcript when captions are unavailable.

## Validation

- Do not invent transcript content.
- Keep the summary proportional to the request.
