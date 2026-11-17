#!/usr/bin/env bash
# Bluetooth picker on top of bluetoothctl. Opens from the Waybar Bluetooth icon.
set -uo pipefail

menu() { "$HOME/.scripts/rofi-menu.sh" "$@"; }
notify() { notify-send -a 'Bluetooth' -i bluetooth "$@"; }

powered() { bluetoothctl show 2>/dev/null | grep -q 'Powered: yes'; }
connected() { bluetoothctl info "$1" 2>/dev/null | grep -q 'Connected: yes'; }

if ! bluetoothctl show >/dev/null 2>&1; then
  notify 'No Bluetooth adapter found'
  exit 0
fi

if ! powered; then
  choice="$(printf '%s\t%s\n' '󰂯' 'Turn Bluetooth on' | menu 'Bluetooth off')" || exit 0
  rfkill unblock bluetooth 2>/dev/null
  bluetoothctl power on >/dev/null && notify 'Bluetooth turned on'
  exit 0
fi

declare -A mac_for=()
lines=()

while read -r _ mac name; do
  [[ -z "$mac" ]] && continue
  if connected "$mac"; then
    label="$name   ·  connected"; icon='󰂱'
  else
    label="$name"; icon='󰂯'
  fi
  mac_for["$label"]="$mac"
  lines+=("$icon"$'\t'"$label")
done < <(bluetoothctl devices Paired 2>/dev/null)

choice="$(
  {
    ((${#lines[@]})) && printf '%s\n' "${lines[@]}"
    printf '%s\t%s\n' '󰂰' 'Pair a new device' '󰂲' 'Turn Bluetooth off'
  } | menu 'Bluetooth'
)" || exit 0

case "$choice" in
  'Turn Bluetooth off')
    bluetoothctl power off >/dev/null && notify 'Bluetooth turned off'; exit 0 ;;
  'Pair a new device')
    notify 'Scanning for devices' 'Put your device in pairing mode. This takes about 8 seconds.'
    bluetoothctl --timeout 8 scan on >/dev/null 2>&1

    declare -A new_mac=()
    new_lines=()
    paired="$(bluetoothctl devices Paired 2>/dev/null)"
    while read -r _ mac name; do
      [[ -z "$mac" || "$paired" == *"$mac"* ]] && continue
      # Skip nameless devices, which only show their address.
      [[ "$name" == "${mac//:/-}" ]] && continue
      new_mac["$name"]="$mac"
      new_lines+=('󰂯'$'\t'"$name")
    done < <(bluetoothctl devices 2>/dev/null)

    if ((${#new_lines[@]} == 0)); then
      notify 'No new devices found'
      exit 0
    fi
    pick="$(printf '%s\n' "${new_lines[@]}" | menu 'Pair')" || exit 0
    mac="${new_mac[$pick]}"
    if bluetoothctl pair "$mac" >/dev/null 2>&1 && bluetoothctl trust "$mac" >/dev/null 2>&1 \
       && bluetoothctl connect "$mac" >/dev/null 2>&1; then
      notify "Connected to $pick"
    else
      notify -u critical "Could not pair with $pick"
    fi
    exit 0 ;;
esac

mac="${mac_for[$choice]:-}"
[[ -n "$mac" ]] || exit 0
name="${choice%   ·  connected}"

if connected "$mac"; then
  action="$(printf '%s\t%s\n' '󰂲' 'Disconnect' '󰆴' 'Forget device' | menu "$name")" || exit 0
  case "$action" in
    'Disconnect')    bluetoothctl disconnect "$mac" >/dev/null && notify "Disconnected $name" ;;
    'Forget device') bluetoothctl remove "$mac" >/dev/null && notify "Forgot $name" ;;
  esac
else
  if bluetoothctl connect "$mac" >/dev/null 2>&1; then
    notify "Connected to $name"
  else
    notify -u critical "Could not connect to $name" 'Is it turned on and nearby?'
  fi
fi
