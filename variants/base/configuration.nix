# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../programs/default.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chuanhao01 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    # read from /etc that is symlinked, so no issues
    #hashedPasswordFile = toString ../../users/chuanhao01/chuanhao01.passwd;
    hashedPasswordFile = "/etc/nixos/users/chuanhao01/chuanhao01.passwd";
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    tailscale
  ];
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  nix.settings.auto-optimise-store = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

