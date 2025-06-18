#!/bin/bash

# stow-package.sh - Apply Stow packages safely with backup
# Usage: ./scripts/stow-package.sh [package] [action]
#   package: stow package to apply (required)
#   action: install|remove|reinstall (default: install)

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

log_stow() {
    echo -e "${BLUE}[STOW]${NC} $1"
}

# Check if stow is available
check_stow() {
    if ! command -v stow &> /dev/null; then
        log_error "GNU Stow is not installed"
        log_info "Install with: brew install stow"
        exit 1
    fi
}

# List available packages
list_packages() {
    log_info "Available Stow packages:"
    for package in "$DOTFILES_DIR/stow/"*; do
        if [[ -d "$package" ]]; then
            local package_name=$(basename "$package")
            echo "  - $package_name"
        fi
    done
}

# Validate package exists
validate_package() {
    local package="$1"
    local package_dir="$DOTFILES_DIR/stow/$package"
    
    if [[ ! -d "$package_dir" ]]; then
        log_error "Package not found: $package"
        list_packages
        exit 1
    fi
    
    # Check if package has content
    if [[ -z "$(find "$package_dir" -name "*" -not -path "$package_dir")" ]]; then
        log_warn "Package directory is empty: $package"
        read -p "Continue anyway? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            log_info "Operation cancelled"
            exit 0
        fi
    fi
}

# Install stow package
install_package() {
    local package="$1"
    
    log_stow "Installing package: $package"
    
    # Run test first
    log_info "Running configuration test..."
    if ! "$SCRIPT_DIR/test-config.sh" "$package"; then
        log_error "Configuration test failed for $package"
        read -p "Continue with installation anyway? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled"
            exit 1
        fi
    fi
    
    # Create backup before installing
    log_info "Creating backup before installation..."
    "$SCRIPT_DIR/backup.sh" "$package"
    
    # Perform dry-run first
    log_stow "Performing dry-run..."
    if stow -nv -d "$DOTFILES_DIR/stow" -t "$HOME" "$package"; then
        log_info "Dry-run successful"
    else
        log_error "Dry-run failed"
        exit 1
    fi
    
    # Confirm installation
    echo -e "${YELLOW}This will create symlinks for $package configuration${NC}"
    read -p "Continue with installation? (y/N): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled"
        exit 0
    fi
    
    # Actually install the package
    log_stow "Installing package: $package"
    if stow -v -d "$DOTFILES_DIR/stow" -t "$HOME" "$package"; then
        log_info "Package installed successfully: $package"
        return 0
    else
        log_error "Package installation failed: $package"
        return 1
    fi
}

# Remove stow package
remove_package() {
    local package="$1"
    
    log_stow "Removing package: $package"
    
    # Check if package is actually stowed
    if ! stow -nD -d "$DOTFILES_DIR/stow" -t "$HOME" "$package" 2>/dev/null; then
        log_warn "Package may not be currently stowed: $package"
    fi
    
    # Confirm removal
    echo -e "${YELLOW}This will remove symlinks for $package configuration${NC}"
    read -p "Continue with removal? (y/N): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_info "Removal cancelled"
        exit 0
    fi
    
    # Remove the package
    if stow -Dv -d "$DOTFILES_DIR/stow" -t "$HOME" "$package"; then
        log_info "Package removed successfully: $package"
        return 0
    else
        log_error "Package removal failed: $package"
        return 1
    fi
}

# Reinstall stow package
reinstall_package() {
    local package="$1"
    
    log_stow "Reinstalling package: $package"
    
    # Remove first (ignore errors)
    stow -Dv -d "$DOTFILES_DIR/stow" -t "$HOME" "$package" 2>/dev/null || true
    
    # Then install
    install_package "$package"
}

# Show package status
show_package_status() {
    local package="$1"
    
    log_info "Package status for: $package"
    
    # Show what would be stowed
    log_stow "Dry-run output:"
    stow -nv -d "$DOTFILES_DIR/stow" -t "$HOME" "$package" 2>&1 || true
    
    # Check for conflicts
    echo
    log_info "Checking for conflicts..."
    if stow -n -d "$DOTFILES_DIR/stow" -t "$HOME" "$package" 2>&1 | grep -q "conflict"; then
        log_warn "Conflicts detected - see dry-run output above"
    else
        log_info "No conflicts detected"
    fi
}

main() {
    local package="$1"
    local action="${2:-install}"
    
    if [[ -z "$package" ]]; then
        log_error "Package name required"
        echo "Usage: $0 <package> [install|remove|reinstall|status]"
        list_packages
        exit 1
    fi
    
    check_stow
    validate_package "$package"
    
    case "$action" in
        "install")
            install_package "$package"
            ;;
        "remove")
            remove_package "$package"
            ;;
        "reinstall")
            reinstall_package "$package"
            ;;
        "status")
            show_package_status "$package"
            ;;
        *)
            log_error "Unknown action: $action"
            log_info "Available actions: install, remove, reinstall, status"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"