#!/bin/bash

# restore.sh - Restore dotfiles from backup
# Usage: ./scripts/restore.sh [backup_timestamp] [component]
#   backup_timestamp: specific backup to restore from (optional, defaults to latest)
#   component: specific config to restore (optional, defaults to all)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$DOTFILES_DIR/backups"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# List available backups
list_backups() {
    log_info "Available backups:"
    if [[ -d "$BACKUP_DIR" ]]; then
        ls -la "$BACKUP_DIR" | grep "^d" | awk '{print $9}' | grep -E "^[0-9]{8}_[0-9]{6}$" | sort -r
    else
        log_warn "No backup directory found"
        return 1
    fi
}

# Get latest backup
get_latest_backup() {
    local latest
    latest=$(ls -1 "$BACKUP_DIR" | grep -E "^[0-9]{8}_[0-9]{6}$" | sort -r | head -n1)
    if [[ -n "$latest" ]]; then
        echo "$latest"
    else
        log_error "No backups found"
        return 1
    fi
}

# Restore a single file
restore_file() {
    local source="$1"
    local dest="$2"
    
    if [[ -e "$source" ]]; then
        # Create backup of current file before restoring
        if [[ -e "$dest" ]]; then
            local current_backup="${dest}.pre-restore.$(date +%Y%m%d_%H%M%S)"
            log_info "Backing up current file: $dest -> $current_backup"
            cp -r "$dest" "$current_backup"
        fi
        
        # Restore the file
        mkdir -p "$(dirname "$dest")"
        cp -r "$source" "$dest"
        log_info "Restored: $source -> $dest"
        return 0
    else
        log_warn "Backup file not found: $source"
        return 1
    fi
}

# Restore all files from backup
restore_all_files() {
    local backup_dir="$1"
    local restored=0
    
    log_info "Restoring all files from: $backup_dir"
    
    # Find all files in backup (excluding MANIFEST)
    while IFS= read -r -d '' file; do
        local relative_path="${file#$backup_dir}"
        local dest_path="$HOME$relative_path"
        
        if restore_file "$file" "$dest_path"; then
            ((restored++))
        fi
    done < <(find "$backup_dir" -type f -not -name "MANIFEST" -print0)
    
    log_info "Restored $restored files"
}

# Restore specific component
restore_component() {
    local component="$1"
    local backup_dir="$2"
    
    case "$component" in
        "zsh")
            restore_file "$backup_dir/.zshrc" "$HOME/.zshrc"
            restore_file "$backup_dir/.oh-my-zsh" "$HOME/.oh-my-zsh"
            ;;
        "git")
            restore_file "$backup_dir/.gitconfig" "$HOME/.gitconfig"
            restore_file "$backup_dir/.gitignore_global" "$HOME/.gitignore_global"
            ;;
        "nvim"|"neovim")
            restore_file "$backup_dir/.config/nvim" "$HOME/.config/nvim"
            restore_file "$backup_dir/.vimrc" "$HOME/.vimrc"
            restore_file "$backup_dir/.vim" "$HOME/.vim"
            ;;
        "tmux")
            restore_file "$backup_dir/.tmux.conf" "$HOME/.tmux.conf"
            ;;
        *)
            log_error "Unknown component: $component"
            log_info "Available components: zsh, git, nvim, tmux"
            exit 1
            ;;
    esac
}

# Interactive restore selection
interactive_restore() {
    list_backups
    echo
    read -p "Enter backup timestamp to restore (or 'latest' for most recent): " backup_choice
    
    if [[ "$backup_choice" == "latest" ]]; then
        backup_choice=$(get_latest_backup)
    fi
    
    if [[ ! -d "$BACKUP_DIR/$backup_choice" ]]; then
        log_error "Backup not found: $backup_choice"
        exit 1
    fi
    
    echo
    echo "Available components in backup:"
    cat "$BACKUP_DIR/$backup_choice/MANIFEST"
    echo
    read -p "Enter component to restore (or 'all' for everything): " component_choice
    
    echo "$backup_choice:$component_choice"
}

main() {
    local backup_timestamp="${1:-}"
    local component="${2:-all}"
    
    # If no arguments provided, use interactive mode
    if [[ -z "$backup_timestamp" ]]; then
        log_info "No backup specified, entering interactive mode..."
        local interactive_result
        interactive_result=$(interactive_restore)
        backup_timestamp="${interactive_result%:*}"
        component="${interactive_result#*:}"
    fi
    
    # Use latest backup if not specified
    if [[ "$backup_timestamp" == "latest" ]]; then
        backup_timestamp=$(get_latest_backup)
    fi
    
    local backup_dir="$BACKUP_DIR/$backup_timestamp"
    
    if [[ ! -d "$backup_dir" ]]; then
        log_error "Backup directory not found: $backup_dir"
        list_backups
        exit 1
    fi
    
    log_info "Starting restore process..."
    log_info "Backup: $backup_timestamp"
    log_info "Component: $component"
    
    # Confirm restore operation
    echo -e "${YELLOW}WARNING: This will overwrite existing files!${NC}"
    read -p "Continue with restore? (y/N): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_info "Restore cancelled"
        exit 0
    fi
    
    if [[ "$component" == "all" ]]; then
        restore_all_files "$backup_dir"
    else
        restore_component "$component" "$backup_dir"
    fi
    
    log_info "Restore completed successfully"
    log_info "Note: Previous files were backed up with .pre-restore suffix"
}

# Run main function with all arguments
main "$@"