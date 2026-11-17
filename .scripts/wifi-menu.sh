#!/usr/bin/env bash
# Wi-Fi picker on top of NetworkManager. Opens from the Waybar network icon.
set -uo pipefail

menu() { "$HOME/.scripts/rofi-menu.sh" "$@"; }
notify() { notify-send -a 'Wi-Fi' -i network-wireless "$@"; }

signal_icon() {
  local s="$1"
  if   ((s >= 75)); then printf '󰤨'
  elif ((s >= 50)); then printf '󰤥'
  elif ((s >= 25)); then printf '󰤢'
  else                   printf '󰤟'
  fi
}

ask_password() {
  rofi -dmenu -no-show-icons -password -p "$1" -theme "$HOME/.config/rofi/menu.rasi" \
    -theme-str 'listview { enabled: false; } entry { placeholder: "Password"; }' </dev/null
}

if [[ "$(nmcli radio wifi)" != enabled ]]; then
  choice="$(printf '%s\t%s\n' '󰖩' 'Turn Wi-Fi on' '󰒓' 'Advanced settings' | menu 'Wi-Fi off')" || exit 0
  case "$choice" in
    'Turn Wi-Fi on')     nmcli radio wifi on && notify 'Wi-Fi turned on' ;;
    'Advanced settings') nm-connection-editor ;;
  esac
  exit 0
fi

declare -A ssid_for=() secure_for=()
lines=()
seen=""

# One row per network name (strongest access point), strongest first.
while IFS=: read -r inuse signal security ssid; do
  [[ -z "$ssid" ]] && continue
  case $'\n'"$seen" in *$'\n'"$ssid"$'\n'*) continue ;; esac
  seen+="$ssid"$'\n'

  label="$ssid"
  [[ "$inuse" == '*' ]] && label="$ssid   ·  connected"
  [[ -n "$security" && "$security" != '--' && "$inuse" != '*' ]] && label="$ssid   ·  secured"

  ssid_for["$label"]="$ssid"
  secure_for["$label"]=$([[ -n "$security" && "$security" != '--' ]] && echo 1 || echo 0)
  lines+=("$(signal_icon "$signal")"$'\t'"$label")
done < <(nmcli -t -e no -f IN-USE,SIGNAL,SECURITY,SSID dev wifi list --rescan no 2>/dev/null | sort -t: -k2,2nr)

choice="$(
  {
    printf '%s\n' "${lines[@]}"
    printf '%s\t%s\n' '󰑐' 'Rescan networks' '󰖪' 'Turn Wi-Fi off' '󰒓' 'Advanced settings'
  } | menu 'Wi-Fi' -theme-str 'listview { lines: 10; }'
)" || exit 0

case "$choice" in
  'Rescan networks')
    notify 'Scanning for networks'; nmcli dev wifi list --rescan yes >/dev/null 2>&1; exec "$0" ;;
  'Turn Wi-Fi off')
    nmcli radio wifi off && notify 'Wi-Fi turned off'; exit 0 ;;
  'Advanced settings')
    exec nm-connection-editor ;;
esac

ssid="${ssid_for[$choice]:-}"
[[ -n "$ssid" ]] || exit 0

if [[ "$choice" == *'·  connected' ]]; then
  action="$(printf '%s\t%s\n' '󰖪' 'Disconnect' '󰆴' 'Forget network' | menu "$ssid")" || exit 0
  case "$action" in
    'Disconnect')     nmcli con down id "$ssid" >/dev/null 2>&1 && notify "Disconnected from $ssid" ;;
    'Forget network') nmcli con delete id "$ssid" >/dev/null 2>&1 && notify "Forgot $ssid" ;;
  esac
  exit 0
fi

# Saved network: just bring it up.
if nmcli -t -f NAME con show | grep -Fxq -- "$ssid"; then
  if nmcli con up id "$ssid" >/dev/null 2>&1; then
    notify "Connected to $ssid"
    exit 0
  fi
fi

if [[ "${secure_for[$choice]}" == 1 ]]; then
  password="$(ask_password "$ssid")" || exit 0
  [[ -n "$password" ]] || exit 0
  if out="$(nmcli dev wifi connect "$ssid" password "$password" 2>&1)"; then
    notify "Connected to $ssid"
  else
    notify -u critical "Could not connect to $ssid" "$out"
  fi
else
  if out="$(nmcli dev wifi connect "$ssid" 2>&1)"; then
    notify "Connected to $ssid"
  else
    notify -u critical "Could not connect to $ssid" "$out"
  fi
fi
