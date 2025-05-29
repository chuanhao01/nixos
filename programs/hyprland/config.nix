{ config, pkgs, ... }:
{
  # Hyprland
  programs.hyprland.enable = true;
  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
