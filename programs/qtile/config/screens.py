import platform
import typing as t

from bars import LaptopBarGenerator, PCBarGenerator, StreamingBarGenerator
from common import CaptureCommand
from libqtile.config import Screen

# from libqtile.log_utils import logger

# Same as bars, screens need to be unique


class ScreenGenerator:
    def generate_main_screen(self) -> Screen:
        raise NotImplementedError

    def generate_other_screen(self) -> Screen:
        raise NotImplementedError


class LaptopScreenGenerator(ScreenGenerator):
    def __init__(self) -> None:
        # self.bar_generator = StreamingBarGenerator()
        self.bar_generator = LaptopBarGenerator()

    def generate_main_screen(self) -> Screen:
        return Screen(bottom=self.bar_generator.generate_bottom_bar(True))

    def generate_other_screen(self) -> Screen:
        return Screen(bottom=self.bar_generator.generate_bottom_bar(False))


class PCScreenGenerator(ScreenGenerator):
    def __init__(self) -> None:
        self.bar_generator = PCBarGenerator()

    def generate_main_screen(self) -> Screen:
        return Screen(bottom=self.bar_generator.generate_bottom_bar(True))

    def generate_other_screen(self) -> Screen:
        return Screen(bottom=self.bar_generator.generate_bottom_bar(False))


def get_all_screens() -> t.List[Screen]:
    uname = platform.uname()
    hostname = uname.node

    screen_generator: ScreenGenerator
    if "pc" in hostname:
        screen_generator = PCScreenGenerator()
    elif "laptop" in hostname:
        screen_generator = LaptopScreenGenerator()
    elif "thinkpad" in hostname:
        screen_generator = LaptopScreenGenerator()
    else:
        # Final base case, in case running on some other machines
        screen_generator = PCScreenGenerator()

    # randr_screen_command = CaptureCommand()
    # randr_screen_command.run(["xrandr --listactivemonitors | head -n1 | awk '{print $2}'"])

    # output = randr_screen_command.get_stdout_str()
    # number_of_screens = int(output)

    # Hard coded to try wayland for now
    number_of_screens = 1
    screens = [
        *[screen_generator.generate_main_screen()],
        *[screen_generator.generate_other_screen() for _ in range(number_of_screens - 1)],
    ]
    return screens
