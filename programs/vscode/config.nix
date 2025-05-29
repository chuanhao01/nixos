{ config, pkgs, ... }:
{
  # https://nixos.wiki/wiki/Visual_Studio_Code#Remote_SSH
  # For vscode-server
  programs.nix-ld.enable = true;
}
