# Modern CLI Tools

Discover the Rust-based CLI tools that have replaced traditional Unix commands as defaults in DotClaude.

## Installation

```bash
# Install all modern tools (safe, non-destructive)
./scripts/setup-tools.sh

# Install specific categories
./scripts/setup-tools.sh rust-tools     # Core Rust tools
./scripts/setup-tools.sh additional     # Additional utilities
```

::: tip Modern Tools Are Now Default
As of commit `4559798`, modern CLI tools are now the default commands. Legacy tools are available with `_original` suffix (e.g., `ls_original`, `cat_original`).
:::

## Tool Categories

### File Operations

#### **eza** - Enhanced `ls` (Now Default)
Better directory listings with colors, git integration, and icons.

```bash
# These now use eza by default (with fallback to ls if not installed)
ls          # eza with icons
ll          # eza with long format, git status, icons
la          # eza with all files, git status, icons
l           # eza with long format, git status, icons
tree        # eza tree view

# Legacy command (if you need original ls)
ls_original  # Original ls command
ll_original  # Original ls -la command
```

**Additional eza aliases for power users:**
- `ll_git` - Long format with git-ignore respect
- `ll_all` - Long format showing all files
- `tree_git` - Tree view respecting git-ignore
- `tree_all` - Tree view showing all files
- `tree_depth` - Tree view with depth control

**Features:**
- Git status integration
- File type icons
- Better color schemes
- Human-readable file sizes
- Directory-first sorting

#### **bat** - Enhanced `cat` (Now Default)
Syntax-highlighted file viewing with line numbers and git integration.

```bash
# These now use bat by default (with fallback to cat if not installed)
cat config.json     # Syntax highlighting + line numbers
less config.json    # Paged viewing with highlighting
preview config.json # Alias for bat

# Legacy command (if you need original cat)
cat_original config.json  # Original cat command
```

**Additional bat aliases for power users:**
- `bat_plain` - Plain output without decorations
- `bat_no_pager` - No paging for long files
- `catp` - Plain cat replacement (no decorations, no paging)

**Features:**
- Syntax highlighting for 200+ languages
- Line numbers and git diff integration
- Automatic paging for long files
- Theme support (matches delta git diffs)

#### **fd** - Fast `find` (Now Default)
Faster, more intuitive file searching with regex support.

```bash
# These now use fd by default (with fallback to find if not installed)
find "js$"              # Regex pattern (fd syntax)
find -e js              # File extension
find config             # Partial name match

# Legacy command (if you need original find)
find_original . -name "*.js" -type f  # Original find command
```

**Additional fd aliases for power users:**
- `fd_hidden` - Include hidden files
- `fd_no_ignore` - Don't respect .gitignore
- `fd_all` - Include hidden files and don't respect .gitignore

**Features:**
- 5-10x faster than traditional find
- Respects .gitignore automatically  
- Colored output
- Unicode support
- Smart case sensitivity

### Text Processing

#### **ripgrep** - Ultra-fast `grep` (Now Default)
Blazingly fast text search with smart defaults.

```bash
# These now use ripgrep by default (with fallback to grep if not installed)
grep "function" src/     # Ultra-fast search
fgrep "literal" src/     # Fixed string search (rg -F)
egrep "pattern" src/     # Extended regex search (rg)

# Legacy command (if you need original grep)
grep_original -r "function" src/  # Original grep command
fgrep_original "literal" src/     # Original fgrep command
egrep_original "pattern" src/     # Original egrep command
```

**Additional ripgrep aliases for power users:**
- `rg_hidden` - Include hidden files
- `rg_all` - Include hidden files and don't respect .gitignore
- `rg_files` - List matching files only

**Features:**
- 2-10x faster than grep
- Respects .gitignore
- Unicode support
- Multi-line search
- Automatic encoding detection

### System Monitoring

#### **dust** - Better `du` (Now Default)
More intuitive disk usage visualization.

```bash
# These now use dust by default (with fallback to du if not installed)
du               # Interactive disk usage tree

# Legacy command (if you need original du)
du_original -sh *  # Original du command
```

