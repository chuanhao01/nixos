{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vifm
  ];
}
