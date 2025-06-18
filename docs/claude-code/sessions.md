# Session Management for Claude Code Workflows

Advanced session management patterns for maintaining persistent, organized Claude Code development environments.

## Session Architecture

### Session Hierarchy

**DotClaude Session Structure:**
```
tmux sessions
├── claude-dev-project1      # Main project workspace
│   ├── pane-1: Claude Code (feature-auth)
│   ├── pane-2: Claude Code (feature-api)
│   ├── pane-3: Neovim (main repo)
│   └── pane-4: Git operations
├── claude-dev-project2      # Secondary project
├── monitoring               # System monitoring
└── scratch                  # Quick experiments
```

### Session Naming Convention

**Consistent Naming Patterns:**
```bash
# Claude Code development sessions
claude-dev-{project-name}

# Examples:
claude-dev-dotfiles         # DotClaude development
claude-dev-webapp           # Web application project
claude-dev-api-service      # Microservice development
claude-dev-mobile-app       # Mobile application
```

**Session Name Benefits:**
- Easy identification in session lists
- Consistent workspace discovery
- Automation script compatibility
- Clear separation of contexts

## Session Persistence

### Tmux-Resurrect Integration

**Automatic Session Saving:**
```bash
# Configuration in .tmux.conf
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# Enhanced settings for Claude Code sessions
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-capture-pane-contents 'on'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'

# Claude Code specific environments
set -g @resurrect-save-bash-history 'on'
set -g @resurrect-save-command-history 'on'
```

**What Gets Preserved:**
- Pane layouts and sizes
- Working directories for each pane
- Running processes (where possible)
- Neovim sessions with open files
- Command history in each pane

### Manual Session Management

**Session Backup and Restore:**
```bash
# Save current session state
tmux capture-pane -t claude-dev-myproject -p > session-backup.txt

# Save session layout
tmux list-windows -t claude-dev-myproject -F "#{window_layout}" > layout-backup.txt

# Restore session from backup
tmux new-session -d -s claude-dev-myproject-restored
# Manual pane recreation based on saved layout
```

## Advanced Session Patterns

### Project Templates

**Template-Based Session Creation:**
```bash
# ~/bin/claude-template-react
#!/bin/bash
PROJECT_NAME="$1"

# Create session with React-specific layout
tmux new-session -d -s "claude-dev-$PROJECT_NAME"

# Top panes: Claude Code sessions
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "cd components && echo 'Claude: Components'" Enter
tmux select-pane -t 1  
tmux send-keys "cd api && echo 'Claude: API'" Enter

# Bottom panes: Development tools
tmux split-window -v -t 0
tmux split-window -v -t 2
tmux select-pane -t 2
tmux send-keys "nvim src/" Enter
tmux select-pane -t 3
tmux send-keys "npm run dev" Enter

# Focus on first Claude pane
tmux select-pane -t 0
tmux attach-session -t "claude-dev-$PROJECT_NAME"
```

**Template Usage:**
```bash
# Use project templates
claude-template-react myapp
claude-template-python data-analysis
claude-template-go microservice
```

### Multi-Project Session Management

**Project Switching Workflow:**
```bash
# ~/bin/claude-switch
#!/bin/bash
# Quick project switching

if [[ -z "$1" ]]; then
    # Show available sessions
    echo "Available Claude Code sessions:"
    tmux list-sessions | grep "claude-dev-" | cut -d: -f1
    exit 0
fi

PROJECT="$1"
SESSION_NAME="claude-dev-$PROJECT"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    # Attach to existing session
    tmux attach-session -t "$SESSION_NAME"
else
    # Create new session for project
    if [[ -d "$HOME/projects/$PROJECT" ]]; then
        cd "$HOME/projects/$PROJECT"
        cw "$PROJECT"
    else
        echo "Project directory not found: $HOME/projects/$PROJECT"
        exit 1
    fi
fi
```

**Usage Examples:**
```bash
# Switch between projects
claude-switch dotfiles      # Switch to dotfiles project
claude-switch webapp        # Switch to webapp project
claude-switch               # List available sessions
```

## Session State Management

### Environment Variables

**Session-Specific Environment:**
```bash
# Set environment variables per session
tmux set-environment -t claude-dev-myproject CLAUDE_PROJECT myproject
tmux set-environment -t claude-dev-myproject NODE_ENV development
tmux set-environment -t claude-dev-myproject DEBUG_MODE 1

# Access in session
echo $CLAUDE_PROJECT  # myproject
```

