# Enhanced .zshrc with Oh-My-Zsh integration
# This configuration preserves existing user settings while adding modern features

# Path to Oh-My-Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration - KOHO branded theme with responsive layout
# Features: exit code emojis, battery indicator, git status, KOHO brand colors
ZSH_THEME="koho"

# Plugins (start with essential set, can expand based on user preferences)
plugins=(
  git
  battery
  brew
  docker
  golang
  python
  ruby
  asdf
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# ============================================================================
# PRESERVE ORIGINAL USER SETTINGS
# ============================================================================

# History settings (preserve user's existing configuration)
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Basic settings (preserve user's preferences)
setopt autocd
setopt extendedglob
unsetopt beep
bindkey -e # Use emacs keybindings

# Enhanced completion (build on user's existing setup)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # Case-insensitive completion
zstyle ':completion:*' menu select # Menu-style completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Colorized completion
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Load separate config files (preserve user's modular approach)
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions
[[ -f ~/.zsh_suffix_aliases ]] && source ~/.zsh_suffix_aliases  # Zsh-specific suffix aliases
[[ -f ~/.zsh_widgets ]] && source ~/.zsh_widgets  # Custom ZLE widgets
[[ -f ~/.zsh_local ]] && source ~/.zsh_local # For machine-specific settings

# ============================================================================
# VERSION MANAGERS & PATH SETUP (preserve user's existing setup)
# ============================================================================

# Initialize asdf version manager if installed
if [ -f $(brew --prefix asdf)/libexec/asdf.sh ]; then
  . $(brew --prefix asdf)/libexec/asdf.sh
elif [[ -d "${ASDF_DATA_DIR:-$HOME/.asdf}" ]]; then
  . "${ASDF_DATA_DIR:-$HOME/.asdf}/asdf.sh"
  # Append completions to fpath
  fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
fi

# Add local bin directories to PATH
export PATH="$HOME/.local/bin:$PATH"

# For Python user packages
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# For Ruby gems
if command -v ruby >/dev/null && command -v gem >/dev/null; then
  export PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# For Go packages
if command -v go >/dev/null; then
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi

# LM Studio CLI (if installed)
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

# ============================================================================
# ENHANCED FEATURES (new additions)
# ============================================================================

# Initialize zoxide for smart directory navigation (must happen before loading aliases)
if command -v zoxide >/dev/null; then
  # Ensure no conflicting z function exists
  unset -f z 2>/dev/null
  eval "$(zoxide init zsh)"
fi

# Load dotfiles environment and centralized aliases
[[ -f ~/.zshenv ]] && source ~/.zshenv
[[ -f ~/.aliases ]] && source ~/.aliases

# Enhanced prompt with git status (fallback if Oh-My-Zsh theme doesn't work)
if [[ "$ZSH_THEME" == "clean" ]]; then
  autoload -Uz vcs_info
  precmd() {
    local EXIT_CODE=$?
    vcs_info
    if [ $EXIT_CODE -eq 0 ]; then
      PROMPT='✅ %F{cyan}%~%f %F{green}${vcs_info_msg_0_}%f$ '
    else
      PROMPT='❌ %F{cyan}%~%f %F{green}${vcs_info_msg_0_}%f$ '
    fi
  }
  zstyle ':vcs_info:git:*' formats '%b '
  setopt PROMPT_SUBST
fi

# ============================================================================
# MODERN CLI TOOLS
# ============================================================================

# ============================================================================
# USER EXPERIENCE ENHANCEMENTS
# ============================================================================

# Better history search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Quick directory navigation
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Better globbing
setopt EXTENDED_GLOB
setopt GLOB_DOTS

# Performance optimizations
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

# ============================================================================
# PROJECT-SPECIFIC ENVIRONMENT MANAGEMENT
# ============================================================================

# Auto-load project-specific configurations
autoload_project_config() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.env" ]]; then
            echo "Loading project environment from $dir/.env"
            source "$dir/.env"
            break
        fi
        if [[ -f "$dir/.nvmrc" ]] && command -v nvm >/dev/null; then
            echo "Loading Node.js version from $dir/.nvmrc"
            nvm use
            break
        fi
        dir="$(dirname "$dir")"
    done
}

# Hook to run on directory change
chpwd() {
    autoload_project_config
}

# ============================================================================
# ADVANCED SHELL FEATURES
# ============================================================================

# Enhanced command correction
setopt CORRECT
setopt CORRECT_ALL

# Better process handling
setopt MONITOR
setopt HUP

# Advanced completion
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' special-dirs true

# Smart URL handling
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Enhanced editing
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# ============================================================================
# KEYBINDING ENHANCEMENTS (Emacs mode optimized for CapsLock=Ctrl)
# ============================================================================

# Redo binding (complements Ctrl+_ for undo)
bindkey '^Y' redo

# Word navigation with Ctrl+Arrow keys
bindkey '^[[1;5D' backward-word  # Ctrl+Left
bindkey '^[[1;5C' forward-word   # Ctrl+Right

# Delete word forward (Ctrl+Delete)
bindkey '^[[3;5~' kill-word

# Magic Space - expand history references (!! !$ !-2 etc.) on space
# See what you're about to run before hitting Enter
bindkey ' ' magic-space

# ============================================================================
# ZMV - Batch rename/move/copy with pattern matching
# ============================================================================
# Usage: zmvn '(*).test.ts' '$1.spec.ts'  (dry-run first!)
#        zmv '(*).test.ts' '$1.spec.ts'   (execute)
autoload -U zmv
alias zmv='noglob zmv'      # No need to quote patterns
alias zcp='noglob zmv -C'   # Batch copy
alias zln='noglob zmv -L'   # Batch symlink
alias zmvn='noglob zmv -n'  # Dry-run (ALWAYS preview first)
