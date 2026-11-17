#!/usr/bin/env bash
set -euo pipefail

state_dir="$HOME/.config/awww"
state_file="$state_dir/current-wallpaper"
legacy_config="$HOME/.config/hypr/hyprpaper.conf"
mkdir -p "$state_dir"

# Migrate the old hyprpaper selection once, so the current wallpaper survives.
if [[ ! -s "$state_file" && -f "$legacy_config" ]]; then
  python3 - "$legacy_config" > "$state_file" <<'PY'
import re
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text()
match = re.search(r'(?m)^\s*path\s*=\s*["\']?([^"\'\n]+)', text)
if match:
    print(Path(match.group(1)).expanduser())
PY
fi

wallpaper="$(head -n 1 "$state_file" 2>/dev/null || true)"
[[ -f "$wallpaper" ]] || wallpaper="$HOME/.local/share/backgrounds/tubes-d.png"
[[ -f "$wallpaper" ]] || exit 0

if ! awww query >/dev/null 2>&1; then
  awww-daemon --quiet >/dev/null 2>&1 &
  for _ in {1..30}; do
    awww query >/dev/null 2>&1 && break
    sleep 0.1
  done
fi

awww img "$wallpaper" --transition-type none
