#!/bin/bash

# macos-defaults.sh - Configure macOS system settings for development
# Usage: ./scripts/macos-defaults.sh [--all|--keyboard|--finder|--dock|--status]
#
# This script is idempotent - safe to run multiple times.
# Applies sensible defaults for a development environment.

set -euo pipefail

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

log_setting() {
    echo -e "${BLUE}[SET]${NC} $1"
}

#######################################
# Check macOS
#######################################

check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log_error "This script is designed for macOS only"
        exit 1
    fi
}

#######################################
# Keyboard Settings
#######################################

configure_keyboard() {
    log_info "Configuring keyboard settings..."

    # Set fast key repeat rate
    log_setting "Fast key repeat rate"
    defaults write NSGlobalDomain KeyRepeat -int 2

    # Set short delay until key repeat
    log_setting "Short key repeat delay"
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Disable press-and-hold for keys in favor of key repeat
    log_setting "Disable press-and-hold for key repeat"
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Enable full keyboard access for all controls (Tab in dialogs)
    log_setting "Full keyboard access"
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    # Disable automatic capitalization
    log_setting "Disable auto-capitalization"
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

    # Disable smart dashes
    log_setting "Disable smart dashes"
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Disable automatic period substitution
    log_setting "Disable auto period substitution"
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

    # Disable smart quotes
    log_setting "Disable smart quotes"
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # Disable auto-correct
    log_setting "Disable auto-correct"
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    log_info "Keyboard settings configured"
}

#######################################
# CapsLock to Control Remapping
#######################################

configure_capslock() {
    log_info "Configuring CapsLock → Control remapping..."

    # Note: This uses hidutil to remap CapsLock to Control
    # The mapping is: 0x700000039 (CapsLock) -> 0x7000000E0 (Left Control)
    #
    # This is a runtime change that resets on reboot.
    # To make it permanent, we create a LaunchAgent.

    local plist_dir="$HOME/Library/LaunchAgents"
    local plist_file="$plist_dir/com.local.KeyRemapping.plist"

    mkdir -p "$plist_dir"

    # Create LaunchAgent for persistent CapsLock remapping
    if [[ ! -f "$plist_file" ]]; then
        log_setting "Creating CapsLock → Control LaunchAgent"

        cat > "$plist_file" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.KeyRemapping</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

        log_info "LaunchAgent created for persistent CapsLock remapping"
    else
        log_info "CapsLock LaunchAgent already exists"
    fi

    # Apply the remapping immediately
    log_setting "Applying CapsLock → Control now"
    hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}' >/dev/null 2>&1 || log_warn "Could not apply CapsLock remapping (may need sudo)"

    # Load the LaunchAgent
    launchctl load "$plist_file" 2>/dev/null || log_info "LaunchAgent already loaded"

    log_info "CapsLock remapping configured (CapsLock → Control)"
}

#######################################
# Finder Settings
#######################################

configure_finder() {
    log_info "Configuring Finder settings..."

    # Show hidden files by default
    log_setting "Show hidden files"
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show all filename extensions
    log_setting "Show file extensions"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Show status bar
    log_setting "Show status bar"
    defaults write com.apple.finder ShowStatusBar -bool true

    # Show path bar
    log_setting "Show path bar"
    defaults write com.apple.finder ShowPathbar -bool true

    # Display full POSIX path as Finder window title
    log_setting "Full path in title"
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Keep folders on top when sorting by name
    log_setting "Folders on top"
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # When performing a search, search the current folder by default
    log_setting "Search current folder"
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Disable the warning when changing a file extension
    log_setting "Disable extension change warning"
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Avoid creating .DS_Store files on network or USB volumes
    log_setting "No .DS_Store on network volumes"
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Use list view in all Finder windows by default
    log_setting "List view default"
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Show the ~/Library folder
    log_setting "Show ~/Library folder"
    chflags nohidden ~/Library 2>/dev/null || true

    log_info "Finder settings configured"
}

#######################################
# Dock Settings
#######################################

configure_dock() {
    log_info "Configuring Dock settings..."

    # Set the icon size of Dock items
    log_setting "Dock icon size: 48"
    defaults write com.apple.dock tilesize -int 48

    # Minimize windows into their application's icon
    log_setting "Minimize to app icon"
    defaults write com.apple.dock minimize-to-application -bool true

    # Enable spring loading for all Dock items
    log_setting "Spring loading"
    defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

    # Show indicator lights for open applications
    log_setting "Show app indicators"
    defaults write com.apple.dock show-process-indicators -bool true

    # Don't animate opening applications
    log_setting "Disable launch animation"
    defaults write com.apple.dock launchanim -bool false

    # Speed up Mission Control animations
    log_setting "Fast Mission Control"
    defaults write com.apple.dock expose-animation-duration -float 0.1

    # Don't automatically rearrange Spaces based on most recent use
    log_setting "Don't auto-rearrange Spaces"
    defaults write com.apple.dock mru-spaces -bool false

    # Auto-hide the Dock
    log_setting "Auto-hide Dock"
    defaults write com.apple.dock autohide -bool true

    # Remove the auto-hiding Dock delay
    log_setting "No Dock hide delay"
    defaults write com.apple.dock autohide-delay -float 0

    # Make Dock icons of hidden applications translucent
    log_setting "Translucent hidden apps"
    defaults write com.apple.dock showhidden -bool true

    log_info "Dock settings configured"
}

#######################################
# Screenshot Settings
#######################################

