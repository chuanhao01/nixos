{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tailscale
  ];
  # tailscale
  services.tailscale.enable = true;
}
