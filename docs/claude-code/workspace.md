# Claude Code Workspace Setup

Launch parallel Claude Code sessions with git worktrees for conflict-free AI development.

## Quick Start

```bash
# Launch workspace with 4-pane layout
cw myproject feature-auth feature-api

# Alternative command
claude-workspace myproject feature-auth feature-api
```

## Workspace Layout

The `tmux-claude-workspace` script creates an optimized 4-pane layout:

```
┌─────────────────┬─────────────────┐  
│ Claude: auth    │ Claude: api     │  ← Parallel Claude Code sessions
├─────────────────┼─────────────────┤
│ Neovim          │ Git Operations  │  ← Code editing + git operations
└─────────────────┴─────────────────┘
```

### Pane Breakdown

1. **Top Left**: Claude Code session for first feature (uses git worktree)
2. **Top Right**: Claude Code session for second feature (separate worktree)  
3. **Bottom Left**: Neovim for code editing in main repository
4. **Bottom Right**: Git operations and general terminal commands

## Git Worktree Integration

Each Claude Code session works in its own git worktree:

```bash
# Automatic worktree creation
.worktrees/
├── feature-auth/     # First Claude session workspace
└── feature-api/      # Second Claude session workspace
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
# Basic workspace
cw project-name

# With feature branches
cw project-name auth-system payment-flow

# Custom session name  
tmux-claude-workspace my-app user-mgmt api-refactor
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
cw myapp user-auth payment-api
```

### 2. Claude Code Sessions Auto-Start
```bash
# Claude Code sessions start automatically when workspace launches:
# Pane 1 (user-auth worktree): claude . is executed automatically
# Pane 2 (payment-api worktree): claude . is executed automatically

# Manual startup only needed if claude command unavailable
claude .  # If auto-start failed or claude was not found
```

### 3. Use Neovim Pane
```bash
# Open project in neovim
nvim src/

# Quick file editing
C-a ,e    # Split with neovim
```

### 4. Git Operations Pane
```bash
# Check overall project status
git status
git lg

# Merge completed features
git checkout main
git merge feature-auth
git merge feature-api
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
# Remove worktrees when done
git worktree remove .worktrees/feature-auth
git worktree remove .worktrees/feature-api
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
- The workspace will still create the layout with placeholder messages
- Claude Code sessions won't auto-start, but panes are ready
- Install Claude Code CLI and relaunch workspace for auto-start feature

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