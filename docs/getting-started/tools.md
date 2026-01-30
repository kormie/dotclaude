# Modern CLI Tools

Discover the Rust-based CLI tools available in DotClaude as alternatives to traditional Unix commands.

## Installation

```bash
# Install all modern tools (safe, non-destructive)
./scripts/setup-tools.sh

# Install specific categories
./scripts/setup-tools.sh rust-tools     # Core Rust tools
./scripts/setup-tools.sh additional     # Additional utilities
```

::: tip Learn As You Go
DotClaude includes a terminal tips system that teaches you these modern tools naturally. When you use traditional commands like `cat` or `find`, it will gently remind you about the modern alternatives. See [Shell Enhancement](/guide/shell) for details.
:::

## Philosophy: Explicit Over Implicit

DotClaude does **not** alias traditional commands to modern replacements. Instead:

```bash
# Traditional commands work as expected
cat file.txt     # Standard cat
find . -name x   # Standard find
grep pattern     # Standard grep

# Modern tools are used explicitly
bat file.txt     # Syntax-highlighted viewing
fd "*.md"        # Fast file finding
rg pattern       # Blazing fast search
```

**Why this approach?**
- Scripts and tools (like Claude Code) work correctly
- No surprises on other machines without these tools
- The tips system teaches you to use modern tools directly

## Tool Categories

### File Operations

#### **eza** - Enhanced Directory Listings
Better directory listings with colors, git integration, and icons.

```bash
# Aliased for convenience (eza is ls-compatible)
ls          # eza with icons
ll          # eza with long format, git status, icons
la          # eza with all files, git status, icons
l           # eza with long format
tree        # eza tree view

# Extended aliases
ll_git      # Long format respecting .gitignore
ll_all      # Long format showing all files
tree_git    # Tree view respecting .gitignore
tree_all    # Tree view showing all files
tree_depth  # Tree view with depth control
```

**Features:**
- Git status integration
- File type icons (with Nerd Fonts)
- Better color schemes
- Human-readable file sizes
- Directory-first sorting

#### **bat** - Syntax-Highlighted Viewing
Syntax-highlighted file viewing with line numbers and git integration.

```bash
# Use directly
bat config.json     # Syntax highlighting + line numbers
bat -p file.txt     # Plain output (no decorations)

# Convenience aliases
preview file        # Alias for bat
catp file           # Plain bat (no decorations, no paging)
bat_plain file      # Plain output
bat_no_pager file   # Disable paging
```

**Features:**
- Syntax highlighting for 200+ languages
- Line numbers and git diff integration
- Automatic paging for long files
- Theme support (matches delta git diffs)

#### **fd** - Fast File Finding
Faster, more intuitive file searching with regex support.

```bash
# Use directly (simpler syntax than find)
fd "*.md"           # Find markdown files
fd -e js            # Find by extension
fd config           # Partial name match
fd -H pattern       # Include hidden files

# Convenience aliases
fd_hidden pattern   # Include hidden files
fd_no_ignore pat    # Don't respect .gitignore
fd_all pattern      # Hidden + ignore nothing
```

**Features:**
- 5-10x faster than traditional find
- Respects .gitignore automatically
- Colored output
- Unicode support
- Smart case sensitivity

### Text Processing

#### **ripgrep (rg)** - Ultra-Fast Search
Blazingly fast text search with smart defaults.

```bash
# Use directly
rg "function" src/      # Search in directory
rg -i "pattern"         # Case-insensitive
rg -t js "import"       # Search only JS files
rg -C 3 "error"         # Show 3 lines context

# Convenience aliases
rg_hidden pattern       # Include hidden files
rg_all pattern          # Hidden + ignore nothing
rg_files pattern        # List matching files only
```

**Features:**
- 2-10x faster than grep
- Respects .gitignore
- Unicode support
- Multi-line search
- Automatic encoding detection

### System Monitoring

#### **dust** - Visual Disk Usage
More intuitive disk usage visualization.

```bash
# Use directly
dust                # Interactive disk usage tree
dust ~/Downloads    # Specific directory
dust -d 2           # Limit depth

# Convenience alias
dust_depth 3        # Control tree depth
```

**Features:**
- Visual tree representation
- Sorted by size automatically
- Colored output
- Faster scanning

#### **procs** - Modern Process Viewer
Better process viewer with tree structure and search.

```bash
# Use directly
procs               # Enhanced process list
procs node          # Search for processes
procs --tree        # Tree view

# Convenience aliases
procs_tree          # Tree view
procs_watch         # Watch mode
myps                # Traditional ps for current user
```

