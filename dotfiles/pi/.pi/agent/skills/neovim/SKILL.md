---
name: neovim
description: Neovim/Fugitive integration for reviewing Git changes. Use when showing file differences to the user in Neovim with vim-fugitive.
---

# Neovim Fugitive Review

Use Neovim with `vim-fugitive` to review Git changes visually.

## Requirements

- Neovim must be installed with the `nvim` CLI available in PATH.
- `vim-fugitive` must be installed.

## Important: Terminal Blocking

Do **not** launch interactive Neovim. If the user is using Kitty, prefer opening Neovim in a new Kitty tab/window using the `kitty` skill so Pi remains available.

## Review All Git Changes

Open Fugitive status, ensure it is the only Neovim window, and press Fugitive's `=` mapping to expand inline diffs/hunks:

```bash
nvim -c 'G' -c 'only' -c 'normal ='
```

From Pi in Kitty, prefer launching it in a new tab:

```bash
kitty @ launch --type=tab --cwd "$(pwd)" nvim -c 'G' -c 'only' -c 'normal ='
```

## Single-File Git Diff

Open a file and compare it to a Git ref with Fugitive:

```bash
nvim path/to/file -c 'Gvdiffsplit HEAD'
```

From Pi in Kitty:

```bash
kitty @ launch --type=tab --cwd "$(pwd)" nvim path/to/file -c 'Gvdiffsplit HEAD'
```

## When to Use

- Reviewing all Git changes visually via Fugitive status.
- Showing a single file diff against `HEAD`.
- Launching Neovim in Kitty when interactive review should not block Pi.
