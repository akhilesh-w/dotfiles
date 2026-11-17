#!/usr/bin/env bash
# Quick actions (Super+Space).
set -euo pipefail

choice="$(printf '%s\t%s\n' \
  '󰀻' 'Applications' \
  '󰅌' 'Clipboard history' \
  '󰖩' 'Wi-Fi' \
  '󰂯' 'Bluetooth' \
  '󰖔' 'Night light' \
  '󰾅' 'Power mode' \
  '󰢮' 'NVIDIA GPU on/off' \
  '󰸉' 'Choose wallpaper' \
  '󰉏' 'Open wallpaper folder' \
  '󰌌' 'Keyboard shortcuts' \
  '󰌾' 'Lock screen' \
  '⏻' 'Power menu' \
  '󰑐' 'Reload Waybar' \
  | "$HOME/.scripts/rofi-menu.sh" 'Quick actions' -theme-str 'listview { lines: 13; }')" || exit 0

case "$choice" in
  'Applications')          rofi -show drun ;;
  'Clipboard history')     "$HOME/.scripts/clipboard-menu.sh" ;;
  'Wi-Fi')                 "$HOME/.scripts/wifi-menu.sh" ;;
  'Bluetooth')             "$HOME/.scripts/bluetooth-menu.sh" ;;
  'Night light')           "$HOME/.scripts/night-light.sh" ;;
  'Power mode')            "$HOME/.scripts/power-mode.sh" ;;
  'NVIDIA GPU on/off')     "$HOME/.scripts/gpu-toggle.sh" ;;
  'Choose wallpaper')      "$HOME/.scripts/wallpaper-picker.sh" ;;
  'Open wallpaper folder') mkdir -p "$HOME/Pictures/Wallpapers" && xdg-open "$HOME/Pictures/Wallpapers" ;;
  'Keyboard shortcuts')    "$HOME/.scripts/shortcuts.sh" ;;
  'Lock screen')           hyprlock ;;
  'Power menu')            "$HOME/.scripts/power-menu.sh" ;;
  'Reload Waybar')         pkill -SIGUSR2 waybar ;;
esac
