{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vifm
    wget
    git
    docker
    docker-compose
    tmux
    gnumake
    kitty
    udisks
  ];
  environment.variables.EDITOR = "vim";
  virtualisation.containers.enable = true;
  virtualisation = {
    docker = {
      enable = true;
    };
  };

  # Hyprland
  programs.hyprland.enable = true;
  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # udisks
  services.udisks2.enable = true;
}

