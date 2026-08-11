{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
  ];
  fonts = {
    enableDefaultPackages = true; # Includes some common fonts
  };

}
