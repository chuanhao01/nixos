{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    theme = ./custom.rasi;
  };
}
