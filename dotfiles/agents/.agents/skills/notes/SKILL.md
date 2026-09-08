---
name: notes
description: Search, read, summarize, synthesize, and, when explicitly requested, create or edit the user's local Markdown notes at ~/Notes. Use when the user asks to find, review, create, or update their notes.
---

# Purpose

Answer from Markdown notes in `~/Notes`; change a note only on explicit request.

## Workflow

1. Search Markdown files under `~/Notes`, following symlinks. Exclude vault configuration, version-control, and trash directories unless relevant.
2. Read only the sections needed for the request. Follow `[[internal links]]` only when they add needed context.
3. Attribute note-derived facts with a note-relative path and heading. Label conclusions that synthesize multiple notes, and report material gaps or conflicts.
4. For an edit, confirm the target and intended change when either is ambiguous. Make only the requested change and report the changed path.

## Validation

- Do not claim content from unreadable files.
- Leave `~/Notes` unchanged without an explicit edit request.