**Additional dust aliases for power users:**
- `dust_depth` - Control tree depth

**Features:**
- Visual tree representation
- Sorted by size automatically
- Colored output
- Faster scanning

#### **procs** - Modern `ps` (Now Default)
Better process viewer with tree structure and search.

```bash
# These now use procs by default (with fallback to ps if not installed)
ps               # Enhanced process tree
ps node          # Search for node processes
myps             # Traditional ps for current user (ps -f -u $USER)

# Legacy command (if you need original ps)
ps_original aux  # Original ps command
```

**Additional procs aliases for power users:**
- `procs_tree` - Tree view of processes
- `procs_watch` - Watch process changes

**Features:**
- Tree view of process relationships
- Colored output
- Search and filter capabilities
- Better memory/CPU display

#### **bottom** - Enhanced `top` (Now Default)
Cross-platform system monitor with graphs and customization.

```bash
# These now use bottom by default (with fallback to top if not installed)
top              # Enhanced system monitor

# Legacy command (if you need original top)
top_original     # Original top command
```

**Additional bottom aliases for power users:**
- `btm_basic` - Basic mode
- `btm_tree` - Tree view

**Features:**
- CPU, memory, disk, and network graphs
- Process search and sorting
- Customizable layouts
- Mouse support

### Navigation

#### **zoxide** - Smart `cd` (Now Default)
Learns your habits and jumps to frequently used directories.

```bash
# After visiting directories frequently
cd ~/Documents/Projects/myapp

# Smart navigation (zoxide is now the default cd)
cd myapp         # Jumps to most likely directory (transparently uses zoxide)
z myapp          # Direct zoxide usage (also available)

# Legacy command (if you need original cd)
cd_original ~/path  # Original cd command
```

::: tip Transparent Smart Navigation
As of commit `84f49a9`, `cd` now uses zoxide for smart directory jumping while maintaining full compatibility with traditional cd patterns. Use `cd_original` if you need the shell builtin.
:::

**Features:**
- Learns from your navigation patterns
- Fuzzy matching
- Works across shell sessions
- Interactive selection for conflicts

#### **broot** - Interactive Tree
Navigate directory trees interactively with fuzzy search.

```bash
# Launch interactive tree browser
br               # Direct broot usage
```

**Features:**
- Interactive directory navigation
- Fuzzy search within trees
- File preview
- Quick actions (edit, copy, move)

## Git Integration

### **delta** - Better Git Diffs
Enhanced git diff viewer with syntax highlighting.

```bash
# Automatically used in git commands
git diff         # Now uses delta
git log -p       # Beautiful commit diffs
git show         # Enhanced commit viewing
```

**Features:**
- Side-by-side diff view
- Syntax highlighting
- Line numbers and navigation
- Hyperlinks to files
- Word-level diff highlighting

### **difftastic** - Syntax-Aware Diffs
Understands code structure for better diff analysis.

```bash
# Via git aliases
git dt           # Difftastic diff
git dtl          # Difftastic log with diffs
git dtshow       # Difftastic show

# Direct usage
glogdifft        # Shell alias for syntax-aware log
```

**Features:**
- Syntax tree-based diffing
- Understands 30+ programming languages
- Better handling of code refactoring
- Structural change detection

## Package Management

### **GNU Stow** - Symlink Management
Manages dotfile symlinks safely and reversibly.

```bash
# Apply package
./scripts/stow-package.sh git

# Remove package
./scripts/stow-package.sh git remove

# Check status
./scripts/stow-package.sh git status
```

## Additional Utilities

### **jq/yq** - Data Processing
JSON and YAML processing with advanced queries.

```bash
# JSON processing
cat data.json | jq '.users[0].name'

# YAML processing  
cat config.yaml | yq '.database.host'
```

### **httpie** - HTTP Client
Modern HTTP client for API testing.

```bash
# GET request
http GET api.example.com/users

# POST with data
http POST api.example.com/users name=john email=john@example.com
```

## Usage Patterns

