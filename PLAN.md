# koho-terminal-tutor

> Turn every terminal mistake into a learning moment. Smooth the path from "I've never used a terminal" to "I'm productive with Claude Code" — across an entire org.

## Problem

KOHO is rolling out Claude Code org-wide. Many team members have never used a terminal. The gap between "has a terminal open" and "can use Claude Code productively" is where people give up. This tool closes that gap through daily repetition, progressive education, AI-powered error recovery, and safety guardrails.

## Architecture: Hybrid Go CLI + Zsh Plugin

Two components that work together:

```
┌─────────────────────────────────────────────────────────┐
│                    User's Terminal                        │
│                                                          │
│  ┌──────────────────────┐    ┌────────────────────────┐ │
│  │   Zsh Plugin (thin)  │    │   Go CLI (koho-tutor)  │ │
│  │                      │    │                        │ │
│  │  • Error trapping    │───▶│  • Curriculum engine   │ │
│  │  • Startup lesson    │    │  • Error explainer     │ │
│  │  • Safety intercept  │    │  • Drill runner        │ │
│  │  • Gentle nudges     │    │  • Progress dashboard  │ │
│  │  • wtf command       │    │  • claude -p bridge    │ │
│  │                      │◀───│  • Error cache (bolt)  │ │
│  │  Ships via:          │    │  • Analytics export    │ │
│  │  claude-init plugin  │    │                        │ │
│  └──────────────────────┘    │  Ships via:            │ │
│                              │  MDM / Homebrew tap    │ │
│                              └────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

**Why hybrid?**
- The zsh plugin must be shell-native to intercept commands (`accept-line` widget) and trap errors (`TRAPZERR`, `precmd`) — you can't do this from an external binary
- The Go CLI handles everything that benefits from a real language: TUI, progress persistence, curriculum logic, `claude -p` orchestration, caching
- The plugin is ~150 lines of zsh that delegates to `koho-tutor` for anything complex

## Repository Structure

```
koho-terminal-tutor/
├── cmd/
│   └── koho-tutor/
│       └── main.go                 # CLI entrypoint
├── internal/
│   ├── curriculum/
│   │   ├── engine.go               # Progression logic, spaced repetition
│   │   ├── levels.go               # Level definitions and unlock criteria
│   │   └── lessons/
│   │       ├── 01-navigation.yaml  # Level 1: Where am I?
│   │       ├── 02-files.yaml       # Level 2: Files and folders
│   │       ├── 03-reading.yaml     # Level 3: Looking at things
│   │       ├── 04-editing.yaml     # Level 4: Changing things
│   │       ├── 05-git-basics.yaml  # Level 5: Git survival
│   │       ├── 06-claude-code.yaml # Level 6: Claude Code basics
│   │       ├── 07-workflows.yaml   # Level 7: KOHO daily workflows
│   │       └── 08-power-user.yaml  # Level 8: Putting it together
│   ├── errors/
│   │   ├── whisperer.go            # Error explanation orchestrator
│   │   ├── cache.go                # Local error→explanation cache (bbolt)
│   │   ├── classifier.go           # Classify error severity/type
│   │   └── prompts.go              # System prompts for claude -p
│   ├── drills/
│   │   ├── runner.go               # Interactive drill execution
│   │   ├── validator.go            # Check if user did the right thing
│   │   └── exercises/
│   │       └── *.yaml              # Exercise definitions per level
│   ├── progress/
│   │   ├── tracker.go              # Track commands used, lessons done
│   │   ├── streaks.go              # Daily streak tracking
│   │   ├── store.go                # SQLite persistence
│   │   └── analytics.go            # Export for org-level dashboards
│   ├── safety/
│   │   ├── guard.go                # Dangerous command detection
│   │   └── rules.yaml              # What to intercept and how
│   ├── nudge/
│   │   ├── detector.go             # "There's a better way" detection
│   │   └── suggestions.yaml        # Better alternatives mapping
│   └── ui/
│       ├── banner.go               # KOHO-branded startup display
│       ├── dashboard.go            # Progress dashboard TUI
│       ├── drillui.go              # Drill interaction TUI
│       ├── colors.go               # KOHO brand color constants
│       └── components.go           # Shared TUI components
├── plugin/
│   ├── koho-terminal-tutor.plugin.zsh  # oh-my-zsh/claude-init plugin entry
│   ├── hooks/
│   │   ├── error-trap.zsh          # TRAPZERR + stderr capture
│   │   ├── startup.zsh             # Daily lesson on new shell
│   │   ├── safety.zsh              # Dangerous command intercept
│   │   └── nudge.zsh               # Post-command suggestions
│   └── commands/
│       ├── wtf.zsh                 # "wtf just happened?" command
│       ├── learn.zsh               # Start today's lesson
│       └── drill.zsh               # Start practice drill
├── content/
│   ├── lessons/                    # KOHO-specific lesson content
│   ├── drills/                     # Exercise definitions
│   ├── errors/                     # Pre-cached common error explanations
│   ├── safety-rules.yaml           # Dangerous command definitions
│   └── nudges.yaml                 # Better-way suggestions
├── scripts/
│   ├── install.sh                  # Standalone installer
│   └── validate.sh                 # Post-install validation
├── Makefile                        # Build, test, install targets
├── go.mod
├── go.sum
├── CLAUDE.md                       # Claude Code instructions for this repo
└── README.md
```

## Core Systems

### 1. Error Whisperer

The flagship feature. Every terminal error becomes a learning moment.

**Flow:**

```
User runs command
        │
        ▼
