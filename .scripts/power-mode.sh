#!/usr/bin/env bash
# Power profiles (power-profiles-daemon).
#   power-mode.sh            pick from a menu (right-click on the Waybar icon, quick actions)
#   power-mode.sh --cycle    saver -> balanced -> performance -> saver (left-click)
#   power-mode.sh --waybar   print the state as JSON for the Waybar icon
set -uo pipefail

current="$(powerprofilesctl get 2>/dev/null)"

pretty() {
  case "$1" in
    power-saver) echo 'Power saver' ;;
    balanced)    echo 'Balanced' ;;
    performance) echo 'Performance' ;;
    *)           echo "$1" ;;
  esac
}

apply() {
  if powerprofilesctl set "$1" 2>/dev/null; then
    notify-send -a 'Power mode' -i battery "Power mode: $(pretty "$1")"
  else
    notify-send -a 'Power mode' -u critical "Could not switch to $(pretty "$1")"
  fi
  pkill -RTMIN+8 waybar
}

case "${1:-}" in
  --waybar)
    case "$current" in
      power-saver) icon='󰾆' ;;
      performance) icon='󰓅' ;;
      *)           icon='󰾅' ;;
    esac
    printf '{"text": "%s", "class": "%s", "tooltip": "Power mode: %s\\nClick to cycle   Right-click: menu"}\n' \
      "$icon" "$current" "$(pretty "$current")"
    exit 0 ;;
  --cycle)
    case "$current" in
      power-saver) apply balanced ;;
      balanced)    apply performance ;;
      *)           apply power-saver ;;
    esac
    exit 0 ;;
esac

mark() { [[ "$current" == "$1" ]] && printf '   ·  current'; }

choice="$(printf '%s\t%s\n' \
  '󰾆' "Power saver$(mark power-saver)" \
  '󰾅' "Balanced$(mark balanced)" \
  '󰓅' "Performance$(mark performance)" \
  | "$HOME/.scripts/rofi-menu.sh" 'Power mode')" || exit 0

case "$choice" in
  'Power saver'*) apply power-saver ;;
  'Balanced'*)    apply balanced ;;
  'Performance'*) apply performance ;;
esac
