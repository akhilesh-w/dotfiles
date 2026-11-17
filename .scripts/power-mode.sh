#!/usr/bin/env bash
# Pick a power profile (power-profiles-daemon). Also opens from the Waybar icon.
set -uo pipefail

current="$(powerprofilesctl get 2>/dev/null)"
mark() { [[ "$current" == "$1" ]] && printf '   ·  current'; }

choice="$(printf '%s\t%s\n' \
  '󰾆' "Power saver$(mark power-saver)" \
  '󰾅' "Balanced$(mark balanced)" \
  '󰓅' "Performance$(mark performance)" \
  | "$HOME/.scripts/rofi-menu.sh" 'Power mode')" || exit 0

case "$choice" in
  'Power saver'*) profile=power-saver ;;
  'Balanced'*)    profile=balanced ;;
  'Performance'*) profile=performance ;;
  *) exit 0 ;;
esac

if powerprofilesctl set "$profile" 2>/dev/null; then
  notify-send -a 'Power mode' -i battery "Power mode: ${choice%%   ·*}"
else
  notify-send -a 'Power mode' -u critical "Could not switch to ${choice%%   ·*}"
fi
