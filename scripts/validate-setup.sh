#!/bin/bash

# validate-setup.sh - Verify dotfiles installation is complete and correct
# Usage: ./scripts/validate-setup.sh [--verbose|-v]
#
# This script validates the installation and reports any issues.
# Exit codes:
#   0 - All checks passed
#   1 - Some checks failed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

VERBOSE="${1:-}"
FAILED_CHECKS=0
PASSED_CHECKS=0
WARNED_CHECKS=0

#######################################
# Logging Functions
#######################################

log_pass() {
    echo -e "  ${GREEN}✓${NC} $1"
    ((PASSED_CHECKS++))
}

log_fail() {
    echo -e "  ${RED}✗${NC} $1"
    ((FAILED_CHECKS++))
}

log_warn() {
    echo -e "  ${YELLOW}!${NC} $1"
    ((WARNED_CHECKS++))
}

log_skip() {
    echo -e "  ${CYAN}-${NC} $1"
}

log_header() {
    echo
    echo -e "${BLUE}=== $1 ===${NC}"
}

log_verbose() {
    if [[ "$VERBOSE" == "--verbose" || "$VERBOSE" == "-v" ]]; then
        echo -e "    ${CYAN}↳${NC} $1"
    fi
}

#######################################
# Core Dependency Checks
#######################################

check_core_dependencies() {
    log_header "Core Dependencies"

    local deps=(
        "brew:Homebrew"
        "stow:GNU Stow"
        "git:Git"
        "zsh:Zsh Shell"
        "nvim:Neovim"
        "tmux:Tmux"
    )

    for dep_info in "${deps[@]}"; do
        local cmd="${dep_info%:*}"
        local name="${dep_info#*:}"

        if command -v "$cmd" &>/dev/null; then
            local version
            case "$cmd" in
                "brew")
                    version=$(brew --version | head -1)
                    ;;
                "nvim")
                    version=$(nvim --version | head -1)
                    ;;
                "git")
                    version=$(git --version)
                    ;;
                *)
                    version=$($cmd --version 2>/dev/null | head -1 || echo "installed")
                    ;;
            esac
            log_pass "$name"
            log_verbose "$version"
        else
            log_fail "$name - not installed"
        fi
    done
}

#######################################
# Modern CLI Tools Checks
#######################################

