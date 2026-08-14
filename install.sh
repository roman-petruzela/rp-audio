#!/usr/bin/env bash
# rp-audio — installs into the current user's XDG dirs and enables the
# systemd user service. Safe to re-run: existing user config
# (blacklist.conf, rp-audio.conf) is never overwritten.
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rp-audio"
WP_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wireplumber/wireplumber.conf.d"
SYSTEMD_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

ENABLE_SERVICE=1
for arg in "$@"; do
    case "$arg" in
        --no-enable) ENABLE_SERVICE=0 ;;
        -h|--help)
            echo "Usage: $0 [--no-enable]"
            echo "  --no-enable   install files but don't enable/start the systemd service"
            exit 0
            ;;
        *) echo "install.sh: unknown argument '$arg'" >&2; exit 1 ;;
    esac
done

mkdir -p "$BIN_DIR" "$CONF_DIR" "$WP_CONF_DIR" "$SYSTEMD_DIR"

install -m 755 "$SRC_DIR/bin/rp-audio" "$BIN_DIR/rp-audio"
install -m 644 "$SRC_DIR/wireplumber.conf.d/51-rp-audio.conf" "$WP_CONF_DIR/51-rp-audio.conf"
install -m 644 "$SRC_DIR/systemd/rp-audio.service" "$SYSTEMD_DIR/rp-audio.service"

for f in blacklist.conf rp-audio.conf; do
    dest="$CONF_DIR/$f"
    [[ -e "$dest" ]] || install -m 644 "$SRC_DIR/config/$f" "$dest"
done

command -v systemctl >/dev/null 2>&1 && systemctl --user daemon-reload

if (( ENABLE_SERVICE )); then
    systemctl --user enable --now rp-audio.service
    echo "rp-audio installed and service started."
else
    echo "rp-audio installed. Enable the service with:"
    echo "  systemctl --user enable --now rp-audio.service"
fi

echo "Restart WirePlumber to pick up the config snippet: systemctl --user restart wireplumber"
