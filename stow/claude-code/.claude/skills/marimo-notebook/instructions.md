---
description: Create and develop marimo reactive notebooks
trigger: When the user asks to create a marimo notebook, data analysis script, or reactive Python application
---

# marimo Notebook Development

You are creating or editing a marimo notebook. Follow these guidelines for best results.

## Notebook Structure

A marimo notebook is a Python file with reactive cells:

```python
import marimo

app = marimo.App()

@app.cell
def _():
    import marimo as mo
    return (mo,)

@app.cell
def _(mo):
    # Your code here
    return ()

if __name__ == "__main__":
    app.run()
```

## Key Principles

### 1. Reactivity
- Cells automatically re-run when their dependencies change
- Define variables in one cell, use them in another
- Return variables from cells to make them available to other cells

### 2. Cell Dependencies
```python
@app.cell
def _():
    x = 10
    return (x,)

@app.cell
def _(x):  # Depends on x from above
    y = x * 2
    return (y,)
```

### 3. UI Elements
```python
@app.cell
def _(mo):
    slider = mo.ui.slider(0, 100, value=50, label="Value")
    return (slider,)

@app.cell
def _(slider):
    # Reactively updates when slider changes
    result = slider.value ** 2
    mo.md(f"Result: {result}")
    return ()
```

## Common UI Components

```python
# Text input
text = mo.ui.text(placeholder="Enter text")

# Number input
number = mo.ui.number(start=0, stop=100, value=50)

# Dropdown
dropdown = mo.ui.dropdown(["Option A", "Option B", "Option C"])

# Checkbox
checkbox = mo.ui.checkbox(label="Enable feature")

# Button
button = mo.ui.button(label="Click me")

# File upload
file = mo.ui.file(kind="button")

# Table with selection
table = mo.ui.table(df, selection="multi")

# Tabs
tabs = mo.ui.tabs({
    "Tab 1": content1,
    "Tab 2": content2
})
```

## Data Visualization

### With Altair
```python
import altair as alt

chart = alt.Chart(df).mark_bar().encode(
    x="category:N",
    y="value:Q"
)
mo.ui.altair_chart(chart)
```

### With Plotly
```python
import plotly.express as px

fig = px.scatter(df, x="x", y="y", color="category")
mo.ui.plotly(fig)
```

## Best Practices

1. **One concept per cell** - Keep cells focused and small
2. **Return all variables** - Don't forget the return tuple
3. **Use mo.md() for text** - Rich markdown with LaTeX support
4. **Leverage mo.ui** - Interactive components are first-class
5. **Run linting** - Use `uvx marimo check --fix` to catch issues

## File Operations

```python
# Read uploaded file
@app.cell
def _(mo):
    file_input = mo.ui.file(kind="button", filetypes=[".csv", ".json"])
    return (file_input,)

@app.cell
def _(file_input):
    if file_input.contents():
        import pandas as pd
        import io
        df = pd.read_csv(io.BytesIO(file_input.contents()))
        return (df,)
    return ()
```

## Running Notebooks

- `uvx marimo edit notebook.py` - Interactive editing
- `uvx marimo run notebook.py` - Run as app
- `uvx marimo export notebook.py` - Export to HTML/Markdown
