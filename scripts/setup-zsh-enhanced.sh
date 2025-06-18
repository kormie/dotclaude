#!/bin/bash

# Enhanced Zsh Setup Script
# Installs Oh-My-Zsh and plugins alongside existing configuration

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
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

# Safety check
if [[ ! -f "$(dirname "$0")/backup.sh" ]]; then
    log_error "Backup script not found. Please run from dotfiles directory."
    exit 1
fi

# Ensure we have a backup
log_step "Creating safety backup..."
./scripts/backup.sh

# Check if Oh-My-Zsh is already installed
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log_warn "Oh-My-Zsh is already installed. Skipping installation."
else
    log_step "Installing Oh-My-Zsh..."
    # Use unattended installation to avoid interactive prompts
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_info "Oh-My-Zsh installed successfully"
fi

# Install useful plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    log_step "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    log_info "zsh-autosuggestions installed"
else
    log_info "zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    log_step "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    log_info "zsh-syntax-highlighting installed"
else
    log_info "zsh-syntax-highlighting already installed"
fi

# Create toggle mechanism
log_step "Creating configuration toggle mechanism..."

# Create directories for toggle system
mkdir -p "$HOME/.config/dotfiles"

# Create toggle script
cat > "$HOME/.config/dotfiles/toggle-zsh.sh" << 'EOF'
#!/bin/bash

# Toggle between original and enhanced Zsh configuration

ORIGINAL_ZSHRC="$HOME/.zshrc.original"
ENHANCED_ZSHRC="$HOME/.zshrc.enhanced"
CURRENT_ZSHRC="$HOME/.zshrc"

case "${1:-status}" in
    "enhanced"|"new"|"ohmy")
        if [[ -f "$ENHANCED_ZSHRC" ]]; then
            cp "$CURRENT_ZSHRC" "$ORIGINAL_ZSHRC" 2>/dev/null || true
            cp "$ENHANCED_ZSHRC" "$CURRENT_ZSHRC"
            echo "Switched to enhanced Zsh configuration"
            echo "Restart your shell or run: exec zsh"
        else
            echo "Enhanced configuration not found at $ENHANCED_ZSHRC"
            exit 1
        fi
        ;;
    "original"|"old"|"basic")
        if [[ -f "$ORIGINAL_ZSHRC" ]]; then
            cp "$CURRENT_ZSHRC" "$ENHANCED_ZSHRC" 2>/dev/null || true
            cp "$ORIGINAL_ZSHRC" "$CURRENT_ZSHRC"
            echo "Switched to original Zsh configuration"
            echo "Restart your shell or run: exec zsh"
        else
            echo "Original configuration not found at $ORIGINAL_ZSHRC"
            exit 1
        fi
        ;;
    "status")
        echo "Current Zsh configuration status:"
        if grep -q "Oh-My-Zsh" "$CURRENT_ZSHRC" 2>/dev/null; then
            echo "  Currently using: Enhanced (Oh-My-Zsh)"
        else
            echo "  Currently using: Original"
        fi
        echo "  Original backup: $([[ -f "$ORIGINAL_ZSHRC" ]] && echo "Available" || echo "Not found")"
        echo "  Enhanced config: $([[ -f "$ENHANCED_ZSHRC" ]] && echo "Available" || echo "Not found")"
        echo ""
        echo "Usage:"
        echo "  $0 enhanced    - Switch to Oh-My-Zsh configuration"
        echo "  $0 original    - Switch to original configuration"
        echo "  $0 status      - Show current status"
        ;;
    *)
        echo "Usage: $0 {enhanced|original|status}"
        exit 1
        ;;
esac
EOF

chmod +x "$HOME/.config/dotfiles/toggle-zsh.sh"

# Save current zshrc as original
if [[ -f "$HOME/.zshrc" ]]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.original"
    log_info "Original .zshrc saved as .zshrc.original"
fi

log_step "Enhanced Zsh setup complete!"
log_info "Configuration files ready for deployment"
log_info ""
log_info "Next steps:"
log_info "1. Deploy with: ./scripts/stow-package.sh zsh"
log_info "2. Test in new terminal: exec zsh"
log_info "3. Toggle configs: ~/.config/dotfiles/toggle-zsh.sh"
log_info ""
log_warn "SAFETY: Original config backed up as ~/.zshrc.original"
log_warn "SAFETY: Use toggle script to switch back if needed"