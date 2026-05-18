---
name: kitty
description: Launch interactive, long-running, or user-facing commands in separate Kitty tabs/windows. Use for editors, REPLs, debuggers, dev servers, log tails, watchers, or commands the user should interact with outside the agent terminal.
---

# Kitty

Use Kitty to start commands the user should interact with or watch outside the agent terminal.

## Use Kitty for

- editors: `nvim`, `vim`, `$EDITOR`
- REPLs, debuggers, shells, database consoles
- dev servers, workers, queues, watch-mode tests
- log tails and monitoring commands
- long-running commands where captured output is not needed

## Do not use Kitty for

- quick one-shot commands
- commands whose stdout/stderr the agent needs to inspect
- ordinary file inspection or search
- destructive or privileged commands without explicit confirmation

## Preflight

Before the first launch in a session, verify Kitty remote control works:

```bash
command -v kitty && kitty @ ls >/dev/null
```

If unavailable, say so and use normal tools or ask the user what to do.

## Launch pattern

Launch through the user's shell so their environment is loaded:

```bash
kitty @ launch --type=tab --cwd "$(pwd)" --title "<short title>" "$SHELL" -c '<command>'
```

Use `--keep-focus` when the agent should continue working immediately:

```bash
kitty @ launch --keep-focus --type=tab --cwd "$(pwd)" --title "<short title>" "$SHELL" -c '<command>'
```

Use `--type=window` only when a separate OS window is clearly useful.

## Command construction

- Set `--cwd` to the relevant project or file directory; default to current working directory.
- Use short, recognizable tab titles like `dev server`, `nvim`, `logs`, `pytest watch`.
- Quote user-provided paths and arguments defensively.
- Prefer simple literal commands; avoid interpolating untrusted text into `"$SHELL" -c`.
- Remember: launch returns immediately and output is not captured by the agent.

## After launching

Tell the user:

- what command was launched
- where it was launched
- the tab/window title
- if relevant, how to stop it, usually `Ctrl-C` in the Kitty tab

## Examples

```bash
kitty @ launch --type=tab --cwd "$(pwd)" --title "nvim" "$SHELL" -c 'nvim path/to/file'
kitty @ launch --keep-focus --type=tab --cwd "$(pwd)" --title "dev server" "$SHELL" -c 'npm run dev'
kitty @ launch --keep-focus --type=tab --cwd "$(pwd)" --title "logs" "$SHELL" -c 'tail -f logs/app.log'
kitty @ launch --type=tab --cwd "$(pwd)" --title "rails console" "$SHELL" -c 'bin/rails console'
```
