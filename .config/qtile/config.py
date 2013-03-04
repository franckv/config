from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
import os

dmenucmd = "dmenu_run -b -fn '-*-profont-*-*-*-*-11-*-*-*-*-*-*-*' -nb '#111111' -nf '#eeeeee' -sb '#6666ff' -sf '#ffffff'"

mod = 'mod4'

keys = [
    # Switch between windows in current stack pane
    Key(
        [mod], "k",
        lazy.layout.down()
    ),
    Key(
        [mod], "j",
        lazy.layout.up()
    ),

    # Move windows up or down in current stack
    Key(
        [mod, "control"], "k",
        lazy.layout.shuffle_down()
    ),
    Key(
        [mod, "control"], "j",
        lazy.layout.shuffle_up()
    ),

    # Switch window focus to other pane(s) of stack
    Key(
        [mod], "space",
        lazy.layout.next()
    ),

    # Swap panes of split stack
    Key(
        [mod, "shift"], "space",
        lazy.layout.rotate()
    ),

    Key([mod, "shift"], "t", lazy.window.toggle_floating()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with multiple stack panes
    Key(
        [mod, "shift"], "Return",
        lazy.layout.toggle_split()
    ),
    Key([mod], "h",      lazy.layout.previous()),
    Key([mod], "l",      lazy.layout.next()),

    Key([mod, "shift"], "h",      lazy.layout.decrease_ratio()),
    Key([mod, "shift"], "l",      lazy.layout.increase_ratio()),

    Key([mod], "Return", lazy.spawn("urxvt")),

    Key([mod], "p", lazy.spawn(dmenucmd)),

    # Toggle between different layouts as defined below
    Key([mod], "Tab",    lazy.nextlayout()),

    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "z", lazy.shutdown()),
    Key([mod, "shift"], "c", lazy.window.kill()),

    Key([mod], "Left",      lazy.group.prevgroup()),
    Key([mod], "Right",      lazy.group.nextgroup()),

    Key([mod], "r", lazy.spawncmd()),
    Key([mod], "g", lazy.switchgroup()),

    Key([mod, "shift"], "i", lazy.spawn("firefox")),
    Key([mod, "shift"], "p", lazy.spawn("dbus-launch pcmanfm")),

    Key(
        [], "XF86AudioRaiseVolume",
        lazy.spawn("amixer sset Master 5%+")
    ),
    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn("amixer sset Master 5%-")
    ),
    Key(
        [], "XF86AudioMute",
        lazy.spawn("amixer sset Master toggle")
    ),

    Key(["mod1", "control"], "l", lazy.spawn("xlock -mode blank")),
]

mouse = [
    Drag(["mod1"], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag(["mod1"], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click(["mod1"], "Button2", lazy.window.bring_to_front())
]

groups = [
    Group("q"),
    Group("s"),
    Group("d"),
    Group("f"),
]
for i in groups:
    # mod1 + letter of group = switch to group
    keys.append(
        Key([mod], i.name, lazy.group[i.name].toscreen())
    )

    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name))
    )

dgroups_key_binder = None

layouts = [
    layout.Max(),
    layout.Stack(stacks=2),
    layout.Tile(ratio=0.25),
]

style = {'fontsize': 12}

screens = [
    Screen(
        bottom = bar.Bar(
                    [
                        widget.GroupBox(**style),
                        widget.sep.Sep(**style),
                        widget.WindowName(**style),
                        widget.Prompt(**style),
                        widget.sep.Sep(**style),
                        widget.CurrentLayout(**style),
                        widget.Systray(**style),
                        widget.BatteryIcon(**style),
                        widget.Battery(**style),
                        widget.Clock('%Y-%m-%d %a %H:%M', **style),
                    ],
                    27,
                    font='Terminus',
                ),
    ),
    Screen(
        bottom = bar.Bar(
                    [
                        widget.GroupBox(**style),
                        widget.WindowName(**style),
                    ],
                    27,
                    font='Terminus',
                ),
    ),
]

@hook.subscribe.client_new
def dialogs(window):
    if(window.window.get_wm_type() == 'dialog'
        or window.window.get_wm_transient_for()):
        window.floating = True

@hook.subscribe.startup
def runner():
    import subprocess
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
        qtile.cmd_restart()

main = None
follow_mouse_focus = True
cursor_warp = False
floating_layout = layout.Floating()
#mouse = ()
auto_fullscreen = True
widget_defaults = {}
