# Dotfiles Configuration

This directory contains configuration files for shell enhancements.

## Files

| File | Purpose |
|------|---------|
| `tips.txt` | Tip of the Day database |

## tips.txt Format

```
category|tip text
```

### Categories

- `nav` — Navigation & keybindings
- `hist` — History expansion
- `file` — File operations
- `git` — Git shortcuts
- `tool` — Modern CLI tools
- `py` — Python/uv
- `node` — Node/npm
- `mix` — Elixir
- `proj` — Project detection
- `zle` — ZLE widgets

### Special Lines

- Lines starting with `#` are comments (ignored)
- Lines starting with `## REMOVED:` are removed tips (kept for history)

### Example

```
nav|Ctrl+A / Ctrl+E — Jump to beginning/end of line
git|glogp — Pretty git log with graph and colors
## REMOVED: nav|Some tip that was permanently removed
```

## See Also

Full documentation: [Tip of the Day](/guide/totd)
