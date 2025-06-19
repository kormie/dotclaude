# Tmux Configuration for Claude Code

Deep dive into the vim-optimized tmux configuration designed for Claude Code workflows.

## Configuration Overview

The tmux configuration is specifically designed for:
- **Vim users** with CapsLock rebound to Ctrl
- **Claude Code development** with multi-session workflows
- **Git worktree integration** for parallel development
- **Modern terminal features** with enhanced aesthetics

## Key Philosophy

### Vim-First Design
- **hjkl navigation** throughout all tmux operations
- **Comma (,) secondary leader** matching your vim mapleader
- **Seamless vim/tmux integration** with smart pane switching
- **Copy mode** behaves exactly like vim's visual mode

### CapsLock→Ctrl Optimization
- **C-a prefix** is ergonomic when CapsLock=Ctrl
- **C-hjkl navigation** for seamless vim/tmux switching
- **No finger gymnastics** - all keybindings designed for this setup

## Essential Keybindings

### Pane Operations
```bash
# Splitting (your preferred keys)
C-a |        # Split horizontally
C-a -        # Split vertically

# Navigation (vim-style)
C-a h        # Move to left pane
C-a j        # Move to down pane  
C-a k        # Move to up pane
C-a l        # Move to right pane

# Smart navigation (works with vim)
C-h          # Move left (vim-aware)
C-j          # Move down (vim-aware)
C-k          # Move up (vim-aware)  
C-l          # Move right (vim-aware)

# Resizing (repeatable)
C-a H        # Resize left
C-a J        # Resize down
C-a K        # Resize up
C-a L        # Resize right

# Management
C-a x        # Close pane (vim-like)
C-a z        # Zoom pane toggle
```

### Window Operations
```bash
# Creation and management
C-a c        # New window (in current path)
C-a X        # Close window
C-a &        # Close window (alternative)

# Navigation
C-p          # Previous window (no prefix needed)
C-n          # Next window (no prefix needed)

# File operations (netrw-inspired)
C-a e        # Split with file listing (horizontal)
C-a E        # Split with file listing (vertical)
C-a o        # Open horizontal split
C-a O        # Open vertical split
C-a t        # New window/tab
```

### Claude Code Specific
```bash
# Workspace management
C-a C-w      # Launch Claude workspace popup
C-a ,w       # Launch Claude workspace (comma leader)

# Quick sessions
C-a ,c       # New Claude Code session in window
C-a ,s       # Split with Claude Code (horizontal)
C-a ,v       # Split with Claude Code (vertical)
C-a ,n       # New neovim session

# Git operations
C-a g        # Git status in horizontal split
C-a G        # Git status in new window

# Session management
C-a ,q       # Quit session
C-a ,d       # Detach session
C-a ,l       # List sessions
C-a ,r       # Reload tmux config
```

### Copy Mode (Vim-Style)
```bash
# Enter/exit copy mode
Escape       # Enter copy mode
q            # Exit copy mode
Escape       # Exit copy mode (alternative)

# Selection and movement
v            # Begin selection (visual mode)
C-v          # Rectangle selection
y            # Copy selection
H            # Move to start of line
L            # Move to end of line

# Search (vim-style)
/            # Search forward
?            # Search backward
n            # Next search result
N            # Previous search result

# Text objects (vim-style)
w            # Next word
b            # Previous word  
e            # End of word
```

## Advanced Features

### Session Management
```bash
# Create new session
C-a C-c      # New session
C-a ,        # New session with comma leader

# Session switching
C-a C-f      # Find session (fuzzy search)
C-a s        # List sessions (tmux native)

# Buffer management (vim-style)
C-a b        # List buffers (:ls equivalent)
C-a B        # Choose buffer (:b equivalent)
C-a p        # Paste buffer
```

### Pane Synchronization
```bash
# Sync all panes (useful for Claude sessions)
C-a S        # Toggle pane synchronization
             # Shows "Pane sync ON/OFF" status
```

### Status Bar Features

**Information Display:**
- **Left**: Session name + current directory
- **Right**: Git branch + system info + time
- **Windows**: Show zoom status with asterisk

**Git Integration:**
- Automatically shows current git branch
- Updates when you switch directories
- Shows "no-git" when not in a repository

**Color Scheme:**
- **Dracula-inspired** colors for consistency with git delta
- **Active pane** highlighted in green
- **Current window** highlighted with different background

## Configuration Sections

### General Settings
```bash
# Modern terminal support
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color*:Tc"

# Mouse support for modern workflows
set -g mouse on

# Larger scrollback for Claude Code sessions
set -g history-limit 50000

# Faster command sequences
set -s escape-time 0
```

### Plugin System

**Tmux Plugin Manager (TPM):**
```bash
# Essential plugins
tmux-sensible        # Sensible defaults
tmux-resurrect       # Session persistence  
tmux-continuum       # Automatic session saving
tmux-yank           # Better copy/paste
tmux-open           # Open files/URLs from tmux
tmux-logging        # Log tmux output
```

