# Modern CLI Tools

Discover the Rust-based CLI tools that enhance your development workflow.

## Installation

```bash
# Install all modern tools (safe, non-destructive)
./scripts/setup-tools.sh

# Install specific categories
./scripts/setup-tools.sh rust-tools     # Core Rust tools
./scripts/setup-tools.sh additional     # Additional utilities
```

## Tool Categories

### File Operations

#### **exa/eza** - Enhanced `ls`
Better directory listings with colors, git integration, and icons.

```bash
# Traditional command
ls -la

# Modern alternatives
ll2         # exa/eza with long format
l2          # exa/eza with git status
tree2       # Directory tree view
```

**Features:**
- Git status integration
- File type icons
- Better color schemes
- Human-readable file sizes
- Directory-first sorting

#### **bat** - Enhanced `cat`
Syntax-highlighted file viewing with line numbers and git integration.

```bash
# Traditional command
cat config.json

# Modern alternative
cat2 config.json    # Syntax highlighting + line numbers
less2 config.json   # Paged viewing with highlighting
```

**Features:**
- Syntax highlighting for 200+ languages
- Line numbers and git diff integration
- Automatic paging for long files
- Theme support (matches delta git diffs)

#### **fd** - Fast `find`
Faster, more intuitive file searching with regex support.

```bash
# Traditional command
find . -name "*.js" -type f

# Modern alternative
find2 "\.js$"           # Regex pattern
find2 -e js             # File extension
find2 config            # Partial name match
```

**Features:**
- 5-10x faster than traditional find
- Respects .gitignore automatically  
- Colored output
- Unicode support
- Smart case sensitivity

### Text Processing

#### **ripgrep** - Ultra-fast `grep`
Blazingly fast text search with smart defaults.

```bash
# Traditional command
grep -r "function" src/

# Modern alternative
grep2 "function" src/    # Faster with better output
rg "function" src/       # Direct ripgrep usage
```

**Features:**
- 2-10x faster than grep
- Respects .gitignore
- Unicode support
- Multi-line search
- Automatic encoding detection

### System Monitoring

#### **dust** - Better `du`
More intuitive disk usage visualization.

```bash
# Traditional command
du -sh * | sort -hr

# Modern alternative
du2              # Interactive disk usage tree
dust             # Direct usage
```

**Features:**
- Visual tree representation
- Sorted by size automatically
- Colored output
- Faster scanning

#### **procs** - Modern `ps`
Better process viewer with tree structure and search.

```bash
# Traditional command
ps aux | grep node

# Modern alternative
ps2              # Enhanced process tree
ps2 node         # Search for node processes
```

**Features:**
- Tree view of process relationships
- Colored output
- Search and filter capabilities
- Better memory/CPU display

#### **bottom** - Enhanced `top`
Cross-platform system monitor with graphs and customization.

```bash
# Traditional command
top

# Modern alternative
top2             # Enhanced system monitor
btm              # Direct bottom usage
```

**Features:**
- CPU, memory, disk, and network graphs
- Process search and sorting
- Customizable layouts
- Mouse support

### Navigation

#### **zoxide** - Smart `cd`
Learns your habits and jumps to frequently used directories.

```bash
# After visiting directories frequently
cd ~/Documents/Projects/myapp

# Smart navigation (after setup)
z myapp          # Jumps to most likely directory
cd2 myapp        # Alias for zoxide
```

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

### Gradual Adoption

1. **Try with `2` suffix**: Use `ll2`, `cat2`, `find2` to test
2. **Compare with originals**: Run both to see differences  
3. **Adopt when comfortable**: Create your own aliases when ready

### Integration Examples

```bash
# File exploration workflow
ll2                    # List directory with git status
find2 "\.js$" | head   # Find JS files
cat2 app.js            # View with syntax highlighting
grep2 "function" app.js # Search within file

# System monitoring workflow  
ps2 node               # Find node processes
du2                    # Check disk usage
top2                   # Monitor system resources

# Git workflow
git lg                 # Beautiful log
git dt                 # Syntax-aware diff
git dtl -5             # Recent commits with structural diffs
```

## Tool Comparison

| Category | Traditional | Modern | Speed Improvement |
|----------|------------|--------|-------------------|
| File listing | `ls` | `exa/eza` | Similar |
| File viewing | `cat` | `bat` | Similar + features |
| File search | `find` | `fd` | 5-10x faster |
| Text search | `grep` | `ripgrep` | 2-10x faster |
| Disk usage | `du` | `dust` | 2-3x faster |
| Process view | `ps` | `procs` | Similar + features |
| System monitor | `top` | `bottom` | Similar + features |
| Navigation | `cd` | `zoxide` | Smarter |

## Customization

### Aliases

All tools are available with safe aliases in `~/.aliases`:

```bash
# Modern tool aliases (coexist with originals)
alias ll2='exa -la --git --header --group-directories-first'
alias cat2='bat'
alias find2='fd'
alias grep2='rg'
alias du2='dust'
alias ps2='procs'
alias top2='btm'
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

**Want to use tools as defaults?**
```bash
# Edit ~/.aliases to create your own aliases
alias ls='exa'
alias cat='bat'
alias find='fd'
```

**Performance issues?**
Most modern tools have configuration options to tune performance for your system size and usage patterns.

Modern CLI tools significantly enhance your development workflow while maintaining compatibility with existing scripts and muscle memory! 🚀