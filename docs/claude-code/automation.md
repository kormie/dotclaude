# Automation Scripts for Claude Code Workflows

Streamline your Claude Code development with powerful automation scripts and workflow optimizations.

## Core Automation Scripts

### tmux-claude-workspace

The main automation script that creates optimized development environments.

**Basic Usage:**
```bash
# Quick workspace
cw myproject

# Feature-specific workspace  
cw myproject feature-auth feature-api

# Custom session name
tmux-claude-workspace my-app user-system payment-flow
```

**What It Automates:**
1. **Git worktree creation** for parallel development
2. **Tmux session setup** with 4-pane layout
3. **Directory navigation** to correct worktrees
4. **Pane configuration** with appropriate commands
5. **Session naming** with consistent patterns

### Workspace Components

**Pane 1 (Top Left)**: First Claude Code session
```bash
# Automatically navigates to first worktree
cd .worktrees/feature-auth
echo 'Claude Code Session 1: feature-auth'
echo 'Ready to start claude-code .'
```

**Pane 2 (Top Right)**: Second Claude Code session  
```bash
# Automatically navigates to second worktree
cd .worktrees/feature-api
echo 'Claude Code Session 2: feature-api'  
echo 'Ready to start claude-code .'
```

**Pane 3 (Bottom Left)**: Neovim session
```bash
# Main repository for shared file editing
cd /path/to/main/repo
echo 'Neovim ready. Type nvim to start editing.'
```

**Pane 4 (Bottom Right)**: Git operations
```bash
# Git command center
cd /path/to/main/repo
git status
```

## Advanced Automation Features

### Intelligent Branch Creation

The script automatically handles missing branches:

```bash
# If branch doesn't exist, creates it
if ! git rev-parse --verify "$feature" >/dev/null 2>&1; then
    log_info "Creating branch: $feature"
    git branch "$feature"
fi

# Then creates worktree
git worktree add "$worktree_path" "$feature"
```

### Error Recovery

**Conflict Resolution:**
```bash
# Handles existing worktrees gracefully
if [[ -d "$worktree_path" ]]; then
    log_warn "Worktree already exists: $worktree_path"
    # Continues with existing worktree
else
    # Creates new worktree
    git worktree add "$worktree_path" "$feature"
fi
```

**Dependency Checking:**
```bash
# Validates requirements before starting
check_git_repo     # Ensures we're in a git repository
check_tmux         # Verifies tmux is available  
check_claude_code  # Checks for claude-code CLI (optional)
```

### Custom Layouts

**Pane Size Optimization:**
```bash
# Top panes get 60% height for code work
tmux resize-pane -t "$SESSION_NAME:1.1" -y 60%
tmux resize-pane -t "$SESSION_NAME:1.2" -y 60%

# Equal width split for parallel sessions
tmux resize-pane -t "$SESSION_NAME:1.1" -x 50%
```

**Dynamic Pane Titles:**
```bash
# Descriptive pane titles for easy identification
tmux select-pane -t "$SESSION_NAME:1.1" -T "Claude: $FEATURE1"
tmux select-pane -t "$SESSION_NAME:1.2" -T "Claude: $FEATURE2"  
tmux select-pane -t "$SESSION_NAME:1.3" -T "Neovim: $(basename "$base_dir")"
tmux select-pane -t "$SESSION_NAME:1.4" -T "Git Operations"
```

## Custom Automation Scripts

### Project-Specific Automation

Create project-specific workspace scripts:

```bash
# ~/bin/myapp-workspace
#!/bin/bash
# Custom workspace for specific project

PROJECT_PATH="$HOME/projects/myapp"
cd "$PROJECT_PATH"

# Pre-setup tasks
npm install  # Ensure dependencies are current
git fetch --all  # Update all branches

# Launch Claude workspace with typical features
cw myapp \
  feature-user-auth \
  feature-payment-integration

# Post-setup in each pane
tmux send-keys -t "claude-dev-myapp:1.1" "npm run dev" Enter
tmux send-keys -t "claude-dev-myapp:1.2" "npm run test:watch" Enter
```

### Development Environment Automation

