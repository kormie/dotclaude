---
description: Create custom UI widgets for marimo notebooks using anywidget
trigger: When the user asks to create a custom widget, interactive component, or UI element for marimo
---

# AnyWidget Generator for marimo

You are creating a custom anywidget for use in marimo notebooks. Follow these guidelines:

## Widget Structure

An anywidget consists of three main parts:
1. **Python class** - Defines the widget's state and traitlets
2. **JavaScript module** (`_esm`)** - Handles rendering and interactivity
3. **CSS styles** (`_css`)** - Provides styling with light/dark mode support

## Implementation Guidelines

### Python Class
```python
import anywidget
import traitlets

class MyWidget(anywidget.AnyWidget):
    # Define state as traitlets for automatic syncing
    value = traitlets.Unicode("").tag(sync=True)
    count = traitlets.Int(0).tag(sync=True)

    # ESM JavaScript module for rendering
    _esm = """
    function render({ model, el }) {
        // Access state with model.get('value')
        // Update state with model.set('value', newValue)
        // model.save_changes() to sync back to Python

        // DOM manipulation
        el.innerHTML = '<div class="my-widget">...</div>';

        // Event handling
        el.querySelector('button').addEventListener('click', () => {
            model.set('count', model.get('count') + 1);
            model.save_changes();
        });

        // React to state changes
        model.on('change:value', () => {
            // Update UI when value changes
        });
    }
    export default { render };
    """

    # CSS styles with light/dark mode support
    _css = """
    .my-widget {
        padding: 1rem;
        border-radius: 8px;
        background: var(--color-bg, #fff);
        color: var(--color-text, #000);
    }

    @media (prefers-color-scheme: dark) {
        .my-widget {
            background: var(--color-bg-dark, #1a1a1a);
            color: var(--color-text-dark, #fff);
        }
    }
    """
```

### Using in marimo

Wrap the widget with `mo.ui.anywidget()` for full marimo integration:

```python
import marimo as mo

# Create widget instance
widget = MyWidget(value="initial")

# Wrap for marimo reactivity
mo_widget = mo.ui.anywidget(widget)

# Access value reactively
mo_widget.value
```

## Best Practices

1. **Use vanilla JavaScript** in `_esm` - avoid frameworks for simplicity
2. **Always support dark mode** in `_css` using CSS variables or media queries
3. **Keep state minimal** - only sync what's needed between Python and JS
4. **Use `model.save_changes()`** after setting values to sync back to Python
5. **Clean up event listeners** in the render function if needed
6. **Test with `uvx marimo edit`** to verify reactivity works correctly

## Common Patterns

### Debounced Input
```javascript
let timeout;
input.addEventListener('input', (e) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
        model.set('value', e.target.value);
        model.save_changes();
    }, 300);
});
```

### Canvas Drawing
```javascript
const canvas = document.createElement('canvas');
const ctx = canvas.getContext('2d');
// ... drawing logic
canvas.addEventListener('click', (e) => {
    const rect = canvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    model.set('click_pos', [x, y]);
    model.save_changes();
});
```

### External Libraries
```javascript
// Import from CDN in _esm
import * as d3 from "https://esm.sh/d3@7";
```
