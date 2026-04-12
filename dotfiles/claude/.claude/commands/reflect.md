---
description: Scan recent conversations across all projects, extract preferences and corrections, propose config updates, and clean up old logs
allowed-tools: [Bash, Read, Edit, Write, Glob, Grep]
---

Scan conversation logs from all Claude Code projects, extract user preferences and corrections, and propose updates to `~/.claude/CLAUDE.md`, principles, and skill files.

## Step 1: Extract user messages

Run this script to extract short user messages (where corrections and preferences live) from all conversation logs:

```bash
python3 -c "
import json, os, glob, time

cutoff_7d = time.time() - 7 * 86400
projects_dir = os.path.expanduser('~/.claude/projects')

for proj_dir in sorted(glob.glob(os.path.join(projects_dir, '*'))):
    proj_name = os.path.basename(proj_dir)
    jsonls = sorted(glob.glob(os.path.join(proj_dir, '*.jsonl')), key=os.path.getmtime)
    if not jsonls:
        continue
    print(f'\n=== {proj_name} ===')
    for jf in jsonls:
        mtime = os.path.getmtime(jf)
        age_days = (time.time() - mtime) / 86400
        session_id = os.path.basename(jf).replace('.jsonl', '')
        print(f'\n--- session {session_id[:8]} ({age_days:.0f}d ago) ---')
        with open(jf) as f:
            for line in f:
                obj = json.loads(line)
                if obj.get('type') != 'user':
                    continue
                msg = obj.get('message', {})
                content = msg.get('content', '')
                texts = []
                if isinstance(content, str):
                    texts.append(content)
                elif isinstance(content, list):
                    for block in content:
                        if isinstance(block, dict) and block.get('type') == 'text':
                            texts.append(block['text'])
                for t in texts:
                    clean = t.strip()
                    # Skip tool results, system messages, and long messages
                    if clean.startswith('{') or clean.startswith('<') or len(clean) > 300:
                        continue
                    if clean:
                        print(f'  > {clean}')
"
```

## Step 2: Read current config

1. Read `~/.claude/CLAUDE.md`
2. `Glob` for `~/.claude/principles/*.md` and `~/.claude/skills/*/SKILL.md`
3. Read all principle and skill files found

## Step 3: Identify patterns

From the extracted messages, look for:

- **Corrections** — "don't do X", "stop doing X", "not like that"
- **Confirmed approaches** — "yes", "perfect", "nice", "do it", user accepting a non-obvious choice
- **Explicit preferences** — commit style, naming, workflow, tool usage
- **Repeated patterns** — the same guidance appearing across multiple sessions

Ignore:
- One-off task instructions ("fix the bug in foo.go")
- Questions about code behavior
- Anything already captured in existing config

## Step 4: Propose changes

For each finding, decide where it belongs:

- **General preferences** (cross-language, workflow, style) → `~/.claude/CLAUDE.md`
- **Always-loaded principles** (programming, source-control, etc.) → the matching file under `~/.claude/principles/`. Create a new principle file if the topic doesn't fit existing ones.
- **Language/tool-specific preferences** → `~/.claude/skills/<name>/SKILL.md`. Create a new skill if one doesn't exist for the language/tool yet.

For each finding, show:

```
### [Add/Update]: <file path>

**What:** <the preference or rule>
**Evidence:** <quote the user message(s) that support this>

\`\`\`diff
+ <the line(s) to add>
\`\`\`
```

Wait for user confirmation before applying any changes.

## Step 5: Clean up old conversations

After changes are applied, list conversations older than 7 days and ask the user to confirm deletion:

```bash
python3 -c "
import os, glob, time

cutoff = time.time() - 7 * 86400
projects_dir = os.path.expanduser('~/.claude/projects')
old = []
for jf in glob.glob(os.path.join(projects_dir, '*', '*.jsonl')):
    if os.path.getmtime(jf) < cutoff:
        old.append(jf)

if old:
    print(f'Found {len(old)} conversation logs older than 7 days:')
    for f in sorted(old):
        print(f'  {f}')
else:
    print('No conversations older than 7 days.')
"
```

If the user confirms, delete them:

```bash
python3 -c "
import os, glob, time

cutoff = time.time() - 7 * 86400
projects_dir = os.path.expanduser('~/.claude/projects')
deleted = 0
for jf in glob.glob(os.path.join(projects_dir, '*', '*.jsonl')):
    if os.path.getmtime(jf) < cutoff:
        os.remove(jf)
        deleted += 1
        # Also remove companion directory if it exists
        companion = jf.replace('.jsonl', '')
        if os.path.isdir(companion):
            import shutil
            shutil.rmtree(companion)
print(f'Deleted {deleted} old conversation logs.')
"
```