Command fails (exit ≠ 0)
        │
        ▼
Zsh TRAPZERR fires ──▶ Captures: command, exit code, stderr (last 20 lines)
        │
        ▼
koho-tutor explain --command "..." --stderr "..." --exit-code N
        │
        ▼
    ┌───┴───┐
    │ Cache  │──── Hit? ──▶ Show cached explanation (instant)
    │ lookup │
    └───┬───┘
        │ Miss
        ▼
    ┌──────────┐
    │ claude -p │──── System prompt tuned for non-devs
    │           │     "Explain like I've never used a terminal"
    └─────┬────┘
          │
          ▼
    ┌──────────┐
    │  Cache   │──── Store explanation keyed by error signature
    │  store   │     (command pattern + exit code + stderr hash)
    └─────┬────┘
          │
          ▼
    Display friendly explanation with KOHO branding
```

**Auto vs. Manual:**

```
Level 1-3 (beginner):  Auto-explain all errors
                        "Looks like something went wrong. Here's what happened..."

Level 4-6 (learning):  Show short hint, offer detail
                        "Permission denied. Type 'wtf' for a full explanation."

Level 7-8 (proficient): Silent unless user asks
                        User types 'wtf' → full explanation
```

**Error explanation format (non-dev friendly):**

```
┌─[Oops!]─────────────────────────────────────────────────┐
│                                                          │
│  What happened:                                          │
│  You tried to edit a file that's protected. Think of     │
│  it like trying to edit a Google Doc you only have       │
│  "view" access to.                                       │
│                                                          │
│  What to do:                                             │
│  Run this instead:  sudo nano config.yaml                │
│  ("sudo" is like asking an admin to do it for you)       │
│                                                          │
│  Learn more:  koho-tutor explain permissions             │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

**System prompt for claude -p:**

```
You are a friendly terminal tutor helping someone who has NEVER used a
terminal before. They work at KOHO (a fintech company) and are learning
the terminal to use Claude Code.

The user ran a command that failed. Explain what happened and what to do.

Rules:
- Use analogies to things non-technical people understand (Google Docs,
  file folders, asking a coworker)
- Never say "just" or "simply" — nothing is obvious to them
- Keep it to 3-4 sentences max
- Always give them the exact command to fix it
- If the fix involves something potentially dangerous, warn them
- Format: "What happened:" + "What to do:" + optional "Learn more:"

Command: {command}
Exit code: {exit_code}
Error output: {stderr}
User's current skill level: {level}
```

