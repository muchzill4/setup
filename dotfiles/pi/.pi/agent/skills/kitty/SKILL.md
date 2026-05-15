---
name: kitty
description: Launch interactive, long-running, or user-facing commands in separate Kitty tabs/windows. Use for editors, REPLs, debuggers, dev servers, log tails, watchers, or commands the user should interact with outside the agent terminal.
---

# Kitty

Use Kitty when a command would block the agent session or needs user interaction. Do not use it for ordinary commands whose stdout/stderr the agent should capture.

## Requirements

Kitty remote control must work:

```bash
command -v kitty && kitty @ ls >/dev/null
```

If unavailable, report that and use normal tools or ask for guidance.

## Launch rule

Always launch commands through the user's shell so environment setup is available:

```bash
kitty @ launch --type=tab --cwd "$(pwd)" --title "<title>" "$SHELL" -c '<command>'
```

Use `--keep-focus` when the agent should continue working immediately:

```bash
kitty @ launch --keep-focus --type=tab --cwd "$(pwd)" --title "<title>" "$SHELL" -c '<command>'
```

Use `--type=window` only when a separate OS window is clearly useful.

## Examples

```bash
kitty @ launch --type=tab --cwd "$(pwd)" --title "nvim" "$SHELL" -c 'nvim path/to/file'
kitty @ launch --keep-focus --type=tab --cwd "$(pwd)" --title "dev server" "$SHELL" -c 'npm run dev'
kitty @ launch --type=tab --cwd "$(pwd)" --title "logs" "$SHELL" -c 'tail -f logs/app.log'
```

## Notes

- Quote user-provided paths/args carefully inside the shell command.
- Launching returns immediately; ongoing output is not captured.
- Destructive or privileged commands still require confirmation.
