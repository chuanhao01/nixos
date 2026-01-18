{ config, pkgs, ... }:
{
  xdg.configFile."qtile" = {
    source = ./config;
    recursive = true;
  };
}
