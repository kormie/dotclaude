# Configuration Guide

This section provides comprehensive guides for configuring and customizing your DotClaude setup.

## Quick Navigation

### Configuration Guides
- **Git Configuration** - Modern git setup with delta and difftastic
- **Tmux Setup** - Terminal multiplexing with vim-style navigation  
- **Shell Enhancement** - Oh-My-Zsh integration and modern tools
- **Editor Integration** - Neovim Lua configuration with LSP

### Package Management
- **GNU Stow Basics** - Understanding symlink management
- **Package Structure** - How packages are organized
- **Deployment** - Applying configurations safely
- **Rollback & Recovery** - Reverting changes when needed

## Getting Started

1. **Safety First** - All configurations include backup and rollback mechanisms
2. **Incremental Adoption** - Apply changes gradually without disrupting existing workflows
3. **Modular Design** - Each component can be enabled/disabled independently

## Architecture Overview

DotClaude uses GNU Stow for symlink management, organizing configurations into modular packages under `stow/`:

```
stow/
├── git/          # Git configuration with modern diff tools
├── zsh/          # Shell enhancement with Oh-My-Zsh
├── neovim/       # Modern Neovim Lua configuration
├── tmux/         # Terminal multiplexing setup
├── aliases/      # Centralized alias management
└── environment/  # PATH and environment variables
```

Each package is self-contained and can be applied independently using the provided safety scripts.