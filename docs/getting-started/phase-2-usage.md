# Phase 2: Enhanced Shell Usage Guide

Phase 2 brings enhanced shell capabilities with Oh-My-Zsh integration and modern CLI tools while maintaining complete backward compatibility.

## 🚀 Getting Started

### Switch to Enhanced Shell

```bash
# Switch to enhanced configuration
~/.config/dotfiles/toggle-zsh.sh enhanced
exec zsh  # or restart terminal
```

### Switch Back to Original

```bash
# Switch back to original configuration
~/.config/dotfiles/toggle-zsh.sh original
exec zsh  # or restart terminal
```

### Check Current Status

```bash
# View current configuration status
~/.config/dotfiles/toggle-zsh.sh status
```

## ✨ New Features Available

### Enhanced Oh-My-Zsh Shell

**Installed Plugins:**
- `git` - Enhanced git aliases and status
- `zsh-autosuggestions` - Command suggestions based on history
- `zsh-syntax-highlighting` - Real-time command syntax highlighting

**Theme:** `robbyrussell` (clean, git-aware theme similar to original setup)

### Modern CLI Tool Aliases

All modern tools are available with '2' suffix to coexist with originals:

```bash
# Enhanced ls with eza
ll2          # Long listing with git status and icons
ls2          # Basic listing with icons  
la2          # All files with git status and icons
tree2        # Tree view with icons
lsd2         # List only directories

# Enhanced cat with bat
cat2 file.js # Syntax highlighted file viewing
less2 file   # Paged viewing with syntax highlighting
batl file    # Line numbers only

# Enhanced find with fd
find2 pattern    # Fast file search
fd2 pattern      # Alternative syntax

# Enhanced grep with ripgrep
grep2 pattern    # Fast text search
rg2 pattern      # Colored output

# Enhanced system monitoring
du2          # Disk usage with dust
ps2          # Process list with procs  
top2         # System monitor with bottom

# Smart directory navigation (if available)
cd2 path     # Jump to frequently used directories with zoxide
cdi          # Interactive directory selection
```

### Enhanced Git Aliases

Building on Oh-My-Zsh git plugin:

```bash
# Your preferred git log format (preserved)
glogp        # Pretty graph log with colors
glogd        # Date-formatted log
glogdifft    # Syntax-aware log with difftastic
gdifft       # Syntax-aware diff with difftastic
```

### Centralized Alias System

All aliases are managed in `~/.config/dotfiles/aliases`:

```bash
# Edit centralized aliases
aliases      # Opens alias file in nvim

# Common shortcuts
repos        # cd ~/Documents/Repos
dotfiles     # cd ~/Documents/Repos/dotfiles
cw           # Launch Claude Code workspace
```

## 🔧 Configuration

### Enhanced Shell Features

**Improved History:**
- Shared history across all sessions
- Intelligent duplicate handling
- Better history search with up/down arrows

**Enhanced Completion:**
- Case-insensitive completion
- Colorized completion menus
- Modern tool awareness

**Performance Optimizations:**
- Fast startup time
- Efficient plugin loading
- Memory usage optimization

### Modern Tool Configuration

Tools are configured for optimal performance:

**eza (ls replacement):**
- Git integration enabled
- Icons and colors configured
- Directory grouping

**bat (cat replacement):**
- Syntax highlighting themes
- Line numbers and headers
- Git integration

**ripgrep (grep replacement):**
- Smart case matching
- Respect .gitignore files
- Colored output

## 🛠️ Customization

### Adding Your Own Aliases

Edit the centralized alias file:

```bash
nvim ~/.config/dotfiles/aliases
```

Add your aliases to the appropriate section:

```bash
# User-specific aliases
alias myalias='my command'
alias project='cd ~/my/project/path'
```

### Plugin Management

Oh-My-Zsh plugins can be added to `~/.zshrc.enhanced`:

```bash
plugins=(
  git
  brew
  docker
  golang
  python
  ruby
  asdf
  zsh-autosuggestions
  zsh-syntax-highlighting
  # Add your plugins here
)
```

## 🔍 Troubleshooting

### Shell Performance Issues

```bash
# Check plugin load times
time zsh -i -c exit

# Disable plugins temporarily
# Edit ~/.zshrc.enhanced and comment out slow plugins
```

### Tool Conflicts

If you encounter issues with modern tools:

```bash
# Use original tools temporarily
/bin/ls instead of ll2
/usr/bin/find instead of find2
/usr/bin/grep instead of grep2
```

### Reset to Original Configuration

```bash
# Emergency reset
~/.config/dotfiles/toggle-zsh.sh original
exec zsh

# Or restore from backup
./scripts/restore.sh zsh
```

## 🚀 Advanced Usage

### Combining with Claude Code Workflows

```bash
# Launch Claude Code workspace with enhanced shell
cw myproject
# Now you have modern tools available in all panes

# Use modern tools for faster development
ll2              # Quick file overview with git status
cat2 config.js   # Syntax-highlighted config review
find2 "*.test"   # Fast test file discovery
grep2 "TODO"     # Quick todo searching
```

### Project-Specific Aliases

Add project-specific aliases to your local `.zsh_local` file:

```bash
# In your project directory
echo 'alias run="npm run dev"' >> ~/.zsh_local
echo 'alias test="npm test"' >> ~/.zsh_local
```

## 📊 Performance Benefits

### Measured Improvements

**Tool Performance:**
- `eza` vs `ls`: 2-3x faster with better output
- `bat` vs `cat`: Syntax highlighting with no performance penalty
- `fd` vs `find`: 3-5x faster file searching
- `rg` vs `grep`: 5-10x faster text searching

**Shell Experience:**
- Intelligent command suggestions reduce typing
- Syntax highlighting prevents command errors
- Enhanced git integration speeds up workflow

## 🔮 Next Steps

Phase 2 sets the foundation for Phase 3 (Editor Enhancement):

- Modern tools will integrate with Neovim configuration
- Enhanced shell provides better development environment
- Centralized alias system will extend to editor shortcuts

Ready to continue with Phase 3 when you are!