```bash
# ~/bin/dev-setup
#!/bin/bash
# Complete development environment setup

# Start essential services
brew services start postgresql
brew services start redis

# Launch multiple project workspaces
cw frontend auth-redesign api-optimization
cw backend user-service payment-service  
cw docs feature-guide api-reference

# Open monitoring dashboard
tmux new-session -d -s monitoring 'htop'
```

### Git Workflow Automation

```bash
# ~/bin/feature-complete
#!/bin/bash
# Automate feature completion workflow

FEATURE_NAME="$1"
WORKTREE_PATH=".worktrees/$FEATURE_NAME"

if [[ -d "$WORKTREE_PATH" ]]; then
    cd "$WORKTREE_PATH"
    
    # Run tests
    npm test
    
    # Commit any final changes
    git add .
    git commit -m "feat: complete $FEATURE_NAME implementation"
    
    # Push to remote
    git push -u origin "$FEATURE_NAME"
    
    # Switch to main repo and merge
    cd ../..
    git checkout main
    git pull origin main
    git merge "$FEATURE_NAME"
    git push origin main
    
    # Clean up
    git worktree remove "$WORKTREE_PATH"
    git branch -d "$FEATURE_NAME"
    git push --delete origin "$FEATURE_NAME"
    
    echo "Feature $FEATURE_NAME completed and cleaned up!"
fi
```

## Integration Automation

### VS Code Integration

```bash
# ~/.vscode/tasks.json addition
{
    "label": "Launch Claude Workspace",
    "type": "shell", 
    "command": "cw",
    "args": ["${workspaceFolderBasename}", "feature-1", "feature-2"],
    "group": "build",
    "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "new"
    }
}
```

### Alfred/Raycast Integration

**Alfred Workflow:**
```bash
# Alfred script filter
query="$1"
project_name="${query%% *}"
features="${query#* }"

# Launch workspace
osascript -e "tell application \"Terminal\" to do script \"cd ~/projects/$project_name && cw $project_name $features\""
```

### Keyboard Shortcuts

**macOS Shortcuts:**
```bash
# ~/bin/claude-hotkey
#!/bin/bash
# Triggered by global hotkey

# Get current directory name
PROJECT=$(basename "$(pwd)")

# Quick workspace with common patterns
if [[ "$PROJECT" == *"frontend"* ]]; then
    cw "$PROJECT" ui-components state-management
elif [[ "$PROJECT" == *"backend"* ]]; then
    cw "$PROJECT" api-endpoints database-schema
else
    cw "$PROJECT" feature-1 feature-2
fi
```

## Monitoring and Logging

### Session Monitoring

```bash
# ~/bin/claude-sessions
#!/bin/bash
# Monitor active Claude Code sessions

echo "Active Claude Code Sessions:"
echo "============================"

# List tmux sessions
tmux list-sessions | grep "claude-dev" | while read session; do
    session_name=$(echo "$session" | cut -d: -f1)
    echo "📝 $session_name"
    
    # Show pane details
    tmux list-panes -t "$session_name" -F "  Pane #{pane_index}: #{pane_title} (#{pane_current_path})"
done

echo ""
echo "Git Worktrees:"
echo "============="
git worktree list 2>/dev/null | grep -v "$(pwd)$" | while read worktree; do
    path=$(echo "$worktree" | awk '{print $1}')  
    branch=$(echo "$worktree" | awk '{print $3}' | tr -d '[]')
    echo "🌿 $branch -> $path"
done
```

### Activity Logging

```bash
# Enhanced tmux logging for Claude sessions
set -g @logging-path "$HOME/.tmux/claude-logs"

# Automatic logging for claude-dev sessions
if-shell 'test "#{session_name}" = "claude-dev*"' \
    'pipe-pane -o "cat >> $HOME/.tmux/claude-logs/#{session_name}-#{pane_index}.log"'

# Log rotation script
# ~/bin/rotate-claude-logs
find ~/.tmux/claude-logs -name "*.log" -mtime +7 -delete
```

## Performance Optimizations

### Parallel Operations

```bash
# Parallel worktree creation for large projects
create_worktrees_parallel() {
    local features=("$@")
    
    for feature in "${features[@]}"; do
        (
            git worktree add ".worktrees/$feature" "$feature" 2>/dev/null &
        )
    done
    
    wait  # Wait for all background jobs
    log_info "All worktrees created in parallel"
}
```

### Lazy Loading

