# Configuration Files

Complete reference for all DotClaude configuration files and their purposes.

## Configuration Architecture

### Stow Package Structure
```
stow/
├── git/                    # Git configuration
│   ├── .gitconfig         # Main git config
│   └── .gitignore_global  # Global gitignore
├── zsh/                   # Shell configuration
│   ├── .zshrc            # Main zsh config
│   └── .zsh_profile      # Profile settings
├── neovim/               # Editor configuration
│   └── .config/nvim/     # Neovim config directory
├── tmux/                 # Terminal multiplexer
│   └── .tmux.conf        # Tmux configuration
├── aliases/              # Centralized aliases
│   └── .config/dotfiles/aliases
└── environment/          # Environment variables
    └── .config/dotfiles/environment
```

## Core Configuration Files

### Git Configuration
**Location**: `stow/git/.gitconfig`
**Purpose**: Enhanced git setup with modern diff tools

Key features:
- Delta as default pager
- SSH commit signing
- GitHub URL rewriting
- Difftastic integration

```ini
[core]
    pager = delta
    editor = nvim
[gpg]
    format = ssh
[user]
    signingkey = CC88252F9D88566B
```

### Zsh Configuration
**Location**: `stow/zsh/.zshrc`
**Purpose**: Enhanced shell with Oh-My-Zsh integration

Key features:
- Oh-My-Zsh with curated plugins
- Modern tool integration
- Centralized alias loading
- Performance optimizations

### Neovim Configuration
**Location**: `stow/neovim/.config/nvim/`
**Purpose**: Modern Lua-based editor setup

Structure:
```
nvim/
├── init.lua              # Entry point
├── lua/
│   ├── config/           # Core configuration
│   ├── plugins/          # Plugin specifications
│   └── user/             # User preferences
```

### Tmux Configuration
**Location**: `stow/tmux/.tmux.conf`
**Purpose**: Vim-optimized terminal multiplexing

Key features:
- Vim-style navigation (hjkl)
- Claude Code integration
- Smart pane management
- Session persistence

## Support Configuration Files

### Centralized Aliases
**Location**: `stow/aliases/.config/dotfiles/aliases`
**Purpose**: Single source of truth for all aliases

Categories:
- Modern tool defaults (ls→eza, cat→bat, find→fd, grep→ripgrep, cd→zoxide)
- Legacy tool fallbacks (ls_original, cat_original, find_original, etc.)
- Git workflow shortcuts and difftastic integration
- Development conveniences and Claude Code integration
- System utilities and safety features

### Environment Variables
**Location**: `stow/environment/.config/dotfiles/environment`
**Purpose**: PATH management and environment setup

Features:
- XDG Base Directory compliance
- Modern tool PATH entries
- Development environment variables
- Cross-platform compatibility

## Script Configuration

### Management Scripts
**Location**: `scripts/`
**Purpose**: Safe configuration management

Key scripts:
- `stow-package.sh` - Apply packages safely
- `backup.sh` - Backup existing configurations
- `restore.sh` - Rollback changes
- `test-config.sh` - Test configurations

### Automation Scripts
**Location**: `scripts/`
**Purpose**: Workflow automation

Features:
- `tmux-claude-workspace` - Launch AI workspaces
- `install-modern-tools.sh` - Tool installation
- `toggle-*.sh` - Configuration switching

## Configuration Hierarchy

### Loading Order
1. **System Defaults** - OS and application defaults
2. **User Overrides** - Existing user configurations
3. **DotClaude Base** - Core DotClaude configurations
4. **Local Customizations** - User-specific modifications

### Precedence Rules
- Local configurations override DotClaude defaults
- User preferences are preserved during updates
- Safety backups maintain original settings
- Toggle scripts enable easy switching

## Customization Guidelines

### User Modifications
**Recommended**: Create local override files
**Location**: `~/.config/dotfiles/local/`
**Purpose**: Preserve customizations during updates

### Package Extensions
**Method**: Create additional stow packages
**Location**: `stow/local-*`
**Purpose**: Add personal configurations without conflicts

## File Permissions

### Security Considerations
- Configuration files: 644 permissions
- Scripts: 755 permissions
- SSH keys: 600 permissions
- Private configs: 600 permissions

### Backup Permissions
- Backups preserve original permissions
- Restore operations maintain security
- No elevation of privileges required

## Validation

### Configuration Health Checks
```bash
# Check all configurations
./scripts/health-check.sh

# Validate specific package
./scripts/validate-package.sh zsh

# Test configuration loading
./scripts/test-config.sh tmux
```

### Troubleshooting
- **Syntax Errors** - Use built-in validators
- **Permission Issues** - Check file permissions
- **Path Problems** - Verify environment variables
- **Conflicts** - Review stow status

## Integration Points

### Cross-Configuration Dependencies
- Aliases reference environment variables
- Tmux uses git configurations
- Neovim integrates with shell tools
- Scripts coordinate multiple packages

### External Tool Integration
- Oh-My-Zsh plugin management
- LSP server configuration
- Git hook integration
- Terminal application settings