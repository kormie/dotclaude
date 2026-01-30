#!/usr/bin/env zsh
# Terminal Tips System - Core Library
# Provides tip display functions with KOHO branding

# ============================================================================
# Configuration
# ============================================================================

TIPS_DIR="${TIPS_DIR:-$HOME/.config/dotfiles/tips/tips-data}"
TIPS_BOX_WIDTH="${TIPS_BOX_WIDTH:-60}"

# KOHO Brand Colors (matching koho.zsh-theme)
_TIPS_LIME=$'\e[38;2;209;243;0m'
_TIPS_LIME_TINT=$'\e[38;2;232;250;128m'
_TIPS_LPURPLE=$'\e[38;2;107;77;158m'
_TIPS_GREEN=$'\e[38;2;18;107;78m'
_TIPS_CYAN=$'\e[38;2;139;233;253m'
_TIPS_RESET=$'\e[0m'
_TIPS_BOLD=$'\e[1m'
_TIPS_DIM=$'\e[2m'

# ============================================================================
# Helper Functions
# ============================================================================

# Get list of available categories
_tips_categories() {
    local tips_dir="${1:-$TIPS_DIR}"
    [[ -d "$tips_dir" ]] || return 1
    ls "$tips_dir"/*.tips 2>/dev/null | xargs -n1 basename 2>/dev/null | sed 's/\.tips$//'
}

# Get random tip from all categories
# Returns: category|alias|old|description|example
_tips_get_random() {
    local tips_dir="${1:-$TIPS_DIR}"
    [[ -d "$tips_dir" ]] || return 1

    # Get all tip files
    local files=("$tips_dir"/*.tips(N))
    [[ ${#files[@]} -eq 0 ]] && return 1

    # Pick random file
    local file="${files[RANDOM % ${#files[@]} + 1]}"
    local category=$(basename "$file" .tips)

    # Pick random non-comment, non-empty line
    local line=$(grep -v '^#' "$file" | grep -v '^$' | shuf -n1 2>/dev/null || \
                 grep -v '^#' "$file" | grep -v '^$' | awk 'BEGIN{srand()} {lines[NR]=$0} END{print lines[int(rand()*NR)+1]}')

    [[ -z "$line" ]] && return 1
    echo "${category}|${line}"
}

# Get all tips from a category
_tips_get_category() {
    local category="$1"
    local tips_dir="${2:-$TIPS_DIR}"
    local file="$tips_dir/${category}.tips"

    [[ -f "$file" ]] || return 1
    grep -v '^#' "$file" | grep -v '^$'
}

# ============================================================================
# Display Functions
# ============================================================================

# Draw a horizontal line with optional label
_tips_draw_line() {
    local label="$1"
    local width="${2:-$TIPS_BOX_WIDTH}"
    local char="${3:-─}"
    local line=""

    if [[ -n "$label" ]]; then
        local label_len=${#label}
        local remaining=$((width - label_len - 4))  # 4 = corners + spacing
        local left_pad=1
        local right_pad=$((remaining - left_pad))

        line="${char}[${_TIPS_LIME}${label}${_TIPS_RESET}]"
        for ((i=0; i<right_pad; i++)); do line+="$char"; done
    else
        for ((i=0; i<width-2; i++)); do line+="$char"; done
    fi

    echo "$line"
}

# Pad string to width
_tips_pad() {
    local str="$1"
    local width="${2:-$TIPS_BOX_WIDTH}"
    local visible_len=${#${(S)str//\[*m/}}  # Strip ANSI codes for length calc
    local padding=$((width - visible_len - 4))  # 4 = "│ " + " │"

    printf "%s%*s" "$str" "$padding" ""
}

# Display a tip in a styled box
# Args: category alias description example
tips_display_box() {
    local category="$1"
    local alias_name="$2"
    local description="$3"
    local example="$4"
    local width="${TIPS_BOX_WIDTH:-60}"

    # Capitalize category
    local cap_category="${(C)category}"

    # Build the box
    echo ""
    echo "${_TIPS_DIM}┌─${_TIPS_RESET}[${_TIPS_LIME}${cap_category}${_TIPS_RESET}]${_TIPS_DIM}$(_tips_draw_line "" $((width - ${#cap_category} - 4)) "─")┐${_TIPS_RESET}"

    # Main tip line
    local tip_line="${_TIPS_BOLD}${_TIPS_LIME}${alias_name}${_TIPS_RESET} → ${description}"
    echo "${_TIPS_DIM}│${_TIPS_RESET} $(_tips_pad "$tip_line" $width)${_TIPS_DIM}│${_TIPS_RESET}"

    # Example line
    if [[ -n "$example" ]]; then
        local example_line="Try: ${_TIPS_CYAN}${example}${_TIPS_RESET}"
        echo "${_TIPS_DIM}│${_TIPS_RESET} $(_tips_pad "$example_line" $width)${_TIPS_DIM}│${_TIPS_RESET}"
    fi

    echo "${_TIPS_DIM}└$(_tips_draw_line "" $((width - 1)) "─")┘${_TIPS_RESET}"
    echo ""
}

# Main startup tip display function
# Called from KOHO theme banner
tips_show_startup() {
    # Check if disabled
    [[ "${TIPS_STARTUP:-1}" == "0" ]] && return 0

    # Check for tips directory
    [[ -d "$TIPS_DIR" ]] || return 0

    # Get random tip
    local tip_data=$(_tips_get_random)
    [[ -z "$tip_data" ]] && return 0

    # Parse tip data: category|alias|old|description|example
    local category alias_name old_pattern description example
    IFS='|' read -r category alias_name old_pattern description example <<< "$tip_data"

    # Display the tip
    tips_display_box "$category" "$alias_name" "$description" "$example"
}

# Display all tips in a category
tips_show_category() {
    local category="$1"
    local tips_dir="${2:-$TIPS_DIR}"

    if [[ -z "$category" ]]; then
        echo "\n${_TIPS_LIME}Available categories:${_TIPS_RESET} $(_tips_categories | tr '\n' ' ')"
        echo "Usage: ${_TIPS_CYAN}tips <category>${_TIPS_RESET}  or  ${_TIPS_CYAN}tip${_TIPS_RESET} (random)\n"
        return 0
    fi

    local file="$tips_dir/${category}.tips"
    if [[ ! -f "$file" ]]; then
        echo "${_TIPS_LPURPLE}Unknown category:${_TIPS_RESET} $category"
        echo "Available: $(_tips_categories | tr '\n' ' ')"
        return 1
    fi

    local cap_category="${(C)category}"
    echo "\n${_TIPS_LIME}[${cap_category} Tips]${_TIPS_RESET}"

    while IFS='|' read -r alias_name old_pattern description example; do
        [[ -z "$alias_name" ]] && continue
        printf "  ${_TIPS_BOLD}${_TIPS_LIME}%-12s${_TIPS_RESET} → %s\n" "$alias_name" "$description"
    done < <(grep -v '^#' "$file" | grep -v '^$')

    echo ""
}
