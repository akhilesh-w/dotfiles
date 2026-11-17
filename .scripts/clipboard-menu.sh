#!/usr/bin/env bash
# Clipboard history (Super+Ctrl+V). History is recorded by the
# "wl-paste --watch cliphist store" watchers started from hyprland.lua.
set -euo pipefail

if [[ -z "$(cliphist list 2>/dev/null)" ]]; then
  notify-send 'Clipboard history' 'Nothing copied yet.'
  exit 0
fi

# Alt+Delete removes the highlighted entry instead of pasting it.
selected="$(cliphist list | rofi -dmenu -i -no-show-icons -p 'Clipboard' -display-columns 2 \
  -theme "$HOME/.config/rofi/menu.rasi" \
  -theme-str 'window { width: 640px; } listview { lines: 10; fixed-height: true; }' \
  -mesg 'Enter: copy   ·   Alt+Delete: forget entry' \
  -kb-custom-1 'Alt+Delete')" && status=0 || status=$?

case "$status" in
  0)  printf '%s' "$selected" | cliphist decode | wl-copy ;;
  10) printf '%s' "$selected" | cliphist delete && exec "$0" ;;
esac
