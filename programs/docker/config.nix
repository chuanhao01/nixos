# Installs docker and docker-compose
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
  virtualisation.containers.enable = true;
  virtualisation = {
    docker = {
      enable = true;
    };
  };

  users.users.chuanhao01.extraGroups = [ "docker" ]; # Enable ‘sudo’ for the user.
}