**Automatic Environment Setup:**
```bash
# ~/bin/setup-claude-env
#!/bin/bash
SESSION_NAME="$1"
PROJECT_PATH="$2"

# Set common environment variables
tmux set-environment -t "$SESSION_NAME" CLAUDE_CODE_TMUX_SESSION 1
tmux set-environment -t "$SESSION_NAME" PROJECT_ROOT "$PROJECT_PATH"
tmux set-environment -t "$SESSION_NAME" EDITOR nvim

# Load project-specific environment
if [[ -f "$PROJECT_PATH/.env.claude" ]]; then
    while IFS= read -r line; do
        if [[ "$line" && "${line:0:1}" != "#" ]]; then
            tmux set-environment -t "$SESSION_NAME" $line
        fi
    done < "$PROJECT_PATH/.env.claude"
fi
```

### Working Directory Management

**Consistent Directory Structure:**
```bash
# Pane-specific working directories
tmux send-keys -t "$SESSION:0" "cd .worktrees/feature-1" Enter
tmux send-keys -t "$SESSION:1" "cd .worktrees/feature-2" Enter  
tmux send-keys -t "$SESSION:2" "cd ." Enter                    # Main repo
tmux send-keys -t "$SESSION:3" "cd ." Enter                    # Git ops
```

**Directory Synchronization:**
```bash
# Keep certain panes synchronized to main directory
tmux bind S set-window-option synchronize-panes \; display "Sync #{?synchronize-panes,ON,OFF}"

# Selective sync for git operations
tmux bind g send-keys -t 3 "git status" Enter
```

## Session Automation

### Automated Session Creation

**Intelligent Session Setup:**
```bash
# ~/bin/smart-claude-session
#!/bin/bash
PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"

# Detect project type and create appropriate session
if [[ -f "package.json" ]]; then
    claude-template-node "$PROJECT_NAME"
elif [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then
    claude-template-python "$PROJECT_NAME"
elif [[ -f "go.mod" ]]; then
    claude-template-go "$PROJECT_NAME"
elif [[ -f "Cargo.toml" ]]; then
    claude-template-rust "$PROJECT_NAME"
else
    # Generic template
    cw "$PROJECT_NAME"
fi
```

### Session Health Monitoring

**Session Status Checking:**
```bash
# ~/bin/claude-session-health
#!/bin/bash
# Monitor Claude Code session health

echo "Claude Code Session Health Report"
echo "================================="

for session in $(tmux list-sessions -F "#{session_name}" | grep "claude-dev-"); do
    echo "Session: $session"
    
    # Check if session has the expected 4 panes
    pane_count=$(tmux list-panes -t "$session" | wc -l)
    if [[ $pane_count -eq 4 ]]; then
        echo "  ✅ Pane count: $pane_count (expected: 4)"
    else
        echo "  ⚠️  Pane count: $pane_count (expected: 4)"
    fi
    
    # Check if worktrees exist
    session_path=$(tmux display-message -t "$session" -p "#{pane_current_path}")
    if [[ -d "$session_path/.worktrees" ]]; then
        worktree_count=$(ls -1 "$session_path/.worktrees" | wc -l)
        echo "  ✅ Worktrees: $worktree_count found"
    else
        echo "  ⚠️  Worktrees: not found"
    fi
    
    echo ""
done
```

## Session Cleanup

### Automated Cleanup

**Old Session Removal:**
```bash
# ~/bin/claude-cleanup-sessions
#!/bin/bash
# Clean up old Claude Code sessions

RETENTION_HOURS=${1:-24}  # Keep sessions for 24 hours by default

echo "Cleaning up Claude Code sessions older than $RETENTION_HOURS hours..."

tmux list-sessions -F "#{session_name} #{session_created}" | \
grep "claude-dev-" | \
while read session created; do
    # Calculate age in hours
    current_time=$(date +%s)
    age_hours=$(( (current_time - created) / 3600 ))
    
    if (( age_hours > RETENTION_HOURS )); then
        echo "Removing old session: $session (${age_hours}h old)"
        tmux kill-session -t "$session"
    else
        echo "Keeping session: $session (${age_hours}h old)"
    fi
done
```

### Manual Cleanup Commands

**Session Management Commands:**
```bash
# List all Claude Code sessions with age
claude-list-sessions() {
    tmux list-sessions -F "#{session_name} #{session_created_string}" | \
    grep "claude-dev-" | \
    sort
}

# Kill specific Claude Code session with cleanup
claude-kill-session() {
    local session="claude-dev-$1"
    if tmux has-session -t "$session" 2>/dev/null; then
        # Optional: backup session before killing
        tmux capture-pane -t "$session" -p > "/tmp/${session}-backup.txt"
        tmux kill-session -t "$session"
        echo "Session $session terminated and backed up"
    else
        echo "Session $session not found"
    fi
}

# Kill all Claude Code sessions
claude-kill-all() {
    read -p "Kill all Claude Code sessions? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        tmux list-sessions -F "#{session_name}" | \
        grep "claude-dev-" | \
        xargs -I {} tmux kill-session -t {}
        echo "All Claude Code sessions terminated"
    fi
}
```

