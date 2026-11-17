#!/usr/bin/env bash
# Searchable keyboard shortcut sheet (Super+Shift+/). Type to filter.
set -euo pipefail

shortcuts='ESSENTIAL
Super + Return        Open terminal
Super + D             Open app launcher
Super + Shift + D     Launch an app on the NVIDIA GPU (Steam games: launch normally)
Super + Space         Open quick actions
Super + Shift + /     Show this shortcut guide
Super + Ctrl + V      Clipboard history
Super + N             Show the last notification again
Super + Shift + N     Dismiss all notifications
Super + Shift + W     Change wallpaper with a smooth transition
Print                 Select an area, save it and copy it
Shift + Print         Screenshot the whole screen, save it and copy it
Super + Ctrl + L      Lock screen
Super + Shift + M     Leave Hyprland

VOICE
Hold F9               Push-to-talk recording
Super + Ctrl + X      Toggle voice recording

WINDOWS
Super + Q             Close focused window
Super + V             Toggle floating window
Super + P             Toggle pseudotile
Super + J             Toggle split direction
Super + Arrow keys    Focus a neighboring window
Super + Z             Drag focused window
Super + X             Resize focused window
Super + Shift + Arrow Resize focused window
Alt + Tab             Cycle applications

WORKSPACES
Super + 1 through 0   Switch to workspace 1 through 10
Super + Shift + 1..0  Move focused window to workspace
Super + S             Toggle special workspace
Super + Shift + S     Move focused window to special workspace

SYSTEM
Volume keys           Adjust or mute audio (shows a pop-up)
Brightness keys       Adjust display brightness (shows a pop-up)
Super + Ctrl + B      Open Brave'

escape() {
  local s="$1"
  s="${s//&/&amp;}"; s="${s//</&lt;}"; s="${s//>/&gt;}"
  printf '%s' "$s"
}

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  if [[ "$line" != *'  '* ]]; then
    # Section heading
    printf "<span size='8.5pt' weight='bold' letter_spacing='1200' foreground='#8f838b'>%s</span>\n" "$line"
  else
    keys="${line:0:22}"
    desc="${line:22}"
    printf "<span font_family='JetBrains Mono' size='10pt' foreground='#ffcfdf'>%s</span>  %s\n" \
      "$(escape "$keys")" "$(escape "$desc")"
  fi
done <<< "$shortcuts" | rofi -dmenu -i -no-show-icons -markup-rows -no-custom -selected-row 1 -p 'Shortcuts' \
  -theme "$HOME/.config/rofi/shortcuts.rasi" >/dev/null || true
