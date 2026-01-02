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

## Pending (to be added as we implement)

- Magic Space (history expansion)
- Suffix aliases
- ZMV batch renaming
- Custom ZLE widgets
- Boilerplate hotkeys
