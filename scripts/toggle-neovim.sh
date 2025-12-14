#!/bin/bash

# Toggle between original and enhanced Neovim configuration
# Usage: ./toggle-neovim.sh [enhanced|original|status]

set -euo pipefail

# Calculate paths relative to script location for portability
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/backups"
ENHANCED_CONFIG_DIR="$DOTFILES_DIR/stow/neovim/.config/nvim"
CURRENT_STATUS_FILE="$HOME/.config/dotfiles/nvim-config-status"

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

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# Create config directory if it doesn't exist
mkdir -p "$(dirname "$CURRENT_STATUS_FILE")"

get_current_status() {
    if [[ -f "$CURRENT_STATUS_FILE" ]]; then
        cat "$CURRENT_STATUS_FILE"
    else
        echo "original"
    fi
}

set_status() {
    local status="$1"
    echo "$status" > "$CURRENT_STATUS_FILE"
    log_info "Neovim configuration status set to: $status"
}

backup_current_config() {
    local backup_name="nvim-backup-$(date +%Y%m%d_%H%M%S)"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    if [[ -d "$NVIM_CONFIG_DIR" ]]; then
        log_info "Backing up current Neovim configuration to $backup_path"
        mkdir -p "$BACKUP_DIR"
        cp -r "$NVIM_CONFIG_DIR" "$backup_path"
        log_info "Backup completed successfully"
    else
        log_warn "No existing Neovim configuration found to backup"
    fi
}

switch_to_enhanced() {
    local current_status
    current_status=$(get_current_status)

    # Check if already using enhanced config
    if [[ "$current_status" == "enhanced" ]]; then
        # Verify the symlink is correct
        if [[ -L "$NVIM_CONFIG_DIR" ]] && [[ "$(readlink "$NVIM_CONFIG_DIR")" == "$ENHANCED_CONFIG_DIR" ]]; then
            log_info "Already using enhanced Neovim configuration"
            return 0
        fi
        log_warn "Status says enhanced but symlink is incorrect, fixing..."
    fi

    # Verify enhanced config exists
    if [[ ! -d "$ENHANCED_CONFIG_DIR" ]]; then
        log_error "Enhanced configuration not found at: $ENHANCED_CONFIG_DIR"
        log_info "Make sure you're running this script from the dotfiles directory"
        return 1
    fi

    log_info "Switching to enhanced Neovim configuration..."

    # Backup current config
    backup_current_config

    # Remove current config (symlink or directory)
    if [[ -L "$NVIM_CONFIG_DIR" ]]; then
        rm "$NVIM_CONFIG_DIR"
    elif [[ -d "$NVIM_CONFIG_DIR" ]]; then
        rm -rf "$NVIM_CONFIG_DIR"
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"

    # Create symlink to enhanced config
    ln -sf "$ENHANCED_CONFIG_DIR" "$NVIM_CONFIG_DIR"

    # Verify symlink was created correctly
    if [[ -L "$NVIM_CONFIG_DIR" ]] && [[ "$(readlink "$NVIM_CONFIG_DIR")" == "$ENHANCED_CONFIG_DIR" ]]; then
        set_status "enhanced"
        log_info "✅ Switched to enhanced Neovim configuration"
        log_info "Run 'nvim' to start with the new configuration"
        log_info "First startup will install plugins automatically"
    else
        log_error "Failed to create symlink"
        return 1
    fi
}

