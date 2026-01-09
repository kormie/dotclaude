# Package Structure

Understanding DotClaude's modular package organization and architecture.

## Package Architecture

### Design Principles
- **Modularity** - Each package serves a specific purpose
- **Independence** - Packages can be applied separately
- **Safety** - Non-destructive installation and removal
- **Consistency** - Uniform structure across all packages

### Package Categories

#### Core Packages
Essential configurations for primary tools:
- **git** - Git configuration with modern diff tools
- **zsh** - Shell enhancement with Oh-My-Zsh
- **neovim** - Modern editor with LSP integration
- **tmux** - Terminal multiplexing with vim navigation

#### Support Packages
Infrastructure and utilities:
- **aliases** - Centralized alias management with modern CLI tools as defaults
- **environment** - PATH and environment variables
- **claude-code** - Claude Code commands, skills, and hooks for AI development

## Package Structure

### Standard Package Layout
```
stow/package-name/
├── README.md              # Package documentation
├── .config/               # XDG config directory files
├── bin/                   # Executable scripts
├── dotfiles/              # Configuration files
└── [target-structure]     # Mirror of target directory
```

### Example: Git Package
```
stow/git/
├── README.md              # Git package documentation
├── .gitconfig             # Main git configuration
├── .gitignore_global      # Global gitignore patterns
└── bin/
    └── git-dtl            # Difftastic alias script
```

### Example: Neovim Package
```
stow/neovim/
├── README.md              # Neovim package documentation
└── .config/
    └── nvim/              # Neovim configuration
        ├── init.lua       # Entry point
        ├── lua/
        │   ├── config/    # Core configuration
        │   ├── plugins/   # Plugin specifications
        │   └── user/      # User preferences
        └── after/         # After-plugins
```

### Example: Claude Code Package
```
stow/claude-code/
├── README.md              # Claude Code package documentation
└── .claude/
    ├── commands/          # Slash commands
    │   ├── marimo-check.md
    │   ├── marimo-convert.md
    │   ├── marimo-run.md
    │   └── marimo-edit.md
    ├── skills/            # Auto-triggered skills
    │   ├── anywidget-generator/
    │   │   └── instructions.md
    │   └── marimo-notebook/
    │       └── instructions.md
    └── hooks/             # PostToolUse hooks
        └── marimo-check.sh
```

## Package Dependencies

### Dependency Management
While packages are designed to be independent, some have soft dependencies:

```yaml
git:
  dependencies: []
  enhances: [zsh, neovim]

zsh:
  dependencies: [aliases, environment]
  enhances: [git, tmux]

neovim:
  dependencies: []
  enhances: [git, tmux]

tmux:
  dependencies: []
  enhances: [zsh, neovim]

claude-code:
  dependencies: []
  enhances: [tmux]
  external: [marimo, uv]  # Optional external tools
```

### Dependency Resolution
The `stow-package.sh` script handles dependencies:
1. Check for required dependencies
2. Offer to install missing dependencies
3. Apply packages in correct order
4. Verify successful installation

## Package Lifecycle

### Development Phase
1. **Structure Creation** - Set up package directory
2. **Configuration Development** - Create configuration files
3. **Testing** - Validate in isolated environment
4. **Documentation** - Write README and usage guide

### Deployment Phase
1. **Backup** - Save existing configurations
2. **Application** - Apply package with stow
3. **Verification** - Test functionality
4. **Integration** - Ensure compatibility with other packages

### Maintenance Phase
1. **Updates** - Regular configuration updates
2. **Bug Fixes** - Address issues and conflicts
3. **Enhancement** - Add new features
4. **Cleanup** - Remove deprecated elements

## Package Standards

### File Organization
- **Configuration Files** - Mirror target directory structure
- **Scripts** - Place in `bin/` directory
- **Documentation** - Include comprehensive README
- **Tests** - Add validation scripts

### Naming Conventions
- **Package Names** - Use lowercase with hyphens
- **File Names** - Follow target system conventions
- **Script Names** - Use descriptive, action-oriented names

### Documentation Requirements
Each package must include:
- Purpose and overview
- Installation instructions
- Configuration options
- Troubleshooting guide
- Dependency information

## Custom Package Creation

### Creating New Packages
1. **Identify Need** - Define package purpose
2. **Plan Structure** - Design directory layout
3. **Develop Configuration** - Create config files
4. **Test Thoroughly** - Validate functionality
5. **Document Completely** - Write comprehensive docs

### Package Template
```bash
# Create new package structure
mkdir -p stow/new-package/{bin,.config}
echo "# New Package" > stow/new-package/README.md

# Add configuration files
# Test and validate
# Document usage
```

### Best Practices
- **Single Responsibility** - One purpose per package
- **Minimal Dependencies** - Reduce coupling
- **Comprehensive Testing** - Validate all functionality
- **Clear Documentation** - Enable user success

## Package Integration

### Cross-Package Coordination
Packages coordinate through:
- **Shared Directories** - Common configuration locations
- **Environment Variables** - Shared settings
- **Script Integration** - Cross-package automation
- **Documentation Links** - Related package references

### Conflict Resolution
When packages conflict:
1. **Detection** - Automated conflict identification
2. **Resolution** - Merge or override strategies
3. **User Choice** - Interactive resolution options
4. **Documentation** - Clear conflict explanations

## Quality Assurance

### Package Validation
Each package undergoes:
- **Syntax Checking** - Configuration file validation
- **Functionality Testing** - Feature verification
- **Integration Testing** - Cross-package compatibility
- **Performance Testing** - Resource usage validation

### Continuous Integration
Automated testing ensures:
- Package integrity
- Cross-platform compatibility
- Dependency satisfaction
- Documentation accuracy

## Advanced Features

### Conditional Configuration
Packages can include conditional logic:
- **Platform Detection** - OS-specific configurations
- **Tool Availability** - Feature availability checks
- **User Preferences** - Customizable options
- **Environment Adaptation** - Context-aware setup

### Plugin Architecture
Some packages support plugins:
- **Neovim** - Lua plugin system
- **Zsh** - Oh-My-Zsh plugin integration
- **Tmux** - Plugin manager support
- **Git** - Hook and command extensions

## Migration and Upgrades

### Package Updates
Updating packages involves:
1. **Backup Current** - Preserve working state
2. **Apply Updates** - Install new version
3. **Merge Conflicts** - Resolve configuration conflicts
4. **Validate Function** - Ensure continued operation
5. **Update Documentation** - Reflect changes

### Breaking Changes
When packages have breaking changes:
- **Migration Scripts** - Automated update assistance
- **Compatibility Mode** - Temporary backward compatibility
- **Clear Communication** - Document all changes
- **Rollback Support** - Easy reversion capability