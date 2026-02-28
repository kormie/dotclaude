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

## Mosh over Tailscale

Mosh is great over flaky networks, but it uses **UDP**. Over Tailscale, the simplest pattern is:

```bash
mosh root@<tailscale-hostname>
```

If you run into UDP/firewall issues, pin a single port:

```bash
mosh --port=60000 root@<tailscale-hostname>
```

Then allow that UDP port **only on the Tailscale interface** (example with UFW):

```bash
ufw allow in on tailscale0 to any port 60000 proto udp
```
