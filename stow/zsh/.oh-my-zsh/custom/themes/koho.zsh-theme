# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                           KOHO Oh-My-Zsh Theme                            ║
# ║                   Simple, clean prompt with KOHO branding                 ║
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
    echo ""
}

# Display banner on theme load (only for interactive shells)
[[ -o interactive ]] && _koho_print_banner

# ─────────────────────────────────────────────────────────────────────────────
# Git Configuration
# ─────────────────────────────────────────────────────────────────────────────

# Use 256-color approximations for better compatibility in prompt escapes
# Lime ~= 190, Purple ~= 97, Green ~= 29
ZSH_THEME_GIT_PROMPT_PREFIX="%F{97}git:(%F{190}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{97})%f "
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{190}✗%f"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{29}✓%f"

# ─────────────────────────────────────────────────────────────────────────────
# Main Prompt
# ─────────────────────────────────────────────────────────────────────────────

# Format: [status indicator] [directory] [git info] $
# Using 256-color codes for better compatibility
# 190 = lime (success), 196 = red (failure), 97 = purple
# Using ● (bullet) for consistent single-character width across all terminals

PROMPT='%(?.%F{190}●%f.%F{196}●%f) %F{190}%1~%f $(git_prompt_info)%F{190}$%f '

# Right prompt: truncated full path in purple
ZLE_RPROMPT_INDENT=0
RPROMPT='%F{97}%30<..<%~%f'

# Continuation prompt
PS2="%F{97}   ...%f "
