# Tmux Setup

Terminal multiplexing configuration optimized for vim-style navigation and Claude Code workflows.

## Overview

DotClaude's tmux configuration provides a vim-optimized terminal multiplexing experience with specialized support for AI development workflows.

## Key Features

### Vim-Style Navigation
- **C-a hjkl** - Vim-style pane navigation
- **C-a |/-** - Intuitive pane splitting
- **Escape** - Enter copy mode with vim keybindings
- **CapsLock=Ctrl** integration for seamless navigation

### Claude Code Integration
- **C-a ,w** - Launch Claude Code workspace
- **C-a ,c** - New Claude Code session
- **C-a ,n** - New Neovim session
- Multi-session workspace management

### Smart Pane Management
- Automatic pane sizing and layout
- Session persistence and restoration
- Named sessions for different projects

## Configuration Files

The tmux package includes:
- `stow/tmux/.tmux.conf` - Main tmux configuration
- `scripts/tmux-claude-workspace` - Workspace automation
- Integration with git worktrees

## Workspace Layouts

### 4-Pane Development Layout
```
┌─────────────┬─────────────┐
│  Claude 1   │  Claude 2   │
├─────────────┼─────────────┤
│  Claude 3   │  Claude 4   │
└─────────────┴─────────────┘
```

### Git Worktree Integration
Each pane can work in different git worktrees for parallel development:
- Feature development
- Testing and validation
- Documentation updates
- Code cleanup

## Usage

```bash
# Apply tmux configuration
./scripts/stow-package.sh tmux

# Launch Claude Code workspace
tmux-claude-workspace

# Manual session management
tmux new-session -s claude-main
tmux new-session -s claude-test
```

## Key Bindings Reference

| Binding | Action |
|---------|--------|
| `C-a hjkl` | Navigate panes |
| `C-a \|` | Vertical split |
| `C-a -` | Horizontal split |
| `C-a ,w` | Claude workspace |
| `C-a ,c` | New Claude session |
| `C-a ,n` | New Neovim session |

## Safety

Tmux configurations are applied safely with rollback support:

```bash
# Test new configuration
./scripts/test-config.sh tmux

# Rollback if needed
./scripts/restore.sh tmux
```