# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                           KOHO Oh-My-Zsh Theme                            ║
# ║     Combining: dotclaude responsiveness + clean simplicity + KOHO brand  ║
# ║                   Optimized for charcoal grey backgrounds                 ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
#
# Features:
#   - Exit code emoji indicators (✅/❌) from clean theme
#   - Responsive layout from dotclaude (adapts to terminal width)
#   - Battery indicator from dotclaude
#   - KOHO brand colors throughout
#   - Banner displayed on terminal startup
#
# KOHO Brand Colors (2025):
#   - Electric Lime: #D1F300 - Primary accent (use sparingly!)
#   - Haiti (deep purple): #1D123C - Background/dark elements
#   - Scarlet Gum: #36186B - Secondary purple
#   - Light Purple: #6B4D9E - Tertiary/muted elements
#   - Jewel Green: #126B4E - Success/positive states
#   - Early Dawn: #FFF9E8 - Light cream (for high contrast on dark)
#   - Lime Tint: #E8FA80 - Softer lime
#   - Purple Tint: #E8E6F0 - Light purple (muted text)
#
# Installation:
#   1. Copy this file to ~/.oh-my-zsh/themes/koho.zsh-theme
#   2. Set ZSH_THEME="koho" in your ~/.zshrc
#   3. Restart your terminal or run: source ~/.zshrc
#
# Recommended terminal settings:
#   - Background: #2D2D2D (charcoal grey) or #1D123C (Haiti)
#   - Cursor: #D1F300 (Electric Lime)
#   - Font: JetBrains Mono, Fira Code, or any Nerd Font

# ─────────────────────────────────────────────────────────────────────────────
# Shell Options
# ─────────────────────────────────────────────────────────────────────────────

unsetopt HIST_VERIFY
setopt PROMPT_SUBST

# ─────────────────────────────────────────────────────────────────────────────
# KOHO Brand Colors
# ─────────────────────────────────────────────────────────────────────────────

# True color (24-bit) - works in Ghostty, Alacritty, Windows Terminal, etc.
KOHO_LIME='%F{#D1F300}'
KOHO_LIME_TINT='%F{#E8FA80}'
KOHO_LPURPLE='%F{#6B4D9E}'
KOHO_SCARLET='%F{#36186B}'
KOHO_GREEN='%F{#126B4E}'
KOHO_WHITE='%F{#FFFFFF}'
KOHO_CREAM='%F{#FFF9E8}'
KOHO_PURPLE_TINT='%F{#E8E6F0}'

RESET='%f%b'
RESET_ALL='%{$reset_color%}'

# ─────────────────────────────────────────────────────────────────────────────
# KOHO Banner (displayed on terminal startup)
# ─────────────────────────────────────────────────────────────────────────────

koho_banner() {
  echo ""
  echo "%F{#D1F300}██╗  ██╗ ██████╗ ██╗  ██╗ ██████╗ %f"
  echo "%F{#D1F300}██║ ██╔╝██╔═══██╗██║  ██║██╔═══██╗%f"
  echo "%F{#D1F300}█████╔╝ ██║   ██║███████║██║   ██║%f"
  echo "%F{#6B4D9E}██╔═██╗ ██║   ██║██╔══██║██║   ██║%f"
  echo "%F{#6B4D9E}██║  ██╗╚██████╔╝██║  ██║╚██████╔╝%f"
  echo "%F{#6B4D9E}╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ %f"
  echo ""
  echo "%F{#E8FA80}    MONEY DONE DIFFERENTLY™%f"
  echo ""
}

# Print banner using print -P for proper prompt expansion
_koho_print_banner() {
  print -P ""
  print -P "%F{#D1F300}██╗  ██╗ ██████╗ ██╗  ██╗ ██████╗ %f"
  print -P "%F{#D1F300}██║ ██╔╝██╔═══██╗██║  ██║██╔═══██╗%f"
  print -P "%F{#D1F300}█████╔╝ ██║   ██║███████║██║   ██║%f"
  print -P "%F{#6B4D9E}██╔═██╗ ██║   ██║██╔══██║██║   ██║%f"
  print -P "%F{#6B4D9E}██║  ██╗╚██████╔╝██║  ██║╚██████╔╝%f"
  print -P "%F{#6B4D9E}╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ %f"
  print -P ""
  print -P "%F{#E8FA80}    3, 2, 1… Let's get it!%f"
  print -P ""
}

# Display banner on theme load (new terminal startup)
_koho_print_banner

# ─────────────────────────────────────────────────────────────────────────────
# Emoji Definitions
# ─────────────────────────────────────────────────────────────────────────────

# Battery emoji (🔋)
battery=$(echo -n "\xF0\x9F\x94\x8B")

# Status emojis
# ✨ for success (sparkles - chef's kiss)
# 🫠 for failure (melting face - everything's fine)
KOHO_SUCCESS_EMOJI="✨"
KOHO_FAIL_EMOJI="🫠"

# ─────────────────────────────────────────────────────────────────────────────
# Git Configuration (vcs_info for clean-style integration)
# ─────────────────────────────────────────────────────────────────────────────

autoload -Uz vcs_info

# Configure vcs_info for git
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

