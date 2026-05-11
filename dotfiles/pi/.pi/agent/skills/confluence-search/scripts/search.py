#!/usr/bin/env python3
"""Search an on-prem Confluence instance via REST CQL.

Authentication is read from environment variables:
  CONFLUENCE_BASE_URL=https://confluence.example.com
  CONFLUENCE_PAT=...                         # preferred when available
  CONFLUENCE_USERNAME=... CONFLUENCE_PASSWORD=...
"""

from __future__ import annotations

import argparse
import base64
import html
import json
import os
import re
import sys
import textwrap
from html.parser import HTMLParser
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode, urljoin
from urllib.request import Request, urlopen


class HTMLTextExtractor(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.parts: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag in {"br", "p", "div", "li", "tr", "h1", "h2", "h3", "h4", "h5", "h6"}:
            self.parts.append("\n")

    def handle_data(self, data: str) -> None:
        self.parts.append(data)

    def text(self) -> str:
        value = html.unescape("".join(self.parts))
        value = re.sub(r"[ \t\r\f\v]+", " ", value)
        value = re.sub(r"\n\s*\n+", "\n", value)
        return value.strip()


def die(message: str, exit_code: int = 1) -> None:
    print(f"Error: {message}", file=sys.stderr)
    sys.exit(exit_code)


def auth_headers() -> dict[str, str]:
    headers = {
        "Accept": "application/json",
        "User-Agent": "pi-confluence-search/1.0",
    }

    pat = os.environ.get("CONFLUENCE_PAT")
    if pat:
        headers["Authorization"] = f"Bearer {pat}"
        return headers

    username = os.environ.get("CONFLUENCE_USERNAME")
    password = os.environ.get("CONFLUENCE_PASSWORD")
    if username and password:
        token = base64.b64encode(f"{username}:{password}".encode()).decode()
        headers["Authorization"] = f"Basic {token}"
        return headers

    die("set CONFLUENCE_PAT, or both CONFLUENCE_USERNAME and CONFLUENCE_PASSWORD")
    raise AssertionError("unreachable")


def request_json(url: str) -> dict[str, Any]:
    req = Request(url, headers=auth_headers())
    try:
        with urlopen(req, timeout=30) as response:
            return json.loads(response.read().decode("utf-8"))
    except HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        details = body[:1000].strip()
        die(f"Confluence returned HTTP {exc.code} for {url}\n{details}")
    except URLError as exc:
        die(f"could not reach Confluence: {exc.reason}")
    except json.JSONDecodeError as exc:
        die(f"Confluence did not return JSON: {exc}")
    raise AssertionError("unreachable")


def cql_quote(value: str) -> str:
    return '"' + value.replace('\\', '\\\\').replace('"', '\\"') + '"'


def build_cql(args: argparse.Namespace) -> str:
    if args.cql:
        return args.cql

    if not args.query:
        die("provide search terms or --cql")

    clauses = [f"text ~ {cql_quote(args.query)}"]
    if args.space:
        clauses.append(f"space = {cql_quote(args.space)}")
    if args.content_type:
        clauses.append(f"type = {cql_quote(args.content_type)}")
    return " AND ".join(clauses) + " ORDER BY lastmodified DESC"


def content_text(result: dict[str, Any]) -> str:
    body = result.get("body") or {}
    rendered = body.get("view", {}).get("value") or body.get("storage", {}).get("value") or ""
    if not rendered:
        return ""
    parser = HTMLTextExtractor()
    parser.feed(rendered)
    return parser.text()


def truncate(value: str, width: int = 800) -> str:
    value = value.strip()
    if len(value) <= width:
        return value
    return value[: width - 1].rstrip() + "…"


def web_url(base_url: str, result: dict[str, Any]) -> str:
    links = result.get("_links") or {}
    webui = links.get("webui") or links.get("tinyui")
    if webui:
        return urljoin(base_url.rstrip("/") + "/", webui.lstrip("/"))
    return ""


def format_result(base_url: str, result: dict[str, Any], index: int, include_content: bool) -> str:
    space = result.get("space") or {}
    version = result.get("version") or {}
    lines = [
        f"--- Result {index} ---",
        f"Title: {result.get('title', '(untitled)')}",
        f"Type: {result.get('type', 'unknown')}",
    ]

    if space:
        lines.append(f"Space: {space.get('key', '')} - {space.get('name', '')}".rstrip(" -"))
    if version.get("when"):
        lines.append(f"Last Modified: {version['when']}")

    url = web_url(base_url, result)
    if url:
        lines.append(f"Link: {url}")

    if include_content:
        text = truncate(content_text(result))
        if text:
            lines.append("Content:")
            lines.append(textwrap.indent(text, "  "))

    return "\n".join(lines)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Search Confluence using CQL")
    parser.add_argument("query", nargs="?", help="search terms; converted to CQL text search")
    parser.add_argument("--cql", help="raw CQL query to run")
    parser.add_argument("-n", "--limit", type=int, default=5, help="number of results (default: 5)")
    parser.add_argument("--space", help="restrict to a Confluence space key")
    parser.add_argument("--type", dest="content_type", help="restrict to a content type, e.g. page or blogpost")
    parser.add_argument("--content", action="store_true", help="include rendered body text excerpts")
    parser.add_argument("--base-url", help="override CONFLUENCE_BASE_URL")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if args.limit < 1:
        die("--limit must be at least 1")

    base_url = (args.base_url or os.environ.get("CONFLUENCE_BASE_URL") or "").strip().rstrip("/")
    if not base_url:
        die("set CONFLUENCE_BASE_URL or pass --base-url")

    cql = build_cql(args)
    expand = "space,version"
    if args.content:
        expand += ",body.view"

    endpoint = base_url + "/rest/api/content/search?" + urlencode(
        {"cql": cql, "limit": str(args.limit), "expand": expand}
    )

    data = request_json(endpoint)
    results = data.get("results", [])
    if not results:
        print(f"No Confluence results for CQL: {cql}")
        return

    print(f"CQL: {cql}")
    print()
    print("\n\n".join(format_result(base_url, result, idx, args.content) for idx, result in enumerate(results, 1)))


if __name__ == "__main__":
    main()
