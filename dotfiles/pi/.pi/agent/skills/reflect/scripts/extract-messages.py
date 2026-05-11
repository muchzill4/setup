#!/usr/bin/env python3
"""
Extract user messages from Pi session logs within a given time window.

Usage:
  extract-messages.py <duration>

Examples:
  extract-messages.py "7 days"
  extract-messages.py "2 hours"
  extract-messages.py "30 minutes"
"""

from __future__ import annotations

import json
import re
import sys
import time
from pathlib import Path


UNITS = {
    "second": 1,
    "seconds": 1,
    "minute": 60,
    "minutes": 60,
    "hour": 3600,
    "hours": 3600,
    "day": 86400,
    "days": 86400,
    "week": 604800,
    "weeks": 604800,
    "month": 2592000,
    "months": 2592000,
}

MAX_MESSAGE_CHARS = 1200
SKIP_PREFIXES = (
    "<tool_result",
    "<tool_use",
    "<system-reminder",
    "<environment",
)


def parse_duration(text: str) -> int:
    pattern = r"(\d+)\s*(" + "|".join(UNITS.keys()) + r")"
    match = re.search(pattern, text.lower())
    if not match:
        print(f"Error: could not parse duration '{text}'", file=sys.stderr)
        print("Expected something like: '7 days', '2 hours', '30 minutes'", file=sys.stderr)
        sys.exit(1)
    return int(match.group(1)) * UNITS[match.group(2)]


def format_age(secs: float) -> str:
    if secs < 3600:
        return f"{secs / 60:.0f}m ago"
    if secs < 86400:
        return f"{secs / 3600:.1f}h ago"
    return f"{secs / 86400:.0f}d ago"


def extract_texts(content) -> list[str]:
    if isinstance(content, str):
        return [content]
    if isinstance(content, list):
        return [
            block["text"]
            for block in content
            if isinstance(block, dict)
            and block.get("type") == "text"
            and isinstance(block.get("text"), str)
        ]
    return []


def normalize_message(text: str) -> str | None:
    clean = re.sub(r"\s+", " ", text.strip())
    if not clean:
        return None
    if clean.lower().startswith(SKIP_PREFIXES):
        return None
    if len(clean) > MAX_MESSAGE_CHARS:
        clean = clean[:MAX_MESSAGE_CHARS].rstrip() + " … [truncated]"
    return clean


def iter_session_files(sessions_dir: Path, cutoff: float) -> list[Path]:
    if not sessions_dir.exists():
        return []
    files = [path for path in sessions_dir.glob("*/*.jsonl") if path.stat().st_mtime >= cutoff]
    return sorted(files, key=lambda path: (path.parent.name, path.stat().st_mtime))


def main() -> None:
    if len(sys.argv) < 2:
        print("Usage: extract-messages.py <duration>", file=sys.stderr)
        sys.exit(1)

    duration_secs = parse_duration(" ".join(sys.argv[1:]))
    cutoff = time.time() - duration_secs
    sessions_dir = Path.home() / ".pi" / "agent" / "sessions"

    current_project = None
    for session_file in iter_session_files(sessions_dir, cutoff):
        project_name = session_file.parent.name
        session_id = session_file.stem
        age_str = format_age(time.time() - session_file.stat().st_mtime)
        messages: list[str] = []

        with session_file.open(encoding="utf-8") as handle:
            for line in handle:
                try:
                    obj = json.loads(line)
                except json.JSONDecodeError:
                    continue

                if obj.get("type") != "message":
                    continue
                message = obj.get("message", {})
                if message.get("role") != "user":
                    continue

                for text in extract_texts(message.get("content", "")):
                    clean = normalize_message(text)
                    if clean:
                        messages.append(clean)

        if not messages:
            continue

        if project_name != current_project:
            print(f"\n=== {project_name} ===")
            current_project = project_name

        print(f"\n--- session {session_id[:8]} ({age_str}) ---")
        for message in messages:
            print(f"  > {message}")


if __name__ == "__main__":
    main()
