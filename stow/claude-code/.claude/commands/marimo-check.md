# marimo-check

Run marimo notebook linting with automatic fixes.

Usage: /marimo-check <notebook.py>

```bash
uvx marimo check --fix $ARGUMENTS || true
```

This command runs the marimo linter on the specified notebook file(s) with the `--fix` flag
to automatically resolve common issues. The `|| true` ensures non-zero exit codes don't
break the command execution, allowing Claude to see and respond to any remaining issues.

## Examples

- `/marimo-check notebook.py` - Check and fix a single notebook
- `/marimo-check src/*.py` - Check and fix all Python files in src/
- `/marimo-check .` - Check and fix all marimo notebooks in current directory
