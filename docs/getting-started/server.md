# Linux Server Setup (Minimal Profile)

This is the minimal DotClaude profile for VPS/server bootstrapping.

Goals:
- tmux muscle memory
- vim muscle memory (minimal `.vimrc`, no plugins)
- mosh for resilient remote sessions
- a few ergonomic tools: fzf, bat, zoxide

## Quick start (Ubuntu/Debian)

```bash
git clone git@github.com:kormie/dotclaude.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh --server

# Verify
ls -la ~/.tmux.conf ~/.vimrc
```

## What it installs

Via `apt-get`:
- git
- stow
- tmux
- vim
- mosh
- fzf
- bat
- zoxide

## What it deploys

Via GNU stow into `$HOME`:
- `tmux` → `~/.tmux.conf`
- `vim-min` → `~/.vimrc`

## Notes

- Server mode always stows with an explicit target (`-t $HOME`) to avoid accidentally stowing into the dotfiles repo directory.
- If you want a different vim indent policy, edit `stow/vim-min/.vimrc`.
