# .zshrc - ZSH configuration file


# History settings
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

# Basic settings
setopt autocd
setopt extendedglob
unsetopt beep
bindkey -e # Use emacs keybindings

# Load completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # Case-insensitive completion
zstyle ':completion:*' menu select # Menu-style completion

# Load separate config files
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions
[[ -f ~/.zsh_local ]] && source ~/.zsh_local # For machine-specific settings

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

# Prompt settings - Clean, minimal prompt
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



# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/david.kormushoff/.lmstudio/bin"
