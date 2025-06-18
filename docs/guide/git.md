# Git Configuration

Modern git setup with enhanced diff tools and workflow optimization.

## Overview

DotClaude enhances git with modern diff tools and optimized configuration for AI-assisted development workflows.

## Key Features

### Delta Integration
Enhanced git diffs with syntax highlighting and side-by-side view:
- Configured as the default git pager
- Improved readability for code reviews
- Integration with existing git workflows

### Difftastic Support
Syntax-aware diff tool for advanced comparisons:
- Access via `git dtl` alias
- `GIT_EXTERNAL_DIFF=difft` environment pattern
- Specialized for code structure analysis

### SSH Signing
Secure commit signing with SSH keys:
- GPG-style signing with SSH keys
- Key: 
- Automatic signature verification

## Configuration Files

The git package includes:
- `stow/git/.gitconfig` - Main git configuration
- Enhanced diff tool integration
- SSH signing setup
- GitHub-specific optimizations

## Usage

```bash
# Apply git configuration
./scripts/stow-package.sh git

# Test enhanced diffs
git log --graph --pretty="format:%C(yellow)%h%Cred%d%Creset %s %C(white) %C(cyan)%an%Creset, %C(green)%ar%Creset"

# Use difftastic for syntax-aware diffs
git dtl
```

## Safety

All git configurations preserve existing settings and can be safely rolled back:

```bash
# Backup existing config
./scripts/backup.sh git

# Rollback if needed
./scripts/restore.sh git
```