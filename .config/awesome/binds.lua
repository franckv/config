require("lib/mpd")

local screen_cmd = "urxvt -e screen -RD"
local dmenucmd = "dmenu_run -b -fn '-*-profont-*-*-*-*-11-*-*-*-*-*-*-*' -nb '#111111' -nf '#eeeeee' -sb '#6666ff' -sf '#ffffff'"
local browser = "firefox"
local chat = "pidgin"
local audio_player = "sonata"
local ssaver = "xlock"
local vol_down = "amixer sset 'Master' 5%-"
local vol_up = "amixer sset 'Master' 5%+"
local vol_toggle = "amixer sset 'Master' toggle"
local sleep = "sudo pm-hibernate"
local suspend = "sudo pm-suspend"
local reboot = "sudo reboot"
local shutdown = "sudo poweroff"

globalkeys = awful.util.table.join(globalkeys,
    -- media keys
    awful.key({ },  "XF86AudioRaiseVolume", function () awful.util.spawn(vol_up) end),
    awful.key({ },  "XF86AudioLowerVolume", function () awful.util.spawn(vol_down) end),
    awful.key({ },  "XF86AudioMute", function () awful.util.spawn(vol_toggle) end),
    --awful.key({ },  "XF86Eject", function () awful.util.spawn("eject") end),
    awful.key({ },  "XF86AudioMedia", function () awful.util.spawn(audio_player) end),
    awful.key({ },  "XF86AudioPlay", function () mpd.toggle_play() end),
    awful.key({ },  "XF86HomePage", function () awful.util.spawn(browser) end),
    awful.key({ },  "XF86ScreenSaver", function () awful.util.spawn(ssaver) end),
    awful.key({ },  "XF86Sleep", function () awful.util.spawn(sleep) end),

    awful.key({ modkey },  "p", function () awful.util.spawn(dmenucmd) end),                                                                                 
    awful.key({ "Mod1" , "Control"}, "Escape", function () awful.util.spawn("xkill") end)
)
