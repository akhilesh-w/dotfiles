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
((${#wallpapers[@]} > 0)) || exit 0

current="$(head -n 1 "$state_file" 2>/dev/null || true)"
next="${wallpapers[0]}"
for i in "${!wallpapers[@]}"; do
  if [[ "${wallpapers[$i]}" == "$current" ]]; then
    next="${wallpapers[$(((i + 1) % ${#wallpapers[@]}))]}"
    break
  fi
done

awww img "$next" --transition-type outer --transition-duration 0.85 --transition-fps 60 --transition-bezier '.18,.84,.26,1'
printf '%s\n' "$next" > "$state_file"
notify-send 'Wallpaper changed' "$(basename "$next")"
