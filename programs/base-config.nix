# Base programs to install for any system
# Includes simple configs for common tools like git, neovim...
# Also installs commonly used utils like wget, gnumake, udisks...
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    gnumake
    udisks
    htop
    rclone
    nmap

    # To have the nixfmt utility
    nixfmt-rfc-style
  ];
  # udisks
  services.udisks2.enable = true;
}
