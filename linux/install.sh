#!/usr/bin/env bash

set -euo pipefail

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    echo "Do not run this installer as root or with sudo."
    echo "It installs per-user files into ~/.local and ~/.config."
    echo "Run:"
    echo "  ./linux/install.sh"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
DATA_DIR="$HOME/.local/share/pikvm-launcher"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pikvm-launcher"

BIN_PATH="$BIN_DIR/pikvm-launcher"
DESKTOP_PATH="$APP_DIR/pikvm-launcher.desktop"
CONFIG_PATH="$CONFIG_DIR/config"

mkdir -p "$BIN_DIR" "$APP_DIR" "$DATA_DIR" "$CONFIG_DIR"

install -m 755 "$SCRIPT_DIR/pikvm-launcher" "$BIN_PATH"

# Prefer PNG for Linux desktop environments.
# Keep the ICO as a fallback because this repo also supports Windows launchers.
PNG_ICON_SOURCE="$REPO_ROOT/pi.png"
ICO_ICON_SOURCE="$REPO_ROOT/pikvm-light.ico"
ICON_PATH="computer"

if [[ -f "$PNG_ICON_SOURCE" ]]; then
    install -m 644 "$PNG_ICON_SOURCE" "$DATA_DIR/pikvm-launcher.png"
    ICON_PATH="$DATA_DIR/pikvm-launcher.png"
elif [[ -f "$ICO_ICON_SOURCE" ]]; then
    install -m 644 "$ICO_ICON_SOURCE" "$DATA_DIR/pikvm-light.ico"
    ICON_PATH="$DATA_DIR/pikvm-light.ico"
fi

sed \
    -e "s|@BIN_PATH@|$BIN_PATH|g" \
    -e "s|@ICON_PATH@|$ICON_PATH|g" \
    "$SCRIPT_DIR/pikvm-launcher.desktop" > "$DESKTOP_PATH"

chmod 644 "$DESKTOP_PATH"

if [[ ! -f "$CONFIG_PATH" ]]; then
    install -m 644 "$SCRIPT_DIR/config.example" "$CONFIG_PATH"
    CONFIG_STATUS="created"
else
    CONFIG_STATUS="kept existing"
fi

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
fi

cat <<DONE
Installed PiKVM Linux launcher.

Launcher:
  $BIN_PATH

Desktop entry:
  $DESKTOP_PATH

Config:
  $CONFIG_PATH ($CONFIG_STATUS)

Test from terminal:
  $BIN_PATH --dry-run

Launch:
  $BIN_PATH

If your app menu does not show PiKVM immediately, log out/in or restart your desktop shell.
DONE
