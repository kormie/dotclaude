# Troubleshooting Guide

Common issues and solutions for DotClaude setup and usage.

## Installation Issues

### Command Not Found After Installation

**Symptoms:**
```bash
$ ll2
command not found: ll2

$ cat2 README.md
command not found: cat2
```

**Solutions:**

1. **Reload your shell:**
```bash
# Option 1: Reload current shell
exec $SHELL

# Option 2: Source configurations
source ~/.zshrc
source ~/.aliases
```

2. **Check PATH configuration:**
```bash
# Verify modern tools are in PATH
echo $PATH | tr ':' '\n' | grep -E "(local|cargo|homebrew)"

# Should see entries like:
# /Users/username/.local/bin
# /Users/username/.cargo/bin
# /opt/homebrew/bin
```

3. **Re-apply configurations:**
```bash
# Apply aliases package
./scripts/stow-package.sh aliases

# Apply environment package
./scripts/stow-package.sh environment

# Reload shell
exec $SHELL
```

### Homebrew Installation Failures

**Symptoms:**
```bash
$ ./scripts/setup-tools.sh
Error: No available formula with name "exa"
```

**Solutions:**

1. **Update Homebrew:**
```bash
brew update
brew upgrade
```

2. **Check alternative formulas:**
```bash
# exa was replaced by eza
brew install eza

# Check what's available
brew search bat
brew search fd
```

3. **Manual installation:**
```bash
# Install core tools manually
brew install eza bat fd ripgrep git-delta difftastic zoxide dust procs bottom
```

## Stow Package Issues

### Stow Conflicts

**Symptoms:**
```bash
$ ./scripts/stow-package.sh git
WARNING! stowing git would cause conflicts:
  * cannot stow .gitconfig over existing target
```

**Solutions:**

1. **Check what conflicts exist:**
```bash
./scripts/stow-package.sh git status
```

2. **Backup and remove conflicting files:**
```bash
# Backup first
./scripts/backup.sh git

# Remove existing config (it's backed up)
rm ~/.gitconfig

# Apply package
./scripts/stow-package.sh git
```

3. **Use the adopt flag (advanced):**
```bash
# This moves existing files into the stow package
stow --adopt -v -d ~/.dotfiles/stow -t ~ git
```

### GNU Stow Not Available

**Symptoms:**
```bash
$ ./scripts/test-config.sh stow
[ERROR] GNU Stow is not installed
```

**Solutions:**

1. **Install GNU Stow:**
```bash
# macOS with Homebrew
brew install stow

# Verify installation
which stow
stow --version
```

2. **Update PATH if needed:**
```bash
# Add Homebrew to PATH
export PATH="/opt/homebrew/bin:$PATH"

# Or for Intel Macs
export PATH="/usr/local/bin:$PATH"
```

## Git Configuration Issues

### Git Log Format Problems

**Symptoms:**
```bash
$ git lg
fatal: bad config line 104 in file .gitconfig
```

**Solutions:**

1. **Test git config syntax:**
```bash
git config --list | head -10
```

2. **Restore from backup:**
```bash
./scripts/restore.sh latest git
```

3. **Check specific config sections:**
```bash
# Test alias section
git config --get-regexp "alias.*"

# Test user section  
git config --get-regexp "user.*"
```

### Delta/Difftastic Not Working

**Symptoms:**
```bash
$ git diff
fatal: cannot run delta: No such file or directory
```

**Solutions:**

1. **Install missing tools:**
```bash
brew install git-delta difftastic
```

2. **Check git config:**
```bash
git config --get core.pager
git config --get interactive.diffFilter
```

3. **Temporary disable:**
```bash
# Use without delta temporarily
git -c core.pager=less diff
```

### GPG Signing Issues

**Symptoms:**
```bash
$ git commit -m "test"
error: gpg failed to sign the data
```

**Solutions:**

1. **Check GPG configuration:**
```bash
git config --get user.signingkey
git config --get commit.gpgsign
git config --get gpg.format
```

2. **Test SSH key signing:**
```bash
# Test SSH key signing
ssh-add -L
```

3. **Temporary disable signing:**
```bash
git -c commit.gpgsign=false commit -m "test message"
```

## Tmux Issues

### Keybinding Problems

**Symptoms:**
- Tmux keybindings not working as expected
- `C-a` prefix not responding
- Vim-style navigation not working

**Solutions:**

1. **Reload tmux configuration:**
```bash
# From within tmux
C-a r    # Reload config (if working)

# Or manually
tmux source-file ~/.tmux.conf
```

2. **Check tmux version:**
```bash
tmux -V
# Needs tmux 3.0+ for some features
```

3. **Test configuration syntax:**
```bash
tmux -f ~/.tmux.conf -C "list-keys" | head -5
```

4. **Kill and restart tmux:**
```bash
tmux kill-server
tmux
```

### Claude Code Workspace Issues

**Symptoms:**
```bash
$ cw myproject
command not found: cw
```

**Solutions:**

1. **Check script availability:**
```bash
which tmux-claude-workspace
ls -la scripts/tmux-claude-workspace
```

2. **Make script executable:**
```bash
chmod +x scripts/tmux-claude-workspace
```

