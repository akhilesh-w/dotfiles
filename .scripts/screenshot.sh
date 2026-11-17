#!/usr/bin/env bash
# Print: select an area. Shift+Print (or "full" argument): whole screen.
# The image is saved to ~/Pictures/Screenshots and copied to the clipboard.
set -euo pipefail

dir="${HOME}/Pictures/Screenshots"
mkdir -p "$dir"
file="${dir}/screenshot_$(date +'%Y%m%d_%H%M%S').png"

if [[ "${1:-}" == full ]]; then
  grim "$file"
else
  geometry="$(slurp)" || exit 0
  grim -g "$geometry" "$file"
fi

wl-copy --type image/png < "$file"
notify-send -a 'Screenshot' -i "$file" 'Screenshot copied' "Saved to Pictures/Screenshots/$(basename "$file")"
