# Reference Documentation

Complete reference for commands, configurations, and troubleshooting.

## Quick Reference

### Essential Commands

```bash
# Safety & Testing
./scripts/backup.sh [component]          # Backup configurations
./scripts/restore.sh [timestamp]         # Restore from backup
./scripts/test-config.sh [component]     # Test configurations

# Package Management  
./scripts/stow-package.sh [package]      # Apply Stow package
./scripts/stow-package.sh [package] remove  # Remove Stow package
./scripts/stow-package.sh [package] status  # Check package status

# Tool Installation
./scripts/setup-tools.sh                 # Install all modern tools
./scripts/setup-tools.sh rust-tools      # Install just Rust tools

# Claude Code Workflows
cw project feature1 feature2             # Launch Claude workspace
claude-workspace project f1 f2           # Alternative command
tmux-claude-workspace project f1 f2      # Full command
```

### Modern Tool Aliases

| Original | Modern | Alias | Purpose |
|----------|--------|-------|---------|
| `ls` | `exa/eza` | `ll2` | Enhanced directory listing |
| `cat` | `bat` | `cat2` | Syntax highlighted file viewing |
| `find` | `fd` | `find2` | Fast file search |
| `grep` | `ripgrep` | `grep2` | Ultra-fast text search |
| `du` | `dust` | `du2` | Disk usage visualization |
| `ps` | `procs` | `ps2` | Enhanced process viewer |
| `top` | `bottom` | `top2` | System monitor with graphs |
| `cd` | `zoxide` | `z` | Smart directory navigation |

### Git Enhancements

```bash
# Enhanced log formats
git lg           # Your preferred format with colors
git lga          # All branches with colors  
git tree         # Simplified branch overview

# Modern diff tools
git dt           # Difftastic diff
git dts          # Difftastic staged changes
git dtl          # Difftastic log with diffs
git dtshow       # Difftastic show commit

# Shell aliases for difftastic
glogdifft        # Syntax-aware log viewing
gdifft           # Difftastic diff
gshowdifft       # Difftastic show
```

### Tmux Keybindings (Vim-Optimized)

```bash
# Pane operations
C-a |            # Split horizontally
C-a -            # Split vertically  
C-a hjkl         # Navigate panes (vim-style)
C-a HJKL         # Resize panes (repeatable)

# Window operations  
C-a c            # New window
C-a x            # Close pane
C-a X            # Close window
C-a z            # Zoom pane

# Claude Code workflows
C-a ,w           # Launch Claude workspace
C-a ,c           # New Claude session
C-a ,n           # New neovim session
C-a ,s           # Split with Claude Code
C-a ,v           # Vertical split with Claude Code

# Copy mode (vim-style)
Escape           # Enter copy mode
v                # Begin selection
y                # Copy selection
p                # Paste

# Session management
C-a ,q           # Quit session
C-a ,d           # Detach session
C-a ,l           # List sessions
```

## Configuration Files

### Package Structure

```
stow/
├── aliases/          # Centralized alias management
│   └── .aliases     # All shell aliases
├── environment/      # Environment variables
│   └── .zshenv      # PATH, XDG, tool configs
├── git/             # Git configuration
│   ├── .gitconfig   # Enhanced git config
│   └── .gitignore_global  # Global gitignore
├── tmux/            # Tmux configuration
│   └── .tmux.conf   # Vim-optimized tmux
├── neovim/          # Neovim configuration (Phase 2)
├── rust-tools/      # Modern tool configurations (Phase 2)
└── zsh/             # Zsh configuration (Phase 2)
```

### Management Scripts

```
scripts/
├── backup.sh            # Comprehensive backup system
├── restore.sh           # Interactive restore functionality
├── test-config.sh       # Pre-deployment testing
├── stow-package.sh      # Safe package deployment
├── setup-tools.sh       # Modern tool installation
└── tmux-claude-workspace # Claude Code workspace automation
```

## Project Phases

### ✅ Phase 1: Foundation & Safety (Complete)
- [Phase 1 Details](./phase-1) - Complete implementation details
- Safety infrastructure with backup/restore
- Git configuration with modern diff tools
- Tmux optimization for Claude Code workflows
- Modern CLI tool installation system
- VitePress documentation with GitHub Pages

### 🔄 Phase 2: Shell Enhancement (Next)
- Enhanced Zsh configuration with Oh-My-Zsh
- Modern tool integration and gradual migration
- Advanced Claude Code workflow automation
- Neovim Lua configuration foundation

### 🚀 Phase 3: Editor Enhancement (Future)
- Complete Neovim setup with LSP
- Development tool integration
- Workflow optimization and validation

