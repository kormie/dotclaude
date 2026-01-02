# Tip of the Day Candidates

Track tips to showcase in the terminal startup TOTD feature.

## Format
Each tip should be:
- One-liner or max 2 lines
- Include the keybinding/command
- Brief explanation of what it does

---

## Navigation & Editing

- `Ctrl+A` / `Ctrl+E` — Jump to beginning/end of line
- `Ctrl+W` — Delete word backward (undo with `Ctrl+_`)
- `Ctrl+_` — Undo last edit in command buffer
- `Ctrl+Y` — Redo (undo the undo)
- `Ctrl+←/→` — Navigate word by word
- `Ctrl+X Ctrl+E` — Open current command in Neovim for complex editing

## History

- `Ctrl+R` — Reverse search through history
- `↑/↓` — History search filtered by current prefix (type `git` then ↑)

## Zoxide

- `z <partial>` — Smart cd using frecency (frequency + recency)
- `zi` — Interactive directory picker with fzf

## Modern CLI Tools

- `ll2` — Enhanced ls with git status, icons (eza)
- `cat2` — Syntax-highlighted file viewing (bat)
- `find2` — Faster, friendlier find (fd)
- `grep2` — Faster grep with better defaults (ripgrep)

## Git Shortcuts

- `glogp` — Pretty git log with graph and colors
- `glogdifft` — Git log with syntax-aware diffs (difftastic)
- `gwt <branch>` — Create git worktree and cd into it

---

## History Expansion (Magic Space)

- `!!<Space>` — Expands to last command (see before running!)
- `sudo !!<Space>` — Re-run last command with sudo, safely
- `!$<Space>` — Last argument of previous command
- `!*<Space>` — All arguments of previous command
- `!git<Space>` — Last command starting with "git"
- `!-2<Space>` — Second-to-last command

## Suffix Aliases (open files by typing filename)

- `README.md` — Opens in bat (syntax-highlighted read-only view)
- `main.go` — Opens in nvim for editing
- `config.json` — Pretty-prints with jq
- `video.mp4` — Opens in default macOS player
- Works for: `.ts`, `.py`, `.go`, `.ex`, `.rb`, `.rs`, `.lua`, `.sh`, and more
- Note: `cat file.md` still works — suffix aliases only trigger with no command

## ZMV (batch rename/move/copy)

- `zmvn '(*).test.ts' '$1.spec.ts'` — Dry-run rename (ALWAYS preview first!)
- `zmv '(*).test.ts' '$1.spec.ts'` — Execute batch rename
- `zcp '(*).example' '$1'` — Batch copy (e.g., config.example → config)
- `zln '(*)' '../backup/$1'` — Batch symlink
- `zmv '(*)' '${(L)1}'` — Lowercase all filenames

## Pending (to be added as we implement)

- Custom ZLE widgets
- Boilerplate hotkeys
