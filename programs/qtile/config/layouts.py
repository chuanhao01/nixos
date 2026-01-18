from libqtile import layout

all_layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),  # type: ignore
    layout.Max(),  # type: ignore
]
