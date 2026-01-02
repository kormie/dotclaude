# Shell Enhancement

Oh-My-Zsh integration with modern CLI tools and enhanced productivity features.

## Overview

DotClaude's shell enhancement provides a modern, productive command-line experience with Oh-My-Zsh integration and Rust-based tool replacements.

## Key Features

### Oh-My-Zsh Integration
- **Essential Plugins**: git, zsh-autosuggestions, zsh-syntax-highlighting
- **Custom Theme**: Optimized for git workflows and AI development
- **Plugin Management**: Curated selection for performance and utility

### Modern Tool Replacements
Rust-based alternatives that are now the default commands:
- **eza** (`ls`) - Enhanced ls with git integration (was `ll2`)
- **bat** (`cat`) - Syntax-highlighted cat (was `cat2`)
- **fd** (`find`) - Fast, user-friendly find (was `find2`)
- **ripgrep** (`grep`) - Ultra-fast text search (was `grep2`)
- **zoxide** (`cd`) - Smart directory jumping (was `z`)
- **dust** (`du`) - Better disk usage visualization
- **procs** (`ps`) - Modern process viewer
- **bottom** (`top`) - Enhanced system monitor

### Centralized Alias Management
Single source of truth for all aliases:
- Located in `~/.config/dotfiles/aliases`
- Consistent across all shell sessions
- Easy to maintain and extend
- Includes convenience shortcuts like `c` for `clear`

## Configuration Files

The shell package includes:
- `stow/zsh/.zshrc` - Main shell configuration
- `stow/aliases/.config/dotfiles/aliases` - Centralized aliases
- `stow/environment/.config/dotfiles/environment` - PATH management

## Modern Tools Overview

| Tool | Purpose | Default Command | Original Available As |
|------|---------|----------------|-----------------------|
| eza | Enhanced ls | `ls`, `ll` | `ls_original` |
| bat | Syntax highlighting | `cat`, `less` | `cat_original` |
| fd | Fast find | `find` | `find_original` |
| ripgrep | Ultra-fast search | `grep`, `fgrep`, `egrep` | `grep_original` |
| zoxide | Smart navigation | `cd` | `cd_original` |
| dust | Disk usage | `du` | `du_original` |
| procs | Process viewer | `ps` | `ps_original` |
| bottom | System monitor | `top` | `top_original` |
| delta | Git diffs | (automatic) | - |

## Installation & Usage

```bash
# Install modern tools
./scripts/install-modern-tools.sh

# Apply shell configuration
./scripts/stow-package.sh zsh
./scripts/stow-package.sh aliases
./scripts/stow-package.sh environment

# Test enhanced shell
exec $SHELL
```

## Modern Tools Are Now Default

As of commit `4559798`, modern tools are the default commands with automatic fallbacks:

```bash
# These now use modern tools by default
ls         # Enhanced ls with eza (falls back to ls if not installed)
cat file   # Syntax-highlighted cat with bat (falls back to cat if not installed)
find -n    # Fast find with fd (falls back to find if not installed)
grep       # Ultra-fast search with ripgrep (falls back to grep if not installed)
cd project # Smart directory jumping with zoxide (falls back to cd if not installed)

# Use original tools when needed
ls_original  # Original ls command
cat_original # Original cat command
find_original # Original find command

# Convenience shortcuts
c          # Clear terminal (alias for clear)

# Git workflow shortcuts
gwt branch # Create git worktree with new branch and cd to it
```

> [!TIP]
> **Smart Navigation with zoxide**
> As of commit `84f49a9`, the `cd` command now uses zoxide for smart directory jumping while maintaining full compatibility with traditional cd patterns. Use `cd_original` if you need the shell builtin.

## Safety Features

### Toggle System
Easy switching between modern and original tool configurations:

```bash
# Switch to enhanced shell (modern tools as defaults)
./scripts/toggle-shell.sh enhanced

# Revert to original (traditional tools as defaults)
./scripts/toggle-shell.sh original

# Check current status
./scripts/toggle-shell.sh status
```

> [!WARNING]
> **Migration Complete**
> With the recent updates, the enhanced shell configuration with modern tools as defaults is now the standard setup. The toggle system remains available for users who prefer traditional tools.

### Backup & Restore
Comprehensive backup system:

```bash
# Backup existing shell config
./scripts/backup.sh shell

# Restore if needed
./scripts/restore.sh shell
```

## Custom Hotkeys

DotClaude includes a set of custom Zsh hotkeys for common operations. All hotkeys use the `Ctrl+X` prefix, following Emacs tradition.

### Keybinding Convention

We use a **core vs auxiliary** two-tier pattern:

| Pattern | Ctrl Behavior | Purpose |
|---------|---------------|---------|
| `Ctrl+X, Ctrl+key` | Keep Ctrl held | **Core**: Buffer/editor operations |
| `Ctrl+X, key` | Release Ctrl | **Auxiliary**: External tool templates |

**Rationale:**
- **Core operations** transform or act ON the current buffer (copy it, edit in `$EDITOR`, prepend sudo). These are fundamental to line-editing, so Ctrl stays held.
- **Auxiliary operations** insert command templates for external tools (git, npm, docker). These transition you from editing to composing a new command, so Ctrl is released.

This follows the spirit of Emacs's `C-x C-_` vs `C-x _` distinction, but with a clearer boundary for shell use cases.

### Core: Buffer Operations

| Hotkey | Action |
|--------|--------|
| `Ctrl+X, Ctrl+E` | Edit command in `$EDITOR` |
| `Ctrl+X, Ctrl+C` | Copy buffer to clipboard |
| `Ctrl+X, Ctrl+O` | Re-run last command, copy output |
| `Ctrl+X, Ctrl+L` | Clear screen, keep buffer |
| `Ctrl+X, Ctrl+S` | Prepend sudo |
| `Ctrl+X, Ctrl+'` | Wrap line in single quotes |
| `Ctrl+X, Ctrl+,` | Snooze tip of the day |
| `Ctrl+X, Ctrl+.` | Remove tip permanently |

### Auxiliary: Tool Templates

| Hotkey | Inserts | Cursor Position |
|--------|---------|-----------------|
| `Ctrl+X, g` | `git commit -m ""` | Inside quotes |
| `Ctrl+X, p` | `git push origin ` | After origin |
| `Ctrl+X, d` | `docker exec -it  bash` | After `-it` |
| `Ctrl+X, n` | `npm run ` | After run |
| `Ctrl+X, t` | `npm test ` | After test |
| `Ctrl+X, b` | `npm run build` | End of line |
| `Ctrl+X, u` | `uv run ` | After run |
| `Ctrl+X, m` | `mix ` | After mix |
| `Ctrl+X, i` | `iex -S mix` | End of line |
| `Ctrl+X, v` | `nvim .` | Before `.` |

### Configuration

Hotkeys are defined in `~/.zsh_hotkeys`, which is sourced by `.zshrc`. The file includes:
- Detailed convention documentation in the header
- Clear separation between core and auxiliary sections
- Widget definitions live separately in `~/.zsh_widgets`

## Customization

### Adding New Aliases
Edit the centralized alias file:
```bash
# Edit aliases
$EDITOR ~/.config/dotfiles/aliases

# Changes take effect in new shell sessions
exec $SHELL
```

### Plugin Management
Oh-My-Zsh plugins are managed in the zsh configuration:
- Performance-focused selection
- Essential productivity features
- Git workflow optimization