# Modern Dotfiles Project Plan

## Overview
Create a highly modular, modern CLI setup using GNU Stow for symlink management. Focus on modern tooling, Rust-based CLI replacements, Neovim with Lua configuration, and a clean, maintainable structure.

**PRIMARY GOALS**:
1. **Safety First**: Non-destructive development on primary machine with easy rollback
2. **Modern Tooling**: Rust-based CLI replacements with coexisting aliases
3. **Claude Code Optimization**: Specialized workflows for agentic CLI development
4. **Vim-Style Navigation**: Consistent vim keybindings and workflow patterns

**SAFETY FIRST**: This is being developed on a primary development machine - all changes must be non-destructive and easily reversible.

## Core Principles
- **Modularity**: Each tool/config in its own Stow package
- **Modern Tooling**: Rust replacements for legacy tools where possible
- **Single Source of Truth**: Centralized configuration management
- **Idempotent**: Safe to run setup multiple times
- **Iterable**: Easy to add/remove/modify configurations
- **Non-Destructive**: Always backup existing configs, never overwrite without confirmation
- **Incremental Adoption**: Use new tools as they're ready, maintain existing workflow

## Safety Strategy
### Backup and Rollback
- Automatically backup existing dotfiles before any changes
- Create restore scripts for quick rollback
- Use Git to track all changes with detailed commit messages
- Test each component in isolation before integration

### Incremental Migration
- Develop configurations alongside existing setup
- Use aliases to gradually transition to new tools
- Maintain existing tools until new ones are proven stable
- Allow selective adoption of new configurations

### Testing Approach
- Test all new configurations in separate terminal sessions
- Validate tool functionality before switching defaults
- Keep existing configurations as fallbacks
- Document any breaking changes or requirements

## Directory Structure
```
dotfiles/
├── stow/
│   ├── zsh/              # Zsh + Oh-My-Zsh configuration
│   ├── neovim/           # Neovim Lua configuration
│   ├── git/              # Git configuration
│   ├── rust-tools/       # Modern CLI tools (bat, exa, fd, etc.)
│   ├── tmux/             # Terminal multiplexing
│   ├── aliases/          # Centralized alias management
│   └── environment/      # PATH and environment variables
├── scripts/
│   ├── install.sh        # Main installation script
│   ├── setup-tools.sh    # Install modern CLI tools
│   ├── backup.sh         # Backup existing configurations
│   ├── restore.sh        # Restore previous configurations
│   └── stow-all.sh       # Stow all packages
├── backups/              # Automatic backups of existing configs
└── docs/
    └── TOOLS.md          # Documentation of all tools and configs
```

## Phase 1: Foundation & Safety ✅ COMPLETED
**Goal**: Set up infrastructure without breaking existing setup

### Milestone 1.1: Safety Infrastructure ✅
- ✅ Create comprehensive backup system for existing dotfiles (`./scripts/backup.sh`)
- ✅ Set up GNU Stow directory structure with all packages
- ✅ Create restore/rollback scripts with safety confirmations (`./scripts/restore.sh`)
- ✅ Test backup and restore on existing dotfiles (successfully backed up .zshrc, .gitconfig, .vim, nvim config)

