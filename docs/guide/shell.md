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
Rust-based alternatives to traditional Unix tools:
- **exa/eza** (`ll2`) - Enhanced ls with git integration
- **bat** (`cat2`) - Syntax-highlighted cat
- **fd** (`find2`) - Fast, user-friendly find
- **ripgrep** (`grep2`) - Ultra-fast text search
- **zoxide** (`z`) - Smart directory jumping

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

| Tool | Purpose | Alias | Replaces |
|------|---------|-------|----------|
| exa/eza | Enhanced ls | `ll2` | `ls` |
| bat | Syntax highlighting | `cat2` | `cat` |
| fd | Fast find | `find2` | `find` |
| ripgrep | Ultra-fast search | `grep2` | `grep` |
| zoxide | Smart navigation | `z` | `cd` |
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

## Incremental Adoption

Tools are introduced with coexisting aliases (e.g., `ll2`) before becoming defaults:

```bash
# Try modern tools
ll2        # Enhanced ls with exa
cat2 file  # Syntax-highlighted cat
find2 -n   # Fast find with fd
grep2      # Ultra-fast search with ripgrep
z project  # Smart directory jumping

# Convenience shortcuts
c          # Clear terminal (alias for clear)

# Git workflow shortcuts
gwt branch # Create git worktree with new branch and cd to it
```

## Safety Features

### Toggle System
Easy switching between original and enhanced configurations:

```bash
# Switch to enhanced shell
./scripts/toggle-shell.sh enhanced

# Revert to original
./scripts/toggle-shell.sh original

# Check current status
./scripts/toggle-shell.sh status
```

### Backup & Restore
Comprehensive backup system:

```bash
# Backup existing shell config
./scripts/backup.sh shell

# Restore if needed
./scripts/restore.sh shell
```

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