# Git Worktrees for Parallel Development

Git worktrees enable parallel Claude Code sessions without conflicts by creating separate working directories for different branches.

## What Are Git Worktrees?

Git worktrees allow you to have multiple working directories attached to the same repository, each checked out to different branches. Perfect for Claude Code development where you want to work on multiple features simultaneously.

## Why Use Worktrees with Claude Code?

### Traditional Problem
```bash
# Traditional workflow - conflicts arise
git checkout feature-auth
# Work with Claude Code on auth feature
git checkout feature-api  
# Work with Claude Code on API feature
# ❌ Git state conflicts, uncommitted changes, context switching
```

### Worktree Solution
```bash
# Worktree workflow - no conflicts
# Claude session 1: .worktrees/feature-auth (auth branch)
# Claude session 2: .worktrees/feature-api (api branch)  
# ✅ Parallel development, no git conflicts, independent sessions
```

## Automatic Worktree Setup

### Via Claude Code Workspace

```bash
# Automatically creates worktrees
cw myproject feature-auth feature-api

# Creates structure:
# .worktrees/
# ├── feature-auth/     ← Claude session 1
# └── feature-api/      ← Claude session 2
```

### Manual Worktree Creation

```bash
# Create main worktree directory
mkdir -p .worktrees

# Create feature branches if they don't exist
git branch feature-auth
git branch feature-api

# Create worktrees
git worktree add .worktrees/feature-auth feature-auth
git worktree add .worktrees/feature-api feature-api

# Verify creation
git worktree list
```

## Worktree Structure

### Directory Layout
```
myproject/                    ← Main repository
├── .git/                    ← Git metadata
├── .worktrees/              ← Worktree container
│   ├── feature-auth/        ← Auth feature worktree
│   │   ├── src/
│   │   ├── package.json
│   │   └── ... (full project files)
│   └── feature-api/         ← API feature worktree  
│       ├── src/
│       ├── package.json
│       └── ... (full project files)
├── src/                     ← Main branch files
└── package.json
```

### Each Worktree Contains
- Complete copy of all tracked files
- Independent working directory
- Separate HEAD pointing to different branch
- Shared git history and configuration

## Claude Code Integration

### Multi-Session Development

**Tmux Layout with Worktrees:**
```
┌─────────────────────┬─────────────────────┐  
│ feature-auth/       │ feature-api/        │  
│ claude-code .       │ claude-code .       │  
│ (auth branch)       │ (api branch)        │
├─────────────────────┼─────────────────────┤
│ main repo/          │ git operations      │
│ nvim src/           │ git status          │
└─────────────────────┴─────────────────────┘
```

**Development Workflow:**
1. **Pane 1**: Claude Code working on authentication in `feature-auth` worktree
2. **Pane 2**: Claude Code working on API changes in `feature-api` worktree  
3. **Pane 3**: Neovim editing main repository files
4. **Pane 4**: Git operations to manage and merge changes

### Independent Development

**Each Claude session can:**
- Make commits independently
- Run tests without conflicts
- Install different dependencies
- Have different environment configurations
- Work at different paces without blocking

## Worktree Commands

### Basic Operations

```bash
# List all worktrees
git worktree list

# Add new worktree
git worktree add PATH BRANCH

# Remove worktree
git worktree remove PATH

# Clean up stale worktrees
git worktree prune
```

### Practical Examples

```bash
# Create worktree for hotfix
git worktree add .worktrees/hotfix-login main
cd .worktrees/hotfix-login
git checkout -b hotfix-login

# Create worktree for experiment  
git worktree add .worktrees/experiment main
cd .worktrees/experiment
git checkout -b experiment-new-ui

# Remove completed worktree
git worktree remove .worktrees/completed-feature
git branch -d completed-feature  # Clean up branch too
```

## Advanced Worktree Workflows

### Feature Development Cycle

```bash
# 1. Start new feature
git worktree add .worktrees/feature-payments main
cd .worktrees/feature-payments
git checkout -b feature-payments

# 2. Claude Code development
claude-code .

# 3. Regular commits during development  
git add .
git commit -m "Add payment validation"

# 4. Push feature branch
git push -u origin feature-payments

# 5. When feature is complete, merge from main repo
cd ../..  # Back to main repo
git checkout main
git merge feature-payments

# 6. Clean up
git worktree remove .worktrees/feature-payments
git branch -d feature-payments
git push --delete origin feature-payments
```

### Parallel Bug Fixing

```bash
# Production bug - create hotfix worktree
git worktree add .worktrees/hotfix-security main
cd .worktrees/hotfix-security
git checkout -b hotfix-security

# Development continues in other worktrees
# Main development in .worktrees/feature-auth
# API work in .worktrees/feature-api
# Security fix in .worktrees/hotfix-security

# Each can proceed independently
```

### Code Review Workflow

