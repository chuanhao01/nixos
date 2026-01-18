# Concept of workspace and rooms
# Idea built upon a13xmt work in https://github.com/qtile/qtile-examples/

# Workspaces contains a set of rooms
# Depending on the active workspace, the rooms you have will be different
# By switching workspaces, you can access a different set of rooms with the SAME hotkeys

# Changing Workspace
# I.e. room 1 in workspace q -> room 1 in workspace w
# Changing Rooms
# I.e. room 1 in workspace q -> room 2 in workspace q
from __future__ import annotations

import typing as t

from common import CaptureCommand, HotkeyConfig
from constants import MOD_KEY, ROOMS_CONFIGS, WORKSPACES_CONFIGS
from libqtile.lazy import lazy
from libqtile.config import Group, Key
from libqtile.core.manager import Qtile

# from libqtile import qtile as global_qtile
# from libqtile.log_utils import logger
from utils.cycle import Cycle


class GroupsController:
    def __init__(
        self, workspace_configs: t.List[HotkeyConfig], room_configs: t.List[HotkeyConfig]
    ) -> None:
        self.workspace_configs = workspace_configs
        self.room_configs = room_configs

        self.xrandr_screens = self.__get_xrandr_screens()

        self.screen_active_workspace: t.Dict[int, Workspace]
        self.workspaces_rooms: t.List[t.List[Room]]
        self.workspaces: t.Dict[int, t.Dict[str, Workspace]]

        self.__create_workspaces()
        self.__init_active_workspace()

    @staticmethod
    def __get_xrandr_screens() -> int:
        # Hard Code for now since I am trying to run this on wayland
        return 1

        xrandr_command = CaptureCommand()
        xrandr_command.run(["xrandr --listactivemonitors | head -n1 | awk '{print $2}'"])
        screens = int(xrandr_command.get_stdout_str())
        screens = screens if screens > 0 else 1
        return screens


    def __create_workspaces(self) -> None:
        workspaces_rooms = []
        for workspace_config in self.workspace_configs:
            rooms = []
            for room_config in self.room_configs:
                group = Group(f"{room_config.value}{workspace_config.value}")
                # logger.debug("workspace.value=%s", workspace_config.value)
                # logger.debug("room.value=%s", room_config.value)
                # logger.debug("group.name=%s", group.name)
                room = Room(room_config.value, room_config.hotkey, group)
                rooms.append(room)
            workspaces_rooms.append(rooms)
        self.workspaces_rooms = workspaces_rooms

        all_workspaces = {}
        for screen_index in range(self.xrandr_screens):
            workspaces = {}
            for workspace_config, workspace_rooms in zip(self.workspace_configs, workspaces_rooms):
                workspace = Workspace(workspace_config.value, workspace_config.hotkey)
                for room in workspace_rooms:
                    workspace.add_room(room)
                workspace.init_active_room()
                workspaces[workspace_config.value] = workspace
            all_workspaces[screen_index] = workspaces
        self.workspaces = all_workspaces

    def __init_active_workspace(self) -> None:
        """
        Just use the first workspace
        """
        self.screen_active_workspace = {}
        for screen_index in range(self.xrandr_screens):
            default_workspace = list(self.workspaces[screen_index].keys())[0]
            self.set_active_workspace(screen_index, default_workspace)

    def set_active_workspace(self, screen_index: int, value: str) -> Workspace:
        self.screen_active_workspace[screen_index] = self.get_workspace(screen_index, value)
        return self.screen_active_workspace[screen_index]

    def get_active_workspace(self, screen_index: int) -> Workspace:
        return self.screen_active_workspace[screen_index]

    def get_workspace(self, screen_index: int, value: str) -> Workspace:
        return self.workspaces[screen_index][value]

    def get_all_groups(self) -> t.List[Group]:
        groups = []
        for workspace_rooms in self.workspaces_rooms:
            for room in workspace_rooms:
                groups.append(room.group)
        return groups

    def get_workspace_keys(self) -> t.List[Key]:
        @lazy.function
        def to_workspace(qtile: Qtile, value: str):  # type: ignore
            workspace = self.set_active_workspace(qtile.current_screen.index, value)
            room = workspace.get_active_room()

            qtile.groups_map[room.group.name].cmd_toscreen(toggle=False)  # type: ignore

            # A hacky workaround for multiple same widgets
            # Use the index of the screen as the suffix of the widget name
            # Should follow the order of xrandr?
            # Have not tested with plugging in monitor
            screen_index = qtile.current_screen.index
            groupbox_widget_name = "groupbox" if screen_index == 0 else f"groupbox_{screen_index}"
            groupbox_widget = qtile.widgets_map[groupbox_widget_name]
            groupbox_widget.visible_groups = [room.group.name for room in workspace.get_all_rooms()]  # type: ignore
            groupbox_widget.draw()  # type: ignore

        @lazy.function
        def window_to_workspace(qtile: Qtile, value: str):  # type: ignore
            workspace = self.get_workspace(qtile.current_screen.index, value)
            room = workspace.get_active_room()

            qtile.current_window.togroup(room.group.name)  # type: ignore

        keys = []
        for workspace_config in self.workspace_configs:
            keys.append(
                Key(
                    [MOD_KEY],
                    workspace_config.hotkey,
                    to_workspace(workspace_config.value),  # pylint: disable=no-value-for-parameter
                ),
            )
            keys.append(
                Key(
                    [MOD_KEY, "shift"],
                    workspace_config.hotkey,
                    window_to_workspace(  # pylint: disable=no-value-for-parameter
                        workspace_config.value
                    ),
                )
            )
        return keys

    def get_room_keys(self) -> t.List[Key]:
        def to_room(qtile: Qtile, value: str):  # type: ignore
            workspace = self.get_active_workspace(qtile.current_screen.index)
            room = workspace.set_active_room(value)

            qtile.groups_map[room.group.name].cmd_toscreen(toggle=False)  # type: ignore

        @lazy.function
        def to_next_room(qtile: Qtile):  # type: ignore
            workspace = self.get_active_workspace(qtile.current_screen.index)
            next_room = workspace.get_next_active_room_cycle()
            to_room(qtile, next_room)

        @lazy.function
        def to_prev_room(qtile: Qtile):  # type: ignore
            workspace = self.get_active_workspace(qtile.current_screen.index)
            prev_room = workspace.get_prev_active_room_cycle()
            to_room(qtile, prev_room)

        @lazy.function
        def window_to_room(qtile: Qtile, value: str):  # type: ignore
            workspace = self.get_active_workspace(qtile.current_screen.index)
            room = workspace.get_room(value)

            qtile.current_window.togroup(room.group.name)  # type: ignore

        keys = []
        for room_config in self.room_configs:
            keys.append(
                Key(
                    [MOD_KEY],
                    room_config.hotkey,
                    lazy.function(
                        to_room, room_config.value
                    ),  # pylint: disable=no-value-for-parameter
                )
            )
            keys.append(
                Key(
                    [MOD_KEY, "shift"],
                    room_config.hotkey,
                    window_to_room(room_config.value),  # pylint: disable=no-value-for-parameter
                )
            )
        keys.append(Key([MOD_KEY], "n", to_next_room()))  # pylint: disable=no-value-for-parameter
        keys.append(Key([MOD_KEY], "p", to_prev_room()))  # pylint: disable=no-value-for-parameter
        return keys


