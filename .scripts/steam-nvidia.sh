#!/usr/bin/env bash
# Make every installed Steam game run on the NVIDIA GPU by adding
# "prime-run %command%" to its launch options. Run again after installing
# new games (also in quick actions). Steam has to be closed while its config
# is edited, so this quits Steam and starts it again afterwards.
#
# prime-run is the wrapper in ~/.scripts/bin: it turns the NVIDIA GPU on if
# needed and lets the game see it. Existing launch options are kept.
set -euo pipefail

steam_root="$HOME/.local/share/Steam"
notify() { notify-send -a 'Steam' -i steam "$@" 2>/dev/null || true; }

was_running=0
if pgrep -x steam >/dev/null; then
  was_running=1
  notify 'Restarting Steam' 'Setting all games to use the NVIDIA GPU.'
  steam -shutdown >/dev/null 2>&1 || true
  for _ in $(seq 1 60); do pgrep -x steam >/dev/null || break; sleep 0.5; done
  if pgrep -x steam >/dev/null; then
    notify -u critical 'Steam did not quit' 'Close Steam and run this again.'
    exit 1
  fi
fi

changed="$(python3 - "$steam_root" <<'PY'
import glob, os, re, sys

root = sys.argv[1]
SKIP = re.compile(r"^(Proton|Steam Linux Runtime|Steamworks Common)", re.I)

# Installed games from the library manifests (all library folders).
games = {}
libs = {os.path.join(root, "steamapps")}
lf = os.path.join(root, "steamapps", "libraryfolders.vdf")
if os.path.exists(lf):
    for path in re.findall(r'"path"\s+"([^"]+)"', open(lf, encoding="utf-8").read()):
        libs.add(os.path.join(path.replace("\\\\", "\\"), "steamapps"))
for lib in libs:
    for m in glob.glob(os.path.join(lib, "appmanifest_*.acf")):
        text = open(m, encoding="utf-8", errors="replace").read()
        appid = re.search(r'"appid"\s+"(\d+)"', text)
        name = re.search(r'"name"\s+"([^"]*)"', text)
        if appid and name and not SKIP.match(name.group(1)):
            games[appid.group(1)] = name.group(1)

# Minimal VDF (KeyValues text) parser/writer that keeps key order.
def tokens(s):
    i, n = 0, len(s)
    while i < n:
        c = s[i]
        if c.isspace():
            i += 1
        elif c == "/" and s.startswith("//", i):
            i = s.find("\n", i) if s.find("\n", i) != -1 else n
        elif c in "{}":
            yield c; i += 1
        elif c == '"':
            j, out = i + 1, []
            while j < n and s[j] != '"':
                if s[j] == "\\" and j + 1 < n:
                    out.append(s[j:j + 2]); j += 2
                else:
                    out.append(s[j]); j += 1
            yield ("str", "".join(out)); i = j + 1
        else:
            j = i
            while j < n and not s[j].isspace() and s[j] not in '{}"':
                j += 1
            yield ("str", s[i:j]); i = j

def parse(it):
    d = []
    for t in it:
        if t == "}":
            return d
        key = t[1]
        v = next(it)
        d.append([key, parse(it) if v == "{" else v[1]])
    return d

def dump(d, depth=0):
    out, tab = [], "\t" * depth
    for k, v in d:
        if isinstance(v, list):
            out.append(f'{tab}"{k}"\n{tab}{{\n{dump(v, depth + 1)}{tab}}}\n')
        else:
            out.append(f'{tab}"{k}"\t\t"{v}"\n')
    return "".join(out)

def child(d, key, create=True):
    for kv in d:
        if kv[0].lower() == key.lower():
            return kv[1]
    if not create:
        return None
    new = []
    d.append([key, new])
    return new

def get(d, key):
    for kv in d:
        if kv[0].lower() == key.lower():
            return kv
    return None

report = []
for cfg in glob.glob(os.path.join(root, "userdata", "*", "config", "localconfig.vdf")):
    data = parse(iter(tokens(open(cfg, encoding="utf-8", errors="replace").read())))
    apps = child(child(child(child(child(data, "UserLocalConfigStore"), "Software"), "Valve"), "Steam"), "apps")
    edited = False
    for appid, name in sorted(games.items()):
        app = child(apps, appid)
        kv = get(app, "LaunchOptions")
        current = kv[1] if kv else ""
        if "prime-run" in current:
            continue
        if "%command%" in current:
            new = current.replace("%command%", "prime-run %command%", 1)
        elif current.strip():
            new = f"prime-run %command% {current.strip()}"
        else:
            new = "prime-run %command%"
        if kv:
            kv[1] = new
        else:
            app.append(["LaunchOptions", new])
        report.append(name)
        edited = True
    if edited:
        os.replace(cfg, cfg + ".bak-before-prime-run") if not os.path.exists(cfg + ".bak-before-prime-run") else None
        with open(cfg, "w", encoding="utf-8") as f:
            f.write(dump(data))
print(", ".join(report))
PY
)"

if ((was_running)); then
  # Start Steam from Hyprland so it gets the normal desktop environment.
  hyprctl dispatch 'hl.dsp.exec_cmd("steam -silent")' >/dev/null 2>&1 || (steam -silent >/dev/null 2>&1 & disown)
fi

if [[ -n "$changed" ]]; then
  notify 'Steam games set to NVIDIA' "$changed"
  echo "Set to NVIDIA: $changed"
else
  notify 'Steam games already use NVIDIA' 'Nothing to change.'
  echo 'All installed games already use prime-run.'
fi