### Migration and Fallbacks

1. **Modern tools are now defaults**: `ls`, `cat`, `find`, `grep`, etc. use modern tools
2. **Automatic fallbacks**: If modern tools aren't installed, aliases fall back to original commands
3. **Access originals**: Use `_original` suffix (e.g., `ls_original`, `cat_original`) when needed
4. **Power user aliases**: Extended functionality available (e.g., `ll_git`, `bat_plain`, `fd_hidden`)

### Integration Examples

```bash
# File exploration workflow (modern tools as defaults)
ll                     # List directory with git status (eza)
find "js$" | head      # Find JS files (fd)
cat app.js             # View with syntax highlighting (bat)
grep "function" app.js # Search within file (ripgrep)

# System monitoring workflow (modern tools as defaults)
ps node                # Find node processes (procs)
du                     # Check disk usage (dust)
top                    # Monitor system resources (bottom)

# Git workflow
git lg                 # Beautiful log
git dt                 # Syntax-aware diff
git dtl -5             # Recent commits with structural diffs
```

## Tool Comparison

| Category | Traditional | Modern (Now Default) | Speed Improvement |
|----------|------------|---------------------|-------------------|
| File listing | `ls_original` | `ls` (eza) | Similar + features |
| File viewing | `cat_original` | `cat` (bat) | Similar + features |
| File search | `find_original` | `find` (fd) | 5-10x faster |
| Text search | `grep_original` | `grep` (ripgrep) | 2-10x faster |
| Disk usage | `du_original` | `du` (dust) | 2-3x faster |
| Process view | `ps_original` | `ps` (procs) | Similar + features |
| System monitor | `top_original` | `top` (bottom) | Similar + features |
| Navigation | `cd_original` | `cd` (zoxide) | Smarter |

## Customization

### Aliases

Modern tools are now the defaults with fallbacks in `~/.aliases`:

```bash
# Modern tools as defaults (with automatic fallbacks)
alias ls='eza --icons'  # Falls back to 'ls -G' if eza not available
alias cat='bat'         # Falls back to 'cat' if bat not available
alias find='fd'         # Falls back to 'find' if fd not available
alias grep='rg'         # Falls back to 'grep --color=auto' if rg not available

# Legacy tools available with _original suffix
alias ls_original='command ls -G'
alias cat_original='command cat'
alias find_original='command find'
alias grep_original='command grep --color=auto'
```

### Configuration

Many tools support configuration files:

- **bat**: `~/.config/bat/config`
- **bottom**: `~/.config/bottom/bottom.toml`
- **git-delta**: configured via `.gitconfig`

## Performance Benefits

### Benchmarks

Typical performance improvements on large codebases:

```bash
# File search comparison
time find . -name "*.js"           # ~2.1s
time fd "\.js$"                     # ~0.3s (7x faster)

# Text search comparison  
time grep -r "function" src/        # ~1.8s
time rg "function" src/             # ~0.2s (9x faster)
```

### Resource Usage

Modern tools are generally more efficient:
- Better memory usage patterns
- Optimized for SSD storage
- Parallel processing where beneficial
- Respect system resources

## Next Steps

1. **[Quick Setup](./quick-setup)** - Apply configurations to use these tools
2. **[Claude Code Workflows](/claude-code/workspace)** - Integrate tools into AI development
3. **[Safety Guide](./safety)** - Understand backup and rollback procedures

## Troubleshooting

**Tools not found after installation?**
```bash
# Reload shell
exec $SHELL

# Check PATH
echo $PATH | grep -o '[^:]*' | grep -E "(\.local/bin|\.cargo/bin)"
```

**Want to use original tools as defaults?**
```bash
# Edit ~/.aliases to override with original commands
alias ls='command ls -G'
alias cat='command cat'
alias find='command find'
# Or use the _original aliases directly
```

**Performance issues?**
Most modern tools have configuration options to tune performance for your system size and usage patterns.

Modern CLI tools significantly enhance your development workflow while maintaining compatibility with existing scripts and muscle memory! 🚀