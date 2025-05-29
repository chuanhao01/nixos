{ config, pkgs, ... }:
{
  # You need to the users default shell yourself
  # This only configures the shell
  programs.zsh.enable = true;

  # fzf and ripgrep
  environment.systemPackages = with pkgs; [
    fzf
    ripgrep
  ];
}