check_modern_tools() {
    log_header "Modern CLI Tools"

    local tools=(
        "eza:eza (better ls)"
        "bat:bat (better cat)"
        "fd:fd (better find)"
        "rg:ripgrep (better grep)"
        "zoxide:zoxide (smart cd)"
        "delta:delta (git diff)"
        "difft:difftastic (syntax-aware diff)"
        "dust:dust (better du)"
        "procs:procs (better ps)"
        "btm:bottom (better top)"
    )

    local installed=0
    local total=${#tools[@]}

    for tool_info in "${tools[@]}"; do
        local cmd="${tool_info%:*}"
        local name="${tool_info#*:}"

        if command -v "$cmd" &>/dev/null; then
            log_pass "$name"
            ((installed++))
        else
            log_warn "$name - not installed (optional)"
        fi
    done

    echo
    echo -e "  ${CYAN}Info:${NC} $installed/$total modern tools installed"
}

#######################################
# Stow Package Checks
#######################################

check_stow_packages() {
    log_header "Stow Package Deployment"

    # Define expected symlinks for each package
    declare -A package_links=(
        ["git"]=".gitconfig"
        ["environment"]=".zshenv"
        ["tmux"]=".tmux.conf"
        ["neovim"]=".config/nvim"
        ["ghostty"]=".config/ghostty"
        ["zsh"]=".zshrc"
        ["aliases"]=".config/dotfiles"
        ["tips"]=".zshrc.d/tips.zsh"
    )

    for package in "${!package_links[@]}"; do
        local target="${package_links[$package]}"
        local full_path="$HOME/$target"
        local source_path="$DOTFILES_DIR/stow/$package"

        # Check if source package exists
        if [[ ! -d "$source_path" ]]; then
            log_skip "$package - package not found in stow/"
            continue
        fi

        # Check if target exists and is properly linked
        if [[ -L "$full_path" ]]; then
            # It's a symlink - verify it points to our stow package
            local link_target
            link_target=$(readlink "$full_path" 2>/dev/null || echo "")
            if [[ "$link_target" == *"$DOTFILES_DIR/stow/$package"* ]]; then
                log_pass "$package → ~/$target"
                log_verbose "Linked to: $link_target"
            else
                log_warn "$package - symlink exists but points elsewhere"
                log_verbose "Points to: $link_target"
            fi
        elif [[ -e "$full_path" ]]; then
            log_warn "$package - ~/$target exists but is not a symlink"
        else
            log_fail "$package - ~/$target not deployed"
        fi
    done
}

#######################################
# Shell Configuration Checks
#######################################

check_shell_config() {
    log_header "Shell Configuration"

    # Check current shell
    local current_shell
    current_shell=$(basename "$SHELL")
    if [[ "$current_shell" == "zsh" ]]; then
        log_pass "Default shell is Zsh"
    else
        log_warn "Default shell is $current_shell (not Zsh)"
    fi

    # Check Oh-My-Zsh
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_pass "Oh-My-Zsh installed"

        # Check for essential plugins
        local plugins=("zsh-autosuggestions" "zsh-syntax-highlighting")
        for plugin in "${plugins[@]}"; do
            if [[ -d "$HOME/.oh-my-zsh/custom/plugins/$plugin" ]]; then
                log_pass "Plugin: $plugin"
            else
                log_warn "Plugin: $plugin - not installed"
            fi
        done

        # Check for KOHO theme
        if [[ -f "$HOME/.oh-my-zsh/custom/themes/koho.zsh-theme" ]]; then
            log_pass "KOHO theme installed"
        else
            log_warn "KOHO theme not found"
        fi
    else
        log_warn "Oh-My-Zsh not installed"
    fi

    # Check for terminal tips system
    if [[ -f "$HOME/.zshrc.d/tips.zsh" ]]; then
        log_pass "Terminal tips system installed"
        # Check tips data directory
        if [[ -d "$HOME/.config/dotfiles/tips/tips-data" ]]; then
            local tip_count
            tip_count=$(find "$HOME/.config/dotfiles/tips/tips-data" -name "*.tips" 2>/dev/null | wc -l | tr -d ' ')
            log_verbose "$tip_count tip categories available"
        fi
    else
        log_warn "Terminal tips system not installed (optional)"
    fi
}

#######################################
# Git Configuration Checks
#######################################

check_git_config() {
    log_header "Git Configuration"

    # Check git user config
    local git_name
    local git_email
    git_name=$(git config --global user.name 2>/dev/null || echo "")
    git_email=$(git config --global user.email 2>/dev/null || echo "")

    if [[ -n "$git_name" ]]; then
        log_pass "Git user.name: $git_name"
    else
        log_warn "Git user.name not set"
    fi

    if [[ -n "$git_email" ]]; then
        log_pass "Git user.email: $git_email"
    else
        log_warn "Git user.email not set"
    fi

    # Check for delta as diff tool
    local git_pager
    git_pager=$(git config --global core.pager 2>/dev/null || echo "")
    if [[ "$git_pager" == *"delta"* ]]; then
        log_pass "Git using delta as pager"
    elif command -v delta &>/dev/null; then
        log_warn "Delta installed but not configured as git pager"
    else
        log_skip "Delta not installed"
    fi

    # Check for difftastic
    if command -v difft &>/dev/null; then
        log_pass "Difftastic available"
    else
        log_skip "Difftastic not installed"
    fi
}

#######################################
# Neovim Configuration Checks
#######################################

check_neovim_config() {
    log_header "Neovim Configuration"

    if ! command -v nvim &>/dev/null; then
        log_skip "Neovim not installed"
        return
    fi

    local nvim_config="$HOME/.config/nvim"

    if [[ -d "$nvim_config" || -L "$nvim_config" ]]; then
        log_pass "Neovim config directory exists"

        # Check for init.lua
        if [[ -f "$nvim_config/init.lua" ]]; then
            log_pass "init.lua present"
        else
            log_warn "init.lua not found"
        fi

        # Check for lazy.nvim
        if [[ -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]]; then
            log_pass "lazy.nvim plugin manager installed"
        else
            log_warn "lazy.nvim not installed (run nvim to install)"
        fi
    else
        log_fail "Neovim config directory not found"
    fi

    # Check toggle status
    local nvim_status_file="$HOME/.config/dotfiles/nvim-config-status"
    if [[ -f "$nvim_status_file" ]]; then
        local status
        status=$(cat "$nvim_status_file")
        log_verbose "Neovim config status: $status"
    fi
}

#######################################
# Font Checks
#######################################

check_fonts() {
    log_header "Nerd Fonts"

    # Check for Nerd Fonts in common locations
    local font_dirs=(
        "$HOME/Library/Fonts"
        "/Library/Fonts"
    )

    local nerd_fonts_found=false

    for dir in "${font_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            if find "$dir" -iname "*nerd*" -type f 2>/dev/null | grep -q .; then
                nerd_fonts_found=true
                break
            fi
            if find "$dir" -iname "*JetBrainsMono*" -type f 2>/dev/null | grep -q .; then
                nerd_fonts_found=true
                break
            fi
        fi
    done

    if $nerd_fonts_found; then
        log_pass "Nerd Fonts detected"
    else
        log_warn "Nerd Fonts not detected (optional)"
    fi
}

#######################################
# Tmux Configuration Checks
#######################################

check_tmux_config() {
    log_header "Tmux Configuration"

    if ! command -v tmux &>/dev/null; then
        log_skip "Tmux not installed"
        return
    fi

    if [[ -f "$HOME/.tmux.conf" || -L "$HOME/.tmux.conf" ]]; then
        log_pass "Tmux config present"

        # Check for TPM (Tmux Plugin Manager)
        if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
            log_pass "TPM (Tmux Plugin Manager) installed"
        else
            log_warn "TPM not installed (optional)"
        fi
    else
        log_fail "Tmux config not found"
    fi
}

#######################################
# Path and Environment Checks
#######################################

check_environment() {
    log_header "Environment"

    # Check .local/bin is in PATH
    if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
        log_pass "~/.local/bin in PATH"
    else
        log_warn "~/.local/bin not in PATH"
    fi

    # Check for .zshenv
    if [[ -f "$HOME/.zshenv" || -L "$HOME/.zshenv" ]]; then
        log_pass ".zshenv present"
    else
        log_warn ".zshenv not found"
    fi

    # Check XDG directories
    local xdg_config="${XDG_CONFIG_HOME:-$HOME/.config}"
    if [[ -d "$xdg_config" ]]; then
        log_pass "XDG_CONFIG_HOME exists ($xdg_config)"
    else
        log_warn "XDG_CONFIG_HOME directory not found"
    fi
}

#######################################
# Backup System Checks
#######################################

check_backup_system() {
    log_header "Backup System"

    local backup_dir="$DOTFILES_DIR/backups"

    if [[ -d "$backup_dir" ]]; then
        local backup_count
        backup_count=$(find "$backup_dir" -maxdepth 1 -type d | wc -l)
        ((backup_count--))  # Subtract 1 for the backups dir itself

        log_pass "Backup directory exists"
        log_verbose "$backup_count backup(s) found"
    else
        log_warn "Backup directory not found"
    fi

    # Check backup script
    if [[ -x "$SCRIPT_DIR/backup.sh" ]]; then
        log_pass "Backup script available"
    else
        log_fail "Backup script not found or not executable"
    fi

    # Check restore script
    if [[ -x "$SCRIPT_DIR/restore.sh" ]]; then
        log_pass "Restore script available"
    else
        log_fail "Restore script not found or not executable"
    fi
}

#######################################
# Summary
#######################################

show_summary() {
    echo
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}           Validation Summary            ${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo
    echo -e "  ${GREEN}Passed:${NC}  $PASSED_CHECKS"
    echo -e "  ${YELLOW}Warnings:${NC} $WARNED_CHECKS"
    echo -e "  ${RED}Failed:${NC}  $FAILED_CHECKS"
    echo

    if [[ $FAILED_CHECKS -eq 0 ]]; then
        echo -e "${GREEN}All critical checks passed!${NC}"
        if [[ $WARNED_CHECKS -gt 0 ]]; then
            echo -e "${YELLOW}Some optional components are missing.${NC}"
        fi
    else
        echo -e "${RED}Some checks failed. Review the output above.${NC}"
        echo
        echo "To fix issues, try:"
        echo "  ./scripts/install.sh --all    # Full installation"
        echo "  ./scripts/setup-tools.sh      # Install modern tools"
        echo "  ./scripts/stow-package.sh <pkg>  # Deploy specific package"
    fi
    echo
}

#######################################
# Usage
#######################################

show_usage() {
    cat << EOF
Dotfiles Validation Script

USAGE:
    $(basename "$0") [OPTIONS]

OPTIONS:
    --verbose, -v    Show detailed information
    --help, -h       Show this help message

EXAMPLES:
    $(basename "$0")           # Run validation
    $(basename "$0") -v        # Run with verbose output

EXIT CODES:
    0 - All critical checks passed
    1 - One or more critical checks failed

EOF
}

#######################################
# Main
#######################################

main() {
    case "${1:-}" in
        "--help"|"-h")
            show_usage
            exit 0
            ;;
        "--verbose"|"-v"|"")
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac

    echo
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}     Dotfiles Installation Validation    ${NC}"
    echo -e "${BLUE}==========================================${NC}"

    check_core_dependencies
    check_modern_tools
    check_stow_packages
    check_shell_config
    check_git_config
    check_neovim_config
    check_fonts
    check_tmux_config
    check_environment
    check_backup_system

    show_summary

    # Return appropriate exit code
    if [[ $FAILED_CHECKS -gt 0 ]]; then
        exit 1
    fi
    exit 0
}

# Run main function
main "$@"
