---
name: kitty
description: Kitty terminal integration for launching commands in new tabs or windows. Use when running interactive terminal programs without blocking the current Pi terminal session.
---

# Kitty Terminal Integration

Use Kitty remote control to launch commands in a separate Kitty tab or window, especially interactive tools such as Neovim, REPLs, debuggers, or long-running processes.

## Requirements

- Kitty must be the terminal emulator.
- The `kitty` CLI must be available in PATH.
- Kitty remote control must be enabled for `kitty @ ...` commands to work.

Typical Kitty config:

```conf
allow_remote_control yes
```

More restrictive setups may use a configured remote-control socket. If `kitty @ ...` fails, check the user's Kitty config before relying on this skill.

## Launch in a New Tab

Run a command in a new Kitty tab using the current working directory:

```bash
kitty @ launch --type=tab --cwd "$(pwd)" <command> <args...>
```

Example:

```bash
kitty @ launch --type=tab --cwd "$(pwd)" nvim -d old.txt new.txt
```

## Launch in a New Window

Run a command in a new Kitty window using the current working directory:

```bash
kitty @ launch --type=window --cwd "$(pwd)" <command> <args...>
```

Example:

```bash
kitty @ launch --type=window --cwd "$(pwd)" nvim -d old.txt new.txt
```

## Focus Behavior

By default, Kitty may focus the launched tab/window. To keep focus on the current Pi terminal, add `--keep-focus`:

```bash
kitty @ launch --keep-focus --type=tab --cwd "$(pwd)" <command> <args...>
```

## Why Use This From Pi

Pi runs inside the current terminal. Starting an interactive program directly can block Pi until the program exits. Launching the program in a separate Kitty tab/window lets the user interact with it while Pi remains available.

## Gotchas

- Remote control may be disabled; `kitty @ launch ...` will fail until enabled.
- Quote paths and command arguments carefully.
- Prefer `--cwd "$(pwd)"` so the launched command starts in the same project directory as Pi.
- For temporary files that must remain available after the command returns, write them to stable paths such as `/tmp` or a project `.scratch` directory.

## When to Use

- Opening Neovim diffs without blocking Pi.
- Running interactive terminal applications alongside Pi.
- Starting long-running commands in a separate visible terminal context.
