#!/bin/bash

# test-config.sh - Test new configurations before applying system-wide
# Usage: ./scripts/test-config.sh [component]

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

log_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

# Test Stow package structure
test_stow_package() {
    local package="$1"
    local package_dir="$DOTFILES_DIR/stow/$package"
    
    log_test "Testing Stow package: $package"
    
    if [[ ! -d "$package_dir" ]]; then
        log_error "Package directory not found: $package_dir"
        return 1
    fi
    
    # Check if package has content
    if [[ -z "$(find "$package_dir" -name "*" -not -path "$package_dir")" ]]; then
        log_warn "Package directory is empty: $package"
        return 0
    fi
    
    # Test stow dry-run
    log_test "Running Stow dry-run for $package..."
    if stow -nv -d "$DOTFILES_DIR/stow" -t "$HOME" "$package" 2>&1; then
        log_info "Stow dry-run successful for $package"
        return 0
    else
        log_error "Stow dry-run failed for $package"
        return 1
    fi
}

# Test shell configuration
test_shell_config() {
    local config_file="$1"
    
    log_test "Testing shell configuration: $config_file"
    
    if [[ ! -f "$config_file" ]]; then
        log_error "Configuration file not found: $config_file"
        return 1
    fi
    
    # Test shell syntax
    if bash -n "$config_file" 2>&1; then
        log_info "Shell syntax check passed for $config_file"
    else
        log_error "Shell syntax check failed for $config_file"
        return 1
    fi
    
    # Test in subshell to avoid affecting current session
    log_test "Testing configuration in subshell..."
    if (source "$config_file" && echo "Config loaded successfully") 2>&1; then
        log_info "Configuration test passed for $config_file"
        return 0
    else
        log_error "Configuration test failed for $config_file"
        return 1
    fi
}

# Test git configuration
test_git_config() {
    local git_config="$DOTFILES_DIR/stow/git/.gitconfig"
    
    log_test "Testing Git configuration..."
    
    if [[ -f "$git_config" ]]; then
        # Test git config syntax
        if git config --file="$git_config" --list > /dev/null 2>&1; then
            log_info "Git configuration syntax is valid"
            return 0
        else
            log_error "Git configuration has syntax errors"
            return 1
        fi
    else
        log_warn "Git configuration not found, skipping test"
        return 0
    fi
}

# Test neovim configuration
test_neovim_config() {
    local nvim_config_dir="$DOTFILES_DIR/stow/neovim/.config/nvim"
    
    log_test "Testing Neovim configuration..."
    
    if [[ -d "$nvim_config_dir" ]]; then
        # Check if neovim is available
        if ! command -v nvim &> /dev/null; then
            log_warn "Neovim not installed, skipping configuration test"
            return 0
        fi
        
        # Test neovim configuration syntax
        if nvim --headless -c "checkhealth" -c "q" 2>&1 | grep -q "ERROR"; then
            log_warn "Neovim configuration may have issues (check :checkhealth)"
        else
            log_info "Neovim configuration appears healthy"
        fi
        return 0
    else
        log_warn "Neovim configuration not found, skipping test"
        return 0
    fi
}

# Test tmux configuration
test_tmux_config() {
    local tmux_config="$DOTFILES_DIR/stow/tmux/.tmux.conf"
    
    log_test "Testing Tmux configuration..."
    
    if [[ -f "$tmux_config" ]]; then
        # Check if tmux is available
        if ! command -v tmux &> /dev/null; then
            log_warn "Tmux not installed, skipping configuration test"
            return 0
        fi
        
        # Test tmux configuration syntax
        if tmux -f "$tmux_config" -C "source-file $tmux_config" 2>&1; then
            log_info "Tmux configuration syntax is valid"
            return 0
        else
            log_error "Tmux configuration has syntax errors"
            return 1
        fi
    else
        log_warn "Tmux configuration not found, skipping test"
        return 0
    fi
}

# Test all components
test_all() {
    local failed=0
    
    log_info "Testing all components..."
    
    # Test each stow package
    for package in "$DOTFILES_DIR/stow/"*; do
        if [[ -d "$package" ]]; then
            local package_name=$(basename "$package")
            if ! test_stow_package "$package_name"; then
                ((failed++))
            fi
        fi
    done
    
    # Test specific configurations
    test_git_config || ((failed++))
    test_neovim_config || ((failed++))
    test_tmux_config || ((failed++))
    
    if [[ $failed -eq 0 ]]; then
        log_info "All tests passed!"
        return 0
    else
        log_error "$failed test(s) failed"
        return 1
    fi
}

# Test specific component
test_component() {
    local component="$1"
    
    case "$component" in
        "stow")
            # Check if stow is installed
            if ! command -v stow &> /dev/null; then
                log_error "GNU Stow is not installed"
                log_info "Install with: brew install stow"
                return 1
            fi
            log_info "GNU Stow is available"
            ;;
        "zsh")
            test_stow_package "zsh"
            if [[ -f "$DOTFILES_DIR/stow/zsh/.zshrc" ]]; then
                test_shell_config "$DOTFILES_DIR/stow/zsh/.zshrc"
            fi
            ;;
        "git")
            test_stow_package "git"
            test_git_config
            ;;
        "nvim"|"neovim")
            test_stow_package "neovim"
            test_neovim_config
            ;;
        "tmux")
            test_stow_package "tmux"
            test_tmux_config
            ;;
        "environment"|"env")
            test_stow_package "environment"
            if [[ -f "$DOTFILES_DIR/stow/environment/.zshenv" ]]; then
                test_shell_config "$DOTFILES_DIR/stow/environment/.zshenv"
            fi
            ;;
        "aliases")
            test_stow_package "aliases"
            if [[ -f "$DOTFILES_DIR/stow/aliases/.aliases" ]]; then
                test_shell_config "$DOTFILES_DIR/stow/aliases/.aliases"
            fi
            ;;
        "all")
            test_all
            ;;
        *)
            log_error "Unknown component: $component"
            log_info "Available components: stow, zsh, git, nvim, tmux, environment, aliases, all"
            return 1
            ;;
    esac
}

main() {
    local component="${1:-all}"
    
    log_info "Starting configuration tests..."
    log_info "Component: $component"
    
    if test_component "$component"; then
        log_info "Configuration test completed successfully"
        exit 0
    else
        log_error "Configuration test failed"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"