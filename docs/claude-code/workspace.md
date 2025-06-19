# Claude Code Workspace Setup

Launch 1-5 parallel Claude Code sessions with git worktrees for conflict-free AI development.

::: tip Script Features
The `tmux-claude-workspace` script includes:
- ✅ **Auto-validation**: Checks git repo, tmux, and Claude CLI availability
- ✅ **Colored output**: Status messages with color-coded logging
- ✅ **Auto-cleanup**: Prompts to remove worktrees when session ends
- ✅ **Help support**: Use `-h` or `--help` for detailed usage information
:::

## Quick Start

```bash
# Launch workspace with single feature
tmux-claude-workspace myproject auth-system

# Launch with multiple features (horizontal layout)
tmux-claude-workspace myproject auth-system payment-api notifications dashboard

# Quick alias (if configured)
cw myproject auth-system payment-api
```

::: info Command Aliases
The `cw` command is an alias for `tmux-claude-workspace` defined in the aliases package:
```bash
alias cw='tmux-claude-workspace'
```
This alias is available after applying the aliases configuration with `./scripts/stow-package.sh aliases`.
:::

## Workspace Layout

The `tmux-claude-workspace` script creates a horizontal layout with 1-5 Claude Code sessions on top and a worktree-switching terminal at the bottom:

**2 Features:**
```
┌─────────────────┬─────────────────┐  
│ Claude: auth    │ Claude: api     │  ← Parallel Claude Code sessions
├─────────────────┴─────────────────┤
│        Terminal (Worktree Switcher)│  ← Switch between worktrees
└─────────────────────────────────────┘
```

**5 Features:**
```
┌──────┬──────┬──────┬──────┬──────┐  
│Claude│Claude│Claude│Claude│Claude│  ← Up to 5 parallel sessions
│ auth │ api  │notify│dash  │admin │
├──────┴──────┴──────┴──────┴──────┤
│     Terminal (Worktree Switcher)  │  ← Navigate all worktrees
└───────────────────────────────────┘
```

### Pane Breakdown

1. **Top Row**: 1-5 Claude Code sessions, each in its own git worktree
2. **Bottom Pane**: Terminal with `cw-switch` command for worktree navigation

## Git Worktree Integration

Each Claude Code session works in its own git worktree:

```bash
# Automatic worktree creation for all features
.worktrees/
├── auth-system/      # First Claude session workspace
├── payment-api/      # Second Claude session workspace
├── notifications/    # Third Claude session workspace
└── dashboard/        # Fourth Claude session workspace
```

**Benefits:**
- No git state conflicts between parallel sessions
- Each session can be on different branches
- Independent development without interference
- Easy feature switching and merging

## Vim-Optimized Keybindings

Navigate efficiently with vim-style tmux keybindings:

```bash
C-a |        # Split pane horizontally  
C-a -        # Split pane vertically
C-a hjkl     # Navigate panes (vim-style)
C-a ,w       # Launch new Claude Code workspace
C-a ,c       # New Claude Code session in current pane
C-a ,n       # New neovim session
Escape       # Enter copy mode
C-hjkl       # Smart vim/tmux navigation (with CapsLock→Ctrl)
```

## Workspace Commands

### Launch Commands
```bash
# Single feature workspace
tmux-claude-workspace project-name auth-system

# Multiple features (2-5 supported)
tmux-claude-workspace project-name auth-system payment-api notifications

# Maximum features (5 limit)
tmux-claude-workspace my-app auth api notify dash admin

# Get help
tmux-claude-workspace --help

# Quick alias (if configured)
cw project-name auth-system payment-api
```

### Session Management
```bash
# List active sessions
tmux list-sessions

# Attach to existing session
tmux attach-session -t claude-dev-myproject

# Detach from session
C-a d

# Kill session
C-a ,q
```

## Development Workflow

### 1. Start Workspace
```bash
tmux-claude-workspace myapp user-auth payment-api
```

### 2. Claude Code Sessions Auto-Start
```bash
# Claude Code sessions start automatically when workspace launches:
# All top panes automatically execute: claude .

# Manual startup only needed if claude command unavailable
claude .  # If auto-start failed or claude was not found
```

### 3. Use Bottom Terminal Pane
```bash
# Switch between worktrees
cw-switch           # List all available worktrees
cw-switch 1         # Switch to first worktree (auth-system)
cw-switch 3         # Switch to third worktree (notifications)

# Git operations in any worktree
git status
git commit -m "feature implementation"
git push

# Navigate back to main repo
cd ..
```

## Advanced Features

### Pane Synchronization
Send same commands to multiple panes:
```bash
C-a S    # Toggle pane synchronization
```

### Session Persistence
Sessions automatically restore with tmux-resurrect:
- Window layouts preserved
- Pane contents restored  
- Working directories maintained

### Workspace Cleanup
```bash
# Automatic cleanup prompt when exiting workspace
# Or manual cleanup:
git worktree remove .worktrees/auth-system
git worktree remove .worktrees/payment-api
# ... remove all feature worktrees
rmdir .worktrees
```

## Customization

### Custom Layout
Edit `scripts/tmux-claude-workspace` to modify:
- Pane sizes and arrangement
- Default commands in each pane
- Workspace naming conventions

### Additional Panes
```bash
# Add monitoring pane
C-a |              # Split horizontally
htop               # System monitoring

# Add log pane  
C-a -              # Split vertically
tail -f app.log    # Log monitoring
```

## Troubleshooting

**Workspace won't start?**
```bash
# Check tmux availability
which tmux

# Check script permissions
ls -la scripts/tmux-claude-workspace
```

**Git worktree conflicts?**
```bash
# List existing worktrees
git worktree list

# Remove conflicting worktree
git worktree remove .worktrees/feature-name
```

**Claude Code not found?**
- The script automatically detects Claude CLI availability
- If found: `claude .` auto-starts in each top pane
- If not found: Panes display helpful message and wait for manual commands
- Install Claude Code CLI and relaunch workspace for full auto-start feature
- Script provides colored status messages about Claude CLI detection

**Too many features?**
- Maximum 5 features supported for optimal screen space
- Use multiple workspaces for larger projects
- Consider grouping related features

## Tips & Best Practices

1. **Start Fresh**: Use new feature branch names for each workspace
2. **Regular Commits**: Commit frequently in each worktree to avoid conflicts
3. **Session Names**: Use descriptive names for easy session switching
4. **Cleanup**: Remove worktrees after merging to keep repository clean
5. **Backup**: Workspace creation automatically backs up existing configs

## Next Steps

- [Learn tmux configuration details](/claude-code/tmux)
- [Explore git worktree workflows](/claude-code/worktrees)
- [Discover automation scripts](/claude-code/automation)