# Safety System

DotClaude prioritizes safety with comprehensive backup, testing, and rollback systems.

## Safety Philosophy

**Non-Destructive Development**: All changes are designed to coexist with your existing setup, never replacing anything without explicit confirmation and automatic backups.

## Backup System

### Automatic Backups

Every operation automatically creates timestamped backups:

```bash
# Backup all dotfiles
./scripts/backup.sh

# Backup specific component
./scripts/backup.sh git
./scripts/backup.sh zsh
```

### Backup Structure

```
backups/
├── 20250618_131638/           # Timestamp directory
│   ├── MANIFEST              # List of backed up files
│   ├── .zshrc                # Original zshrc
│   ├── .gitconfig            # Original gitconfig
│   └── .config/nvim/         # Original neovim config
└── 20250618_142305/          # Another backup session
```

### What Gets Backed Up

- **Shell configs**: `.zshrc`, `.bashrc`, `.bash_profile`
- **Git configs**: `.gitconfig`, `.gitignore_global`
- **Editor configs**: `.vimrc`, `.vim/`, `.config/nvim/`
- **Terminal configs**: `.tmux.conf`
- **Custom configs**: `.aliases`, `.exports`

## Testing System

### Pre-Deployment Testing

Never apply configurations without testing:

```bash
# Test all configurations
./scripts/test-config.sh all

# Test specific component
./scripts/test-config.sh git
./scripts/test-config.sh tmux
./scripts/test-config.sh stow
```

### What Gets Tested

- **Syntax validation**: Shell scripts, git configs, tmux configs
- **Stow dry-runs**: See what would be linked without actually linking
- **Dependency checks**: Ensure required tools are available
- **Conflict detection**: Identify potential file conflicts

### Test Output

```bash
$ ./scripts/test-config.sh git
[INFO] Starting configuration tests...
[INFO] Component: git
[TEST] Testing Stow package: git
[TEST] Running Stow dry-run for git...
[INFO] Stow dry-run successful for git
[TEST] Testing Git configuration...
[INFO] Git configuration syntax is valid
[INFO] Configuration test completed successfully
```

## Rollback System

### Interactive Restore

```bash
# Interactive restore with backup selection
./scripts/restore.sh

# Output:
Available backups:
20250618_142305
20250618_131638

Enter backup timestamp to restore (or 'latest' for most recent): latest
Enter component to restore (or 'all' for everything): git
```

### Quick Restore

```bash
# Restore latest backup
./scripts/restore.sh latest

# Restore specific component from latest
./scripts/restore.sh latest git

# Restore specific backup
./scripts/restore.sh 20250618_131638 all
```

### Safety Confirmations

All destructive operations require explicit confirmation:

```bash
WARNING: This will overwrite existing files!
Continue with restore? (y/N): 
```

## Safe Deployment

### Package Management

Apply configurations incrementally:

```bash
# See what would be applied (dry-run)
./scripts/stow-package.sh git status

# Apply configuration
./scripts/stow-package.sh git

# Remove configuration  
./scripts/stow-package.sh git remove
```

### Coexisting Tools

Modern tools are installed with safe aliases:

| Tool | Safe Alias | Original |
|------|------------|----------|
| exa/eza | `ll2` | `ls` |
| bat | `cat2` | `cat` |
| fd | `find2` | `find` |
| ripgrep | `grep2` | `grep` |

Your original commands continue working unchanged.

## Emergency Procedures

### Quick Rollback

If something breaks:

```bash
# 1. Restore from latest backup
./scripts/restore.sh latest

# 2. Remove problematic package
./scripts/stow-package.sh PACKAGE remove

# 3. Reload shell
exec $SHELL
```

### Nuclear Option

Complete reset to original state:

```bash
# Remove all stow packages
for pkg in git tmux aliases environment; do
    ./scripts/stow-package.sh $pkg remove 2>/dev/null || true
done

# Restore from earliest backup
./scripts/restore.sh
```

## Safety Best Practices

### Before Making Changes

1. **Backup**: `./scripts/backup.sh`
2. **Test**: `./scripts/test-config.sh COMPONENT`
3. **Apply**: `./scripts/stow-package.sh COMPONENT`
4. **Verify**: Test functionality in new shell session

### During Development

- Keep existing terminal sessions open
- Test new configurations in separate sessions
- Use `exec $SHELL` to test shell configs safely
- Document any changes or customizations

### Regular Maintenance

```bash
# Weekly backup
./scripts/backup.sh

# Clean old backups (keep recent ones)
find backups/ -name "2024*" -type d | head -n -5 | xargs rm -rf

# Test all configurations
./scripts/test-config.sh all
```

## Recovery Examples

### Git Configuration Issues

```bash
# Problem: git log looks wrong
# Solution: Restore git config
./scripts/restore.sh latest git
```

### Shell Issues

```bash
# Problem: shell won't load
# Solution: Open new terminal, restore shell config
./scripts/restore.sh latest zsh
exec $SHELL
```

### Tmux Issues

```bash
# Problem: tmux keybindings broken  
# Solution: Remove tmux config, restart tmux
./scripts/stow-package.sh tmux remove
tmux kill-server
tmux
```

## Confidence Building

The safety system is designed to give you confidence to experiment:

- ✅ **Nothing is permanent** - everything can be rolled back
- ✅ **Gradual adoption** - use new tools when ready
- ✅ **Coexistence** - old and new tools work together
- ✅ **Testing first** - verify before applying
- ✅ **Automatic backups** - never lose your original setup

With these safety nets in place, you can confidently explore modern development tools while knowing your working environment is protected.

## Next Steps

- **[Quick Setup](./quick-setup)** - Apply your first configurations safely
- **[Modern Tools](./tools)** - Learn about the new CLI tools available
- **[Troubleshooting](/reference/troubleshooting)** - Common issues and solutions