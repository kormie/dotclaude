# Scripts & Tools

Complete reference for all DotClaude automation scripts and management tools.

## Core Management Scripts

### Package Management
Located in `scripts/`

#### `stow-package.sh`
**Purpose**: Safely apply stow packages with backup
**Usage**: `./scripts/stow-package.sh <package-name>`
**Features**:
- Automatic backup before applying
- Conflict detection and resolution
- Verification of successful application
- Rollback capability on failure

```bash
# Examples
./scripts/stow-package.sh git
./scripts/stow-package.sh zsh
./scripts/stow-package.sh neovim
```

#### `unstow-package.sh`
**Purpose**: Remove stow packages safely
**Usage**: `./scripts/unstow-package.sh <package-name>`
**Features**:
- Clean removal of symlinks
- Preservation of user modifications
- Verification of complete removal

#### `backup.sh`
**Purpose**: Create timestamped backups of configurations
**Usage**: `./scripts/backup.sh [component]`
**Features**:
- Individual component backup
- Full system backup
- Timestamped backup directories
- Compression for space efficiency

```bash
# Backup specific components
./scripts/backup.sh git
./scripts/backup.sh shell

# Full system backup
./scripts/backup.sh
```

#### `restore.sh`
**Purpose**: Restore configurations from backups
**Usage**: `./scripts/restore.sh <component> [backup-date]`
**Features**:
- Point-in-time restoration
- Interactive backup selection
- Verification before restoration
- Safe rollback procedures

### Configuration Testing

#### `test-config.sh`
**Purpose**: Test configurations before system-wide application
**Usage**: `./scripts/test-config.sh <component>`
**Features**:
- Isolated testing environment
- Syntax validation
- Functionality testing
- Performance benchmarking

#### `health-check.sh`
**Purpose**: Comprehensive system health validation
**Usage**: `./scripts/health-check.sh`
**Features**:
- Configuration file validation
- Symlink integrity checking
- Tool availability verification
- Performance metrics

## Toggle Scripts

### `toggle-shell.sh`
**Purpose**: Switch between original and enhanced shell configurations
**Usage**: `./scripts/toggle-shell.sh [enhanced|original|status]`

States:
- **enhanced** - Use Oh-My-Zsh with modern tools
- **original** - Revert to system defaults
- **status** - Show current configuration state

### `toggle-neovim.sh`
**Purpose**: Switch between Neovim configurations
**Usage**: `./scripts/toggle-neovim.sh [enhanced|original|status]`

Features:
- Safe configuration switching
- Plugin state management
- User preference preservation
- Performance optimization

### `toggle-git.sh`
**Purpose**: Switch between git configurations
**Usage**: `./scripts/toggle-git.sh [enhanced|original|status]`

Components:
- Delta/difftastic integration
- SSH signing configuration
- Alias and workflow enhancements

## Installation Scripts

### `install-modern-tools.sh`
**Purpose**: Install and configure Rust-based CLI tools
**Usage**: `./scripts/install-modern-tools.sh`

Tools installed:
- exa/eza (enhanced ls)
- bat (syntax-highlighted cat)
- fd (fast find)
- ripgrep (ultra-fast grep)
- zoxide (smart directory navigation)
- delta (enhanced git diffs)
- difftastic (syntax-aware diffs)

Features:
- Platform detection
- Dependency management
- Configuration integration
- Alias setup

### `setup-system.sh`
**Purpose**: Complete system setup and configuration
**Usage**: `./scripts/setup-system.sh`

Phases:
1. Dependency installation
2. Tool setup and configuration
3. Package application
4. Verification and testing

## Automation Scripts

### `tmux-claude-workspace`
**Purpose**: Launch multi-pane Claude Code development workspace
**Usage**: `tmux-claude-workspace [session-name]`

Features:
- 4-pane development layout
- Git worktree integration
- Named session management
- Vim-style navigation setup

Layout:
```
┌─────────────┬─────────────┐
│  Claude 1   │  Claude 2   │
├─────────────┼─────────────┤
│  Claude 3   │  Claude 4   │
└─────────────┴─────────────┘
```

### `create-worktree.sh`
**Purpose**: Automate git worktree creation for parallel development
**Usage**: `./scripts/create-worktree.sh <branch-name> [base-branch]`

Features:
- Automatic worktree directory creation
- Branch creation and checkout
- Integration with tmux workspaces
- Cleanup automation

## Utility Scripts

### `check-package.sh`
**Purpose**: Verify package installation and status
**Usage**: `./scripts/check-package.sh <package-name>`

Checks:
- Symlink integrity
- Configuration file presence
- Tool availability
- Functionality testing

### `validate-package.sh`
**Purpose**: Comprehensive package validation
**Usage**: `./scripts/validate-package.sh <package-name>`

Validation:
- Syntax checking
- Dependency verification
- Security validation
- Performance testing

### `cleanup.sh`
**Purpose**: Clean up temporary files and broken symlinks
**Usage**: `./scripts/cleanup.sh`

Features:
- Broken symlink removal
- Temporary file cleanup
- Backup directory management
- Cache clearing

## Development Scripts

### `dev-setup.sh`
**Purpose**: Set up development environment for DotClaude
**Usage**: `./scripts/dev-setup.sh`

Features:
- Git hooks installation
- Pre-commit configuration
- Testing environment setup
- Documentation generation

### `run-tests.sh`
**Purpose**: Execute comprehensive test suite
**Usage**: `./scripts/run-tests.sh [component]`

Test categories:
- Unit tests for individual scripts
- Integration tests for package interactions
- Performance benchmarks
- Security validation

## Script Configuration

### Environment Variables
Scripts use the following environment variables:

```bash
# Core directories
DOTFILES_DIR="${HOME}/dotfiles"
BACKUP_DIR="${DOTFILES_DIR}/backups"
STOW_DIR="${DOTFILES_DIR}/stow"

# Tool preferences
EDITOR="${EDITOR:-nvim}"
SHELL="${SHELL:-zsh}"
TMUX_SESSION_PREFIX="claude"
```

### Logging
All scripts support consistent logging:
- **INFO**: General information
- **WARN**: Non-fatal warnings
- **ERROR**: Fatal errors
- **DEBUG**: Detailed debugging information

### Error Handling
Scripts implement robust error handling:
- Exit codes for automation
- Rollback on failure
- User confirmation for destructive operations
- Detailed error messages

## Usage Patterns

### Daily Workflow
```bash
# Morning setup
./scripts/health-check.sh
tmux-claude-workspace daily

# Apply new configurations
./scripts/stow-package.sh new-feature

# End of day cleanup
./scripts/cleanup.sh
./scripts/backup.sh
```

### Emergency Recovery
```bash
# Quick health check
./scripts/health-check.sh

# Restore from backup
./scripts/restore.sh shell 2024-06-18

# Reset to known good state
./scripts/toggle-shell.sh original
```

### Development Workflow
```bash
# Set up development environment
./scripts/dev-setup.sh

# Test changes
./scripts/test-config.sh modified-package

# Apply and verify
./scripts/stow-package.sh modified-package
./scripts/health-check.sh
```

## Customization

### Adding New Scripts
1. Follow naming conventions (`action-target.sh`)
2. Include proper error handling
3. Add usage documentation
4. Implement logging
5. Add to main script directory

### Script Templates
Base templates are available in `scripts/templates/` for:
- Package management scripts
- Configuration toggles
- Testing frameworks
- Automation workflows