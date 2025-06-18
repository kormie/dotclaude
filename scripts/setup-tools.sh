#!/bin/bash

# setup-tools.sh - Install modern CLI tools without changing defaults
# Usage: ./scripts/setup-tools.sh [tool|all]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_install() {
    echo -e "${BLUE}[INSTALL]${NC} $1"
}

# Check if running on macOS
check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log_error "This script is designed for macOS with Homebrew"
        exit 1
    fi
}

# Check if Homebrew is installed
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_error "Homebrew is not installed"
        log_info "Install Homebrew first: https://brew.sh"
        exit 1
    fi
}

# Install a tool via Homebrew
install_tool() {
    local tool="$1"
    local formula="$2"
    
    log_install "Installing $tool..."
    
    if command -v "$tool" &> /dev/null; then
        log_info "$tool is already available"
        return 0
    fi
    
    if brew install "$formula"; then
        log_info "$tool installed successfully"
        return 0
    else
        log_error "Failed to install $tool"
        return 1
    fi
}

# Install modern CLI tools
install_rust_tools() {
    log_info "Installing modern Rust-based CLI tools..."
    
    # Better ls replacement
    install_tool "exa" "exa" || install_tool "eza" "eza"
    
    # Better cat replacement  
    install_tool "bat" "bat"
    
    # Better find replacement
    install_tool "fd" "fd"
    
    # Better grep replacement
    install_tool "rg" "ripgrep"
    
    # Smart directory navigation
    install_tool "zoxide" "zoxide"
    
    # Better git diff tools
    install_tool "delta" "git-delta"
    install_tool "difft" "difftastic"
    
    # Better du replacement
    install_tool "dust" "dust"
    
    # Better ps replacement
    install_tool "procs" "procs"
    
    # Better top replacement
    install_tool "btm" "bottom"
    
    # Better tree replacement
    install_tool "broot" "broot"
}

# Install additional useful tools
install_additional_tools() {
    log_info "Installing additional useful tools..."
    
    # GNU Stow for dotfile management
    install_tool "stow" "stow"
    
    # Modern shell
    install_tool "zsh" "zsh"
    
    # Terminal multiplexer
    install_tool "tmux" "tmux"
    
    # Modern text editor
    install_tool "nvim" "neovim"
    
    # JSON processor
    install_tool "jq" "jq"
    
    # YAML processor  
    install_tool "yq" "yq"
    
    # HTTP client
    install_tool "httpie" "httpie"
    
    # File archiver
    install_tool "7z" "p7zip"
}

# Create coexisting aliases for new tools
create_aliases() {
    local alias_file="$DOTFILES_DIR/stow/rust-tools/.aliases"
    
    log_info "Creating coexisting aliases..."
    
    mkdir -p "$(dirname "$alias_file")"
    
    cat > "$alias_file" << 'EOF'
# Modern CLI tool aliases - coexist with traditional tools
# These provide modern alternatives without replacing the originals

# exa/eza (better ls)
if command -v eza &> /dev/null; then
    alias ll2='eza -la --git --header --group-directories-first'
    alias l2='eza -l --git --header --group-directories-first'
    alias la2='eza -la --git --header --group-directories-first'
    alias tree2='eza --tree'
elif command -v exa &> /dev/null; then
    alias ll2='exa -la --git --header --group-directories-first'
    alias l2='exa -l --git --header --group-directories-first'  
    alias la2='exa -la --git --header --group-directories-first'
    alias tree2='exa --tree'
fi

# bat (better cat)
if command -v bat &> /dev/null; then
    alias cat2='bat'
    alias less2='bat'
fi

# fd (better find)
if command -v fd &> /dev/null; then
    alias find2='fd'
fi

# ripgrep (better grep)
if command -v rg &> /dev/null; then
    alias grep2='rg'
fi

# dust (better du)
if command -v dust &> /dev/null; then
    alias du2='dust'
fi

# procs (better ps)
if command -v procs &> /dev/null; then
    alias ps2='procs'
fi

# bottom (better top)
if command -v btm &> /dev/null; then
    alias top2='btm'
fi

# zoxide (smart cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd2='z'
fi
EOF

    log_info "Aliases created in: $alias_file"
    log_info "To use, run: source $alias_file"
}

# Show installation summary
show_summary() {
    log_info "Installation Summary:"
    
    echo
    echo "Modern CLI Tools Available:"
    
    # Check each tool
    local tools=(
        "exa:Enhanced ls with colors and git integration"
        "eza:Alternative enhanced ls (newer fork of exa)"
        "bat:Cat with syntax highlighting and paging"
        "fd:Simple and fast alternative to find"
        "rg:Extremely fast grep alternative"
        "zoxide:Smart cd command that learns your habits"
        "delta:Better git diff with syntax highlighting"
        "difft:Syntax-aware diff tool (difftastic)"
        "dust:Intuitive du replacement"
        "procs:Modern ps replacement"
        "btm:Cross-platform top alternative"
        "broot:Interactive tree view"
        "stow:GNU Stow for symlink management"
        "jq:JSON processor"
        "yq:YAML processor"
    )
    
    for tool_desc in "${tools[@]}"; do
        local tool="${tool_desc%:*}"
        local desc="${tool_desc#*:}"
        
        if command -v "$tool" &> /dev/null; then
            echo -e "  ✅ ${GREEN}$tool${NC} - $desc"
        else
            echo -e "  ❌ ${RED}$tool${NC} - $desc (not installed)"
        fi
    done
    
    echo
    log_info "Try the new tools with '2' suffix aliases (e.g., ll2, cat2, find2)"
    log_info "Load aliases with: source $DOTFILES_DIR/stow/rust-tools/.aliases"
}

main() {
    local target="${1:-all}"
    
    check_macos
    check_homebrew
    
    log_info "Setting up modern CLI tools..."
    log_info "Target: $target"
    
    case "$target" in
        "rust"|"rust-tools")
            install_rust_tools
            ;;
        "additional")
            install_additional_tools
            ;;
        "aliases")
            create_aliases
            ;;
        "all")
            install_rust_tools
            install_additional_tools
            create_aliases
            ;;
        *)
            log_error "Unknown target: $target"
            log_info "Available targets: rust, additional, aliases, all"
            exit 1
            ;;
    esac
    
    show_summary
    
    # Create symlink for tmux-claude-workspace script
    local script_path="$DOTFILES_DIR/scripts/tmux-claude-workspace"
    local bin_dir="$HOME/.local/bin"
    
    if [[ -f "$script_path" ]]; then
        mkdir -p "$bin_dir"
        if [[ ! -L "$bin_dir/tmux-claude-workspace" ]]; then
            ln -sf "$script_path" "$bin_dir/tmux-claude-workspace"
            log_info "tmux-claude-workspace script linked to PATH"
        fi
    fi
    
    log_info "Setup completed successfully!"
    log_info "New tools are available alongside your existing ones."
    log_info "Claude Code workspace: Run 'cw' or 'claude-workspace' to start"
}

# Run main function with all arguments
main "$@"