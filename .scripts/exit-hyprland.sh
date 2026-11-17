#!/usr/bin/env bash
# Confirm before leaving Hyprland. Super+M used to exit immediately.
choice="$(printf '%s\t%s\n' \
  '󰜺' 'No, stay' \
  '󰗼' 'Yes, exit Hyprland' \
  | "$HOME/.scripts/rofi-menu.sh" 'Exit Hyprland?')" || exit 0
[[ "$choice" == Yes,* ]] || exit 0
hyprctl dispatch 'hl.dsp.exit()'
