#!/usr/bin/env bash
# rp-audio — removes installed files. User config in ~/.config/rp-audio is
# kept unless --purge is given.
set -euo pipefail

BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rp-audio"
WP_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wireplumber/wireplumber.conf.d"
SYSTEMD_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

PURGE=0
for arg in "$@"; do
    case "$arg" in
        --purge) PURGE=1 ;;
        -h|--help)
            echo "Usage: $0 [--purge]"
            echo "  --purge   also remove $CONF_DIR"
            exit 0
            ;;
        *) echo "uninstall.sh: unknown argument '$arg'" >&2; exit 1 ;;
    esac
done

if command -v systemctl >/dev/null 2>&1; then
    systemctl --user disable --now rp-audio.service 2>/dev/null || true
fi

rm -f "$BIN_DIR/rp-audio" "$WP_CONF_DIR/51-rp-audio.conf" "$SYSTEMD_DIR/rp-audio.service"
command -v systemctl >/dev/null 2>&1 && systemctl --user daemon-reload

if (( PURGE )); then
    rm -rf "$CONF_DIR"
fi

echo "rp-audio removed."
