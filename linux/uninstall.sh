#!/usr/bin/env bash

set -euo pipefail

BIN_PATH="$HOME/.local/bin/pikvm-launcher"
DESKTOP_PATH="$HOME/.local/share/applications/pikvm-launcher.desktop"
DATA_DIR="$HOME/.local/share/pikvm-launcher"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pikvm-launcher"

rm -f "$BIN_PATH"
rm -f "$DESKTOP_PATH"
rm -rf "$DATA_DIR"

if [[ "${1:-}" == "--purge" ]]; then
    rm -rf "$CONFIG_DIR"
    CONFIG_STATUS="removed"
else
    CONFIG_STATUS="kept"
fi

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi

cat <<DONE
Uninstalled PiKVM Linux launcher.

Config was $CONFIG_STATUS:
  $CONFIG_DIR

To remove config too, run:
  ./linux/uninstall.sh --purge
DONE
