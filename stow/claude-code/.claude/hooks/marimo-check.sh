#!/bin/bash
# marimo-check.sh - PostToolUse hook for automatic marimo notebook linting
#
# This hook is triggered after Edit or Write operations on files.
# It checks if the modified file is a marimo notebook and runs linting.
#
# Usage: Called by Claude Code via PostToolUse hook configuration
# Arguments: $1 = file path of the modified file
#
# Exit codes:
#   0 - Success (file is not a marimo notebook or lint passed)
#   2 - Lint failed (blocks the change and displays errors)

set -euo pipefail

FILE="${1:-}"

# Exit if no file provided
if [[ -z "$FILE" ]]; then
    exit 0
fi

# Exit if file doesn't exist
if [[ ! -f "$FILE" ]]; then
    exit 0
fi

# Exit if not a Python file
if [[ ! "$FILE" =~ \.py$ ]]; then
    exit 0
fi

# Check if file contains marimo notebook markers
if grep -q "import marimo" "$FILE" && grep -q "@app.cell" "$FILE"; then
    echo "Detected marimo notebook: $FILE"
    echo "Running marimo check..."

    # Run marimo check
    if ! uvx marimo check "$FILE" 2>&1; then
        echo ""
        echo "marimo check failed. Please fix the issues above."
        exit 2
    fi

    echo "marimo check passed."
fi

exit 0