**Cache strategy:**
- Key: normalized command pattern + exit code + stderr signature (first meaningful line, stripped of paths/specifics)
- Store: bbolt (embedded, zero config, single file at `~/.local/share/koho-tutor/error-cache.db`)
- TTL: 30 days (errors don't change meaning)
- Pre-seed: Ship with ~100 most common errors pre-explained (see `content/errors/`)

**Rate limiting:**
- Max 10 `claude -p` calls per 5-minute window
- Max 50 per hour
- If rate limited: show generic "Something went wrong. Type 'wtf' later to learn more."
- Rate limit state in memory (resets per shell session, generous enough for learning)

### 2. Progressive Curriculum

Eight levels that take someone from "what is a terminal" to "productive with Claude Code."

**Level Design:**

| Level | Name | Theme | Unlocks After |
|-------|------|-------|---------------|
| 1 | **Where Am I?** | `pwd`, `ls`, `cd`, `~`, `.`, `..` | Default start |
| 2 | **Files & Folders** | `mkdir`, `cp`, `mv`, `rm`, `touch`, `cat` | 5 L1 commands used naturally |
| 3 | **Looking at Things** | `cat`, `less`, `head`, `tail`, `grep` (basic) | 5 L2 commands used |
| 4 | **Making Changes** | text editors (nano basics), `echo >>`, pipes intro | 5 L3 commands used |
| 5 | **Git Survival** | `git status`, `git add`, `git commit`, `git pull`, `git push` | 5 L4 commands used |
| 6 | **Claude Code** | `claude`, basic prompting, reading output, approving changes | 5 L5 commands used |
| 7 | **KOHO Workflows** | PR reviews, branch conventions, CI checks, deploy process | Comfortable with L6 |
| 8 | **Power User** | Aliases, piping, scripting, customization | Self-directed |

**Lesson format (YAML):**

```yaml
# content/lessons/01-navigation.yaml
level: 1
name: "Where Am I?"
description: "Learn to navigate the file system — it's like Finder but with words"

lessons:
  - id: nav-001
    title: "Your first command"
    concept: "The terminal is waiting for you to tell it what to do"
    analogy: "Think of it like a text message to your computer"
    teach:
      command: "pwd"
      meaning: "Print Working Directory — shows where you are right now"
      analogy: "Like looking at the address bar in Finder"
      example: "pwd"
      expected_output_hint: "You'll see something like /Users/yourname"
    practice:
      prompt: "Type 'pwd' to see where you are"
      validation: "command_is:pwd"
      success: "You're in {{output}}. That's your current folder!"

  - id: nav-002
    title: "Look around"
    concept: "ls shows what's in the current folder"
    teach:
      command: "ls"
      meaning: "List — shows files and folders where you are"
      analogy: "Like opening a folder in Finder to see what's inside"
      example: "ls"
    practice:
      prompt: "Type 'ls' to see what files are here"
      validation: "command_is:ls"

  - id: nav-003
    title: "Go somewhere"
    concept: "cd changes your location"
    teach:
      command: "cd"
      meaning: "Change Directory — move to a different folder"
      analogy: "Like double-clicking a folder in Finder"
      example: "cd Documents"
    practice:
      prompt: "Move to your Documents folder with 'cd Documents'"
      validation: "command_starts_with:cd"
      success: "You're now in {{pwd}}!"

  - id: nav-004
    title: "Go back"
    concept: "cd .. goes up one level"
    teach:
      command: "cd .."
      meaning: "Go up to the parent folder"
      analogy: "Like clicking the back button in Finder"
    practice:
      prompt: "Go back to where you were with 'cd ..'"
      validation: "command_is:cd .."

  - id: nav-005
    title: "Go home"
    concept: "cd ~ or just cd takes you home"
    teach:
      command: "cd ~"
      meaning: "Go to your home folder — your personal space"
      analogy: "Like clicking 'Home' in the Finder sidebar"
    practice:
      prompt: "Go home by typing 'cd ~' or just 'cd'"
      validation: "command_matches:^cd(\\s+~)?$"
```

**Startup daily lesson:**

Each shell open shows one micro-lesson from the user's current level. Controlled by the curriculum engine's spaced repetition:
- New concepts introduced every 2-3 days
- Previously learned concepts resurface if not used recently
- Format: short, single concept, with an invitation to practice

```
┌─[Level 2: Files & Folders]──────────────────────────────┐
│                                                          │
│  Today's lesson: Copying files                           │
│                                                          │
│  cp  makes a copy of a file (like Cmd+C, Cmd+V)        │
│                                                          │
│  Try it:  cp notes.txt notes-backup.txt                  │
│                                                          │
│  Type 'learn' to practice  •  'skip' to dismiss          │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

**Unlock criteria:**
- Track which commands from the current level the user has actually used (via `precmd` hook reporting to Go CLI)
- "Used naturally" = typed the command themselves (not during a drill)
- Each level requires N commands from its command set used at least once organically
- When unlocked: celebration moment + next level introduction

### 3. Daily Drills

Short interactive practice sessions matched to the user's level.

**Invocation:** `drill` (or `koho-tutor drill`)

**Drill flow:**
1. CLI selects 3-5 exercises from current level + review from prior levels
2. Each exercise: shows a prompt, user types a command, CLI validates
3. Immediate feedback (correct/try again/hint)
4. Summary at end with streak update

**Exercise format:**

```yaml
# content/drills/01-navigation.yaml
level: 1
exercises:
  - id: drill-nav-01
    prompt: "Show the files in your current directory"
    hints:
      - "The command is two letters"
      - "It stands for 'list'"
    accept:
      - "ls"
      - "ls -a"
      - "ls -l"
      - "ls -la"
    feedback:
      correct: "That's it! 'ls' lists everything in the current folder."

  - id: drill-nav-02
    prompt: "Navigate to your home directory"
    hints:
      - "You need to 'change directory'"
      - "The tilde character ~ means 'home'"
    accept:
      - "cd"
      - "cd ~"
      - "cd $HOME"
    feedback:
      correct: "Home sweet home! The ~ symbol always means your home folder."

  - id: drill-nav-03
    prompt: "Go up one directory level"
    hints:
      - "Two dots (..) means 'parent directory'"
    accept:
      - "cd .."
    feedback:
      correct: "Up we go! '..' always means 'the folder above this one'."
```

**Validation modes:**
- `command_is:X` — exact match
- `command_starts_with:X` — prefix match
- `command_matches:regex` — regex
- `output_contains:X` — check command output
- `cwd_is:X` — check resulting directory
- `file_exists:X` — check if file was created

### 4. Safety Net

Intercept dangerous commands with context-appropriate explanations.

**Rules (content/safety-rules.yaml):**

```yaml
rules:
  - pattern: "rm -rf /"
    severity: critical
    action: block
    message: "This would delete EVERYTHING on your computer. Seriously everything."

  - pattern: "rm -rf"
    severity: high
    action: confirm
    message: "This permanently deletes files and folders — there's no recycling bin in the terminal."
    suggestion: "Double-check the path after 'rm -rf' before pressing Enter."

  - pattern: "sudo rm"
    severity: high
    action: confirm
    message: "You're deleting files as an administrator. These can include important system files."

  - pattern: "chmod 777"
    severity: medium
    action: warn
    message: "This makes a file readable, writable, and executable by everyone. Usually not what you want."
    suggestion: "Try 'chmod 755' for folders or 'chmod 644' for files instead."

  - pattern: "git push --force"
    severity: high
    action: confirm
    message: "Force-pushing can overwrite your teammates' work. This is almost never what you want."
    suggestion: "Use 'git push --force-with-lease' which checks first, or better yet, just 'git push'."

  - pattern: "> /dev/"
    severity: critical
    action: block
    message: "Writing to system devices can cause serious problems."

  - pattern: ":(){ :|:& };:"
    severity: critical
    action: block
    message: "This is a fork bomb — it would crash your computer."
```

**Actions:**
- `block`: Prevent execution entirely, explain why
- `confirm`: Ask "Are you sure?" with explanation, require explicit y/n
- `warn`: Allow execution but show warning first

**Implementation (zsh side):**

Uses the same `accept-line` widget pattern from the existing tips system. The zsh plugin sends the command to `koho-tutor safety-check --command "..."` before allowing execution. The Go CLI checks against rules and returns the action.

### 5. Gentle Nudges

Non-blocking suggestions when there's a better way. Different from the existing tips system's block behavior — this is always gentle, never blocks.

```
$ cat very-long-file.txt
[... output scrolls past ...]
  Tip: For long files, try 'less very-long-file.txt' — you can scroll up/down and search
```

```
$ ls -la | grep config
  Tip: Try 'find . -name "*config*"' or even 'fd config' for finding files
```

The nudge system runs post-command via `precmd` hook. The Go CLI maintains the mapping of "what they did" → "what might be better" with awareness of skill level (don't suggest `fd` to a Level 1 user).

### 6. Progress Dashboard

`koho-tutor progress` (or `progress` alias)

```
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  ██╗  ██╗ ██████╗ ██╗  ██╗ ██████╗                      │
│  ██║ ██╔╝██╔═══██╗██║  ██║██╔═══██╗                     │
│  █████╔╝ ██║   ██║███████║██║   ██║                      │
│  ██╔═██╗ ██║   ██║██╔══██║██║   ██║                      │
│  ██║  ██╗╚██████╔╝██║  ██║╚██████╔╝                     │
│  ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝                     │
│                                                          │
│  Terminal Journey                          Level 3 / 8   │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━░░░░░░░░  37%         │
│                                                          │
│  Current: Looking at Things                              │
│  Next:    Making Changes (2 more commands to unlock)     │
│                                                          │
│  ── Stats ──────────────────────────────────             │
│  Commands learned:  18 / 48                              │
│  Drills completed:  12                                   │
│  Current streak:    5 days 🔥                            │
│  Errors explained:  23                                   │
│                                                          │
│  ── Recent Commands ────────────────────────             │
│  ✓ cat     ✓ less    ✓ head     ○ tail                  │
│  ○ grep    ✓ wc      ○ sort     ○ diff                  │
│                                                          │
│  ── Level Progress ─────────────────────────             │
│  ✓ 1. Where Am I?        ✓ 2. Files & Folders           │
│  ▶ 3. Looking at Things  ○ 4. Making Changes             │
│  ○ 5. Git Survival       ○ 6. Claude Code                │
│  ○ 7. KOHO Workflows     ○ 8. Power User                 │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

**Data persistence:**
- SQLite at `~/.local/share/koho-tutor/progress.db`
- Tables: `command_usage`, `lessons_seen`, `drills_completed`, `errors_explained`, `daily_streaks`
- Analytics export: `koho-tutor analytics export --format json` for org-level dashboards

### 7. Command Tracking

The zsh plugin reports command usage to the Go CLI for curriculum progression.

**How it works:**
- `precmd` hook (after each command) sends: command name, exit code, timestamp
- `koho-tutor track --command "ls" --exit 0` (fire-and-forget, backgrounded)
- Go CLI updates progress DB, checks for level unlocks
- If level unlock triggered: sets a flag file that the zsh plugin reads on next prompt

**Privacy:**
- Only the command name is tracked, not arguments (no `git commit -m "secret message"`)
- All data is local only (`~/.local/share/koho-tutor/`)
- No telemetry phoning home
- Analytics export is explicit and opt-in

## Zsh Plugin Detail

The plugin entry point (`plugin/koho-terminal-tutor.plugin.zsh`):

```zsh
#!/usr/bin/env zsh
# koho-terminal-tutor - Terminal education for KOHO
# Requires: koho-tutor binary in PATH

# ── Guard ────────────────────────────────────────────────
# Only load for interactive shells, only if binary exists
[[ -o interactive ]] || return 0
command -v koho-tutor &>/dev/null || {
    echo "[koho-tutor] Binary not found. Install via MDM or: brew install kohofinancial/internal/koho-tutor"
    return 0
}

# ── Configuration ────────────────────────────────────────
export KOHO_TUTOR_ENABLED="${KOHO_TUTOR_ENABLED:-1}"
export KOHO_TUTOR_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/koho-tutor"

[[ "$KOHO_TUTOR_ENABLED" == "0" ]] && return 0

# ── Source hook scripts ──────────────────────────────────
local plugin_dir="${0:A:h}"
for hook_file in "$plugin_dir"/hooks/*.zsh(N); do
    source "$hook_file"
done

# ── Register commands ────────────────────────────────────
for cmd_file in "$plugin_dir"/commands/*.zsh(N); do
    source "$cmd_file"
done

# ── Startup lesson ───────────────────────────────────────
koho-tutor startup-lesson 2>/dev/null
```

**Key shell commands provided:**

| Command | What it does |
|---------|-------------|
| `wtf` | Explain the last error with AI |
| `learn` | Show today's lesson |
| `drill` | Start a practice session |
| `progress` | Show progress dashboard |
| `hint` | Get a hint during a drill |
| `koho-tutor` | Full CLI (all subcommands) |

## Distribution

### Go Binary (koho-tutor)

**Primary: MDM**
- Build for darwin/arm64 (Apple Silicon) and darwin/amd64
- MDM pushes binary to `/usr/local/bin/koho-tutor`
- Zero user action required

**Secondary: Private Homebrew tap**
```
kohofinancial/homebrew-internal  (private GitHub repo)
└── Formula/
    └── koho-tutor.rb
```

```bash
brew tap kohofinancial/internal
brew install koho-tutor
```

**CI/CD:** GitHub Actions builds on tag push, uploads to GitHub Releases, updates Homebrew formula automatically via `goreleaser`.

### Zsh Plugin (via claude-init)

Register in `kohofinancial/claude-init` marketplace:

```yaml
# claude-init plugin registry entry
name: koho-terminal-tutor
repo: kohofinancial/koho-terminal-tutor
path: plugin
load: koho-terminal-tutor.plugin.zsh
requires:
  - binary: koho-tutor
    install: "brew tap kohofinancial/internal && brew install koho-tutor"
tags: [education, onboarding, terminal]
```

The plugin directory is cloned by `claude-init` into the user's oh-my-zsh custom plugins directory. MDM pre-configures the plugin as active.

## Go CLI Design

### Subcommands

```
koho-tutor
├── startup-lesson          # Print today's lesson for shell startup
├── explain                 # Explain an error
│   ├── --command "..."
│   ├── --stderr "..."
│   ├── --exit-code N
│   └── --level N
├── safety-check            # Check if command is dangerous
│   └── --command "..."
├── nudge                   # Check for better alternatives
│   └── --command "..."
├── track                   # Record command usage
│   ├── --command "..."
│   └── --exit N
├── drill                   # Start interactive drill session
│   └── --count N           # Number of exercises (default: 5)
├── progress                # Show progress dashboard
├── lesson                  # Show a specific lesson
│   └── --id "nav-003"
├── level                   # Show current level info
├── analytics
│   └── export              # Export analytics JSON
├── reset                   # Reset progress (with confirmation)
└── version
```

### Key Dependencies (Go)

| Package | Purpose |
|---------|---------|
| `github.com/charmbracelet/bubbletea` | TUI framework for dashboard/drills |
| `github.com/charmbracelet/lipgloss` | Styled terminal output (KOHO branding) |
| `github.com/charmbracelet/glamour` | Markdown rendering in terminal |
| `go.etcd.io/bbolt` | Embedded key-value store for error cache |
| `modernc.org/sqlite` | Pure-Go SQLite for progress tracking |
| `gopkg.in/yaml.v3` | Lesson/drill content parsing |

### KOHO Branding (colors.go)

```go
var (
    ElectricLime = lipgloss.Color("#D1F300")
    LightPurple  = lipgloss.Color("#6B4D9E")
    JewelGreen   = lipgloss.Color("#126B4E")
    LimeTint     = lipgloss.Color("#E8FA80")
)
```

## User Journey: Day 1 → Day 30

### Day 1: First Terminal Session

1. User opens Ghostty (pre-configured by MDM)
2. KOHO banner displays
3. Welcome message: "Welcome to the terminal! Think of this as texting your computer."
4. First lesson: `pwd` — "Let's find out where you are"
5. Invited to try: `drill` for practice

### Day 3: First Error

1. User types `cd Documints` (typo)
2. Error: `cd: no such file or directory: Documints`
3. Auto-explanation appears:
   ```
   What happened: There's no folder called "Documints" — check for typos.
   What to do: Try 'ls' to see what folders exist, then 'cd Documents'
   ```
4. User learns about `ls` naturally through error recovery

### Day 7: Building Confidence

1. User is Level 2 (Files & Folders)
2. Daily drill on `cp`, `mv`, `mkdir`
3. Streak: 5 days
4. Nudge system active: "You typed 'cat bigfile.txt' — try 'less bigfile.txt' to scroll through it"

### Day 14: Git Starts

1. User hits Level 5 (Git Survival)
2. Lessons focus on `git status` → `git add` → `git commit` → `git push`
3. Safety net catches `git push --force` attempts
4. Error Whisperer explains merge conflicts in plain English

### Day 21: Claude Code

1. User reaches Level 6 (Claude Code)
2. Lessons on `claude` command, reading output, approving changes
3. Error Whisperer now explains Claude Code errors too
4. User starts being productive with AI-assisted development

### Day 30: Proficient

1. User is Level 7-8
2. Error Whisperer switches to `wtf`-triggered only
3. Nudges are rare (they know the efficient ways)
4. Progress dashboard shows mastery
5. User is productive with Claude Code in daily work

## Org-Level Visibility

`koho-tutor analytics export` outputs JSON that can feed dashboards:

```json
{
  "user_id": "anonymous-hash",
  "current_level": 5,
  "days_active": 18,
  "current_streak": 12,
  "commands_learned": 31,
  "drills_completed": 24,
  "errors_explained": 47,
  "level_history": [
    {"level": 1, "unlocked_at": "2026-03-01", "completed_at": "2026-03-04"},
    {"level": 2, "unlocked_at": "2026-03-04", "completed_at": "2026-03-08"},
    {"level": 3, "unlocked_at": "2026-03-08", "completed_at": "2026-03-13"},
    {"level": 4, "unlocked_at": "2026-03-13", "completed_at": "2026-03-18"},
    {"level": 5, "unlocked_at": "2026-03-18", "completed_at": null}
  ]
}
```

An opt-in telemetry endpoint could aggregate these across the org for "how close are we to Claude Code GA readiness?" dashboards. But local-only by default.

## Implementation Phases

### Phase 1: Error Whisperer + Safety Net (MVP)
**Ship first because it has immediate value — people are already hitting errors.**
- Go CLI: `explain`, `safety-check` subcommands
- Zsh plugin: `TRAPZERR` hook, `accept-line` safety intercept, `wtf` command
- Error cache with pre-seeded common errors
- `claude -p` integration with rate limiting
- Safety rules for dangerous commands

### Phase 2: Curriculum + Daily Lessons
- Go CLI: `startup-lesson`, `lesson`, `level` subcommands
- Curriculum engine with spaced repetition
- Level 1-3 content (Navigation, Files, Reading)
- Startup lesson display
- Command tracking via `precmd` hook

### Phase 3: Drills + Progress
- Go CLI: `drill`, `progress`, `track` subcommands
- Interactive drill runner with bubbletea TUI
- Progress dashboard
- Streak tracking
- Level 4-6 content (Editing, Git, Claude Code)

### Phase 4: Nudges + Polish + Org Analytics
- Gentle nudge system
- Level 7-8 content (KOHO Workflows, Power User)
- Analytics export
- Org dashboard integration
- Performance optimization
- Edge case handling

## Open Questions

1. **claude -p availability**: Is `claude` CLI available on all org machines? Does it need auth configured per-user, or is there an org-level API key?
2. **MDM specifics**: Which MDM (Jamf, Mosyle, Kandji)? This affects the binary delivery mechanism.
3. **Org analytics**: Is there an existing internal dashboard (Datadog, Grafana, etc.) to feed analytics into, or should we build a simple web view?
4. **Content review**: Who at KOHO reviews/approves curriculum content? Should there be a content authoring workflow?
5. **Accessibility**: Any specific accessibility requirements (screen reader compatibility, color blind safe palette)?
6. **Offline mode**: Should `wtf` work offline with cached explanations only, or is network always available?
