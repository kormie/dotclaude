# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                           KOHO Oh-My-Zsh Theme                            ║
# ║                   Simple, clean prompt with KOHO branding                 ║
# ║              Works with or without Nerd Fonts installed                   ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
#
# KOHO Brand Colors (2025):
#   - Electric Lime: #D1F300
#   - Light Purple: #6B4D9E
#   - Jewel Green: #126B4E
#   - Lime Tint: #E8FA80

# ─────────────────────────────────────────────────────────────────────────────
# Shell Options
# ─────────────────────────────────────────────────────────────────────────────

setopt PROMPT_SUBST

# ─────────────────────────────────────────────────────────────────────────────
# Nerd Font Detection
# ─────────────────────────────────────────────────────────────────────────────

# Check if Nerd Fonts are likely available
# We check for common Nerd Font files in the user's font directory
_koho_has_nerd_font() {
    # Check environment variable override first
    [[ "$KOHO_NERD_FONTS" == "1" ]] && return 0
    [[ "$KOHO_NERD_FONTS" == "0" ]] && return 1

    # Check for Nerd Font files (cached result)
    if [[ -z "$_KOHO_NERD_FONT_CACHED" ]]; then
        if [[ -d "$HOME/Library/Fonts" ]] && \
           ls "$HOME/Library/Fonts"/*Nerd* &>/dev/null; then
            _KOHO_NERD_FONT_CACHED=1
        else
            _KOHO_NERD_FONT_CACHED=0
        fi
    fi
    [[ "$_KOHO_NERD_FONT_CACHED" == "1" ]]
}

# ─────────────────────────────────────────────────────────────────────────────
# Icon Definitions (Nerd Font vs Fallback)
# ─────────────────────────────────────────────────────────────────────────────

if _koho_has_nerd_font; then
    # Nerd Font icons (using Unicode escape sequences)
    _KOHO_ICON_GIT=$'\ue0a0 '     # nf-pl-branch (powerline)
    _KOHO_ICON_FOLDER=$'\uf07c'   # nf-fa-folder_open
    _KOHO_ICON_OK=$'\uf00c'       # nf-fa-check
    _KOHO_ICON_FAIL=$'\uf00d'     # nf-fa-times
    _KOHO_ICON_DIRTY=$'\uf00d'    # nf-fa-times
    _KOHO_ICON_CLEAN=$'\uf00c'    # nf-fa-check
    _KOHO_ICON_PROMPT=$'\uf054'   # nf-fa-chevron_right
else
    # Unicode/ASCII fallbacks
    _KOHO_ICON_GIT="git:"
    _KOHO_ICON_FOLDER=""
    _KOHO_ICON_OK="●"
    _KOHO_ICON_FAIL="●"
    _KOHO_ICON_DIRTY="✗"
    _KOHO_ICON_CLEAN="✓"
    _KOHO_ICON_PROMPT="$"
fi

# ─────────────────────────────────────────────────────────────────────────────
# ANSI Color Codes for functions (true color / 24-bit)
# ─────────────────────────────────────────────────────────────────────────────

# These are raw ANSI escapes for use in functions with echo/print
_KOHO_LIME=$'\e[38;2;209;243;0m'
_KOHO_LIME_TINT=$'\e[38;2;232;250;128m'
_KOHO_LPURPLE=$'\e[38;2;107;77;158m'
_KOHO_GREEN=$'\e[38;2;18;107;78m'
_KOHO_RESET=$'\e[0m'

# ─────────────────────────────────────────────────────────────────────────────
# KOHO Banner (displayed on terminal startup)
# ─────────────────────────────────────────────────────────────────────────────

_koho_print_banner() {
    echo ""
    echo "${_KOHO_LIME}██╗  ██╗ ██████╗ ██╗  ██╗ ██████╗ ${_KOHO_RESET}"
    echo "${_KOHO_LIME}██║ ██╔╝██╔═══██╗██║  ██║██╔═══██╗${_KOHO_RESET}"
    echo "${_KOHO_LIME}█████╔╝ ██║   ██║███████║██║   ██║${_KOHO_RESET}"
    echo "${_KOHO_LPURPLE}██╔═██╗ ██║   ██║██╔══██║██║   ██║${_KOHO_RESET}"
    echo "${_KOHO_LPURPLE}██║  ██╗╚██████╔╝██║  ██║╚██████╔╝${_KOHO_RESET}"
    echo "${_KOHO_LPURPLE}╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ${_KOHO_RESET}"
    echo ""
    echo "${_KOHO_LIME_TINT}    3, 2, 1… Let's get it!${_KOHO_RESET}"

    # Show startup tip if tips system is loaded
    if type tips_show_startup &>/dev/null; then
        tips_show_startup
    else
        echo ""
    fi
}

# Display banner on theme load (only for interactive shells)
[[ -o interactive ]] && _koho_print_banner

# ─────────────────────────────────────────────────────────────────────────────
# Git Configuration
# ─────────────────────────────────────────────────────────────────────────────

# Use 256-color approximations for better compatibility in prompt escapes
# Lime ~= 190, Purple ~= 97, Green ~= 29
ZSH_THEME_GIT_PROMPT_PREFIX="%F{97}${_KOHO_ICON_GIT}(%F{190}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{97})%f "
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{190}${_KOHO_ICON_DIRTY}%f"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{29}${_KOHO_ICON_CLEAN}%f"

# ─────────────────────────────────────────────────────────────────────────────
# Main Prompt
# ─────────────────────────────────────────────────────────────────────────────

# Format: [status indicator] [directory] [git info] $
# Using 256-color codes for better compatibility
# 190 = lime (success), 97 = purple (failure/secondary)

PROMPT='%(?.%F{190}${_KOHO_ICON_OK}%f.%F{97}${_KOHO_ICON_FAIL}%f) %F{190}%1~%f $(git_prompt_info)%F{190}${_KOHO_ICON_PROMPT}%f '

# Right prompt: truncated full path in purple
ZLE_RPROMPT_INDENT=0
RPROMPT='%F{97}%30<..<%~%f'

# Continuation prompt
PS2="%F{97}   ...%f "

# ─────────────────────────────────────────────────────────────────────────────
# Manual Override
# ─────────────────────────────────────────────────────────────────────────────
# To force Nerd Fonts on/off, add to your ~/.zshrc BEFORE sourcing oh-my-zsh:
#   export KOHO_NERD_FONTS=1  # Force Nerd Font icons
#   export KOHO_NERD_FONTS=0  # Force fallback icons
