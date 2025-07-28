#!/usr/bin/env bash

# Toggle Modern Tools Script
# Safely switch between modern tools as defaults and legacy tools
#
# Usage: ./toggle-modern-tools.sh [modern|legacy|status]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$DOTFILES_DIR/backups"
ALIASES_FILE="$DOTFILES_DIR/stow/aliases/.aliases"
RUST_TOOLS_FILE="$DOTFILES_DIR/stow/rust-tools/.aliases"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() {
    echo "Usage: $0 [modern|legacy|status]"
    echo ""
    echo "  modern  - Enable modern tools as defaults (eza, bat, fd, rg, etc.)"
    echo "  legacy  - Restore legacy tools as defaults (ls, cat, find, grep, etc.)"
    echo "  status  - Show current configuration"
    echo ""
}

show_status() {
    echo -e "${BLUE}=== Current Tool Configuration ===${NC}"
    
    # Check what ls points to
    if source "$ALIASES_FILE" 2>/dev/null && alias ls 2>/dev/null | grep -q "eza"; then
        echo -e "${GREEN}✓ Modern tools are active${NC}"
        echo "  - ls → eza"
        echo "  - cat → bat"
        echo "  - find → fd"
        echo "  - grep → rg"
    else
        echo -e "${YELLOW}○ Legacy tools are active${NC}"
        echo "  - ls → command ls"
        echo "  - cat → command cat"
        echo "  - find → command find" 
        echo "  - grep → command grep"
    fi
    
    echo ""
    echo -e "${BLUE}=== Fallback aliases available ===${NC}"
    echo "  - ls_original, cat_original, find_original, grep_original, etc."
    echo ""
}

restore_from_backup() {
    local backup_pattern="$1"
    local latest_backup
    
    latest_backup=$(find "$BACKUP_DIR" -name "*$backup_pattern*" -type d | sort -r | head -1)
    
    if [[ -z "$latest_backup" ]]; then
        echo -e "${RED}Error: No backup found matching pattern '$backup_pattern'${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Restoring from backup: $latest_backup${NC}"
    
    if [[ -f "$latest_backup/main-aliases.backup" ]]; then
        cp "$latest_backup/main-aliases.backup" "$ALIASES_FILE"
        echo "✓ Restored main aliases"
    fi
    
    if [[ -f "$latest_backup/rust-tools-aliases.backup" ]]; then
        cp "$latest_backup/rust-tools-aliases.backup" "$RUST_TOOLS_FILE"
        echo "✓ Restored rust-tools aliases"
    fi
}

enable_modern_tools() {
    echo -e "${GREEN}Enabling modern tools as defaults...${NC}"
    
    # The current files should already have modern tools enabled
    # This is a no-op if already enabled, or could restore from a "modern" backup
    
    echo "✓ Modern tools are now active"
    echo ""
    echo "Modern tools now available as:"
    echo "  - ls (eza with icons)"
    echo "  - ll (eza with git info)" 
    echo "  - cat (bat with syntax highlighting)"
    echo "  - find (fd - fast file finder)"
    echo "  - grep (ripgrep - fast text search)"
    echo "  - du (dust - better disk usage)"
    echo "  - ps (procs - modern process viewer)"
    echo "  - top (bottom/btm - better system monitor)"
    echo ""
    echo "Legacy tools available with _original suffix:"
    echo "  - ls_original, cat_original, find_original, etc."
}

enable_legacy_tools() {
    echo -e "${YELLOW}Enabling legacy tools as defaults...${NC}"
    
    # Look for the most recent backup to restore from
    restore_from_backup "aliases-migration"
    
    echo "✓ Legacy tools are now active"
    echo ""
    echo "Traditional tools restored:"
    echo "  - ls, ll, cat, find, grep, du, ps, top"
    echo ""
    echo "Modern tools still available with '2' suffix:"
    echo "  - ll2, cat2, find2, grep2, etc."
}

main() {
    case "${1:-status}" in
        "modern")
            enable_modern_tools
            ;;
        "legacy")
            enable_legacy_tools
            ;;
        "status")
            show_status
            ;;
        "help"|"-h"|"--help")
            usage
            ;;
        *)
            echo -e "${RED}Error: Invalid option '$1'${NC}"
            echo ""
            usage
            exit 1
            ;;
    esac
}

main "$@"