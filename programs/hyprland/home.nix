{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "LALT";
    "monitor" = "HEADLESS-1, 1920x1080@60, 0x0, 1";
  };

}
