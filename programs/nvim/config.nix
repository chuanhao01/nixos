{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
  ];
  # nvim
  environment.variables.EDITOR = "nvim";
}
