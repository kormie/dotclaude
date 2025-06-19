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
cw myproject feature-1 feature-2  # 'cw' alias for tmux-claude-workspace

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

## Phase 2 Complete ✅

**Shell Enhancement**
- Enhanced Zsh configuration with Oh-My-Zsh and essential plugins
- Modern tool integration with coexisting aliases (ll2, cat2, etc.)
- Safety toggle system for easy configuration switching
- Centralized alias management with single source of truth

[View detailed Phase 2 documentation →](/reference/phase-2)

## Phase 3 Complete ✅

**Editor Enhancement**
- Modern Neovim configuration with Lua and lazy.nvim (40+ plugins)
- Full LSP integration with Mason for automatic language servers
- Advanced git integration (gitsigns, fugitive, diffview)
- Enhanced UI with Tokyo Night theme, Lualine, Neo-tree explorer
- Telescope integration for fuzzy finding files, text, git, LSP
- All user preferences preserved (comma leader, hjkl navigation)
- Production ready with comprehensive testing and issue resolution

[View Phase 3 migration guide →](/getting-started/phase-3-migration)

## ✅ Phase 4 Complete - Full Integration & Optimization

**All Project Goals Achieved:**
- ✅ Enhanced configurations deployed as primary setup
- ✅ Performance optimized: Neovim ~47ms, Zsh ~380ms startup
- ✅ Advanced shell features: project environments, command correction
- ✅ Modern tool integration: ll2, cat2, find2, grep2, and more
- ✅ Comprehensive testing and validation complete
- ✅ Production-ready with complete safety systems

**DotClaude is now fully operational - a modern, safe, and powerful CLI environment optimized for AI-assisted development!**

[View complete project documentation →](/reference/)

## Why DotClaude?

Built specifically for developers using Claude Code and other AI tools, DotClaude provides:

- **Parallel Development**: Work on multiple features simultaneously with git worktrees
- **Vim Integration**: Seamless navigation between vim and tmux with consistent keybindings  
- **Safety Systems**: Comprehensive backup and rollback procedures for peace of mind
- **Modern Tools**: Latest Rust-based CLI tools with gradual migration paths
- **AI-Optimized Workflows**: Purpose-built for agentic development patterns

Perfect for developers who want a powerful, safe, and modern CLI environment optimized for AI-assisted development workflows.

---

## 🎉 **Mission Accomplished**

**DotClaude project is complete!** From initial concept to production deployment, this project successfully delivered a modern, safe, and powerful CLI environment specifically optimized for AI-assisted development.

**Ready to transform your development workflow?** [Get started now →](/getting-started/)

**Built for the future of AI-assisted development** 🤖✨