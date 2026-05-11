---
name: youtube-summary
description: Summarize YouTube videos from transcripts. Use when the user provides a YouTube URL and asks for a summary, notes, takeaways, timestamps, action items, or a focused explanation of the video.
---

# YouTube Summary

## Workflow

When the user provides a YouTube URL:

1. Use the `youtube-transcriber` skill to obtain the transcript.
   - If the transcriber instructions are not already loaded, read the sibling skill at `../youtube-transcriber/SKILL.md` if available.
   - Follow the transcriber skill's usage and failure-handling instructions.
2. Ensure the transcript is complete enough to summarize.
   - If command output is truncated and points to a temp file, read the full temp file in chunks before summarizing.
   - Do not summarize portions of the video that were not retrieved.
3. Identify the user's requested focus, if any.
   - Examples: technical insights, business insights, beginner-friendly explanation, concise summary, detailed notes, how-to steps, critique, implementation ideas.
4. Summarize using the user's requested format, or this default format:
   - Short overview
   - 5 key takeaways
   - Notable timestamps
   - Action items or next steps

## Constraints

- Do not invent transcript content.
- Base claims on the retrieved transcript.
- Use actual transcript timestamps for notable moments.
- If the transcript is incomplete, clearly say what was available.
- Keep the summary proportional to the user's request: concise by default, detailed when asked.
- Do not duplicate the transcriber implementation; delegate transcript retrieval to `youtube-transcriber`.

## Failure handling

- If transcript retrieval fails, briefly explain why.
- Common causes: subtitles disabled, unavailable video, region/age restriction, no transcript in the requested language.
- Suggest that the user provide a manual transcript if subtitles are unavailable.
