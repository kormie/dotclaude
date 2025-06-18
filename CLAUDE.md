# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose
This is a modern dotfiles repository using GNU Stow for symlink management. The goal is to create a highly modular, modern CLI setup with Rust-based tool replacements, Neovim with Lua configuration, and clean maintainable structure.

## Critical Safety Requirements
**This repository is being developed on a primary development machine - all changes must be non-destructive and easily reversible.**

### Safety-First Development Commands
```bash
# Always backup before making changes
./scripts/backup.sh

# Test new configuration before applying
./scripts/test-config.sh [component]

# Apply changes using Stow
./scripts/stow-package.sh [package]

# Emergency rollback
./scripts/restore.sh [component]
```

### Testing Protocol
- Test all new configurations in separate terminal sessions before applying
- Use `exec $SHELL` to test new shell configs without breaking existing sessions
- Keep existing configurations as fallbacks until new ones are proven stable
- Validate each Stow package individually before system-wide deployment

## Architecture & Structure

### GNU Stow Package Organization
Each configuration lives in its own Stow package under `stow/`:
- `stow/zsh/` - Zsh + Oh-My-Zsh configuration
- `stow/neovim/` - Neovim Lua configuration  
- `stow/git/` - Git configuration
- `stow/rust-tools/` - Modern CLI tools (bat, exa, fd, etc.)
- `stow/tmux/` - Terminal multiplexing
- `stow/aliases/` - Centralized alias management (single source of truth)
- `stow/environment/` - PATH and environment variables

### Development Workflow
1. **Incremental Migration**: Develop configurations alongside existing setup, never replace immediately
2. **Parallel Development**: Build new configs without affecting current ones
3. **Gradual Adoption**: Use aliases to transition (e.g., `ll2` for `exa` before replacing `ls`)
4. **Modular Testing**: Each Stow package can be enabled/disabled independently

## Core Principles to Follow
- **Modularity**: Each tool/config in its own Stow package
- **Non-Destructive**: Always backup existing configs, never overwrite without confirmation
- **Incremental Adoption**: Use new tools as they're ready, maintain existing workflow
- **Single Source of Truth**: Centralized configuration management (especially for aliases)
- **Idempotent**: Safe to run setup scripts multiple times
- **Documentation Updates**: Always update the README.md, CLAUDE.md, PROJECT_PLAN.md and docs directory in a dedicated commit before pushing to remote if necessary to ensure documentation is up to date

## Modern Tool Replacements
When implementing Rust-based CLI tool replacements:
- Install as additional commands first, not replacements
- Create coexisting aliases before making them default (e.g., ll2, cat2, find2)
- Maintain backwards compatibility through aliases
- Target tools: exa/eza (ls), bat (cat), fd (find), ripgrep (grep), zoxide, delta, difftastic, dust, procs, bottom, broot

### Git Diff Tool Configuration
- **Delta**: Primary diff tool configured as core.pager with enhanced features (side-by-side, syntax highlighting, navigation)
- **Difftastic**: Secondary syntax-aware diff tool accessed via GIT_EXTERNAL_DIFF pattern:
  - `env GIT_EXTERNAL_DIFF=difft git log -p --ext-diff` for syntax-aware log viewing
  - Aliases: `git dtl`, `glogdifft` for convenient access
- User prefers: `git log --graph --pretty="format:%C(yellow)%h%Cred%d%Creset %s %C(white) %C(cyan)%an%Creset, %C(green)%ar%Creset"`

## Configuration Management
- Neovim configurations must be in Lua
- Zsh configurations should integrate with Oh-My-Zsh cleanly
- All aliases managed centrally in `stow/aliases/` (single source of truth)
- PATH management consolidated in `stow/environment/` with XDG Base Directory compliance
- Git configurations leverage modern tools (delta + difftastic) with user's existing settings preserved

### User-Specific Requirements
- **Docker**: Uses colima instead of Docker Desktop (aliases updated accordingly)
- **Git Signing**: SSH GPG signing enabled with key 
- **Git Preferences**: GitHub SSH URL rewriting, Git LFS, macOS keychain integration
- **Development Environment**: Primary development machine requiring non-destructive changes
- **Vim Workflow**: CapsLock rebound to Ctrl, mapleader is comma, prefers hjkl navigation and netrw patterns
- **Claude Code Optimization**: Specialized workflows for multi-session agentic development

### Claude Code Development Features
- **Multi-Session Tmux Workspace**: 4-pane layout with parallel Claude Code sessions using git worktrees
- **Vim-Style Navigation**: Consistent hjkl movement, comma leader key, seamless vim/tmux integration
- **Automated Setup**: `tmux-claude-workspace` script for instant development environment creation
- **Git Worktree Integration**: Parallel development without branch conflicts using `.worktrees/` directory
- **Session Management**: Named sessions with persistence and easy workspace switching

### Tmux Key Bindings (Vim-Optimized)
- **C-a |/-**: Pane splitting (user preference)
- **C-a hjkl**: Vim-style pane navigation
- **C-a ,w**: Launch Claude Code workspace 
- **C-a ,c**: New Claude Code session
- **C-a ,n**: New neovim session
- **Escape**: Enter copy mode (vim-like)
- **C-hjkl**: Smart vim/tmux navigation (leverages CapsLock=Ctrl)

## Rollback Strategy
- Keep backups in `backups/` directory with timestamps
- Maintain restore scripts for each component (`./scripts/restore.sh`)
- Document all changes in detailed git commit messages
- Ensure easy toggle between old/new configurations during transition

## Phase 1 Completion Status
✅ **Safety Infrastructure**: Comprehensive backup/restore system tested and working
✅ **Core Scripts**: All management scripts created and tested
✅ **Package Structure**: Git, environment, aliases, tmux packages ready for deployment
✅ **Modern Tools**: Installation script with coexisting aliases (ll2, cat2, etc.)
✅ **Git Enhancement**: Delta + difftastic configured with user's preferred log format
✅ **User Integration**: Existing settings preserved, colima support added
✅ **Claude Code Optimization**: Multi-session tmux workspace with git worktrees
✅ **Vim-Style Navigation**: Comprehensive keybinding integration matching user workflow

**Enhanced Phase 1 Features**:
✅ **Automated Workspace**: `tmux-claude-workspace` script for instant setup
✅ **Git Worktree Integration**: Parallel development without conflicts
✅ **Vim-Optimized Keybindings**: CapsLock=Ctrl leveraged, comma leader, hjkl navigation
✅ **Session Management**: Named sessions with persistence and switching

## Documentation System
✅ **VitePress Documentation**: Modern, fast documentation with GitHub Pages integration
- **Live Site**: https://kormie.github.io/dotclaude/
- **Local Development**: `cd docs && npm run docs:dev`
- **Auto-deployment**: GitHub Actions on every push to main
- **Features**: Built-in search, mobile responsive, dark/light mode, edit links

## Documentation Structure
- **getting-started/**: Installation and setup guides
- **guide/**: Configuration guides and package management
- **claude-code/**: AI development workflows and tmux integration
- **reference/**: Command reference and troubleshooting

**Ready for Phase 2**: Shell enhancement with Oh-My-Zsh integration