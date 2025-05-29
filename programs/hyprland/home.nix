{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "LALT";
  };
}
