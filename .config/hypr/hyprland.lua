-- Port of the old hyprland.conf.
-- Hyprland 0.57+ only reads this Lua config, not hyprland.conf.

local terminal = "kitty"
local fileManager = "dolphin"
local menu = "pkill -x rofi || rofi -show drun"

------------------
---- MONITORS ----
------------------

-- Laptop panel.
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@120",
    position = "0x0",
    scale    = 1,
})

-- Anything else plugged in (external monitor, projector): use its own best
-- mode and place it to the right of the laptop screen.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    -- nm-applet removed: Waybar now has its own Wi-Fi icon and menu.
    hl.exec_cmd("waybar")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("systemctl --user start hypridle")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("~/.scripts/wallpaper-init.sh")
    hl.exec_cmd("systemctl --user start dunst")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("systemctl --user start voxtype")
    hl.exec_cmd("tailscale systray --theme light:nobg")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_THEME", "Adwaita:dark")
-- Draw the desktop with the AMD GPU only (it drives the laptop screen and HDMI).
-- If Hyprland also opened the NVIDIA card it could never sleep. Apps still use
-- the NVIDIA GPU on request with prime-run (Super+Shift+D, or Steam launch
-- options "prime-run %command%"). /dev/dri/amd-igpu comes from
-- /etc/udev/rules.d/82-amd-igpu.rules; skip the setting if it is missing so
-- Hyprland can never fail to start because of it.
do
    local igpu = io.open("/dev/dri/amd-igpu", "r")
    if igpu then
        igpu:close()
        hl.env("AQ_DRM_DEVICES", "/dev/dri/amd-igpu")
    end
end

-- ~/.scripts/bin first, so launcher, Steam and keybinds get the prime-run
-- wrapper that also makes NVIDIA the only Vulkan device.
do
    local bin = os.getenv("HOME") .. "/.scripts/bin"
    local path = os.getenv("PATH") or "/usr/local/bin:/usr/bin"
    -- Only prepend once; a config reload would otherwise add it again.
    if not (":" .. path .. ":"):find(":" .. bin .. ":", 1, true) then
        hl.env("PATH", bin .. ":" .. path)
    end
end

-- Qt apps (Dolphin etc.) use qt6ct: Fusion style, dark palette, Breeze Dark icons.
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 3,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgba(771a4fee)", "rgba(ffcfdfee)" }, angle = 45 },
            inactive_border = "rgba(695960aa)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 5,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },

    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })

-- Old gestures { workspace_swipe = true }
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("~/.scripts/exit-hyprland.sh"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
-- Same launcher, but the chosen app runs on the NVIDIA GPU.
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("pkill -x rofi || rofi -show drun -display-drun 'NVIDIA' -run-command 'prime-run {cmd}'"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.scripts/control-center.sh"))
hl.bind(mainMod .. " + SHIFT + SLASH", hl.dsp.exec_cmd("~/.scripts/shortcuts.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.scripts/wallpaper-next.sh"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind("Print", hl.dsp.exec_cmd("~/.scripts/screenshot.sh"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.scripts/screenshot.sh full"))
hl.bind(mainMod .. " + CTRL + V", hl.dsp.exec_cmd("~/.scripts/clipboard-menu.sh"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("dunstctl history-pop"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("dunstctl close-all"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("F9", hl.dsp.exec_cmd("voxtype record start"))
hl.bind("F9", hl.dsp.exec_cmd("voxtype record stop"), { release = true })
hl.bind(mainMod .. " + CTRL + X", hl.dsp.exec_cmd("voxtype record toggle"))
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("brave"))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
local function cycle_apps(step)
    return function()
        local wins = {}
        for _, w in ipairs(hl.get_windows() or {}) do
            if w.mapped and not w.hidden then
                wins[#wins + 1] = w
            end
        end
        if #wins == 0 then return end

        table.sort(wins, function(a, b)
            local wa = (a.workspace and a.workspace.id) or 0
            local wb = (b.workspace and b.workspace.id) or 0
            if wa ~= wb then return wa < wb end
            return (a.focus_history_id or 0) < (b.focus_history_id or 0)
        end)

        local current = hl.get_active_window()
        local idx = 1
        if current then
            for i, w in ipairs(wins) do
                if w.address == current.address then
                    idx = i
                    break
                end
            end
        end

        local target = wins[((idx - 1 + step) % #wins) + 1]
        if target.workspace then
            hl.dispatch(hl.dsp.focus({ workspace = target.workspace.id }))
        end
        hl.dispatch(hl.dsp.focus({ window = target }))
    end
end

hl.bind("ALT + Tab", cycle_apps(1))
hl.bind("ALT + SHIFT + Tab", cycle_apps(-1))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + CTRL + ALT + Right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + ALT + Left",  hl.dsp.window.move({ workspace = "r-1" }))

hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.resize({ x = 30,  y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.resize({ x = -30, y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true })

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + Z", hl.dsp.window.drag(),   { drag = true })
hl.bind(mainMod .. " + X", hl.dsp.window.resize(), { drag = true })

hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"),       { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- swayosd changes the value and shows the on-screen pop-up in one step.
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness +5"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -5"), { repeating = true, locked = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"), { repeating = true, locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Frosted glass behind Rofi menus and the volume/brightness pop-up.
-- ignore_alpha keeps the blur inside their rounded corners.
hl.layer_rule({
    name = "blur-rofi",
    match = { namespace = "^rofi$" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "blur-notifications",
    match = { namespace = "^notifications$" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "blur-swayosd",
    match = { namespace = "^swayosd$" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})
