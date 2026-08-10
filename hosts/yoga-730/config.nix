{ config, pkgs, ... }:
{
  # For stuff I want to config just for the machine
  environment.systemPackages = with pkgs; [
    # See if I can use it as a remote photo editing server
    darktable
    # display
    arandr
    # Browsers - Using sync to maintain the different profiles
    firefox
    google-chrome

    keepassxc
    syncthing
  ];


}
