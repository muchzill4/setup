#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten path: ~/D/m/setup → truncate intermediate segments to first char, last segment full
short_cwd=$(echo "$cwd" | sed "s|^$HOME|~|" | awk -F/ '{
  for (i = 1; i < NF; i++) {
    if (i > 1) printf "/"
    printf "%s", substr($i, 1, 1)
  }
  if (NF > 1) printf "/"
  printf "%s", $NF
}')

# Git branch (skip optional locks)
branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)

# Split path into prefix and last segment, bold the last segment
path_prefix=$(echo "$short_cwd" | sed 's|/[^/]*$||')
path_last=$(basename "$short_cwd")
if [ "$path_prefix" = "$short_cwd" ]; then
  styled_cwd=$(printf '\033[34;1m%s\033[0m' "$short_cwd")
else
  styled_cwd=$(printf '\033[34m%s/\033[1m%s\033[0m' "$path_prefix" "$path_last")
fi

# Git indicators: dirty, ahead/behind (matching hydro symbols)
git_info=""
if [ -n "$branch" ]; then
  git_info="$branch"
  # Dirty: staged/unstaged changes or untracked files
  git -C "$cwd" diff-index --quiet HEAD 2>/dev/null
  dirty=$?
  if [ "$dirty" -eq 1 ] || [ -n "$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null)" ]; then
    git_info="${git_info}•"
  fi
  # Ahead/behind upstream
  counts=$(git -C "$cwd" rev-list --count --left-right '@{upstream}...HEAD' 2>/dev/null)
  if [ -n "$counts" ]; then
    behind=$(echo "$counts" | cut -f1)
    ahead=$(echo "$counts" | cut -f2)
    [ "$ahead" -gt 0 ] 2>/dev/null && git_info="${git_info} ↑${ahead}"
    [ "$behind" -gt 0 ] 2>/dev/null && git_info="${git_info} ↓${behind}"
  fi
fi

# Build output (blue for cwd, black for git — hydro-inspired)
if [ -n "$git_info" ]; then
  dir_git=$(printf '%s \033[30m%s\033[0m' "$styled_cwd" "$git_info")
else
  dir_git=$styled_cwd
fi

if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  # 8-cell gradient bar: █ = full, ▓▒░ = transition, ░ = empty
  width=8
  total=$(( pct * width ))
  full=$(( total / 100 ))
  frac=$(( (total % 100) * 4 / 100 ))  # 0=░ 1=▒ 2=▓ 3=█
  bar=""
  i=0; while [ "$i" -lt "$full" ]; do bar="${bar}█"; i=$((i + 1)); done
  if [ "$full" -lt "$width" ]; then
    case $frac in
      0) bar="${bar}░" ;;
      1) bar="${bar}▒" ;;
      2) bar="${bar}▓" ;;
      3) bar="${bar}█" ;;
    esac
    full=$((full + 1))
  fi
  i=$full; while [ "$i" -lt "$width" ]; do bar="${bar}░"; i=$((i + 1)); done
  if [ "$pct" -ge 80 ]; then
    ctx=$(printf '\033[31m%s %s%%\033[0m' "$bar" "$pct")
  elif [ "$pct" -ge 50 ]; then
    ctx=$(printf '\033[33m%s %s%%\033[0m' "$bar" "$pct")
  else
    ctx=$(printf '\033[30m%s %s%%\033[0m' "$bar" "$pct")
  fi
  printf '%s  %s' "$dir_git" "$ctx"
else
  printf '%s' "$dir_git"
fi