switch_to_original() {
    local current_status
    current_status=$(get_current_status)

    # Check if already using original config (and it's not a symlink)
    if [[ "$current_status" == "original" ]]; then
        if [[ -d "$NVIM_CONFIG_DIR" ]] && [[ ! -L "$NVIM_CONFIG_DIR" ]]; then
            log_info "Already using original Neovim configuration"
            return 0
        fi
        log_warn "Status says original but config is a symlink, fixing..."
    fi

    log_info "Switching to original Neovim configuration..."

    # Remove enhanced config symlink
    if [[ -L "$NVIM_CONFIG_DIR" ]]; then
        rm "$NVIM_CONFIG_DIR"
    elif [[ -d "$NVIM_CONFIG_DIR" ]]; then
        backup_current_config
        rm -rf "$NVIM_CONFIG_DIR"
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"

    # Find most recent original backup
    local latest_backup
    latest_backup=$(find "$BACKUP_DIR" -name "nvim-backup-*" -type d 2>/dev/null | sort | tail -1)
    
    if [[ -n "$latest_backup" && -d "$latest_backup" ]]; then
        log_info "Restoring original configuration from $latest_backup"
        cp -r "$latest_backup" "$NVIM_CONFIG_DIR"
        set_status "original"
        log_info "✅ Switched to original Neovim configuration"
    else
        log_warn "No backup found, creating minimal original configuration"
        mkdir -p "$NVIM_CONFIG_DIR/lua/user"
        
        # Create minimal init.lua
        cat > "$NVIM_CONFIG_DIR/init.lua" << 'EOF'
-- Minimal Neovim configuration
require('user.options')
require('user.keymaps')
EOF
        
        # Create basic options
        cat > "$NVIM_CONFIG_DIR/lua/user/options.lua" << 'EOF'
-- Basic Neovim options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes'
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.clipboard = 'unnamedplus'
EOF
        
        # Create basic keymaps
        cat > "$NVIM_CONFIG_DIR/lua/user/keymaps.lua" << 'EOF'
-- Basic keymaps
vim.g.mapleader = ','
vim.g.maplocalleader = ','

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Clear search highlighting
map('n', '<leader><leader>', ':nohlsearch<CR>')

-- Window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Buffer navigation
map('n', '<S-l>', ':bnext<CR>')
map('n', '<S-h>', ':bprevious<CR>')

-- File explorer
map('n', '-', ':Explore<CR>')

-- Exit insert mode
map('i', 'jk', '<ESC>')

-- Visual mode indenting
map('v', '<', '<gv')
map('v', '>', '>gv')
EOF
        
        set_status "original"
        log_info "✅ Created minimal original Neovim configuration"
    fi
}

show_status() {
    local current_status
    current_status=$(get_current_status)
    
    echo "==================================="
    echo "   Neovim Configuration Status"
    echo "==================================="
    echo
    
    case "$current_status" in
        "enhanced")
            echo -e "Current: ${GREEN}Enhanced Configuration${NC}"
            echo "• Modern Lua-based setup with plugins"
            echo "• LSP, completion, and modern features"
            echo "• Git integration with delta/difftastic"
            echo "• Optimized for Claude Code workflows"
            ;;
        "original")
            echo -e "Current: ${BLUE}Original Configuration${NC}"
            echo "• Basic Neovim setup"
            echo "• User's preferred keybindings (comma leader)"
            echo "• Minimal feature set"
            echo "• Compatible with existing workflow"
            ;;
        *)
            echo -e "Current: ${YELLOW}Unknown${NC}"
            ;;
    esac
    
    echo
    echo "Configuration location: $NVIM_CONFIG_DIR"
    
    if [[ -L "$NVIM_CONFIG_DIR" ]]; then
        echo "Type: Symlink"
        echo -e "Target: ${BLUE}$(readlink "$NVIM_CONFIG_DIR")${NC}"
    elif [[ -d "$NVIM_CONFIG_DIR" ]]; then
        echo "Type: Directory"
    else
        echo -e "Type: ${RED}Missing${NC}"
    fi
    
    echo
    echo "Available backups:"
    if find "$BACKUP_DIR" -name "nvim-backup-*" -type d >/dev/null 2>&1; then
        find "$BACKUP_DIR" -name "nvim-backup-*" -type d | sort -r | head -5 | while read -r backup; do
            echo "  • $(basename "$backup")"
        done
    else
        echo "  • No backups found"
    fi
}

show_help() {
    cat << EOF
Neovim Configuration Toggle Script

USAGE:
    $(basename "$0") [COMMAND]

COMMANDS:
    enhanced    Switch to enhanced Neovim configuration with modern features
    original    Switch to original/minimal Neovim configuration  
    status      Show current configuration status and information
    help        Show this help message

EXAMPLES:
    $(basename "$0") enhanced   # Switch to modern Lua configuration
    $(basename "$0") original   # Switch back to basic configuration
    $(basename "$0") status     # Check current status

The enhanced configuration includes:
• Modern plugin management with lazy.nvim
• LSP support with completion and diagnostics
• Git integration (gitsigns, fugitive, diffview)
• Modern UI components and themes
• Claude Code workflow optimizations
• Your existing keybinding preferences preserved

The original configuration provides:
• Basic Neovim setup with your preferred keybindings
• Minimal feature set for maximum compatibility
• Fast startup time
• No plugin dependencies

Both configurations preserve your comma leader key preference and core keybindings.
EOF
}

main() {
    local command="${1:-status}"
    
    case "$command" in
        "enhanced")
            switch_to_enhanced
            ;;
        "original")
            switch_to_original
            ;;
        "status")
            show_status
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            log_error "Unknown command: $command"
            echo
            show_help
            exit 1
            ;;
    esac
}

main "$@"