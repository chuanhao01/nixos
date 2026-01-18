import json
import shlex
import typing as t
from datetime import datetime
from pathlib import Path

from common import CaptureCommand, Command
from constants import ALT_KEY, MOD_KEY, TERMINAL
from libqtile.config import Key
from libqtile.core.manager import Qtile
from libqtile.lazy import lazy
from libqtile.log_utils import logger

HOME_PATH_STR = Path("~/").expanduser().as_posix()

# Helper commands
def run_commands(commands: t.List[str]) -> None:
    shell_command = Command({"shell": True})
    for command in commands:
        shell_command.run([command])


@lazy.function
def spawn_chrome(qtile: Qtile):  # type: ignore
    filter_profiles = ["System Profile"]
    try:
        google_chrome_config_path = Path("~/.config/google-chrome").expanduser().resolve()

        options = []
        for preferences_path in google_chrome_config_path.rglob("Preferences"):
            profile_name = preferences_path.parent.name
            if profile_name in filter_profiles:
                continue
            with open(preferences_path, "r", encoding="utf-8") as preferences_file:
                preferences: t.Dict = json.loads(preferences_file.read())
            account_info = preferences.get("account_info")
            account = account_info[0] if account_info else None
            email = account.get("email") if account else None
            description = email if email else preferences["profile"]["name"]
            options.append(f"{profile_name}({description})")

        dmenu_preference_str = shlex.quote("\n".join(options))
        dmenu_command = CaptureCommand()
        dmenu_command.run(
            [f"echo {dmenu_preference_str} | rofi -dmenu -only-match -p 'Google Chrome'"]
        )
        if not dmenu_command.check_successful():
            logger.info("No Chrome selected")
            return
        dmenu_output = dmenu_command.get_stdout_str()
        selected_profile = dmenu_output.split("(")[0]

        qtile.cmd_spawn(f"google-chrome-stable --profile-directory={shlex.quote(selected_profile)}")

    except Exception as err:
        logger.warning("spawn_chrome_failed|err=%s", err)


@lazy.function()
def hotkey_screenshot(_: Qtile):  # type: ignore
    dt_str = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
    sc_path_str = Path(f"~/Pictures/Screenshots/{dt_str}.png").expanduser().as_posix()
    run_commands([f"import {sc_path_str}; xclip -sel clip -t image/png {sc_path_str}"])


hotkeys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([MOD_KEY], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([MOD_KEY], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([MOD_KEY], "j", lazy.layout.down(), desc="Move focus down"),
    Key([MOD_KEY], "k", lazy.layout.up(), desc="Move focus up"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([MOD_KEY, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key(
        [MOD_KEY, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([MOD_KEY, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD_KEY, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([MOD_KEY, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([MOD_KEY, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([MOD_KEY, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([MOD_KEY, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([MOD_KEY, "control"], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [MOD_KEY, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Toggle between different layouts as defined below
    Key([MOD_KEY], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    # Screen hotkeys
    Key([MOD_KEY, ALT_KEY], "n", lazy.next_screen()),
    Key([MOD_KEY, ALT_KEY], "p", lazy.prev_screen()),
    # Launch hotkeys
    Key([MOD_KEY], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),
    Key([MOD_KEY], "space", lazy.spawn("rofi -show drun"), desc="Rofi drun"),
    Key([MOD_KEY], "a", lazy.window.kill(), desc="Kill focused window"),
    Key([MOD_KEY], "u", lazy.window.disable_floating(), desc="Tile back the window"),
    # Applications
    Key([MOD_KEY], "g", spawn_chrome()),  # pylint: disable=no-value-for-parameter
    # Hotkeys
    Key([MOD_KEY], "s", hotkey_screenshot()),  # pylint: disable=no-value-for-parameter
    Key(
        [MOD_KEY, ALT_KEY],
        "l",
        lazy.spawn(f"{HOME_PATH_STR}/.bin/screen-locker.sh"),
        desc="Lock Screen",
    ),
    # Qtile hotkeys
    Key([MOD_KEY, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD_KEY, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
]
