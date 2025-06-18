#!/bin/bash

# backup.sh - Safely backup existing dotfiles before making changes
# Usage: ./scripts/backup.sh [component]
#   component: specific config to backup (optional, defaults to all)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$DOTFILES_DIR/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

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

# Create backup directory structure
create_backup_structure() {
    local backup_session_dir="$BACKUP_DIR/$TIMESTAMP"
    mkdir -p "$backup_session_dir"
    echo "$backup_session_dir"
}

# Backup a single file if it exists
backup_file() {
    local source="$1"
    local dest="$2"
    
    if [[ -e "$source" ]]; then
        mkdir -p "$(dirname "$dest")"
        cp -r "$source" "$dest"
        log_info "Backed up: $source -> $dest"
        return 0
    else
        log_warn "File not found, skipping: $source"
        return 1
    fi
}

# Backup common dotfiles
backup_common_dotfiles() {
    local backup_session_dir="$1"
    local backed_up=0
    
    # Common dotfiles to backup
    declare -a dotfiles=(
        "$HOME/.zshrc"
        "$HOME/.bashrc" 
        "$HOME/.bash_profile"
        "$HOME/.profile"
        "$HOME/.gitconfig"
        "$HOME/.gitignore_global"
        "$HOME/.tmux.conf"
        "$HOME/.vimrc"
        "$HOME/.vim"
        "$HOME/.config/nvim"
        "$HOME/.oh-my-zsh"
        "$HOME/.aliases"
        "$HOME/.exports"
    )
    
    for dotfile in "${dotfiles[@]}"; do
        if backup_file "$dotfile" "$backup_session_dir$(basename "$dotfile")"; then
            ((backed_up++))
        fi
    done
    
    return $backed_up
}

# Backup specific component
backup_component() {
    local component="$1"
    local backup_session_dir="$2"
    
    case "$component" in
        "zsh")
            backup_file "$HOME/.zshrc" "$backup_session_dir/.zshrc"
            backup_file "$HOME/.oh-my-zsh" "$backup_session_dir/.oh-my-zsh"
            ;;
        "git")
            backup_file "$HOME/.gitconfig" "$backup_session_dir/.gitconfig"
            backup_file "$HOME/.gitignore_global" "$backup_session_dir/.gitignore_global"
            ;;
        "nvim"|"neovim")
            backup_file "$HOME/.config/nvim" "$backup_session_dir/.config/nvim"
            backup_file "$HOME/.vimrc" "$backup_session_dir/.vimrc"
            backup_file "$HOME/.vim" "$backup_session_dir/.vim"  
            ;;
        "tmux")
            backup_file "$HOME/.tmux.conf" "$backup_session_dir/.tmux.conf"
            ;;
        *)
            log_error "Unknown component: $component"
            log_info "Available components: zsh, git, nvim, tmux"
            exit 1
            ;;
    esac
}

main() {
    local component="${1:-all}"
    
    log_info "Starting backup process..."
    log_info "Timestamp: $TIMESTAMP"
    
    # Create backup session directory
    local backup_session_dir
    backup_session_dir=$(create_backup_structure)
    
    if [[ "$component" == "all" ]]; then
        log_info "Backing up all common dotfiles..."
        if backup_common_dotfiles "$backup_session_dir"; then
            log_info "Backup completed successfully"
            log_info "Backup location: $backup_session_dir"
        else
            log_warn "No files were backed up"
        fi
    else
        log_info "Backing up component: $component"
        backup_component "$component" "$backup_session_dir"
        log_info "Component backup completed"
        log_info "Backup location: $backup_session_dir"
    fi
    
    # Create backup manifest
    echo "Backup created: $(date)" > "$backup_session_dir/MANIFEST"
    echo "Component: $component" >> "$backup_session_dir/MANIFEST"
    echo "Files backed up:" >> "$backup_session_dir/MANIFEST"
    find "$backup_session_dir" -type f -not -name "MANIFEST" >> "$backup_session_dir/MANIFEST"
}

# Run main function with all arguments
main "$@"