**Features:**
- Tree view of process relationships
- Colored output
- Search and filter capabilities
- Better memory/CPU display

#### **bottom (btm)** - System Monitor
Cross-platform system monitor with graphs and customization.

```bash
# Use directly
btm                 # Full system monitor
btm --basic         # Basic mode
btm --tree          # Process tree view

# Convenience aliases
btm_basic           # Basic mode
btm_tree            # Tree view
```

**Features:**
- CPU, memory, disk, and network graphs
- Process search and sorting
- Customizable layouts
- Mouse support

### Navigation

#### **zoxide (z)** - Smart Directory Jumping
Learns your habits and jumps to frequently used directories.

```bash
# Use directly
z projects          # Jump to frecent "projects" directory
z doc down          # Fuzzy match multiple terms
zi                  # Interactive selection with fzf

# After using directories, zoxide learns patterns
cd ~/Documents/Projects/myapp   # Visit normally
z myapp                         # Later, jump directly
```

**Features:**
- Learns from your navigation patterns
- Fuzzy matching
- Works across shell sessions
- Interactive selection for conflicts

#### **broot (br)** - Interactive Tree
Navigate directory trees interactively with fuzzy search.

```bash
# Use directly
br                  # Interactive tree browser
```

**Features:**
- Interactive directory navigation
- Fuzzy search within trees
- File preview
- Quick actions (edit, copy, move)

## Git Integration

### **delta** - Better Git Diffs
Enhanced git diff viewer with syntax highlighting. Automatically used by git.

```bash
# Automatically used in git commands
git diff            # Uses delta
git log -p          # Beautiful commit diffs
git show            # Enhanced commit viewing
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
# Via shell aliases
gdifft              # Difftastic diff
glogdifft           # Log with difftastic
gshowdifft          # Show with difftastic
```

**Features:**
- Syntax tree-based diffing
- Understands 30+ programming languages
- Better handling of code refactoring
- Structural change detection

## JavaScript Runtime

### **Bun** - Fast JavaScript Runtime
Ultra-fast JavaScript runtime, bundler, and package manager.

```bash
# Check installation
bun --version

# Usage
bun run script.ts   # Run JavaScript/TypeScript
bun install         # Install packages (faster than npm)
bun run dev         # Run package.json scripts
```

**Features:**
- 3-4x faster than Node.js for many operations
- Built-in TypeScript support
- Native bundler and test runner
- npm-compatible package manager

## Additional Utilities

### **jq** - JSON Processing
```bash
jq '.users[0].name' data.json   # Query JSON
cat data.json | jq '.'          # Pretty print (auto-colored)
```

### **httpie** - HTTP Client
```bash
http GET api.example.com/users
http POST api.example.com/users name=john
```

## Learning the Tools

The terminal tips system helps you learn these tools:

```bash
# See a random tip
tip

# Browse tips by category
tips modern    # Rust tool alternatives
tips git       # Git shortcuts
tips tmux      # Tmux keybindings

# When you use traditional commands, you'll see reminders:
$ cat file.txt
# ... output ...
Tip (1/3): Use 'bat' instead of 'cat' for syntax highlighting
```

## Tool Comparison

| Category | Traditional | Modern | Speed |
|----------|------------|--------|-------|
| Listing | `ls` | `ll` (eza) | Similar + features |
| Viewing | `cat` | `bat` | Similar + features |
| Finding | `find` | `fd` | 5-10x faster |
| Searching | `grep` | `rg` | 2-10x faster |
| Disk usage | `du` | `dust` | 2-3x faster |
| Processes | `ps` | `procs` | Similar + features |
| Monitor | `top` | `btm` | Similar + features |
| Navigation | `cd` | `z` | Smarter |

## Configuration

Many tools support configuration files:

- **bat**: `~/.config/bat/config`
- **bottom**: `~/.config/bottom/bottom.toml`
- **git-delta**: configured via `.gitconfig`

## Troubleshooting

**Tools not found after installation?**
```bash
# Reload shell
exec $SHELL

# Check PATH
echo $PATH | tr ':' '\n' | grep -E "(\.local/bin|\.cargo/bin)"
```

**Performance issues?**
Most modern tools have configuration options to tune performance for your system.

## Next Steps

1. **[Shell Enhancement](/guide/shell)** - Learn about the tips system and aliases
2. **[Quick Setup](./quick-setup)** - Apply configurations
3. **[Safety Guide](./safety)** - Understand backup and rollback procedures
