# DotClaude - Modern Dotfiles Optimized for AI Development

> A highly modular, modern CLI setup designed for Claude Code and agentic development workflows

[![Phase 1 Complete](https://img.shields.io/badge/Phase%201-Complete-green.svg)](https://github.com/kormie/dotclaude)
[![Phase 2 Complete](https://img.shields.io/badge/Phase%202-Complete-green.svg)](https://github.com/kormie/dotclaude)
[![Phase 3 Complete](https://img.shields.io/badge/Phase%203-Complete-green.svg)](https://github.com/kormie/dotclaude)
[![Phase 4 Complete](https://img.shields.io/badge/Phase%204-Complete-green.svg)](https://github.com/kormie/dotclaude)
[![Project Complete](https://img.shields.io/badge/Project-Complete-brightgreen.svg)](https://github.com/kormie/dotclaude)
[![Safety First](https://img.shields.io/badge/Safety-First-blue.svg)]()
[![Vim Optimized](https://img.shields.io/badge/Vim-Optimized-purple.svg)]()

## 🎯 Project Goals

1. **🛡️ Safety First**: Non-destructive development on primary machine with comprehensive rollback
2. **⚡ Modern Tooling**: Rust-based CLI replacements with coexisting aliases  
3. **🤖 Claude Code Optimization**: Specialized workflows for multi-session agentic development
4. **⌨️ Vim-Style Navigation**: Consistent hjkl keybindings and workflow patterns throughout

## 🚀 Quick Start

### Linux Server (Ubuntu/Debian) - Minimal Profile

This profile is designed for VPS/server bootstrapping: **tmux + vim muscle memory + mosh + fzf + bat + zoxide**.

```bash
git clone git@github.com:kormie/dotclaude.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh --server

# Verify
ls -la ~/.tmux.conf ~/.vimrc
```

### Fresh Mac (No SSH Keys Yet)

```bash
# One-liner bootstrap - works without SSH keys configured
curl -fsSL bootstrap.kormie.link | bash

# Minimal install
curl -fsSL bootstrap.kormie.link | INSTALL_MODE=minimal bash

# Interactive install
curl -fsSL bootstrap.kormie.link | INSTALL_MODE=interactive bash
```

### One-Line Installation (With SSH Keys)

```bash
# Full idempotent setup - safe to run multiple times
git clone git@github.com:kormie/dotclaude.git ~/.dotfiles && cd ~/.dotfiles && ./scripts/install.sh --all
```

### Interactive Installation

```bash
# Clone the repository (HTTPS - no SSH keys needed)
git clone https://github.com/kormie/dotclaude.git ~/.dotfiles
cd ~/.dotfiles

# Run interactive installer (prompts for each component)
./scripts/install.sh

# Or run full installation non-interactively
./scripts/install.sh --all
```

### Minimal Installation

```bash
# Install only core dependencies and deploy configs
./scripts/install.sh --minimal
```

### Verify Installation

```bash
# Validate your setup
./scripts/validate-setup.sh

# Check with verbose output
./scripts/validate-setup.sh --verbose
```

## 🔧 What Gets Installed

| Component | Minimal | Full |
|-----------|---------|------|
| Homebrew (if not present) | ✅ | ✅ |
| Core tools (stow, git, zsh, nvim, tmux) | ✅ | ✅ |
| Configuration backup | ✅ | ✅ |
| Stow package deployment | ✅ | ✅ |
| Modern CLI tools (eza, bat, fd, rg, etc.) | ❌ | ✅ |
| Nerd Fonts | ❌ | ✅ |
| Oh-My-Zsh with plugins | ❌ | ✅ |
| macOS system defaults | ❌ | ✅ |

### Apply Configurations Manually

```bash
# Deploy individual packages
./scripts/stow-package.sh git      # Enhanced git config
./scripts/stow-package.sh tmux     # Vim-optimized tmux
./scripts/stow-package.sh aliases  # Centralized aliases

# Launch Claude Code workspace (4-pane layout with git worktrees)
cw myproject feature-1 feature-2
```

## 🏗️ Architecture

### GNU Stow Package System
```
stow/
├── aliases/          ✅ Centralized alias management
├── environment/      ✅ PATH and XDG Base Directory setup  
├── git/             ✅ Git config with delta + difftastic
├── tmux/            ✅ Vim-optimized tmux with Claude Code workflows
├── neovim/          ✅ Modern Neovim Lua configuration with LSP
├── rust-tools/      ✅ Modern CLI tool configurations
└── zsh/             ✅ Enhanced Zsh + Oh-My-Zsh setup
```

### Management Scripts
```
scripts/
├── install.sh           ✅ Main idempotent bootstrap (NEW)
├── validate-setup.sh    ✅ Installation verification (NEW)
├── macos-defaults.sh    ✅ macOS system settings (NEW)
├── backup.sh            ✅ Comprehensive backup system
├── restore.sh           ✅ Safe rollback functionality
├── test-config.sh       ✅ Pre-deployment testing
├── stow-package.sh      ✅ Safe package deployment
├── setup-tools.sh       ✅ Modern tool installation (with Homebrew auto-install)
├── install-fonts.sh     ✅ Nerd Font installation
├── setup-zsh-enhanced.sh ✅ Oh-My-Zsh setup
├── toggle-neovim.sh     ✅ Neovim config toggle
├── toggle-modern-tools.sh ✅ Modern tools toggle
└── tmux-claude-workspace ✅ Automated Claude Code workspace
```

## 🤖 Claude Code Development Features

### Multi-Session Tmux Workspace
Launch parallel Claude Code sessions with git worktrees:

```bash
# Quick workspace setup
cw myproject auth-feature api-feature

# Creates 4-pane layout:
# ┌─────────────────┬─────────────────┐  
# │ Claude: auth    │ Claude: api     │  <- Parallel development
# ├─────────────────┼─────────────────┤
# │ Neovim          │ Git Operations  │  <- Code editing + git ops
# └─────────────────┴─────────────────┘
```

### Vim-Optimized Keybindings
Designed for CapsLock→Ctrl users with vim muscle memory:

```bash
C-a |        # Split pane horizontally  
C-a -        # Split pane vertically
C-a hjkl     # Navigate panes (vim-style)
C-a ,w       # Launch Claude Code workspace
C-a ,c       # New Claude Code session
C-a ,n       # New neovim session
Escape       # Enter copy mode
C-hjkl       # Smart vim/tmux navigation
```

### Git Worktree Integration
Parallel development without branch conflicts:
- Automatic worktree creation in `.worktrees/` directory
- Each Claude session works on separate feature branch
- No git state conflicts between parallel sessions
- Easy branch switching and merging

## 🔧 Enhanced Git Configuration

### Modern Diff Tools
- **Delta**: Primary diff tool with syntax highlighting and side-by-side view
- **Difftastic**: Syntax-aware diffing via `GIT_EXTERNAL_DIFF` pattern

```bash
git lg           # Your preferred log format with colors
git dtl          # Syntax-aware log with difftastic  
glogdifft        # Shell alias for difftastic log
```

### Your Settings Preserved
- ✅ SSH GPG signing (configure in ~/.gitconfig.local)
- ✅ GitHub SSH URL rewriting
- ✅ Git LFS configuration
- ✅ macOS keychain integration
- ✅ Colima Docker support

## 🔄 Idempotent Setup

This repository is designed as a **fully idempotent setup utility** for new and existing Macs:

### Key Features

- **Safe to run multiple times**: Every script checks current state before making changes
- **Works on fresh Macs**: Automatically installs Homebrew, Xcode CLT, and dependencies
- **Works on existing setups**: Detects what's already installed and skips accordingly
- **Automatic backups**: All existing configurations backed up before any changes
- **Validation built-in**: Verify your setup with `./scripts/validate-setup.sh`

### Install Modes

```bash
./scripts/install.sh --all         # Full installation, no prompts
./scripts/install.sh --minimal     # Core only (stow, configs)
./scripts/install.sh --interactive # Choose each component (default)
```

### macOS System Settings

The installer can optionally configure macOS defaults optimized for development:

```bash
./scripts/macos-defaults.sh        # Apply all settings
./scripts/macos-defaults.sh --keyboard  # Keyboard only (fast key repeat)
./scripts/macos-defaults.sh --capslock  # CapsLock → Control remapping
./scripts/macos-defaults.sh --status    # View current settings
```

**Key settings applied:**
- CapsLock remapped to Control (great for vim/tmux users)
- Fast key repeat rate for efficient editing
- Finder shows hidden files and full paths
- Dock auto-hides with no delay
- Screenshots saved to `~/Screenshots`

## 🛡️ Safety System

### Comprehensive Backup & Restore
```bash
# Before any changes
./scripts/backup.sh                    # Backup all dotfiles
./scripts/backup.sh git                # Backup specific component

# Test before applying  
./scripts/test-config.sh git           # Test git configuration
./scripts/test-config.sh all           # Test all configurations

# Apply safely
./scripts/stow-package.sh git          # Deploy git config
./scripts/stow-package.sh git status   # Check deployment status

# Rollback if needed
./scripts/restore.sh                   # Interactive restore
./scripts/restore.sh latest git        # Restore git from latest backup
```

### Non-Destructive Philosophy
- All existing configurations backed up before changes
- New tools installed with coexisting aliases (`ll2`, `cat2`, `find2`)
- Easy toggle between old and new configurations
- Comprehensive testing before deployment

## 📦 Modern CLI Tools

### Rust-Based Replacements
```bash
# Install modern tools (coexist with existing)
./scripts/setup-tools.sh

# Available tools with '2' suffix aliases:
ll2         # eza/exa (enhanced ls)
cat2        # bat (syntax highlighting)  
find2       # fd (fast find)
grep2       # ripgrep (fast grep)
du2         # dust (disk usage)
ps2         # procs (process viewer)
top2        # bottom (system monitor)
```

### Colima Docker Support
Docker aliases updated for colima compatibility:
```bash
colima-start     # Start colima
colima-stop      # Stop colima  
colima-status    # Check status
d, dc, dps       # Standard docker aliases work with colima
```

## 📋 Phase Status

### ✅ Phase 1 Complete - Foundation & Safety
- **Safety Infrastructure**: Backup/restore system tested and working
- **Package Structure**: Git, environment, aliases, tmux packages ready
- **Modern Tools**: Installation system with coexisting aliases
- **Claude Code Optimization**: Multi-session workspace with git worktrees
- **Vim Integration**: Comprehensive keybinding optimization
- **User Customization**: All existing settings preserved and enhanced

### ✅ Phase 2 Complete - Shell Enhancement
- **Enhanced Zsh Configuration**: Oh-My-Zsh with essential plugins
- **Modern Tool Integration**: Coexisting aliases with gradual migration
- **Safety Toggle System**: Easy switching between configurations
- **Centralized Management**: Single source of truth for aliases

### ✅ Phase 3 Complete - Editor Enhancement
- **Modern Neovim**: Lua configuration with lazy.nvim (40+ plugins)
- **LSP Integration**: Full language server support with Mason
- **Advanced Git Tools**: Gitsigns, fugitive, diffview integration
- **Enhanced UI**: Tokyo Night theme, Lualine, Neo-tree explorer
- **Telescope Integration**: Fuzzy finding for files, text, git, LSP
- **User Preferences**: Comma leader, hjkl navigation, all workflows preserved
- **Production Ready**: All issues resolved, comprehensive testing complete

### ✅ Phase 4 Complete - Full Integration & Optimization
- **Confident Migration**: All enhanced configurations deployed as primary
- **Performance Optimization**: Neovim ~47ms, Zsh ~380ms startup times
- **Advanced Customizations**: Project-specific environments, enhanced shell features
- **Final Validation**: Comprehensive system testing and benchmarking complete
- **Production Ready**: Modern CLI environment fully operational with safety systems

## 🎮 Usage Examples

### Daily Development Workflow
```bash
# Start Claude Code workspace for new feature
cw myapp user-auth payment-system

# In tmux panes:
# Pane 1: claude-code . (user-auth branch)
# Pane 2: claude-code . (payment-system branch)  
# Pane 3: nvim src/
# Pane 4: git status && git lg

# Quick operations
C-a ,n          # Open neovim in new pane
C-a g           # Quick git status
C-a S           # Sync panes for identical commands
```

### Git Operations
```bash
git lg          # Beautiful log with your preferred format
git dt          # Difftastic diff for syntax awareness
git dtl         # Syntax-aware log viewing
git sync        # Fetch all and rebase
git cleanup     # Remove merged branches
```

### Tool Migration
```bash
# Try modern tools safely
ll2             # Enhanced ls (eza/exa)
cat2 file.py    # Syntax highlighted cat (bat)
find2 . -name "*.js"  # Fast find (fd)

# When ready, gradually replace defaults via aliases
```

## 📖 Documentation

### 🌐 **[Full Documentation](https://kormie.github.io/dotclaude/)** (GitHub Pages)

Complete guides, tutorials, and reference documentation with beautiful search and navigation.

### 📚 Local Documentation
```bash
# Serve documentation locally
cd docs && npm install && npm run docs:dev
# Open http://localhost:5173
```

### 📄 Quick Reference
- **[CLAUDE.md](CLAUDE.md)**: Project instructions and configuration guidance
- **[backups/](backups/)**: Automatic backups with timestamps
- **[docs/](docs/)**: VitePress documentation source

## 🤝 Contributing

This is a personal dotfiles repository optimized for Claude Code development. The design patterns and safety systems may be useful for others building agentic development workflows.

## 📄 License

Personal dotfiles configuration - use at your own discretion.

---

## 🏆 **Project Complete - Production Ready**

**DotClaude is now fully operational!** A modern, safe, and powerful CLI environment optimized for AI-assisted development workflows.

### **Final Achievement Summary**
- ✅ **All 4 Phases Complete**: Foundation → Shell → Editor → Integration
- ✅ **Production Deployment**: Enhanced configurations active as primary setup
- ✅ **Performance Optimized**: Neovim ~47ms, Zsh ~380ms startup times
- ✅ **Safety Systems Intact**: Complete rollback capability maintained
- ✅ **Modern Tooling**: Full CLI tool suite with coexisting aliases
- ✅ **Documentation Complete**: Comprehensive guides with no dead links

**Built for the future of AI-assisted development** 🤖✨

*Project completed: All phases finished - December 2024*