# Oh-My-Zsh git prompt settings (used when git_prompt_info is available)
ZSH_THEME_GIT_PROMPT_PREFIX="${KOHO_LPURPLE}git:(${KOHO_LIME_TINT}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${KOHO_LPURPLE})${RESET_ALL}"
ZSH_THEME_GIT_PROMPT_DIRTY=" ${KOHO_LIME}✗${RESET_ALL}"
ZSH_THEME_GIT_PROMPT_CLEAN=" ${KOHO_GREEN}✓${RESET_ALL}"

# ─────────────────────────────────────────────────────────────────────────────
# Battery Function (KOHO styled)
# ─────────────────────────────────────────────────────────────────────────────

batteryPack() {
  # Check if battery_pct function exists (from oh-my-zsh battery plugin)
  if type battery_pct &>/dev/null; then
    local pct=$(battery_pct 2>/dev/null)
    if [[ -n "$pct" ]]; then
      echo "${KOHO_LPURPLE}$battery ${pct}%%${RESET_ALL}"
      return
    fi
  fi
  # Fallback: try pmset on macOS
  if command -v pmset &>/dev/null; then
    local pct=$(pmset -g batt 2>/dev/null | grep -Eo '[0-9]+%' | head -1)
    if [[ -n "$pct" ]]; then
      echo "${KOHO_LPURPLE}$battery ${pct}${RESET_ALL}"
      return
    fi
  fi
  # No battery info available
  echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Responsive Layout Functions (from dotclaude)
# ─────────────────────────────────────────────────────────────────────────────

isSmallerRPromptReduced() {
  local right=$(pwd)
  right=${right#"$HOME/"}
  right=${right#"$HOME"}
  local rightCount=${#right}
  local fraction=$(echo "scale=3 ; $rightCount/$COLUMNS" | bc 2>/dev/null || echo "0")
  if (( $(echo "$fraction > 0.4" | bc -l 2>/dev/null || echo "0") )); then
    return 0
  fi
  return 1
}

isReduced() {
  [[ "$COLUMNS" -lt 54 ]]
}

# ─────────────────────────────────────────────────────────────────────────────
# Git Status Helper
# ─────────────────────────────────────────────────────────────────────────────

_koho_git_info() {
  # Prefer oh-my-zsh git_prompt_info if available
  if type git_prompt_info &>/dev/null; then
    echo "$(git_prompt_info)"
  elif [[ -n "${vcs_info_msg_0_}" ]]; then
    # Fallback to vcs_info
    local dirty=""
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
      dirty=" ${KOHO_LIME}✗${RESET_ALL}"
    else
      dirty=" ${KOHO_GREEN}✓${RESET_ALL}"
    fi
    echo "${KOHO_LPURPLE}git:(${KOHO_LIME_TINT}${vcs_info_msg_0_}${KOHO_LPURPLE})${dirty}${RESET_ALL}"
  fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Prompt Section Functions
# ─────────────────────────────────────────────────────────────────────────────

# Status emoji based on last exit code
_koho_status_emoji() {
  if [[ $_KOHO_EXIT_CODE -eq 0 ]]; then
    echo "$KOHO_SUCCESS_EMOJI"
  else
    echo "$KOHO_FAIL_EMOJI"
  fi
}

# Left side of prompt
_koho_left() {
  if isReduced; then
    # Compact: status emoji + battery
    echo "$(_koho_status_emoji) $(batteryPack)"
  else
    # Full: status emoji
    echo "$(_koho_status_emoji)"
  fi
}

# Git section (hidden when reduced)
_koho_git_section() {
  if isReduced; then
    echo ""
  else
    local git_info="$(_koho_git_info)"
    if [[ -n "$git_info" ]]; then
      echo " $git_info"
    fi
  fi
}

# Right side of prompt
_koho_right() {
  if isSmallerRPromptReduced; then
    if isReduced; then
      # Very compact: just git info
      echo "$(_koho_git_info)"
    else
      # Medium: just battery
      echo "$(batteryPack)"
    fi
  else
    # Full: path + battery
    local batt="$(batteryPack)"
    if [[ -n "$batt" ]]; then
      echo "${KOHO_LIME}%~${RESET_ALL} $batt"
    else
      echo "${KOHO_LIME}%~${RESET_ALL}"
    fi
  fi
}

# Cursor/input indicator
_koho_cursor() {
  if isReduced; then
    echo "${KOHO_LIME}:${RESET_ALL} "
  else
    echo " ${KOHO_LIME}\$${RESET_ALL} "
  fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Precmd Hook - runs before each prompt
# ─────────────────────────────────────────────────────────────────────────────

_koho_precmd() {
  # Capture exit code FIRST before anything else
  _KOHO_EXIT_CODE=$?

  # Update vcs_info
  vcs_info
}

# Add to precmd hooks
autoload -Uz add-zsh-hook
add-zsh-hook precmd _koho_precmd

# ─────────────────────────────────────────────────────────────────────────────
# Main Prompt
# ─────────────────────────────────────────────────────────────────────────────

# Format: [status emoji] [directory] [git info] $
# Clean and readable, with KOHO branding

PROMPT='$(_koho_left) ${KOHO_LIME}%.${RESET_ALL}$(_koho_git_section)$(_koho_cursor)'

# Right prompt: full path + battery (responsive)
RPROMPT='$(_koho_right)'

# ─────────────────────────────────────────────────────────────────────────────
# PS2 - Continuation prompt
# ─────────────────────────────────────────────────────────────────────────────

PS2="${KOHO_LPURPLE}   ...${RESET_ALL} "
