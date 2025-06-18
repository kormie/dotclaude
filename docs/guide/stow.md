# GNU Stow Basics

Understanding symlink management with GNU Stow for modular dotfile organization.

## Overview

GNU Stow is the foundation of DotClaude's modular architecture, enabling safe, reversible configuration management through symbolic links.

## How Stow Works

### Symlink Management
Stow creates symbolic links from a source directory to a target directory:

```bash
# Basic stow operation
cd ~/dotfiles
stow -t ~ stow/zsh

# This creates symlinks:
# ~/.zshrc -> ~/dotfiles/stow/zsh/.zshrc
```

### Package Structure
Each configuration is organized as a "package":

```
stow/
├── git/
│   └── .gitconfig
├── zsh/
│   └── .zshrc
├── neovim/
│   └── .config/
│       └── nvim/
└── tmux/
    └── .tmux.conf
```

## DotClaude Package Organization

### Core Packages
- **git** - Git configuration with modern diff tools
- **zsh** - Shell enhancement with Oh-My-Zsh
- **neovim** - Modern editor configuration
- **tmux** - Terminal multiplexing setup

### Support Packages
- **aliases** - Centralized alias management
- **environment** - PATH and environment variables
- **rust-tools** - Modern CLI tool configurations

## Safety Scripts

DotClaude provides wrapper scripts for safe stow operations:

### Package Management
```bash
# Apply a package safely
./scripts/stow-package.sh zsh

# Remove a package
./scripts/unstow-package.sh zsh

# Check package status
./scripts/check-package.sh zsh
```

### Backup & Restore
```bash
# Backup before applying
./scripts/backup.sh zsh

# Restore if needed
./scripts/restore.sh zsh
```

## Stow Commands

### Basic Operations
```bash
# Apply package
stow -t ~ package-name

# Remove package
stow -D -t ~ package-name

# Simulate (dry run)
stow -n -t ~ package-name

# Verbose output
stow -v -t ~ package-name
```

### Advanced Usage
```bash
# Force operation (overwrite conflicts)
stow --adopt -t ~ package-name

# Specify stow directory
stow -d ~/dotfiles/stow -t ~ package-name

# Target specific directory
stow -t ~/.config config-package
```

## Conflict Resolution

### Handling Conflicts
When stow encounters existing files:

1. **Backup** - Always backup existing files first
2. **Adopt** - Use `--adopt` to take ownership of existing files
3. **Review** - Check differences before applying
4. **Merge** - Manually merge conflicting configurations

### Example Conflict Resolution
```bash
# Backup existing file
cp ~/.zshrc ~/.zshrc.backup

# Apply package with adoption
stow --adopt -t ~ zsh

# Review and merge differences
diff ~/.zshrc.backup ~/.zshrc
```

## Best Practices

### Package Design
1. **Modularity** - Keep packages focused and independent
2. **Structure** - Mirror target directory structure
3. **Documentation** - Include README for complex packages
4. **Testing** - Test packages individually

### Safety Measures
1. **Always Backup** - Backup before applying changes
2. **Dry Run** - Use `-n` flag to preview changes
3. **Incremental** - Apply packages one at a time
4. **Verification** - Test functionality after applying

### Maintenance
1. **Regular Updates** - Keep packages up to date
2. **Cleanup** - Remove unused packages
3. **Documentation** - Update package documentation
4. **Version Control** - Track all changes in git

## Troubleshooting

### Common Issues
- **Permission Errors** - Check file permissions
- **Broken Links** - Verify source file existence
- **Path Conflicts** - Resolve directory structure issues
- **Stow Conflicts** - Handle overlapping packages

### Debugging Commands
```bash
# Check stow status
stow -n -v -t ~ package-name

# List stow links
find ~ -type l -ls | grep dotfiles

# Verify link targets
ls -la ~/.zshrc
```

## Integration with DotClaude

### Automated Scripts
DotClaude provides automation for common stow operations:
- Package installation and removal
- Backup and restore procedures
- Conflict detection and resolution
- Health checks and validation

### Safety First Approach
All stow operations in DotClaude are:
- **Non-destructive** - Always backup first
- **Reversible** - Easy rollback procedures
- **Tested** - Validated before system-wide deployment
- **Documented** - Clear procedures and troubleshooting