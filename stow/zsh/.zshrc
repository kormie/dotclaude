# Enhanced .zshrc with Oh-My-Zsh integration
# This configuration preserves existing user settings while adding modern features

# Path to Oh-My-Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration - using minimal theme similar to current prompt
# robbyrussell is clean and Git-aware like the original setup
ZSH_THEME="robbyrussell"

# Plugins (start with essential set, can expand based on user preferences)
plugins=(
  git
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

# LM Studio CLI (preserve user's addition)
export PATH="$PATH:/Users/david.kormushoff/.lmstudio/bin"

# ============================================================================
# ENHANCED FEATURES (new additions)
# ============================================================================

# Load dotfiles environment and centralized aliases
[[ -f ~/.config/dotfiles/environment ]] && source ~/.config/dotfiles/environment
[[ -f ~/.config/dotfiles/aliases ]] && source ~/.config/dotfiles/aliases

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
# MODERN CLI TOOLS (aliases for testing, not replacements)
# ============================================================================

# Only create aliases if modern tools are installed
if command -v eza >/dev/null; then
  alias ll2='eza -la --icons --git'
  alias ls2='eza --icons'
  alias tree2='eza --tree --icons'
fi

if command -v bat >/dev/null; then
  alias cat2='bat --style=numbers,changes,header'
fi

if command -v fd >/dev/null; then
  alias find2='fd'
fi

if command -v rg >/dev/null; then
  alias grep2='rg'
fi

if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd2='z'
fi

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