3. **Add to PATH:**
```bash
# Check if ~/.local/bin is in PATH
echo $PATH | grep "\.local/bin"

# Add if missing
export PATH="$HOME/.local/bin:$PATH"
```

4. **Use full path:**
```bash
./scripts/tmux-claude-workspace myproject feature1 feature2
```

### Git Worktree Conflicts

**Symptoms:**
```bash
fatal: 'feature-auth' is already checked out at '.worktrees/feature-auth'
```

**Solutions:**

1. **List existing worktrees:**
```bash
git worktree list
```

2. **Remove conflicting worktree:**
```bash
git worktree remove .worktrees/feature-auth
```

3. **Prune stale worktrees:**
```bash
git worktree prune
```

## Shell Configuration Issues

### Zsh vs Bash Compatibility

**Symptoms:**
- Aliases not working in different shells
- Path issues between shells

**Solutions:**

1. **Check current shell:**
```bash
echo $SHELL
ps -p $$
```

2. **Ensure proper configuration loading:**
```bash
# For zsh users
source ~/.zshrc

# For bash users  
source ~/.bashrc
```

3. **Check configuration file existence:**
```bash
ls -la ~/.zshrc ~/.bashrc ~/.bash_profile
```

### Environment Variable Issues

**Symptoms:**
```bash
$ echo $EDITOR
# Empty or wrong value
```

**Solutions:**

1. **Check environment package:**
```bash
./scripts/test-config.sh environment
```

2. **Source environment manually:**
```bash
source ~/.zshenv
```

3. **Verify PATH additions:**
```bash
echo $PATH | tr ':' '\n' | grep -v "^/usr\|^/bin"
```

## Performance Issues

### Slow Command Response

**Symptoms:**
- Modern commands (ll2, cat2, etc.) are slower than expected
- Shell startup is slow

**Solutions:**

1. **Check for alias loops:**
```bash
alias | grep -E "(ll2|cat2|find2)"
```

2. **Test tools directly:**
```bash
# Test without aliases
/opt/homebrew/bin/eza -la
/opt/homebrew/bin/bat README.md
```

3. **Profile shell startup:**
```bash
# For zsh
time zsh -i -c exit

# Check what's loading
zsh -x -i -c exit 2>&1 | head -20
```

### Large Repository Performance

**Symptoms:**
- find2/fd is slow on large codebases
- git operations taking too long

**Solutions:**

1. **Use tool-specific configurations:**
```bash
# fd: exclude directories
find2 --exclude node_modules --exclude .git

# ripgrep: use .rgignore files
echo "node_modules/" >> .rgignore
```

2. **Check .gitignore coverage:**
```bash
# Tools respect .gitignore by default
cat .gitignore | grep -E "(node_modules|target|build)"
```

## Recovery Procedures

### Complete System Recovery

**When everything is broken:**

1. **Emergency shell with original configs:**
```bash
# Start new terminal
# Don't source any custom configs
bash --noprofile --norc
```

2. **Restore everything:**
```bash
cd ~/.dotfiles
./scripts/restore.sh latest all
```

3. **Remove all stow packages:**
```bash
for pkg in git tmux aliases environment; do
    ./scripts/stow-package.sh $pkg remove 2>/dev/null || true
done
```

4. **Start fresh:**
```bash
exec $SHELL
# Should be back to original state
```

### Selective Recovery

**When specific component is broken:**

1. **Identify the problem:**
```bash
./scripts/test-config.sh all
```

2. **Restore specific component:**
```bash
./scripts/restore.sh latest COMPONENT
```

3. **Re-test and re-apply if needed:**
```bash
./scripts/test-config.sh COMPONENT
./scripts/stow-package.sh COMPONENT
```

## Getting Help

### Debug Information Collection

**Before asking for help, collect:**

1. **System information:**
```bash
uname -a
echo $SHELL
which stow git tmux
```

2. **Configuration status:**
```bash
./scripts/test-config.sh all
ls -la stow/*/
```

3. **Recent backups:**
```bash
ls -la backups/
```

### Log Files and Error Messages

**Important locations:**
- Backup manifests: `backups/*/MANIFEST`
- Stow operations: Use `-v` flag for verbose output
- Shell startup issues: Use `zsh -x` for debugging

### Common Solutions Summary

| Issue | Quick Fix |
|-------|-----------|
| Command not found | `exec $SHELL` |
| Stow conflicts | `./scripts/backup.sh && rm conflicting-file` |
| Git config errors | `./scripts/restore.sh latest git` |
| Tmux not working | `tmux kill-server && tmux` |
| Slow performance | Check for alias loops, exclude large dirs |
| Complete failure | `./scripts/restore.sh latest all` |

Most issues can be resolved by reloading configurations or restoring from the automatic backups. The safety system is designed to make recovery straightforward and reliable.

## Prevention

**Best practices to avoid issues:**
- Always test configurations before applying
- Keep regular backups (automatic system handles this)
- Apply changes incrementally, one package at a time
- Keep existing terminal sessions open when testing
- Read error messages carefully - they usually indicate the exact problem

For additional help, check the [command reference](/reference/) or review the [safety guide](/getting-started/safety).