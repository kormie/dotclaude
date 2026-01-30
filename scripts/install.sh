#!/bin/bash

# install.sh - Main bootstrap script for idempotent Mac setup
# Usage: ./scripts/install.sh [--all|--minimal|--interactive]
#
# This script is fully idempotent - safe to run multiple times.
# Each step checks current state before making changes.

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

# Configuration
INSTALL_MODE="${1:-interactive}"
LOG_FILE="$DOTFILES_DIR/install.log"

#######################################
# Logging Functions
#######################################

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
    echo "[STEP] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
    echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log_skip() {
    echo -e "${CYAN}[SKIP]${NC} $1"
    echo "[SKIP] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

#######################################
# System Detection
#######################################

detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            echo "linux"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

detect_arch() {
    case "$(uname -m)" in
        arm64|aarch64)
            echo "arm64"
            ;;
        x86_64)
            echo "x86_64"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

#######################################
# Prerequisite Checks
#######################################

check_macos() {
    if [[ "$(detect_os)" != "macos" ]]; then
        log_error "This script is designed for macOS"
        log_info "Detected OS: $(uname -s)"
        exit 1
    fi
    log_success "macOS detected"
}

check_xcode_clt() {
    log_step "Checking Xcode Command Line Tools..."

    if xcode-select -p &>/dev/null; then
        log_skip "Xcode Command Line Tools already installed"
        return 0
    fi

    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install 2>/dev/null || true

    # Wait for installation
    echo "Please complete the Xcode Command Line Tools installation dialog..."
    echo "Press Enter when installation is complete..."
    read -r

    if xcode-select -p &>/dev/null; then
        log_success "Xcode Command Line Tools installed"
    else
        log_error "Xcode Command Line Tools installation failed"
        exit 1
    fi
}

