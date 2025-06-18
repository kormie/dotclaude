# Phase 3: Editor Enhancement Migration Guide

Phase 3 introduces a modern Neovim configuration while preserving all your existing preferences and workflow patterns.

## 🎯 What's New in Phase 3

### Enhanced Neovim Configuration
- **Modern Plugin System**: Lazy.nvim for fast, efficient plugin management
- **LSP Integration**: Full Language Server Protocol support with completion and diagnostics
- **Git Integration**: Advanced git tools (gitsigns, fugitive, diffview) integrated with delta/difftastic
- **Modern UI**: Beautiful themes, status line, and enhanced visual experience
- **Claude Code Optimization**: Special keybindings and workflows for AI development

### Your Preferences Preserved
✅ **Comma Leader Key**: All configurations use `,` as leader key  
✅ **hjkl Navigation**: Window navigation with `C-hjkl` preserved  
✅ **Netrw Integration**: `-` still opens netrw file explorer  
✅ **jk Escape**: `jk` in insert mode still exits to normal mode  
✅ **Visual Mode**: All your visual mode keybindings preserved  

## 🚀 Quick Start

### Switch to Enhanced Configuration

```bash
# Switch to the enhanced Neovim setup
./scripts/toggle-neovim.sh enhanced

# The first startup will automatically install all plugins
nvim
```

### Switch Back if Needed

```bash
# Return to your original configuration anytime
./scripts/toggle-neovim.sh original
```

### Check Current Status

```bash
# See which configuration is active
./scripts/toggle-neovim.sh status
```

## 🔧 Enhanced Features

### LSP and Completion

**Language Server Support:**
- Automatic LSP server installation via Mason
- Intelligent code completion with nvim-cmp
- Real-time diagnostics and error detection
- Go-to-definition, references, and hover documentation

**Key Bindings (LSP):**
```bash
gd          # Go to definition (via Telescope)
gr          # Go to references (via Telescope)  
K           # Hover documentation
<leader>rn  # Rename symbol
<leader>ca  # Code actions
<leader>ds  # Document symbols
```

### Modern Git Integration

**Enhanced Git Workflow:**
- **Gitsigns**: Real-time git status in sign column
- **Fugitive**: Full git integration with `:Git` commands
- **Diffview**: Beautiful diff and merge conflict resolution
- **Delta Integration**: Your existing delta config works seamlessly

**Git Key Bindings:**
```bash
# Git hunks (gitsigns)
]c          # Next hunk
[c          # Previous hunk
<leader>hs  # Stage hunk
<leader>hr  # Reset hunk
<leader>hp  # Preview hunk

# Git operations (fugitive)
<leader>gs  # Git status
<leader>gc  # Git commit
<leader>gd  # Git diff split
<leader>gb  # Git blame

# Advanced git (diffview)
<leader>gv  # Open diffview
<leader>gh  # File history
```

### Telescope Fuzzy Finding

**Powerful Search and Navigation:**
```bash
<leader>sf  # Find files
<leader>sg  # Live grep
<leader>sb  # Find buffers
<leader>sh  # Search help
<leader>sk  # Search keymaps
<leader>sw  # Search word under cursor

# Git integration
<leader>gf  # Git files
<leader>gc  # Git commits
<leader>gb  # Git branches
```

### Enhanced Text Objects and Navigation

**Better Movement:**
```bash
# Improved navigation (your existing keys enhanced)
<C-d>       # Half page down and center
<C-u>       # Half page up and center
n           # Next search and center
N           # Previous search and center

# Text objects (mini.ai)
af/if       # Around/inside function
ac/ic       # Around/inside class
at/it       # Around/inside HTML tags
```

### Claude Code Workflow Integration

**AI Development Features:**
```bash
<F1>        # Open terminal
<F2>        # Launch Claude Code in tmux pane
<F3>        # Quick git status
<F4>        # Quick git log

# Enhanced clipboard (works with Claude Code)
<leader>y   # Yank to system clipboard
<leader>Y   # Yank line to system clipboard
<leader>p   # Paste without overwriting register
```

## 🎨 Visual Enhancements

### Modern Theme and UI
- **Tokyo Night Theme**: Beautiful, modern colorscheme with excellent syntax highlighting
- **Lualine Status Bar**: Informative status line with git integration
- **Dashboard**: Welcome screen with quick actions
- **Better Notifications**: Non-intrusive notification system

### Enhanced File Explorer
- **Neo-tree**: Modern file explorer (available alongside netrw)
- **Tree View**: `<leader>e` for tree view, `-` for netrw (your preference)
- **Git Integration**: Visual git status in file explorer

## 🔄 Migration Strategy

### Phase 3A: Parallel Testing (Recommended)
1. **Test Enhanced Config**: Switch to enhanced for testing
2. **Learn New Features**: Explore LSP, Telescope, and git tools
3. **Fallback Available**: Switch back to original anytime
4. **Gradual Adoption**: Use new features as you learn them

### Phase 3B: Full Migration (When Ready)
1. **Comfort with New Features**: LSP and modern tools become natural
2. **Workflow Integration**: Claude Code workflows fully adopted
3. **Performance Benefits**: Faster editing and navigation

## 📚 Learning Path