```bash
# Create worktree for reviewing PR
git fetch origin pull/123/head:pr-123
git worktree add .worktrees/review-pr-123 pr-123

# Review in separate Claude session
cd .worktrees/review-pr-123
claude-code .

# Continue development in main worktrees
# Review doesn't interfere with ongoing work
```

## Integration with Claude Code Workspace

### Workspace Script Features

The `tmux-claude-workspace` script automatically:

1. **Creates worktree directory** if it doesn't exist
2. **Creates branches** if they don't exist  
3. **Sets up worktrees** for each feature
4. **Configures tmux panes** to start in correct directories
5. **Provides cleanup options** when workspace ends

### Workspace Configuration

```bash
# Workspace with custom worktree setup
tmux-claude-workspace myproject \
  feature-user-auth \
  feature-payment-api

# Creates:
# Pane 1: .worktrees/feature-user-auth/
# Pane 2: .worktrees/feature-payment-api/
# Pane 3: main repository (for editing shared files)
# Pane 4: main repository (for git operations)
```

### Automatic Cleanup

```bash
# When workspace ends, optionally clean up
# Script prompts: "Remove worktrees when done? (y/N)"

# If yes:
git worktree remove .worktrees/feature-user-auth
git worktree remove .worktrees/feature-payment-api
rmdir .worktrees  # If empty
```

## Best Practices

### Worktree Management

1. **Consistent naming**: Use descriptive branch/worktree names
2. **Regular cleanup**: Remove completed worktrees promptly
3. **Shared .gitignore**: All worktrees use same ignore rules
4. **Backup strategy**: Main repo backups cover all worktrees

### Development Workflow

1. **Feature branches**: One worktree per feature branch
2. **Main repo editing**: Use main repo for shared file editing
3. **Git operations**: Run git commands from main repo when possible
4. **Dependency management**: Be aware of different package.json changes

### Claude Code Integration

1. **Session per worktree**: One Claude session per worktree
2. **Context separation**: Keep feature work isolated
3. **Regular commits**: Commit frequently in each worktree
4. **Status monitoring**: Check all worktrees in git operations pane

## Common Patterns

### Multi-Feature Development

```bash
# Start workspace for multiple features
cw myapp user-management payment-processing admin-dashboard

# Results in:
# .worktrees/user-management/     ← Claude session 1
# .worktrees/payment-processing/  ← Claude session 2  
# .worktrees/admin-dashboard/     ← Could add third pane
```

### Bug Fix + Feature Work

```bash
# Continue feature work while fixing bug
git worktree add .worktrees/hotfix-login main
cd .worktrees/hotfix-login
git checkout -b hotfix-login

# Feature work continues in existing worktree
# Bug fix proceeds in parallel
```

### Experimental Changes

```bash
# Try risky changes without affecting main work
git worktree add .worktrees/experiment main  
cd .worktrees/experiment
git checkout -b experiment-refactor

# Experiment safely, delete worktree if unsuccessful
```

## Troubleshooting

### Common Issues

**Worktree already exists:**
```bash
$ git worktree add .worktrees/feature-auth feature-auth
fatal: 'feature-auth' is already checked out at '.worktrees/feature-auth'

# Solution: Remove existing worktree first
git worktree remove .worktrees/feature-auth
```

**Branch doesn't exist:**
```bash
$ git worktree add .worktrees/new-feature new-feature
fatal: invalid reference: new-feature

# Solution: Create branch first
git branch new-feature
git worktree add .worktrees/new-feature new-feature
```

**Stale worktrees:**
```bash
# List shows worktrees that no longer exist
$ git worktree list
/path/to/repo/.worktrees/old-feature  abcd123 [old-feature]

# Solution: Prune stale entries
git worktree prune
```

### Performance Considerations

**Large repositories:**
- Worktrees share git objects (efficient storage)
- Each worktree needs full file checkout (disk space)
- Consider using sparse-checkout for large repos

**Many worktrees:**
- Monitor disk usage with `du -sh .worktrees/*`
- Regular cleanup of completed features
- Consider using symbolic links for shared assets

## Integration with Other Tools

### IDE Support
- VS Code: Each worktree opens as separate workspace
- Neovim: LSP servers work independently in each worktree
- File watchers: Configure to watch worktree directories

### CI/CD Considerations
- Ensure CI ignores `.worktrees/` directory
- Add to `.gitignore`: `.worktrees/`
- Test scripts should work from any directory

### Backup Strategy
```bash
# .gitignore entry
.worktrees/

# Backup includes worktrees
./scripts/backup.sh  # Backs up main repo structure
# Individual worktrees backed up with main system
```

Git worktrees provide the perfect foundation for parallel Claude Code development, enabling you to work on multiple features simultaneously without the typical git conflicts and context switching overhead.

## Next Steps

- **[Automation Scripts](/claude-code/automation)** - Automate worktree and workspace management
- **[Vim Integration](/claude-code/vim)** - Optimize vim for multi-worktree development
- **[Best Practices](/claude-code/best-practices)** - Advanced patterns and workflows