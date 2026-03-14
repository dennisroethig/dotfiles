#!/bin/bash
set -euo pipefail

# Dotfiles bootstrap script
# Usage: ./bootstrap.sh [--laptop | --headless | --mini]

PROFILE="${1:---laptop}"
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

info() { printf "\033[1;34m==>\033[0m %s\n" "$1"; }
success() { printf "\033[1;32m==>\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m==>\033[0m %s\n" "$1"; }

# --- 1. Xcode CLI tools ---
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Waiting for Xcode CLI tools installation..."
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
else
  success "Xcode CLI tools already installed"
fi

# --- 2. Homebrew ---
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  success "Homebrew already installed"
fi

# --- 3. Brewfile ---
info "Installing packages from Brewfile..."
if [ "$PROFILE" = "--headless" ]; then
  brew bundle --file="$DOTFILES_DIR/Brewfile" --no-cask
else
  brew bundle --file="$DOTFILES_DIR/Brewfile"
fi

# --- 4. Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  success "Oh My Zsh already installed"
fi

# --- 5. Symlink dotfiles ---
info "Symlinking dotfiles..."

link() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi
  if [ -f "$dst" ] && [ ! -L "$dst" ]; then
    warn "Backing up existing $dst to ${dst}.backup"
    mv "$dst" "${dst}.backup"
  fi
  ln -sf "$src" "$dst"
  success "Linked $dst"
}

link "$DOTFILES_DIR/configs/shell/zshrc"    "$HOME/.zshrc"
link "$DOTFILES_DIR/configs/shell/zprofile"  "$HOME/.zprofile"
link "$DOTFILES_DIR/configs/shell/devrc"     "$HOME/.devrc"
link "$DOTFILES_DIR/configs/git/gitconfig"   "$HOME/.gitconfig"
link "$DOTFILES_DIR/configs/ssh/config"      "$HOME/.ssh/config"

if [ "$PROFILE" != "--headless" ]; then
  link "$DOTFILES_DIR/configs/ghostty/config"  "$HOME/.config/ghostty/config"
  link "$DOTFILES_DIR/configs/zed/settings.json" "$HOME/.config/zed/settings.json"
fi

# --- 6. Wallpapers ---
if [ "$PROFILE" != "--headless" ] && [ -d "$DOTFILES_DIR/wallpapers" ]; then
  WALLPAPER_DIR="$HOME/Documents/Other/Wallpaper"
  mkdir -p "$WALLPAPER_DIR"
  cp -n "$DOTFILES_DIR/wallpapers/"* "$WALLPAPER_DIR/" 2>/dev/null || true
  success "Wallpapers copied to $WALLPAPER_DIR"

  # Set default wallpaper
  WALLPAPER="$WALLPAPER_DIR/wp11529903-imac-5k-wallpapers.jpg"
  if [ -f "$WALLPAPER" ]; then
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\"" 2>/dev/null || true
    success "Wallpaper set"
  fi
fi

# --- 7. App and system settings ---
if [ "$PROFILE" != "--headless" ]; then
  for plist_pair in \
    "raycast.plist:com.raycast.macos" \
    "dock.plist:com.apple.dock" \
    "windowmanager.plist:com.apple.WindowManager"; do
    file="${plist_pair%%:*}"
    domain="${plist_pair##*:}"
    if [ -f "$DOTFILES_DIR/configs/$file" ]; then
      defaults import "$domain" "$DOTFILES_DIR/configs/$file"
      success "Imported $domain settings"
    fi
  done
  killall Dock 2>/dev/null || true
fi

# --- 8. Secrets template ---
if [ ! -f "$HOME/.secrets" ]; then
  info "Creating ~/.secrets template..."
  cat > "$HOME/.secrets" << 'SECRETS'
# API keys and tokens — fill these in manually
# This file is sourced by .zshrc and must NOT be committed to git

export INTERVALS_API_KEY=""
export INTERVALS_ATHLETE_ID=""
export UP_BANK_API_TOKEN=""
SECRETS
  chmod 600 "$HOME/.secrets"
  warn "Fill in ~/.secrets with your API keys"
else
  success "~/.secrets already exists"
fi

# --- 7. SSH key ---
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  info "Generating SSH key..."
  ssh-keygen -t ed25519 -C "roethig.dennis@gmail.com" -f "$HOME/.ssh/id_ed25519" -N ""
  echo ""
  warn "Add this public key to GitHub:"
  echo ""
  cat "$HOME/.ssh/id_ed25519.pub"
  echo ""
else
  success "SSH key already exists"
fi

# --- 8. macOS defaults ---
if [ -f "$DOTFILES_DIR/macos/defaults.sh" ]; then
  info "Applying macOS defaults..."
  bash "$DOTFILES_DIR/macos/defaults.sh" "$PROFILE"
fi

# --- 9. Post-setup checklist ---
echo ""
echo "========================================="
echo "  Bootstrap complete!"
echo "========================================="
echo ""
echo "Manual steps remaining:"
echo "  [ ] Add SSH public key to GitHub (see above or: cat ~/.ssh/id_ed25519.pub)"
echo "  [ ] Run ./setup-ssh-access.sh to push SSH key to all other machines"
echo "  [ ] Fill in ~/.secrets with API keys"
echo "  [ ] Install Tailscale from the App Store (not Homebrew — better macOS integration)"
echo "  [ ] Open Zed → install Snazzy extension (Cmd+Shift+X, search 'snazzy')"
echo "  [ ] Install Claude Code: npm install -g @anthropic-ai/claude-code"
echo "  [ ] Clone workspace: git clone git@github.com:dennisroethig/claude.git ~/Projects/claude"
echo ""
