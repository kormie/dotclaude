# Quick Setup

Apply your first configurations safely with the backup and testing system.

## Before You Start

Make sure you've completed the [installation](./index.md) and have DotClaude ready to use.

## Step 1: Create Your First Backup

```bash
# Backup all existing dotfiles
./scripts/backup.sh

# Verify backup was created
ls -la backups/
```

## Step 2: Apply Git Configuration

The safest configuration to start with - enhances your git workflow:

```bash
# Test the git configuration first
./scripts/test-config.sh git

# Apply git configuration
./scripts/stow-package.sh git

# Test your new git log format
git lg
```

**What you get:**
- Your preferred git log format with colors
- Delta diff viewer with syntax highlighting
- Difftastic for syntax-aware diffs (`git dtl`)
- All your existing settings preserved (GPG signing, SSH URLs, etc.)

## Step 3: Apply Environment Variables

Set up modern PATH and XDG compliance:

```bash
# Test environment configuration
./scripts/test-config.sh environment

# Apply environment configuration  
./scripts/stow-package.sh environment

# Reload your shell
exec $SHELL
```

## Step 4: Apply Centralized Aliases

Get access to modern CLI tools with coexisting aliases:

```bash
# Apply alias configuration
./scripts/stow-package.sh aliases

# Reload shell to access new aliases
source ~/.aliases

# Test modern tools
ll2        # Enhanced ls
cat2 --help # Syntax highlighted cat
```

## Step 5: Apply Tmux Configuration (Optional)

If you use tmux and want Claude Code optimization:

```bash
# Test tmux configuration
./scripts/test-config.sh tmux

# Apply tmux configuration
./scripts/stow-package.sh tmux

# Test Claude Code workspace
cw test-project feature-1 feature-2
```

## Verification

Verify everything is working:

```bash
# Check modern tools are available
ll2
cat2 README.md
git lg

# Test Claude Code workspace (if tmux applied)
cw dotfiles test-feature

# Check configuration status
./scripts/test-config.sh all
```

## Troubleshooting

**Commands not found?**
```bash
# Reload your shell
exec $SHELL

# Or source specific configs
source ~/.zshrc
source ~/.aliases
```

**Want to rollback?**
```bash
# Interactive restore
./scripts/restore.sh

# Restore specific component
./scripts/restore.sh latest git
```

**Configuration conflicts?**
```bash
# Check what would be applied
./scripts/stow-package.sh git status

# Remove conflicting package
./scripts/stow-package.sh git remove
```

## Machine-Specific Configuration

DotClaude creates local config files for machine-specific settings that shouldn't be tracked in git.

### Git Identity (`~/.gitconfig.local`)

Set your git identity and signing key:

```bash
# Edit the local git config
cat ~/.gitconfig.local

# Add your identity
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "your@email.com"
git config --file ~/.gitconfig.local user.signingkey "~/.ssh/id_ed25519.pub"
```

### Shell Customizations (`~/.zshrc.local`)

Add machine-specific PATH entries or tools:

```bash
# Example: Add local tool paths
echo 'export PATH="$PATH:$HOME/.local-tool/bin"' >> ~/.zshrc.local
```

### Secrets (`~/.secrets`)

Store API keys and tokens securely:

```bash
# Edit the secrets file (created during setup)
$EDITOR ~/.secrets

# Example contents:
# export OPENAI_API_KEY="sk-..."
# export GITHUB_TOKEN="ghp_..."
```

::: warning Security
The `~/.secrets` file has restricted permissions (600). Never commit secrets to git.
:::

## What's Next?

Once you have the basic configurations working:

1. **[Explore Modern Tools](./tools)** - Learn about all the new CLI tools
2. **[Claude Code Workflows](/claude-code/workspace)** - Set up AI development workflows
3. **[Safety Guide](./safety)** - Understand backup and restore procedures

## Pro Tips

- **Start small**: Apply one configuration at a time
- **Test first**: Always use `./scripts/test-config.sh` before applying
- **Keep backups**: The automatic backup system has saved you
- **Gradual adoption**: Use tools when you're ready, no pressure to change everything

Your dotfiles are now enhanced with modern tools while keeping your existing workflow intact! 🎉