class Workspace:
    def __init__(self, value: str, hotkey: str) -> None:
        self.value = value
        self.hotkey = hotkey
        self.rooms: t.Dict[str, Room] = {}
        self.rooms_cycle = Cycle[str]()
        self.active_room: Room

    def add_room(self, room: Room) -> None:
        """
        TODO: Add checking for duplicates?
        Too lazy chuanhao01
        """
        self.rooms[room.value] = room
        self.rooms_cycle.add(room.value)

    def get_room(self, value: str) -> Room:
        """
        TODO: Same with add_room
        Also error handling
        """
        return self.rooms[value]

    def get_next_active_room_cycle(self) -> str:
        return self.rooms_cycle.get_next(self.active_room.value)

    def get_prev_active_room_cycle(self) -> str:
        return self.rooms_cycle.get_prev(self.active_room.value)

    def get_all_rooms(self) -> t.List[Room]:
        return list(self.rooms.values())

    def init_active_room(self) -> None:
        """
        Just grab the first value
        """
        self.set_active_room(list(self.rooms.keys())[0])

    def set_active_room(self, value: str) -> Room:
        """
        TODO: Same with add_room
        """
        self.active_room = self.get_room(value)
        return self.active_room

    def get_active_room(self) -> Room:
        return self.active_room


class Room:
    def __init__(self, value: str, hotkey: str, group: Group) -> None:
        self.value = value
        self.hotkey = hotkey
        self.group = group


groups_controller = GroupsController(WORKSPACES_CONFIGS, ROOMS_CONFIGS)

all_groups = groups_controller.get_all_groups()
workspace_keys = groups_controller.get_workspace_keys()
room_keys = groups_controller.get_room_keys()
