local home = os.getenv("HOME")
local mod = "SUPER"

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
hl.env("QT_QPA_PLATFORM", "wayland;xcb")

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland.service xdg-desktop-portal.service")
    hl.exec_cmd("waybar")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("systemctl --user restart dunst.service")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("swaybg -c '#080808'")
end)

hl.config({
    input = {
        kb_layout = "br",
        kb_model = "thinkpad",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
            tap_to_click = true,
            disable_while_typing = true,
        },
    },
    general = {
        gaps_in = 3,
        gaps_out = 7,
        border_size = 1,
        col = {
            active_border = "rgb(48484E)",
            inactive_border = "rgb(101012)",
        },
        layout = "dwindle",
        resize_on_border = true,
    },
    decoration = {
        rounding = 6,
        shadow = { enabled = true, range = 8, render_power = 2, color = "rgba(00000055)" },
        blur = { enabled = true, size = 6, passes = 2 },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true },
    misc = { disable_hyprland_logo = true, disable_splash_rendering = true },
})

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "default" })

hl.bind(mod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("alacritty -e " .. home .. "/.local/bin/file-picker"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd(home .. "/.local/bin/clipboard-menu"))
hl.bind(mod .. " + A", hl.dsp.exec_cmd(home .. "/.local/bin/audio-menu"))
hl.bind(mod .. " + F1", hl.dsp.exec_cmd(home .. "/.local/bin/shortcut-center"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("dunstctl close"))
hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("dunstctl history-pop"))
hl.bind(mod .. " + CTRL + N", hl.dsp.exec_cmd("dunstctl action"))
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + SHIFT + J", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd(home .. "/.local/bin/lockscreen"))
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd(home .. "/.local/bin/power-menu"))

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + Left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + Down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(home .. "/.local/bin/volume-control up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(home .. "/.local/bin/volume-control down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(home .. "/.local/bin/volume-control mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(home .. "/.local/bin/brightness-control up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(home .. "/.local/bin/brightness-control down"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("env QT_QPA_PLATFORM=wayland XDG_CURRENT_DESKTOP=Hyprland flameshot screen --number 0 --edit"))

for workspace = 1, 10 do
    local key = workspace % 10
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