```bash
# Only load heavy configurations when needed
setup_development_tools() {
    if [[ "$CLAUDE_CODE_TMUX_SESSION" == "1" ]]; then
        # Load expensive configurations only in Claude sessions
        source ~/.config/development-tools
        export HEAVY_DEV_CONFIG=1
    fi
}
```

### Resource Management  

```bash
# Automatic cleanup of old sessions
cleanup_old_sessions() {
    # Kill sessions older than 24 hours
    tmux list-sessions -F "#{session_name} #{session_created}" | \
    while read name created; do
        age=$(( $(date +%s) - created ))
        if (( age > 86400 )); then  # 24 hours
            tmux kill-session -t "$name"
            log_info "Cleaned up old session: $name"
        fi
    done
}
```

## Workflow Templates

### Feature Development Template

```bash
# ~/bin/new-feature  
#!/bin/bash
FEATURE_NAME="$1"
PROJECT_NAME="$2"

# Validation
if [[ -z "$FEATURE_NAME" || -z "$PROJECT_NAME" ]]; then
    echo "Usage: new-feature FEATURE_NAME PROJECT_NAME"
    exit 1
fi

# Setup
cd ~/projects/"$PROJECT_NAME"
git checkout main
git pull origin main

# Create feature branch
git checkout -b "feature/$FEATURE_NAME"
git push -u origin "feature/$FEATURE_NAME"

# Launch workspace
cw "$PROJECT_NAME" "feature/$FEATURE_NAME" "testing/$FEATURE_NAME"

echo "Feature workspace ready for: $FEATURE_NAME"
```

### Review Template

```bash
# ~/bin/review-pr
#!/bin/bash
PR_NUMBER="$1"
PROJECT_NAME="$2"

# Fetch PR
cd ~/projects/"$PROJECT_NAME"  
git fetch origin "pull/$PR_NUMBER/head:pr-$PR_NUMBER"

# Create review workspace
cw "$PROJECT_NAME-review" "pr-$PR_NUMBER" "main"

echo "Review workspace ready for PR #$PR_NUMBER"
```

## Error Handling and Recovery

### Robust Error Handling

```bash
# Enhanced error handling in automation scripts
set -euo pipefail  # Exit on error, undefined vars, pipe failures

error_handler() {
    local line_number=$1
    local error_code=$2
    log_error "Error on line $line_number: exit code $error_code"
    
    # Cleanup on error
    cleanup_failed_session
    
    exit "$error_code"
}

trap 'error_handler ${LINENO} $?' ERR
```

### Recovery Procedures

```bash
# Automatic recovery from common failures
recover_failed_workspace() {
    local session_name="$1"
    
    # Kill failed session
    tmux kill-session -t "$session_name" 2>/dev/null || true
    
    # Clean up partial worktrees
    find .worktrees -maxdepth 1 -type d -empty -delete 2>/dev/null || true
    
    # Reset any partial git state
    git worktree prune
    
    log_info "Workspace recovery completed"
}
```

## Continuous Integration

### Pre-commit Automation

```bash
# .git/hooks/pre-commit
#!/bin/bash
# Ensure all Claude sessions are committed

for worktree in .worktrees/*/; do
    if [[ -d "$worktree" ]]; then
        cd "$worktree"
        if ! git diff-index --quiet HEAD --; then
            echo "Uncommitted changes in $worktree"
            echo "Commit or stash changes before pushing main"
            exit 1
        fi
        cd - > /dev/null
    fi
done
```

### Automated Testing

```bash
# Run tests across all worktrees
test_all_worktrees() {
    local exit_code=0
    
    for worktree in .worktrees/*/; do
        if [[ -d "$worktree" ]]; then
            echo "Testing $worktree..."
            cd "$worktree"
            
            if ! npm test; then
                echo "Tests failed in $worktree"
                exit_code=1
            fi
            
            cd - > /dev/null
        fi
    done
    
    return $exit_code
}
```

These automation scripts significantly enhance the Claude Code development experience by reducing manual setup time, ensuring consistent environments, and providing robust error handling and recovery mechanisms.

## Next Steps

- **[Session Management](/claude-code/sessions)** - Advanced session management patterns
- **[Best Practices](/claude-code/best-practices)** - Proven workflows and patterns
- **[Vim Integration](/claude-code/vim)** - Deep vim/tmux/Claude integration