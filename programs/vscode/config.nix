{ config, pkgs, ... }:
{
  # To allow microsoft extensions to be downloaded
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # vscode
    source-code-pro
    # terminal
    meslo-lgs-nf
  ];
}
