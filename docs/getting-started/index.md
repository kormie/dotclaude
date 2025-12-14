# Installation

Get started with DotClaude in minutes with our safety-first approach.

## Prerequisites

- **macOS** (tested on macOS Sonoma 14.5+)
- **Basic terminal familiarity**

That's it! The installer handles everything else (Homebrew, Git, Xcode CLI tools).

## Quick Installation (Fresh Mac)

For a brand new Mac without SSH keys configured:

```bash
# One-liner bootstrap - works without SSH keys
curl -fsSL bootstrap.kormie.link | bash
```

### Install Options

```bash
# Full installation (default) - all features
curl -fsSL bootstrap.kormie.link | bash

# Minimal installation - core only
curl -fsSL bootstrap.kormie.link | INSTALL_MODE=minimal bash

# Interactive installation - choose components
curl -fsSL bootstrap.kormie.link | INSTALL_MODE=interactive bash
```

## Installation (With SSH Keys)

If you already have SSH keys configured with GitHub:

```bash
# Clone and install
git clone git@github.com:kormie/dotclaude.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh --all
```

## Installation (HTTPS)

```bash
# Clone via HTTPS
git clone https://github.com/kormie/dotclaude.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh --all
```

## What Gets Installed

The setup script installs modern CLI tools that **coexist** with your existing setup:

| Tool | Purpose | Alias | Original |
|------|---------|--------|----------|
| [exa/eza](https://github.com/eza-community/eza) | Enhanced ls | `ll2` | `ls` |
| [bat](https://github.com/sharkdp/bat) | Syntax highlighting cat | `cat2` | `cat` |
| [fd](https://github.com/sharkdp/fd) | Fast find alternative | `find2` | `find` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Ultra-fast grep | `grep2` | `grep` |
| [delta](https://github.com/dandavison/delta) | Better git diffs | (git integration) | - |
| [difftastic](https://github.com/Wilfred/difftastic) | Syntax-aware diffs | `git dtl` | - |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart directory navigation | `z` | `cd` |

## Safety Features

Your existing setup remains **completely untouched**:

- ✅ All existing dotfiles are automatically backed up
- ✅ New tools use different command names (with `2` suffix)
- ✅ Original commands continue to work exactly as before
- ✅ Easy rollback if you want to remove anything

## Next Steps

1. **[Quick Setup](./quick-setup)** - Apply your first configurations
2. **[Safety Guide](./safety)** - Understand the backup/restore system  
3. **[Modern Tools](./tools)** - Learn about the new CLI tools

## Verification

Verify your installation is working:

```bash
# Check tool availability
ll2        # Should show enhanced directory listing
cat2 --help # Should show bat help with syntax highlighting info
git lg     # Should show your preferred git log format

# Test Claude Code workspace (if claude-code is installed)
cw test-project feature-1 feature-2  # 'cw' is an alias for 'tmux-claude-workspace'
```

## Troubleshooting

**Command not found errors?**
```bash
# Reload your shell configuration
source ~/.zshrc
# or
exec $SHELL
```

**Need to rollback?**
```bash
# Restore from automatic backup
./scripts/restore.sh
```

**Still having issues?**
Check our [troubleshooting guide](/reference/troubleshooting) or [open an issue](https://github.com/kormie/dotclaude/issues).

## What's Next?

Once installation is complete, you're ready to:
- [Apply your first configurations](./quick-setup)
- [Launch Claude Code workspaces](/claude-code/workspace)
- [Explore the modern tools](./tools)