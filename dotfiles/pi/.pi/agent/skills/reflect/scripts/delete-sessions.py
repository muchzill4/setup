#!/usr/bin/env python3
"""
List or delete Pi session files older than a given time window.

Usage:
  delete-sessions.py [--dry-run] <duration>

Examples:
  delete-sessions.py --dry-run "7 days"
  delete-sessions.py "7 days"
"""

from __future__ import annotations

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


def parse_duration(text: str) -> int:
    pattern = r"(\d+)\s*(" + "|".join(UNITS.keys()) + r")"
    match = re.search(pattern, text.lower())
    if not match:
        print(f"Error: could not parse duration '{text}'", file=sys.stderr)
        print("Expected something like: '7 days', '2 hours', '30 minutes'", file=sys.stderr)
        sys.exit(1)
    return int(match.group(1)) * UNITS[match.group(2)]


def old_session_files(sessions_dir: Path, cutoff: float) -> list[Path]:
    if not sessions_dir.exists():
        return []
    files = [path for path in sessions_dir.glob("*/*.jsonl") if path.stat().st_mtime < cutoff]
    return sorted(files, key=lambda path: path.stat().st_mtime)


def main() -> None:
    args = sys.argv[1:]
    dry_run = "--dry-run" in args
    args = [arg for arg in args if arg != "--dry-run"]

    if not args:
        print("Usage: delete-sessions.py [--dry-run] <duration>", file=sys.stderr)
        sys.exit(1)

    duration_secs = parse_duration(" ".join(args))
    cutoff = time.time() - duration_secs
    sessions_dir = Path.home() / ".pi" / "agent" / "sessions"
    files = old_session_files(sessions_dir, cutoff)

    if not files:
        print("No session files older than the given window.")
        return

    if dry_run:
        print(f"Found {len(files)} session file(s) older than the given window:")
        for path in files:
            age_days = (time.time() - path.stat().st_mtime) / 86400
            print(f"  {path}  ({age_days:.0f}d old)")
        return

    for path in files:
        path.unlink()
    print(f"Deleted {len(files)} session file(s).")


if __name__ == "__main__":
    main()
