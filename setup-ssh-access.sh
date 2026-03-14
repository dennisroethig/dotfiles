#!/bin/bash
set -euo pipefail

# Distribute this machine's SSH key to all other machines in the SSH config.
# Run after bootstrap on a new Mac to enable cross-access.
#
# Usage: ./setup-ssh-access.sh
#
# You'll be prompted for each machine's password once. After that,
# key-based auth works and you won't need passwords again.

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SSH_CONFIG="$DOTFILES_DIR/configs/ssh/config"
CURRENT_HOSTNAME=$(hostname -s)

info() { printf "\033[1;34m==>\033[0m %s\n" "$1"; }
success() { printf "\033[1;32m==>\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m==>\033[0m %s\n" "$1"; }
fail() { printf "\033[1;31m==>\033[0m %s\n" "$1"; }

# Ensure we have an SSH key
if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
  echo "No SSH key found. Run bootstrap.sh first."
  exit 1
fi

# Parse hosts from SSH config (skip Tailscale aliases)
hosts=()
while IFS= read -r line; do
  host=$(echo "$line" | awk '{print $2}')
  # Skip Tailscale aliases (they're the same machines)
  if [[ "$host" == *-ts ]]; then
    continue
  fi
  hosts+=("$host")
done < <(grep "^Host " "$SSH_CONFIG")

echo ""
echo "This will copy your SSH key to the following machines:"
for host in "${hosts[@]}"; do
  ip=$(grep -A1 "^Host ${host}$" "$SSH_CONFIG" | grep HostName | awk '{print $2}')
  echo "  - $host ($ip)"
done
echo ""
read -rp "Continue? [y/N] " confirm
if [[ "$confirm" != [yY] ]]; then
  echo "Aborted."
  exit 0
fi

for host in "${hosts[@]}"; do
  ip=$(grep -A1 "^Host ${host}$" "$SSH_CONFIG" | grep HostName | awk '{print $2}')

  info "Checking $host ($ip)..."

  # Skip if we can already connect without a password
  if ssh -o BatchMode=yes -o ConnectTimeout=5 "$host" "echo ok" &>/dev/null; then
    success "$host — already accessible"
    continue
  fi

  # Check if host is reachable
  if ! ping -c1 -W2 "$ip" &>/dev/null; then
    warn "$host ($ip) — offline, skipping"
    continue
  fi

  info "Copying SSH key to $host (you'll be prompted for the password)..."
  if ssh-copy-id -i "$HOME/.ssh/id_ed25519.pub" "$host" 2>/dev/null; then
    success "$host — key installed"
  else
    fail "$host — failed (check password or SSH is enabled)"
  fi
done

echo ""
echo "========================================="
echo "  SSH access setup complete"
echo "========================================="
echo ""
echo "Test with: ssh mini, ssh mbp, etc."
echo ""
echo "If a machine was offline, power it on and re-run this script."
echo ""