### Milestone 1.2: Parallel Development Setup ✅
- ✅ Set up Git configuration package with modern features (delta, difftastic, user's preferred log format)
- ✅ Create environment variables package for PATH management (XDG compliance, modern tools)
- ✅ Create centralized alias management system
- ✅ Create comprehensive validation scripts (`./scripts/test-config.sh`)

### Milestone 1.3: Safe Tool Installation ✅
- ✅ Modern CLI tool installation script with coexisting aliases (`./scripts/setup-tools.sh`)
- ✅ Create aliases that coexist with existing commands (ll2, cat2, find2, etc.)
- ✅ Document all modern tool replacements and migration paths
- ✅ Stow package management system (`./scripts/stow-package.sh`)

**Phase 1 Success Criteria ACHIEVED**: 
- ✅ All existing functionality remains intact
- ✅ Modern tools ready for installation and testing
- ✅ Backup/restore system tested and working reliably  
- ✅ Easy switching between old and new configs with safety nets

### Enhanced Features Implemented:
- **Advanced Git Configuration**: User's preferred log format, delta + difftastic via GIT_EXTERNAL_DIFF
- **Colima Support**: Docker aliases updated for colima compatibility
- **User Settings Preserved**: SSH GPG signing, GitHub SSH URLs, Git LFS, keychain integration
- **Modern Diff Tools**: Delta as default, difftastic for syntax-aware analysis
- **Claude Code Optimization**: Specialized tmux workflows for agentic development
- **Vim-Style Navigation**: CapsLock=Ctrl optimized keybindings, comma leader, hjkl navigation

### Claude Code Development Features:
- **Multi-Session Tmux Layout**: 4-pane setup with parallel Claude Code sessions using git worktrees
- **Automated Workspace Setup**: `tmux-claude-workspace` script for instant development environment
- **Vim-Optimized Keybindings**: Seamless navigation between vim and tmux with consistent hjkl patterns
- **Git Worktree Integration**: Parallel development on different features without branch conflicts
- **Session Management**: Named sessions, easy switching, and workspace persistence

## Phase 2: Incremental Shell Enhancement (Week 2)
**Goal**: Enhance shell without breaking existing workflow

### Milestone 2.1: Safe Zsh Enhancement
- [ ] Backup existing Zsh configuration
- [ ] Create new Oh-My-Zsh setup alongside existing
- [ ] Test new configuration in separate terminal sessions
- [ ] Create toggle mechanism between old/new configs

### Milestone 2.2: Modern Tool Integration
- [ ] Add modern tools as additional commands (not replacements)
- [ ] Create optional aliases (e.g., `ll2` for `exa`)
- [ ] Test performance and functionality thoroughly
- [ ] Document benefits and usage patterns

### Milestone 2.3: Gradual Alias Migration
- [ ] Set up centralized alias management
- [ ] Create migration path from existing aliases
- [ ] Test alias conflicts and resolutions
- [ ] Implement gradual transition strategy

## Phase 3: Editor Enhancement (Week 3)
**Goal**: Enhance development environment safely

### Milestone 3.1: Neovim Parallel Setup
- [ ] Install/configure Neovim without affecting existing editor
- [ ] Set up Lua configuration in parallel
- [ ] Test essential plugins and LSP setup
- [ ] Create migration guide from existing editor setup

### Milestone 3.2: Development Tool Integration
- [ ] Configure modern git tools (delta, etc.) as alternatives
- [ ] Set up enhanced terminal multiplexing (tmux)
- [ ] Test development workflow with new tools
- [ ] Create fallback mechanisms for critical workflows

### Milestone 3.3: Workflow Validation
- [ ] Test complete development workflows
- [ ] Validate performance improvements
- [ ] Document any breaking changes or limitations
- [ ] Create quick-switch mechanisms

## Phase 4: Full Integration & Optimization (Week 4)
**Goal**: Complete migration with safety nets

### Milestone 4.1: Confident Migration
- [ ] Switch to new configurations as primary (with easy rollback)
- [ ] Optimize performance and startup times
- [ ] Clean up redundant configurations
- [ ] Validate all functionality works as expected

### Milestone 4.2: Advanced Features
- [ ] Implement advanced shell features and customizations
- [ ] Set up project-specific environment management
- [ ] Configure advanced Neovim features
- [ ] Integrate all tools into cohesive workflow

### Milestone 4.3: Final Validation
- [ ] Complete system testing
- [ ] Performance benchmarking
- [ ] Documentation completion
- [ ] Create final migration checklist

## Safety Commands & Procedures

### Before Each Major Change
```bash
# Always backup before changes
./scripts/backup.sh

# Test new configuration
./scripts/test-config.sh [component]

# Apply changes
./scripts/stow-package.sh [package]

# Rollback if needed
./scripts/restore.sh [component]
```

### Emergency Rollback
- Keep existing shell sessions open during testing
- Use `exec $SHELL` to test new shell configs
- Keep backup terminal with original configs
- Document all changes in commit messages

## Risk Mitigation Strategies
- **Incremental Changes**: One component at a time
- **Parallel Development**: Build alongside, not replace
- **Extensive Testing**: Validate before switching
- **Easy Rollback**: Always have a way back
- **Documentation**: Record every change and decision
- **Validation Scripts**: Automated testing where possible

## Success Metrics
- **Zero Downtime**: Existing workflow never breaks
- **Improved Performance**: Measurable improvements in speed
- **Enhanced Functionality**: New capabilities without losing old ones
- **Easy Maintenance**: Clear upgrade and rollback paths
- **Adoption Flexibility**: Can use new tools at own pace

This approach ensures your development environment stays stable while we build an amazing modern CLI setup!