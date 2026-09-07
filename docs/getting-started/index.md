# Installation

Get started with DotClaude in minutes with our safety-first approach.

## Contributor shell (optional)

The repository has an optional [devenv](https://devenv.sh/) shell for working
on the repository on macOS or Linux. Install only its prerequisites, then enter
it and run the named checks:

```bash
./scripts/install.sh --contributor
devenv shell
devenv tasks run docs:build
devenv tasks run shell:lint
devenv tasks run flipper:validate
devenv tasks run check:all  # aggregate check; `devenv test` is equivalent
```

The locked shell contains only contributor tools: Bun, Python, Git, ShellCheck,
and shfmt. Shell entry has no setup hook: it does not invoke Stow, Homebrew,
`apt`, font installation, macOS defaults, or any repository install script, and
therefore does not create, remove, or replace user configuration under `$HOME`.
Only an explicit host-install command from the sections below changes the host.

devenv is not required. Contributors using native tools can run:

```bash
(cd docs && bun install --frozen-lockfile && bun run docs:build)
shellcheck --severity=error bin/claude-switch scripts/*.sh scripts/tmux-claude-workspace
for file in bin/claude-switch scripts/*.sh scripts/tmux-claude-workspace; do shfmt --to-json < "$file" >/dev/null; done
python3 - <<'PY'
import ast
from pathlib import Path
for source in sorted(Path("flipper").glob("*.py")):
    ast.parse(source.read_text(), filename=str(source))
PY
```

The contributor shell validates repository sources; the installer below
deploys dotfiles and manages the host. Keeping that boundary explicit makes
opening a development shell safe on both supported operating systems.

## Prerequisites

- **macOS** (tested on macOS Sonoma 14.5+)
- **Basic terminal familiarity**

That's it! The installer handles everything else (Homebrew, Git, Xcode CLI tools).

## Quick Installation (Fresh Mac)

For a brand new Mac without SSH keys configured:

```bash
# One-liner bootstrap - works without SSH keys
curl -fsSL bootstrap.kormie.link | bash
```

### Install Options

```bash
# Full installation (default) - all features
curl -fsSL bootstrap.kormie.link | bash

# Minimal installation - core only
curl -fsSL bootstrap.kormie.link | INSTALL_MODE=minimal bash

# Interactive installation - choose components
curl -fsSL bootstrap.kormie.link | INSTALL_MODE=interactive bash
```

## Installation (With SSH Keys)

If you already have SSH keys configured with GitHub:

```bash
# Clone and install
git clone git@github.com:kormie/dotclaude.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh --all
```

## Installation (HTTPS)

```bash
# Clone via HTTPS
git clone https://github.com/kormie/dotclaude.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh --all
```

## What Gets Installed

The setup script installs modern CLI tools that **coexist** with your existing setup:

| Tool | Purpose | Alias | Original |
|------|---------|--------|----------|
| [exa/eza](https://github.com/eza-community/eza) | Enhanced ls | `ll2` | `ls` |
| [bat](https://github.com/sharkdp/bat) | Syntax highlighting cat | `cat2` | `cat` |
| [fd](https://github.com/sharkdp/fd) | Fast find alternative | `find2` | `find` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Ultra-fast grep | `grep2` | `grep` |
| [delta](https://github.com/dandavison/delta) | Better git diffs | (git integration) | - |
| [difftastic](https://github.com/Wilfred/difftastic) | Syntax-aware diffs | `git dtl` | - |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart directory navigation | `z` | `cd` |

## Safety Features

Your existing setup remains **completely untouched**:

- ✅ All existing dotfiles are automatically backed up
- ✅ New tools use different command names (with `2` suffix)
- ✅ Original commands continue to work exactly as before
- ✅ Easy rollback if you want to remove anything

## Next Steps

1. **[Quick Setup](./quick-setup)** - Apply your first configurations
2. **[Safety Guide](./safety)** - Understand the backup/restore system
3. **[Linux Server Setup (Minimal Profile)](./server)** - VPS bootstrap (tmux + vim-min + mosh + fzf/bat/zoxide)
3. **[Modern Tools](./tools)** - Learn about the new CLI tools

## Verification

Verify your installation is working:

```bash
# Check tool availability
ll2        # Should show enhanced directory listing
cat2 --help # Should show bat help with syntax highlighting info
git lg     # Should show your preferred git log format

# Test Claude Code workspace (if claude-code is installed)
cw test-project feature-1 feature-2  # 'cw' is an alias for 'tmux-claude-workspace'
```

## Troubleshooting

**Command not found errors?**
```bash
# Reload your shell configuration
source ~/.zshrc
# or
exec $SHELL
```

**Need to rollback?**
```bash
# Restore from automatic backup
./scripts/restore.sh
```

**Still having issues?**
Check our [troubleshooting guide](/reference/troubleshooting) or [open an issue](https://github.com/kormie/dotclaude/issues).

## What's Next?

Once installation is complete, you're ready to:
- [Apply your first configurations](./quick-setup)
- [Launch Claude Code workspaces](/claude-code/workspace)
- [Explore the modern tools](./tools)