### 🎯 Phase 4: Full Integration (Future)
- Complete migration with performance optimization
- Advanced features and customizations
- Final validation and documentation

## Package Reference

### Git Package (`stow/git/`)
- **Enhanced .gitconfig**: Delta + difftastic integration, user preferences preserved
- **Global .gitignore**: Comprehensive ignore patterns for all platforms
- **Modern aliases**: Improved log formats, diff tools, workflow commands
- **Your settings**: SSH GPG signing, GitHub SSH URLs, Git LFS preserved

### Tmux Package (`stow/tmux/`)
- **Vim-optimized keybindings**: hjkl navigation, comma leader
- **Claude Code integration**: Multi-session workspace support
- **Modern features**: Copy mode enhancements, session management
- **Git worktree support**: Parallel development workflows

### Environment Package (`stow/environment/`)
- **XDG Base Directory**: Compliant directory structure
- **PATH management**: Modern tools, language runtimes, local binaries
- **Tool configurations**: BAT_THEME, FZF defaults, modern tool settings
- **Runtime support**: Rust, Node.js, Go, Python, Java environments

### Aliases Package (`stow/aliases/`)
- **Centralized management**: Single source of truth for all aliases
- **Modern tool integration**: Coexisting aliases with '2' suffix
- **Safety defaults**: Confirmation for destructive operations
- **Development shortcuts**: Git, Docker (colima), Kubernetes, Claude Code

## Troubleshooting

### Common Issues

**Command not found after installation:**
```bash
# Reload shell
exec $SHELL

# Check PATH
echo $PATH | tr ':' '\n' | grep -E "(local|cargo)"

# Re-source configurations
source ~/.zshrc
source ~/.aliases
```

**Stow conflicts:**
```bash
# Check what conflicts exist
./scripts/stow-package.sh PACKAGE status

# Remove conflicting package
./scripts/stow-package.sh PACKAGE remove

# Manual conflict resolution
ls -la ~/.CONFLICTING_FILE
```

**Git configuration issues:**
```bash
# Test git config syntax
git config --list | head -5

# Restore from backup
./scripts/restore.sh latest git

# Check GPG signing
git config --get commit.gpgsign
```

**Tmux keybinding problems:**
```bash
# Reload tmux config
tmux source-file ~/.tmux.conf

# Kill and restart tmux server
tmux kill-server
tmux

# Test tmux config syntax
tmux -f ~/.tmux.conf -C "list-keys" | head -5
```

### Recovery Procedures

**Complete rollback:**
```bash
# Remove all packages
for pkg in git tmux aliases environment; do
    ./scripts/stow-package.sh $pkg remove 2>/dev/null || true
done

# Restore original configurations
./scripts/restore.sh latest all
```

**Selective recovery:**
```bash
# Restore specific component
./scripts/restore.sh latest COMPONENT

# Test before reapplying
./scripts/test-config.sh COMPONENT

# Reapply if needed
./scripts/stow-package.sh COMPONENT
```

## Advanced Usage

### Custom Tool Installation

```bash
# Install additional tools manually
brew install tool-name

# Add to setup-tools.sh for persistence
# Edit scripts/setup-tools.sh and add to install_rust_tools()
```

### Configuration Customization

```bash
# Local overrides (not version controlled)
touch ~/.gitconfig.local      # Git overrides
touch ~/.zshenv.local         # Environment overrides  
touch ~/.aliases.local        # Personal aliases
```

### Workspace Customization

```bash
# Edit workspace script
vi scripts/tmux-claude-workspace

# Custom layouts, commands, or naming conventions
# Modify create_tmux_layout() function
```

## Integration Examples

### Daily Development Workflow

```bash
# Morning setup
cw myproject auth-feature api-feature

# In tmux panes:
# Pane 1: claude-code . (auth worktree)
# Pane 2: claude-code . (api worktree)
# Pane 3: nvim src/
# Pane 4: git status && git lg

# Development cycle
git dt                    # Review changes with difftastic
git dtl -3               # Recent commits with syntax diffs
ll2                      # Enhanced directory listing
cat2 config.json         # Syntax highlighted viewing
find2 "component" src/   # Fast file search
grep2 "function" src/    # Fast text search
```

### Tool Migration Strategy

1. **Learn with '2' aliases**: `ll2`, `cat2`, `find2`
2. **Compare performance**: Run both old and new
3. **Gradual adoption**: Replace when comfortable
4. **Create personal aliases**: Your own shortcuts
5. **Update muscle memory**: Practice new patterns

This reference provides comprehensive information for using and troubleshooting your DotClaude setup. For detailed guides, see the specific documentation sections.