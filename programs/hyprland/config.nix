{ config, pkgs, ... }:
{
  # Hyprland
  programs.hyprland.enable = true;

  environment.sessionVariables = {
    # WLR_BACKENDS = "headless";
    NIXOS_OZONE_WL = "1"; # Hint Electron apps natively use Wayland
  };

  environment.systemPackages = with pkgs; [
    wayvnc
    wl-clipboard
  ];


}
