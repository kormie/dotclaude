# Editor Integration

Modern Neovim configuration with Lua, LSP support, and AI development optimizations.

## Overview

DotClaude provides a comprehensive Neovim setup optimized for modern development workflows and AI-assisted coding.

## Key Features

### Modern Plugin Management
- **lazy.nvim** - Fast, modern plugin manager
- **40+ Curated Plugins** - Essential tools for productive development
- **Lazy Loading** - Optimized startup performance

### Language Server Protocol (LSP)
- **Mason** - LSP server management
- **nvim-lspconfig** - Pre-configured language servers
- **Completion** - Intelligent code completion
- **Diagnostics** - Real-time error detection

### Enhanced Git Integration
- **Gitsigns** - Git status in the gutter
- **Fugitive** - Comprehensive git commands
- **Diffview** - Advanced diff visualization
- **Delta/Difftastic** - Enhanced diff tools

### Modern UI
- **Tokyo Night** - Beautiful, consistent theme
- **Lualine** - Informative status line
- **Neo-tree** - Modern file explorer
- **Telescope** - Fuzzy finder for everything

## Configuration Structure

```
stow/neovim/.config/nvim/
├── init.lua              # Main configuration entry
├── lua/
│   ├── config/           # Core configuration
│   ├── plugins/          # Plugin specifications
│   └── user/             # User preferences
```

## User Preferences Preserved

### Vim Workflow
- **Comma Leader** - `,` as leader key
- **hjkl Navigation** - Consistent movement
- **jk Escape** - Quick mode switching
- **Netrw Patterns** - Familiar file navigation (now with Neo-tree)

### Claude Code Integration
F-key shortcuts for AI development:
- **F1** - Open current file in Claude
- **F2** - Send visual selection to Claude
- **F3** - Claude Code workspace shortcuts
- **F4-F12** - Additional AI workflow shortcuts

## Installation & Usage

```bash
# Apply Neovim configuration
./scripts/stow-package.sh neovim

# Launch Neovim
nvim

# Or use the toggle system
./scripts/toggle-neovim.sh enhanced
```

## Safety Toggle System

Easy switching between configurations:

```bash
# Switch to enhanced Neovim
./scripts/toggle-neovim.sh enhanced

# Revert to original configuration
./scripts/toggle-neovim.sh original

# Check current status
./scripts/toggle-neovim.sh status
```

## Key Features Overview

### LSP Integration
- **Automatic Setup** - Language servers configured automatically
- **Intelligent Completion** - Context-aware suggestions
- **Go-to Definition** - Navigate code effortlessly
- **Real-time Diagnostics** - Immediate feedback

### Telescope Integration
Fuzzy finding for everything:
- **Files** - `<leader>ff` - Find files
- **Text** - `<leader>fg` - Live grep
- **Buffers** - `<leader>fb` - Open buffers
- **Git** - `<leader>gc` - Git commits
- **LSP** - `<leader>fs` - LSP symbols

### Git Workflow
- **Gitsigns** - Visual git status
- **Fugitive** - Full git integration
- **Diffview** - Enhanced diff viewing
- **Blame** - Line-by-line git blame

## Plugin Highlights

### Core Functionality
- **Treesitter** - Advanced syntax highlighting
- **LSP** - Language server integration
- **Completion** - Intelligent autocompletion
- **Snippets** - Code snippet expansion

### Productivity
- **Telescope** - Fuzzy finding
- **Neo-tree** - File management
- **Which-key** - Keybinding hints
- **Comment** - Easy commenting

### Git Integration
- **Gitsigns** - Git decorations
- **Fugitive** - Git commands
- **Diffview** - Diff visualization

## Migration Guide

### From Original Neovim
1. **Backup** - Configuration is backed up automatically
2. **Toggle** - Use toggle script for safe switching
3. **Learn** - Gradual adoption of new features
4. **Customize** - Modify user preferences as needed

### Learning Path
1. **Basic Navigation** - hjkl, leader key patterns
2. **File Management** - Neo-tree and Telescope
3. **LSP Features** - Go-to definition, completion
4. **Git Integration** - Gitsigns and Fugitive
5. **Advanced Features** - Custom shortcuts and workflows

## Troubleshooting

### Common Issues
- **LSP Loading** - Check Mason installation
- **Plugin Errors** - Verify lazy.nvim setup
- **Performance** - Optimize plugin loading
- **Keybindings** - Check for conflicts

### Getting Help
- Check the troubleshooting guide
- Review plugin documentation
- Use `:checkhealth` for diagnostics