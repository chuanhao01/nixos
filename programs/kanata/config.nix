{ config, pkgs, ... }:
{
  services.kanata = {
    enable = true;
    keyboards.all-keyboards.configFile = ./kanata.kbd;
  };
}
