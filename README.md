# DotClaude - Modern Dotfiles Optimized for AI Development

> A highly modular, modern CLI setup designed for Claude Code and agentic development workflows

[![Phase 1 Complete](https://img.shields.io/badge/Phase%201-Complete-green.svg)](https://github.com/kormie/dotclaude)
[![Phase 2 Complete](https://img.shields.io/badge/Phase%202-Complete-green.svg)](https://github.com/kormie/dotclaude)
[![Safety First](https://img.shields.io/badge/Safety-First-blue.svg)]()
[![Vim Optimized](https://img.shields.io/badge/Vim-Optimized-purple.svg)]()

## 🎯 Project Goals

1. **🛡️ Safety First**: Non-destructive development on primary machine with comprehensive rollback
2. **⚡ Modern Tooling**: Rust-based CLI replacements with coexisting aliases  
3. **🤖 Claude Code Optimization**: Specialized workflows for multi-session agentic development
4. **⌨️ Vim-Style Navigation**: Consistent hjkl keybindings and workflow patterns throughout

## 🚀 Quick Start

```bash
# Clone the repository
git clone git@github.com:kormie/dotclaude.git ~/.dotfiles
cd ~/.dotfiles

# Install modern tools (safe, non-destructive)
./scripts/setup-tools.sh

# Launch Claude Code workspace (4-pane layout with git worktrees)
cw myproject feature-1 feature-2

# Apply configurations gradually
./scripts/stow-package.sh git      # Enhanced git config
./scripts/stow-package.sh tmux     # Vim-optimized tmux
./scripts/stow-package.sh aliases  # Centralized aliases
```

## 🏗️ Architecture

### GNU Stow Package System
```
stow/
├── aliases/          ✅ Centralized alias management
├── environment/      ✅ PATH and XDG Base Directory setup  
├── git/             ✅ Git config with delta + difftastic
├── tmux/            ✅ Vim-optimized tmux with Claude Code workflows
├── neovim/          🔄 Neovim Lua configuration (Phase 3)
├── rust-tools/      ✅ Modern CLI tool configurations
└── zsh/             ✅ Enhanced Zsh + Oh-My-Zsh setup
```

### Management Scripts
```
scripts/
├── backup.sh            ✅ Comprehensive backup system
├── restore.sh           ✅ Safe rollback functionality  
├── test-config.sh       ✅ Pre-deployment testing
├── stow-package.sh      ✅ Safe package deployment
├── setup-tools.sh       ✅ Modern tool installation
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
- ✅ SSH GPG signing (key: CC88252F9D88566B)
- ✅ GitHub SSH URL rewriting
- ✅ Git LFS configuration
- ✅ macOS keychain integration
- ✅ Colima Docker support

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

### 🔄 Phase 2 - Shell Enhancement (Next)
- Enhanced Zsh configuration with Oh-My-Zsh
- Modern tool integration and gradual migration
- Neovim Lua configuration  
- Advanced Claude Code workflow automation

### 🚀 Phase 3 - Editor Enhancement (Future)
- Complete Neovim setup with LSP
- Development tool integration
- Workflow optimization and validation

### 🎯 Phase 4 - Full Integration (Future)  
- Complete migration with performance optimization
- Advanced features and customizations
- Final validation and documentation

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
- **[PROJECT_PLAN.md](PROJECT_PLAN.md)**: Detailed project roadmap and milestones
- **[CLAUDE.md](CLAUDE.md)**: Project instructions and configuration guidance  
- **[backups/](backups/)**: Automatic backups with timestamps
- **[docs/](docs/)**: VitePress documentation source

## 🤝 Contributing

This is a personal dotfiles repository optimized for Claude Code development. The design patterns and safety systems may be useful for others building agentic development workflows.

## 📄 License

Personal dotfiles configuration - use at your own discretion.

---

**Built for the future of AI-assisted development** 🤖✨

*Last updated: Phase 1 Complete - June 2025*