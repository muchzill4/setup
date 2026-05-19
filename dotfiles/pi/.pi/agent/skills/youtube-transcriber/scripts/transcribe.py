#!/usr/bin/env python3
import argparse
import json
import re
import sys
import warnings
from urllib.parse import parse_qs, urlparse

warnings.filterwarnings(
    "ignore",
    message=r"urllib3 v2 only supports OpenSSL 1\.1\.1\+",
)


def extract_video_id(value: str) -> str:
    value = value.strip()
    if re.fullmatch(r"[A-Za-z0-9_-]{11}", value):
        return value

    parsed = urlparse(value)
    host = parsed.netloc.lower()
    path = parsed.path.strip("/")

    if host in {"youtu.be", "www.youtu.be"} and path:
        candidate = path.split("/")[0]
        if re.fullmatch(r"[A-Za-z0-9_-]{11}", candidate):
            return candidate

    if host.endswith("youtube.com") or host.endswith("youtube-nocookie.com"):
        if path == "watch":
            candidate = parse_qs(parsed.query).get("v", [""])[0]
            if re.fullmatch(r"[A-Za-z0-9_-]{11}", candidate):
                return candidate

        parts = path.split("/")
        if len(parts) >= 2 and parts[0] in {"embed", "shorts", "live", "v"}:
            candidate = parts[1]
            if re.fullmatch(r"[A-Za-z0-9_-]{11}", candidate):
                return candidate

    raise ValueError(f"Could not extract a YouTube video ID from: {value}")


def format_timestamp(seconds: float) -> str:
    total = max(0, int(seconds))
    hours, rem = divmod(total, 3600)
    minutes, secs = divmod(rem, 60)
    if hours:
        return f"{hours:02d}:{minutes:02d}:{secs:02d}"
    return f"{minutes:02d}:{secs:02d}"


def to_segment_dicts(fetched):
    segments = []
    for item in fetched:
        text = getattr(item, "text", None)
        start = getattr(item, "start", None)
        duration = getattr(item, "duration", None)
        if text is None and isinstance(item, dict):
            text = item.get("text")
            start = item.get("start")
            duration = item.get("duration")
        segments.append(
            {
                "text": (text or "").replace("\n", " ").strip(),
                "start": float(start or 0),
                "duration": float(duration or 0),
            }
        )
    return segments


def main() -> int:
    parser = argparse.ArgumentParser(description="Fetch a YouTube transcript")
    parser.add_argument("url", help="YouTube URL or video ID")
    parser.add_argument(
        "--language",
        action="append",
        dest="languages",
        default=[],
        help="Preferred transcript language. Repeatable.",
    )
    parser.add_argument("--json", action="store_true", help="Emit JSON")
    parser.add_argument(
        "--text-only",
        action="store_true",
        help="Emit plain text without timestamps",
    )
    args = parser.parse_args()

    try:
        video_id = extract_video_id(args.url)
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 2

    try:
        from youtube_transcript_api import YouTubeTranscriptApi
    except ImportError:
        print(
            "Missing dependency: youtube-transcript-api\n"
            "Install it with: python3 -m pip install --user youtube-transcript-api",
            file=sys.stderr,
        )
        return 2

    api = YouTubeTranscriptApi()
    languages = args.languages or ["en"]

    try:
        fetched = api.fetch(video_id, languages=languages, preserve_formatting=True)
        segments = to_segment_dicts(fetched)
    except Exception as exc:
        print(f"Could not fetch transcript for {args.url}: {exc}", file=sys.stderr)
        return 1

    full_text = "\n".join(segment["text"] for segment in segments if segment["text"])

    if args.json:
        print(
            json.dumps(
                {
                    "url": args.url,
                    "video_id": video_id,
                    "languages": languages,
                    "full_text": full_text,
                    "segments": segments,
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 0

    if args.text_only:
        print(full_text)
        return 0

    print(f"YouTube URL: {args.url}")
    print(f"Video ID: {video_id}")
    print()
    for segment in segments:
        if not segment["text"]:
            continue
        print(f"[{format_timestamp(segment['start'])}] {segment['text']}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
