#!/bin/bash
# macOS system preferences
# Usage: defaults.sh [--laptop | --headless | --mini]

PROFILE="${1:---laptop}"

echo "Applying macOS defaults..."

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 48

# Finder
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # Search current folder by default

# Keyboard
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Screenshots
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# Trackpad (laptop only)
if [ "$PROFILE" = "--laptop" ]; then
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
fi

# Restart affected apps
killall Dock Finder 2>/dev/null || true

echo "macOS defaults applied. Some changes may require a logout/restart."
