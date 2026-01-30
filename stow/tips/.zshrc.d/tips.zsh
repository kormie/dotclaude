#!/usr/bin/env zsh
# Terminal Tips System - Shell Integration
# Provides context-triggered coaching and on-demand tip commands

# ============================================================================
# Configuration
# ============================================================================

# Tips directory location
export TIPS_DIR="${TIPS_DIR:-$HOME/.config/dotfiles/tips/tips-data}"

# Control flags (set in ~/.zshrc.local to customize)
# TIPS_STARTUP=0    # Disable startup tips
# TIPS_COACHING=0   # Disable context-triggered reminders
# TIPS_BLOCK_COUNT=5  # Change block threshold (default: 3)

TIPS_BLOCK_COUNT="${TIPS_BLOCK_COUNT:-3}"

# ============================================================================
# Load Core Library
# ============================================================================

TIPS_LIB="${TIPS_LIB:-$HOME/.config/dotfiles/tips/tips.sh}"
[[ -f "$TIPS_LIB" ]] && source "$TIPS_LIB"

# ============================================================================
# Context-Triggered Coaching
# ============================================================================

# Associative array to track command usage per session
typeset -gA _tips_miss_count

# Pending reminder to show after command completes
typeset -g _tips_pending_reminder=""

# Patterns to watch for (loaded from tips files)
# Format: pattern -> "alias|description"
typeset -gA _tips_patterns

# Load patterns from tips files
_tips_load_patterns() {
    _tips_patterns=()
    [[ -d "$TIPS_DIR" ]] || return

    local file alias_name old_pattern description example
    for file in "$TIPS_DIR"/*.tips(N); do
        while IFS='|' read -r alias_name old_pattern description example; do
            [[ -z "$old_pattern" || "$old_pattern" == \#* ]] && continue
            # Only track patterns that look like commands (not key combos)
            # Allow patterns starting with letter or dot (. is alias for source)
            [[ "$old_pattern" =~ ^[a-zA-Z.\$] ]] || continue
            _tips_patterns[$old_pattern]="${alias_name}|${description}"
        done < "$file"
    done
}

# Initialize patterns
_tips_load_patterns

# ============================================================================
# True Command Blocking via accept-line Widget
# ============================================================================

# Check if command should be blocked or reminded
# Returns: 0 = allow, 1 = block, 2 = remind then allow
_tips_check_command() {
    local cmd="$1"

    # Skip if coaching disabled
    [[ "${TIPS_COACHING:-1}" == "0" ]] && return 0

    # Skip empty commands
    [[ -z "$cmd" ]] && return 0

    # Skip if command starts with 'command ' (intentional bypass)
    [[ "$cmd" == "command "* ]] && return 0

    # Skip pipeline commands
    [[ "$cmd" == *\|* ]] && return 0

    # Check against patterns
    local pattern alias_info alias_name description
    for pattern in "${(@k)_tips_patterns}"; do
        # Match at start of command
        if [[ "$cmd" == ${pattern}* ]]; then
            alias_info="${_tips_patterns[$pattern]}"
            IFS='|' read -r alias_name description <<< "$alias_info"

            # Increment miss count
            (( _tips_miss_count[$pattern]++ ))
            local count=${_tips_miss_count[$pattern]}

            if (( count >= TIPS_BLOCK_COUNT )); then
                # Block - store info for message
                _tips_block_pattern="$pattern"
                _tips_block_alias="$alias_name"
                _tips_block_count="$count"
                return 1
            else
                # Remind after command completes
                _tips_pending_reminder="${alias_name}|${count}|${pattern}|${description}"
                return 2
            fi
        fi
    done

    return 0
}

# Custom accept-line widget that checks for blocks BEFORE executing
_tips_accept_line() {
    local cmd="$BUFFER"

    _tips_check_command "$cmd"
    local result=$?

    if (( result == 1 )); then
        # BLOCKED - show message and clear the line
        echo ""
        echo "${_TIPS_LPURPLE}Blocked:${_TIPS_RESET} You've used '${_TIPS_DIM}${_tips_block_pattern}${_TIPS_RESET}' ${_tips_block_count} times this session"
        echo "   Use '${_TIPS_LIME}${_tips_block_alias}${_TIPS_RESET}' instead, or prefix with 'command' to bypass"
        echo ""

        # Clear the buffer and redisplay prompt
        BUFFER=""
        zle redisplay
        return 0
    fi

    # Allow the command (result 0 or 2)
    zle .accept-line
}

# Register the custom widget (only for interactive shells)
if [[ -o interactive ]]; then
    zle -N accept-line _tips_accept_line
fi

# ============================================================================
# Reminder Display (after command completes)
# ============================================================================

# Precmd hook - runs before prompt, after command completes
_tips_precmd_hook() {
    # Show pending reminder if any
    if [[ -n "$_tips_pending_reminder" ]]; then
        local alias_name count pattern description
        IFS='|' read -r alias_name count pattern description <<< "$_tips_pending_reminder"

        echo "${_TIPS_DIM}Tip (${count}/${TIPS_BLOCK_COUNT}):${_TIPS_RESET} Use '${_TIPS_LIME}${alias_name}${_TIPS_RESET}' instead of '${_TIPS_DIM}${pattern}${_TIPS_RESET}'"

        _tips_pending_reminder=""
    fi
}

# Register precmd hook
if [[ -o interactive ]]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _tips_precmd_hook
fi

# ============================================================================
# User Commands
# ============================================================================

# Show a random tip
tip() {
    tips_show_startup
}

# Show tips by category or list categories
tips() {
    tips_show_category "$1"
}

# Reload tips patterns (useful after editing tip files)
tips-reload() {
    _tips_load_patterns
    _tips_miss_count=()
    echo "${_TIPS_LIME}Tips reloaded.${_TIPS_RESET} ${#_tips_patterns[@]} patterns loaded."
}

# Show current session stats
tips-stats() {
    echo "\n${_TIPS_LIME}Session Coaching Stats${_TIPS_RESET}"
    echo "Block threshold: ${TIPS_BLOCK_COUNT}"
    echo ""

    if [[ ${#_tips_miss_count[@]} -eq 0 ]]; then
        echo "${_TIPS_DIM}No coaching triggers this session.${_TIPS_RESET}"
    else
        local pattern count
        for pattern in "${(@k)_tips_miss_count}"; do
            count=${_tips_miss_count[$pattern]}
            local alias_info="${_tips_patterns[$pattern]}"
            local alias_name="${alias_info%%|*}"

            if (( count >= TIPS_BLOCK_COUNT )); then
                echo "  ${_TIPS_LPURPLE}${pattern}${_TIPS_RESET} → ${alias_name}: ${count}x (blocked)"
            else
                echo "  ${_TIPS_DIM}${pattern}${_TIPS_RESET} → ${alias_name}: ${count}/${TIPS_BLOCK_COUNT}"
            fi
        done
    fi
    echo ""
}

# Reset coaching counters
tips-reset() {
    _tips_miss_count=()
    echo "${_TIPS_LIME}Coaching counters reset.${_TIPS_RESET}"
}
