# marimo-convert

Convert Jupyter notebooks to marimo format.

Usage: /marimo-convert <notebook.ipynb>

```bash
uvx marimo convert $ARGUMENTS
```

This command converts Jupyter notebooks (.ipynb) to marimo notebook format (.py).
The converted notebook will use marimo's reactive cell-based structure.

## Examples

- `/marimo-convert analysis.ipynb` - Convert a single Jupyter notebook
- `/marimo-convert notebooks/*.ipynb` - Convert all Jupyter notebooks in a directory
