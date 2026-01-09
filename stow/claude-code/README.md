# Claude Code Integration Package

This stow package provides Claude Code commands, skills, and hooks for enhanced AI-assisted development workflows.

## Contents

### Slash Commands (`~/.claude/commands/`)

- **`/marimo-check`** - Run marimo notebook linting with automatic fixes
- **`/marimo-convert`** - Convert Jupyter notebooks to marimo format
- **`/marimo-run`** - Run a marimo notebook as an application
- **`/marimo-edit`** - Open a marimo notebook in the interactive editor

### Skills (`~/.claude/skills/`)

- **`anywidget-generator`** - Guidance for creating custom anywidget UI components for marimo
- **`marimo-notebook`** - Best practices for creating and developing marimo reactive notebooks

### Hooks (`~/.claude/hooks/`)

- **`marimo-check.sh`** - PostToolUse hook for automatic marimo notebook linting after edits

## Installation

### Using Stow

```bash
# From the dotfiles root directory
cd ~/dotfiles  # or wherever your dotfiles are
stow -t ~ claude-code
```

### Manual Installation

```bash
# Copy commands
cp -r .claude/commands/* ~/.claude/commands/

# Copy skills
cp -r .claude/skills/* ~/.claude/skills/

# Copy hooks
cp -r .claude/hooks/* ~/.claude/hooks/
chmod +x ~/.claude/hooks/marimo-check.sh
```

### Enable the Hook

Add the following to your `~/.claude/settings.json`:

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

## Usage Examples

### marimo Commands

```bash
# Check and fix a notebook
/marimo-check notebook.py

# Convert a Jupyter notebook
/marimo-convert analysis.ipynb

# Run as an app
/marimo-run dashboard.py

# Open in editor
/marimo-edit notebook.py
```

### Skills

Skills are automatically triggered when Claude detects relevant context:

- Ask "create a custom slider widget for my marimo notebook" to trigger the anywidget-generator skill
- Ask "create a data analysis notebook" to trigger the marimo-notebook skill

### Hook Behavior

When you edit or create a Python file containing marimo notebook markers (`import marimo` and `@app.cell`), the hook automatically:

1. Detects the file is a marimo notebook
2. Runs `uvx marimo check` on the file
3. Blocks the change if linting fails (exit code 2)
4. Allows the change if linting passes (exit code 0)

This creates a feedback loop where Claude automatically validates and fixes notebook issues.

## Requirements

- [marimo](https://marimo.io/) - Install with `pip install marimo` or use `uvx`
- [uv](https://github.com/astral-sh/uv) - For `uvx` command support (recommended)
- Claude Code CLI

## Customization

### Adding New Commands

Create a new `.md` file in `~/.claude/commands/` with:

```markdown
# command-name

Description of what the command does.

Usage: /command-name <arguments>

\`\`\`bash
your-bash-command $ARGUMENTS || true
\`\`\`
```

### Adding New Skills

Create a directory in `~/.claude/skills/` with an `instructions.md` file:

```markdown
---
description: Brief description for automatic triggering
trigger: When the user asks to...
---

# Skill Name

Full instructions for Claude...
```

## Troubleshooting

### Hook not running

1. Verify the hook script is executable: `chmod +x ~/.claude/hooks/marimo-check.sh`
2. Check settings.json syntax is valid JSON
3. Ensure `uvx` is in your PATH

### marimo check failing

1. Run manually: `uvx marimo check your-notebook.py`
2. Check marimo is installed: `pip install marimo`
3. Verify the file is a valid marimo notebook