### Week 1: Core Features
- [ ] **LSP Basics**: Learn `gd`, `gr`, `K` for navigation
- [ ] **Telescope**: Master `<leader>sf` and `<leader>sg` 
- [ ] **Git Integration**: Use `<leader>hs` and `<leader>hp` for hunks
- [ ] **Completion**: Get comfortable with nvim-cmp

### Week 2: Advanced Features
- [ ] **Diffview**: Use `<leader>gv` for reviewing changes
- [ ] **Text Objects**: Learn `af`, `ac` for better selection
- [ ] **Sessions**: Use `<leader>qs` for session management
- [ ] **Claude Code Integration**: Master F-key shortcuts

### Week 3: Workflow Optimization
- [ ] **Custom Keybindings**: Add your own shortcuts
- [ ] **LSP Configuration**: Customize for your languages
- [ ] **Git Workflows**: Integrate with your development process
- [ ] **Performance Tuning**: Optimize for your needs

## 🛠️ Customization

### Adding Language Servers

Edit the LSP configuration to add more language servers:

```lua
-- In ~/.config/nvim/lua/plugins/lsp.lua
local servers = {
  -- Add your language servers here
  pyright = {},        -- Python
  tsserver = {},       -- TypeScript/JavaScript  
  rust_analyzer = {},  -- Rust
  gopls = {},          -- Go
}
```

### Custom Keybindings

Add your own keybindings to `~/.config/nvim/lua/user/keymaps.lua`:

```lua
-- Your custom mappings
map('n', '<leader>mm', ':MyCustomCommand<CR>', { desc = 'My custom command' })
```

### Plugin Configuration

Modify plugin configurations in `~/.config/nvim/lua/plugins/`:
- `colorscheme.lua` - Theme settings
- `telescope.lua` - Search configuration  
- `git.lua` - Git tool settings
- `lsp.lua` - Language server settings

## 🐛 Troubleshooting

### Common Issues

**LSP Not Working:**
```bash
# Check Mason installation
:Mason
# Install language server manually
:MasonInstall lua-language-server
```

**Plugins Not Loading:**
```bash
# Check lazy.nvim status
:Lazy
# Sync all plugins
:Lazy sync
```

**Git Integration Issues:**
```bash
# Ensure git tools are available
which git delta difft
# Check git configuration
git config --list | grep -E "(core.pager|diff.external)"
```

### Performance Issues

**Slow Startup:**
```bash
# Check startup time
nvim --startuptime startup.log
# Profile plugins
:Lazy profile
```

**Large Files:**
- LSP automatically disables for files >40k lines
- Treesitter handles large files gracefully
- Use `:set syntax=off` for very large files

## 🔒 Rollback Strategy

### Immediate Rollback
```bash
# Switch back to original immediately
./scripts/toggle-neovim.sh original
```

### Emergency Recovery
```bash
# Restore from backup if something goes wrong
./scripts/restore.sh neovim
# Or restore latest backup manually
cp -r ~/backups/nvim-backup-* ~/.config/nvim
```

### Clean Installation
```bash
# Start fresh if needed
rm -rf ~/.local/share/nvim/lazy
./scripts/toggle-neovim.sh enhanced
# Plugins will reinstall on next startup
```

## 📈 Benefits You'll Experience

### Immediate Improvements
- **LSP Integration**: Instant go-to-definition and documentation
- **Better Completion**: Context-aware code completion
- **Git Visualization**: See changes directly in the editor
- **Fuzzy Finding**: Instantly find files and text across projects

### Long-term Benefits
- **Faster Development**: Reduced context switching
- **Better Code Quality**: Real-time diagnostics and formatting
- **Enhanced Git Workflow**: Visual diff and merge tools
- **Claude Code Integration**: Optimized for AI-assisted development

## 🎓 Advanced Usage

### Project-Specific Configuration

Create project-specific settings with `.nvim.lua` files:

```lua
-- .nvim.lua in project root
vim.opt_local.colorcolumn = "120"
vim.keymap.set('n', '<leader>r', ':!npm run dev<CR>')
```

### Custom Snippets

Add your own snippets to enhance productivity:

```lua
-- In lua/snippets/
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("javascript", {
  s("log", t("console.log()"))
})
```

### Integration with External Tools

The enhanced configuration integrates seamlessly with:
- **Claude Code**: F-key shortcuts and clipboard integration
- **Tmux**: Smart window navigation between vim and tmux
- **Git Tools**: Delta, difftastic, and modern git workflows
- **Modern CLI Tools**: Integration with bat, fd, ripgrep from Phase 2

## 🚀 Next Steps

1. **Try Enhanced Configuration**: `./scripts/toggle-neovim.sh enhanced`
2. **Explore Features**: Start with basic LSP and Telescope
3. **Learn Gradually**: Master one feature at a time
4. **Customize**: Add your own keybindings and preferences
5. **Integrate**: Combine with Phase 1 & 2 features for complete workflow

Phase 3 represents a significant leap forward in editing capabilities while maintaining the familiar, efficient workflow you've built. The safety-first approach ensures you can always return to your original setup while exploring these powerful new features.

**Ready to enhance your development experience? Your comma-leader, hjkl-navigating, netrw-using workflow is preserved and enhanced with modern power tools.**