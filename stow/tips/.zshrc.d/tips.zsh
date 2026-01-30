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
            [[ "$old_pattern" =~ ^[a-zA-Z.] ]] || continue
            _tips_patterns[$old_pattern]="${alias_name}|${description}"
        done < "$file"
    done
}

# Initialize patterns
_tips_load_patterns

# Preexec hook - runs before each command
_tips_preexec_hook() {
    # Skip if coaching disabled
    [[ "${TIPS_COACHING:-1}" == "0" ]] && return 0

    local cmd="$1"
    _tips_pending_reminder=""

    # Skip if command uses _original suffix (intentional bypass)
    [[ "$cmd" == *_original* ]] && return 0

    # Skip pipeline commands (contains |)
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
                # Block the command
                echo ""
                echo "${_TIPS_LPURPLE}Blocked:${_TIPS_RESET} You've used '${_TIPS_DIM}${pattern}${_TIPS_RESET}' ${count} times this session"
                echo "   Use '${_TIPS_LIME}${alias_name}${_TIPS_RESET}' instead, or prefix with 'command' to bypass"
                echo ""

                # Return non-zero to signal block (though zsh preexec can't actually block)
                # We'll use a different mechanism - store block state
                _tips_blocked_cmd="$cmd"
                _tips_blocked_alias="$alias_name"
                return 1
            else
                # Queue reminder for after command completes
                _tips_pending_reminder="${alias_name}|${count}|${pattern}|${description}"
            fi
            break
        fi
    done

    return 0
}

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

# Register hooks (only for interactive shells)
if [[ -o interactive ]]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook preexec _tips_preexec_hook
    add-zsh-hook precmd _tips_precmd_hook
fi

# ============================================================================
# Command Wrapping for Blocking
# ============================================================================

# Since preexec can't actually block commands, we override common commands
# to check the block state. This is optional but provides true blocking.

# Helper to check if command should be blocked
_tips_check_block() {
    local cmd="$1"
    local pattern alias_info alias_name description count

    [[ "${TIPS_COACHING:-1}" == "0" ]] && return 0

    for pattern in "${(@k)_tips_patterns}"; do
        if [[ "$cmd" == ${pattern}* ]]; then
            (( _tips_miss_count[$pattern]++ ))
            count=${_tips_miss_count[$pattern]}

            if (( count >= TIPS_BLOCK_COUNT )); then
                alias_info="${_tips_patterns[$pattern]}"
                IFS='|' read -r alias_name description <<< "$alias_info"

                echo ""
                echo "${_TIPS_LPURPLE}Blocked:${_TIPS_RESET} You've used '${_TIPS_DIM}${pattern}${_TIPS_RESET}' ${count} times this session"
                echo "   Use '${_TIPS_LIME}${alias_name}${_TIPS_RESET}' instead, or prefix with 'command' to bypass"
                echo ""
                return 1
            elif (( count > 0 )); then
                # Show reminder after command runs (via precmd)
                _tips_pending_reminder="${alias_name}|${count}|${pattern}|${description}"
            fi
            break
        fi
    done
    return 0
}

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
