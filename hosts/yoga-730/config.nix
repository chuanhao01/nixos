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

    # Pipewire
    easyeffects
    pwvucontrol

    # Bluetooth
    # bluez # Bluetooth support
    # bluez-tools # Bluetooth tools
  ];

  # Audio
  security.rtkit.enable = true; # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # Bluetooth
  # hardware.bluetooth = {
  #   enable = true;
  #   powerOnBoot = true;
  # };
}
