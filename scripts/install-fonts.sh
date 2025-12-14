#!/bin/bash

# install-fonts.sh - Install Nerd Fonts for terminal configuration
# Usage: ./scripts/install-fonts.sh [font|all|list]
#
# This script is idempotent - safe to run multiple times.
# Fonts already installed will be skipped.

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
        log_info "For Linux, install fonts via your package manager or:"
        log_info "  https://github.com/ryanoasis/nerd-fonts#option-3-install-script"
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

# Ensure Homebrew font cask tap is available
setup_font_tap() {
    if ! brew tap | grep -q "homebrew/cask-fonts" 2>/dev/null; then
        # Note: As of 2023, fonts are in homebrew/cask directly, tap may not be needed
        # but we check anyway for older Homebrew installations
        log_info "Homebrew fonts are available in the main cask repository"
    fi
}

# Check if a font is already installed
# Uses font book or checks common font directories
is_font_installed() {
    local font_name="$1"

    # Check in system and user font directories
    local font_dirs=(
        "$HOME/Library/Fonts"
        "/Library/Fonts"
        "/System/Library/Fonts"
    )

    for dir in "${font_dirs[@]}"; do
        if [[ -d "$dir" ]] && find "$dir" -iname "*${font_name}*" -type f 2>/dev/null | grep -q .; then
            return 0
        fi
    done

    return 1
}

# Install a Nerd Font via Homebrew cask
install_font() {
    local font_name="$1"
    local cask_name="$2"
    local check_name="${3:-$font_name}"

    log_install "Checking $font_name..."

    if is_font_installed "$check_name"; then
        log_info "$font_name is already installed"
        return 0
    fi

    log_install "Installing $font_name..."

    if brew install --cask "$cask_name" 2>/dev/null; then
        log_info "$font_name installed successfully"
        return 0
    else
        log_error "Failed to install $font_name"
        log_info "Try manually: brew install --cask $cask_name"
        return 1
    fi
}

# Available fonts and their Homebrew cask names
declare -A FONTS=(
    ["jetbrains"]="font-jetbrains-mono-nerd-font:JetBrainsMono"
    ["firacode"]="font-fira-code-nerd-font:FiraCode"
    ["cascadia"]="font-caskaydia-cove-nerd-font:CaskaydiaCove"
    ["hack"]="font-hack-nerd-font:Hack"
    ["meslo"]="font-meslo-lg-nerd-font:MesloLG"
    ["iosevka"]="font-iosevka-nerd-font:Iosevka"
    ["victor"]="font-victor-mono-nerd-font:VictorMono"
    ["source"]="font-sauce-code-pro-nerd-font:SauceCodePro"
)

# Display names for fonts
declare -A FONT_NAMES=(
    ["jetbrains"]="JetBrainsMono Nerd Font"
    ["firacode"]="FiraCode Nerd Font"
    ["cascadia"]="CaskaydiaCove Nerd Font"
    ["hack"]="Hack Nerd Font"
    ["meslo"]="MesloLG Nerd Font"
    ["iosevka"]="Iosevka Nerd Font"
    ["victor"]="VictorMono Nerd Font"
    ["source"]="SauceCodePro Nerd Font"
)

# Install a specific font by key
install_font_by_key() {
    local key="$1"

    if [[ -z "${FONTS[$key]}" ]]; then
        log_error "Unknown font: $key"
        log_info "Available fonts: ${!FONTS[*]}"
        return 1
    fi

    local cask_and_check="${FONTS[$key]}"
    local cask_name="${cask_and_check%:*}"
    local check_name="${cask_and_check#*:}"
    local display_name="${FONT_NAMES[$key]}"

    install_font "$display_name" "$cask_name" "$check_name"
}

# Install recommended fonts for this dotfiles setup
install_recommended() {
    log_info "Installing recommended Nerd Fonts..."

    # Primary font used in Ghostty config
    install_font_by_key "jetbrains"

    # Common alternatives mentioned in config
    install_font_by_key "firacode"
    install_font_by_key "meslo"
}

# Install all available fonts
install_all() {
    log_info "Installing all available Nerd Fonts..."

    for key in "${!FONTS[@]}"; do
        install_font_by_key "$key"
    done
}

# List available fonts and their status
list_fonts() {
    echo
    echo "Available Nerd Fonts:"
    echo

    for key in "${!FONTS[@]}"; do
        local cask_and_check="${FONTS[$key]}"
        local check_name="${cask_and_check#*:}"
        local display_name="${FONT_NAMES[$key]}"

        if is_font_installed "$check_name"; then
            echo -e "  ✅ ${GREEN}$key${NC} - $display_name (installed)"
        else
            echo -e "  ⬜ ${YELLOW}$key${NC} - $display_name"
        fi
    done

    echo
    echo "Usage:"
    echo "  ./scripts/install-fonts.sh <font>      Install specific font"
    echo "  ./scripts/install-fonts.sh recommended Install recommended fonts"
    echo "  ./scripts/install-fonts.sh all         Install all fonts"
    echo
}

# Show installation summary
show_summary() {
    echo
    log_info "Font Installation Summary:"
    echo

    local installed=0
    local total=0

    for key in "${!FONTS[@]}"; do
        local cask_and_check="${FONTS[$key]}"
        local check_name="${cask_and_check#*:}"
        local display_name="${FONT_NAMES[$key]}"

        ((total++))

        if is_font_installed "$check_name"; then
            echo -e "  ✅ ${GREEN}$display_name${NC}"
            ((installed++))
        fi
    done

    echo
    log_info "$installed of $total Nerd Fonts installed"

    if is_font_installed "JetBrainsMono"; then
        log_info "Primary font (JetBrainsMono Nerd Font) is ready for Ghostty"
    else
        log_warn "Primary font not installed. Run: ./scripts/install-fonts.sh jetbrains"
    fi
}

usage() {
    echo "Usage: $0 [command]"
    echo
    echo "Commands:"
    echo "  <font>       Install a specific font (jetbrains, firacode, hack, etc.)"
    echo "  recommended  Install recommended fonts for this dotfiles setup"
    echo "  all          Install all available Nerd Fonts"
    echo "  list         List available fonts and their installation status"
    echo "  help         Show this help message"
    echo
    echo "Examples:"
    echo "  $0 jetbrains     # Install JetBrainsMono Nerd Font"
    echo "  $0 recommended   # Install recommended fonts"
    echo "  $0 list          # Show available fonts"
}

main() {
    local target="${1:-list}"

    case "$target" in
        "help"|"-h"|"--help")
            usage
            exit 0
            ;;
        "list")
            check_macos
            list_fonts
            exit 0
            ;;
    esac

    check_macos
    check_homebrew
    setup_font_tap

    log_info "Installing Nerd Fonts..."
    log_info "Target: $target"
    echo

    case "$target" in
        "recommended")
            install_recommended
            ;;
        "all")
            install_all
            ;;
        *)
            # Try to install as a specific font
            install_font_by_key "$target"
            ;;
    esac

    show_summary

    log_info "Font installation complete!"
    log_info "You may need to restart your terminal to use new fonts."
}

# Run main function with all arguments
main "$@"
