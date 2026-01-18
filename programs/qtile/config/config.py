# chuanhao01, qtile config
# Mostly split into their own files

from typing import List

from constants import MOD_KEY, WIDGET_DEFEAULTS
from groups import all_groups, room_keys, workspace_keys
from keys import hotkeys
from layouts import all_layouts
from libqtile import layout
from libqtile.config import Click, Drag, Match
from libqtile.lazy import lazy
from screens import get_all_screens

keys = [*hotkeys, *workspace_keys, *room_keys]
groups = all_groups
layouts = all_layouts

extension_defaults = WIDGET_DEFEAULTS.copy()
screens = get_all_screens()

# Drag floating layouts.
mouse = [
    Drag(  # type: ignore
        [MOD_KEY],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag([MOD_KEY], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),  # type: ignore
    Click([MOD_KEY], "Button2", lazy.window.bring_to_front()),
]

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)

# pylint: disable=invalid-name
dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
