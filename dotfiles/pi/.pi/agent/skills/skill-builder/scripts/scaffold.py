#!/usr/bin/env python3
"""Create a basic Agent Skills compatible skill skeleton."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

NAME_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")


def validate_name(name: str) -> None:
    if len(name) > 64:
        raise SystemExit(f"Invalid skill name: {name!r} is longer than 64 characters")
    if not NAME_RE.match(name):
        raise SystemExit(
            "Invalid skill name: use lowercase letters, numbers, and single hyphens; "
            "no leading/trailing hyphen or consecutive hyphens"
        )


def main() -> None:
    parser = argparse.ArgumentParser(description="Create a skill skeleton")
    parser.add_argument("name", help="Skill name, e.g. repo-roast")
    parser.add_argument(
        "--root",
        default="~/.pi/agent/skills",
        help="Skills root directory (default: ~/.pi/agent/skills)",
    )
    parser.add_argument(
        "--description",
        default=None,
        help="Skill description/routing rule for frontmatter",
    )
    parser.add_argument(
        "--with-references",
        action="store_true",
        help="Create references/ directory with a notes file",
    )
    parser.add_argument(
        "--with-scripts",
        action="store_true",
        help="Create scripts/ directory with a placeholder README",
    )
    args = parser.parse_args()

    validate_name(args.name)

    root = Path(args.root).expanduser()
    skill_dir = root / args.name
    skill_file = skill_dir / "SKILL.md"

    if skill_file.exists():
        raise SystemExit(f"Refusing to overwrite existing skill: {skill_file}")

    description = args.description or f"Use when the user asks to {args.name.replace('-', ' ')}."
    if len(description) > 1024:
        raise SystemExit("Description is longer than 1024 characters")

    skill_dir.mkdir(parents=True, exist_ok=False)
    skill_file.write_text(
        f"""---
name: {args.name}
description: {description}
---

# {args.name.replace('-', ' ').title()}

## Goal

TODO: Describe the repeatable task this skill handles.

## Workflow

1. TODO: Gather required context.
2. TODO: Perform the task.
3. TODO: Verify or summarize the result.

## Constraints

- TODO: Add important rules and things to avoid.

## Output

Return:

- TODO: Define the expected output format.
""",
        encoding="utf-8",
    )

    if args.with_references:
        references = skill_dir / "references"
        references.mkdir()
        (references / "notes.md").write_text(
            "# Notes\n\nAdd long-form guidance here and load it only when needed.\n",
            encoding="utf-8",
        )

    if args.with_scripts:
        scripts = skill_dir / "scripts"
        scripts.mkdir()
        (scripts / "README.md").write_text(
            "# Scripts\n\nDocument helper scripts here.\n",
            encoding="utf-8",
        )

    print(skill_file)


if __name__ == "__main__":
    main()
