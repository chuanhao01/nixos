{ config, pkgs, ... }:
{
  # To allow microsoft extensions to be downloaded
  nixpkgs.config.allowUnfree = true;
}