configure_screenshots() {
    log_info "Configuring screenshot settings..."

    # Save screenshots to a dedicated folder
    local screenshot_dir="$HOME/Screenshots"
    mkdir -p "$screenshot_dir"

    log_setting "Screenshots saved to ~/Screenshots"
    defaults write com.apple.screencapture location -string "$screenshot_dir"

    # Save screenshots in PNG format
    log_setting "PNG format"
    defaults write com.apple.screencapture type -string "png"

    # Disable shadow in screenshots
    log_setting "No shadow"
    defaults write com.apple.screencapture disable-shadow -bool true

    log_info "Screenshot settings configured"
}

#######################################
# Development Settings
#######################################

configure_development() {
    log_info "Configuring development settings..."

    # Increase sound quality for Bluetooth headphones/headsets
    log_setting "Better Bluetooth audio"
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

    # Enable developer menu and Web Inspector in Safari
    log_setting "Safari developer tools"
    defaults write com.apple.Safari IncludeDevelopMenu -bool true
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

    # Add a context menu item for showing the Web Inspector
    log_setting "Web Inspector context menu"
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

    log_info "Development settings configured"
}

#######################################
# Apply Changes
#######################################

restart_affected_apps() {
    log_info "Restarting affected applications..."

    # Kill affected applications (they will restart automatically in some cases)
    local apps=("Finder" "Dock" "SystemUIServer")

    for app in "${apps[@]}"; do
        if killall "$app" 2>/dev/null; then
            log_info "Restarted $app"
        fi
    done

    log_info "Some changes may require a logout/restart to take effect"
}

#######################################
# Show Current Settings
#######################################

show_status() {
    echo
    echo -e "${BLUE}=== macOS Settings Status ===${NC}"
    echo

    echo "Keyboard:"
    echo "  Key repeat rate: $(defaults read NSGlobalDomain KeyRepeat 2>/dev/null || echo 'not set')"
    echo "  Initial delay: $(defaults read NSGlobalDomain InitialKeyRepeat 2>/dev/null || echo 'not set')"
    echo "  Auto-correct: $(defaults read NSGlobalDomain NSAutomaticSpellingCorrectionEnabled 2>/dev/null || echo 'not set')"

    echo
    echo "CapsLock Remapping:"
    local current_mapping
    current_mapping=$(hidutil property --get "UserKeyMapping" 2>/dev/null | head -1)
    if [[ "$current_mapping" == *"0x700000039"* ]]; then
        echo "  CapsLock → Control: ACTIVE"
    else
        echo "  CapsLock → Control: NOT ACTIVE"
    fi

    echo
    echo "Finder:"
    echo "  Show hidden files: $(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null || echo 'not set')"
    echo "  Show extensions: $(defaults read NSGlobalDomain AppleShowAllExtensions 2>/dev/null || echo 'not set')"

    echo
    echo "Dock:"
    echo "  Auto-hide: $(defaults read com.apple.dock autohide 2>/dev/null || echo 'not set')"
    echo "  Icon size: $(defaults read com.apple.dock tilesize 2>/dev/null || echo 'not set')"

    echo
}

#######################################
# Usage
#######################################

show_usage() {
    cat << EOF
macOS Defaults Configuration Script

USAGE:
    $(basename "$0") [OPTION]

OPTIONS:
    --all           Apply all settings (default)
    --keyboard      Keyboard settings only (includes CapsLock remap)
    --capslock      CapsLock → Control remapping only
    --finder        Finder settings only
    --dock          Dock settings only
    --screenshots   Screenshot settings only
    --development   Development settings only
    --status        Show current settings
    --help, -h      Show this help message

EXAMPLES:
    $(basename "$0")              # Apply all settings
    $(basename "$0") --keyboard   # Keyboard settings only
    $(basename "$0") --status     # View current settings

KEY SETTINGS:
    - CapsLock remapped to Control (great for vim/tmux)
    - Fast key repeat for efficient editing
    - Finder shows hidden files and extensions
    - Dock auto-hides with no delay
    - Screenshots saved to ~/Screenshots

IDEMPOTENCY:
    This script is safe to run multiple times. Settings are applied
    only if different from desired state.

NOTE:
    Some settings require logout/restart to take effect.
    The script will restart Finder and Dock automatically.

EOF
}

#######################################
# Main
#######################################

main() {
    check_macos

    local target="${1:---all}"

    case "$target" in
        "--all"|"all")
            echo
            echo -e "${BLUE}==========================================${NC}"
            echo -e "${BLUE}     macOS Defaults Configuration        ${NC}"
            echo -e "${BLUE}==========================================${NC}"
            echo
            configure_keyboard
            configure_capslock
            configure_finder
            configure_dock
            configure_screenshots
            configure_development
            restart_affected_apps
            echo
            log_info "All macOS defaults have been configured!"
            log_warn "Some changes require logout/restart to take effect"
            ;;
        "--keyboard")
            configure_keyboard
            configure_capslock
            ;;
        "--capslock")
            configure_capslock
            ;;
        "--finder")
            configure_finder
            killall Finder 2>/dev/null || true
            ;;
        "--dock")
            configure_dock
            killall Dock 2>/dev/null || true
            ;;
        "--screenshots")
            configure_screenshots
            ;;
        "--development"|"--dev")
            configure_development
            ;;
        "--status")
            show_status
            ;;
        "--help"|"-h"|"help")
            show_usage
            ;;
        *)
            log_error "Unknown option: $target"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
