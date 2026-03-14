#!/bin/bash
set -euo pipefail

# Grant macOS privacy permissions for apps.
# Must be run locally with sudo (can't be done over SSH without TTY).
#
# Usage: sudo ./setup-permissions.sh

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run with sudo:"
  echo "  sudo ./setup-permissions.sh"
  exit 1
fi

TCC_DB="/Library/Application Support/com.apple.TCC/TCC.db"

grant() {
  local service="$1"
  local client="$2"
  local client_type="${3:-0}"  # 0 = bundleID, 1 = path

  sqlite3 "$TCC_DB" "INSERT OR REPLACE INTO access (service, client, client_type, auth_value, auth_reason, auth_version, flags) VALUES ('$service', '$client', $client_type, 2, 3, 1, 0);" 2>/dev/null
  echo "  ✓ $client → $service"
}

echo "Granting privacy permissions..."
echo ""

echo "Raycast:"
grant kTCCServiceAccessibility com.raycast.macos
grant kTCCServiceSystemPolicyDesktopFolder com.raycast.macos
grant kTCCServiceSystemPolicyDocumentsFolder com.raycast.macos
grant kTCCServiceSystemPolicyDownloadsFolder com.raycast.macos
grant kTCCServiceSystemPolicyRemovableVolumes com.raycast.macos
grant kTCCServiceFileProviderDomain com.raycast.macos
grant kTCCServiceCalendar com.raycast.macos

echo ""
echo "Ghostty:"
grant kTCCServiceSystemPolicyDesktopFolder com.mitchellh.ghostty
grant kTCCServiceSystemPolicyDocumentsFolder com.mitchellh.ghostty
grant kTCCServiceSystemPolicyDownloadsFolder com.mitchellh.ghostty
grant kTCCServiceFileProviderDomain com.mitchellh.ghostty

echo ""
echo "iStat Menus:"
grant kTCCServiceBluetoothAlways com.bjango.istatmenus
grant kTCCServiceBluetoothAlways com.bjango.istatmenus.status

echo ""
echo "Done. Restart apps for changes to take effect."
