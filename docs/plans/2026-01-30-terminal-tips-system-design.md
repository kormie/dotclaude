# Terminal Tips System Design

A tip/suggestion system to help discover and remember terminal functionality.

## Overview

Three-layer approach to surfacing the rich set of aliases, shortcuts, and tools configured in this dotfiles repo:

1. **Startup tips** - Random tip shown below KOHO banner on new shell
2. **Context-triggered coaching** - Reminders when using "old" commands, blocks on 3rd miss
3. **On-demand browsing** - `tip` for random, `tips [category]` for category listing

## Architecture

```
stow/tips/
├── .config/dotfiles/tips/
│   ├── tips.sh                    # Core library (~150 lines)
│   └── tips-data/
│       ├── modern.tips            # Rust tool replacements (~15)
│       ├── git.tips               # Git aliases + difftastic (~20)
│       ├── zsh.tips               # Advanced shell tricks (~10)
│       ├── tmux.tips              # Key bindings + workflows (~15)
│       ├── nav.tips               # Directory navigation (~10)
│       ├── docker.tips            # Container shortcuts (~10)
│       └── k8s.tips               # Kubernetes shortcuts (~10)
└── .zshrc.d/
    └── tips.zsh                   # Shell integration (~100 lines)
```

Plus modification to `koho.zsh-theme` to call `tips_show_startup`.

## Tip Data Format

Simple pipe-delimited format in `.tips` files:

```
alias|old_command_pattern|description|example
```

Example:
```
ll|ls -la|List files with git status, icons, and grouping|ll ~/Documents
```

## Startup Display

Composed below KOHO banner:

```
██╗  ██╗ ██████╗ ██╗  ██╗ ██████╗
██║ ██╔╝██╔═══██╗██║  ██║██╔═══██╗
█████╔╝ ██║   ██║███████║██║   ██║
██╔═██╗ ██║   ██║██╔══██║██║   ██║
██║  ██╗╚██████╔╝██║  ██║╚██████╔╝
╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝

    3, 2, 1… Let's get it!

┌─[Modern Tools]─────────────────────────────────────────────┐
│ ll → List files with git status, icons, and grouping       │
│ Try: ll ~/Documents                                        │
└────────────────────────────────────────────────────────────┘
```

Uses KOHO brand colors for consistency.

## Context-Triggered Coaching

Uses `preexec` hook to intercept commands:

**First two uses - gentle reminder:**
```
$ ls -la
[... normal output ...]
💡 Tip (1/3): Use 'll' instead of 'ls -la' for git status + icons
```

**Third use - soft block:**
```
$ ls -la
🚫 Blocked: You've used 'ls -la' 3 times this session
   Use 'll' instead, or 'ls_original -la' to bypass
```

Key behaviors:
- Count resets each session
- `_original` suffix always bypasses
- Only tracks interactive standalone commands

## On-Demand Commands

**`tip`** - Shows random tip (same format as startup)

**`tips`** - Lists available categories
```
Available categories: modern git zsh tmux nav docker k8s
Usage: tips <category>  or  tip (random)
```

**`tips <category>`** - Lists all tips in category
```
[Git Tips]
  gs        → git status
  ga        → git add
  ...
```

## Configuration

Environment variables for user control:

```zsh
export TIPS_STARTUP=0      # Disable startup tips
export TIPS_COACHING=0     # Disable context-triggered reminders
export TIPS_BLOCK_COUNT=5  # Change block threshold (default: 3)
```

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Command in pipeline | No tracking |
| Command in script/function | No tracking |
| `_original` suffix used | No tracking (intentional bypass) |
| Tips directory missing | Graceful no-op |
| Non-interactive shell | All tips disabled |

## Performance

- Tip files loaded once at startup (~5ms)
- No subshells during preexec hook
- State in shell variables (no disk I/O)
