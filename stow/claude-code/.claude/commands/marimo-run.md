# marimo-run

Run a marimo notebook as an application.

Usage: /marimo-run <notebook.py>

```bash
uvx marimo run $ARGUMENTS
```

This command runs a marimo notebook as a standalone application in the browser.
The notebook will be served with a read-only interface suitable for sharing.

## Examples

- `/marimo-run app.py` - Run a notebook as an app
- `/marimo-run --port 8080 dashboard.py` - Run on a specific port
