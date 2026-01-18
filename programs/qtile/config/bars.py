from libqtile import widget
from libqtile.bar import Bar

# Each bar needs to be generated as the reference to the bar is unique
# So use generators instead


class BarGenerator:
    def generate_bottom_bar(self, have_systray: bool) -> Bar:
        raise NotImplementedError


class StreamingBarGenerator(BarGenerator):
    def generate_bottom_bar(self, _: bool) -> Bar:
        return Bar(  # type: ignore
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Spacer(),
                widget.TextBox("streaming setup", name="config_name"),
                widget.TextBox("Full", name="mock_battery"),
                widget.TextBox("1970-01-01 Thur 00:00", name="mock_datetime"),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        )

class LaptopBarGenerator(BarGenerator):
    def generate_bottom_bar(self, have_systray: bool) -> Bar:
        systray_widgets = [widget.Systray()] if have_systray else []
        return Bar(  # type: ignore
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.TextBox("chuanhao01 config", name="default"),
                widget.Battery(),
                widget.Clock(format="%Y-%m-%d %a %H:%M"),
                *systray_widgets,
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        )


class PCBarGenerator(BarGenerator):
    def generate_bottom_bar(self, have_systray: bool) -> Bar:
        systray_widgets = [widget.Systray()] if have_systray else []
        return Bar(  # type: ignore
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.TextBox("chuanhao01 config", name="default"),
                widget.Clock(format="%Y-%m-%d %a %H:%M"),
                *systray_widgets,
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        )