**Plugin Configuration:**
```bash
# Session restoration
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-capture-pane-contents 'on'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'

# Logging (useful for Claude Code sessions)
set -g @logging-path "$HOME/.tmux/logs"
set -g @screen-capture-key 'M-c'
set -g @save-complete-history-key 'M-C'
```

## Vim Integration

### Smart Pane Navigation

The configuration includes vim-aware navigation that detects when you're in vim and sends the appropriate commands:

```bash
# This magic allows C-hjkl to work both in tmux and vim
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
```

### Copy Mode Enhancements

Copy mode behaves exactly like vim's visual mode:
- Same movement keys (hjkl, w, b, e)
- Same search functionality (/, ?, n, N)
- Same selection model (v for visual, C-v for block)
- Automatic clipboard integration with macOS

## Claude Code Optimizations

### Environment Variables
```bash
# Set for Claude Code sessions
set-environment -g CLAUDE_CODE_TMUX_SESSION 1
set-environment -g EDITOR nvim

# Better handling of long outputs
setw -g aggressive-resize on
set -g terminal-overrides 'xterm*:smcup@:rmcup@'
```

### Workspace-Specific Features

**Pane Titles:**
- Automatically set descriptive titles for each pane
- "Claude: feature-name" for development panes
- "Neovim: project-name" for editor panes
- "Git Operations" for git command panes

**Auto-Start Claude Sessions:**
- Automatically launches `claude .` in Claude Code panes
- Detects if claude command is available
- Falls back to placeholder messages if claude not found
- Seamless startup experience with `tmux-claude-workspace`

**Layout Optimization:**
- Top panes get 60% of screen height for code work
- Bottom panes sized for quick reference and commands
- Automatic layout restoration with tmux-resurrect

## Customization Options

### Personal Keybinding Additions

Add to your local tmux config (not version controlled):

```bash
# ~/.tmux.conf.local (sourced by main config)

# Personal keybindings
bind-key r source-file ~/.tmux.conf \; display "Reloaded!"
bind-key | split-window -h -c "#{pane_current_path}"
bind-key - split-window -v -c "#{pane_current_path}"

# Custom Claude Code shortcuts
bind-key C-d new-window -c "#{pane_current_path}" -n "debug" "claude-code ."
```

### Theme Customization

**Color Scheme Variables:**
```bash
# Dracula colors (customizable)
BG_COLOR="#282a36"
FG_COLOR="#f8f8f2"
ACCENT_COLOR="#6272a4"
HIGHLIGHT_COLOR="#50fa7b"
WARNING_COLOR="#ff5555"
```

**Status Bar Customization:**
```bash
# Custom status bar sections
set -g status-left '#[bg=accent,fg=fg,bold] #S #[bg=bg] #{b:pane_current_path} '
set -g status-right '#[fg=cyan]#(git branch --show-current 2>/dev/null)#[fg=fg] | #[fg=orange]%H:%M'
```

## Integration with Modern Tools

### Git Delta Integration
- Status bar shows current git branch
- Delta themes coordinate with tmux colors
- Copy mode colors match git diff highlighting

### Modern CLI Tool Support
- Environment variables set for bat, fd, ripgrep themes
- PATH configured for modern tools
- Aliases available in all tmux sessions

### Claude Code Specific Environment
- CLAUDE_CODE_TMUX_SESSION variable for detection
- Enhanced terminal capabilities for AI tool output
- Logging capabilities for session review

## Troubleshooting

### Common Issues

**Keybindings not working:**
```bash
# Reload config
C-a r

# Check tmux version
tmux -V  # Needs 3.0+

# Test configuration
tmux -f ~/.tmux.conf -C "list-keys" | head -5
```

**Colors not displaying correctly:**
```bash
# Test terminal colors
echo $TERM
infocmp $TERM | grep -o 'colors#[0-9]*'

# Should show 256 colors
```

**Plugin issues:**
```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install plugins
C-a I  # (capital I)
```

### Performance Optimization

**For large codebases:**
```bash
# Reduce status bar update frequency
set -g status-interval 15

# Limit scrollback for better performance
set -g history-limit 10000
```

**For many sessions:**
```bash
# Reduce aggressive resize frequency
setw -g aggressive-resize off
```

## Best Practices

### Session Management
1. Use descriptive session names
2. Keep one Claude Code workspace per project
3. Use tmux-resurrect for persistence
4. Regular cleanup of old sessions

### Pane Usage
1. Keep Claude Code panes large (top row)
2. Use bottom panes for quick commands
3. Sync panes when needed for identical commands
4. Close unused panes to reduce clutter

### Integration with Vim
1. Use consistent keybindings between vim and tmux
2. Configure vim to work well with tmux colors
3. Use tmux copy mode for system clipboard
4. Leverage smart pane navigation

This tmux configuration provides a powerful foundation for Claude Code development while maintaining vim workflow consistency and modern terminal aesthetics.

## Next Steps

- **[Git Worktrees](/claude-code/worktrees)** - Learn about parallel development workflows
- **[Vim Integration](/claude-code/vim)** - Deeper vim/tmux integration
- **[Automation Scripts](/claude-code/automation)** - Automate common workflows