#!/usr/bin/env bash
set -euo pipefail

wallpaper_dir="$HOME/Pictures/Wallpapers"
state_file="$HOME/.config/awww/current-wallpaper"
mkdir -p "$wallpaper_dir" "$(dirname "$state_file")"

mapfile -d '' wallpapers < <(
  find "$HOME/.local/share/backgrounds" "$wallpaper_dir" \
    -type d -name .git -prune -o \
    -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.gif' -o -iname '*.bmp' -o -iname '*.tiff' -o -iname '*.avif' \) \
    -print0 2>/dev/null | sort -z
)

if ((${#wallpapers[@]} == 0)); then
  notify-send 'Wallpaper picker' "Add PNG, JPG, or WebP images to $wallpaper_dir first."
  xdg-open "$wallpaper_dir"
  exit 0
fi

# Thumbnail grid. Rofi only loads the images that are on screen, so a large
# collection still opens quickly. Type to filter by file name.
current="$(head -n 1 "$state_file" 2>/dev/null || true)"
selected_row=0
index="$(
  for i in "${!wallpapers[@]}"; do
    path="${wallpapers[$i]}"
    name="$(basename "${path%.*}")"
    printf '%s\0icon\x1f%s\n' "$name" "$path"
  done | rofi -dmenu -i -show-icons -no-custom -format i -p 'Wallpaper' \
      -selected-row "$(for i in "${!wallpapers[@]}"; do [[ "${wallpapers[$i]}" == "$current" ]] && { echo "$i"; break; }; done || echo 0)" \
      -theme "$HOME/.config/rofi/wallpaper.rasi"
)" || exit 0

[[ "$index" =~ ^[0-9]+$ ]] || exit 0
selected="${wallpapers[$index]}"
[[ -f "$selected" ]] || exit 0

# Awww uses a smooth outside-in reveal at the display's native refresh rate.
awww img "$selected" --transition-type outer --transition-duration 0.85 --transition-fps 60 --transition-bezier '.18,.84,.26,1'
printf '%s\n' "$selected" > "$state_file"
notify-send 'Wallpaper changed' "$(basename "$selected")"
