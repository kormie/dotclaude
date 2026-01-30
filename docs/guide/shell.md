# Shell Enhancement

Oh-My-Zsh integration with modern CLI tools, the KOHO theme, and a terminal tips system for learning.

## Overview

DotClaude's shell enhancement provides a modern, productive command-line experience with Oh-My-Zsh integration, Rust-based tool alternatives, and a built-in tips system to help you learn and remember all the functionality.

## Key Features

### Oh-My-Zsh Integration
- **Essential Plugins**: git, zsh-autosuggestions, zsh-syntax-highlighting
- **KOHO Theme**: Custom branded theme with git status and Nerd Font support
- **Plugin Management**: Curated selection for performance and utility

### Modern Tool Alternatives

Rust-based tools are available alongside (not replacing) traditional commands:

| Traditional | Modern Alternative | Usage |
|-------------|-------------------|-------|
| `cat` | `bat` | `bat file.js` - syntax highlighting |
| `find` | `fd` | `fd "*.md"` - faster, simpler syntax |
| `grep` | `rg` | `rg "pattern"` - blazing fast |
| `du` | `dust` | `dust` - visual disk usage |
| `ps` | `procs` | `procs` - modern process viewer |
| `top` | `btm` | `btm` - beautiful system monitor |
| `cd` | `z` | `z project` - smart directory jumping |

::: tip Learn the Tools Naturally
The terminal tips system will remind you about these modern alternatives when you use traditional commands. No need to memorize - just use the terminal and learn as you go.
:::

### Terminal Tips System

A three-layer system to help you discover and remember terminal functionality:

#### Startup Tips
Each new shell shows a random tip below the KOHO banner:

```
██╗  ██╗ ██████╗ ██╗  ██╗ ██████╗
██║ ██╔╝██╔═══██╗██║  ██║██╔═══██╗
█████╔╝ ██║   ██║███████║██║   ██║
██╔═██╗ ██║   ██║██╔══██║██║   ██║
██║  ██╗╚██████╔╝██║  ██║╚██████╔╝
╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝

    3, 2, 1… Let's get it!

┌─[Modern]───────────────────────────────────────────────────┐
│ bat → Syntax-highlighted file viewing with line numbers    │
│ Try: bat ~/.zshrc                                          │
└────────────────────────────────────────────────────────────┘
```

#### Context-Triggered Coaching
When you use traditional commands, gentle reminders suggest modern alternatives:

```bash
$ cat ~/.zshrc
# ... output ...
Tip (1/3): Use 'bat' instead of 'cat' for syntax highlighting
```

On the third use in a session, the command is soft-blocked to encourage learning:

```bash
$ cat ~/.zshrc
Blocked: You've used 'cat' 3 times this session
   Use 'bat' instead, or 'command cat' to bypass
```

#### On-Demand Commands

```bash
tip              # Show a random tip
tips             # List available categories
tips modern      # Show all modern tool tips
tips git         # Show git-related tips
tips tmux        # Show tmux keybinding tips
tips-stats       # View session coaching statistics
tips-reset       # Reset coaching counters
tips-reload      # Reload tips after editing
```

**Tip Categories:**
- `modern` - Rust tool alternatives (bat, fd, rg, dust, etc.)
- `git` - Git aliases and difftastic
- `zsh` - Advanced shell tricks
- `tmux` - Key bindings and workflows
- `nav` - Directory navigation
- `docker` - Container shortcuts
- `k8s` - Kubernetes shortcuts

### Centralized Alias Management
Single source of truth for all aliases:
- Located in `~/.aliases` (symlinked from stow package)
- Includes convenience shortcuts (`ll`, `la`, `tree`, etc.)
- Git workflow shortcuts (`gs`, `ga`, `gc`, etc.)
- Modern tool shortcuts (`preview`, `tree_git`, etc.)

## Configuration Files

The shell package includes:
- `stow/zsh/.zshrc` - Main shell configuration
- `stow/zsh/.oh-my-zsh/custom/themes/koho.zsh-theme` - KOHO branded theme
- `stow/aliases/.aliases` - Centralized aliases
- `stow/tips/` - Terminal tips system

## Tips Configuration

Control the tips system via environment variables in `~/.zshrc.local`:

```bash
export TIPS_STARTUP=0      # Disable startup tips (keep banner)
export TIPS_COACHING=0     # Disable context-triggered reminders
export TIPS_BLOCK_COUNT=5  # Change soft-block threshold (default: 3)
```

## Installation & Usage

```bash
# Apply shell configuration
./scripts/stow-package.sh zsh
./scripts/stow-package.sh aliases
./scripts/stow-package.sh tips

# Reload shell to apply changes
exec $SHELL
```

## Safe Alias Philosophy

DotClaude intentionally does NOT alias core commands to modern replacements:

```bash
# These use standard commands (safe for scripts and Claude Code)
cat file.txt    # Standard cat
find . -name x  # Standard find
grep pattern    # Standard grep

# Use modern tools explicitly
bat file.txt    # Syntax highlighting
fd "*.md"       # Fast file finding
rg pattern      # Fast searching
```

**Why?** Aliasing `cat` to `bat` or `find` to `fd` breaks:
- Non-interactive shells and scripts
- Tools like Claude Code that expect standard behavior
- Muscle memory when on other machines

The tips system teaches you to use modern tools directly.

## Customization

### Adding New Aliases
```bash
# Edit centralized alias file
$EDITOR ~/.aliases

# Or add machine-specific aliases
$EDITOR ~/.aliases.local

# Reload
source ~/.aliases
```

### Adding Custom Tips
```bash
# Edit tip files (pipe-delimited format)
$EDITOR ~/.config/dotfiles/tips/tips-data/modern.tips

# Format: tool|old_pattern|description|example
bat|cat |Syntax-highlighted viewing|bat ~/.zshrc

# Reload tips
tips-reload
```

## Safety Features

### Backup & Restore
```bash
# Backup existing shell config
./scripts/backup.sh shell

# Restore if needed
./scripts/restore.sh shell
```

### Plugin Management
Oh-My-Zsh plugins are managed in `.zshrc`:
- Performance-focused selection
- Essential productivity features
- Git workflow optimization
