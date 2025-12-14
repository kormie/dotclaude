#!/bin/bash

# bootstrap.sh - Bootstrap dotfiles on a fresh Mac (no SSH keys required)
#
# Usage:
#   curl -fsSL kormie.link/dotfiles | bash
#   curl -fsSL https://raw.githubusercontent.com/kormie/dotclaude/main/scripts/bootstrap.sh | bash
#
# Options (via environment variables):
#   DOTFILES_DIR   - Where to clone dotfiles (default: ~/.dotfiles)
#   INSTALL_MODE   - Install mode: all, minimal, interactive (default: all)
#
# Examples:
#   curl -fsSL kormie.link/dotfiles | bash
#   curl -fsSL kormie.link/dotfiles | INSTALL_MODE=minimal bash
#   curl -fsSL kormie.link/dotfiles | DOTFILES_DIR=~/dotfiles bash

set -e

# Configuration
DOTFILES_REPO="https://github.com/kormie/dotclaude.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
INSTALL_MODE="${INSTALL_MODE:-all}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Banner
show_banner() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}║   ${BLUE}DotClaude Bootstrap${GREEN}                                      ║${NC}"
    echo -e "${GREEN}║   Modern dotfiles for AI-assisted development              ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo
}

# Check if running on macOS
check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log_error "This bootstrap script is designed for macOS"
        exit 1
    fi
    log_info "macOS detected: $(sw_vers -productVersion)"
}

# Check for git (comes with Xcode CLT)
check_git() {
    if ! command -v git &>/dev/null; then
        log_step "Git not found, installing Xcode Command Line Tools..."
        xcode-select --install 2>/dev/null || true

        echo
        echo "Please complete the Xcode Command Line Tools installation."
        echo "Then re-run this bootstrap script."
        echo
        exit 1
    fi
    log_info "Git available: $(git --version)"
}

# Clone or update dotfiles
clone_dotfiles() {
    log_step "Setting up dotfiles repository..."

    if [[ -d "$DOTFILES_DIR" ]]; then
        log_info "Dotfiles directory exists at $DOTFILES_DIR"

        # Check if it's a git repo
        if [[ -d "$DOTFILES_DIR/.git" ]]; then
            log_info "Updating existing repository..."
            cd "$DOTFILES_DIR"
            git pull origin main || git pull origin master || log_warn "Could not pull updates"
        else
            log_warn "Directory exists but is not a git repo"
            log_info "Backing up to ${DOTFILES_DIR}.backup"
            mv "$DOTFILES_DIR" "${DOTFILES_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
            git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        fi
    else
        log_info "Cloning dotfiles to $DOTFILES_DIR..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi

    cd "$DOTFILES_DIR"
    log_info "Dotfiles ready at $DOTFILES_DIR"
}

# Run the installer
run_installer() {
    log_step "Running installer (mode: $INSTALL_MODE)..."

    if [[ ! -x "$DOTFILES_DIR/scripts/install.sh" ]]; then
        chmod +x "$DOTFILES_DIR/scripts/install.sh"
    fi

    case "$INSTALL_MODE" in
        "all")
            "$DOTFILES_DIR/scripts/install.sh" --all
            ;;
        "minimal")
            "$DOTFILES_DIR/scripts/install.sh" --minimal
            ;;
        "interactive")
            "$DOTFILES_DIR/scripts/install.sh" --interactive
            ;;
        *)
            log_warn "Unknown install mode: $INSTALL_MODE, using 'all'"
            "$DOTFILES_DIR/scripts/install.sh" --all
            ;;
    esac
}

# Post-install instructions
show_next_steps() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    Bootstrap Complete!                     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo "Next steps:"
    echo
    echo "  1. Restart your terminal or run:"
    echo -e "     ${BLUE}exec \$SHELL${NC}"
    echo
    echo "  2. (Optional) Set up SSH keys for GitHub:"
    echo -e "     ${BLUE}ssh-keygen -t ed25519 -C \"your@email.com\"${NC}"
    echo -e "     ${BLUE}cat ~/.ssh/id_ed25519.pub${NC}  # Add to GitHub"
    echo
    echo "  3. (Optional) Switch git remote to SSH:"
    echo -e "     ${BLUE}cd $DOTFILES_DIR${NC}"
    echo -e "     ${BLUE}git remote set-url origin git@github.com:kormie/dotclaude.git${NC}"
    echo
    echo "  4. Validate your setup:"
    echo -e "     ${BLUE}$DOTFILES_DIR/scripts/validate-setup.sh${NC}"
    echo
    echo "Documentation: https://kormie.github.io/dotclaude/"
    echo
}

# Main
main() {
    show_banner
    check_macos
    check_git
    clone_dotfiles
    run_installer
    show_next_steps
}

main
