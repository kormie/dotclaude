# marimo Integration

Claude Code integration with marimo reactive notebooks for AI-assisted data science and application development.

## Overview

[marimo](https://marimo.io/) is a reactive Python notebook framework that creates reproducible, interactive data applications. This integration provides Claude Code with specialized commands, skills, and hooks for seamless marimo development.

## Installation

### Using Stow

```bash
# Apply the claude-code package
./scripts/stow-package.sh claude-code install
```

### Manual Installation

```bash
# Copy commands
cp -r stow/claude-code/.claude/commands/* ~/.claude/commands/

# Copy skills
cp -r stow/claude-code/.claude/skills/* ~/.claude/skills/

# Copy hooks
cp -r stow/claude-code/.claude/hooks/* ~/.claude/hooks/
chmod +x ~/.claude/hooks/marimo-check.sh
```

### Enable Automatic Linting Hook

Add to your `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "~/.claude/hooks/marimo-check.sh \"$FILE\""
      }
    ]
  }
}
```

## Slash Commands

### /marimo-check

Run marimo notebook linting with automatic fixes.

```bash
# Check a single notebook
/marimo-check notebook.py

# Check multiple notebooks
/marimo-check src/*.py

# Check all notebooks in current directory
/marimo-check .
```

### /marimo-convert

Convert Jupyter notebooks to marimo format.

```bash
# Convert a single notebook
/marimo-convert analysis.ipynb

# Convert all notebooks in a directory
/marimo-convert notebooks/*.ipynb
```

### /marimo-run

Run a marimo notebook as a standalone application.

```bash
# Run as app
/marimo-run dashboard.py

# Run on specific port
/marimo-run --port 8080 app.py
```

### /marimo-edit

Open a marimo notebook in the interactive editor.

```bash
# Open in browser editor
/marimo-edit notebook.py

# Headless mode (no browser)
/marimo-edit --headless notebook.py
```

## Skills

### marimo-notebook

Automatically triggered when you ask Claude to create data analysis notebooks or reactive Python applications. Provides guidance on:

- Reactive cell structure
- Cell dependencies and variable passing
- UI components (`mo.ui.slider`, `mo.ui.dropdown`, etc.)
- Data visualization with Altair and Plotly
- File operations and data loading
- Best practices for notebook organization

**Example triggers:**
- "Create a data analysis notebook"
- "Build a reactive dashboard"
- "Make a marimo notebook for exploring this CSV"

### anywidget-generator

Triggered when you need custom UI components for marimo. Provides comprehensive guidance on:

- Python class structure with traitlets
- JavaScript module (`_esm`) implementation
- CSS styling with light/dark mode support
- Event handling and state synchronization
- Integration with `mo.ui.anywidget()`

**Example triggers:**
- "Create a custom slider widget for marimo"
- "Build an interactive canvas component"
- "Make a custom chart widget"

## Automatic Linting Hook

When enabled, the PostToolUse hook automatically validates marimo notebooks after any edit or write operation.

### How It Works

1. After Claude edits a Python file, the hook script runs
2. It checks for marimo markers (`import marimo` and `@app.cell`)
3. If detected, runs `uvx marimo check` on the file
4. If linting fails (exit code 2), the change is blocked
5. Claude sees the errors and automatically attempts fixes

### Hook Output Example

```
Detected marimo notebook: analysis.py
Running marimo check...
[marimo linting output]
marimo check passed.
```

### Disabling the Hook

Remove or comment out the hook configuration in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      // Commented out to disable
      // {
      //   "matcher": "Edit|Write",
      //   "command": "~/.claude/hooks/marimo-check.sh \"$FILE\""
      // }
    ]
  }
}
```

## Workflow Examples

### Creating a New Dashboard

```
User: Create a data dashboard that loads a CSV file and shows
      interactive charts with filtering options

Claude: [Uses marimo-notebook skill automatically]
        [Creates notebook with file upload, filters, and charts]
        [Hook runs marimo check after each edit]
```

### Converting Jupyter Notebooks

```
User: /marimo-convert my-analysis.ipynb

Claude: [Runs conversion command]
        [Opens converted notebook in editor if requested]
        [Helps fix any conversion issues]
```

### Building Custom Widgets

```
User: I need a custom color picker widget for my marimo notebook

Claude: [Uses anywidget-generator skill]
        [Creates Python class with traitlets]
        [Implements JavaScript rendering]
        [Adds CSS with dark mode support]
        [Hook validates the notebook structure]
```

## Integration with Claude Code Workspace

The marimo integration works seamlessly with the tmux-claude-workspace:

```bash
# Create workspace for notebook development
cw myproject notebook-feature data-viz

# Each pane can work on different notebooks
# Hook validates changes across all sessions
```

## Requirements

- **marimo** - Install with `pip install marimo` or use `uvx` (recommended)
- **uv** - For `uvx` command support: `pip install uv`
- **Claude Code CLI** - The Claude Code CLI tool

## Troubleshooting

### Hook Not Running

1. Check script is executable:
   ```bash
   chmod +x ~/.claude/hooks/marimo-check.sh
   ```

2. Verify settings.json syntax:
   ```bash
   cat ~/.claude/settings.json | python -m json.tool
   ```

3. Ensure `uvx` is in PATH:
   ```bash
   which uvx
   ```

### marimo check Failing

1. Run manually to see detailed errors:
   ```bash
   uvx marimo check your-notebook.py
   ```

2. Common issues:
   - Missing return statements in cells
   - Undefined variables in cell dependencies
   - Circular dependencies between cells

### Skills Not Triggering

- Be explicit: "Create a **marimo notebook** for..."
- Mention specific features: "...with reactive cells and UI components"
- The skill triggers on context, not just the word "marimo"

## Next Steps

- **[Automation](/claude-code/automation)** - More Claude Code automation scripts
- **[Best Practices](/claude-code/best-practices)** - Development workflow patterns
- **[Workspace Setup](/claude-code/workspace)** - Multi-session development