install_homebrew() {
    log_step "Checking Homebrew..."

    if command -v brew &>/dev/null; then
        log_skip "Homebrew already installed"
        # Update Homebrew
        log_info "Updating Homebrew..."
        brew update &>/dev/null || log_warn "Homebrew update failed (non-fatal)"
        return 0
    fi

    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    local arch
    arch=$(detect_arch)

    if [[ "$arch" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    if command -v brew &>/dev/null; then
        log_success "Homebrew installed"
    else
        log_error "Homebrew installation failed"
        exit 1
    fi
}

#######################################
# Core Dependencies
#######################################

install_core_dependencies() {
    log_step "Installing core dependencies..."

    local deps=(
        "stow"      # GNU Stow for symlink management
        "git"       # Version control
        "zsh"       # Shell
        "neovim"    # Editor
        "tmux"      # Terminal multiplexer
    )

    for dep in "${deps[@]}"; do
        if command -v "$dep" &>/dev/null; then
            log_skip "$dep already installed"
        else
            log_info "Installing $dep..."
            if brew install "$dep"; then
                log_success "$dep installed"
            else
                log_error "Failed to install $dep"
            fi
        fi
    done
}

#######################################
# Backup Existing Configuration
#######################################

backup_existing_configs() {
    log_step "Backing up existing configurations..."

    if [[ -x "$SCRIPT_DIR/backup.sh" ]]; then
        "$SCRIPT_DIR/backup.sh" all
        log_success "Backup completed"
    else
        log_warn "Backup script not found, skipping backup"
    fi
}

#######################################
# Install Modern CLI Tools
#######################################

install_modern_tools() {
    log_step "Installing modern CLI tools..."

    if [[ -x "$SCRIPT_DIR/setup-tools.sh" ]]; then
        "$SCRIPT_DIR/setup-tools.sh" all
        log_success "Modern tools installation completed"
    else
        log_warn "setup-tools.sh not found, skipping modern tools"
    fi
}

#######################################
# Install Nerd Fonts
#######################################

install_fonts() {
    log_step "Installing Nerd Fonts..."

    if [[ -x "$SCRIPT_DIR/install-fonts.sh" ]]; then
        "$SCRIPT_DIR/install-fonts.sh" recommended
        log_success "Font installation completed"
    else
        log_warn "install-fonts.sh not found, skipping fonts"
    fi
}

#######################################
# Install Bun (JavaScript Runtime)
#######################################

install_bun() {
    log_step "Checking Bun..."

    if command -v bun &>/dev/null; then
        log_skip "Bun already installed ($(bun --version))"
        return 0
    fi

    log_info "Installing Bun..."
    if curl -fsSL https://bun.sh/install | bash; then
        log_success "Bun installed"
        # Add to current session
        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"
    else
        log_error "Failed to install Bun"
    fi
}

#######################################
# Setup Oh-My-Zsh
#######################################

setup_oh_my_zsh() {
    log_step "Setting up Oh-My-Zsh..."

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_skip "Oh-My-Zsh already installed"
    else
        if [[ -x "$SCRIPT_DIR/setup-zsh-enhanced.sh" ]]; then
            "$SCRIPT_DIR/setup-zsh-enhanced.sh"
            log_success "Oh-My-Zsh setup completed"
        else
            log_warn "setup-zsh-enhanced.sh not found, skipping Oh-My-Zsh"
        fi
    fi
}

#######################################
# Setup Secrets File
#######################################

setup_secrets_file() {
    log_step "Setting up secrets file..."

    local secrets_template="$DOTFILES_DIR/stow/environment/.secrets.template"
    local secrets_file="$HOME/.secrets"

    if [[ -f "$secrets_file" ]]; then
        log_skip "Secrets file already exists at ~/.secrets"
        return 0
    fi

    if [[ -f "$secrets_template" ]]; then
        cp "$secrets_template" "$secrets_file"
        chmod 600 "$secrets_file"  # Restrict permissions
        log_success "Created ~/.secrets from template"
        log_info "Edit ~/.secrets to add your API keys and tokens"
    else
        log_warn "Secrets template not found"
    fi
}

#######################################
# Setup Local Config Files
#######################################

setup_local_configs() {
    log_step "Setting up local config files..."

    # ~/.gitconfig.local - machine-specific git settings
    local gitconfig_local="$HOME/.gitconfig.local"
    if [[ -f "$gitconfig_local" ]]; then
        log_skip "~/.gitconfig.local already exists"
    else
        cat > "$gitconfig_local" << 'GITCONFIG'
# Machine-specific git configuration (not tracked in dotfiles)
# This file is sourced by ~/.gitconfig

[user]
    # Uncomment and set your identity:
    # name = Your Name
    # email = your@email.com
    # signingkey = ~/.ssh/id_ed25519.pub
GITCONFIG
        log_success "Created ~/.gitconfig.local"
        log_info "Edit ~/.gitconfig.local to set your git identity"
    fi

    # ~/.zshrc.local - machine-specific shell settings
    local zshrc_local="$HOME/.zshrc.local"
    if [[ -f "$zshrc_local" ]]; then
        log_skip "~/.zshrc.local already exists"
    else
        cat > "$zshrc_local" << 'ZSHRC'
# Machine-specific shell configuration (not tracked in dotfiles)
# This file is sourced at the end of ~/.zshrc

# Add machine-specific PATH entries, aliases, or settings here
# Example:
# export PATH="$PATH:$HOME/.some-local-tool/bin"
ZSHRC
        log_success "Created ~/.zshrc.local"
    fi
}

#######################################
# Deploy Stow Packages
#######################################

setup_oh_my_zsh_customizations() {
    log_step "Setting up Oh-My-Zsh custom themes and plugins..."

    local omz_custom="$HOME/.oh-my-zsh/custom"
    local stow_omz_custom="$DOTFILES_DIR/stow/zsh/.oh-my-zsh/custom"

    # Ensure Oh-My-Zsh is installed first
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_warn "Oh-My-Zsh not installed, skipping customizations"
        return 0
    fi

    # Create custom directories if they don't exist
    mkdir -p "$omz_custom/themes"
    mkdir -p "$omz_custom/plugins"

    # Symlink custom themes
    if [[ -d "$stow_omz_custom/themes" ]]; then
        for theme in "$stow_omz_custom/themes/"*.zsh-theme; do
            if [[ -f "$theme" ]]; then
                local theme_name=$(basename "$theme")
                local target="$omz_custom/themes/$theme_name"

                if [[ -L "$target" ]]; then
                    # Already a symlink, check if it points to the right place
                    if [[ "$(readlink "$target")" == "$theme" ]]; then
                        log_skip "Theme already linked: $theme_name"
                    else
                        rm "$target"
                        ln -s "$theme" "$target"
                        log_success "Re-linked theme: $theme_name"
                    fi
                elif [[ -f "$target" ]]; then
                    # Regular file exists, back it up
                    mv "$target" "$target.backup"
                    ln -s "$theme" "$target"
                    log_success "Linked theme (backed up existing): $theme_name"
                else
                    ln -s "$theme" "$target"
                    log_success "Linked theme: $theme_name"
                fi
            fi
        done
    fi

    # Symlink custom plugins (if any exist in stow package)
    if [[ -d "$stow_omz_custom/plugins" ]]; then
        for plugin_dir in "$stow_omz_custom/plugins/"*/; do
            if [[ -d "$plugin_dir" ]]; then
                local plugin_name=$(basename "$plugin_dir")
                local target="$omz_custom/plugins/$plugin_name"

                if [[ -L "$target" ]]; then
                    log_skip "Plugin already linked: $plugin_name"
                elif [[ -d "$target" ]]; then
                    log_skip "Plugin already exists: $plugin_name"
                else
                    ln -s "$plugin_dir" "$target"
                    log_success "Linked plugin: $plugin_name"
                fi
            fi
        done
    fi
}

deploy_stow_packages() {
    log_step "Deploying Stow packages..."

    # Define packages in deployment order
    local packages=(
        "environment"   # PATH and environment variables first
        "aliases"       # Aliases
        "tips"          # Terminal tips system (must be before zsh)
        "git"           # Git configuration
        "zsh"           # Zsh configuration
        "tmux"          # Tmux configuration
        "neovim"        # Neovim configuration
        "ghostty"       # Terminal configuration
    )

    for package in "${packages[@]}"; do
        local package_dir="$DOTFILES_DIR/stow/$package"

        if [[ ! -d "$package_dir" ]]; then
            log_warn "Package not found: $package"
            continue
        fi

        log_info "Deploying package: $package"

        # Check if already stowed by doing a dry run
        if stow -n -d "$DOTFILES_DIR/stow" -t "$HOME" "$package" 2>&1 | grep -q "BUG\|WARNING\|WARN"; then
            # Try to restow (handles updates)
            if stow -R -d "$DOTFILES_DIR/stow" -t "$HOME" "$package" 2>/dev/null; then
                log_success "Package deployed: $package"
            else
                log_warn "Package may have conflicts: $package (check manually)"
            fi
        else
            # Fresh stow
            if stow -d "$DOTFILES_DIR/stow" -t "$HOME" "$package" 2>/dev/null; then
                log_success "Package deployed: $package"
            else
                # Try restow for updates
                if stow -R -d "$DOTFILES_DIR/stow" -t "$HOME" "$package" 2>/dev/null; then
                    log_success "Package re-deployed: $package"
                else
                    log_warn "Failed to deploy package: $package"
                fi
            fi
        fi
    done
}

#######################################
# Apply macOS System Defaults
#######################################

apply_macos_defaults() {
    log_step "Applying macOS system defaults..."

    if [[ -x "$SCRIPT_DIR/macos-defaults.sh" ]]; then
        "$SCRIPT_DIR/macos-defaults.sh"
        log_success "macOS defaults applied"
    else
        log_skip "macos-defaults.sh not found, skipping system defaults"
    fi
}

#######################################
# Validate Installation
#######################################

validate_installation() {
    log_step "Validating installation..."

    if [[ -x "$SCRIPT_DIR/validate-setup.sh" ]]; then
        if "$SCRIPT_DIR/validate-setup.sh"; then
            log_success "Installation validation passed"
        else
            log_warn "Installation validation found issues (see above)"
        fi
    else
        log_skip "validate-setup.sh not found, skipping validation"
    fi
}

#######################################
# Interactive Mode Prompts
#######################################

prompt_yes_no() {
    local prompt="$1"
    local default="${2:-y}"
    local response

    if [[ "$default" == "y" ]]; then
        read -rp "$prompt [Y/n]: " response
        response="${response:-y}"
    else
        read -rp "$prompt [y/N]: " response
        response="${response:-n}"
    fi

    [[ "$response" =~ ^[Yy]$ ]]
}

run_interactive() {
    echo
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Dotfiles Installation - Interactive  ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo

    check_macos
    check_xcode_clt
    install_homebrew

    echo
    if prompt_yes_no "Install core dependencies (stow, git, zsh, nvim, tmux)?"; then
        install_core_dependencies
    fi

    echo
    if prompt_yes_no "Backup existing configurations?"; then
        backup_existing_configs
    fi

    echo
    if prompt_yes_no "Install modern CLI tools (eza, bat, fd, ripgrep, etc.)?"; then
        install_modern_tools
    fi

    echo
    if prompt_yes_no "Install Nerd Fonts?"; then
        install_fonts
    fi

    echo
    if prompt_yes_no "Setup Oh-My-Zsh with plugins?"; then
        setup_oh_my_zsh
    fi

    echo
    if prompt_yes_no "Install Bun (fast JavaScript runtime)?"; then
        install_bun
    fi

    echo
    if prompt_yes_no "Deploy Stow packages (configurations)?"; then
        deploy_stow_packages
        setup_oh_my_zsh_customizations
    fi

    echo
    if prompt_yes_no "Setup secrets file for API keys/tokens?"; then
        setup_secrets_file
    fi

    echo
    if prompt_yes_no "Setup local config files (gitconfig.local, zshrc.local)?"; then
        setup_local_configs
    fi

    echo
    if prompt_yes_no "Apply macOS system defaults?"; then
        apply_macos_defaults
    fi

    echo
    validate_installation
}

run_minimal() {
    echo
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Dotfiles Installation - Minimal      ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo

    check_macos
    check_xcode_clt
    install_homebrew
    install_core_dependencies
    backup_existing_configs
    install_bun
    deploy_stow_packages
    setup_oh_my_zsh_customizations
    setup_secrets_file
    setup_local_configs
    validate_installation
}

run_full() {
    echo
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Dotfiles Installation - Full         ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo

    check_macos
    check_xcode_clt
    install_homebrew
    install_core_dependencies
    backup_existing_configs
    install_modern_tools
    install_fonts
    setup_oh_my_zsh
    install_bun
    deploy_stow_packages
    setup_oh_my_zsh_customizations
    setup_secrets_file
    setup_local_configs
    apply_macos_defaults
    validate_installation
}

#######################################
# Usage
#######################################

show_usage() {
    cat << EOF
Dotfiles Installation Script

USAGE:
    $(basename "$0") [OPTION]

OPTIONS:
    --all, -a           Full installation with all features
    --minimal, -m       Minimal installation (core only)
    --interactive, -i   Interactive mode with prompts (default)
    --help, -h          Show this help message

EXAMPLES:
    $(basename "$0")              # Interactive mode
    $(basename "$0") --all        # Full installation
    $(basename "$0") --minimal    # Minimal installation

WHAT GETS INSTALLED:
    Minimal:
      - Homebrew (if not present)
      - Core dependencies (stow, git, zsh, neovim, tmux)
      - Bun (fast JavaScript runtime)
      - Stow packages deployment

    Full (includes minimal plus):
      - Modern CLI tools (eza, bat, fd, ripgrep, etc.)
      - Nerd Fonts
      - Oh-My-Zsh with plugins
      - macOS system defaults

IDEMPOTENCY:
    This script is designed to be idempotent - running it multiple
    times will not cause issues. Each step checks the current state
    before making changes.

SAFETY:
    - Existing configurations are backed up before changes
    - Original configs preserved with .original suffix
    - Restore with: ./scripts/restore.sh

EOF
}

#######################################
# Main
#######################################

main() {
    # Initialize log file
    mkdir -p "$(dirname "$LOG_FILE")"
    echo "=== Installation started: $(date) ===" >> "$LOG_FILE"
    echo "Mode: $INSTALL_MODE" >> "$LOG_FILE"

    case "$INSTALL_MODE" in
        "--all"|"-a"|"all")
            run_full
            ;;
        "--minimal"|"-m"|"minimal")
            run_minimal
            ;;
        "--interactive"|"-i"|"interactive"|"")
            run_interactive
            ;;
        "--help"|"-h"|"help")
            show_usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $INSTALL_MODE"
            show_usage
            exit 1
            ;;
    esac

    echo
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Installation Complete!                ${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo
    log_info "Log file: $LOG_FILE"
    log_info "To apply shell changes, run: exec \$SHELL"
    log_info "For help: ./scripts/install.sh --help"
    echo

    echo "=== Installation completed: $(date) ===" >> "$LOG_FILE"
}

# Run main function
main
