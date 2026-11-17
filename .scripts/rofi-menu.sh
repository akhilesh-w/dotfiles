#!/usr/bin/env bash
# Shared Rofi action menu with properly sized Nerd Font icons.
#
#   printf '%s\t%s\n' '󰌾' 'Lock screen' '⏻' 'Shut down' | rofi-menu.sh 'Power' [extra rofi args]
#
# Each input line is "ICON<TAB>LABEL". Prints the chosen LABEL, or exits 1 on cancel.
set -euo pipefail

prompt="${1:-Menu}"
shift || true

icons=()
labels=()
while IFS=$'\t' read -r icon label; do
  [[ -z "${label:-}" ]] && { label="$icon"; icon=""; }
  icons+=("$icon")
  labels+=("$label")
done

((${#labels[@]} > 0)) || exit 1

escape() {
  local s="$1"
  s="${s//&/&amp;}"; s="${s//</&lt;}"; s="${s//>/&gt;}"
  printf '%s' "$s"
}

index="$(
  for i in "${!labels[@]}"; do
    printf "<span font_family='FiraCode Nerd Font' size='14pt' rise='-1pt' foreground='#ffcfdf'>%s</span>   %s\n" \
      "$(escape "${icons[$i]}")" "$(escape "${labels[$i]}")"
  done | rofi -dmenu -i -no-show-icons -markup-rows -no-custom -format i \
      -p "$prompt" -theme "$HOME/.config/rofi/menu.rasi" "$@"
)" || exit 1

[[ "$index" =~ ^[0-9]+$ ]] || exit 1
printf '%s\n' "${labels[$index]}"