## Session Synchronization

### Multi-Machine Session Sync

**Session Export/Import:**
```bash
# Export session configuration
claude-export-session() {
    local session="$1"
    local export_file="claude-session-${session}.tar.gz"
    
    # Create export directory
    mkdir -p "/tmp/claude-export-$session"
    
    # Export session layout
    tmux list-windows -t "$session" -F "#{window_layout}" > "/tmp/claude-export-$session/layout"
    
    # Export environment variables
    tmux show-environment -t "$session" > "/tmp/claude-export-$session/environment"
    
    # Export pane commands (if running)
    tmux list-panes -t "$session" -F "#{pane_current_command}" > "/tmp/claude-export-$session/commands"
    
    # Create archive
    tar -czf "$export_file" -C "/tmp" "claude-export-$session"
    rm -rf "/tmp/claude-export-$session"
    
    echo "Session exported to: $export_file"
}

# Import session configuration
claude-import-session() {
    local import_file="$1"
    local session_name="$2"
    
    # Extract archive
    tar -xzf "$import_file" -C "/tmp"
    local import_dir="/tmp/claude-export-${session_name}"
    
    # Create session
    tmux new-session -d -s "$session_name"
    
    # Restore environment
    while IFS= read -r env_line; do
        tmux set-environment -t "$session_name" $env_line
    done < "$import_dir/environment"
    
    # TODO: Restore layout and commands
    
    echo "Session imported: $session_name"
}
```

### Remote Session Access

**SSH Session Forwarding:**
```bash
# Access remote Claude Code sessions
ssh-claude() {
    local remote_host="$1"
    local session_name="$2"
    
    # Connect to remote tmux session
    ssh -t "$remote_host" "tmux attach-session -t claude-dev-$session_name || tmux list-sessions"
}

# Share session with others
share-claude-session() {
    local session="$1"
    local socket_path="/tmp/tmux-shared-claude"
    
    # Create shared socket
    tmux -S "$socket_path" new-session -d -s "shared-$session"
    chmod 777 "$socket_path"
    
    echo "Shared session created at: $socket_path"
    echo "Others can connect with: tmux -S $socket_path attach-session -t shared-$session"
}
```

## Integration with Development Tools

### IDE Integration

**VS Code Integration:**
```json
// .vscode/tasks.json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Attach to Claude Session",
            "type": "shell",
            "command": "tmux",
            "args": ["attach-session", "-t", "claude-dev-${workspaceFolderBasename}"],
            "group": "build",
            "presentation": {
                "echo": false,
                "reveal": "always",
                "focus": true,
                "panel": "new"
            }
        }
    ]
}
```

### Git Hook Integration

**Pre-commit Session Check:**
```bash
# .git/hooks/pre-commit
#!/bin/bash
# Ensure Claude Code sessions are properly committed

for session in $(tmux list-sessions -F "#{session_name}" | grep "claude-dev-"); do
    session_path=$(tmux display-message -t "$session" -p "#{pane_current_path}")
    
    # Check for uncommitted changes in worktrees
    for worktree in "$session_path/.worktrees/"*/; do
        if [[ -d "$worktree" ]]; then
            cd "$worktree"
            if ! git diff-index --quiet HEAD --; then
                echo "Warning: Uncommitted changes in $worktree"
                echo "Session: $session"
            fi
            cd - > /dev/null
        fi
    done
done
```

## Best Practices

### Session Organization

1. **Consistent Naming**: Use the `claude-dev-` prefix for all development sessions
2. **Project Separation**: One session per major project or feature set
3. **Template Usage**: Use project-specific templates for consistency
4. **Regular Cleanup**: Remove old sessions to avoid clutter

### Performance Optimization

1. **Session Limits**: Keep number of concurrent sessions reasonable (< 10)
2. **Pane Management**: Close unused panes to free resources
3. **History Limits**: Set appropriate scrollback limits for each pane
4. **Process Monitoring**: Monitor resource usage of long-running sessions

### Backup and Recovery

1. **Automatic Backups**: Use tmux-resurrect for automatic session persistence
2. **Manual Snapshots**: Periodically save session state for critical work
3. **Configuration Versioning**: Keep session templates in version control
4. **Recovery Testing**: Regularly test session restore procedures

Session management is crucial for maintaining productive Claude Code development workflows. Proper session organization, automation, and maintenance ensure consistent and reliable development environments across projects and time.

## Next Steps

- **[Best Practices](/claude-code/best-practices)** - Proven workflow patterns
- **[Automation Scripts](/claude-code/automation)** - Advanced automation techniques
- **[Vim Integration](/claude-code/vim)** - Deep vim/tmux integration