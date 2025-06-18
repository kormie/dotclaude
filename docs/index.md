---
layout: home

hero:
  name: DotClaude
  text: Modern Dotfiles for AI Development
  tagline: A highly modular CLI setup optimized for Claude Code and agentic development workflows
  image: 
    src: /hero-logo.svg
    alt: DotClaude
  actions:
    - theme: brand
      text: Get Started
      link: /getting-started/
    - theme: alt
      text: View on GitHub
      link: https://github.com/kormie/dotclaude

features:
  - icon: 🛡️
    title: Safety First
    details: Non-destructive development with comprehensive backup/restore system and easy rollback capabilities.
    
  - icon: ⚡
    title: Modern Tooling
    details: Rust-based CLI replacements with coexisting aliases. Upgrade your workflow without breaking existing habits.
    
  - icon: 🤖
    title: Claude Code Optimized
    details: Multi-session tmux workspaces with git worktrees for parallel AI-assisted development workflows.
    
  - icon: ⌨️
    title: Vim-Style Navigation
    details: Consistent hjkl keybindings throughout, optimized for CapsLock→Ctrl users with vim muscle memory.

  - icon: 🏗️
    title: Modular Architecture  
    details: GNU Stow package system with independent, testable components. Apply configurations gradually and safely.
    
  - icon: 🔧
    title: Enhanced Git Workflow
    details: Delta + Difftastic integration, modern aliases, and your preferred log format with SSH GPG signing preserved.
---

## Quick Start

```bash
# Clone the repository
git clone git@github.com:kormie/dotclaude.git ~/.dotfiles
cd ~/.dotfiles

# Install modern tools (safe, non-destructive)
./scripts/setup-tools.sh

# Launch Claude Code workspace
cw myproject feature-1 feature-2

# Apply configurations gradually
./scripts/stow-package.sh git      # Enhanced git config
./scripts/stow-package.sh tmux     # Vim-optimized tmux
./scripts/stow-package.sh aliases  # Centralized aliases
```

## Phase 1 Complete ✅

**Foundation & Safety Infrastructure**
- Comprehensive backup/restore system tested and working
- Multi-session Claude Code workspace with git worktrees  
- Vim-optimized tmux configuration with seamless navigation
- Enhanced git configuration with modern diff tools
- Modern CLI tool installation with coexisting aliases

[View detailed Phase 1 documentation →](/reference/phase-1)

## What's Next

**Phase 2: Shell Enhancement**
- Enhanced Zsh configuration with Oh-My-Zsh
- Modern tool integration and gradual migration  
- Advanced Claude Code workflow automation

[View project roadmap →](/reference/)

## Why DotClaude?

Built specifically for developers using Claude Code and other AI tools, DotClaude provides:

- **Parallel Development**: Work on multiple features simultaneously with git worktrees
- **Vim Integration**: Seamless navigation between vim and tmux with consistent keybindings  
- **Safety Systems**: Comprehensive backup and rollback procedures for peace of mind
- **Modern Tools**: Latest Rust-based CLI tools with gradual migration paths
- **AI-Optimized Workflows**: Purpose-built for agentic development patterns

Perfect for developers who want a powerful, safe, and modern CLI environment optimized for AI-assisted development workflows.

---

**Built for the future of AI-assisted development** 🤖✨