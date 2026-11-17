#!/usr/bin/env bash
set -euo pipefail

choice="$(printf '%s\t%s\n' \
  '󰌾' 'Lock screen' \
  '󰤄' 'Suspend' \
  '󰜉' 'Restart computer' \
  '⏻' 'Shut down computer' \
  '󰗼' 'Leave Hyprland' \
  | "$HOME/.scripts/rofi-menu.sh" 'Power')" || exit 0

case "$choice" in
  'Lock screen')        hyprlock ;;
  'Suspend')            systemctl suspend ;;
  'Restart computer')   systemctl reboot ;;
  'Shut down computer') systemctl poweroff ;;
  'Leave Hyprland')     "$HOME/.scripts/exit-hyprland.sh" ;;
esac
